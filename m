Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845821FDE2E
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 14:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733149827; cv=none; b=pNlXcAL6n+KvO95zwGIq7NagKhrQ7NdEuOlbUx7XEKm747cTD9W1rsWFxqDI3M2gKCKkqSmIouzT7WmD7BPrEWyR4c23kxTbykGmpz6S9CKd13ZkqMHaNBiZXh2aSuMJlsSvrHMD1g9wrDSY2FeU5YiWx9+E/thRVfrXkoLsP5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733149827; c=relaxed/simple;
	bh=q/4EU0cRrWIkiXqk0dXjd/z6g01ABRxjlms3ls0l7Wk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GU0+1eu9R5BNuvbIQFzqwLEN1uz2pHLbr7Jd7K7nl+ajRk++U0gMadOfqahJ42CtHMLQ8kzrLr783VaY16oHQBDj0c4zlqTVn8pmSFVNI4ydFDGoMMP4khyPI/HjOsCp8HVgM5Wno4P3IbxqIf5lnocRPa8UizatQwrjEUNuJFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yna05BER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yna05BER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F82C4CED9;
	Mon,  2 Dec 2024 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733149827;
	bh=q/4EU0cRrWIkiXqk0dXjd/z6g01ABRxjlms3ls0l7Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yna05BERE7KZRQrjDT+s1JZ4+/VgYZnGOn4H5i/qmEqpHs/XjG7lnMpQBHjBPivB+
	 hP9i9q6+Jx3kr23X8kbDvrIv15dt9aP4sZgkoJiWG3NPj7sxHB+LMBi4WuK6aPpcq7
	 d3q9KOHyB+Y0U5sI0NzoJbYJB7pW+DlqIaYJDoMZ3yh5jr/F6XU7ljq/qDan7zME3c
	 imEdAKn+mK+NP8rqTtVSRMeuCPLvQgQy5GQLaCDSQ8VoqGMiCUxt2kmWyUvOB0iGIG
	 lUgqNEay2h0AmhUlpovN91t+4/TyCdNHhhwrRSbFVj9PoGwjjJYzWrcWwre03WaYcf
	 dlAZ2KHyEHXdg==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 08/10] nvme-fabrics: reset admin connection for secure concatenation
Date: Mon,  2 Dec 2024 15:29:57 +0100
Message-Id: <20241202142959.81321-9-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241202142959.81321-1-hare@kernel.org>
References: <20241202142959.81321-1-hare@kernel.org>
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

