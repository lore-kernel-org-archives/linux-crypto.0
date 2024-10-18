Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7171215FD13
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 06:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729233251; cv=none; b=MByGsNm77FAMwWnPqe0sjBGZjfVUfk2Huc2Xn9KTcpW/16P6NQJkk11oi3cLNH+oFBDr2z2GJGOwClugaB1wJ7jg0nOeMmJFC2eAqF6hdCXqG0WfpyCGfnwGHp5bup5/2IzTfsOI4ZxBHMu03RpIGTv+wZ5aV7dvQbQontcPXVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729233251; c=relaxed/simple;
	bh=pFqbPRAdiuRsY0v5qj58v/zUdbaLboMBN8uycfJ3/pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YDvjJJBSA0ttK+qeUV8dTJYOcnaB6toU4iOGNk52QLQraf7B2cWMtW5INrKPlrXrnLfXmfnpbNCPCwZwbijQTiOQHrP0F3aRsgPQ9my/VxnChxrIrdEgIyNCOVfoO/C3wFL8LBAPW9J9IKaJAnCl/Ov5JZLp0IlRjPF3fMMaw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctBp7Pee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctBp7Pee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88E2C4CED0;
	Fri, 18 Oct 2024 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729233251;
	bh=pFqbPRAdiuRsY0v5qj58v/zUdbaLboMBN8uycfJ3/pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctBp7Pee0WLSThkhL3amFtZrGnwNh4gzXGNPB9shRA8R7nSGEboSi4+qF8OHH9aa7
	 tSFkGhtZXoi7f3etun8Kn0ESaVp54WMHxn9H6G/8KAiF+eQBIyTE0lU5pyRcW51muU
	 zVJ4zsgHZdwe6qxN2I+CV0beyQJP/6eZYIfiOkjqSVTIl++9cTup/GRM8QQbbkRyv1
	 DmcJMPswp+Qdplzn7YAh1eQ2k6vTBqxjebEVu+Krvlz7p0rVmDwhqsk9RZeRekgZ5p
	 1Y4o/C0PRR8N8Oc+/Y9NVGvZKYejiRArcR6lSGB3AIDQph5VAJnfaMsNsJoAjafCm9
	 64vCXfY7rTWyw==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 7/9] nvme-fabrics: reset admin connection for secure concatenation
Date: Fri, 18 Oct 2024 08:33:41 +0200
Message-Id: <20241018063343.39798-8-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241018063343.39798-1-hare@kernel.org>
References: <20241018063343.39798-1-hare@kernel.org>
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
index b8a3461b617c..04f0ac57855e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2251,6 +2251,15 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 	if (ret)
 		return ret;
 
+	if (ctrl->opts && ctrl->opts->concat && !ctrl->tls_pskid) {
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

