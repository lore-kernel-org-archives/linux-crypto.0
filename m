From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH] crypto: tcrypt - removed unused variable.
Date: Wed, 16 Jan 2013 11:18:51 +0530
Message-ID: <1358315331-29465-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:59778
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab3APFvY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jan 2013 00:51:24 -0500
Received: from mail62-am1 (localhost [127.0.0.1])	by mail62-am1-R.bigfish.com
 (Postfix) with ESMTP id 4C03C160089	for <linux-crypto@vger.kernel.org>; Wed,
 16 Jan 2013 05:51:22 +0000 (UTC)
Received: from AM1EHSMHS021.bigfish.com (unknown [10.3.201.227])	by
 mail62-am1.bigfish.com (Postfix) with ESMTP id 114FA12007C	for
 <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2013 05:51:20 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r0G5pDDH012148	for
 <linux-crypto@vger.kernel.org>; Tue, 15 Jan 2013 22:51:16 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Removed unused variable for storing output string from:

	(a) test_ahash_jiffies_digest()
	(b) test_ahash_jiffies()
	(c) test_ahash_cycles_digest()
	(d) test_ahash_cycles()

This variable is not needed in above functions since the caller function
test_ahash_speed() already sets output buffer in the ahash transform using
ahash_request_set_crypt().

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
 crypto/tcrypt.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7ae2130..1414b9f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -499,7 +499,7 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 }
 
 static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
-				     char *out, int sec)
+				     int sec)
 {
 	unsigned long start, end;
 	int bcount;
@@ -519,14 +519,14 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 }
 
 static int test_ahash_jiffies(struct ahash_request *req, int blen,
-			      int plen, char *out, int sec)
+			      int plen, int sec)
 {
 	unsigned long start, end;
 	int bcount, pcount;
 	int ret;
 
 	if (plen == blen)
-		return test_ahash_jiffies_digest(req, blen, out, sec);
+		return test_ahash_jiffies_digest(req, blen, sec);
 
 	for (start = jiffies, end = start + sec * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
@@ -550,8 +550,7 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 	return 0;
 }
 
-static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
-				    char *out)
+static int test_ahash_cycles_digest(struct ahash_request *req, int blen)
 {
 	unsigned long cycles = 0;
 	int ret, i;
@@ -589,13 +588,13 @@ out:
 }
 
 static int test_ahash_cycles(struct ahash_request *req, int blen,
-			     int plen, char *out)
+			     int plen)
 {
 	unsigned long cycles = 0;
 	int i, pcount, ret;
 
 	if (plen == blen)
-		return test_ahash_cycles_digest(req, blen, out);
+		return test_ahash_cycles_digest(req, blen);
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
@@ -696,10 +695,10 @@ static void test_ahash_speed(const char *algo, unsigned int sec,
 
 		if (sec)
 			ret = test_ahash_jiffies(req, speed[i].blen,
-						 speed[i].plen, output, sec);
+						 speed[i].plen, sec);
 		else
 			ret = test_ahash_cycles(req, speed[i].blen,
-						speed[i].plen, output);
+						speed[i].plen);
 
 		if (ret) {
 			pr_err("hashing failed ret=%d\n", ret);
-- 
1.7.7
