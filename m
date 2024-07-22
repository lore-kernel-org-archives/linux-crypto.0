Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE4D8BEA
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2024 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658136; cv=none; b=hf4JtmC8cB2d17iK1EINc98en8YFxaou0MDhNf+7WtTNmVqm8m7QU3StZShmOdlH/aN8L+xPR/+caZDIRcZ0ux1ADlApUMhTRyS+1rZcs1p2OwbXI0S/p9w81kRRpLyX+0rO9q+MkbWKaeiqVb3gi2fxiFKnecwZzJobahHVAOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658136; c=relaxed/simple;
	bh=/86MfWmQRKcJfmjDt9iktLWAZBTQWC9ifCVsFdqniNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HpHKZOHmTel+gDrCL7CYtZPVHxIOXWF6iSlh84q1IgPPSylC5RIUubmROWSg77RfE+K1WN4EFIDlZSlvAH+ho/EoBeRtm+mAly7uPDmGiSL6eyUO2YoKErB/nzuSZ+3KMHQUlRibHN6566YVBFIiv3YXTKhjsclNqprU2vBeZDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRHLR1QE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRHLR1QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFA9C4AF0E;
	Mon, 22 Jul 2024 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721658135;
	bh=/86MfWmQRKcJfmjDt9iktLWAZBTQWC9ifCVsFdqniNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRHLR1QExmwBjOTLBGYUit0X5xthmsotdXGxxUhnjw1+5QGw+BckdxxDyTpvWxj7D
	 EOHrnFySSW9tWx9W4CGPRPEEqgphj5ULc5GS4W9XZyzAgb+pOv8ZBrCQEVVz+7/EP6
	 S6xPgawwtUjbUy5/WczRRP73sJt0iFhNXYDAMr9gAmucHJaFdfln2ej+TmAatgKrjh
	 Ow+ytD/WqTZuQDdwevQGIKM5VIvH3MWIIsU4zDDn/d8fXci0kJ1cz82BzKNUWD1MwA
	 6zbQpamC/dH68a8qZu9IbmLg9v740eCXytFDMds19MbwTENZaUgBrS+sKShFO5py6S
	 qaXNPv9x+grrQ==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 7/9] nvme-fabrics: reset admin connection for secure concatenation
Date: Mon, 22 Jul 2024 16:21:20 +0200
Message-Id: <20240722142122.128258-8-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240722142122.128258-1-hare@kernel.org>
References: <20240722142122.128258-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When secure concatenation is requested the connection needs to be
reset to enable TLS encryption on the new cnnection.
That implies that the original connection used for the DH-CHAP
negotiation really shouldn't be used, and we should reset as soon
as the DH-CHAP negotiation has succeeded on the admin queue.

Based on an idea from Sagi.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/tcp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index b229c4402482..76c8e01d8f08 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2251,6 +2251,15 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 	if (ret)
 		return ret;
 
+	if (new && ctrl->opts && ctrl->opts->concat && !ctrl->tls_pskid) {
+		dev_dbg(ctrl->device, "restart admin queue for secure concatenation\n");
+		nvme_stop_keep_alive(ctrl);
+		nvme_tcp_teardown_admin_queue(ctrl, false);
+		ret = nvme_tcp_configure_admin_queue(ctrl, false);
+		if (ret)
+			return ret;
+	}
+
 	if (ctrl->icdoff) {
 		ret = -EOPNOTSUPP;
 		dev_err(ctrl->device, "icdoff is not supported!\n");
-- 
2.35.3

