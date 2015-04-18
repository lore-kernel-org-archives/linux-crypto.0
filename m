From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 3/3] crypto: drbg - leave cipher handles operational
Date: Sat, 18 Apr 2015 19:37 +0200
Message-ID: <6244692.WBb0ZOZ1TI@myon.chronox.de>
References: <1702481.h2hMdNkdaF@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34195 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbbDRRia (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 13:38:30 -0400
In-Reply-To: <1702481.h2hMdNkdaF@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As the DRBG does not operate on shadow copies of the DRBG instance
any more, the cipher handles only need to be allocated once during
initalization time and deallocated during uninstantiate time.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 3683bb3..1ceb76c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1249,11 +1249,6 @@ static int drbg_generate(struct drbg_state *drbg,
 	if ((drbg_max_requests(drbg)) < drbg->reseed_ctr)
 		drbg->seeded = false;
 
-	/* allocate cipher handle */
-	len = drbg->d_ops->crypto_init(drbg);
-	if (len)
-		goto err;
-
 	if (drbg->pr || !drbg->seeded) {
 		pr_devel("DRBG: reseeding before generation (prediction "
 			 "resistance: %s, state %s)\n",
@@ -1325,7 +1320,6 @@ static int drbg_generate(struct drbg_state *drbg,
 	 */
 	len = 0;
 err:
-	drbg->d_ops->crypto_fini(drbg);
 	return len;
 }
 
@@ -1424,9 +1418,10 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	if (drbg->d_ops->crypto_init(drbg))
 		goto err;
 	ret = drbg_seed(drbg, pers, false);
-	drbg->d_ops->crypto_fini(drbg);
-	if (ret)
+	if (ret) {
+		drbg->d_ops->crypto_fini(drbg);
 		goto err;
+	}
 
 	mutex_unlock(&drbg->drbg_mutex);
 	return 0;
@@ -1450,6 +1445,7 @@ unlock:
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
 	mutex_lock(&drbg->drbg_mutex);
+	drbg->d_ops->crypto_fini(drbg);
 	drbg_dealloc_state(drbg);
 	/* no scrubbing of test_data -- this shall survive an uninstantiate */
 	mutex_unlock(&drbg->drbg_mutex);
-- 
2.1.0
