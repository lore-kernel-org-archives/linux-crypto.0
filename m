Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEE41D5176
	for <linux-crypto@vger.kernel.org>; Mon,  3 Feb 2025 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738590469; cv=none; b=n+U+qtA/+ioBlz2OQ9ZM9cNKCQY1nIUvyFXamb/3SXozbgHC0tCRWv0HnKNTVDY3HGLyDmCFhBHFa4kfVdN4ajg3fk0KgvLpyf9Ecbs6/FiuoRf8581ILsSmlxhTaHgdlU02JlYkwv91dLXZzQm/g5vqRNm3Ow/r/J7UG4wlqXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738590469; c=relaxed/simple;
	bh=Ux/eyBmuGVWC2Lvb1Wmp2yLi4jZRCp2s22AK0n981Uk=;
	h=Message-ID:In-Reply-To:References:From:Date:Subject:To:Cc; b=LvATu0wLiIlNGEtmat3oyUIiFV0yJL6MszdLKhjFi6TNNtTpExNW6nD/Gsz0+UKkmr/Sqe2ePfT3VDI9luo39Dr/gjK1Rr+KA2LEJeDQCVMDnbrQKNCZhzzn820GAryyDfKD1FKW0XQtTx71bcG2xf9TsoVhkM8X5yr1BrSzYkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id B4C50101920D8;
	Mon,  3 Feb 2025 14:47:44 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by h08.hostsharing.net (Postfix) with ESMTPSA id 8967C63AEEE5;
	Mon,  3 Feb 2025 14:47:44 +0100 (CET)
X-Mailbox-Line: From d9abd97c2d407c9398d016c26f2d8c5fb3111c52 Mon Sep 17 00:00:00 2001
Message-ID: <d9abd97c2d407c9398d016c26f2d8c5fb3111c52.1738562694.git.lukas@wunner.de>
In-Reply-To: <cover.1738562694.git.lukas@wunner.de>
References: <cover.1738562694.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 3 Feb 2025 14:37:02 +0100
Subject: [PATCH 2/5] crypto: virtio - Simplify RSA key size caching
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Gonglei <arei.gonglei@huawei.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio Perez <eperezma@redhat.com>, linux-crypto@vger.kernel.org, virtualization@lists.linux.dev
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

When setting a public or private RSA key, the integer n is cached in the
transform context virtio_crypto_akcipher_ctx -- with the sole purpose of
calculating the key size from it in virtio_crypto_rsa_max_size().
It looks like this was copy-pasted from crypto/rsa.c.

Cache the key size directly instead of the integer n, thus simplifying
the code and reducing the memory footprint.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 .../virtio/virtio_crypto_akcipher_algs.c      | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 48fee07b7e51..7fdf32c79909 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -21,7 +21,7 @@
 #include "virtio_crypto_common.h"
 
 struct virtio_crypto_rsa_ctx {
-	MPI n;
+	unsigned int key_size;
 };
 
 struct virtio_crypto_akcipher_ctx {
@@ -352,10 +352,7 @@ static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
 	int node = virtio_crypto_get_current_node();
 	uint32_t keytype;
 	int ret;
-
-	/* mpi_free will test n, just free it. */
-	mpi_free(rsa_ctx->n);
-	rsa_ctx->n = NULL;
+	MPI n;
 
 	if (private) {
 		keytype = VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
@@ -368,10 +365,13 @@ static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
 	if (ret)
 		return ret;
 
-	rsa_ctx->n = mpi_read_raw_data(rsa_key.n, rsa_key.n_sz);
-	if (!rsa_ctx->n)
+	n = mpi_read_raw_data(rsa_key.n, rsa_key.n_sz);
+	if (!n)
 		return -ENOMEM;
 
+	rsa_ctx->key_size = mpi_get_size(n);
+	mpi_free(n);
+
 	if (!ctx->vcrypto) {
 		vcrypto = virtcrypto_get_dev_node(node, VIRTIO_CRYPTO_SERVICE_AKCIPHER,
 						VIRTIO_CRYPTO_AKCIPHER_RSA);
@@ -442,7 +442,7 @@ static unsigned int virtio_crypto_rsa_max_size(struct crypto_akcipher *tfm)
 	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct virtio_crypto_rsa_ctx *rsa_ctx = &ctx->rsa_ctx;
 
-	return mpi_get_size(rsa_ctx->n);
+	return rsa_ctx->key_size;
 }
 
 static int virtio_crypto_rsa_init_tfm(struct crypto_akcipher *tfm)
@@ -460,12 +460,9 @@ static int virtio_crypto_rsa_init_tfm(struct crypto_akcipher *tfm)
 static void virtio_crypto_rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct virtio_crypto_rsa_ctx *rsa_ctx = &ctx->rsa_ctx;
 
 	virtio_crypto_alg_akcipher_close_session(ctx);
 	virtcrypto_dev_put(ctx->vcrypto);
-	mpi_free(rsa_ctx->n);
-	rsa_ctx->n = NULL;
 }
 
 static struct virtio_crypto_akcipher_algo virtio_crypto_akcipher_algs[] = {
-- 
2.43.0

