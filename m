From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/24] crypto: talitos - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:48 +0800
Message-ID: <E1YrkJQ-0001B1-4l@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34722 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbEKJrv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:51 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJQ-0000F5-C4
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:48 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/talitos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c04074d..4c0778b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -46,7 +46,7 @@
 #include <crypto/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
 #include <crypto/hash.h>
