Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E606C44C4E6
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931110; cv=none; b=IrVEsJEEid60NbCwl7jJrq+6DMzp/Y5dPCqVEMsnnK2idqYiLKhanqSRaLDKzmmdwllX+epP4Wg5wLoB4cx9siQ+w6R9hPWAf0WIraGrkngyXU1BDaRwKboFD8Lqi4kHC6z0O71E21TKqB++tCo/GaEjXJmfdDwy36b2t032JzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931110; c=relaxed/simple;
	bh=L8ZpOpEgHP/uX6NDcQAlL46I/EkO9GCCwX+fBds8aQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bel2wE5nYgWSAHxsslORUZgFvbm5ZvUqdSOd1QhhOKm3ReI1jl6A7SiC1bQvj6fa5pgmoV0cun/aN0HwcAw4s5IHPaRgqxBH7ojy4XHI6BAHeki9q2GLxEHRVaHip/8Oxag2ZR9kb4kvqvVSric0+jI665bak0h1fmDGtE7RSGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0ptb+S1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0ptb+S1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIa1q/rwVv4YV5P2Dz7HZPw1sN5kuVFBHsiGPLc7Ll0=;
	b=C0ptb+S17I/IJQ0a0X747NZ09NFwMkSZNiDMHISgCj3mLZUsRjKNlGBkTGWuUeXUcLoXjr
	As29WGUcHaRjpl7dMVX5FGK2JWVxiFr0gdIg6GUd4yDdNsditAr1QAmxR9IEOJvxBWEb63
	10b6gcE4CINHLOWeFSCdU6LjLJ8qsPY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-O2e2e1G1MlqpJBIwaZCyfQ-1; Wed,
 05 Aug 2026 07:58:24 -0400
X-MC-Unique: O2e2e1G1MlqpJBIwaZCyfQ-1
X-Mimecast-MFC-AGG-ID: O2e2e1G1MlqpJBIwaZCyfQ_1785931103
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AD3D1956088;
	Wed,  5 Aug 2026 11:58:23 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7E2930001A2;
	Wed,  5 Aug 2026 11:58:21 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 10/10] crypto: safexcel - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Wed,  5 Aug 2026 13:57:48 +0200
Message-ID: <20260805115749.392672-11-thuth@redhat.com>
In-Reply-To: <20260805115749.392672-1-thuth@redhat.com>
References: <20260805115749.392672-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

The code clears the crypto_aes_ctx in most cases already with
memzero_explicit(), but safexcel_skcipher_aesxts_setkey() runs
aes_expandkey() twice, and in case the second call fails, the
context from the first call is leaked.

To fix this issue and to avoid future similar problems, let's use
the new __cleanup(aes_zeroize_ctx) mechanism to make sure that we
always clear the crypto_aes_ctx in all cases.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 13 ++++---------
 drivers/crypto/inside-secure/safexcel_hash.c   |  3 +--
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index e94686490bb27..50e8792b399de 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -375,7 +375,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
@@ -396,7 +396,6 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = len;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -1357,7 +1356,7 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	int ret, i;
 	unsigned int keylen;
 
@@ -1383,7 +1382,6 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = keylen;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -2537,7 +2535,7 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	int ret, i;
 	unsigned int keylen;
 
@@ -2585,7 +2583,6 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = keylen << 1;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -2751,12 +2748,11 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
-		memzero_explicit(&aes, sizeof(aes));
 		return ret;
 	}
 
@@ -2785,7 +2781,6 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 	else
 		ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3402e570d045c..20c17eb09495e 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1905,7 +1905,7 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 				 unsigned int len)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
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

