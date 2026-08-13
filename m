Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D143481250
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629020; cv=none; b=hIJ5Y96Jd8exyCIWhlElJ4QaX3yDK7f7aDphE4i3SQrzLYsdNH70KY6bHfe0gVaeReYTnFkhNavcie5PqjPjUWdKGihx6Rct9mL1/XK72b3WucYkfA/Hq/zD5HUEFtEEfZ6wG9IcTaBQq4GAWqAjKwcFbLDiTd6lceJfNay87As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629020; c=relaxed/simple;
	bh=mRIq6aOo8Xre5dmapUQRuqQO2Rgcce3ztC5/CcVoVP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+OUoLmqqdO8DMVmrFkq0M52JoCIK2QtMzVudNGgRhdkY2tt+r57eSL1cvqqqaJOBN5C+iDeluDot886jNhwQRhr6VRCRXcOcFFxOLdVNUT5nakTHfZVEMBryltHwCv/Yltg2hHbuxbJyNZWPd+Fj2dU7B1KPBYG/1wHGFjea7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nz0/p34Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nz0/p34Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCtTLF0JiWbnDet+pboh6iIiYU7Zl/uxYrEoLKTK9go=;
	b=Nz0/p34YZmYYEfPe/E35ONyd+IH/8H6F3BnHUxqwqJUmTy2KxQN+1f36es9DhLnjvXIS6M
	ZEiycn0NFnrihvrVzQ+ohqfz4km9vmR9g17w91zp8UuAUTtz+WakXlngmTNHGbvPEnZWRr
	LUgPt0AgUCRFGyNoMGm+7fVetO/Kna8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-eRoiWHoIOMSkmxy9-v_Hyw-1; Thu,
 13 Aug 2026 09:50:12 -0400
X-MC-Unique: eRoiWHoIOMSkmxy9-v_Hyw-1
X-Mimecast-MFC-AGG-ID: eRoiWHoIOMSkmxy9-v_Hyw_1786629011
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A8021800742;
	Thu, 13 Aug 2026 13:50:10 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 799F2180049F;
	Thu, 13 Aug 2026 13:50:07 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] crypto: safexcel - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Thu, 13 Aug 2026 15:49:41 +0200
Message-ID: <20260813134953.979481-4-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

