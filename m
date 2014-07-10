From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] crypto: initialize entry len for null input in crypto hash
 sg list walk
Date: Thu, 10 Jul 2014 16:18:08 -0700
Message-ID: <1405034288.2970.647.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaGJXSM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2014 19:18:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For the special case when we have a null input string, we want
to initialize the entry len to 0 for the hash/ahash walk, so
cyrpto_hash_walk_last will return the correct result indicating
that we have completed the scatter list walk.  Otherwise we may
keep walking the sg list and access bogus memory address.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/ahash.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f2a5d8f..f6a36a5 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -131,8 +131,10 @@ int crypto_hash_walk_first(struct ahash_request *req,
 {
 	walk->total = req->nbytes;
 
-	if (!walk->total)
+	if (!walk->total) {
+		walk->entrylen = 0;
 		return 0;
+	}
 
 	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
 	walk->sg = req->src;
@@ -147,8 +149,10 @@ int crypto_ahash_walk_first(struct ahash_request *req,
 {
 	walk->total = req->nbytes;
 
-	if (!walk->total)
+	if (!walk->total) {
+		walk->entrylen = 0;
 		return 0;
+	}
 
 	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
 	walk->sg = req->src;
@@ -167,8 +171,10 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 {
 	walk->total = len;
 
-	if (!walk->total)
+	if (!walk->total) {
+		walk->entrylen = 0;
 		return 0;
+	}
 
 	walk->alignmask = crypto_hash_alignmask(hdesc->tfm);
 	walk->sg = sg;
-- 
1.7.11.7
