From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] crypto: add infra to skip disallowed algs in fips mode
Date: Thu, 7 May 2009 15:27:59 -0400
Message-ID: <200905071527.59809.jarod@redhat.com>
References: <200905071441.27093.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41688 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761944AbZEGT24 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2009 15:28:56 -0400
In-Reply-To: <200905071441.27093.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Because all fips-allowed algorithms must be self-tested before they
can be used, they will all have entries in testmgr.c's alg_test_descs[].
If we add and set an additional flag for the allowed algorithms, we can
key off of it to prevent use of any algs that aren't allowed.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f4cc178..232f043 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -94,6 +94,7 @@ struct alg_test_desc {
 	const char *alg;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
 		    u32 type, u32 mask);
+	int fips_allowed;	/* set if alg is allowed in fips mode */
 
 	union {
 		struct aead_test_suite aead;
@@ -2285,6 +2286,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (i < 0)
 			goto notest;
 
+		if (fips_enabled && !alg_test_descs[i].fips_allowed)
+			goto non_fips_alg;
+
 		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
 		goto test_done;
 	}
@@ -2293,6 +2297,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (i < 0)
 		goto notest;
 
+	if (fips_enabled && !alg_test_descs[i].fips_allowed)
+		goto non_fips_alg;
+
 	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
 				      type, mask);
 test_done:
@@ -2308,5 +2315,7 @@ test_done:
 notest:
 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
 	return 0;
+non_fips_alg:
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(alg_test);

-- 
Jarod Wilson
jarod@redhat.com
