Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE61937C108
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 09:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750328; cv=none; b=DzwPHnue4TRbUyOziNCDiWLihGFxkH35fooFRXRsPl7CHfVy6Bo/iJxO52vWUu0SazbybdORRqqZcvXc3yGBkvyAVhFlFzlNdwUMewK8qhEfMT1X0Nz6oHkj0cKZHwtV46PX8PoASrIE6uWlBD+K7McrSrJxWZmq5jcUcUqfoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750328; c=relaxed/simple;
	bh=KxsvhumK4s3tw3Er5p0b5F38MiorgxJ4jQR1poItIjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnDGm0U9lDhXkZk3MpbU/V1gQxkBlFo6lUGdpEA54Ic0i4U6SkubriZjnEeMlimw3QTvr9U64QOPhp9uZn/4SWLIol0hTw7UOS6XtPnDqtHyKofoFwIQQRK8hS2U92WSpUIapOIWCrowSeWNUQmbyiCaNHzJ/bdpBpUOfyHq6UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dGZu+dx8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dGZu+dx8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785750325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KQ0+OJ5RmnRaSRsooNlQiduy9YrkCjgJuqwW/tXaUM=;
	b=dGZu+dx8+6Ad9yy+tvF054M2VtH1tv3BPFVEsaQiVz29I6wNcExeY7tb6dyig/nKH/W+ap
	k2rXUuh3HfuvH5rr+40AOuGU3dQ1wS8UDtFYWW+CA1bvO5P8zuTg0oRfOp7U4opza6XWSz
	vopoqlhqPDWlslo8BaJJtccZIsN9Wdw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-w65f0Gx6O7S8iK9U9Q_7nQ-1; Mon,
 03 Aug 2026 05:45:19 -0400
X-MC-Unique: w65f0Gx6O7S8iK9U9Q_7nQ-1
X-Mimecast-MFC-AGG-ID: w65f0Gx6O7S8iK9U9Q_7nQ_1785750318
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0171819560B7;
	Mon,  3 Aug 2026 09:45:18 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.213])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F2461956087;
	Mon,  3 Aug 2026 09:45:14 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Cc: Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 8/9] crypto: safexcel - zeroize crypto_aes_ctx with __cleanup(aes_clear_ctx)
Date: Mon,  3 Aug 2026 11:44:27 +0200
Message-ID: <20260803094432.70505-9-thuth@redhat.com>
In-Reply-To: <20260803094432.70505-1-thuth@redhat.com>
References: <20260803094432.70505-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

The code clears the crypto_aes_ctx in most cases already with
memzero_explicit(), but two cases are missed:

1) safexcel_aead_setkey() never cleared it
2) safexcel_skcipher_aesxts_setkey() runs aes_expandkey() twice, and in
   case the second call fails, the context from the first call is leaked

To fix these and to avoid future similar problems, let's use the new
__cleanup(aes_clear_ctx) mechanism to make sure that we clear the
crypto_aes_ctx everywhere.

Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 15 +++++----------
 drivers/crypto/inside-secure/safexcel_hash.c   |  3 +--
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a8349b684693e..2d21ef388beaf 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -375,7 +375,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
@@ -396,7 +396,6 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = len;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -407,7 +406,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_authenc_keys keys;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	int err = -EINVAL, i;
 	const char *alg;
 
@@ -1362,7 +1361,7 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	int ret, i;
 	unsigned int keylen;
 
@@ -1388,7 +1387,6 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = keylen;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -2542,7 +2540,7 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	int ret, i;
 	unsigned int keylen;
 
@@ -2590,7 +2588,6 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = keylen << 1;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -2756,12 +2753,11 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
-		memzero_explicit(&aes, sizeof(aes));
 		return ret;
 	}
 
@@ -2790,7 +2786,6 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 	else
 		ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3402e570d045c..d3b701c96d871 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1905,7 +1905,7 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 				 unsigned int len)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_clear_ctx);
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
@@ -1928,7 +1928,6 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 	ctx->cbcmac  = true;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
-- 
2.55.0

