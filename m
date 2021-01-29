Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE6EC433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E3F64E0B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhA2V12 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbhA2V1Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 16:27:16 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15EFC061756
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:35 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id a7so10172239qkb.13
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bku21q3+cr+GLzVk2k3vQze6gEe69qzWUyEGJx0VR1w=;
        b=rv0cqdkuXydUe5awBZ3awT1hE2A2oVutNJt3kWjYTMCEkxZ3AHqpoPFFW9PJcQXDBG
         fzpzmD98X9JsTZG3PuEC0VwvmK6bm2wo+rTM6qD+mD8qgnq/C7KNuc3N6bgH2I4KRv18
         MjCSLw29Yg7NvFd0n3uEK2VdUpaHFeOiZ+Mc2EkSfqkL0M91gVL9intHvCZS3qSmwNud
         Ec2Y5lo9SuU79sYIbl1nkLKpKmj8+dISZici5xz0URyXbOK71aHC9/4QU5V/kis3xbtI
         lWkjdBO6My4FSXivKrwS8wxI9wkVd9X9A3ITFaVlVfnBwIs0++M0DztiP3A2GBSOGsRQ
         9YWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bku21q3+cr+GLzVk2k3vQze6gEe69qzWUyEGJx0VR1w=;
        b=IRNludBCgF2M7MPOp2sfXnfkz7pxAzv2+yjBiUihzUZQHRbdENfuTryNReNQzf/fP7
         kFe5HS+zIPlaU4/ovALSL8R2yD1V3bE91ZmnonO0uM+F0rHCXtwuO5HXeHyXXNhw95RZ
         HnyKn2K4zIMDjk5ebyK8W0Wd+Zs/iGdWaSE7K6apgMJw5YO+sotXm/WjyYD/q/Q72Tak
         HhGuj83TVV8TCC7w58yJjOq1ScMtHsLaSjzRs/7hoVozDQ/u3TbTrKbrXzK8UZfhrq9Q
         E6YqbpwCVPhCzt4wlr6qrj3ppOzosjlFNySEfS21ZNOr5rZTQhuEW9JaBPf+xgVi8Y4c
         mIQQ==
X-Gm-Message-State: AOAM530g3GOTTqUOfzF1QBsQxzL2V1ThmN9T6SaSE7ZvC7Yoa+KMzbb5
        HXa5S2CofwdnV6P42bcQ0ndBH5D7ad8HdOSU
X-Google-Smtp-Source: ABdhPJxT//oFrOwMEmSAOen9MUma7F8Atm0SLWzKTdBn1bv3JEZ9+Tr+RQ+0Y9qmRG6X7reeM822lA==
X-Received: by 2002:a37:a10c:: with SMTP id k12mr6069341qke.443.1611955594308;
        Fri, 29 Jan 2021 13:26:34 -0800 (PST)
Received: from warrior-desktop.domains. ([189.61.66.20])
        by smtp.gmail.com with ESMTPSA id b194sm6763995qkc.102.2021.01.29.13.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:26:33 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: [PATCH v2 3/4] ecdsa: change ecc.c and ecc.h to support ecdsa
Date:   Fri, 29 Jan 2021 18:25:34 -0300
Message-Id: <20210129212535.2257493-4-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
References: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Saulo Alessandre <saulo.alessandre@tse.jus.br>

* crypto/ecc.c
  - ecc_get_curve - modified to recognize NIST_P384 and NISTP521;
  - vli_rshift - created for use on vli_mmod_fast_521 for ecdsa;
  - vli_mod_add - exported for use on ecdsa.c;
  - vli_mmod_fast_384 - implements fast elliptic curve nist p384 [4];
  - vli_mmod_fast_521 - implements fast elliptic curve nist p521 [4];
  - vli_mmod_fast - changed params to receive struct ecc_curve*;
changed condition to use correct way to detect nist algo; added new curves
(384 and 521);
  - vli_mmod_fast - changed params to receive ecc_curve;
  - vli_mod_slow - moved from .h to .c and exported for use on ecdsa.c;
  - vli_mod_mult_fast - changed params to receive struct ecc_curve*; exported
for use on ecdsa.c;
  - vli_mod_square_fast - changed params to receive struct ecc_curve*;
exported for use on ecdsa.c;
  - ecc_point_is_zero - exported for use on ecdsa.c;
  - ecc_point_double_jacobian - changed params to receive struct ecc_curve*;
  - apply_z - changed params to receive struct ecc_curve*;
  - xycz_initial_double - changed params to receive struct ecc_curve*;
  - xycz_add - changed params to receive struct ecc_curve*;
  - xycz_add_c - changed params to receive struct ecc_curve*;
  - ecc_point_mult - changed to pass struct ecc_curve* forward;
  - ecc_point_mult_shamir - changed to pass struct ecc_curve* forward;
  - ecc_is_pubkey_valid_partial - changed to pass struct ecc_curve*;

