From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/24] crypto: qat - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:46 +0800
Message-ID: <E1YrkJO-00019b-Vi@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33529 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbEKJru (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:50 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJP-0000Ea-6G
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:47 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qat/qat_common/qat_algs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 1dc5b0a..070abcd 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -47,7 +47,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/crypto.h>
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/hash.h>
