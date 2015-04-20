From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/15] crypto: ansi_cprng - Remove bogus inclusion of internal.h
Date: Mon, 20 Apr 2015 13:39:12 +0800
Message-ID: <E1Yk4QK-0004rN-Jd@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53836 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbDTFjQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:16 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QL-0003FE-E1
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:13 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The file internal.h is only meant to be used by internel API
implementation and not algorithm implementations.  In fact it
isn't even needed here so this patch removes it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ansi_cprng.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 765fe76..e4945ec 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -20,8 +20,6 @@
 #include <linux/moduleparam.h>
 #include <linux/string.h>
 
-#include "internal.h"
-
 #define DEFAULT_PRNG_KEY "0123456789abcdef"
 #define DEFAULT_PRNG_KSZ 16
 #define DEFAULT_BLK_SZ 16