* crypto/ecc.h
  - NIST_P384 and NIST_P521 constants defined;
  - ecc_point_is_zero - added to export;
  - vli_mod_slow - added to export;
  - vli_mod_add - added to export
  - vli_mod_fast - added to export;
  - vli_mod_mult_fast - added to export.
---
 crypto/ecc.c | 338 +++++++++++++++++++++++++++++++++++++++------------
 crypto/ecc.h |  59 ++++++++-
 2 files changed, 318 insertions(+), 79 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index c80aa25994a0..f9e8b155f493 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -50,6 +50,10 @@ static inline const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 		return fips_enabled ? NULL : &nist_p192;
 	case ECC_CURVE_NIST_P256:
 		return &nist_p256;
+	case ECC_CURVE_NIST_P384:
+		return &nist_p384;
+	case ECC_CURVE_NIST_P521:
+		return &nist_p521;
 	default:
 		return NULL;
 	}
@@ -235,6 +239,25 @@ static u64 vli_lshift(u64 *result, const u64 *in, unsigned int shift,
 	return carry;
 }
 
+/* Computes result = in >> c, returning carry. */
+static u64 vli_rshift(u64 *result, const u64 *in, unsigned int shift,
+		      unsigned int ndigits)
+{
+	u64 carry = 0;
+	int i;
+
+	for (i = 0; i < ndigits; i++) {
+		if (i + 1 < ndigits)
+			carry = in[i + 1] << (64 - shift);
+		else
+			carry = 0;
+
+		result[i] = (in[i] >> shift) | carry;
+	}
+
+	return carry;
+}
+
 /* Computes vli = vli >> 1. */
 static void vli_rshift1(u64 *vli, unsigned int ndigits)
 {
@@ -474,7 +497,7 @@ static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 /* Computes result = (left + right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
  */
-static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
+void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
 			const u64 *mod, unsigned int ndigits)
 {
 	u64 carry;
@@ -487,6 +510,7 @@ static void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
 	if (carry || vli_cmp(result, mod, ndigits) >= 0)
 		vli_sub(result, result, mod, ndigits);
 }
