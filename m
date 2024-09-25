Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAAB188CBC;
	Wed, 25 Sep 2024 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265604; cv=none; b=hZu8UU/tlK/g2Q5a/GxaU3BI9wcXmxm/V0dxvvr9paziK9y3CgOU77O9SEZN5S51NHf+5Vq44vejA+Tl7OdNNb/F2VHiS0NyqsycPmTpPuaxHT6lySdgB4bN87X5k0/SBLZUwholOCOw+VHP7pF4p9Xr305LaGj2lpdRtJckuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265604; c=relaxed/simple;
	bh=danRxNEwCBNhHmGNlVwhkZHk/Q9xGvHDOSjgsq/3ibc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAp5UwhF9JsFufrnRjs/uwxTeVLaecy6hLkZayQqVgC++i3QagO5wOK/oNzQjiHlt4oL0tOM4LM5UPRhPrfqGU0Htq+LIvr195NXCzTcc55qACQ71TPjJTNMY+z34rG3ri3X9hlmZuWDI+dFqQuOaPu89vCA6p2SEsfXKeN0tL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxkkzr7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxkkzr7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D45EC4CEC3;
	Wed, 25 Sep 2024 12:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265604;
	bh=danRxNEwCBNhHmGNlVwhkZHk/Q9xGvHDOSjgsq/3ibc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxkkzr7L/oJ8wPvB33ZGCpbacfASl9IBzokwzKkxVbAFiXfIslzPjIbPluSuEOICH
	 BSAjFzFSDrdFgTy0CKFizkyVMP64YeBCCsNq5EB68uDUnuNF4bun9yUiH7DIHmqXZa
	 39ZleEOI9wlJ+4SgPewugNrw59hpf0QhgywwH1SRy3wqn0opAwtfHGC1e52Uen6gFr
	 /7pPMvilYImhaT6SAMlcLEULNJ9+TMRhnOxxcv0FdB7aRW20yxN6Uvr0qvDLbkPR42
	 0XXme+vLpXCDPIAr631EpHi73zOyiqEozd8brNJxyuAo+5vZxHkKHN6phEpOVOdFHP
	 ev8Iy4IVoTJgA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux@armlinux.org.uk,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.10 046/197] crypto: simd - Do not call crypto_alloc_tfm during registration
Date: Wed, 25 Sep 2024 07:51:05 -0400
Message-ID: <20240925115823.1303019-46-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3c44d31cb34ce4eb8311a2e73634d57702948230 ]

Algorithm registration is usually carried out during module init,
where as little work as possible should be carried out.  The SIMD
code violated this rule by allocating a tfm, this then triggers a
full test of the algorithm which may dead-lock in certain cases.

SIMD is only allocating the tfm to get at the alg object, which is
in fact already available as it is what we are registering.  Use
that directly and remove the crypto_alloc_tfm call.

Also remove some obsolete and unused SIMD API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/aes-ce-glue.c     |  2 +-
 arch/arm/crypto/aes-neonbs-glue.c |  2 +-
 crypto/simd.c                     | 76 ++++++-------------------------
 include/crypto/internal/simd.h    | 12 +----
 4 files changed, 19 insertions(+), 73 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index b668c97663ec0..f5b66f4cf45d9 100644
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
index f00f042ef3570..0ca94b90bc4ec 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -539,7 +539,7 @@ static int __init aes_init(void)
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algname, drvname, basename);
+		simd = simd_skcipher_create_compat(aes_algs + i, algname, drvname, basename);
 		err = PTR_ERR(simd);
 		if (IS_ERR(simd))
 			goto unregister_simds;
diff --git a/crypto/simd.c b/crypto/simd.c
index edaa479a1ec5e..d109866641a26 100644
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
-}
-EXPORT_SYMBOL_GPL(simd_aead_create_compat);
-
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
+	goto out;
 }
-EXPORT_SYMBOL_GPL(simd_aead_create);
 
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
index d2316242a9884..be97b97a75dd2 100644
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
2.43.0

