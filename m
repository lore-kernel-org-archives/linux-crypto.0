Return-Path: <SRS0=ouVC=R5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20C4C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 12:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6976F20856
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 12:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfCZM7l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:59:41 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:45620 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731567AbfCZM7l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Mar 2019 08:59:41 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E9D2872CCAC;
        Tue, 26 Mar 2019 15:59:38 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 545EA4A4AE9;
        Tue, 26 Mar 2019 15:59:38 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 07/10] crypto: ecc - make ecc into separate module
Date:   Tue, 26 Mar 2019 15:58:39 +0300
Message-Id: <20190326125842.24110-8-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190326125842.24110-1-vt@altlinux.org>
References: <20190326125842.24110-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ecc.c have algorithms that could be used togeter by ecdh and ecrdsa.
Make it separate module. Add CRYPTO_ECC into Kconfig. EXPORT_SYMBOL and
document to what seems appropriate. Move structs ecc_point and ecc_curve
from ecc_curve_defs.h into ecc.h.

No code changes.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/Kconfig          |  4 ++
 crypto/Makefile         |  2 +-
 crypto/ecc.c            | 25 +++++++++----
 crypto/ecc.h            | 99 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/ecc_curve_defs.h | 15 --------
 5 files changed, 122 insertions(+), 23 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b8493d470550..291dda4e8ebf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -248,8 +248,12 @@ config CRYPTO_DH
 	help
 	  Generic implementation of the Diffie-Hellman algorithm.
 
+config CRYPTO_ECC
+	tristate
+
 config CRYPTO_ECDH
 	tristate "ECDH algorithm"
+	select CRYPTO_ECC
 	select CRYPTO_KPP
 	select CRYPTO_RNG_DEFAULT
 	help
diff --git a/crypto/Makefile b/crypto/Makefile
index fb5bf2a3a666..b5685a01ad31 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -147,8 +147,8 @@ obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
+obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 
-ecdh_generic-y := ecc.o
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
diff --git a/crypto/ecc.c b/crypto/ecc.c
index ed1237115066..5f36792d143d 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -24,6 +24,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/module.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/swab.h>
@@ -112,7 +113,7 @@ static void vli_clear(u64 *vli, unsigned int ndigits)
 }
 
 /* Returns true if vli == 0, false otherwise. */
-static bool vli_is_zero(const u64 *vli, unsigned int ndigits)
+bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 {
 	int i;
 
@@ -123,6 +124,7 @@ static bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 
 	return true;
 }
+EXPORT_SYMBOL(vli_is_zero);
 
 /* Returns nonzero if bit bit of vli is set. */
 static u64 vli_test_bit(const u64 *vli, unsigned int bit)
@@ -171,7 +173,7 @@ static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
 }
 
 /* Returns sign of left - right. */
-static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
+int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 {
 	int i;
 
@@ -184,6 +186,7 @@ static int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 
 	return 0;
 }
+EXPORT_SYMBOL(vli_cmp);
 
 /* Computes result = in << c, returning carry. Can modify in place
  * (if result == in). 0 < shift < 64.
@@ -240,7 +243,7 @@ static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
 }
 
 /* Computes result = left - right, returning borrow. Can modify in place. */
-static u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 		   unsigned int ndigits)
 {
 	u64 borrow = 0;
@@ -258,6 +261,7 @@ static u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 
 	return borrow;
 }
+EXPORT_SYMBOL(vli_sub);
 
 static uint128_t mul_64_64(u64 left, u64 right)
 {
@@ -557,7 +561,7 @@ static void vli_mod_square_fast(u64 *result, const u64 *left,
  * See "From Euclid's GCD to Montgomery Multiplication to the Great Divide"
  * https://labs.oracle.com/techrep/2001/smli_tr-2001-95.pdf
  */
-static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 			unsigned int ndigits)
 {
 	u64 a[ECC_MAX_DIGITS], b[ECC_MAX_DIGITS];
@@ -630,6 +634,7 @@ static void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 
 	vli_set(result, u, ndigits);
 }
+EXPORT_SYMBOL(vli_mod_inv);
 
 /* ------ Point operations ------ */
 
@@ -948,6 +953,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 
 	return __ecc_is_key_valid(curve, private_key, ndigits);
 }
+EXPORT_SYMBOL(ecc_is_key_valid);
 
 /*
  * ECC private keys are generated using the method of extra random bits,
@@ -1000,6 +1006,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 
 	return 0;
 }
+EXPORT_SYMBOL(ecc_gen_privkey);
 
 int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, u64 *public_key)
@@ -1036,10 +1043,11 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ecc_make_pub_key);
 
 /* SP800-56A section 5.6.2.3.4 partial verification: ephemeral keys only */