+EXPORT_SYMBOL(vli_mod_add);
 
 /* Computes result = (left - right) % mod.
  * Assumes that left < mod and right < mod, result != mod.
@@ -775,18 +799,156 @@ static void vli_mmod_fast_256(u64 *result, const u64 *product,
 	}
 }
 
+#define SL32OR32(x32, y32) (((u64)x32 << 32) | y32)
+#define AND64H(x64)  (x64 & 0xffFFffFF00000000ull)
+#define AND64L(x64)  (x64 & 0x00000000ffFFffFFull)
+
+/* Computes result = product % curve_prime
+ * from "Mathematical routines for the NIST prime elliptic curves"
+ */
+static void vli_mmod_fast_384(u64 *result, const u64 *product,
+				const u64 *curve_prime, u64 *tmp)
+{
+	int carry;
+	const unsigned int ndigits = 6;
+
+	/* t */
+	vli_set(result, product, ndigits);
+
+	/* s1 */
+	tmp[0] = 0;		// 0 || 0
+	tmp[1] = 0;		// 0 || 0
+	tmp[2] = SL32OR32(product[11], (product[10]>>32));	//a22||a21
+	tmp[3] = product[11]>>32;	// 0 ||a23
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry = vli_lshift(tmp, tmp, 1, ndigits);
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s2 */
+	tmp[0] = product[6];	//a13||a12
+	tmp[1] = product[7];	//a15||a14
+	tmp[2] = product[8];	//a17||a16
+	tmp[3] = product[9];	//a19||a18
+	tmp[4] = product[10];	//a21||a20
+	tmp[5] = product[11];	//a23||a22
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s3 */
+	tmp[0] = SL32OR32(product[11], (product[10]>>32));	//a22||a21
+	tmp[1] = SL32OR32(product[6], (product[11]>>32));	//a12||a23
+	tmp[2] = SL32OR32(product[7], (product[6])>>32);	//a14||a13
+	tmp[3] = SL32OR32(product[8], (product[7]>>32));	//a16||a15
+	tmp[4] = SL32OR32(product[9], (product[8]>>32));	//a18||a17
+	tmp[5] = SL32OR32(product[10], (product[9]>>32));	//a20||a19
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s4 */
+	tmp[0] = AND64H(product[11]);	//a23|| 0
+	tmp[1] = (product[10]<<32);		//a20|| 0
+	tmp[2] = product[6];	//a13||a12
+	tmp[3] = product[7];	//a15||a14
+	tmp[4] = product[8];	//a17||a16
+	tmp[5] = product[9];	//a19||a18
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s5 */
+	tmp[0] = 0;		//  0|| 0
+	tmp[1] = 0;		//  0|| 0
+	tmp[2] = product[10];	//a21||a20
+	tmp[3] = product[11];	//a23||a22
+	tmp[4] = 0;		//  0|| 0
+	tmp[5] = 0;		//  0|| 0
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* s6 */
+	tmp[0] = AND64L(product[10]);	// 0 ||a20
+	tmp[1] = AND64H(product[10]);	//a21|| 0
+	tmp[2] = product[11];	//a23||a22
+	tmp[3] = 0;		// 0 || 0
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry += vli_add(result, result, tmp, ndigits);
+
+	/* d1 */
+	tmp[0] = SL32OR32(product[6], (product[11]>>32));	//a12||a23
+	tmp[1] = SL32OR32(product[7], (product[6]>>32));	//a14||a13
+	tmp[2] = SL32OR32(product[8], (product[7]>>32));	//a16||a15
+	tmp[3] = SL32OR32(product[9], (product[8]>>32));	//a18||a17
+	tmp[4] = SL32OR32(product[10], (product[9]>>32));	//a20||a19
+	tmp[5] = SL32OR32(product[11], (product[10]>>32));	//a22||a21
+	carry -= vli_sub(result, result, tmp, ndigits);
+
+	/* d2 */
+	tmp[0] = (product[10]<<32);	//a20|| 0
+	tmp[1] = SL32OR32(product[11], (product[10]>>32));	//a22||a21
+	tmp[2] = (product[11]>>32);	// 0 ||a23
+	tmp[3] = 0;		// 0 || 0
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry -= vli_sub(result, result, tmp, ndigits);
+
+	/* d3 */
+	tmp[0] = 0;		// 0 || 0
+	tmp[1] = AND64H(product[11]);	//a23|| 0
+	tmp[2] = product[11]>>32;	// 0 ||a23
+	tmp[3] = 0;		// 0 || 0
+	tmp[4] = 0;		// 0 || 0
+	tmp[5] = 0;		// 0 || 0
+	carry -= vli_sub(result, result, tmp, ndigits);
+
+	if (carry < 0) {
+		do {
+			carry += vli_add(result, result, curve_prime, ndigits);
+		} while (carry < 0);
+	} else {
+		while (carry || vli_cmp(curve_prime, result, ndigits) != 1)
+			carry -= vli_sub(result, result, curve_prime, ndigits);
+	}
+
+}
+
+#undef SL32OR32
+#undef AND64H
+#undef AND64L
+
+/* Computes result = product % curve_prime
+ * from "Mathematical routines for the NIST prime elliptic curves"
+ */
+static void vli_mmod_fast_521(u64 *result, const u64 *product,
+			      const u64 *curve_prime, u64 *tmp)
+{
+	int carry;
+	const unsigned int ndigits = 9;
+
+	/* t 512 bits + 9 bits a0 .. a520 */
+	vli_set(result, product, 9);
+	result[8] &= 0x000001ff;
+
+	/* t 512 bits + 9 bits a521 .. a1041 */
+	vli_set(tmp, product + 8, ndigits);
+	vli_rshift(tmp, tmp, 9, ndigits);
+
+	carry = vli_add(result, result, tmp, ndigits);
+
+	while (carry || vli_cmp(curve_prime, result, ndigits) != 1)
+		carry -= vli_sub(result, result, curve_prime, ndigits);
+}
+
 /* Computes result = product % curve_prime for different curve_primes.
  *
  * Note that curve_primes are distinguished just by heuristic check and
  * not by complete conformance check.
  */
 static bool vli_mmod_fast(u64 *result, u64 *product,
-			  const u64 *curve_prime, unsigned int ndigits)
+			const struct ecc_curve *curve)
 {
 	u64 tmp[2 * ECC_MAX_DIGITS];
+	const u64 *curve_prime = curve->p;
+	const unsigned int ndigits = curve->g.ndigits;
 
-	/* Currently, both NIST primes have -1 in lowest qword. */
-	if (curve_prime[0] != -1ull) {
+	/* Currently, all NIST have name nist_*. */
+	if (strncmp(curve->name, "nist_", 5) != 0) {
 		/* Try to handle Pseudo-Marsenne primes. */
 		if (curve_prime[ndigits - 1] == -1ull) {
 			vli_mmod_special(result, product, curve_prime,
@@ -809,6 +971,12 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 	case 4:
 		vli_mmod_fast_256(result, product, curve_prime, tmp);
 		break;
+	case 6:
+		vli_mmod_fast_384(result, product, curve_prime, tmp);
+		break;
+	case 9:
+		vli_mmod_fast_521(result, product, curve_prime, tmp);
+		break;
 	default:
 		pr_err_ratelimited("ecc: unsupported digits size!\n");
 		return false;
@@ -830,25 +998,38 @@ void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
 }
 EXPORT_SYMBOL(vli_mod_mult_slow);
 
+/* Computes result = input % curve_prime. */
+void vli_mod_slow(u64 *result, const u64 *input,
+		  const u64 *mod, unsigned int ndigits)
+{
+	u64 product[ECC_MAX_DIGITS * 2] = { 0 };
+
+	vli_set(&product[0], input, ndigits);
+	vli_mmod_slow(result, product, mod, ndigits);
+}
+EXPORT_SYMBOL(vli_mod_slow);
+
 /* Computes result = (left * right) % curve_prime. */
-static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
-			      const u64 *curve_prime, unsigned int ndigits)
+void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
+				const struct ecc_curve *curve)
 {
 	u64 product[2 * ECC_MAX_DIGITS];
 
-	vli_mult(product, left, right, ndigits);
-	vli_mmod_fast(result, product, curve_prime, ndigits);
+	vli_mult(product, left, right, curve->g.ndigits);
+	vli_mmod_fast(result, product, curve);
 }
+EXPORT_SYMBOL(vli_mod_mult_fast);
 
 /* Computes result = left^2 % curve_prime. */
-static void vli_mod_square_fast(u64 *result, const u64 *left,
-				const u64 *curve_prime, unsigned int ndigits)
+void vli_mod_square_fast(u64 *result, const u64 *left,
+				const struct ecc_curve *curve)
 {
 	u64 product[2 * ECC_MAX_DIGITS];
 
-	vli_square(product, left, ndigits);
-	vli_mmod_fast(result, product, curve_prime, ndigits);
+	vli_square(product, left, curve->g.ndigits);
+	vli_mmod_fast(result, product, curve);
 }
+EXPORT_SYMBOL(vli_mod_square_fast);
 
 #define EVEN(vli) (!(vli[0] & 1))
 /* Computes result = (1 / p_input) % mod. All VLIs are the same size.
@@ -933,11 +1114,12 @@ EXPORT_SYMBOL(vli_mod_inv);
 /* ------ Point operations ------ */
 
 /* Returns true if p_point is the point at infinity, false otherwise. */
-static bool ecc_point_is_zero(const struct ecc_point *point)
+bool ecc_point_is_zero(const struct ecc_point *point)
 {
 	return (vli_is_zero(point->x, point->ndigits) &&
 		vli_is_zero(point->y, point->ndigits));
 }
+EXPORT_SYMBOL(ecc_point_is_zero);
 
 /* Point multiplication algorithm using Montgomery's ladder with co-Z
  * coordinates. From https://eprint.iacr.org/2011/338.pdf
@@ -945,25 +1127,27 @@ static bool ecc_point_is_zero(const struct ecc_point *point)
 
 /* Double in place */
 static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
-				      u64 *curve_prime, unsigned int ndigits)
+					const struct ecc_curve *curve)
 {
 	/* t1 = x, t2 = y, t3 = z */
 	u64 t4[ECC_MAX_DIGITS];
 	u64 t5[ECC_MAX_DIGITS];
+	const u64 *curve_prime = curve->p;
+	const unsigned int ndigits = curve->g.ndigits;
 
 	if (vli_is_zero(z1, ndigits))
 		return;
 
 	/* t4 = y1^2 */
-	vli_mod_square_fast(t4, y1, curve_prime, ndigits);
+	vli_mod_square_fast(t4, y1, curve);
 	/* t5 = x1*y1^2 = A */
-	vli_mod_mult_fast(t5, x1, t4, curve_prime, ndigits);
+	vli_mod_mult_fast(t5, x1, t4, curve);
 	/* t4 = y1^4 */
-	vli_mod_square_fast(t4, t4, curve_prime, ndigits);
+	vli_mod_square_fast(t4, t4, curve);
 	/* t2 = y1*z1 = z3 */
-	vli_mod_mult_fast(y1, y1, z1, curve_prime, ndigits);
+	vli_mod_mult_fast(y1, y1, z1, curve);
 	/* t3 = z1^2 */
-	vli_mod_square_fast(z1, z1, curve_prime, ndigits);
+	vli_mod_square_fast(z1, z1, curve);
 
 	/* t1 = x1 + z1^2 */
 	vli_mod_add(x1, x1, z1, curve_prime, ndigits);
@@ -972,7 +1156,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 	/* t3 = x1 - z1^2 */
 	vli_mod_sub(z1, x1, z1, curve_prime, ndigits);
 	/* t1 = x1^2 - z1^4 */
-	vli_mod_mult_fast(x1, x1, z1, curve_prime, ndigits);
+	vli_mod_mult_fast(x1, x1, z1, curve);
 
 	/* t3 = 2*(x1^2 - z1^4) */
 	vli_mod_add(z1, x1, x1, curve_prime, ndigits);
@@ -989,7 +1173,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 	/* t1 = 3/2*(x1^2 - z1^4) = B */
 
 	/* t3 = B^2 */
-	vli_mod_square_fast(z1, x1, curve_prime, ndigits);
+	vli_mod_square_fast(z1, x1, curve);
 	/* t3 = B^2 - A */
 	vli_mod_sub(z1, z1, t5, curve_prime, ndigits);
 	/* t3 = B^2 - 2A = x3 */
@@ -997,7 +1181,7 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 	/* t5 = A - x3 */
 	vli_mod_sub(t5, t5, z1, curve_prime, ndigits);
 	/* t1 = B * (A - x3) */
-	vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+	vli_mod_mult_fast(x1, x1, t5, curve);
 	/* t4 = B * (A - x3) - y1^4 = y3 */
 	vli_mod_sub(t4, x1, t4, curve_prime, ndigits);
 
@@ -1007,23 +1191,22 @@ static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
 }
 
 /* Modify (x1, y1) => (x1 * z^2, y1 * z^3) */
