From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/2 v2] crypto: skip algs not flagged fips_allowed in fips mode
Date: Mon, 11 May 2009 09:53:06 -0400
Message-ID: <200905110953.06678.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33772 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZEKN4M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 09:56:12 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Because all fips-allowed algorithms must be self-tested before they
can be used, they will all have entries in testmgr.c's alg_test_descs[].
Skip self-tests for any algs not flagged as fips_approved and return
-EINVAL when in fips mode.

Resending with properly updated patch v2 tag.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 51bae62..f93b26d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2308,6 +2308,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (i < 0)
 			goto notest;
 
+		if (fips_enabled && !alg_test_descs[i].fips_allowed)
+			goto non_fips_alg;
+
 		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
 		goto test_done;
 	}
@@ -2316,6 +2319,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (i < 0)
 		goto notest;
 
+	if (fips_enabled && !alg_test_descs[i].fips_allowed)
+		goto non_fips_alg;
+
 	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
 				      type, mask);
 test_done:
@@ -2331,5 +2337,7 @@ test_done:
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

