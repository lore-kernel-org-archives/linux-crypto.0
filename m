Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5042E7E1
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675250; cv=none; b=fPJvF6F7x+6GxZEnnqg5YCuX8luJCRx/rz4Vtni1/8Zez8fp3JoVISPMRrvd3uPB3RkHpMfrJpQ0MA/ZOeGgi+/Kxxc+IXtzHTTQqSqYE3HThzO5BK918M9jPBC33a1R5N6hc+us9EIi8uZLlkU2du1fLEnYxbemM14c6uR6mhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675250; c=relaxed/simple;
	bh=PPJR8P5RQRLlbn7T1W0+NiGHFT0qPn6JyhQBqNbAlbU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Ihm1nwBpz4DlOcK/eiyajF69wMY2o2+ASAMLxNalflo6acLiS3Q/yzMZLCbJwFQ5Zp+wBJ8LuHvBURkfDe4timaVsON5lr1t3Zi0As6tLpjcYZVFQUN4EGmYtgYb9hcOr4W0FUDRSoZKUYXjgD/3baKQ+XRHpW8aA8ASAXMZnAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IMpqNtIl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IMpqNtIl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FGKxPWwVEcqQqOc0ZVw4JhKmYFcoBhe/DT7hf3S6hE8=; b=IMpqNtIlUfnhyKqSGUqD+pol2+
	9r8+OV3SqP1ebXCBuz5JfvEarXbB8Vz4hddTrINbpVyp71c4AevoVu8ACYudNp9DNGOgcPc3Xg9ZP
	TN2+y5Rt4JC7hPCnfC9igsISLKSooFMkQbd7E57Vzw2VNYZIIjlKnnkr+f8ty03rZKTqBSslGcFGA
	udNlrBmMIVofQeDHGu2f+4I/orFEkgKePKyud76XgJxtg9KyHEvY9poq3hg38GEYYXzLVVLAFlqqx
	Uzo2MoknfRl3cqbOKKfWbqXSQLQotTG7SLEJ+v7Z6RUGOik6+yEdprdG/lvzDAHSTuznV75de8/wN
	OPlobEkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnD-000gYv-2C;
	Sun, 16 Feb 2025 11:07:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:24 +0800
Date: Sun, 16 Feb 2025 11:07:24 +0800
Message-Id: <91e2551c839a649fea10a171d9ae0dde104e5679.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 06/11] crypto: ahash - Set default reqsize from ahash_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a reqsize field to struct ahash_alg and use it to set the
default reqsize so that algorithms with a static reqsize are
not forced to create an init_tfm function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        | 4 ++++
 include/crypto/hash.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 40ccaf4c0cd6..6b19fa6fc628 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -862,6 +862,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+	crypto_ahash_set_reqsize(hash, alg->reqsize);
 
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
@@ -1027,6 +1028,9 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
+	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 4e87e39679cb..2aa83ee0ec98 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -135,6 +135,7 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
+ * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -151,6 +152,8 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
+	unsigned int reqsize;
+
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5