-static void apply_z(u64 *x1, u64 *y1, u64 *z, u64 *curve_prime,
-		    unsigned int ndigits)
+static void apply_z(u64 *x1, u64 *y1, u64 *z, const struct ecc_curve *curve)
 {
 	u64 t1[ECC_MAX_DIGITS];
 
-	vli_mod_square_fast(t1, z, curve_prime, ndigits);    /* z^2 */
-	vli_mod_mult_fast(x1, x1, t1, curve_prime, ndigits); /* x1 * z^2 */
-	vli_mod_mult_fast(t1, t1, z, curve_prime, ndigits);  /* z^3 */
-	vli_mod_mult_fast(y1, y1, t1, curve_prime, ndigits); /* y1 * z^3 */
+	vli_mod_square_fast(t1, z, curve);		/* z^2 */
+	vli_mod_mult_fast(x1, x1, t1, curve);	/* x1 * z^2 */
+	vli_mod_mult_fast(t1, t1, z, curve);	/* z^3 */
+	vli_mod_mult_fast(y1, y1, t1, curve);	/* y1 * z^3 */
 }
 
 /* P = (x1, y1) => 2P, (x2, y2) => P' */
 static void xycz_initial_double(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
-				u64 *p_initial_z, u64 *curve_prime,
-				unsigned int ndigits)
+				u64 *p_initial_z, const struct ecc_curve *curve)
 {
 	u64 z[ECC_MAX_DIGITS];
+	const unsigned int ndigits = curve->g.ndigits;
 
 	vli_set(x2, x1, ndigits);
 	vli_set(y2, y1, ndigits);
@@ -1034,35 +1217,37 @@ static void xycz_initial_double(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
 	if (p_initial_z)
 		vli_set(z, p_initial_z, ndigits);
 
-	apply_z(x1, y1, z, curve_prime, ndigits);
+	apply_z(x1, y1, z, curve);
 
-	ecc_point_double_jacobian(x1, y1, z, curve_prime, ndigits);
+	ecc_point_double_jacobian(x1, y1, z, curve);
 
-	apply_z(x2, y2, z, curve_prime, ndigits);
+	apply_z(x2, y2, z, curve);
 }
 
 /* Input P = (x1, y1, Z), Q = (x2, y2, Z)
  * Output P' = (x1', y1', Z3), P + Q = (x3, y3, Z3)
  * or P => P', Q => P + Q
  */
-static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
-		     unsigned int ndigits)
+static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
+			const struct ecc_curve *curve)
 {
 	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
 	u64 t5[ECC_MAX_DIGITS];
+	const u64 *curve_prime = curve->p;
+	const unsigned int ndigits = curve->g.ndigits;
 
 	/* t5 = x2 - x1 */
 	vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
 	/* t5 = (x2 - x1)^2 = A */
-	vli_mod_square_fast(t5, t5, curve_prime, ndigits);
+	vli_mod_square_fast(t5, t5, curve);
 	/* t1 = x1*A = B */
-	vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+	vli_mod_mult_fast(x1, x1, t5, curve);
 	/* t3 = x2*A = C */
-	vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits);
+	vli_mod_mult_fast(x2, x2, t5, curve);
 	/* t4 = y2 - y1 */
 	vli_mod_sub(y2, y2, y1, curve_prime, ndigits);
 	/* t5 = (y2 - y1)^2 = D */
