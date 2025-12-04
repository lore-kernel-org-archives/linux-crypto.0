Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7875133D6EA;
	Thu,  4 Dec 2025 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847415; cv=none; b=W1PQk+gqP4hlIA4xrkmdOVa/w284X5g3+I4Jw8QiRK2peLus8uE4ilGcSH4XW/92ip92J4im7ycVXqZ4ptXEBfCxAotImV3PJczVENWxtfaZFNfDnwBiAjm8s1GVFY8BVdiqH4oRF6Uv9afpHMTyQGtVzB5PdbMonUMtzvLBqHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847415; c=relaxed/simple;
	bh=7c03FxyUmf3V8HIdmPH7XjLkvyH98v4CY+C/h72E+og=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U/6RpOcuSqyMKxYrgQPi69GUPTX0vrGTeO8fPpTewCw/sAyPyVG6n8gzoyBDTcmwja3cQRK7b0GrJ31BYfSP9yowC7y1MdWWwgd2IDBxQs+VIquLbMvFY/aoPI+ITQbnyj8FlNthrtmld5CDIBnqyiAoLhziO8Poy/vdrS2WdWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxF9H+bjFpGAorAA--.27256S3;
	Thu, 04 Dec 2025 19:22:38 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxG8HzbjFp1mpFAQ--.17590S8;
	Thu, 04 Dec 2025 19:22:37 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] crypto: virtio: Add req_data with structure virtio_crypto_sym_request
Date: Thu,  4 Dec 2025 19:22:23 +0800
Message-Id: <20251204112227.2659404-7-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251204112227.2659404-1-maobibo@loongson.cn>
References: <20251204112227.2659404-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxG8HzbjFp1mpFAQ--.17590S8
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
 drivers/crypto/virtio/virtio_crypto_core.c          |  3 ++-
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 12 +++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index ccc6b5c1b24b..e60ad1d94e7f 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -17,7 +17,8 @@ void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
 {
 	if (vc_req) {
-		kfree_sensitive(vc_req->req_data);
+		if (vc_req->req_data)
+			kfree_sensitive(vc_req->req_data);
 		kfree(vc_req->sgs);
 	}
 }
diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 7b3f21a40d78..a7c7c726e6d9 100644
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
@@ -450,7 +445,6 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 free_iv:
 	kfree_sensitive(iv);
 free:
-	kfree_sensitive(req_data);
 	kfree(sgs);
 	return err;
 }
-- 
2.39.3

