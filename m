Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A46E2D027E;
	Fri, 28 Nov 2025 07:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764315619; cv=none; b=fZpl+E6/VdQl/5qsidFdEaF2hE/S5WZ23M5ST+MAxlDcWsaoyLCsFEmCdKWh3Jw2pkTidF2BQIq4S5rkRF5gTCvnCxezEaROy9046QxfcE83LBXgOUN0RoonkP9ViHoc9WO9GHqdN0S+U3NImxw+w+CPLRw6SLWQmP26nmp6kIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764315619; c=relaxed/simple;
	bh=9POnfd8KCgzKOXOKHiFhGQ3sA/OUBNdoOYdyxmsf4rk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TW0J0XNwQ8mJdNgsOxAUD0beAJ4xsey0yK3+mp9EiUOlFbcsfENZw0ZztEMWndZdqYoRj0aSBXYgOM9jr+Aty1KvzmbSmWq0h+NiPkwTmJhWS5qm4/XkMwgQcbV6udNo5DNC99SYln7WfeuiRckt2rtBy4X2Dgv8BpmKLm3AnpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx77_VUSlpwgUpAA--.20515S3;
	Fri, 28 Nov 2025 15:40:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxrcHUUSlpw9hBAQ--.18805S2;
	Fri, 28 Nov 2025 15:40:04 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: virtio: Add spinlock protection with virtqueue notification
Date: Fri, 28 Nov 2025 15:40:01 +0800
Message-Id: <20251128074002.1149034-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxrcHUUSlpw9hBAQ--.18805S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

When VM boots with one virtio-crypto PCI device and builtin backend,
execute openssl benchmark command with multiple processes, such as
  openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32

openssl processes will hangup and there is error reported like this:
  virtio_crypto virtio0: dataq.0:id 3 is not a head!

It seems that the data virtqueue need protection when it is handled
for virtio done notification. If the spinlock protection is added
in virtcrypto_done_task(), openssl benchmark with multiple processes
works well.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 3d241446099c..ccc6b5c1b24b 100644
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
2.39.3

