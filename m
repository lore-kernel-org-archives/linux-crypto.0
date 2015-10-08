From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v2] crypto/jitterentropy-kcapi: remove unnecessary information from a comment
Date: Thu,  8 Oct 2015 23:12:25 +0600
Message-ID: <1444324345-20050-1-git-send-email-kuleshovmail@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34839 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbbJHRN5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 13:13:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The clocksource does not provide clocksource_register() function since
f893598 commit (clocksource: Mostly kill clocksource_register()), so
let's remove unnecessary information about this function from a comment.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/jitterentropy-kcapi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index ceea83d..597cedd 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -98,10 +98,6 @@ void jent_get_nstime(__u64 *out)
 	 * If random_get_entropy does not return a value (which is possible on,
 	 * for example, MIPS), invoke __getnstimeofday
 	 * hoping that there are timers we can work with.
-	 *
-	 * The list of available timers can be obtained from
-	 * /sys/devices/system/clocksource/clocksource0/available_clocksource
-	 * and are registered with clocksource_register()
 	 */
 	if ((0 == tmp) &&
 	   (0 == __getnstimeofday(&ts))) {
-- 
2.6.0
