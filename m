Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB10E16D31C;
	Mon, 12 Aug 2024 10:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458888; cv=none; b=Yw9aEdkSVLktiwZfBGkiQP3aZ5oKIMH7gcXAIwEbDLiqEfWS9qAaxo5aSwa6eCxYzFQIeW8PCAGwRSzgrLjh7tuC+f4UxuqcV1cusW7XeWIbSiiE9IMagZDbAXJZ1ao6UjAvY+AxSWCEMBJGzYJPk1afNgXZoa/miMXbt+Q5B5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458888; c=relaxed/simple;
	bh=a3AQjWPHSuyn2SNOxuFOQEH1yCSPdGp+Gopjd5Bdh/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyqdBd3gs9LrLWjLhmBzov6jytXMkVpOeq7ZlltZyGDVGj4JSK5g4QwKd2Ur8CfsVZxnhzi5a4Bdfsjx5q9cEd/v1oYGqz5fE7oj16fD3EnqyohJlX+bF35L8m5N7wc77d+SYeoJEEaHxvTwaLwxJYIA/kU+WJiHSDXMDWZwN4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sdSFO-0044zD-0v;
	Mon, 12 Aug 2024 18:34:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Aug 2024 18:34:39 +0800
Date: Mon, 12 Aug 2024 18:34:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: [v2 PATCH 1/3] crypto: api - Remove instance larval fulfilment
Message-ID: <ZrnlP4itTulcIYqP@gondor.apana.org.au>
References: <ZrbTfOViUr3S4V7X@gondor.apana.org.au>
 <34069b9d-3731-4d0c-b317-bcbc61df7e9d@stanley.mountain>
 <Zrnk6Y8IDxmN99kG@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zrnk6Y8IDxmN99kG@gondor.apana.org.au>

In order to allow testing to complete asynchronously after the
registration process, instance larvals need to complete prior
to having a test result.  Support this by redoing the lookup for
instance larvals after completion.   This should locate the pending
test larval and then repeat the wait on that (if it is still pending).

As the lookup is now repeated there is no longer any need to compute
the fulfilment status and all that code can be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c | 48 +++---------------------------------------------
 crypto/api.c    | 23 +++++++++++++++++++----
 2 files changed, 22 insertions(+), 49 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 122cd910c4e1..d2ccc1289f92 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -235,7 +235,6 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 EXPORT_SYMBOL_GPL(crypto_remove_spawns);
 
 static void crypto_alg_finish_registration(struct crypto_alg *alg,
-					   bool fulfill_requests,
 					   struct list_head *algs_to_put)
 {
 	struct crypto_alg *q;
@@ -247,30 +246,8 @@ static void crypto_alg_finish_registration(struct crypto_alg *alg,
 		if (crypto_is_moribund(q))
 			continue;
 
-		if (crypto_is_larval(q)) {
-			struct crypto_larval *larval = (void *)q;
-
-			/*
-			 * Check to see if either our generic name or
-			 * specific name can satisfy the name requested
-			 * by the larval entry q.
-			 */
-			if (strcmp(alg->cra_name, q->cra_name) &&
-			    strcmp(alg->cra_driver_name, q->cra_name))
-				continue;
-
-			if (larval->adult)
-				continue;
-			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
-				continue;
-
-			if (fulfill_requests && crypto_mod_get(alg))
-				larval->adult = alg;
-			else
-				larval->adult = ERR_PTR(-EAGAIN);
-
+		if (crypto_is_larval(q))
 			continue;
-		}
 
 		if (strcmp(alg->cra_name, q->cra_name))
 			continue;
@@ -359,7 +336,7 @@ __crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
 		list_add(&larval->alg.cra_list, &crypto_alg_list);
 	} else {
 		alg->cra_flags |= CRYPTO_ALG_TESTED;
-		crypto_alg_finish_registration(alg, true, algs_to_put);
+		crypto_alg_finish_registration(alg, algs_to_put);
 	}
 
 out:
@@ -376,7 +353,6 @@ void crypto_alg_tested(const char *name, int err)
 	struct crypto_alg *alg;
 	struct crypto_alg *q;
 	LIST_HEAD(list);
-	bool best;
 
 	down_write(&crypto_alg_sem);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
@@ -408,25 +384,7 @@ void crypto_alg_tested(const char *name, int err)
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
-	/*
-	 * If a higher-priority implementation of the same algorithm is
-	 * currently being tested, then don't fulfill request larvals.
-	 */
-	best = true;
-	list_for_each_entry(q, &crypto_alg_list, cra_list) {
-		if (crypto_is_moribund(q) || !crypto_is_larval(q))
-			continue;
-
-		if (strcmp(alg->cra_name, q->cra_name))
-			continue;
-
-		if (q->cra_priority > alg->cra_priority) {
-			best = false;
-			break;
-		}
-	}
-
-	crypto_alg_finish_registration(alg, best, &list);
+	crypto_alg_finish_registration(alg, &list);
 
 complete:
 	complete_all(&test->completion);
diff --git a/crypto/api.c b/crypto/api.c
index 22556907b3bc..ffb81aa32725 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -37,6 +37,8 @@ DEFINE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
 #endif
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
+					    u32 mask);
 
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
 {
@@ -201,9 +203,12 @@ static void crypto_start_test(struct crypto_larval *larval)
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 {
-	struct crypto_larval *larval = (void *)alg;
+	struct crypto_larval *larval;
 	long time_left;
 
+again:
+	larval = container_of(alg, struct crypto_larval, alg);
+
 	if (!crypto_boot_test_finished())
 		crypto_start_test(larval);
 
@@ -215,9 +220,16 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 		alg = ERR_PTR(-EINTR);
 	else if (!time_left)
 		alg = ERR_PTR(-ETIMEDOUT);
-	else if (!alg)
-		alg = ERR_PTR(-ENOENT);
-	else if (IS_ERR(alg))
+	else if (!alg) {
+		u32 type;
+		u32 mask;
+
+		alg = &larval->alg;
+		type = alg->cra_flags & ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
+		mask = larval->mask;
+		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
+		      ERR_PTR(-ENOENT);
+	} else if (IS_ERR(alg))
 		;
 	else if (crypto_is_test_larval(larval) &&
 		 !(alg->cra_flags & CRYPTO_ALG_TESTED))
@@ -228,6 +240,9 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 		alg = ERR_PTR(-EAGAIN);
 	crypto_mod_put(&larval->alg);
 
+	if (!IS_ERR(alg) && crypto_is_larval(alg))
+		goto again;
+
 	return alg;
 }
 
-- 
2.39.2

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
