Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8D4C4332E
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EF264E9A
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhBHJsv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:48:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12496 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbhBHJpl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:45:41 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZ1GJ24pBzjL2c;
        Mon,  8 Feb 2021 17:40:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 17:41:21 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 6/9] crypto: add new ecc curve and expose them
Date:   Mon, 8 Feb 2021 17:38:54 +0800
Message-ID: <1612777137-51067-7-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Add ecc curves(P224, P384, P521) for ECDH;
2. Reorder ECC 'Curves ID' in 'include/crypto/ecdh.h';
3. Move 'ecc_get_curve' to 'include/crypto/ecc_curve.h', so everyone
   in kernel tree can easily get ecc curve params;

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 crypto/ecc.c               |  11 ++++-
 crypto/ecc.h               |  37 +---------------
 crypto/ecc_curve_defs.h    | 106 +++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/ecc_curve.h |  53 +++++++++++++++++++++++
 include/crypto/ecdh.h      |   5 ++-
 5 files changed, 175 insertions(+), 37 deletions(-)
 create mode 100644 include/crypto/ecc_curve.h

diff --git a/crypto/ecc.c b/crypto/ecc.c
index c80aa25..a631d3e 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -24,6 +24,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <crypto/ecc_curve.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/slab.h>
@@ -42,18 +43,26 @@ typedef struct {
 	u64 m_high;
 } uint128_t;
 
-static inline const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
+
+const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 {
 	switch (curve_id) {
 	/* In FIPS mode only allow P256 and higher */
 	case ECC_CURVE_NIST_P192:
 		return fips_enabled ? NULL : &nist_p192;
+	case ECC_CURVE_NIST_P224:
+		return &nist_p224;
 	case ECC_CURVE_NIST_P256:
 		return &nist_p256;
+	case ECC_CURVE_NIST_P384:
+		return &nist_p384;
+	case ECC_CURVE_NIST_P521:
+		return &nist_p521;
 	default:
 		return NULL;
 	}
 }
