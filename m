From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2] crypto: tcrypt: do not exit on success in fips mode
Date: Wed, 13 May 2009 12:40:10 -0400
Message-ID: <200905131240.11615.jarod@redhat.com>
References: <200905111006.32675.jarod@redhat.com> <200905130937.33449.jarod@redhat.com> <20090513140329.GA17863@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbZEMQlE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 12:41:04 -0400
In-Reply-To: <20090513140329.GA17863@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 13 May 2009 10:03:29 Herbert Xu wrote:
> On Wed, May 13, 2009 at 09:37:32AM -0400, Jarod Wilson wrote:
> > 
> > The latter option is more or less what the patch at the start of this
> > thread did, although via a param to tcrypt, not keying off the fips
> > flag. If I were to modify the patch to drop the mod param usage, and
> > instead key off the fips flag to not exit, would that be acceptable
> > for committing until such time as the userspace interface is ready?
> 
> Yes that sounds like the way to go.

Okay, here it is.

At present, the tcrypt module always exits with an -EAGAIN upon
successfully completing all the tests its been asked to run. In fips
mode, integrity checking is done by running all self-tests from the
initrd, and its much simpler to check the ret from modprobe for
success than to scrape dmesg and/or /proc/crypto. Simply stay
loaded, giving modprobe a retval of 0, if self-tests all pass and
we're in fips mode.

A side-effect of tracking success/failure for fips mode is that in
non-fips mode, self-test failures will return the actual failure
return codes, rather than always returning -EAGAIN, which seems more
correct anyway.

The tcrypt_test() portion of the patch is dependent on my earlier
pair of patches that skip non-fips algs in fips mode, at least to
achieve the fully intended behavior.

Nb: testing this patch against the cryptodev tree revealed a test
failure for sha384, which I have yet to look into...

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/tcrypt.c |  164 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 90 insertions(+), 74 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9e4974e..d59ba50 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -27,6 +27,7 @@
 #include <linux/timex.h>
 #include <linux/interrupt.h>
 #include "tcrypt.h"
+#include "internal.h"
 
 /*
  * Need slab memory for testing (size in number of pages).
@@ -468,248 +469,255 @@ static void test_available(void)
 
 static inline int tcrypt_test(const char *alg)
 {
-	return alg_test(alg, alg, 0, 0);
+	int ret;
+
+	ret = alg_test(alg, alg, 0, 0);
+	/* non-fips algs return -EINVAL in fips mode */
+	if (fips_enabled && ret == -EINVAL)
+		ret = 0;
+	return ret;
 }
 
