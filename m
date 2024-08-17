Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDD22F23;
	Sat, 17 Aug 2024 06:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723877922; cv=none; b=fi+M/ah9rhdzm8HNkobq3+sargiwWf2jX6sbPscC4HL3eEK74Ax9s9a7b/PpzWRjVyXN1FgxViDpgyoZf3aiSzytTUE0S7CPX6P+x8nkCQcJWbOHKPBawAWArj94zs0O9hpb25ou0A1jLCFTIRD5Y7J+ziQl2SjS0Fzqu50XXpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723877922; c=relaxed/simple;
	bh=PCTL5XS2xFWyQkf6SVa0tbNasyGO31eQN1pkr0nZ2Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZLEg+cGC1hx36TCBLS0G57yqeB3LTWDwhjjWhgsNslQUY9mVeKns6A3X7cWcH6Ory43uMRJd6rnp0sViuWRxCnFhDT+eiX6iwC8C4J/Wxia9xEmaUMoykgA44AP8TgOViAXPF6el5KFc68s9aFcDKuBOaDRxBCUHPZ8ZPgcYVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDG2-005IFX-2D;
	Sat, 17 Aug 2024 14:58:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 14:58:35 +0800
Date: Sat, 17 Aug 2024 14:58:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	ltp@lists.linux.it, Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [v3 PATCH 3/3] crypto: simd - Do not call crypto_alloc_tfm during
 registration
Message-ID: <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
References: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
 <202408161634.598311fd-oliver.sang@intel.com>
 <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsBJ5H4JExArHGVw@gondor.apana.org.au>

Algorithm registration is usually carried out during module init,
where as little work as possible should be carried out.  The SIMD
code violated this rule by allocating a tfm, this then triggers a
full test of the algorithm which may dead-lock in certain cases.

SIMD is only allocating the tfm to get at the alg object, which is
in fact already available as it is what we are registering.  Use
that directly and remove the crypto_alloc_tfm call.

Also remove some obsolete and unused SIMD API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/aes-ce-glue.c     |  2 +-
 arch/arm/crypto/aes-neonbs-glue.c |  2 +-
 crypto/simd.c                     | 76 ++++++-------------------------
 include/crypto/internal/simd.h    | 12 +----
 4 files changed, 19 insertions(+), 73 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index b668c97663ec..f5b66f4cf45d 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -711,7 +711,7 @@ static int __init aes_init(void)
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algname, drvname, basename);
+		simd = simd_skcipher_create_compat(aes_algs + i, algname, drvname, basename);
 		err = PTR_ERR(simd);
 		if (IS_ERR(simd))
 			goto unregister_simds;
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index fd04f855b2f5..f6be80b5938b 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -491,7 +491,7 @@ static int __init aes_init(void)
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algname, drvname, basename);
+		simd = simd_skcipher_create_compat(aes_algs + i, algname, drvname, basename);
 		err = PTR_ERR(simd);
 		if (IS_ERR(simd))
 			goto unregister_simds;
diff --git a/crypto/simd.c b/crypto/simd.c
index 2aa4f72e224f..b07721d1f3f6 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -136,27 +136,19 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 	return 0;
 }
 
-struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
+struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
+						      const char *algname,
 						      const char *drvname,
 						      const char *basename)
 {
 	struct simd_skcipher_alg *salg;
-	struct crypto_skcipher *tfm;
-	struct skcipher_alg *ialg;
 	struct skcipher_alg *alg;
 	int err;
 
-	tfm = crypto_alloc_skcipher(basename, CRYPTO_ALG_INTERNAL,
-				    CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return ERR_CAST(tfm);
-
-	ialg = crypto_skcipher_alg(tfm);
-
 	salg = kzalloc(sizeof(*salg), GFP_KERNEL);
 	if (!salg) {
 		salg = ERR_PTR(-ENOMEM);
-		goto out_put_tfm;
+		goto out;
 	}
 
 	salg->ialg_name = basename;
@@ -195,30 +187,16 @@ struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
 	if (err)
 		goto out_free_salg;
 
-out_put_tfm:
-	crypto_free_skcipher(tfm);
+out:
 	return salg;
 
 out_free_salg:
 	kfree(salg);
 	salg = ERR_PTR(err);
-	goto out_put_tfm;
+	goto out;
 }
 EXPORT_SYMBOL_GPL(simd_skcipher_create_compat);
 
-struct simd_skcipher_alg *simd_skcipher_create(const char *algname,
-					       const char *basename)
-{
-	char drvname[CRYPTO_MAX_ALG_NAME];
-
-	if (snprintf(drvname, CRYPTO_MAX_ALG_NAME, "simd-%s", basename) >=
-	    CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
-
-	return simd_skcipher_create_compat(algname, drvname, basename);
-}
-EXPORT_SYMBOL_GPL(simd_skcipher_create);
-
 void simd_skcipher_free(struct simd_skcipher_alg *salg)
 {
 	crypto_unregister_skcipher(&salg->alg);
@@ -246,7 +224,7 @@ int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
 		algname = algs[i].base.cra_name + 2;
 		drvname = algs[i].base.cra_driver_name + 2;
 		basename = algs[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algname, drvname, basename);
+		simd = simd_skcipher_create_compat(algs + i, algname, drvname, basename);
 		err = PTR_ERR(simd);
 		if (IS_ERR(simd))
 			goto err_unregister;
@@ -383,27 +361,19 @@ static int simd_aead_init(struct crypto_aead *tfm)
 	return 0;
 }
 
-struct simd_aead_alg *simd_aead_create_compat(const char *algname,
-					      const char *drvname,
-					      const char *basename)
+static struct simd_aead_alg *simd_aead_create_compat(struct aead_alg *ialg,
+						     const char *algname,
+						     const char *drvname,
+						     const char *basename)
 {
 	struct simd_aead_alg *salg;
-	struct crypto_aead *tfm;
-	struct aead_alg *ialg;
 	struct aead_alg *alg;
 	int err;
 
-	tfm = crypto_alloc_aead(basename, CRYPTO_ALG_INTERNAL,
-				CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return ERR_CAST(tfm);
-
-	ialg = crypto_aead_alg(tfm);
-
 	salg = kzalloc(sizeof(*salg), GFP_KERNEL);
 	if (!salg) {
 		salg = ERR_PTR(-ENOMEM);
-		goto out_put_tfm;
+		goto out;
 	}
 
 	salg->ialg_name = basename;
@@ -442,36 +412,20 @@ struct simd_aead_alg *simd_aead_create_compat(const char *algname,
 	if (err)
 		goto out_free_salg;
 
-out_put_tfm:
-	crypto_free_aead(tfm);
+out:
 	return salg;
 
 out_free_salg:
 	kfree(salg);
 	salg = ERR_PTR(err);
-	goto out_put_tfm;
+	goto out;
 }
-EXPORT_SYMBOL_GPL(simd_aead_create_compat);
 
-struct simd_aead_alg *simd_aead_create(const char *algname,
-				       const char *basename)
-{
-	char drvname[CRYPTO_MAX_ALG_NAME];
-
-	if (snprintf(drvname, CRYPTO_MAX_ALG_NAME, "simd-%s", basename) >=
-	    CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-ENAMETOOLONG);
-
-	return simd_aead_create_compat(algname, drvname, basename);
-}
-EXPORT_SYMBOL_GPL(simd_aead_create);
-
-void simd_aead_free(struct simd_aead_alg *salg)
+static void simd_aead_free(struct simd_aead_alg *salg)
 {
 	crypto_unregister_aead(&salg->alg);
 	kfree(salg);
 }
-EXPORT_SYMBOL_GPL(simd_aead_free);
 
 int simd_register_aeads_compat(struct aead_alg *algs, int count,
 			       struct simd_aead_alg **simd_algs)
@@ -493,7 +447,7 @@ int simd_register_aeads_compat(struct aead_alg *algs, int count,
 		algname = algs[i].base.cra_name + 2;
 		drvname = algs[i].base.cra_driver_name + 2;
 		basename = algs[i].base.cra_driver_name;
-		simd = simd_aead_create_compat(algname, drvname, basename);
+		simd = simd_aead_create_compat(algs + i, algname, drvname, basename);
 		err = PTR_ERR(simd);
 		if (IS_ERR(simd))
 			goto err_unregister;
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index d2316242a988..be97b97a75dd 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -14,11 +14,10 @@
 struct simd_skcipher_alg;
 struct skcipher_alg;
 
-struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
+struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
+						      const char *algname,
 						      const char *drvname,
 						      const char *basename);
-struct simd_skcipher_alg *simd_skcipher_create(const char *algname,
-					       const char *basename);
 void simd_skcipher_free(struct simd_skcipher_alg *alg);
 
 int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
@@ -32,13 +31,6 @@ void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
 struct simd_aead_alg;
 struct aead_alg;
 
-struct simd_aead_alg *simd_aead_create_compat(const char *algname,
-					      const char *drvname,
-					      const char *basename);
-struct simd_aead_alg *simd_aead_create(const char *algname,
-				       const char *basename);
-void simd_aead_free(struct simd_aead_alg *alg);
-
 int simd_register_aeads_compat(struct aead_alg *algs, int count,
 			       struct simd_aead_alg **simd_algs);
 
-- 
2.39.2

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
