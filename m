From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] crypto/jitterentropy-kcapi: fix a comment reflecting function name changed
Date: Wed,  7 Oct 2015 23:38:14 +0600
Message-ID: <1444239494-8906-1-git-send-email-kuleshovmail@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34312 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbbJGRjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2015 13:39:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The clocksource does not provide clocksource_register() function since
f893598 commit (clocksource: Mostly kill clocksource_register()), but
__clocksource_register() instead.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 crypto/jitterentropy-kcapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index ceea83d..4b030df 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -101,7 +101,7 @@ void jent_get_nstime(__u64 *out)
 	 *
 	 * The list of available timers can be obtained from
 	 * /sys/devices/system/clocksource/clocksource0/available_clocksource
-	 * and are registered with clocksource_register()
+	 * and are registered with __clocksource_register()
 	 */
 	if ((0 == tmp) &&
 	   (0 == __getnstimeofday(&ts))) {
-- 
2.6.0
