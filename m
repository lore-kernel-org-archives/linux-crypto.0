Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1869DC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 15:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC7621D7E
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 15:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATPDR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 10:03:17 -0500
Received: from lalavava.tse.jus.br ([187.4.152.50]:49234 "EHLO
        lalavava.tse.jus.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATPDQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 10:03:16 -0500
X-Greylist: delayed 1812 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 10:02:57 EST
X-AuditID: c0a8cb64-631ff70000001860-ca-5e25a8783cca
Received: from EXCH01.tse.gov.br (exch01.tse.gov.br [10.30.1.221])
        by lalavava.tse.jus.br (Mail) with SMTP id AB.39.06240.878A52E5; Mon, 20 Jan 2020 11:17:44 -0200 (-02)
Received: from [10.30.33.239] (10.30.33.239) by EXCH01.tse.gov.br
 (10.30.1.221) with Microsoft SMTP Server (TLS) id 14.2.347.0; Mon, 20 Jan
 2020 11:17:30 -0300
From:   Saulo Alessandre <saulo.alessandre@tse.jus.br>
To:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] this patch implements ecdsa 256 and 384 with tests on,
 ecdsa256-sha256 and ecdsa384-sha256
CC:     Saulo Alessandre de Lima <saulo.alessandre@gmail.com>
Message-ID: <322e2ea2-4f47-65ec-5bbf-806562237aa1@tse.jus.br>
Date:   Mon, 20 Jan 2020 11:15:20 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pt-BR
X-Originating-IP: [10.30.33.239]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLsWRmVeSWpSXmKPExsXCJcd4V7dihWqcwc/z6hb37/1ksvizqZXd
        gclj56y77B6fN8kFMEVx2aSk5mSWpRbp2yVwZWz9dYa14N0a5oq3F/6wNjA+fcnUxcjJISFg
        InF2w0e2LkYuDiGB1YwS167fgXIWM0pcn76BFaSKDajq2qODQB0cHCICShIPjzODhIUFciVu
        nO5iAbGZBSwlnvTeZQexeQVsJdrufWEEsVkEVCVau+6D2aICERJvf99khagRlDg58wlUr4XE
        zPnnGSFseYnmrbOZIWxxicVbVoIdKiSgIfF87zdmiKMVJM6caGebwCgwC8moWUhGzUIyahaS
        UQsYWVYxCuck5iSWAaFeSXGqXlZpsV5S0SZGYLAeWHE6ZQfjs1+v9Q4xCnAwKvHwGnSoxgmx
        JpYVV+YeYvTmYFIS5RVZBhTiS8pPqcxILM6ILyrNSS1WEuH9vBkozAsXTirNyVaS4j23BSgq
        DBfNSy0vzkktAUbkIUYJDmagtgVNIG0piZVVqUX5EMMOMUpzsCiJ885SWRcrJJCeWJKanZpa
        kFoEkw3h4FCS4F0PMlmwKDU9tSItM6cEJg3Ud4hPOU5IAFkG7BhZ3iJgghESQ5ZAdg8TB+ch
        Rg8OHqCjuLaCHFVckJhbnJkONVeYNxmknQcmCjZTkncbyBlCMEGEeacYEzk2z126iJnj+vu9
        S5mFWPLy81KlxHmNQEYLgNRnlObBXS0lxut2C+hqfiQJkAVSMry2nUpxQqJI4gg7XjG6AiNJ
        mPcJyA08wPyBcK0QbwNIkBsqCHasBO9DcJhBxZDN8QDGrAjvVXMlkLdLEkuQvV0wVQnkbago
        1Nt5IEEhmCDCKKkGpilHJmja32pxFJ69Ydq6vvcVB+WkPq35HrLZRPaGVGSa4MkV2k+vHT3D
        JrTssNvmquS/kfvm7XOvOpA6M/SWbC5T9Tzj74Lft12/ueXd1RnPC2QkDC/ZRBhranOG/p20
        vmyeZCXfYV6bHaWOp74ZaWkLfL0rcjlM1lpq86rAo2VeH0/Pr1H8+CbxA190w/aU+ena2ft7
        cg/ev1ay4OabBYZtx7IuuFz6XFr3JnbxK7Hp+frfHNKSTwQYhr9bPpPjuHS83NU7ZhKqvTxy
        VXvP7JCY/eXMPIFd148Zhxcw1Zw712Zr3tFwhSH4DPfW6jsLWnIauxZdircJT1MOluzWneLE
        mxrMKavNuXJ7nNrpTCWW4oxEQy3mouJEAJQVCyu6BAAA
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset changes akcipher api to support ECDSA style signature 
verification and x509 parser to load ECDSA certificates and implements 
ECDSA (nistp192, nistp256 and nistp384) signature verification. It 
working to verify kernel module signatures and was made on kernel 5.4.2.

I am working on the p521 curve and soon I will attach it to this work.

Tested on x86_64 and i386 with openssl default generated certificates.

I will appreciate your comments.

---
  crypto/Kconfig                        |  10 +
  crypto/Makefile                       |   5 +
  crypto/asymmetric_keys/pkcs7_parser.c |  20 +-
  crypto/ecc.c                          | 264 +++++++++++++------
  crypto/ecc.h                          |  32 +++
  crypto/ecc_curve_defs.h               |  32 +++
  crypto/ecdsa.c                        | 366 ++++++++++++++++++++++++++
  crypto/ecdsa_params.asn1              |   3 +
  crypto/ecdsa_signature.asn1           |   6 +
  include/crypto/ecdh.h                 |   1 +
  include/linux/oid_registry.h          |  10 +
  lib/oid_registry.c                    |  92 +++++++
  12 files changed, 751 insertions(+), 90 deletions(-)
  create mode 100644 crypto/ecdsa.c
  create mode 100644 crypto/ecdsa_params.asn1
  create mode 100644 crypto/ecdsa_signature.asn1

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9e524044d..41c0ea62d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -251,6 +251,16 @@ config CRYPTO_ECDH
      help
        Generic implementation of the ECDH algorithm

+config CRYPTO_ECDSA
+    tristate "ECDSA algorithm"
+    select CRYPTO_ECC
+    select CRYPTO_AKCIPHER
+    select CRYPTO_MANAGER
+    select MPILIB
+    select ASN1
+    help
+      Generic implementation of the ECDSA eliptical curve public key 
algorithm.
+
  config CRYPTO_ECRDSA
      tristate "EC-RDSA (GOST 34.10) algorithm"
      select CRYPTO_ECC
diff --git a/crypto/Makefile b/crypto/Makefile
index fcb1ee679..9010871cf 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -171,6 +171,11 @@ ecdh_generic-y += ecdh.o
  ecdh_generic-y += ecdh_helper.o
  obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o

+$(obj)/ecdsa_signature.asn1.o: $(obj)/ecdsa_signature.asn1.c 
$(obj)/ecdsa_signature.asn1.h
+$(obj)/ecdsa_params.asn1.o: $(obj)/ecdsa_params.asn1.c 
$(obj)/ecdsa_params.asn1.h
+ecdsa_generic-y := ecdsa_signature.asn1.o ecdsa_params.asn1.o ecdsa.o
+obj-$(CONFIG_CRYPTO_ECDSA) += ecdsa_generic.o
+
  $(obj)/ecrdsa_params.asn1.o: $(obj)/ecrdsa_params.asn1.c 
$(obj)/ecrdsa_params.asn1.h
  $(obj)/ecrdsa_pub_key.asn1.o: $(obj)/ecrdsa_pub_key.asn1.c 