-	vli_mod_square_fast(t5, y2, curve_prime, ndigits);
+	vli_mod_square_fast(t5, y2, curve);
 
 	/* t5 = D - B */
 	vli_mod_sub(t5, t5, x1, curve_prime, ndigits);
@@ -1071,11 +1256,11 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
 	/* t3 = C - B */
 	vli_mod_sub(x2, x2, x1, curve_prime, ndigits);
 	/* t2 = y1*(C - B) */
-	vli_mod_mult_fast(y1, y1, x2, curve_prime, ndigits);
+	vli_mod_mult_fast(y1, y1, x2, curve);
 	/* t3 = B - x3 */
 	vli_mod_sub(x2, x1, t5, curve_prime, ndigits);
 	/* t4 = (y2 - y1)*(B - x3) */
-	vli_mod_mult_fast(y2, y2, x2, curve_prime, ndigits);
+	vli_mod_mult_fast(y2, y2, x2, curve);
 	/* t4 = y3 */
 	vli_mod_sub(y2, y2, y1, curve_prime, ndigits);
 
@@ -1086,22 +1271,24 @@ static void xycz_add(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
  * Output P + Q = (x3, y3, Z3), P - Q = (x3', y3', Z3)
  * or P => P - Q, Q => P + Q
  */
-static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
-		       unsigned int ndigits)
+static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2,
+			const struct ecc_curve *curve)
 {
 	/* t1 = X1, t2 = Y1, t3 = X2, t4 = Y2 */
 	u64 t5[ECC_MAX_DIGITS];
 	u64 t6[ECC_MAX_DIGITS];
 	u64 t7[ECC_MAX_DIGITS];
+	const u64 *curve_prime = curve->p;
+	const unsigned int ndigits = curve->g.ndigits;
 
 	/* t5 = x2 - x1 */
 	vli_mod_sub(t5, x2, x1, curve_prime, ndigits);
 	/* t5 = (x2 - x1)^2 = A */
-	vli_mod_square_fast(t5, t5, curve_prime, ndigits);
+	vli_mod_square_fast(t5, t5, curve);
 	/* t1 = x1*A = B */
-	vli_mod_mult_fast(x1, x1, t5, curve_prime, ndigits);
+	vli_mod_mult_fast(x1, x1, t5, curve);
 	/* t3 = x2*A = C */
-	vli_mod_mult_fast(x2, x2, t5, curve_prime, ndigits);
+	vli_mod_mult_fast(x2, x2, t5, curve);
 	/* t4 = y2 + y1 */
 	vli_mod_add(t5, y2, y1, curve_prime, ndigits);
 	/* t4 = y2 - y1 */
@@ -1110,29 +1297,29 @@ static void xycz_add_c(u64 *x1, u64 *y1, u64 *x2, u64 *y2, u64 *curve_prime,
 	/* t6 = C - B */
 	vli_mod_sub(t6, x2, x1, curve_prime, ndigits);
 	/* t2 = y1 * (C - B) */
-	vli_mod_mult_fast(y1, y1, t6, curve_prime, ndigits);
+	vli_mod_mult_fast(y1, y1, t6, curve);
 	/* t6 = B + C */
 	vli_mod_add(t6, x1, x2, curve_prime, ndigits);
 	/* t3 = (y2 - y1)^2 */
-	vli_mod_square_fast(x2, y2, curve_prime, ndigits);
+	vli_mod_square_fast(x2, y2, curve);
 	/* t3 = x3 */
 	vli_mod_sub(x2, x2, t6, curve_prime, ndigits);
 
 	/* t7 = B - x3 */
 	vli_mod_sub(t7, x1, x2, curve_prime, ndigits);
 	/* t4 = (y2 - y1)*(B - x3) */
-	vli_mod_mult_fast(y2, y2, t7, curve_prime, ndigits);
+	vli_mod_mult_fast(y2, y2, t7, curve);
 	/* t4 = y3 */
 	vli_mod_sub(y2, y2, y1, curve_prime, ndigits);
 
 	/* t7 = (y2 + y1)^2 = F */
-	vli_mod_square_fast(t7, t5, curve_prime, ndigits);
+	vli_mod_square_fast(t7, t5, curve);
 	/* t7 = x3' */
 	vli_mod_sub(t7, t7, t6, curve_prime, ndigits);
 	/* t6 = x3' - B */
 	vli_mod_sub(t6, t7, x1, curve_prime, ndigits);
 	/* t6 = (y2 + y1)*(x3' - B) */
-	vli_mod_mult_fast(t6, t6, t5, curve_prime, ndigits);
+	vli_mod_mult_fast(t6, t6, t5, curve);
 	/* t2 = y3' */
 	vli_mod_sub(y1, t6, y1, curve_prime, ndigits);
 
@@ -1162,41 +1349,37 @@ static void ecc_point_mult(struct ecc_point *result,
 	vli_set(rx[1], point->x, ndigits);
 	vli_set(ry[1], point->y, ndigits);
 
-	xycz_initial_double(rx[1], ry[1], rx[0], ry[0], initial_z, curve_prime,
-			    ndigits);
+	xycz_initial_double(rx[1], ry[1], rx[0], ry[0], initial_z, curve);
 
 	for (i = num_bits - 2; i > 0; i--) {
 		nb = !vli_test_bit(scalar, i);
-		xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb], curve_prime,
-			   ndigits);
-		xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve_prime,
-			 ndigits);
+		xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb], curve);
+		xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve);
 	}
 
 	nb = !vli_test_bit(scalar, 0);
