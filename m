Received: from njjs-sys-mailin01.njjs.baidu.com (mx309.baidu.com [180.101.52.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA621586CA
	for <linux-crypto@vger.kernel.org>; Thu,  1 Feb 2024 06:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706769417; cv=none; b=CHRRgB/82M8HGZQnwtoBFv22Hf4+XEFIsSI2YrIFcLTjWIxSr4ln14JNH0BZX8gFhSyXCtJZMTwMf0L+lXonAivly+ZgPQpGsh759soEsX7ZK9G8wUbilEZ7to1RSW5Y4kn2TNSuj7c59BMsdj+4J0EzDsP2j9cuBZ/d+BPJIKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706769417; c=relaxed/simple;
	bh=WIbDMNbZWoOGZv19VnPIaSCLxnXiBoeaJRq1EfSARr8=;
	h=From:To:Cc:Subject:Date:Message-Id; b=sjNhmoFpo0SGZlMAXewow3BC8KlkvMusYQJqeVOxcO2bRJrYR9UVbNK6sbtIi0kuvYla7GH4i9p6uEACMLAHDcju6B6n7dvTb/glNdbAKpyz71/WGyitGABZ4rY3ghcwol1tOme25LdHfWWp3zvcgdtHK3fvCRu3iBSefWdYVjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id CCB277F00057;
	Thu,  1 Feb 2024 14:17:18 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: linux-crypto@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH RESEND] virtio_crypto: remove duplicate check if queue is broken
Date: Thu,  1 Feb 2024 14:17:16 +0800
Message-Id: <20240201061716.16336-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

virtqueue_enable_cb() will call virtqueue_poll() which will check if
queue is broken at beginning, so remove the virtqueue_is_broken() call

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index b909c6a..6a67d70 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -42,8 +42,6 @@ static void virtcrypto_ctrlq_callback(struct virtqueue *vq)
 			virtio_crypto_ctrlq_callback(vc_ctrl_req);
 			spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
 		}
-		if (unlikely(virtqueue_is_broken(vq)))
-			break;
 	} while (!virtqueue_enable_cb(vq));
 	spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
 }
-- 
2.9.4