$(obj)/ecrdsa_pub_key.asn1.h
  $(obj)/ecrdsa.o: $(obj)/ecrdsa_params.asn1.h $(obj)/ecrdsa_pub_key.asn1.h
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c 
b/crypto/asymmetric_keys/pkcs7_parser.c
index 967329e0a..e6a371923 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -228,25 +228,13 @@ int pkcs7_sig_note_digest_algo(void *context, 
size_t hdrlen,

      switch (ctx->last_oid) {
      case OID_md4:
-        ctx->sinfo->sig->hash_algo = "md4";
-        break;
      case OID_md5:
-        ctx->sinfo->sig->hash_algo = "md5";
-        break;
      case OID_sha1:
-        ctx->sinfo->sig->hash_algo = "sha1";
-        break;
      case OID_sha256:
-        ctx->sinfo->sig->hash_algo = "sha256";
-        break;
      case OID_sha384:
-        ctx->sinfo->sig->hash_algo = "sha384";
-        break;
      case OID_sha512:
-        ctx->sinfo->sig->hash_algo = "sha512";
-        break;
      case OID_sha224:
-        ctx->sinfo->sig->hash_algo = "sha224";
+        lookup_oid_digest_info(ctx->last_oid, 
&ctx->sinfo->sig->hash_algo, NULL, NULL);
          break;
      default:
          printk("Unsupported digest algo: %u\n", ctx->last_oid);
@@ -266,8 +254,10 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t 
hdrlen,

      switch (ctx->last_oid) {
      case OID_rsaEncryption:
-        ctx->sinfo->sig->pkey_algo = "rsa";
-        ctx->sinfo->sig->encoding = "pkcs1";
+    case OID_id_ecdsa_with_sha256:
+    case OID_id_ecdsa_with_sha384:
+    case OID_id_ecdsa_with_sha512:
+        lookup_oid_sign_info(ctx->last_oid, 
&ctx->sinfo->sig->pkey_algo, &ctx->sinfo->sig->encoding);
          break;
      default:
          printk("Unsupported pkey algo: %u\n", ctx->last_oid);
diff --git a/crypto/ecc.c b/crypto/ecc.c
index dfe114bc0..490dbca49 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -50,6 +50,8 @@ static inline const struct ecc_curve 
*ecc_get_curve(unsigned int curve_id)
          return fips_enabled ? NULL : &nist_p192;
      case ECC_CURVE_NIST_P256:
          return &nist_p256;
+    case ECC_CURVE_NIST_P384:
+        return &nist_p384;
      default:
          return NULL;
      }
@@ -775,27 +777,132 @@ static void vli_mmod_fast_256(u64 *result, const 
u64 *product,
      }
  }

+/* Computes result = product % curve_prime
+ * from "Mathematical routines for the NIST prime elliptic curves"
+ */
+static void vli_mmod_fast_384(u64 *result, const u64 *product,
+            const u64 *curve_prime, u64 *tmp)
+{
+    int carry;
+    const unsigned int ndigits = 6;
+
+    /* t */
+    vli_set(result, product, ndigits);
+
+    /* s1 */
+    tmp[0] = 0;                                            // 0 || 0
+    tmp[1] = 0;                                            // 0 || 0
+    tmp[2] = (u64)product[11]<<32 | (product[10]>>32);    //a22||a21
+    tmp[3] = product[11]>>32;                            // 0 ||a23
+    tmp[4] = 0;                                            // 0 || 0
+    tmp[5] = 0;                                            // 0 || 0
+    carry = vli_lshift(tmp, tmp, 1, ndigits);
+    carry += vli_add(result, result, tmp, ndigits);
+
+    /* s2 */
+    tmp[0] = product[6];     //a13||a12
+    tmp[1] = product[7];    //a15||a14
+    tmp[2] = product[8];    //a17||a16
+    tmp[3] = product[9];    //a19||a18
+    tmp[4] = product[10];    //a21||a20
+    tmp[5] = product[11];    //a23||a22
+    carry += vli_add(result, result, tmp, ndigits);
+
+    /* s3 */
+    tmp[0] = ((u64)product[11]<<32 | (product[10]>>32));    //a22||a21
+    tmp[1] = ((u64)product[6]<<32  | (product[11]>>32));    //a12||a23
+    tmp[2] = ((u64)product[7]<<32  | (product[6]>>32));        //a14||a13
+    tmp[3] = ((u64)product[8]<<32  | (product[7]>>32));        //a16||a15
+    tmp[4] = ((u64)product[9]<<32  | (product[8]>>32));        //a18||a17
+    tmp[5] = ((u64)product[10]<<32 | (product[9]>>32));        //a20||a19
+    carry += vli_add(result, result, tmp, ndigits);
+
+    /* s4 */
+    tmp[0] = product[11]&0xffFFffFF00000000ull;    //a23|| 0
+    tmp[1] = product[10]<<32;                    //a20|| 0
+    tmp[2] = product[6];                        //a13||a12
+    tmp[3] = product[7];                        //a15||a14
+    tmp[4] = product[8];                        //a17||a16
+    tmp[5] = product[9];                        //a19||a18
+    carry += vli_add(result, result, tmp, ndigits);
+
+    /* s5 */
+    tmp[0] = 0;                //  0|| 0
+    tmp[1] = 0;                //  0|| 0
+    tmp[2] = product[10];    //a21||a20
+    tmp[3] = product[11];    //a23||a22
+    tmp[4] = 0;                //  0|| 0
+    tmp[5] = 0;                //  0|| 0
+    carry += vli_add(result, result, tmp, ndigits);
+
+    /* s6 */
+    tmp[0] = product[10]&0x00000000ffFFffFFull;    // 0 ||a20
+    tmp[1] = product[10]&0xffFFffFF00000000ull;    //a21|| 0
+    tmp[2] = product[11];                        //a23||a22
+    tmp[3] = 0;                                    // 0 || 0
+    tmp[4] = 0;                                    // 0 || 0
+    tmp[5] = 0;                                    // 0 || 0
+    carry += vli_add(result, result, tmp, ndigits);
+
+    /* d1 */
+    tmp[0] = ((u64)product[6]<<32  | (product[11]>>32));    //a12||a23
+    tmp[1] = ((u64)product[7]<<32  | (product[6]>>32));        //a14||a13
+    tmp[2] = ((u64)product[8]<<32  | (product[7]>>32));        //a16||a15
+    tmp[3] = ((u64)product[9]<<32  | (product[8]>>32));        //a18||a17
+    tmp[4] = ((u64)product[10]<<32 | (product[9]>>32));        //a20||a19
+    tmp[5] = ((u64)product[11]<<32 | (product[10]>>32));    //a22||a21
+    carry -= vli_sub(result, result, tmp, ndigits);
+
+    /* d2 */
+    tmp[0] = product[10]<<32; //a20|| 0
+    tmp[1] = (product[11]<<32 | (product[10]>>32));    //a22||a21
+    tmp[2] = product[11]>>32;                        // 0 ||a23
+    tmp[3] = 0;                                        // 0 || 0
+    tmp[4] = 0;                                        // 0 || 0
+    tmp[5] = 0;                                        // 0 || 0
+    carry -= vli_sub(result, result, tmp, ndigits);
+
+    /* d3 */
+    tmp[0] = 0;                                    // 0 || 0
+    tmp[1] = product[11]&0xffFFffFF00000000ull;    //a23|| 0
+    tmp[2] = product[11]>>32;                    // 0 ||a23
+    tmp[3] = 0;                                    // 0 || 0
+    tmp[4] = 0;                                    // 0 || 0
+    tmp[5] = 0;                                    // 0 || 0
+    carry -= vli_sub(result, result, tmp, ndigits);
+
+    if (carry < 0) {
+        do {
+            carry += vli_add(result, result, curve_prime, ndigits);
+        } while (carry < 0);
+    } else {
+        while (carry || vli_cmp(curve_prime, result, ndigits) != 1)
+            carry -= vli_sub(result, result, curve_prime, ndigits);
+    }
+}
+
  /* Computes result = product % curve_prime for different curve_primes.
   *
   * Note that curve_primes are distinguished just by heuristic check and
   * not by complete conformance check.
   */
  static bool vli_mmod_fast(u64 *result, u64 *product,
-              const u64 *curve_prime, unsigned int ndigits)
+              const u64 *curve_prime, unsigned int ndigits,
+              const struct ecc_curve *curve)
  {
      u64 tmp[2 * ECC_MAX_DIGITS];

-    /* Currently, both NIST primes have -1 in lowest qword. */
-    if (curve_prime[0] != -1ull) {
+        /* Currently, both NIST primes have -1 in lowest qword. */
+    if (!curve || strncmp(curve->name, "nist", 4) != 0) {
          /* Try to handle Pseudo-Marsenne primes. */
          if (curve_prime[ndigits - 1] == -1ull) {
              vli_mmod_special(result, product, curve_prime,
-                     ndigits);
+                    ndigits);
              return true;
          } else if (curve_prime[ndigits - 1] == 1ull << 63 &&
-               curve_prime[ndigits - 2] == 0) {
+                curve_prime[ndigits - 2] == 0) {
              vli_mmod_special2(result, product, curve_prime,
-                      ndigits);
+                    ndigits);
              return true;
          }
          vli_mmod_barrett(result, product, curve_prime, ndigits);
@@ -809,6 +916,9 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
      case 4:
          vli_mmod_fast_256(result, product, curve_prime, tmp);
          break;
+    case 6:
+        vli_mmod_fast_384(result, product, curve_prime, tmp);
+        break;
      default:
          pr_err_ratelimited("ecc: unsupported digits size!\n");
          return false;
@@ -821,7 +931,7 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
   * Assumes that mod is big enough curve order.
   */
  void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
-               const u64 *mod, unsigned int ndigits)
+            const u64 *mod, unsigned int ndigits)
  {
      u64 product[ECC_MAX_DIGITS * 2];

@@ -830,24 +940,36 @@ void vli_mod_mult_slow(u64 *result, const u64 
*left, const u64 *right,
  }
  EXPORT_SYMBOL(vli_mod_mult_slow);

+/* Computes result = input % curve_prime. */
+void vli_mod_slow(u64 *result, const u64 *input,
+               const u64 *mod, unsigned int ndigits)
+{
+    u64 product[ECC_MAX_DIGITS * 2] = {0};
+    vli_set(&product[0], input, ndigits);
+    vli_mmod_slow(result, product, mod, ndigits);
+}
+EXPORT_SYMBOL(vli_mod_slow);
+
  /* Computes result = (left * right) % curve_prime. */
  static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 
*right,
-                  const u64 *curve_prime, unsigned int ndigits)
+                  const u64 *curve_prime, unsigned int ndigits,
+                  const struct ecc_curve *curve)
  {
      u64 product[2 * ECC_MAX_DIGITS];

      vli_mult(product, left, right, ndigits);
-    vli_mmod_fast(result, product, curve_prime, ndigits);
+    vli_mmod_fast(result, product, curve_prime, ndigits, curve);
  }

  /* Computes result = left^2 % curve_prime. */
  static void vli_mod_square_fast(u64 *result, const u64 *left,
-                const u64 *curve_prime, unsigned int ndigits)
+                const u64 *curve_prime, unsigned int ndigits,
+                const struct ecc_curve *curve)
  {
      u64 product[2 * ECC_MAX_DIGITS];

      vli_square(product, left, ndigits);
-    vli_mmod_fast(result, product, curve_prime, ndigits);
+    vli_mmod_fast(result, product, curve_prime, ndigits, curve);
  }

  #define EVEN(vli) (!(vli[0] & 1))
