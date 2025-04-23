Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3CA1F4CA6
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 09:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400158; cv=none; b=K49mhKpz6H/3Xkh1wwsgDCv3QIYdkPE1535T1hRSpAuE7k/aPlauQwDuwVsewkbE5g6k8el2l3NOd0snNGeJzeCqWCGmePEwZ0dRkAL8qeUsyGIpufWQQ5zmtPss2LSKBQC+U6BWHjxUqb1UdH/tf1bdVrRXwX3C1VdyvPshL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400158; c=relaxed/simple;
	bh=fHNDMRknqW0EpyB3T4l1+CVYOFbfyJ9eXO3yYoOX6ZA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=VEWm4UcxkFd4hzRea2pyPIeUpLQC9Cp3UNqZkzU+u2HS1Aoc3jeYKUySBPhGR9wkztObgqdOv3LK3nXhKTnwcs2uaRE2ef4vaDFzky0dTGM+5OKQ0sVGUjBbFhBqmgIkK01K2bp5JNuBvvQ9bRzWD2/qdtIgOLaDcVMtSulLNWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lIstfKsd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lIstfKsd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4+MErWx14BFF7rNkL+lpi9IvjGHhZ8Tp8bDiHnU2Wrg=; b=lIstfKsdKoQCnkuUDFsfhwIXvL
	wA8DkD5Taf/Lzd7x3MvofZFzhEW9jQQ/WYEPZ4wMZxSsAM7JM6Z4+IgvubTUKqMF26HgSYpzGamuM
	NvYR6jp5s73k9Cmj1gVNw3jlIR6o8hfIm+mwVh7bMJU+OCNUVxe7PLUA5eQL4kCoG4oaF9Il8pS7I
	N/ks1xezWb38Taphqal4S4JjF9/jKRXCGlbMakMdLwAK5kWf457miLelw0Yf8+kNrBSeL3KF+X7pT
	vw5hihrUtNrLE+UdZ8H3p7vDYITq4R799ruNSPV8Oj1b6Opa0vzqWiUATxzZwG58Kr1B9p0RhFnai
	I0f4D9Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7WJL-000LDx-0T;
	Wed, 23 Apr 2025 17:22:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Apr 2025 17:22:31 +0800
Date: Wed, 23 Apr 2025 17:22:31 +0800
Message-Id: <83673b15be00df2917160c82d285a0c003d8a27d.1745399917.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745399917.git.herbert@gondor.apana.org.au>
References: <cover.1745399917.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: hash - Fix clone error handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Do not copy the exit function in crypto_clone_tfm as it should
only be set after init_tfm or clone_tfm has succeeded.

Move the setting into crypto_clone_ahash and crypto_clone_shash
instead.

Also clone the fb if necessary.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 19 +++++++++++++++++--
 crypto/api.c   |  2 +-
 crypto/shash.c |  3 +++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9b813f7b9177..cc9885d5cfd2 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -877,6 +877,7 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 {
 	struct hash_alg_common *halg = crypto_hash_alg_common(hash);
 	struct crypto_tfm *tfm = crypto_ahash_tfm(hash);
+	struct crypto_ahash *fb = NULL;
 	struct crypto_ahash *nhash;
 	struct ahash_alg *alg;
 	int err;
@@ -906,22 +907,36 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 			err = PTR_ERR(shash);
 			goto out_free_nhash;
 		}
+		crypto_ahash_tfm(nhash)->exit = crypto_exit_ahash_using_shash;
 		nhash->using_shash = true;
 		*nctx = shash;
 		return nhash;
 	}
 
+	if (ahash_is_async(hash)) {
+		fb = crypto_clone_ahash(crypto_ahash_fb(hash));
+		err = PTR_ERR(fb);
+		if (IS_ERR(fb))
+			goto out_free_nhash;
+
+		crypto_ahash_tfm(nhash)->fb = crypto_ahash_tfm(fb);
+	}
+
 	err = -ENOSYS;
 	alg = crypto_ahash_alg(hash);
 	if (!alg->clone_tfm)
-		goto out_free_nhash;
+		goto out_free_fb;
 
 	err = alg->clone_tfm(nhash, hash);
 	if (err)
-		goto out_free_nhash;
+		goto out_free_fb;
+
+	crypto_ahash_tfm(nhash)->exit = crypto_ahash_exit_tfm;
 
 	return nhash;
 
+out_free_fb:
+	crypto_free_ahash(fb);
 out_free_nhash:
 	crypto_free_ahash(nhash);
 	return ERR_PTR(err);
diff --git a/crypto/api.c b/crypto/api.c
index 172e82f79c69..5cd5ec105bb1 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -570,7 +570,7 @@ void *crypto_clone_tfm(const struct crypto_type *frontend,
 
 	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
 	tfm->crt_flags = otfm->crt_flags;
-	tfm->exit = otfm->exit;
+	tfm->fb = tfm;
 
 out:
 	return mem;
diff --git a/crypto/shash.c b/crypto/shash.c
index b6c79a4a044a..c4a724e55d7a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -413,6 +413,9 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 		}
 	}
 
+	if (alg->exit_tfm)
+		crypto_shash_tfm(nhash)->exit = crypto_shash_exit_tfm;
+
 	return nhash;
 }
 EXPORT_SYMBOL_GPL(crypto_clone_shash);
-- 
2.39.5

