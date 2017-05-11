From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto-testmgr: Delete an error message for a failed memory
 allocation in two functions
Date: Thu, 11 May 2017 17:12:11 +0200
Message-ID: <0168ce01-446b-a1f0-8a3f-55da49bdbd86@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 11 May 2017 17:05:17 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/testmgr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6f5f3ed8376c..392bb4f95024 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -217,10 +217,9 @@ static int ahash_partial_update(struct ahash_request **preq,
 	statesize = crypto_ahash_statesize(
 			crypto_ahash_reqtfm(req));
 	state = kmalloc(statesize + sizeof(guard), GFP_KERNEL);
-	if (!state) {
-		pr_err("alt: hash: Failed to alloc state for %s\n", algo);
+	if (!state)
 		goto out_nostate;
-	}
+
 	memcpy(state + statesize, guard, sizeof(guard));
 	ret = crypto_ahash_export(req, state);
 	WARN_ON(memcmp(state + statesize, guard, sizeof(guard)));
@@ -1632,11 +1631,8 @@ static int test_cprng(struct crypto_rng *tfm,
 	seedsize = crypto_rng_seedsize(tfm);
 
 	seed = kmalloc(seedsize, GFP_KERNEL);
-	if (!seed) {
-		printk(KERN_ERR "alg: cprng: Failed to allocate seed space "
-		       "for %s\n", algo);
+	if (!seed)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < tcount; i++) {
 		memset(result, 0, 32);
-- 
2.12.3