+EXPORT_SYMBOL(ecc_get_curve);
 
 static u64 *ecc_alloc_digits_space(unsigned int ndigits)
 {
diff --git a/crypto/ecc.h b/crypto/ecc.h
index d4e546b..38a81d4 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -26,6 +26,8 @@
 #ifndef _CRYPTO_ECC_H
 #define _CRYPTO_ECC_H
 
+#include <crypto/ecc_curve.h>
+
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
 #define ECC_CURVE_NIST_P256_DIGITS  4
@@ -33,44 +35,9 @@
 
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
-/**
- * struct ecc_point - elliptic curve point in affine coordinates
- *
- * @x:		X coordinate in vli form.
- * @y:		Y coordinate in vli form.
- * @ndigits:	Length of vlis in u64 qwords.
- */
-struct ecc_point {
-	u64 *x;
-	u64 *y;
-	u8 ndigits;
-};
-
 #define ECC_POINT_INIT(x, y, ndigits)	(struct ecc_point) { x, y, ndigits }
 
 /**
- * struct ecc_curve - definition of elliptic curve
- *
- * @name:	Short name of the curve.
- * @g:		Generator point of the curve.
- * @p:		Prime number, if Barrett's reduction is used for this curve
- *		pre-calculated value 'mu' is appended to the @p after ndigits.
- *		Use of Barrett's reduction is heuristically determined in
- *		vli_mmod_fast().
- * @n:		Order of the curve group.
- * @a:		Curve parameter a.
- * @b:		Curve parameter b.
- */
-struct ecc_curve {
-	char *name;
-	struct ecc_point g;
-	u64 *p;
-	u64 *n;
-	u64 *a;
-	u64 *b;
-};
-
-/**
  * ecc_is_key_valid() - Validate a given ECDH private key
  *
  * @curve_id:		id representing the curve to use
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 69be6c7..bcd7b58 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -15,6 +15,7 @@ static u64 nist_p192_a[] = { 0xFFFFFFFFFFFFFFFCull, 0xFFFFFFFFFFFFFFFEull,
 				0xFFFFFFFFFFFFFFFFull };
 static u64 nist_p192_b[] = { 0xFEB8DEECC146B9B1ull, 0x0FA7E9AB72243049ull,
 				0x64210519E59C80E7ull };
+
 static struct ecc_curve nist_p192 = {
 	.name = "nist_192",
 	.g = {
@@ -28,6 +29,32 @@ static struct ecc_curve nist_p192 = {
 	.b = nist_p192_b
 };
 
+/* NIST P-224 */
+static u64 nist_p224_g_x[] = { 0x343280D6115C1D21ull, 0x4A03C1D356C21122ull,
+				0x6BB4BF7F321390B9ull, 0xB70E0CBDull };
+static u64 nist_p224_g_y[] = { 0x44d5819985007e34ull, 0xcd4375a05a074764ull,
+				0xb5f723fb4c22dfe6ull, 0xbd376388ull };
+static u64 nist_p224_p[] = { 0x0000000000000001ull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFull };
+static u64 nist_p224_n[] = { 0x13DD29455C5C2A3Dull, 0xFFFF16A2E0B8F03Eull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFull };
+static u64 nist_p224_a[] = { 0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFEFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFull };
+static u64 nist_p224_b[] = { 0x270B39432355FFB4ull, 0x5044B0B7D7BFD8BAull,
+				0x0C04B3ABF5413256ull, 0xB4050A85ull };
+static struct ecc_curve nist_p224 = {
+	.name = "nist_224",
+	.g = {
+		.x = nist_p224_g_x,
+		.y = nist_p224_g_y,
+		.ndigits = 3,
+	},
+	.p = nist_p224_p,
+	.n = nist_p224_n,
+	.a = nist_p224_a,
+	.b = nist_p224_b
+};
+
 /* NIST P-256: a = p - 3 */
 static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
 				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
@@ -41,6 +68,7 @@ static u64 nist_p256_a[] = { 0xFFFFFFFFFFFFFFFCull, 0x00000000FFFFFFFFull,
 				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
 static u64 nist_p256_b[] = { 0x3BCE3C3E27D2604Bull, 0x651D06B0CC53B0F6ull,
 				0xB3EBBD55769886BCull, 0x5AC635D8AA3A93E7ull };
+
 static struct ecc_curve nist_p256 = {
 	.name = "nist_256",
 	.g = {
@@ -54,4 +82,82 @@ static struct ecc_curve nist_p256 = {
 	.b = nist_p256_b
 };
 
+/* NIST P-384: a = p - 3 */
+static u64 nist_p384_g_x[] = { 0x3A545E3872760AB7ull, 0x5502F25DBF55296Cull,
+				0x59F741E082542A38ull, 0x6E1D3B628BA79B98ull,
+				0x8EB1C71EF320AD74ull, 0xAA87CA22BE8B0537ull};
+static u64 nist_p384_g_y[] = { 0x7A431D7C90EA0E5Full, 0x0A60B1CE1D7E819Dull,
+				0xE9DA3113B5F0B8C0ull, 0xF8F41DBD289A147Cull,
+				0x5D9E98BF9292DC29ull, 0x3617DE4A96262C6Full};
+static u64 nist_p384_p[] = { 0x00000000FFFFFFFFull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull};
+static u64 nist_p384_n[] = { 0xECEC196ACCC52973ull, 0x581A0DB248B0A77Aull,
+				0xC7634D81F4372DDFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull};
+static u64 nist_p384_a[] = { 0x00000000FFFFFFFCull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull};
+static u64 nist_p384_b[] = { 0x2A85C8EDD3EC2AEFull, 0xC656398D8A2ED19Dull,
+				0x0314088F5013875Aull, 0x181D9C6EFE814112ull,
+				0x988E056BE3F82D19ull, 0xB3312FA7E23EE7E4ull};
+
+static struct ecc_curve nist_p384 = {
+	.name = "nist_384",
+	.g = {
+		.x = nist_p384_g_x,
+		.y = nist_p384_g_y,
+		.ndigits = 4,
+	},
+	.p = nist_p384_p,
+	.n = nist_p384_n,
+	.a = nist_p384_a,
+	.b = nist_p384_b
+};
+
+/* NIST P-521: a = p - 3 */
+static u64 nist_p521_g_x[] = { 0xF97E7E31C2E5BD66ull, 0x3348B3C1856A429Bull,
+				0xFE1DC127A2FFA8DEull, 0xA14B5E77EFE75928ull,
+				0xF828AF606B4D3DBAull, 0x9C648139053FB521ull,
+				0x9E3ECB662395B442ull, 0x858E06B70404E9CDull,
+				0x00C6ull };
+static u64 nist_p521_g_y[] = { 0x88be94769fd16650ull, 0x353c7086a272c240ull,
+				0xc550b9013fad0761ull, 0x97ee72995ef42640ull,
+				0x17afbd17273e662cull, 0x98f54449579b4468ull,
+				0x5c8a5fb42c7d1bd9ull, 0x39296a789a3bc004ull,
+				0x0118ull };
+static u64 nist_p521_p[] = {0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x01FFull };
+static u64 nist_p521_n[] = { 0xBB6FB71E91386409ull, 0x3BB5C9B8899C47AEull,
+				0x7FCC0148F709A5D0ull, 0x51868783BF2F966Bull,
+				0xFFFFFFFFFFFFFFFAull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x01FFull };
+static u64 nist_p521_a[] = { 0xFFFFFFFFFFFFFFFCull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x01FFull };
+static u64 nist_p521_b[] = { 0xEF451FD46B503F00ull, 0x3573DF883D2C34F1ull,
+				0x1652C0BD3BB1BF07ull, 0x56193951EC7E937Bull,
+				0xB8B489918EF109E1ull, 0xA2DA725B99B315F3ull,
+				0x929A21A0B68540EEull, 0x953EB9618E1C9A1Full,
+				0x0051ull };
+
+static struct ecc_curve nist_p521 = {
+	.name = "nist_521",
+	.g = {
+		.x = nist_p521_g_x,
+		.y = nist_p521_g_y,
+		.ndigits = 4,
+	},
+	.p = nist_p521_p,
+	.n = nist_p521_n,
+	.a = nist_p521_a,
+	.b = nist_p521_b
+};
+
 #endif
diff --git a/include/crypto/ecc_curve.h b/include/crypto/ecc_curve.h
new file mode 100644
index 0000000..19a35da
--- /dev/null
+++ b/include/crypto/ecc_curve.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021 HiSilicon */
+
+#ifndef _CRYTO_ECC_CURVE_H
+#define _CRYTO_ECC_CURVE_H
+
+#include <linux/types.h>
+
+/**
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
+ * ecc_get_curve() - get elliptic curve;
+ * @curve_id:           Curves IDs:
+ *                      defined in 'include/crypto/ecdh.h';
+ *
+ * Returns curve if get curve succssful, NULL otherwise
+ */
+const struct ecc_curve *ecc_get_curve(unsigned int curve_id);
+
+#endif
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index deaaa48..07e0d30 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -24,7 +24,10 @@
 
 /* Curves IDs */
 #define ECC_CURVE_NIST_P192	0x0001
-#define ECC_CURVE_NIST_P256	0x0002
+#define ECC_CURVE_NIST_P224	0x0002
+#define ECC_CURVE_NIST_P256	0x0003
+#define ECC_CURVE_NIST_P384	0x0004
+#define ECC_CURVE_NIST_P521	0x0005
 
 /**
  * struct ecdh - define an ECDH private key
-- 
2.8.1

