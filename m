Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3CA1D79A0
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454873; cv=none; b=JV5QTq6/6t/Ddyypu/Rf1YYZEE0javIjK+2jTvi66alSBSkZz+fk03/bsgdj8qHSVPVs+Vmf4gfFqt4DlkKSwssi9SL4HqdHIGT1EFAkt0TFg7nm7YZBCgt6uZo0+7nis04mEoDDCiqMVDdbaXyO/1+MHR1rWXgSSLkOEIRz5T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454873; c=relaxed/simple;
	bh=GK5kWEUHjKsfS2g8j8oSHVA3ckrV2AGTd61MMCp9eRQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=o3X/sevccD73zPK87UVFgh8Fh7X5LenODtoWWAJXVp3zd/ye4Ll5sHAf/Qf/z1dwcEq86rvfp4cGo9mIIXrahmo43MyAfH5t9DR7vcCQ/LPkM9nnkzG2QLKSTFEqLkzHgVZJvpua+cot1JinMbxpRFPrMeCbcMGbL2UQywlH6rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eb0dAYbg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eb0dAYbg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E++TNNRWDKw7Dr3Vt9aY6SG8S0lXuHvzM5mkYkp6spk=; b=eb0dAYbg8bp1K5uDg1F88WP+nW
	Es2I3fnjpuD++XbTShdaWfMFN7qRaFDLE1puvbYnM13QG+5jQ96zKR5CHsmFzG9mbJPlYHo/U7TX4
	WsBSaRKUBFj3YeV3A9H7nTJI4ioVRaJ0dPFkwWS4goqRqLlby+vWyHcspHvNy5VXNjubLedukD6X3
	q1e9kFSHguMwRuupXNCPi8rJLLaDstA4x3X3y5m1hMNdZ5S/+q4lBpdmIl0ybgCSbsmw6V3181hkW
	1nrCPSTIvsjYFfg6bnR7U+oKTfDJkmKTOtrpJS1ZkZkYDfDUK+d5/O1Xc+efikLcrjnc3JQ3azxGL
	644UE6QQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YOp-00F5EJ-10;
	Sat, 12 Apr 2025 18:47:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:47:47 +0800
Date: Sat, 12 Apr 2025 18:47:47 +0800
Message-Id: <22653813e9cd5c6ba248d0a1de73413bb81b0015.1744454589.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744454589.git.herbert@gondor.apana.org.au>
References: <cover.1744454589.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: shash - Remove dynamic descsize
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As all users of the dynamic descsize have been converted to use
a static one instead, remove support for dynamic descsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/shash.c        | 18 +-----------------
 include/crypto/hash.h |  3 +--
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index a2a7d6609172..f23bd9cb1873 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -153,9 +153,6 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
 	struct shash_alg *alg = crypto_shash_alg(hash);
-	int err;
-
-	hash->descsize = alg->descsize;
 
 	shash_set_needkey(hash, alg);
 
@@ -165,18 +162,7 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 	if (!alg->init_tfm)
 		return 0;
 
-	err = alg->init_tfm(hash);
-	if (err)
-		return err;
-
-	/* ->init_tfm() may have increased the descsize. */
-	if (WARN_ON_ONCE(hash->descsize > HASH_MAX_DESCSIZE)) {
-		if (alg->exit_tfm)
-			alg->exit_tfm(hash);
-		return -EINVAL;
-	}
-
-	return 0;
+	return alg->init_tfm(hash);
 }
 
 static void crypto_shash_free_instance(struct crypto_instance *inst)
@@ -274,8 +260,6 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 	if (IS_ERR(nhash))
 		return nhash;
 
-	nhash->descsize = hash->descsize;
-
 	if (alg->clone_tfm) {
 		err = alg->clone_tfm(nhash, hash);
 		if (err) {
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index eceb2ed04f26..87518cf3b2d8 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -235,7 +235,6 @@ struct crypto_ahash {
 };
 
 struct crypto_shash {
-	unsigned int descsize;
 	struct crypto_tfm base;
 };
 
@@ -810,7 +809,7 @@ static inline void crypto_shash_clear_flags(struct crypto_shash *tfm, u32 flags)
  */
 static inline unsigned int crypto_shash_descsize(struct crypto_shash *tfm)
 {
-	return tfm->descsize;
+	return crypto_shash_alg(tfm)->descsize;
 }
 
 static inline void *shash_desc_ctx(struct shash_desc *desc)
-- 
2.39.5