-	xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb], curve_prime,
-		   ndigits);
+	xycz_add_c(rx[1 - nb], ry[1 - nb], rx[nb], ry[nb], curve);
 
 	/* Find final 1/Z value. */
 	/* X1 - X0 */
 	vli_mod_sub(z, rx[1], rx[0], curve_prime, ndigits);
 	/* Yb * (X1 - X0) */
-	vli_mod_mult_fast(z, z, ry[1 - nb], curve_prime, ndigits);
+	vli_mod_mult_fast(z, z, ry[1 - nb], curve);
 	/* xP * Yb * (X1 - X0) */
-	vli_mod_mult_fast(z, z, point->x, curve_prime, ndigits);
+	vli_mod_mult_fast(z, z, point->x, curve);
 
 	/* 1 / (xP * Yb * (X1 - X0)) */
 	vli_mod_inv(z, z, curve_prime, point->ndigits);
 
 	/* yP / (xP * Yb * (X1 - X0)) */
-	vli_mod_mult_fast(z, z, point->y, curve_prime, ndigits);
+	vli_mod_mult_fast(z, z, point->y, curve);
 	/* Xb * yP / (xP * Yb * (X1 - X0)) */
-	vli_mod_mult_fast(z, z, rx[1 - nb], curve_prime, ndigits);
+	vli_mod_mult_fast(z, z, rx[1 - nb], curve);
 	/* End 1/Z calculation */
 