@@ -945,7 +1067,8 @@ static bool ecc_point_is_zero(const struct 
ecc_point *point)

  /* Double in place */
  static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
-                      u64 *curve_prime, unsigned int ndigits)
+                      u64 *curve_prime, unsigned int ndigits,
+                      const struct ecc_curve *curve)
  {
      /* t1 = x, t2 = y, t3 = z */
      u64 t4[ECC_MAX_DIGITS];
@@ -955,15 +1078,15 @@ static void ecc_point_double_jacobian(u64 *x1, 
u64 *y1, u64 *z1,
          return;

      /* t4 = y1^2 */
-    vli_mod_square_fast(t4, y1, curve_prime, ndigits);
+    vli_mod_square_fast(t4, y1, curve_prime, ndigits, curve);
      /* t5 = x1*y1^2 = A */
-    vli_mod_mult_fast(t5, x1, t4, curve_prime, ndigits);
+    vli_mod_mult_fast(t5, x1, t4, curve_prime, ndigits, curve);
      /* t4 = y1^4 */
-    vli_mod_square_fast(t4, t4, curve_prime, ndigits);
+    vli_mod_square_fast(t4, t4, curve_prime, ndigits, curve);
      /* t2 = y1*z1 = z3 */
-    vli_mod_mult_fast(y1, y1, z1, curve_prime, ndigits);
+    vli_mod_mult_fast(y1, y1, z1, curve_prime, ndigits, curve);
      /* t3 = z1^2 */
-    vli_mod_square_fast(z1, z1, curve_prime, ndigits);
+    vli_mod_square_fast(z1, z1, curve_prime, ndigits, curve);

      /* t1 = x1 + z1^2 */
      vli_mod_add(x1, x1, z1, curve_prime, ndigits);
@@ -972,7 +1095,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 
*y1, u64 *z1,
      /* t3 = x1 - z1^2 */
      vli_mod_sub(z1, x1, z1, curve_prime, ndigits);
      /* t1 = x1^2 - z1^4 */
-    vli_mod_mult_fast(x1, x1, z1, curve_prime, ndigits);
+    vli_mod_mult_fast(x1, x1, z1, curve_prime, ndigits, curve);

      /* t3 = 2*(x1^2 - z1^4) */
      vli_mod_add(z1, x1, x1, curve_prime, ndigits);
@@ -989,7 +1112,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 
*y1, u64 *z1,
      /* t1 = 3/2*(x1^2 - z1^4) = B */

      /* t3 = B^2 */
-    vli_mod_square_fast(z1, x1, curve_prime, ndigits);
+    vli_mod_square_fast(z1, x1, curve_prime, ndigits, curve);
      /* t3 = B^2 - A */
      vli_mod_sub(z1, z1, t5, curve_prime, ndigits);
      /* t3 = B^2 - 2A = x3 */
@@ -997,7 +1120,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 
*y1, u64 *z1,
      /* t5 = A - x3 */
      vli_mod_sub(t5, t5, z1, curve_prime, ndigits);
      /* t1 = B * (A - x3) */
-    vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+    vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits, curve);
      /* t4 = B * (A - x3) - y1^4 = y3 */
      vli_mod_sub(t4, x1, t4, curve_prime, ndigits);

@@ -1008,20 +1131,20 @@ static void ecc_point_double_jacobian(u64 *x1, 
u64 *y1, u64 *z1,

  /* Modify (x1, y1) => (x1 * z^2, y1 * z^3) */
  static void apply_z(u64 *x1, u64 *y1, u64 *z, u64 *curve_prime,
-            unsigned int ndigits)
+            unsigned int ndigits, const struct ecc_curve *curve)
  {
      u64 t1[ECC_MAX_DIGITS];

-    vli_mod_square_fast(t1, z, curve_prime, ndigits);    /* z^2 */
-    vli_mod_mult_fast(x1, x1, t1, curve_prime, ndigits); /* x1 * z^2 */
-    vli_mod_mult_fast(t1, t1, z, curve_prime, ndigits);  /* z^3 */
-    vli_mod_mult_fast(y1, y1, t1, curve_prime, ndigits); /* y1 * z^3 */
+    vli_mod_square_fast(t1, z, curve_prime, ndigits, curve); /* z^2 */
+    vli_mod_mult_fast(x1, x1, t1, curve_prime, ndigits, curve); /* x1 * 
z^2 */
+    vli_mod_mult_fast(t1, t1, z, curve_prime, ndigits, curve); /* z^3 */
+    vli_mod_mult_fast(y1, y1, t1, curve_prime, ndigits, curve); /* y1 * 
z^3 */
  }

  /* P = (x1, y1) => 2P, (x2, y2) => P' */
  static void xycz_initial_double(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
                  u64 *p_initial_z, u64 *curve_prime,
-                unsigned int ndigits)
+                unsigned int ndigits, const struct ecc_curve *curve)
  {
      u64 z[ECC_MAX_DIGITS];

@@ -1034,11 +1157,11 @@ static void xycz_initial_double(u64 *x1, u64 
*y1, u64 *x2, u64 *y2,
      if (p_initial_z)
          vli_set(z, p_initial_z, ndigits);

-    apply_z(x1, y1, z, curve_prime, ndigits);
+    apply_z(x1, y1, z, curve_prime, ndigits, curve);

-    ecc_point_double_jacobian(x1, y1, z, curve_prime, ndigits);
+    ecc_point_double_jacobian(x1, y1, z, curve_prime, ndigits, curve);

-    apply_z(x2, y2, z, curve_prime, ndigits);
+    apply_z(x2, y2, z, curve_prime, ndigits, curve);
  }

  /* Input P = (x1, y1, Z), Q = (x2, y2, Z)
@@ -1046,7 +1169,7 @@ static void xycz_initial_double(u64 *x1, u64 *y1, 
u64 *x2, u64 *y2,
   * or P => P', Q => P + Q
   */
  static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
-             unsigned int ndigits)
+             unsigned int ndigits, const struct ecc_curve *curve)
  {
      /* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
      u64 t5[ECC_MAX_DIGITS];
@@ -1054,15 +1177,15 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, 
u64 *y2, u64 *curve_prime,
      /* t5 = x2 - x1 */
      vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
      /* t5 = (x2 - x1)^2 = A */
-    vli_mod_square_fast(t5, t5, curve_prime, ndigits);
+    vli_mod_square_fast(t5, t5, curve_prime, ndigits, curve);
      /* t1 = x1*A = B */
-    vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+    vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits, curve);
      /* t3 = x2*A = C */
