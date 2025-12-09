Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD181301012;
	Tue,  9 Dec 2025 02:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245610; cv=none; b=IT1bg8qGloftSYw1OEhJq9OVfqDMDE7xFK09GRUXbChidvsgmlgz+fil2K2pjAiqSNcpToG3PUT6yPDT92mIHOaMZEqoTvFO1I09yn3baFuDKBZ7tH4fIWYQU+sOsN0pA5EjjhxAPV8l6uL+b6B2hynnS1g/yMfT/T/6CqszXNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245610; c=relaxed/simple;
	bh=otHlg6VFY9iXNaEv+5xVdFZsWVfFF+xxFJir1438s8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GWTRR/zqIMrBUnZs72sEh2eSzZjprmSABHxZUH26ghE79Uc+h+R/Niha8P3LYmowsvo6njBz55lO7w7+NKv4SqqymVGuCkhNs8tCkcowrYxvZ/3DUpVTP4hfSJK4Yy5trxlUsWDjFnjKre1mXibNC4EEm0WnRr3F8kFmTsIXaxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx6tGdgjdpOoEsAA--.31065S3;
	Tue, 09 Dec 2025 09:59:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxXMGXgjdpI0BHAQ--.4870S4;
	Tue, 09 Dec 2025 09:59:56 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/10] crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
Date: Tue,  9 Dec 2025 09:59:42 +0800
Message-Id: <20251209015951.4174743-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251209015951.4174743-1-maobibo@loongson.cn>
References: <20251209015951.4174743-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxXMGXgjdpI0BHAQ--.4870S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With function virtio_crypto_skcipher_crypt_req(), there is already
virtqueue_kick() call with spinlock held in funtion
__virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
function call here.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 1b3fb21a2a7d..11053d1786d4 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -541,8 +541,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 
-- 
2.39.3

