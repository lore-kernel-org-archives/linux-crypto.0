Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F43AE706
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086471; cv=none; b=lhH8Y9mExfG0xsgKIHkolmLPjmzuM3YWSGZs+8njxwHMpZhYJuEAqmdRWtwdBCgJbSskbjLNV2nzAF4pT+fNvyqiwNudkQ9aS5CYxRs574J9A7iNOXm4kW+/CkInY7l8PwC6A09ImySbZPFhCs6K7CuD2okmbWhtxA077CpQQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086471; c=relaxed/simple;
	bh=qaIAfsiAYVelb8ir4pJGXETIHK/Ms2Y2sK1ev3Z67YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD/twUQvp2x5ogT8638TbfEnc2Sdpc5ORf9T7lfHGPcQ5RVhoR4K1fDqwJpN9c2Vj2OPIPJ70b67st4XagFEjbM8a3E3HX/oSwYJndKCeOVo2tEvmMLZf250NYJp7vce93P+2X/LID53F1vNqVIGO6lR7VxaXd9lsz5vwm0KF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eodPsZUR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eodPsZUR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys+EVzugstWp0eJuLjZlXzo7HqH8hJNda9tOTt9y8Qw=;
	b=eodPsZURzhN4dioABav4PKn2mVd2c1SHJhGe9FjN8gXIVQ8Fw7B2qEJ6G+vIpj0M3JzqgR
	bO9irgu6T1ttU0jUXfP+ttTlunIVvPVB30lO0lFW3Z9oG5tGx57Hoak6IkeHcFmF6rqDJ4
	XBBssKeIk4bU1uo3PAPMUQgNBwdHx8Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-73bp8dHcML6W9_K9DOL0ug-1; Fri,
 07 Aug 2026 03:07:45 -0400
X-MC-Unique: 73bp8dHcML6W9_K9DOL0ug-1
X-Mimecast-MFC-AGG-ID: 73bp8dHcML6W9_K9DOL0ug_1786086461
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EB431800149;
	Fri,  7 Aug 2026 07:07:41 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E2A51956094;
	Fri,  7 Aug 2026 07:07:38 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/10] crypto: safexcel - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
Date: Fri,  7 Aug 2026 09:06:37 +0200
Message-ID: <20260807070651.228713-11-thuth@redhat.com>
In-Reply-To: <20260807070651.228713-1-thuth@redhat.com>
References: <20260807070651.228713-1-thuth@redhat.com>
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
index c331d81ac8a2d..54ab08aea7536 100644
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