-static int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
-				       struct ecc_point *pk)
+int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
+				struct ecc_point *pk)
 {
 	u64 yy[ECC_MAX_DIGITS], xxx[ECC_MAX_DIGITS], w[ECC_MAX_DIGITS];
 
@@ -1064,8 +1072,8 @@ static int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 		return -EINVAL;
 
 	return 0;
-
 }
+EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
 
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
@@ -1121,3 +1129,6 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(crypto_ecdh_shared_secret);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/ecc.h b/crypto/ecc.h
index f75a86baa3bd..3809dbeb699a 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -33,6 +33,41 @@
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
 /**
+ * struct ecc_point - elliptic curve point in affine coordinates
+ *
+ * @x:		X coordinate in vli form.
+ * @y:		Y coordinate in vli form.
+ * @ndigits:	Length of vlis in u64 qwords.
+ */
+struct ecc_point {
+	u64 *x;
+	u64 *y;
+	u8 ndigits;
+};
+
+/**
+ * struct ecc_curve - definition of elliptic curve
+ *
+ * @name:	Short name of the curve.
+ * @g:		Generator point of the curve.
+ * @p:		Prime number, if Barrett's reduction is used for this curve
+ *		pre-calculated value 'mu' is appended to the @p after ndigits.
+ *		Use of Barrett's reduction is heuristically determined in
+ *		vli_mmod_fast().
+ * @n:		Order of the curve group.
+ * @a:		Curve parameter a.
+ * @b:		Curve parameter b.
+ */
+struct ecc_curve {
+	char *name;
+	struct ecc_point g;
+	u64 *p;
+	u64 *n;
+	u64 *a;
+	u64 *b;
+};
+
+/**
  * ecc_is_key_valid() - Validate a given ECDH private key
  *
  * @curve_id:		id representing the curve to use
@@ -91,4 +126,68 @@ int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
 			      u64 *secret);
+
+/**
+ * ecc_is_pubkey_valid_partial() - Partial public key validation
+ *
+ * @curve:		elliptic curve domain parameters
+ * @pk:			public key as a point
+ *
+ * Valdiate public key according to SP800-56A section 5.6.2.3.4 ECC Partial
+ * Public-Key Validation Routine.
+ *
+ * Note: There is no check that the public key is in the correct elliptic curve
+ * subgroup.
+ *
+ * Return: 0 if validation is successful, -EINVAL if validation is failed.
+ */
+int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
+				struct ecc_point *pk);
+
+/**
+ * vli_is_zero() - Determine is vli is zero
+ *
+ * @vli:		vli to check.
+ * @ndigits:		length of the @vli
+ */
+bool vli_is_zero(const u64 *vli, unsigned int ndigits);
+
+/**
+ * vli_cmp() - compare left and right vlis
+ *
+ * @left:		vli
+ * @right:		vli
+ * @ndigits:		length of both vlis
+ *
+ * Returns sign of @left - @right, i.e. -1 if @left < @right,
+ * 0 if @left == @right, 1 if @left > @right.
+ */
+int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits);
+
+/**
+ * vli_sub() - Subtracts right from left
+ *
+ * @result:		where to write result
+ * @left:		vli
+ * @right		vli
+ * @ndigits:		length of all vlis
+ *
+ * Note: can modify in-place.
+ *
+ * Return: carry bit.
+ */
+u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+	    unsigned int ndigits);
+
+/**
+ * vli_mod_inv() - Modular inversion
+ *
+ * @result:		where to write vli number
+ * @input:		vli value to operate on
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ */
+void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+		 unsigned int ndigits);
+
 #endif
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 336ab1805639..69be6c7d228f 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -2,21 +2,6 @@
 #ifndef _CRYTO_ECC_CURVE_DEFS_H
 #define _CRYTO_ECC_CURVE_DEFS_H
 
-struct ecc_point {
-	u64 *x;
-	u64 *y;
-	u8 ndigits;
-};
-
-struct ecc_curve {
-	char *name;
-	struct ecc_point g;
-	u64 *p;
-	u64 *n;
-	u64 *a;
-	u64 *b;
-};
-
 /* NIST P-192: a = p - 3 */
 static u64 nist_p192_g_x[] = { 0xF4FF0AFD82FF1012ull, 0x7CBF20EB43A18800ull,
 				0x188DA80EB03090F6ull };
-- 
2.11.0

