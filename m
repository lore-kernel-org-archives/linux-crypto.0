From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCH] crypto: tcrypt - Add debug prints
Date: Wed, 18 Jan 2017 14:54:05 +0100
Message-ID: <1484747645-17463-1-git-send-email-rabin.vincent@axis.com>
Cc: linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:40104 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdARNyU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 08:54:20 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rabin Vincent <rabinv@axis.com>

tcrypt is very tight-lipped when it succeeds, but a bit more feedback
would be useful when developing or debugging crypto drivers, especially
since even a successful run ends with the module failing to insert. Add
a couple of debug prints, which can be enabled with dynamic debug:

Before:

 # insmod tcrypt.ko mode=10
 insmod: can't insert 'tcrypt.ko': Resource temporarily unavailable

After:

 # insmod tcrypt.ko mode=10 dyndbg
 tcrypt: testing ecb(aes)
 tcrypt: testing cbc(aes)
 tcrypt: testing lrw(aes)
 tcrypt: testing xts(aes)
 tcrypt: testing ctr(aes)
 tcrypt: testing rfc3686(ctr(aes))
 tcrypt: all tests passed
 insmod: can't insert 'tcrypt.ko': Resource temporarily unavailable

Signed-off-by: Rabin Vincent <rabinv@axis.com>
---
 crypto/tcrypt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ae22f05..9a11f3c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -22,6 +22,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/aead.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
@@ -1010,6 +1012,8 @@ static inline int tcrypt_test(const char *alg)
 {
 	int ret;
 
+	pr_debug("testing %s\n", alg);
+
 	ret = alg_test(alg, alg, 0, 0);
 	/* non-fips algs return -EINVAL in fips mode */
 	if (fips_enabled && ret == -EINVAL)
@@ -2059,6 +2063,8 @@ static int __init tcrypt_mod_init(void)
 	if (err) {
 		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
 		goto err_free_tv;
+	} else {
+		pr_debug("all tests passed\n");
 	}
 
 	/* We intentionaly return -EAGAIN to prevent keeping the module,
-- 
2.1.4
