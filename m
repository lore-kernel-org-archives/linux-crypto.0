Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878918EFC1
	for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2024 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728662103; cv=none; b=QYQAz+N5Ssvc+97MDACgjInLfbCXEp0aKiuvDiE8nnuA66errMCPgG+VKBdE36NY93Bk+goL7ZInT9Fw4oAEf0rdogMHpXkWSouj6NU8UfQ0b9iFhtUUZ9ibVtVsnUh5JUuy8aqKU3L0K9mJy0hY+3QAX81ipH9upck3kd07hgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728662103; c=relaxed/simple;
	bh=pFqbPRAdiuRsY0v5qj58v/zUdbaLboMBN8uycfJ3/pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UfkEm/a0YcLiwhu7a5BYdXQuSI6yxhoppe1CIs8YuZVj6h5AWihauJ8K0qXCCh8Ry/bDAVTXhvSHGDhuHzg8vQKdIq18n0k6+MtnSAmMoWaf7quCo0ghzHzuHc/u6xVTIAcp7Z3bOsyMJjA5J73jGS/Bwt8BVq68j70PqJEqMiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFp25kEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFp25kEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77095C4CED0;
	Fri, 11 Oct 2024 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728662103;
	bh=pFqbPRAdiuRsY0v5qj58v/zUdbaLboMBN8uycfJ3/pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFp25kEdGhNq8LJP0wqL1jE3+R3VPxch677kxDVBbHkMX6F+c4vkcRjVt2+fnB5L2
	 D8qp3xOFUHvq2EyCAB51H6r5uvY7MyWVhUVdWdpOpTJfuZpF4vAoo7GoeuIjcrsAi0
	 ghdNCr7Db5Bi+3A09sQoqoFoHsL5lrro1i5CWith5bFRcj+Q4C8DTIrCTM3jOVQMa+
	 1+DtN56JbKBc4zHqKUguUGlanTyNb28+edNPeiBSaoovhl0o/NO+yNvWeOCs1J4Y7E
	 CavXcmZUhXfAYQzDSZEiBotOi7eR+3d27pbiQp22fo4FLY/OD7UPVzDFmuSZw0SaDm
	 72xp+uDA96tsQ==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 7/9] nvme-fabrics: reset admin connection for secure concatenation
Date: Fri, 11 Oct 2024 17:54:28 +0200
Message-Id: <20241011155430.43450-8-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241011155430.43450-1-hare@kernel.org>
References: <20241011155430.43450-1-hare@kernel.org>
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

