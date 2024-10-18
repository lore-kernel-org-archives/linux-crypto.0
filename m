Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BD720E30E
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 06:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729233255; cv=none; b=TyQKkK4uQxshRR/29cACWZRqdb378Zc/BjJPbzA3czg4uWL5i/TauXzbgGvjD7ElGSRIzcsfhDOnDDtVzkepiYfUUyC23aiuaGsnwTI9Qqmkl3Lgc/fp96NlzIOOHS0WQ2LZ6vQLpQcFCiYThMN/fW8bQufGOu6C/f2RJhEmeLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729233255; c=relaxed/simple;
	bh=Ni4SmrOi1UnoeqmiY/o74ZRh5zVQ9/nk219LQVTeAPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KgzERhSn5IIULLsk9uvDHxzfxD6hnGHZzuHhsyBYpMh/5t3j7LHmgHX/FcN8YEvLeVqOZx1/aQ8AMkSWvtMIPNG/VF4NCma+0MHS+DXND9x1FL0BdfIkRJVshU4zEHjajOAlPalaRFvopfXXRo2/iqG4VtwkalOolT5PABDyo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+Mmwg3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+Mmwg3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10B6C4CEC3;
	Fri, 18 Oct 2024 06:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729233255;
	bh=Ni4SmrOi1UnoeqmiY/o74ZRh5zVQ9/nk219LQVTeAPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+Mmwg3fgmpGVjdbNsOMPdgD4gDj+KwLSsxTyURKKsR9yoJgqVn/ObTUaIs6AN6Zh
	 v0Q4HJBitGYi1/wfhGYbrtUZ4YOxuP9QMRRJGEboL30kdZ1W7cKA9p4Hi60JxGJebl
	 UWpHQs9hYkv+EWyDZYGeWABgnMnderB9MrIqEUFwiezD6CgNEYFeUY+08v3gDYWWxz
	 pCB8FcyzIVnTZzOBy2sxG7g+DNwgmk2JVKvW0IbDmxIH+5Bux6J7senpzBBH3YjrdI
	 JKCa0iAdhv59WzK0eaYE8d2CJz7V+aKxY9y8koARkbHS5hc5hnnAd7vRc0nAjCnLZ/
	 y/eYxtj+AwU2g==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 9/9] nvmet: add tls_concat and tls_key debugfs entries
Date: Fri, 18 Oct 2024 08:33:43 +0200
Message-Id: <20241018063343.39798-10-hare@kernel.org>
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

Add debugfs entries to display the 'concat' and 'tls_key' controller
attributes.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/target/debugfs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/nvme/target/debugfs.c b/drivers/nvme/target/debugfs.c
index 220c7391fc19..e4300eb95101 100644
--- a/drivers/nvme/target/debugfs.c
+++ b/drivers/nvme/target/debugfs.c
@@ -132,6 +132,27 @@ static int nvmet_ctrl_host_traddr_show(struct seq_file *m, void *p)
 }
 NVMET_DEBUGFS_ATTR(nvmet_ctrl_host_traddr);
 
+#ifdef CONFIG_NVME_TARGET_TCP_TLS
+static int nvmet_ctrl_tls_key_show(struct seq_file *m, void *p)
+{
+	struct nvmet_ctrl *ctrl = m->private;
+	key_serial_t keyid = nvmet_queue_tls_keyid(ctrl->sqs[0]);
+
+	seq_printf(m, "%08x\n", keyid);
+	return 0;
+}
+NVMET_DEBUGFS_ATTR(nvmet_ctrl_tls_key);
+
+static int nvmet_ctrl_tls_concat_show(struct seq_file *m, void *p)
+{
+	struct nvmet_ctrl *ctrl = m->private;
+
+	seq_printf(m, "%d\n", ctrl->concat);
+	return 0;
+}
+NVMET_DEBUGFS_ATTR(nvmet_ctrl_tls_concat);
+#endif
+
 int nvmet_debugfs_ctrl_setup(struct nvmet_ctrl *ctrl)
 {
 	char name[32];
@@ -157,6 +178,12 @@ int nvmet_debugfs_ctrl_setup(struct nvmet_ctrl *ctrl)
 			    &nvmet_ctrl_state_fops);
 	debugfs_create_file("host_traddr", S_IRUSR, ctrl->debugfs_dir, ctrl,
 			    &nvmet_ctrl_host_traddr_fops);
+#ifdef CONFIG_NVME_TARGET_TCP_TLS
+	debugfs_create_file("tls_concat", S_IRUSR, ctrl->debugfs_dir, ctrl,
+			    &nvmet_ctrl_tls_concat_fops);
+	debugfs_create_file("tls_key", S_IRUSR, ctrl->debugfs_dir, ctrl,
+			    &nvmet_ctrl_tls_key_fops);
+#endif
 	return 0;
 }
 
-- 
2.35.3

