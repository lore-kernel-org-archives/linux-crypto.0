Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB693307B
	for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2024 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731635796; cv=none; b=nqFyiALjA63rUeMwBIcyMjToamCijgn87FOlRRXwh9/BYi/SJskJ/VChDLjD4mZSjO24IBFl1bG93rH8vTej+8zplZfavN0mksJoiO+DeRV2axYSVSHVMZ/tG77bVGocR9w44xAgK9nxWGo6WgeciJ06XkvVWEKSVh8XXH5KwTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731635796; c=relaxed/simple;
	bh=nYU/WKfssaxS+64ZzWnKO+fqUxybcveyLw35iAtTcPs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZo4Jpu3KKYv5wCyjF3xOHnzmzzIgraPel0FJyn1mAUtN/zKprt8kOBYbL+1GzzGMITK5mAx1QevGCw+Hrzcwz5rVwYJofQmaRUxGuWe/SmF0Md0/0P7QEJxwM4fRK0BrGFJHAnej+scIzoDalz3sivwDyYGRjggZ+vCzaBD2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EPUuE6Mx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EPUuE6Mx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k2FyyPUlDoL0DUR5OsFrDB6t2IBVbinidVFEMmTxz0Y=; b=EPUuE6MxGhTfTJXBUQecMoTTMQ
	nfDeKZlL5cnBM2YeDaxaS/uwwG1BZJDrBLYkBKMdj1vlGq+J2MELFLnV/vyWXy0VeKM3pAvdCzsHt
	ShnzWngUP3i5PsuWwDU1Y4L3Qx8RGWEG9ju8PYu9dza42NgAyLrcMfTsQaEX2qkFnLUMxRayQeq7G
	A9hPbeOQfooIlQJroUYbQ8CO47ICsfIPWxn6oeOrQnsKxAxHqiS8lhOKTfY0r8DzU3J0OKEs2RW4V
	R0vMw0Zm4Cd9paPUt3TyhhjFbl8YTjABCNGYwS5tPU1kdizdam6viwnvJlfIdVlWskW7HuFiDcTJ3
	YWkgWWBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBlZU-00GwLx-23;
	Fri, 15 Nov 2024 09:56:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 09:56:28 +0800
Date: Fri, 15 Nov 2024 09:56:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH 2/2] crypto: api - Call crypto_schedule_test outside of mutex
Message-ID: <ZzaqTPmB4RnK_yrA@gondor.apana.org.au>
References: <Zzaj3v7uJDPartDY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzaj3v7uJDPartDY@gondor.apana.org.au>

There is no need to hold the crypto mutex when scheduling a self-
test.  In fact prior to the patch introducing asynchronous testing,
this was done outside of the locked area.

Move the crypto_schedule_test call back out of the locked area.

Also move crypto_remove_final to the else branch under the schedule-
test call as the list of algorithms to be removed is non-empty only
when the test larval is NULL (i.e., testing is disabled).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c067412d909a..ae4a5ea73a6f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -413,6 +413,7 @@ EXPORT_SYMBOL_GPL(crypto_remove_final);
 int crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
+	bool test_started = false;
 	LIST_HEAD(algs_to_put);
 	int err;
 
@@ -424,17 +425,19 @@ int crypto_register_alg(struct crypto_alg *alg)
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg, &algs_to_put);
 	if (!IS_ERR_OR_NULL(larval)) {
-		bool test_started = crypto_boot_test_finished();
-
+		test_started = crypto_boot_test_finished();
 		larval->test_started = test_started;
-		if (test_started)
-			crypto_schedule_test(larval);
 	}
 	up_write(&crypto_alg_sem);
 
 	if (IS_ERR(larval))
 		return PTR_ERR(larval);
-	crypto_remove_final(&algs_to_put);
+
+	if (test_started)
+		crypto_schedule_test(larval);
+	else
+		crypto_remove_final(&algs_to_put);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
@@ -648,10 +651,8 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	larval = __crypto_register_alg(&inst->alg, &algs_to_put);
 	if (IS_ERR(larval))
 		goto unlock;
-	else if (larval) {
+	else if (larval)
 		larval->test_started = true;
-		crypto_schedule_test(larval);
-	}
 
 	hlist_add_head(&inst->list, &tmpl->instances);
 	inst->tmpl = tmpl;
@@ -661,7 +662,12 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	if (IS_ERR(larval))
 		return PTR_ERR(larval);
-	crypto_remove_final(&algs_to_put);
+
+	if (larval)
+		crypto_schedule_test(larval);
+	else
+		crypto_remove_final(&algs_to_put);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_instance);
@@ -1046,7 +1052,6 @@ static void __init crypto_start_tests(void)
 
 			l->test_started = true;
 			larval = l;
-			crypto_schedule_test(larval);
 			break;
 		}
 
@@ -1054,6 +1059,8 @@ static void __init crypto_start_tests(void)
 
 		if (!larval)
 			break;
+
+		crypto_schedule_test(larval);
 	}
 }
 
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
