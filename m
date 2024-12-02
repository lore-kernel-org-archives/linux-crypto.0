Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B393E2040B3
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 14:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733149831; cv=none; b=QEnxd9XNlgr5yDpevnhip1Gl4zq+5+HKz2F3frUH1URCpqQaRipdxel0nATBzsKzecysPh/+v+uhb1ryufio9dbBNKGqFUPmqVIw2SCQcvcY/PoVYVlSege/tZmCM5ZoMlF7JxyQMR5IeSatJzDPakvbM29UXQKGepE3/Dg5O0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733149831; c=relaxed/simple;
	bh=Svjuo5V8Wl0PrlCCeCE0EAGZyFEy5Fqm+ODQK619Izs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VVLhm78445kgmwF55XMjnlCYA8tpTeE7k3d2AP4DqYz76Z1KyJk0QbSyCCh/6MSMfqGYc2IezI6S2xms1iutWRu2c+9VWOx8/xMP27jFzFeFVxwjFgjCL1e53lM4904PyqYuYj0qvzwtew5r2C5heXvGHNqPjCcMTMfNisk7sbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts5SCsA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts5SCsA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85D0C4CEE0;
	Mon,  2 Dec 2024 14:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733149831;
	bh=Svjuo5V8Wl0PrlCCeCE0EAGZyFEy5Fqm+ODQK619Izs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts5SCsA8hHVvGW0b1j8JtWJeQprvER+MmBD6Jgk68/j4LH4Hvo4ytmmoBmCov3f2G
	 mPx5uSVqmJaSpOvd2sQJAsR5wasxi8KwZE3/9jAEf01dtKqZElcOqCvlrN9/IsCKoJ
	 birBdQh4QiIq/9oqAFSugvZDLTFJ83pwrewDyazoUu5lB/vG/YkwxVUejNja97gG4i
	 jBPGimXHqxiHHo+s0ojH8gucZbEhhpxNGtvDQOfnNF2/3zugvaFhIY/ct7TaZ+DheY
	 udUCmTZQxGCIWNgttg6GTq26wuCH3hbiuXC4p4nyMgk4yJgjsEP3dDEtsRmN4d2lMB
	 qXi/kwFHJPrUg==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 10/10] nvmet: add tls_concat and tls_key debugfs entries
Date: Mon,  2 Dec 2024 15:29:59 +0100
Message-Id: <20241202142959.81321-11-hare@kernel.org>
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

Add debugfs entries to display the 'concat' and 'tls_key' controller
attributes.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
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

