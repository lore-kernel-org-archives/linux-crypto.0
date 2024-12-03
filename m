Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5157F1E4101
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 11:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733223793; cv=none; b=Jbh1Pp7vCALaB1In0gfMi4DEdBNBous1gEYzuvGzXOSJBJgi0PWeGoPrIyC0uRnMfSsH3ZC3z5pRqXbo/Njjqy/FQ3uRFjJcq3mikSRBk+RtdTRJtEY35P//P9oDY8YSBNi1FNsMMjO2eMJ+pGFOVziCwF/HFyjwvRURPmwIyB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733223793; c=relaxed/simple;
	bh=q/4EU0cRrWIkiXqk0dXjd/z6g01ABRxjlms3ls0l7Wk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Go1OgNsij5Wdpac/SBynoDDjlsNEHbs+eYSdwktpqN6MwOcHzk/NBRRmsT1rRkP4i78a+bBNhwTtVvpv2bKcTUu9kPq7N/w3dz1s+rMylPSrN3lmJavycKS4KimIIISLFA7XO1A032HUeNjUj/CoF1BVEQgazbgqP+v4KMXKmJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8+tvnuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8+tvnuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ABDC4CED8;
	Tue,  3 Dec 2024 11:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733223793;
	bh=q/4EU0cRrWIkiXqk0dXjd/z6g01ABRxjlms3ls0l7Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8+tvnuDWzrdv6nX1+0K5gUflaSUsyw7zHJ2DB68r6ua03EW8McGybZmD/3t9kZAY
	 o0QMxtm5NRwqrEho95sRnrzWaA0QWz1bCMYUyzqhhhjNN8E+hieTpBaUVa9VlHIUEl
	 CnSY7XwWBh/Z+OA3/xG9vW1sPDjmZBp2nxGG4yecKWhSDw1pGcMDKuxcl7S3sA9u8A
	 mgLmK28X/ilhqHG0B8XFAS+mAcSatBSxHlTJpP0FNIyV9Q7YWvNwqmvLCj55gCOtlX
	 yJeknhBIQNAyvkazOwzjBJU0W09Jf3oHCvI0I33ufIDM2uzqCXouk365zR7EkaQJeS
	 5NQZFjaOUZEXw==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 08/10] nvme-fabrics: reset admin connection for secure concatenation
Date: Tue,  3 Dec 2024 12:02:36 +0100
Message-Id: <20241203110238.128630-10-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241203110238.128630-1-hare@kernel.org>
References: <20241203110238.128630-1-hare@kernel.org>
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
 drivers/nvme/host/tcp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9268c6f2c99f..3ce5cfe8a135 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2260,6 +2260,16 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 	if (ret)
 		return ret;
 
+	if (ctrl->opts && ctrl->opts->concat && !ctrl->tls_pskid) {
+		/* See comments for nvme_tcp_key_revoke_needed() */
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