-    vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits);
+    vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits, curve);
      /* t4 = y2 - y1 */
      vli_mod_sub(y2, y2, y1, curve_prime, ndigits);
      /* t5 = (y2 - y1)^2 = D */
-    vli_mod_square_fast(t5, y2, curve_prime, ndigits);
+    vli_mod_square_fast(t5, y2, curve_prime, ndigits, curve);

      /* t5 = D - B */
      vli_mod_sub(t5, t5, x1, curve_prime, ndigits);
@@ -1071,11 +1194,11 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, 
u64 *y2, u64 *curve_prime,
      /* t3 = C - B */
      vli_mod_sub(x2, x2, x1, curve_prime, ndigits);
      /* t2 = y1*(C - B) */
-    vli_mod_mult_fast(y1, y1, x2, curve_prime, ndigits);
+    vli_mod_mult_fast(y1, y1, x2, curve_prime, ndigits, curve);
      /* t3 = B - x3 */
      vli_mod_sub(x2, x1, t5, curve_prime, ndigits);
      /* t4 = (y2 - y1)*(B - x3) */
-    vli_mod_mult_fast(y2, y2, x2, curve_prime, ndigits);
+    vli_mod_mult_fast(y2, y2, x2, curve_prime, ndigits, curve);
      /* t4 = y3 */
      vli_mod_sub(y2, y2, y1, curve_prime, ndigits);

@@ -1087,7 +1210,7 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, 
u64 *y2, u64 *curve_prime,
   * or P => P - Q, Q => P + Q
   */
  static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 
*curve_prime,
-               unsigned int ndigits)
+               unsigned int ndigits, const struct ecc_curve *curve)
  {
      /* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
      u64 t5[ECC_MAX_DIGITS];
@@ -1097,11 +1220,11 @@ static void xycz_add_c(u64 *x1, u64 *y1, u64 
*x2, u64 *y2, u64 *curve_prime,
      /* t5 = x2 - x1 */
      vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
      /* t5 = (x2 - x1)^2 = A */
-    vli_mod_square_fast(t5, t5, curve_prime, ndigits);
+    vli_mod_square_fast(t5, t5, curve_prime, ndigits, curve);
      /* t1 = x1*A = B */
-    vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+    vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits, curve);
      /* t3 = x2*A = C */
-    vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits);
+    vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits, curve);
      /* t4 = y2 + y1 */
      vli_mod_add(t5, y2, y1, curve_prime, ndigits);
      /* t4 = y2 - y1 */
@@ -1110,29 +1233,29 @@ static void xycz_add_c(u64 *x1, u64 *y1, u64 
*x2, u64 *y2, u64 *curve_prime,
      /* t6 = C - B */
      vli_mod_sub(t6, x2, x1, curve_prime, ndigits);
      /* t2 = y1 * (C - B) */
-    vli_mod_mult_fast(y1, y1, t6, curve_prime, ndigits);
+    vli_mod_mult_fast(y1, y1, t6, curve_prime, ndigits, curve);
      /* t6 = B + C */
      vli_mod_add(t6, x1, x2, curve_prime, ndigits);
      /* t3 = (y2 - y1)^2 */
-    vli_mod_square_fast(x2, y2, curve_prime, ndigits);
+    vli_mod_square_fast(x2, y2, curve_prime, ndigits, curve);
      /* t3 = x3 */
      vli_mod_sub(x2, x2, t6, curve_prime, ndigits);

      /* t7 = B - x3 */
      vli_mod_sub(t7, x1, x2, curve_prime, ndigits);
      /* t4 = (y2 - y1)*(B - x3) */
-    vli_mod_mult_fast(y2, y2, t7, curve_prime, ndigits);
+    vli_mod_mult_fast(y2, y2, t7, curve_prime, ndigits, curve);
      /* t4 = y3 */
      vli_mod_sub(y2, y2, y1, curve_prime, ndigits);

      /* t7 = (y2 + y1)^2 = F */
-    vli_mod_square_fast(t7, t5, curve_prime, ndigits);
+    vli_mod_square_fast(t7, t5, curve_prime, ndigits, curve);
      /* t7 = x3' */
      vli_mod_sub(t7, t7, t6, curve_prime, ndigits);
      /* t6 = x3' - B */
      vli_mod_sub(t6, t7, x1, curve_prime, ndigits);
      /* t6 = (y2 + y1)*(x3' - B) */
-    vli_mod_mult_fast(t6, t6, t5, curve_prime, ndigits);
+    vli_mod_mult_fast(t6, t6, t5, curve_prime, ndigits, curve);
      /* t2 = y3' */
      vli_mod_sub(y1, t6, y1, curve_prime, ndigits);

@@ -1163,40 +1286,40 @@ static void ecc_point_mult(struct ecc_point *result,
      vli_set(ry[1], point->y, ndigits);

      xycz_initial_double(rx[1], ry[1], rx[0], ry[0], initial_z, 
curve_prime,
-                ndigits);
+                ndigits, curve);

      for (i = num_bits - 2; i > 0; i--) {
          nb = !vli_test_bit(scalar, i);
          xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb], curve_prime,
-               ndigits);
+               ndigits, curve);
          xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve_prime,
-             ndigits);
+             ndigits, curve);
      }

      nb = !vli_test_bit(scalar, 0);
      xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb], curve_prime,
-           ndigits);
+           ndigits, curve);

      /* Find final 1/Z value. */
      /* X1 - X0 */
      vli_mod_sub(z, rx[1], rx[0], curve_prime, ndigits);
      /* Yb * (X1 - X0) */
