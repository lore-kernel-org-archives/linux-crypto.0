Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E403B058C
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354257; cv=none; b=utJ+b9ma9aCQRgn8SkK3r7dXb9LlxhSApVBJqCcCmCAsRrs+k1dPhnv7vrlr/kzmNaW95FrPIov9LuNeP+JQmCv3AQ/ukutD347XE3y1rSVqNnwpa2c6vIsNjr5OmD72eLwhkVefLGL6CQRgPyOF+x7JKebloV/cSjjek8e2onU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354257; c=relaxed/simple;
	bh=mRIq6aOo8Xre5dmapUQRuqQO2Rgcce3ztC5/CcVoVP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il8Ah9/n9r0+Va4YGJAqMozepPvJzGXA7n0CoFbAzl1cMoAIUWE8cEvtVSdBDA/deR92yRF6n8u8CN+WlDUcRiGWCaJGuAI4GIqu/0Fvexd34b0mB6tvuS3Y8ICtSabnA0ukRoo5j1WXACOdhA5V3GjfgOifnOEQI3s6wjnRCd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N367pUFV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N367pUFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCtTLF0JiWbnDet+pboh6iIiYU7Zl/uxYrEoLKTK9go=;
	b=N367pUFVZW7WOmSN4QL4hfBFZwtRYCqpmC3X/m+zAbBSwZma8HEv2w8/xXrSAE1xe4EWrq
	2ttI+35QzxKpzW9xDOqMQ6NCGmNWk6T1+QShbQILqWzTsurvowykDFZpbwYbiurfWuwxGD
	X+/GKOUztS2VwvDRSPYVh8rgMvCBYRE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-bF_nFi62OGCUcFDDhaZobw-1; Mon,
 10 Aug 2026 05:30:49 -0400
X-MC-Unique: bF_nFi62OGCUcFDDhaZobw-1
X-Mimecast-MFC-AGG-ID: bF_nFi62OGCUcFDDhaZobw_1786354248
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9023195608E;
	Mon, 10 Aug 2026 09:30:47 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB4BB3001D38;
	Mon, 10 Aug 2026 09:30:45 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/10] crypto: safexcel - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Mon, 10 Aug 2026 11:30:04 +0200
Message-ID: <20260810093009.608090-10-thuth@redhat.com>
In-Reply-To: <20260810093009.608090-1-thuth@redhat.com>
References: <20260810093009.608090-1-thuth@redhat.com>
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

Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 13 ++++---------
 drivers/crypto/inside-secure/safexcel_hash.c   |  3 +--
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index f07d043c67d45..b031cb9652ec3 100644
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
 
@@ -1361,7 +1360,7 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	int ret, i;
 	unsigned int keylen;
 
@@ -1387,7 +1386,6 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = keylen;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -2541,7 +2539,7 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->base.priv;
-	struct crypto_aes_ctx aes;
+	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
 	int ret, i;
 	unsigned int keylen;
 
@@ -2589,7 +2587,6 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 
 	ctx->key_len = keylen << 1;
 
-	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
@@ -2755,12 +2752,11 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
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
 
@@ -2789,7 +2785,6 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
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

