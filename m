From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/6] crypto: fips - Remove bogus inclusion of internal.h
Date: Wed, 22 Apr 2015 13:25:54 +0800
Message-ID: <E1YknAY-0001z9-R5@gondolin.me.apana.org.au>
References: <20150422052452.GA7553@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41225 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbbDVFZ5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:25:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YknAZ-0005S6-3T
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2015 15:25:55 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The header file internal.h is only meant for internal crypto API
implementors such as rng.c.  So fips has no business in including
it.

This patch removes that inclusions and instead adds inclusions of
the actual features used by fips.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/fips.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index 5539700..0f65df9 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -10,7 +10,10 @@
  *
  */
 
-#include "internal.h"
+#include <linux/export.h>
+#include <linux/fips.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 
 int fips_enabled;
 EXPORT_SYMBOL_GPL(fips_enabled);