-    vli_mod_mult_fast(z, z, ry[1 - nb], curve_prime, ndigits);
+    vli_mod_mult_fast(z, z, ry[1 - nb], curve_prime, ndigits, curve);
      /* xP * Yb * (X1 - X0) */
-    vli_mod_mult_fast(z, z, point->x, curve_prime, ndigits);
+    vli_mod_mult_fast(z, z, point->x, curve_prime, ndigits, curve);

      /* 1 / (xP * Yb * (X1 - X0)) */
      vli_mod_inv(z, z, curve_prime, point->ndigits);

      /* yP / (xP * Yb * (X1 - X0)) */
-    vli_mod_mult_fast(z, z, point->y, curve_prime, ndigits);
+    vli_mod_mult_fast(z, z, point->y, curve_prime, ndigits, curve);
      /* Xb * yP / (xP * Yb * (X1 - X0)) */
-    vli_mod_mult_fast(z, z, rx[1 - nb], curve_prime, ndigits);
+    vli_mod_mult_fast(z, z, rx[1 - nb], curve_prime, ndigits, curve);
      /* End 1/Z calculation */

-    xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve_prime, ndigits);
+    xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve_prime, 
ndigits, curve);

-    apply_z(rx[0], ry[0], z, curve_prime, ndigits);
+    apply_z(rx[0], ry[0], z, curve_prime, ndigits, curve);

      vli_set(result->x, rx[0], ndigits);
      vli_set(result->y, ry[0], ndigits);
@@ -1217,9 +1340,9 @@ static void ecc_point_add(const struct ecc_point 
*result,
      vli_mod_sub(z, result->x, p->x, curve->p, ndigits);
      vli_set(px, p->x, ndigits);
      vli_set(py, p->y, ndigits);
-    xycz_add(px, py, result->x, result->y, curve->p, ndigits);
+    xycz_add(px, py, result->x, result->y, curve->p, ndigits, curve);
      vli_mod_inv(z, z, curve->p, ndigits);
-    apply_z(result->x, result->y, z, curve->p, ndigits);
+    apply_z(result->x, result->y, z, curve->p, ndigits, curve);
  }

  /* Computes R = u1P + u2Q mod p using Shamir's trick.
@@ -1260,7 +1383,7 @@ void ecc_point_mult_shamir(const struct ecc_point 
*result,
      z[0] = 1;

      for (--i; i >= 0; i--) {
-        ecc_point_double_jacobian(rx, ry, z, curve->p, ndigits);
+        ecc_point_double_jacobian(rx, ry, z, curve->p, ndigits, curve);
          idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
          point = points[idx];
          if (point) {
@@ -1270,26 +1393,17 @@ void ecc_point_mult_shamir(const struct 
ecc_point *result,

              vli_set(tx, point->x, ndigits);
              vli_set(ty, point->y, ndigits);
-            apply_z(tx, ty, z, curve->p, ndigits);
+            apply_z(tx, ty, z, curve->p, ndigits, curve);
              vli_mod_sub(tz, rx, tx, curve->p, ndigits);
-            xycz_add(tx, ty, rx, ry, curve->p, ndigits);
-            vli_mod_mult_fast(z, z, tz, curve->p, ndigits);
+            xycz_add(tx, ty, rx, ry, curve->p, ndigits, curve);
+            vli_mod_mult_fast(z, z, tz, curve->p, ndigits, curve);
          }
      }
      vli_mod_inv(z, z, curve->p, ndigits);
-    apply_z(rx, ry, z, curve->p, ndigits);
+    apply_z(rx, ry, z, curve->p, ndigits, curve);
  }
  EXPORT_SYMBOL(ecc_point_mult_shamir);

-static inline void ecc_swap_digits(const u64 *in, u64 *out,
-                   unsigned int ndigits)
-{
-    int i;
-
-    for (i = 0; i < ndigits; i++)
-        out[i] = __swab64(in[ndigits - 1 - i]);
-}
-
  static int __ecc_is_key_valid(const struct ecc_curve *curve,
                    const u64 *private_key, unsigned int ndigits)
  {
@@ -1438,10 +1552,10 @@ int ecc_is_pubkey_valid_partial(const struct 
ecc_curve *curve,
          return -EINVAL;

      /* Check 3: Verify that y^2 == (x^3 + a·x + b) mod p */
-    vli_mod_square_fast(yy, pk->y, curve->p, pk->ndigits); /* y^2 */
-    vli_mod_square_fast(xxx, pk->x, curve->p, pk->ndigits); /* x^2 */
-    vli_mod_mult_fast(xxx, xxx, pk->x, curve->p, pk->ndigits); /* x^3 */
-    vli_mod_mult_fast(w, curve->a, pk->x, curve->p, pk->ndigits); /* a·x */
+    vli_mod_square_fast(yy, pk->y, curve->p, pk->ndigits, curve); /* y^2 */
+    vli_mod_square_fast(xxx, pk->x, curve->p, pk->ndigits, curve); /* 
x^2 */
+    vli_mod_mult_fast(xxx, xxx, pk->x, curve->p, pk->ndigits, curve); 
/* x^3 */
+    vli_mod_mult_fast(w, curve->a, pk->x, curve->p, pk->ndigits, 
curve); /* a·x */
      vli_mod_add(w, w, curve->b, curve->p, pk->ndigits); /* a·x + b */
      vli_mod_add(w, w, xxx, curve->p, pk->ndigits); /* x^3 + a·x + b */
      if (vli_cmp(yy, w, pk->ndigits) != 0) /* Equation */
diff --git a/crypto/ecc.h b/crypto/ecc.h
index ab0eb70b9..3d4c31d51 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -29,6 +29,8 @@
  /* One digit is u64 qword. */
  #define ECC_CURVE_NIST_P192_DIGITS  3
  #define ECC_CURVE_NIST_P256_DIGITS  4
+#define ECC_CURVE_NIST_P384_DIGITS  6
+/* Should be 8 to support ECRDSA gostTC512 */
  #define ECC_MAX_DIGITS             (512 / 64)

  #define ECC_DIGITS_TO_BYTES_SHIFT 3
@@ -70,6 +72,22 @@ struct ecc_curve {
      u64 *b;
  };