-static void do_test(int m)
+static int do_test(int m)
 {
 	int i;
+	int ret = 0;
 
 	switch (m) {
 	case 0:
 		for (i = 1; i < 200; i++)
-			do_test(i);
+			ret += do_test(i);
 		break;
 
 	case 1:
-		tcrypt_test("md5");
+		ret += tcrypt_test("md5");
 		break;
 
 	case 2:
-		tcrypt_test("sha1");
+		ret += tcrypt_test("sha1");
 		break;
 
 	case 3:
-		tcrypt_test("ecb(des)");
-		tcrypt_test("cbc(des)");
+		ret += tcrypt_test("ecb(des)");
+		ret += tcrypt_test("cbc(des)");
 		break;
 
 	case 4:
-		tcrypt_test("ecb(des3_ede)");
-		tcrypt_test("cbc(des3_ede)");
+		ret += tcrypt_test("ecb(des3_ede)");
+		ret += tcrypt_test("cbc(des3_ede)");
 		break;
 
 	case 5:
-		tcrypt_test("md4");
+		ret += tcrypt_test("md4");
 		break;
 
 	case 6:
-		tcrypt_test("sha256");
+		ret += tcrypt_test("sha256");
 		break;
 
 	case 7:
-		tcrypt_test("ecb(blowfish)");
-		tcrypt_test("cbc(blowfish)");
+		ret += tcrypt_test("ecb(blowfish)");
+		ret += tcrypt_test("cbc(blowfish)");
 		break;
 
 	case 8:
-		tcrypt_test("ecb(twofish)");
-		tcrypt_test("cbc(twofish)");
+		ret += tcrypt_test("ecb(twofish)");
+		ret += tcrypt_test("cbc(twofish)");
 		break;
 
 	case 9:
-		tcrypt_test("ecb(serpent)");
+		ret += tcrypt_test("ecb(serpent)");
 		break;
 
 	case 10:
-		tcrypt_test("ecb(aes)");
-		tcrypt_test("cbc(aes)");
-		tcrypt_test("lrw(aes)");
-		tcrypt_test("xts(aes)");
-		tcrypt_test("ctr(aes)");
-		tcrypt_test("rfc3686(ctr(aes))");
+		ret += tcrypt_test("ecb(aes)");
+		ret += tcrypt_test("cbc(aes)");
+		ret += tcrypt_test("lrw(aes)");
+		ret += tcrypt_test("xts(aes)");
+		ret += tcrypt_test("ctr(aes)");
+		ret += tcrypt_test("rfc3686(ctr(aes))");
 		break;
 
 	case 11:
-		tcrypt_test("sha384");
+		ret += tcrypt_test("sha384");
 		break;
 
 	case 12:
-		tcrypt_test("sha512");
+		ret += tcrypt_test("sha512");
 		break;
 
 	case 13:
-		tcrypt_test("deflate");
+		ret += tcrypt_test("deflate");
 		break;
 
 	case 14:
-		tcrypt_test("ecb(cast5)");
+		ret += tcrypt_test("ecb(cast5)");
 		break;
 
 	case 15:
-		tcrypt_test("ecb(cast6)");
+		ret += tcrypt_test("ecb(cast6)");
 		break;
 
 	case 16:
-		tcrypt_test("ecb(arc4)");
+		ret += tcrypt_test("ecb(arc4)");
 		break;
 
 	case 17:
-		tcrypt_test("michael_mic");
+		ret += tcrypt_test("michael_mic");
 		break;
 
 	case 18:
-		tcrypt_test("crc32c");
+		ret += tcrypt_test("crc32c");
 		break;
 
 	case 19:
-		tcrypt_test("ecb(tea)");
+		ret += tcrypt_test("ecb(tea)");
 		break;
 
 	case 20:
-		tcrypt_test("ecb(xtea)");
+		ret += tcrypt_test("ecb(xtea)");
 		break;
 
 	case 21:
-		tcrypt_test("ecb(khazad)");
+		ret += tcrypt_test("ecb(khazad)");
 		break;
 
 	case 22:
-		tcrypt_test("wp512");
+		ret += tcrypt_test("wp512");
 		break;
 
 	case 23:
-		tcrypt_test("wp384");
+		ret += tcrypt_test("wp384");
 		break;
 
 	case 24:
-		tcrypt_test("wp256");
+		ret += tcrypt_test("wp256");
 		break;
 
 	case 25:
-		tcrypt_test("ecb(tnepres)");
+		ret += tcrypt_test("ecb(tnepres)");
 		break;
 
 	case 26:
-		tcrypt_test("ecb(anubis)");
-		tcrypt_test("cbc(anubis)");
+		ret += tcrypt_test("ecb(anubis)");
+		ret += tcrypt_test("cbc(anubis)");
 		break;
 
 	case 27:
-		tcrypt_test("tgr192");
+		ret += tcrypt_test("tgr192");
 		break;
 
 	case 28:
 
-		tcrypt_test("tgr160");
+		ret += tcrypt_test("tgr160");
 		break;
 
 	case 29:
-		tcrypt_test("tgr128");
+		ret += tcrypt_test("tgr128");
 		break;
 
 	case 30:
-		tcrypt_test("ecb(xeta)");
+		ret += tcrypt_test("ecb(xeta)");
 		break;
 
 	case 31:
-		tcrypt_test("pcbc(fcrypt)");
+		ret += tcrypt_test("pcbc(fcrypt)");
 		break;
 
 	case 32:
-		tcrypt_test("ecb(camellia)");
-		tcrypt_test("cbc(camellia)");
+		ret += tcrypt_test("ecb(camellia)");
+		ret += tcrypt_test("cbc(camellia)");
 		break;
 	case 33:
-		tcrypt_test("sha224");
+		ret += tcrypt_test("sha224");
 		break;
 
 	case 34:
-		tcrypt_test("salsa20");
+		ret += tcrypt_test("salsa20");
 		break;
 
 	case 35:
-		tcrypt_test("gcm(aes)");
+		ret += tcrypt_test("gcm(aes)");
 		break;
 
 	case 36:
-		tcrypt_test("lzo");
+		ret += tcrypt_test("lzo");
 		break;
 
 	case 37:
-		tcrypt_test("ccm(aes)");
+		ret += tcrypt_test("ccm(aes)");
 		break;
 
 	case 38:
-		tcrypt_test("cts(cbc(aes))");
+		ret += tcrypt_test("cts(cbc(aes))");
 		break;
 
         case 39:
-		tcrypt_test("rmd128");
+		ret += tcrypt_test("rmd128");
 		break;
 
         case 40:
-		tcrypt_test("rmd160");
+		ret += tcrypt_test("rmd160");
 		break;
 
 	case 41:
-		tcrypt_test("rmd256");
+		ret += tcrypt_test("rmd256");
 		break;
 
 	case 42:
-		tcrypt_test("rmd320");
+		ret += tcrypt_test("rmd320");
 		break;
 
 	case 43:
-		tcrypt_test("ecb(seed)");
+		ret += tcrypt_test("ecb(seed)");
 		break;
 
 	case 44:
-		tcrypt_test("zlib");
+		ret += tcrypt_test("zlib");
 		break;
 
 	case 45:
-		tcrypt_test("rfc4309(ccm(aes))");
+		ret += tcrypt_test("rfc4309(ccm(aes))");
 		break;
 
 	case 100:
-		tcrypt_test("hmac(md5)");
+		ret += tcrypt_test("hmac(md5)");
 		break;
 
 	case 101:
-		tcrypt_test("hmac(sha1)");
+		ret += tcrypt_test("hmac(sha1)");
 		break;
 
 	case 102:
-		tcrypt_test("hmac(sha256)");
+		ret += tcrypt_test("hmac(sha256)");
 		break;
 
 	case 103:
-		tcrypt_test("hmac(sha384)");
+		ret += tcrypt_test("hmac(sha384)");
 		break;
 
 	case 104:
-		tcrypt_test("hmac(sha512)");
+		ret += tcrypt_test("hmac(sha512)");
 		break;
 
 	case 105:
-		tcrypt_test("hmac(sha224)");
+		ret += tcrypt_test("hmac(sha224)");
 		break;
 
 	case 106:
-		tcrypt_test("xcbc(aes)");
+		ret += tcrypt_test("xcbc(aes)");
 		break;
 
 	case 107:
-		tcrypt_test("hmac(rmd128)");
+		ret += tcrypt_test("hmac(rmd128)");
 		break;
 
 	case 108:
-		tcrypt_test("hmac(rmd160)");
+		ret += tcrypt_test("hmac(rmd160)");
 		break;
 
 	case 150:
-		tcrypt_test("ansi_cprng");
+		ret += tcrypt_test("ansi_cprng");
 		break;
 
 	case 200:
@@ -873,6 +881,8 @@ static void do_test(int m)
 		test_available();
 		break;
 	}
+
+	return ret;
 }
 
 static int __init tcrypt_mod_init(void)
@@ -886,15 +896,21 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
-	do_test(mode);
+	err = do_test(mode);
+	if (err) {
+		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
+		goto err_free_tv;
+	}
 
-	/* We intentionaly return -EAGAIN to prevent keeping
-	 * the module. It does all its work from init()
-	 * and doesn't offer any runtime functionality 
+	/* We intentionaly return -EAGAIN to prevent keeping the module,
+	 * unless we're running in fips mode. It does all its work from
+	 * init() and doesn't offer any runtime functionality, but in
+	 * the fips case, checking for a successful load is helpful.
 	 * => we don't need it in the memory, do we?
 	 *                                        -- mludvig
 	 */
-	err = -EAGAIN;
+	if (!fips_enabled)
+		err = -EAGAIN;
 
 err_free_tv:
 	for (i = 0; i < TVMEMSIZE && tvmem[i]; i++)


-- 
Jarod Wilson
jarod@redhat.com
