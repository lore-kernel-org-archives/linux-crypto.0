Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED31C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6352238EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgLQRYf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:24:35 -0500
Received: from mga05.intel.com ([192.55.52.43]:47104 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729046AbgLQRYf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:24:35 -0500
IronPort-SDR: reC3F0SixIhrHfaw1v/1BpLMVNNeGhHsHWX6Yl7EoubJ28CSlvALESOp/QpJFeQ6GqfP0khWlv
 kHjGEWze+y7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="260017897"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="260017897"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:35 -0800
IronPort-SDR: OX4aO/VMCM7hTu1kl23O5QQj5rrtADbH5r/zVBAgnzGa06/vtG0tM85TxyOniwxrl1pnDbgyOF
 E2NdIsPMpYAg==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="369930955"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:32 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH 3/6] crypto: ecc - Export additional helper functions
Date:   Thu, 17 Dec 2020 17:20:58 +0000
Message-Id: <20201217172101.381772-4-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Export the following additional ECC helper functions:
- ecc_alloc_point()
- ecc_free_point()
- vli_num_bits()
- ecc_point_is_zero()
- ecc_swap_digits()

This is done to allow future KPP device drivers to re-use existing code,
thus simplifying their implementation.

Functions are exported using EXPORT_SYMBOL() (instead of
EXPORT_SYMBOL_GPL()) to be consistent with the functions already
exported by crypto/ecc.c.

Exported functions are documented in crypto/ecc.h.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 crypto/ecc.c                  | 16 ++++++++-----
 include/crypto/internal/ecc.h | 44 +++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 9aa801315a32..e8176db071d8 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -70,7 +70,7 @@ static void ecc_free_digits_space(u64 *space)
 	kfree_sensitive(space);
 }
 
-static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
+struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 {
 	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
 
@@ -95,8 +95,9 @@ static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 	kfree(p);
 	return NULL;
 }
+EXPORT_SYMBOL(ecc_alloc_point);
 
-static void ecc_free_point(struct ecc_point *p)
+void ecc_free_point(struct ecc_point *p)
 {
 	if (!p)
 		return;
@@ -105,6 +106,7 @@ static void ecc_free_point(struct ecc_point *p)
 	kfree_sensitive(p->y);
 	kfree_sensitive(p);
 }
+EXPORT_SYMBOL(ecc_free_point);
 
 static void vli_clear(u64 *vli, unsigned int ndigits)
 {
@@ -154,7 +156,7 @@ static unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
 }
 
 /* Counts the number of bits required for vli. */
-static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
+unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 {
 	unsigned int i, num_digits;
 	u64 digit;
@@ -169,6 +171,7 @@ static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 
 	return ((num_digits - 1) * 64 + i);
 }
+EXPORT_SYMBOL(vli_num_bits);
 
 /* Set dest from unaligned bit string src. */
 void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits)
@@ -933,11 +936,12 @@ EXPORT_SYMBOL(vli_mod_inv);
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
@@ -1281,8 +1285,7 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 }
 EXPORT_SYMBOL(ecc_point_mult_shamir);
 
-static inline void ecc_swap_digits(const u64 *in, u64 *out,
-				   unsigned int ndigits)
+void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits)
 {
 	const __be64 *src = (__force __be64 *)in;
 	int i;
@@ -1290,6 +1293,7 @@ static inline void ecc_swap_digits(const u64 *in, u64 *out,
 	for (i = 0; i < ndigits; i++)
 		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
 }
+EXPORT_SYMBOL(ecc_swap_digits);
 
 static int __ecc_is_key_valid(const struct ecc_curve *curve,
 			      const u64 *private_key, unsigned int ndigits)
diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index d4e546b9ad79..2f6ac78b64f3 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -239,6 +239,41 @@ void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
 		       const u64 *mod, unsigned int ndigits);
 
+/**
+ * vli_num_bits() - Counts the number of bits required for vli.
+ *
+ * @vli:		vli to check.
+ * @ndigits:		Length of the @vli
+ *
+ * Return: The number of bits required to represent @vli.
+ */
+unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits);
+
+/**
+ * ecc_aloc_point() - Allocate ECC point.
+ *
+ * @ndigits:		Length of vlis in u64 qwords.
+ *
+ * Return: Pointer to the allocated point or NULL if allocation failed.
+ */
+struct ecc_point *ecc_alloc_point(unsigned int ndigits);
+
+/**
+ * ecc_free_point() - Free ECC point.
+ *
+ * @p:			The point to free.
+ */
+void ecc_free_point(struct ecc_point *p);
+
+/**
+ * ecc_point_is_zero() - Check if point is zero.
+ *
+ * @p:			Point to check for zero.
+ *
+ * Return: true if point is the point at infinity, false otherwise.
+ */
+bool ecc_point_is_zero(const struct ecc_point *point);
+
 /**
  * ecc_point_mult_shamir() - Add two points multiplied by scalars
  *
@@ -256,4 +291,13 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 			   const u64 *x, const struct ecc_point *p,
 			   const u64 *y, const struct ecc_point *q,
 			   const struct ecc_curve *curve);
+
+/**
+ * ecc_swap_digits() - Swap digits in vli.
+ *
+ * @in:			The input vli (whose digits will be swapped).
+ * @out:		The output vli (where swapped digits will be saved).
+ * @ndigits:		Length of vli to be swapped.
+ */
+void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits);
 #endif
-- 
2.26.2

