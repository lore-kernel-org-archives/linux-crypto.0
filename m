Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67C2F23;
	Sat, 17 Aug 2024 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723877822; cv=none; b=ogTHW1y8eJc55ay6jlk1VpALBv7SMeDr/8XZzDDA5deMsyMKKf/9Yb0Sv90BEjFRjEhXNpRHuA74QGzv/H1JHRkJENHVdrbBRC58QiPnfDGkxvCBktLrE9tFnldKEEKERUa05kJXCz2dq3waNThXNTJjO7CCzx22786C9PND6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723877822; c=relaxed/simple;
	bh=zUv1rBUZmu5Yn4+YINkeQuhuuWyCBBfTecIy32HYAYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X47wTeMmt8mZB+AkzE61M7jI+ZQREDqLOEqQ7dvdjLLP2pxKP3AJtYe/ishJp+WTQOJfRY7EusgLNaAgeoCdkBd+06ZMcld8+maLry4GtvIVTJ0bX+BJS8aGxYvq6t03g6TLdAusYLpWKYFj53fzIW/Gu1LaD52JZMmTN1/P5cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDEM-005IF8-2C;
	Sat, 17 Aug 2024 14:56:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 14:56:51 +0800
Date: Sat, 17 Aug 2024 14:56:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	ltp@lists.linux.it, Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [v3 PATCH 1/3] crypto: api - Remove instance larval fulfilment
Message-ID: <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
References: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
 <202408161634.598311fd-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202408161634.598311fd-oliver.sang@intel.com>

On Fri, Aug 16, 2024 at 04:45:59PM +0800, kernel test robot wrote:
> 
> kernel test robot noticed "ltp.af_alg03.fail" on:

Thanks for the report.  Indeed the first patch is buggy as the
larval isn't marked as dead upon completion which when paired with
the new re-lookup triggers a dead-lock.  Fix this by adding a DEAD
marking prior to calling complete_all.

---8<---
In order to allow testing to complete asynchronously after the
registration process, instance larvals need to complete prior
to having a test result.  Support this by redoing the lookup for
instance larvals after completion.   This should locate the pending
test larval and then repeat the wait on that (if it is still pending).

As the lookup is now repeated there is no longer any need to compute
the fulfilment status and all that code can be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c  | 48 +++---------------------------------------------
 crypto/algboss.c |  1 +
 crypto/api.c     | 23 +++++++++++++++++++----
 3 files changed, 23 insertions(+), 49 deletions(-)

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
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 1aa5f306998a..d05a5aad2176 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -64,6 +64,7 @@ static int cryptomgr_probe(void *data)
 	crypto_tmpl_put(tmpl);
 
 out:
+	param->larval->alg.cra_flags |= CRYPTO_ALG_DEAD;
 	complete_all(&param->larval->completion);
 	crypto_alg_put(&param->larval->alg);
 	kfree(param);
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
