Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2C32233A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 11:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723547749; cv=none; b=I1XIXj+2qWAIJctpBjda63fSUp+8aBEhQY/rflOPhNqsVR8viOZvxfBYcEnM2OJAJ5NgpKjwsPaZchsX3JygpgJ3c9Ut3qQ8Y0mYl/J4ou1v/wCLZUi6LSKkgbddOFdn61RkEd0NWkHtIvLRalFXfOjvk0AcS5KHQLmHAkq/53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723547749; c=relaxed/simple;
	bh=rvxSwaBo/MU49AuTWmCU/bAdU6ldYXcaCYome3zR76g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gR7aigrRExrtRNL/m4W9FBeRT755FDAUiigWLlOkxLSZg6j4YMWFAfJiUSZ+uf9s+rZ/3bTmSPp2ngMGuALbSKcOXIyRIljD7fJv4GLV2sVLfTc/UEZeINGWBZE2ri9s05XRwiqad2UEpIvHwRuzyXcbdZBeMcY2AAAjbX8dhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goubNEkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goubNEkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65408C4AF09;
	Tue, 13 Aug 2024 11:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723547749;
	bh=rvxSwaBo/MU49AuTWmCU/bAdU6ldYXcaCYome3zR76g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goubNEkbcmhwktSlsrVwMqjmt1QsmsM99fsKNGdeL5p2jV0nLFB9S37Mf/tbK4flc
	 3Y5zEeLuZV7FNNMG5FVjLMEpJIS40y2cegVV2t2OgBoN+nKvPyFrBZIxX3r1+3SGkt
	 F/EMarvsQ57y0rV0HsT+1XfwXJHEY2iY8VTkq9oSxP1Nn8DTtc+i4/Q72gGfIGCaCQ
	 Px3cyMWVTj1x699boMNMIq5Xbg2kjpd93MXnASsmrKjzJ+FMdju80Pnf6OJKscAqPV
	 oOVp+pzU74o4jWLGjgLQx35+iD7K2U+s82972jHfPum96bGn1z50Dcljnqq+UH0D9W
	 EmCar7k8Uqjzg==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 9/9] nvmet: add tls_concat and tls_key debugfs entries
Date: Tue, 13 Aug 2024 13:15:12 +0200
Message-Id: <20240813111512.135634-10-hare@kernel.org>
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

