From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 6/11] crypto: ansi_cprng - Remove bogus inclusion of internal.h
Date: Tue, 21 Apr 2015 10:46:43 +0800
Message-ID: <E1YkOCx-0007Kv-2Q@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41523 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbDUCqq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:46 -0400
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
