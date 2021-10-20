Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44879C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2818561260
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJTKiJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:38:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:7393 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhJTKiI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:38:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228622902"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="228622902"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:54 -0700
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="527005569"
Received: from dhicke3x-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.29.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:51 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/5] crypto: ecc - Export additional helper functions
Date:   Wed, 20 Oct 2021 11:35:36 +0100
Message-Id: <20211020103538.360614-4-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
References: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
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

This is done to allow future ECC device drivers to re-use existing code,
thus simplifying their implementation.

Functions are exported using EXPORT_SYMBOL() (instead of
EXPORT_SYMBOL_GPL()) to be consistent with the functions already
exported by crypto/ecc.c.

Exported functions are documented in include/crypto/internal/ecc.h.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 crypto/ecc.c                  | 12 ++++++++----
 include/crypto/internal/ecc.h | 36 +++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 80efc9b4eb69..7315217c8f73 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -81,7 +81,7 @@ static void ecc_free_digits_space(u64 *space)
 	kfree_sensitive(space);
 }
 
-static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
+struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 {
 	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
 
@@ -106,8 +106,9 @@ static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 	kfree(p);
 	return NULL;
 }
+EXPORT_SYMBOL(ecc_alloc_point);
 
-static void ecc_free_point(struct ecc_point *p)
+void ecc_free_point(struct ecc_point *p)
 {
 	if (!p)
 		return;
@@ -116,6 +117,7 @@ static void ecc_free_point(struct ecc_point *p)
 	kfree_sensitive(p->y);
 	kfree_sensitive(p);
 }
+EXPORT_SYMBOL(ecc_free_point);
 
 static void vli_clear(u64 *vli, unsigned int ndigits)
 {
@@ -165,7 +167,7 @@ static unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
 }
 
 /* Counts the number of bits required for vli. */
-static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
+unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 {
 	unsigned int i, num_digits;
 	u64 digit;
@@ -180,6 +182,7 @@ static unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 
 	return ((num_digits - 1) * 64 + i);
 }
+EXPORT_SYMBOL(vli_num_bits);
 
 /* Set dest from unaligned bit string src. */
 void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits)
@@ -1062,11 +1065,12 @@ EXPORT_SYMBOL(vli_mod_inv);
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
diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index 1350e8eb6ac2..4f6c1a68882f 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -225,6 +225,41 @@ void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
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
@@ -242,4 +277,5 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 			   const u64 *x, const struct ecc_point *p,
 			   const u64 *y, const struct ecc_point *q,
 			   const struct ecc_curve *curve);
+
 #endif
-- 
2.31.1

