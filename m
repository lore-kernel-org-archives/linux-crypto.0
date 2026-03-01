Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2DA302165;
	Sun,  1 Mar 2026 01:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329970; cv=none; b=tce1jzLRYl4S/AA/f+P1FO+5Mqoc/ZbmQ70ctogOjrJ1EIoHk5O9YOTxfXeUQybUijJK5aowiYSlHccqMk//w3FPVVtSpHLUnw+08tvzY2jpoGc6NPK/CEoimFJpI3Po3Rx0h44T6CrC9Xvm0WE9WZWPA/wjCGb8rKW1TLRnU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329970; c=relaxed/simple;
	bh=dnQbL4zJDKzoriq6ePiOoCGht+7q2cSFSjD+tVG8rnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nMWdYkaIbVmLPq7AK9krYMMoIOhgkmTFJWj+obUsUvMbmXEl9tMQzF7IoB0wQSfnobgS6Cs75OiWC62SmNPCk6I9k6AsObSz5J3++MsJXcfqryNX3fci5cwi8xvZ1LYOjItYgMctGIY1XQtliFG24IbLdAvT+Zlbnj+x7jB4Tao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9tH+X83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9tH+X83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E52C19421;
	Sun,  1 Mar 2026 01:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329970;
	bh=dnQbL4zJDKzoriq6ePiOoCGht+7q2cSFSjD+tVG8rnA=;
	h=From:To:Cc:Subject:Date:From;
	b=F9tH+X835u2+rFC9RmITcw+jOSGzy+88Kgd2k0ZE8zUR8wQBNnLF8xS7S3I2kX5nw
	 GlbQT/Ehghu0ZGU88foZ5N83OV0dlh8Gk8ygMAsbG5VV0Vn28tOKKZVgo44tKcAShF
	 4ywknD1wYxWvOwQYwuVUp/IX5isXQ6V3EMB91XIGzFatPE3CJNU3a0nJUBh9ZW9+Jw
	 zZ5uZfhJEx9Pf3A/4/PB1eACc4YisU/+TYJff+F0hvRhgi4b2g8u0YFdMeVvnvuq5I
	 gAQ1Cq+udQuLquSJKsljnS/sbT47ixnLOMNzJ/WcyIl3YOoN3dz8RWiHIl+UdDsMxv
	 IlqHAL6VSd76g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Add spinlock protection with virtqueue notification" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:52:48 -0500
Message-ID: <20260301015248.1719424-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From af9a17d29ce9060664f56264bcc64b976fddd2b5 Mon Sep 17 00:00:00 2001
From: Bibo Mao <maobibo@loongson.cn>
Date: Tue, 13 Jan 2026 11:05:54 +0800
Subject: [PATCH] crypto: virtio: Add spinlock protection with virtqueue
 notification

When VM boots with one virtio-crypto PCI device and builtin backend,
run openssl benchmark command with multiple processes, such as
  openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32

openssl processes will hangup and there is error reported like this:
 virtio_crypto virtio0: dataq.0:id 3 is not a head!

It seems that the data virtqueue need protection when it is handled
for virtio done notification. If the spinlock protection is added
in virtcrypto_done_task(), openssl benchmark with multiple processes
works well.

Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260113030556.3522533-2-maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 3d241446099cc..ccc6b5c1b24b3 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -75,15 +75,20 @@ static void virtcrypto_done_task(unsigned long data)
 	struct data_queue *data_vq = (struct data_queue *)data;
 	struct virtqueue *vq = data_vq->vq;
 	struct virtio_crypto_request *vc_req;
+	unsigned long flags;
 	unsigned int len;
 
+	spin_lock_irqsave(&data_vq->lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
+			spin_unlock_irqrestore(&data_vq->lock, flags);
 			if (vc_req->alg_cb)
 				vc_req->alg_cb(vc_req, len);
+			spin_lock_irqsave(&data_vq->lock, flags);
 		}
 	} while (!virtqueue_enable_cb(vq));
+	spin_unlock_irqrestore(&data_vq->lock, flags);
 }
 
 static void virtcrypto_dataq_callback(struct virtqueue *vq)
-- 
2.51.0




