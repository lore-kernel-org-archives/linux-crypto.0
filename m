Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467F8BEA
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2024 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658139; cv=none; b=KFHlLiKXofCN+5r86FHtAfc3/P5zjzjk/EiRhbLc9f2fvgJbBPHa5USa4Sb79wwrXT9LsyQGTGgofaswaDamjSNCsNpeVuWOx8zA9x27C4qbhYOQxuPRhcp5IKgMCF/r0tDeLeRoFKu+lMW4nniFN3bbbesxL3PR17SmNCEVc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658139; c=relaxed/simple;
	bh=rvxSwaBo/MU49AuTWmCU/bAdU6ldYXcaCYome3zR76g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=chL1h2az2uVItUjTaGeCFfMYWSNOklPI3hOCMKFmALQ1fiJ2bhIZoWnFPOgroqdQSi7qmUh2jDQ7PMU828qW770pRrjbO3KzDjwN3aQ3k4xpgw44aqAeShNcXT9WyuEUDpak1lZqQ1bIgOMeeaGhTz+ksSiHXUG9matc1VpOiOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iC3aEaRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iC3aEaRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27370C4AF12;
	Mon, 22 Jul 2024 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721658139;
	bh=rvxSwaBo/MU49AuTWmCU/bAdU6ldYXcaCYome3zR76g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iC3aEaRKSspVcNhQL6TDXqdnJ6CliDUv2B4uRVv5cAwKCWOCurduQs+Oib4Oo8sEr
	 kTsb94ebTzM4SrcShPE2ubbqztIz8m+nmbncJHqYw8U7h/5n+wAErgiT3cVNXlDYfC
	 n9RS6iDAXbycHom4MlTt8PxuQTdbi2T12gHGclMdT90l1Fo2Myex/J+F7TSfHoN2St
	 mzGkKvIZ70QH2SaAWxGnDNh4jTXulHIchByxcUmQKpzY7mu4Z0/GkkAoHOWIHOLytw
	 ChLVHjjh3SzOUCtH42YK8EAnqwErOPmcunClfYtjae7D+FHAAzp1Q3QSpY8GxUVxdi
	 fpmVDjbR96wvw==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 9/9] nvmet: add tls_concat and tls_key debugfs entries
Date: Mon, 22 Jul 2024 16:21:22 +0200
Message-Id: <20240722142122.128258-10-hare@kernel.org>
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

Add debugfs entries to display the 'concat' and 'tls_key' controller
attributes.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/target/debugfs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/nvme/target/debugfs.c b/drivers/nvme/target/debugfs.c
index cb2befc8619e..40e7b834a5eb 100644
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