-	xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve_prime, ndigits);
+	xycz_add(rx[nb], ry[nb], rx[1 - nb], ry[1 - nb], curve);
 
-	apply_z(rx[0], ry[0], z, curve_prime, ndigits);
+	apply_z(rx[0], ry[0], z, curve);
 
 	vli_set(result->x, rx[0], ndigits);
 	vli_set(result->y, ry[0], ndigits);
@@ -1217,9 +1400,9 @@ static void ecc_point_add(const struct ecc_point *result,
 	vli_mod_sub(z, result->x, p->x, curve->p, ndigits);
 	vli_set(px, p->x, ndigits);
 	vli_set(py, p->y, ndigits);
-	xycz_add(px, py, result->x, result->y, curve->p, ndigits);
+	xycz_add(px, py, result->x, result->y, curve);
 	vli_mod_inv(z, z, curve->p, ndigits);
-	apply_z(result->x, result->y, z, curve->p, ndigits);
+	apply_z(result->x, result->y, z, curve);
 }
 
 /* Computes R = u1P + u2Q mod p using Shamir's trick.
@@ -1248,8 +1431,7 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 	points[2] = q;
 	points[3] = &sum;
 
-	num_bits = max(vli_num_bits(u1, ndigits),
-		       vli_num_bits(u2, ndigits));
+	num_bits = max(vli_num_bits(u1, ndigits), vli_num_bits(u2, ndigits));
 	i = num_bits - 1;
 	idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
 	point = points[idx];
@@ -1260,7 +1442,7 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 	z[0] = 1;
 
 	for (--i; i >= 0; i--) {
-		ecc_point_double_jacobian(rx, ry, z, curve->p, ndigits);
+		ecc_point_double_jacobian(rx, ry, z, curve);
 		idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
 		point = points[idx];
 		if (point) {
@@ -1270,14 +1452,14 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 
 			vli_set(tx, point->x, ndigits);
 			vli_set(ty, point->y, ndigits);
-			apply_z(tx, ty, z, curve->p, ndigits);
+			apply_z(tx, ty, z, curve);
 			vli_mod_sub(tz, rx, tx, curve->p, ndigits);
-			xycz_add(tx, ty, rx, ry, curve->p, ndigits);
-			vli_mod_mult_fast(z, z, tz, curve->p, ndigits);
+			xycz_add(tx, ty, rx, ry, curve);
+			vli_mod_mult_fast(z, z, tz, curve);
 		}
 	}
 	vli_mod_inv(z, z, curve->p, ndigits);
-	apply_z(rx, ry, z, curve->p, ndigits);
+	apply_z(rx, ry, z, curve);
 }
 EXPORT_SYMBOL(ecc_point_mult_shamir);
 
@@ -1441,10 +1623,10 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 		return -EINVAL;
 
 	/* Check 3: Verify that y^2 == (x^3 + a·x + b) mod p */