+/**
+ * ecc_swap_digits() - Validate a given ECDH private key
+ *
+ * @in:        input 64bits
+ * @out:    output 64bits
+ * @ndigits:        curve's number of digits
+ *
+ */
+static inline void ecc_swap_digits(const u64 *in, u64 *out,
+                   unsigned int ndigits)
+{
+    int i;
+    for (i = 0; i < ndigits; i++)
+        out[i] = __swab64(in[ndigits - 1 - i]);
+}
+
  /**
   * ecc_is_key_valid() - Validate a given ECDH private key
   *
@@ -211,6 +229,20 @@ void vli_from_le64(u64 *dest, const void *src, 
unsigned int ndigits);
  void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
           unsigned int ndigits);

+/**
+ * vli_mod_slow() - Computes result = product % mod, where product is 
2N words long.
+ * Reference: Ken MacKay's micro-ecc.
+ * Currently only designed to work for curve_p or curve_n.
+ *
+ * @result:        where to write result value
+ * @product:    vli number to operate mod on
+ * @mod:        modulus
+ * @ndigits:        length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_slow(u64 *result, const u64 *input, const u64 *mod,
+                unsigned int ndigits);
  /**
   * vli_mod_mult_slow() - Modular multiplication
   *
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 69be6c7d2..b327732f6 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -54,4 +54,36 @@ static struct ecc_curve nist_p256 = {
      .b = nist_p256_b
  };

+/* NIST P-384 */
+static u64 nist_p384_g_x[] = { 0x3A545E3872760AB7ull, 
0x5502F25DBF55296Cull,
+                0x59F741E082542A38ull, 0x6E1D3B628BA79B98ull,
+                0x8Eb1C71EF320AD74ull, 0xAA87CA22BE8B0537ull };
+static u64 nist_p384_g_y[] = { 0x7A431D7C90EA0E5Full, 
0x0A60B1CE1D7E819Dull,
+                0xE9DA3113B5F0B8C0ull, 0xF8F41DBD289A147Cull,
+                0x5D9E98BF9292DC29ull, 0x3617DE4A96262C6Full };
+static u64 nist_p384_p[] = { 0x00000000FFFFFFFFull, 0xFFFFFFFF00000000ull,
+                0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+                0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_n[] = { 0xECEC196ACCC52973ull, 0x581A0DB248B0A77Aull,
+                0xC7634D81F4372DDFull, 0xFFFFFFFFFFFFFFFFull,
+                0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_a[] = { 0x00000000FFFFFFFCull, 0xFFFFFFFF00000000ull,
+                0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+                0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_b[] = { 0x2a85c8edd3ec2aefull, 0xc656398d8a2ed19dull,
+                0x0314088f5013875aull, 0x181d9c6efe814112ull,
+                0x988e056be3f82d19ull, 0xb3312fa7e23ee7e4ull };
+static struct ecc_curve nist_p384 = {
+    .name = "nist_384",
+    .g = {
+        .x = nist_p384_g_x,
+        .y = nist_p384_g_y,
+        .ndigits = 6,
+    },
+    .p = nist_p384_p,
+    .n = nist_p384_n,
+    .a = nist_p384_a,
+    .b = nist_p384_b
+};
+
  #endif
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
new file mode 100644
index 000000000..a45dd69b7
--- /dev/null
+++ b/crypto/ecdsa.c
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Elliptic Curve Digital Signature Algorithm for Cryptographic API
+ *
+ * Copyright (C) 2019 Tribunal Superior Eleitoral. All Rights Reserved.
+ * Written by Saulo Alessandre (saulo.alessandre@tse.jus.br || 
saulo.alessandre@gmail.com)
+ *
+ * References:
+ * Mathematical routines for the NIST prime elliptic curves April 05, 2010
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by 
the Free
+ * Software Foundation; either version 2 of the License, or (at your 
option)
+ * any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include <linux/oid_registry.h>
+#include "ecdsa_signature.asn1.h"
+#include "ecdsa_params.asn1.h"
+#include "ecc.h"
+#include "ecc_curve_defs.h"
+#include "crypto/public_key.h"
+
+#define ECDSA_MAX_BITS     521
+#define ECDSA_MAX_SIG_SIZE 140
+#define ECDSA_MAX_DIGITS   9
+#define MAX_DIGEST_SIZE    (512/8)
+
+#define NIST_UNPACKED_KEY_ID 0x04
+#define NISTP256_PACKED_KEY_SIZE 64
+#define NISTP384_PACKED_KEY_SIZE 96
+
+struct ecdsa_ctx {
+    enum OID algo_oid;    /* overall public key oid */
+    enum OID curve_oid;    /* parameter */
+    enum OID digest_oid;    /* parameter */
+    const struct ecc_curve *curve;    /* curve from oid */
+    unsigned int digest_len;    /* parameter (bytes) */
+    const char *digest;    /* digest name from oid */
+    unsigned int key_len;    /* @key length (bytes) */
+    const char *key;    /* raw public key */
+    struct ecc_point pub_key;
+    u64 _pubp[2][ECDSA_MAX_DIGITS];    /* point storage for @pub_key */
+};
+
+struct ecdsa_sig_ctx {
+    u64 r[ECDSA_MAX_DIGITS];
+    u64 s[ECDSA_MAX_DIGITS];
+    int sig_size;
+    u8 ndigits;
+};
+
+static int check_digest_len(int len)
+{
+    switch (len) {
+    case 32:
+    case 48:
+    case 64:
+        return 0;
+    default:
+        return -1;
+    }
+}
+
+static int ecdsa_parse_sig_rs(struct ecdsa_sig_ctx *ctx, u64 * rs,
+                  size_t hdrlen, unsigned char tag,
+                  const void *value, size_t vlen)
+{
+    u8 ndigits;
+    // skip byte 0 if exists
+    const void *idx = value;
+    if (*(u8 *) idx == 0x0) {
+        idx++;
+        vlen--;
+    }
+    ndigits = vlen / 8;
+    if (ndigits == ctx->ndigits)
+        ecc_swap_digits((const u64 *)idx, rs, ndigits);
+    else {
+        u8 nvalue[ECDSA_MAX_SIG_SIZE];
+        const u8 start = (ctx->ndigits * 8) - vlen;
+        memset(nvalue, 0, start);
+        memcpy(nvalue + start, idx, vlen);
+        ecc_swap_digits((const u64 *)nvalue, rs, ctx->ndigits);
+        vlen = ctx->ndigits * 8;
+    }
+    ctx->sig_size += vlen;
+    return 0;
+}
+
+int ecdsa_parse_sig_r(void *context, size_t hdrlen, unsigned char tag,
+              const void *value, size_t vlen)
+{
+    struct ecdsa_sig_ctx *ctx = context;
+    return ecdsa_parse_sig_rs(ctx, ctx->r, hdrlen, tag, value, vlen);
+}
+
+int ecdsa_parse_sig_s(void *context, size_t hdrlen, unsigned char tag,
+              const void *value, size_t vlen)
+{
+    struct ecdsa_sig_ctx *ctx = context;
+    return ecdsa_parse_sig_rs(ctx, ctx->s, hdrlen, tag, value, vlen);
+}
+
+#define ASN_TAG_SIZE    5
+
+CC_OPTIMIZER static int ecdsa_verify(struct akcipher_request *req)
+{
+    struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+    struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+    struct ecdsa_sig_ctx ctx_sig;
+    u8 sig[ECDSA_MAX_SIG_SIZE];
+    u8 digest[MAX_DIGEST_SIZE];
+    u16 ndigits = ctx->pub_key.ndigits;
+    u16 min_digits = (ndigits < ctx->digest_len/8) ? ndigits : 
ctx->digest_len/8;
+    u64 _r[ECDSA_MAX_DIGITS];    /* ecc_point x */
+    u64 _s[ECDSA_MAX_DIGITS];    /* ecc_point y and temp s^{-1} */
+    u64 e[ECDSA_MAX_DIGITS];    /* h \mod q */
+    u64 v[ECDSA_MAX_DIGITS];    /* s^{-1}e \mod q */
+    u64 u[ECDSA_MAX_DIGITS];    /* s^{-1}r \mod q */
+    struct ecc_point cc = ECC_POINT_INIT(_r, _s, ndigits);    /* reuse 
r, s */
+    struct scatterlist *sgl_s, *sgl_d;
+    int err;
+    int i;
+
+    if (!ctx->curve ||
+        !ctx->digest ||
+        !req->src ||
+        !ctx->pub_key.x)
+        return -EBADMSG;
+    if (check_digest_len(req->dst_len)) {
+        printk("ecdsa_verify: invalid source digest size %d\n", 
req->dst_len);
+        return -EBADMSG;
+    }
+    if (check_digest_len(ctx->digest_len)) {
+        printk("ecdsa_verify: invalid context digest size %d\n", 
ctx->digest_len);
+        return -EBADMSG;
+    }
+
+    sgl_s = req->src;
+    sgl_d = (((void *)req->src) + sizeof(struct scatterlist));
+
+    if (ctx->pub_key.ndigits != ctx->curve->g.ndigits ||
+        WARN_ON(sgl_s->length > sizeof(sig)) ||
+        WARN_ON(sgl_d->length > sizeof(digest))) {
+        printk("ecdsa_verify: invalid curve size g(%d) pub(%d) \n", 
ctx->curve->g.ndigits, ctx->pub_key.ndigits);
+        return -EBADMSG;
+    }
+    sg_copy_to_buffer(sgl_s, sg_nents_for_len(sgl_s, sgl_s->length),
+              sig, sizeof(sig));
+    sg_copy_to_buffer(sgl_d, sg_nents_for_len(sgl_d, sgl_d->length),
+              digest, sizeof(digest));
+
+    ctx_sig.sig_size = 0;
+    ctx_sig.ndigits = ndigits;
+    err = asn1_ber_decoder(&ecdsa_signature_decoder, &ctx_sig, sig, 
sgl_s->length);
+    if (err < 0)
+        return err;
+
+    /* Step 1: verify that 0 < r < q, 0 < s < q */
+    if (vli_is_zero(ctx_sig.r, ndigits) ||
+        vli_cmp(ctx_sig.r, ctx->curve->n, ndigits) == 1 ||
+        vli_is_zero(ctx_sig.s, ndigits) ||
+        vli_cmp(ctx_sig.s, ctx->curve->n, ndigits) == 1)
+        return -EKEYREJECTED;
+
+    /* need truncate digest */
+    for (i = min_digits; i < ndigits; i++)
+        e[i] = 0;
+    /* Step 2: calculate hash (h) of the message (passed as input) */
+    /* Step 3: calculate e = h \mod q */
+    vli_from_be64(e, digest, min_digits);
+    if (vli_cmp(e, ctx->curve->n, ndigits) == 1)
+        vli_sub(e, e, ctx->curve->n, ndigits);
+    if (vli_is_zero(e, ndigits))
+        e[0] = 1;
+
+    /* Step 4: calculate _s = s^{-1} \mod q */
+    vli_mod_inv(_s, ctx_sig.s, ctx->curve->n, ndigits);
+    /* Step 5: calculate u = s^{-1} * e \mod q */
+    vli_mod_mult_slow(u, _s, e, ctx->curve->n, ndigits);
+    /* Step 6: calculate v = s^{-1} * r \mod q */
+    vli_mod_mult_slow(v, _s, ctx_sig.r, ctx->curve->n, ndigits);
+    /* Step 7: calculate cc = (x0, y0) = uG + vP */
+    ecc_point_mult_shamir(&cc, u, &ctx->curve->g, v, &ctx->pub_key,
+                  ctx->curve);
+    /* v = x0 mod q */
+    vli_mod_slow(v, cc.x, ctx->curve->n, ndigits);
+
+    /* Step 9: if X0 == r signature is valid */
+    if (vli_cmp(v, ctx_sig.r, ndigits) == 0)
+        return 0;
+
+    return -EKEYREJECTED;
+}
+
+static const struct ecc_curve *get_curve_by_oid(enum OID oid)
+{
+    switch (oid) {
+    case OID_id_secp192r1:
+        return &nist_p192;
+    case OID_id_secp256r1:
+        return &nist_p256;
+    case OID_id_secp384r1:
+        return &nist_p384;
+    default:
+        return NULL;
+    }
+}
+
+int ecdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
+              const void *value, size_t vlen)
+{
+    struct ecdsa_ctx *ctx = context;
+
+    ctx->curve_oid = look_up_OID(value, vlen);
+    if (!ctx->curve_oid)
+        return -EINVAL;
+    ctx->curve = get_curve_by_oid(ctx->curve_oid);
+    return 0;
+}
+
+/* Optional. If present should match expected digest algo OID. */
+int ecdsa_param_digest(void *context, size_t hdrlen, unsigned char tag,
+               const void *value, size_t vlen)
+{
+    struct ecdsa_ctx *ctx = context;
+    int digest_oid = look_up_OID(value, vlen);
+
+    if (digest_oid != ctx->digest_oid)
+        return -EINVAL;
+    return 0;
+}
+
+int ecdsa_parse_pub_key(void *context, size_t hdrlen, unsigned char tag,
+            const void *value, size_t vlen)
+{
+    struct ecdsa_ctx *ctx = context;
+
+    ctx->key = value;
+    ctx->key_len = vlen;
+    return 0;
+}
+
+static u8 *pkey_unpack_u32(u32 * dst, void *src)
+{
+    memcpy(dst, src, sizeof(*dst));
+    return src + sizeof(*dst);
+}
+
+/* Parse BER encoded subjectPublicKey. */
+CC_OPTIMIZER static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, 
const void *key,
+                 unsigned int keylen)
+{
+    struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+    unsigned int ndigits;
+    u32 algo, paramlen;
+    u8 *params;
+    int err;
+    const u8 nist_type = *(u8 *) key;
+    u8 half_pub;
+
+    /* Key parameters is in the key after keylen. */
+    params = (u8 *) key + keylen;
+    params = pkey_unpack_u32(&algo, params);
+    params = pkey_unpack_u32(&paramlen, params);
+
+    ctx->algo_oid = algo;
+    err = lookup_oid_digest_info(ctx->algo_oid,
+                     &ctx->digest, &ctx->digest_len,
+                     &ctx->digest_oid);
+    if (err < 0)
+        return -ENOPKG;
+
+    /* Parse SubjectPublicKeyInfo.AlgorithmIdentifier.parameters. */
+    err = asn1_ber_decoder(&ecdsa_params_decoder, ctx, params, paramlen);
+    if (err < 0)
+        return err;
+    ctx->key = key;
+    ctx->key_len = keylen;
+    if (!ctx->curve)
+        return -ENOPKG;
+
+    /*
+     * Accepts only uncompressed it's not accepted
+     */
+    if (nist_type != NIST_UNPACKED_KEY_ID)
+        return -ENOPKG;
+    /* Skip nist type octet */
+    ctx->key++;
+    ctx->key_len--;
+    if (ctx->key_len != NISTP256_PACKED_KEY_SIZE
+        && ctx->key_len != NISTP384_PACKED_KEY_SIZE)
+        return -ENOPKG;
+    ndigits = ctx->key_len / sizeof(u64) / 2;
+    if (ndigits * 2 * sizeof(u64) < ctx->key_len)
+        ndigits++;
+    half_pub = ctx->key_len / 2;
+    /*
+     * Sizes of key_len and curve should match each other.
+     */
+    if (ctx->curve->g.ndigits != ndigits)
+        return -ENOPKG;
+    ctx->pub_key = ECC_POINT_INIT(ctx->_pubp[0], ctx->_pubp[1], ndigits);
+    /*
+     * X509 stores key.x and key.y as BE
+     */
+    vli_from_be64(ctx->pub_key.x, ctx->key, ndigits);
+    vli_from_be64(ctx->pub_key.y, ctx->key + half_pub, ndigits);
+    err = ecc_is_pubkey_valid_partial(ctx->curve, &ctx->pub_key);
+    if (err)
+        return -EKEYREJECTED;
+
+    return 0;
+}
+
+static unsigned int ecdsa_max_size(struct crypto_akcipher *tfm)
+{
+    struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+    /*
+     * Verify doesn't need any output, so it's just informational
+     * for keyctl to determine the key bit size.
+     */
+    return ctx->pub_key.ndigits * sizeof(u64);
+}
+
+static void ecdsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+}
+
+static struct akcipher_alg ecdsa_alg = {
+    .verify = ecdsa_verify,
+    .set_pub_key = ecdsa_set_pub_key,
+    .max_size = ecdsa_max_size,
+    .exit = ecdsa_exit_tfm,
+    .base = {
+         .cra_name = "ecdsa",
+         .cra_driver_name = "ecdsa-generic",
+         .cra_priority = 100,
+         .cra_module = THIS_MODULE,
+         .cra_ctxsize = sizeof(struct ecdsa_ctx),
+         },
+};
+
+static int __init ecdsa_mod_init(void)
+{
+    return crypto_register_akcipher(&ecdsa_alg);
+}
+
+static void __exit ecdsa_mod_fini(void)
+{
+    crypto_unregister_akcipher(&ecdsa_alg);
+}
+
+module_init(ecdsa_mod_init);
+module_exit(ecdsa_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Saulo Alessandre <saulo.alessandre@gmail.com>");
+MODULE_DESCRIPTION("EC-DSA generic algorithm");
+MODULE_ALIAS_CRYPTO("ecdsa-generic");
diff --git a/crypto/ecdsa_params.asn1 b/crypto/ecdsa_params.asn1
new file mode 100644
index 000000000..e8bef5ca8
--- /dev/null
+++ b/crypto/ecdsa_params.asn1
@@ -0,0 +1,3 @@
+EcdsaCurve ::=  OBJECT IDENTIFIER ({ ecdsa_param_curve })
+
+
\ No newline at end of file
diff --git a/crypto/ecdsa_signature.asn1 b/crypto/ecdsa_signature.asn1
new file mode 100644
index 000000000..378e73913
--- /dev/null
+++ b/crypto/ecdsa_signature.asn1
@@ -0,0 +1,6 @@
+EcdsaSignature ::= SEQUENCE {
+    signatureR  INTEGER ({ ecdsa_parse_sig_r }),
+    signatureS  INTEGER ({ ecdsa_parse_sig_s })
+}
+
+EcdsaPubKey ::= BIT STRING ({ ecdsa_parse_pub_key })
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index a5b805b55..e4ba1de96 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -25,6 +25,7 @@
  /* Curves IDs */
  #define ECC_CURVE_NIST_P192    0x0001
  #define ECC_CURVE_NIST_P256    0x0002
+#define ECC_CURVE_NIST_P384    0x0003

  /**
   * struct ecdh - define an ECDH private key
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 657d6bf2c..c6c01a412 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -19,7 +19,12 @@
  enum OID {
      OID_id_dsa_with_sha1,        /* 1.2.840.10030.4.3 */
      OID_id_dsa,            /* 1.2.840.10040.4.1 */
+    OID_id_secp192r1,     /* 1.2.840.10045.3.1.1 */
+    OID_id_secp256r1,     /* 1.2.840.10045.3.1.7 */
      OID_id_ecdsa_with_sha1,        /* 1.2.840.10045.4.1 */
+    OID_id_ecdsa_with_sha256,        /* 1.2.840.10045.4.3.2 */
+    OID_id_ecdsa_with_sha384,        /* 1.2.840.10045.4.3.3 */
+    OID_id_ecdsa_with_sha512,        /* 1.2.840.10045.4.3.4 */
      OID_id_ecPublicKey,        /* 1.2.840.10045.2.1 */

      /* PKCS#1 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) 
pkcs-1(1)} */
@@ -58,6 +63,7 @@ enum OID {

      OID_certAuthInfoAccess,        /* 1.3.6.1.5.5.7.1.1 */
      OID_sha1,            /* 1.3.14.3.2.26 */
+    OID_id_secp384r1,        /* 1.3.132.0.34 */
      OID_sha256,            /* 2.16.840.1.101.3.4.2.1 */
      OID_sha384,            /* 2.16.840.1.101.3.4.2.2 */
      OID_sha512,            /* 2.16.840.1.101.3.4.2.3 */
@@ -113,5 +119,9 @@ enum OID {
  extern enum OID look_up_OID(const void *data, size_t datasize);
  extern int sprint_oid(const void *, size_t, char *, size_t);
  extern int sprint_OID(enum OID, char *, size_t);
+extern int lookup_oid_sign_info(enum OID oid,
+        const char **sign_algo, const char **sign_encoding);
+extern int lookup_oid_digest_info(enum OID oid,
+        const char **hash_algo, u32 *hash_len, enum OID *oid_algo);

  #endif /* _LINUX_OID_REGISTRY_H */
diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index f7ad43f28..472773e0b 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -92,6 +92,98 @@ enum OID look_up_OID(const void *data, size_t datasize)
  }
  EXPORT_SYMBOL_GPL(look_up_OID);

+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wswitch"
+int lookup_oid_sign_info(enum OID oid, const char **sign_algo,
+        const char **sign_encoding) {
+    int ret = -1;
+    if (sign_algo || sign_encoding) {
+        switch (oid) {
+        case OID_md4WithRSAEncryption:
+        case OID_sha1WithRSAEncryption:
+        case OID_sha256WithRSAEncryption:
+        case OID_sha384WithRSAEncryption:
+        case OID_sha512WithRSAEncryption:
+        case OID_sha224WithRSAEncryption:
+            if (sign_algo) *sign_algo = "rsa";
+            if (sign_encoding) *sign_encoding = "pkcs1";
+            ret = 0;
+            break;
+        case OID_id_ecdsa_with_sha1:
+        case OID_id_ecdsa_with_sha256:
+        case OID_id_ecdsa_with_sha384:
+        case OID_id_ecdsa_with_sha512:
+            if (sign_algo) *sign_algo = "ecdsa";
+            if (sign_encoding) *sign_encoding = "pkcs1";
+            ret = 0;
+            break;
+        case OID_gost2012Signature256:
+        case OID_gost2012Signature512:
+            if (sign_algo) *sign_algo = "ecrdsa";
+            if (sign_encoding) *sign_encoding = "raw";
+            ret = 0;
+            break;
+        }
+    }
+    return ret;
+}
+EXPORT_SYMBOL_GPL(lookup_oid_sign_info);
+
+int lookup_oid_digest_info(enum OID oid,
+        const char **digest_algo, u32 *digest_len, enum OID *digest_oid) {
+    int ret = 0;
+    switch (oid) {
+    case OID_md4WithRSAEncryption:
+        if (digest_algo) *digest_algo = "md4";
+        if (digest_oid) *digest_oid = OID_md4;
+        if (digest_len) *digest_len = 16;
+        break;
+    case OID_sha1WithRSAEncryption:
+    case OID_id_ecdsa_with_sha1:
+        if (digest_algo) *digest_algo = "sha1";
+        if (digest_oid) *digest_oid = OID_sha1;
+        if (digest_len) *digest_len = 20;
+        break;
+    case OID_sha224WithRSAEncryption:
+        if (digest_algo) *digest_algo = "sha224";
+        if (digest_oid) *digest_oid = OID_sha224;
+        if (digest_len) *digest_len = 28;
+        break;
+    case OID_sha256WithRSAEncryption:
+    case OID_id_ecdsa_with_sha256:
+        if (digest_algo) *digest_algo = "sha256";
+        if (digest_oid) *digest_oid = OID_sha256;
+        if (digest_len) *digest_len = 32;
+        break;
+    case OID_sha384WithRSAEncryption:
+    case OID_id_ecdsa_with_sha384:
+        if (digest_algo) *digest_algo = "sha384";
+        if (digest_oid) *digest_oid = OID_sha384;
+        if (digest_len) *digest_len = 48;
+        break;
+    case OID_sha512WithRSAEncryption:
+    case OID_id_ecdsa_with_sha512:
+        if (digest_algo) *digest_algo = "sha512";
+        if (digest_oid) *digest_oid = OID_sha512;
+        if (digest_len) *digest_len = 64;
+        break;
+    case OID_gost2012Signature256:
+        if (digest_algo) *digest_algo = "streebog256";
+        if (digest_oid) *digest_oid = OID_sha256;
+        if (digest_len) *digest_len = 32;
+        break;
+    case OID_gost2012Signature512:
+        if (digest_algo) *digest_algo = "streebog512";
+        if (digest_oid) *digest_oid = OID_sha512;
+        if (digest_len) *digest_len = 64;
+        break;
+    default:
+        ret = -1;
+    }
+    return ret;
+}
+EXPORT_SYMBOL_GPL(lookup_oid_digest_info);
+
  /*
   * sprint_OID - Print an Object Identifier into a buffer
   * @data: The encoded OID to print
-- 
2.17.1


