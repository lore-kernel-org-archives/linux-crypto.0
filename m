Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6139145A1F;
	Sun,  1 Mar 2026 01:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329455; cv=none; b=GdRVl99DDRQAj+11IR+GMCwpP4rNCiNaoPg/L65vAEJgY/YEIiTDDHenfIDVrk45DXYmtiUPVWuXxBFiW4uV2gxDdPGZL4Y+PsW0WnQdlesL2/lKo0GTxx0g9EVFeVpk68GSrpx7TJFbkPoISxtQhtqnXx3PLYfgyLJThOwOqL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329455; c=relaxed/simple;
	bh=cDmbZVf5xKdfpWsKHm0+V0nREKzcarr95Y72hctV1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WfOfOrxfRHmgJ7av9DCscZ1vqW9KTJsmGMQdkCokq7PuWrrKn6TNXaipGuQTOst1YIrf5wQGzcUYXz5HEvDUiHV+7TTHrXl0XLVWqwvRTHnK6NkJQ2iX9YAqc5xRuxcGFMAN3BPc4+nND70gNv9i7SwzTkH7JxIXUbughweFXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1FcJ6gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1FcJ6gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC9AC19421;
	Sun,  1 Mar 2026 01:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329455;
	bh=cDmbZVf5xKdfpWsKHm0+V0nREKzcarr95Y72hctV1bk=;
	h=From:To:Cc:Subject:Date:From;
	b=i1FcJ6gih/z6QE1npowGVT5nsi7oCeHKAtkdffvfu3hy0EuJf7gC5ziasbSB3GHHo
	 G/eNP4eVXtsScHM4iDIEeGycl0rkWuGTof25wJSYqB+9LruhDXc81iXst2EOiyvJlp
	 seJ847q3TTMVkOLN6GcmSwX8pUkSbCfGBnvVbvO3PyC7qP4zmS99zfrz5pnsnF4WTX
	 NLyOeFCF9GMMooxiCGIMVDaoaR01WxkqHHNDhMdFdoE3TdJ0f2C1WA4vnJY/8X2IyO
	 ARNGlkjbSC+FrAizl74x5hx1zuXla0DQa6KzEV5CYzFIBFeDJqOBkVQfaaJ1X1rDHF
	 jw0LDfIa9tolQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Add spinlock protection with virtqueue notification" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:44:13 -0500
Message-ID: <20260301014413.1706432-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




