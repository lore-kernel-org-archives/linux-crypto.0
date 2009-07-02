From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Update stdrng test name so that the testmgr
	finds it properly
Date: Thu, 2 Jul 2009 16:32:59 +0800
Message-ID: <20090702083259.GA12884@gondor.apana.org.au>
References: <20090701155219.GA31414@hmsreliant.think-freely.org> <20090702060255.GA18642@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55840 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbZGBIdG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2009 04:33:06 -0400
Content-Disposition: inline
In-Reply-To: <20090702060255.GA18642@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2009 at 08:02:55AM +0200, Sebastian Andrzej Siewior wrote:
>
> >@@ -1480,7 +1480,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
> > /* Please keep this list sorted by algorithm name. */
> > static const struct alg_test_desc alg_test_descs[] = {
> > 	{
> >-		.alg = "ansi_cprng",
> >+		.alg = "stdrng",
> > 		.test = alg_test_cprng,
> > 		.fips_allowed = 1,
> > 		.suite = {
> 
> Don't you use this vector for _all_ stdrngs now? krng for instance will
> fail.

Good cath!

What this really should do is test a specific implementation of
stdrng.  Like this,

commit a68f6610d4f1ebe61818f5926fa8fa9e75d06a95
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Jul 2 16:32:12 2009 +0800

    crypto: testmgr - Allow implementation-specific tests
    
    This patch adds the support for testing specific implementations.
    This should only be used in very specific situations.  Right now
    this means specific implementations of random number generators.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9bea9d..29b228d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2344,6 +2344,7 @@ static int alg_find_test(const char *alg)
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 {
 	int i;
+	int j;
 	int rc;
 
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
@@ -2365,14 +2366,22 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	}
 
 	i = alg_find_test(alg);
-	if (i < 0)
+	j = alg_find_test(driver);
+	if (i < 0 && j < 0)
 		goto notest;
 
-	if (fips_enabled && !alg_test_descs[i].fips_allowed)
+	if (fips_enabled && ((i >= 0 && !alg_test_descs[i].fips_allowed) ||
+			     (j >= 0 && !alg_test_descs[j].fips_allowed)))
 		goto non_fips_alg;
 
-	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
-				      type, mask);
+	rc = 0;
+	if (i >= 0)
+		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
+					     type, mask);
+	if (j >= 0)
+		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
+					     type, mask);
+
 test_done:
 	if (fips_enabled && rc)
 		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
