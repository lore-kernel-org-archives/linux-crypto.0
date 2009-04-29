From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] crypto: print self-test pass notices in fips mode
Date: Tue, 28 Apr 2009 21:21:35 -0400
Message-ID: <200904282121.35300.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35554 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbZD2BVw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 21:21:52 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

According to our FIPS CAVS testing lab guru, when we're in fips mode,
we *must* print out notices of successful self-test completion for
every alg to be compliant.

Dependent on patch 'crypto: catch base cipher self-test failures in
fips mode', which adds the test_done label.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 39ffa69..d0cc85c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2149,6 +2149,10 @@ notest:
 test_done:
 	if (fips_enabled && rc)
 		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
+	/* fips mode requires we print out self-test success notices */
+	if (fips_enabled && !rc && strncmp(alg, "ctr(aes", 7))
+		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
+		       driver, alg);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(alg_test);

-- 
Jarod Wilson
jarod@redhat.com