-	vli_mod_square_fast(yy, pk->y, curve->p, pk->ndigits); /* y^2 */
-	vli_mod_square_fast(xxx, pk->x, curve->p, pk->ndigits); /* x^2 */
-	vli_mod_mult_fast(xxx, xxx, pk->x, curve->p, pk->ndigits); /* x^3 */
-	vli_mod_mult_fast(w, curve->a, pk->x, curve->p, pk->ndigits); /* a·x */
+	vli_mod_square_fast(yy, pk->y, curve); /* y^2 */
+	vli_mod_square_fast(xxx, pk->x, curve); /* x^2 */
+	vli_mod_mult_fast(xxx, xxx, pk->x, curve); /* x^3 */
+	vli_mod_mult_fast(w, curve->a, pk->x, curve); /* a·x */
 	vli_mod_add(w, w, curve->b, curve->p, pk->ndigits); /* a·x + b */
 	vli_mod_add(w, w, xxx, curve->p, pk->ndigits); /* x^3 + a·x + b */
 	if (vli_cmp(yy, w, pk->ndigits) != 0) /* Equation */
diff --git a/crypto/ecc.h b/crypto/ecc.h
index d4e546b9ad79..f02ea6cfd10d 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -29,7 +29,9 @@
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
 #define ECC_CURVE_NIST_P256_DIGITS  4
-#define ECC_MAX_DIGITS             (512 / 64)
+#define ECC_CURVE_NIST_P384_DIGITS  6
+#define ECC_CURVE_NIST_P521_DIGITS  9
+#define ECC_MAX_DIGITS              (ECC_CURVE_NIST_P521_DIGITS)
 
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
@@ -147,6 +149,9 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 				struct ecc_point *pk);
 
+/* Returns true if p_point is the point at infinity, false otherwise. */
+bool ecc_point_is_zero(const struct ecc_point *point);
+
 /**
  * ecc_is_pubkey_valid_full() - Full public key validation
  *
@@ -225,6 +230,22 @@ void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits);
 void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 		 unsigned int ndigits);
 
+/**
+ * vli_mod_slow() - Computes result = product % mod, where product is 2N words
+ * long.
+ * Reference: Ken MacKay's micro-ecc.
+ * Currently only designed to work for curve_p or curve_n.
+ *
+ * @result:		where to write result value
+ * @product:	vli number to operate mod on
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_slow(u64 *result, const u64 *input, const u64 *mod,
+				unsigned int ndigits);
+
 /**
  * vli_mod_mult_slow() - Modular multiplication
  *
@@ -239,6 +260,42 @@ void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
 		       const u64 *mod, unsigned int ndigits);
 
+/* Computes result = (left + right) % mod.
+ * Assumes that left < mod and right < mod, result != mod.
+ */
+void vli_mod_add(u64 *result, const u64 *left, const u64 *right,
+			const u64 *mod, unsigned int ndigits);
+
+/**
+ * vli_mod_fast() - Computes result = product % curve_prime for different
+ * curve_primes.
+ *
+ * Note that curve_primes are distinguished just by heuristic check and
+ * not by complete conformance check.
+ *
+ * @result:		where to write result value
+ * @input:		vli number to multiply with @right
+ * @mod:		mod
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_fast(u64 *result, const u64 *input, const struct ecc_curve *curve);
+
+/**
+ * vli_mod_mult_fast() - Modular multiplication
+ *
+ * @result:		where to write result value
+ * @left:		vli number to multiply with @right
+ * @right:		vli number to multiply with @left
+ * @mod:		modulus
+ * @ndigits:		length of all vlis
+ *
+ * Note: Assumes that mod is big enough curve order.
+ */
+void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
+			      const struct ecc_curve *curve);
+
 /**
  * ecc_point_mult_shamir() - Add two points multiplied by scalars
  *
-- 
2.25.1

