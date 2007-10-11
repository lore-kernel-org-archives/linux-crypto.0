From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 15:30:03 +0400
Message-ID: <20071011113002.GA20119@2ka.mipt.ru>
References: <20071010152146.GA13379@2ka.mipt.ru> <20071011101400.GA17192@gondor.apana.org.au> <20071011104313.GA31211@2ka.mipt.ru> <20071011105202.GA17487@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48960 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXJKLaO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 07:30:14 -0400
Content-Disposition: inline
In-Reply-To: <20071011105202.GA17487@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 06:52:02PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Thu, Oct 11, 2007 at 02:43:14PM +0400, Evgeniy Polyakov wrote:
> > 
> > Attached patch fixes that with following tcrypt output:
> 
> That was quick :)
> 
> Unfortunately it doesn't apply because des.c has been renamed
> to des_generic.c in cryptodev-2.6.  Could you please fix that
> up and also move the prototype into a header file, say
> include/crypto/des.h?

Here is DES update.
I will send HIFN river update in the next mail.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index ec09e7b..355ecb7 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -20,13 +20,7 @@
 #include <linux/crypto.h>
 #include <linux/types.h>
 
-#define DES_KEY_SIZE		8
-#define DES_EXPKEY_WORDS	32
-#define DES_BLOCK_SIZE		8
-
-#define DES3_EDE_KEY_SIZE	(3 * DES_KEY_SIZE)
-#define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
-#define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
+#include <crypto/des.h>
 
 #define ROL(x, r) ((x) = rol32((x), (r)))
 #define ROR(x, r) ((x) = ror32((x), (r)))
diff --git a/include/crypto/des.h b/include/crypto/des.h
new file mode 100644
index 0000000..2971c63
--- /dev/null
+++ b/include/crypto/des.h
@@ -0,0 +1,19 @@
+/* 
+ * DES & Triple DES EDE Cipher Algorithms.
+ */
+
+#ifndef __CRYPTO_DES_H
+#define __CRYPTO_DES_H
+
+#define DES_KEY_SIZE		8
+#define DES_EXPKEY_WORDS	32
+#define DES_BLOCK_SIZE		8
+
+#define DES3_EDE_KEY_SIZE	(3 * DES_KEY_SIZE)
+#define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
+#define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
+
+
+extern unsigned long des_ekey(u32 *pe, const u8 *k);
+
+#endif /* __CRYPTO_DES_H */

-- 
	Evgeniy Polyakov
