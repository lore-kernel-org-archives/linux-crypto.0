Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B709030171F;
	Tue,  9 Dec 2025 02:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245616; cv=none; b=NdKF+fUGlhA7WerBju4pc5QHbywYeqH+ZIehd5NAQ7Ro09gdaefCixTe8NVg5Z4DvOS+BLkiUtSV5wUwQMg5fDdaVTtEW6/zPpr/aEM7Pld3Ewsbvgh5mGiQvEcP/djtFKglJUgJ1rAt3rNbB87fP6jGFOdkuQ4RYr2NbYrkQko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245616; c=relaxed/simple;
	bh=bP+MftIy5MZyKErTXJZOXlqqWq32ab3+bPjAzNt3ddw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=srW9URFXd/UvPclmCl3pR+5/M31CMJvnhrO/eEGk5kBOphpE4QUIYaTNITPkKh4guvnt/zwUsOFh/AMrybAexEszoapupb/qIfUPUuJYrlNe8IqxLb30E1eMMFrPhRzbJ3zIuhZp+cNguR0LcGqulNQIBCT7uWsrZWwvCMcYgZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxE9CngjdpZIEsAA--.30040S3;
	Tue, 09 Dec 2025 10:00:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxmcChgjdpKEBHAQ--.35119S5;
	Tue, 09 Dec 2025 10:00:06 +0800 (CST)
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
Subject: [PATCH v3 07/10] crypto: virtio: Add req_data with structure virtio_crypto_sym_request
Date: Tue,  9 Dec 2025 09:59:47 +0800
Message-Id: <20251209015951.4174743-8-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxmcChgjdpKEBHAQ--.35119S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With normal encrypt/decrypt workflow, req_data with struct type
virtio_crypto_op_data_req will be allocated. Here put req_data in
virtio_crypto_sym_request, it is pre-allocated when encrypt/decrypt
interface is called.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 788d2d4a9b83..bf9fdf56c2a3 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -26,6 +26,7 @@ struct virtio_crypto_skcipher_ctx {
 
 struct virtio_crypto_sym_request {
 	struct virtio_crypto_request base;
+	struct virtio_crypto_op_data_req req_data;
 
 	/* Cipher or aead */
 	uint32_t type;
@@ -350,14 +351,8 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	if (!sgs)
 		return -ENOMEM;
 
-	req_data = kzalloc_node(sizeof(*req_data), GFP_KERNEL,
-				dev_to_node(&vcrypto->vdev->dev));
-	if (!req_data) {
-		kfree(sgs);
-		return -ENOMEM;
-	}
-
-	vc_req->req_data = req_data;
+	req_data = &vc_sym_req->req_data;
+	vc_req->req_data = NULL;
 	vc_sym_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
 	/* Head of operation */
 	if (vc_sym_req->encrypt) {
@@ -450,7 +445,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 free_iv:
 	kfree_sensitive(iv);
 free:
-	kfree_sensitive(req_data);
+	memzero_explicit(req_data, sizeof(*req_data));
 	kfree(sgs);
 	return err;
 }
-- 
2.39.3

