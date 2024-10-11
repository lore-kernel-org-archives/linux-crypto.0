Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93757198826
	for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2024 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728662107; cv=none; b=EMUtmbWpj5t1ir3ZUKDhQeTvswMfZ3BdOL/Gqj8+UAqzeD5EfGtJRfM0uMZJGfOAC+yZtgbgZOpUQYu0uyYmsxwvSGY/0Oe1ULvKpPPeRrmTP23KcggqyX0OPG4/NV/c+GL7dH5uxUrTfPVh02W2myIxq847rV2m/ap9+STQrc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728662107; c=relaxed/simple;
	bh=Ni4SmrOi1UnoeqmiY/o74ZRh5zVQ9/nk219LQVTeAPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dp+xQcPlrtcP29eNSWFrFWR7dSfR6WgR14MQtmrEtk6CGtUIAaH1z0R3N8K5WzKHeaiX65W/Gs98FDbVB1gxW54unciE/8+BJyzq2JXjye5RlCn+Cu+pwiFybWqgAJQ/TThq6khhbDKrCQhdzgImrdGKAH5YIgdesGDFWi7wWHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7JKUkxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7JKUkxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C7DC4CEC7;
	Fri, 11 Oct 2024 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728662107;
	bh=Ni4SmrOi1UnoeqmiY/o74ZRh5zVQ9/nk219LQVTeAPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7JKUkxabHxsa0aWycUFlpvfxP4Sd4tTQSM5nDZpoPokr/xEVFc+hCmlGtyn/QLdP
	 8udTDcdT9A/wQxSY2MFniIaX3SBHKCNkirAlKN3xteLXGkS5B2wekL1zjU/dZzJ0Sg
	 OD5lTJIknFj5/pjEQdGw1ZRUJLcOrUTXF3JavhXndt6yH3jW+XmJ8tv/jdHQ64r06v
	 A9akUfCGrMJ5yO2Vpg8Xn3DCzTYPQ9mbP42Ejjcfyqsgdsr6ts4Oe2tMTetShWw1zy
	 ZBhxqOt2u2jNC7imGuuAR8fNzmsDMU8eVlJfufcGqt75h0aml8epuqcUa+pkRPiRZY
	 Qumk4zlDgzPYA==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 9/9] nvmet: add tls_concat and tls_key debugfs entries
Date: Fri, 11 Oct 2024 17:54:30 +0200
Message-Id: <20241011155430.43450-10-hare@kernel.org>
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

