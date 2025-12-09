Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3953016EB;
	Tue,  9 Dec 2025 02:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245617; cv=none; b=fgxk9HEqGPzI7VEmziNYPHbKj14zyeNA/SCr71r9SnLsBDGFnwxQVFYKb7DnGl6vGgMO0JRazLh69JQb3lOOeR6ycJfsoD39PLB/OeLb57UXt3QYCGI1mdVoeucldrCNkGiGDqeBOcTCyu9J9ExkxXUnZTKYEWo5iDspPeQOfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245617; c=relaxed/simple;
	bh=/L8zx1/xYUxLfG4+CNqLMESgm+GHvnGTKbXq26oS//Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ECz40FQ8d4ibCoNrKiMch64RlK/5POOconU/g8BMoPTZyqXrGJVyGvYKFRZG47jS1TXF4Gk7dIZyYioxKGv3y4BVimWzLb+mN7C0Ob8x5Nb8rsuFOMk6PV5aJnazDUxp4r40eAip/wvxUnoHQhrQD7rmeOTxjsBLnVPloHLRwEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dx9tCsgjdpb4EsAA--.25385S3;
	Tue, 09 Dec 2025 10:00:12 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxXMGpgjdpNkBHAQ--.4873S2;
	Tue, 09 Dec 2025 10:00:10 +0800 (CST)
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
Subject: [PATCH v3 08/10] crypto: virtio: Add IV buffer in structure virtio_crypto_sym_request
Date: Tue,  9 Dec 2025 09:59:48 +0800
Message-Id: <20251209015951.4174743-9-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxXMGpgjdpNkBHAQ--.4873S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add IV buffer in structure virtio_crypto_sym_request to avoid unnecessary
IV buffer allocation in encrypt/decrypt process. And IV buffer is cleared
when encrypt/decrypt is finished.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c       | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index bf9fdf56c2a3..3d47e7c30c6b 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -30,9 +30,9 @@ struct virtio_crypto_sym_request {
 
 	/* Cipher or aead */
 	uint32_t type;
-	uint8_t *iv;
 	/* Encryption? */
 	bool encrypt;
+	uint8_t iv[0];
 };
 
 struct virtio_crypto_algo {
@@ -402,12 +402,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	 * Avoid to do DMA from the stack, switch to using
 	 * dynamically-allocated for the IV
 	 */
-	iv = kzalloc_node(ivsize, GFP_ATOMIC,
-				dev_to_node(&vcrypto->vdev->dev));
-	if (!iv) {
-		err = -ENOMEM;
-		goto free;
-	}
+	iv = vc_sym_req->iv;
 	memcpy(iv, req->iv, ivsize);
 	if (!vc_sym_req->encrypt)
 		scatterwalk_map_and_copy(req->iv, req->src,
@@ -416,7 +411,6 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 
 	sg_init_one(&iv_sg, iv, ivsize);
 	sgs[num_out++] = &iv_sg;
-	vc_sym_req->iv = iv;
 
 	/* Source data */
 	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
@@ -443,7 +437,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	return 0;
 
 free_iv:
-	kfree_sensitive(iv);
+	memzero_explicit(iv, ivsize);
 free:
 	memzero_explicit(req_data, sizeof(*req_data));
 	kfree(sgs);
@@ -502,8 +496,10 @@ static int virtio_crypto_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	int size;
 
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct virtio_crypto_sym_request));
+	size = sizeof(struct virtio_crypto_sym_request) + crypto_skcipher_ivsize(tfm);
+	crypto_skcipher_set_reqsize(tfm, size);
 	ctx->alg = container_of(alg, struct virtio_crypto_algo, algo.base);
 
 	return 0;
@@ -551,7 +547,7 @@ static void virtio_crypto_skcipher_finalize_req(
 		scatterwalk_map_and_copy(req->iv, req->dst,
 					 req->cryptlen - ivsize,
 					 ivsize, 0);
-	kfree_sensitive(vc_sym_req->iv);
+	memzero_explicit(vc_sym_req->iv, ivsize);
 	virtcrypto_clear_request(&vc_sym_req->base);
 
 	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
-- 
2.39.3

