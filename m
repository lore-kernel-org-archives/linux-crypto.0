Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C882233A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 11:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723547745; cv=none; b=Dz3Mv7IvARMDGO+EaCMHwMd66FMYHnN2MIi5JDgoMY+/+p3F8r/D4PDwhTLLH2wKI2K2A5B/KRnybBPSJhhTWxYY3QU3XYbDi04KaCwxogFJiPOWewmzcWTEBZqLlFFjfSe07zojRaV5kya7mRZBArPt65/Vw/j9mumYAyKhPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723547745; c=relaxed/simple;
	bh=/86MfWmQRKcJfmjDt9iktLWAZBTQWC9ifCVsFdqniNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HrROvTLYhJFFzvRquS6VpzoObXOI8hdYOePDaEv0u3GXcCZ7+Bh2a7o3fXbQkYUspQQmHbZ8UdwSpBWwADY97jCyuLCwuGIfk57m0uPqmjdNjcBU8/NRWsVjt0Kjy3YzbuWA9Ke6z5ATrDYRY3KFDRWFm96ov3fMx/LOJ6LT4ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3EOhzrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3EOhzrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45818C4AF09;
	Tue, 13 Aug 2024 11:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723547744;
	bh=/86MfWmQRKcJfmjDt9iktLWAZBTQWC9ifCVsFdqniNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3EOhzrFloUbjnGESoDCOqiwVXV9cNhUmg32h1L/jbEli58GrbC6SoVSWBfZKD5aS
	 uTrKywT9oXEu0RO3oWGHeTWfahE2xFEKSPLeVj/z/Hqi1/YMB7jB+KKnOpDkYFKU+e
	 bI0MnaJmqICmrTGJsu1m1WoTtSCwMCZ/BVfa6xMlWq3qMiinLfhv/vQxn7G2OQNJ2l
	 tWgLQIqboy0ZV+49LE9fwv7bqErpRCpePDbdAetZVcJfxHnewFbcARdx3qtrSKfJYf
	 Z1a94LN07qIbTx+uBQB1jamtgX9RFJQjhmi/vt3YsgGDTsspt4jyHebed9yhZJKOew
	 J6DVO54GBVeqg==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 7/9] nvme-fabrics: reset admin connection for secure concatenation
Date: Tue, 13 Aug 2024 13:15:10 +0200
Message-Id: <20240813111512.135634-8-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240813111512.135634-1-hare@kernel.org>
References: <20240813111512.135634-1-hare@kernel.org>
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

