Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E61E3798
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733223798; cv=none; b=C7PK73rUhYgZvBXyDWNxDc3V4kub/wCPcoQT3RRYS3m1OcDyE4//rdRkjvjyocsUPkQqsLMAO1y0FqnyJkrVaEUbbMr6UDdD9VnicIBYNgCTdTW0/6GxRlAra7X+xEXvB/xnY19IFojVNp5lKh9dJJ+g/g8uV/7my0QOmkxIOl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733223798; c=relaxed/simple;
	bh=Svjuo5V8Wl0PrlCCeCE0EAGZyFEy5Fqm+ODQK619Izs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=blbfiqHT2bYBu4yud8jHrXJnb+oSIUukHbYXSo8ih3wZ9gsL3XwarqjwkSwnlUK7vdZWud7OskDuiX77TFvthLWWodOb9GN1vPdDX2e77tU6C6a0/qxrzF3QJvS41Cyle6H5F4Rtg6ee4w4UH0l8CRd7bVZdipYWN20QE6UD7ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnFad3i7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnFad3i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD80C4CEDD;
	Tue,  3 Dec 2024 11:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733223797;
	bh=Svjuo5V8Wl0PrlCCeCE0EAGZyFEy5Fqm+ODQK619Izs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnFad3i7jJHjSHI7osDDy8Yc7y+dK7D/ZPsGDOg0mHiMdM6dqK3i1jh5xiDclIL3T
	 bYYwrTgTrPui4DKGsSo+Be92109dAxdFXCULeZ2H+VWSXFGGmrvn4pxUNh5rp26GeP
	 6Lw0ff+KkWRAIgNIGPmGt0mGsIvBzg7uJfTcfLGwPQsWgWQSyon5WOFi/xuNrpnMBz
	 AgHIyWBEJdFj8g7YoyspP51qITJ8h7HNIyI4z8kcF9evF9AMiPaSrHidUoDleJYDgt
	 6gRmlP2G7+NWcx/ig5cFOoB8EzDLuDvy5cWOe58hsVa1f9VdeJ0J0xgc92xoNcEScR
	 oAW/w+3coN6zQ==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 10/10] nvmet: add tls_concat and tls_key debugfs entries
Date: Tue,  3 Dec 2024 12:02:38 +0100
Message-Id: <20241203110238.128630-12-hare@kernel.org>
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

