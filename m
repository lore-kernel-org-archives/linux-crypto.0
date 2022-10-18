Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4B0C43219
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 20:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJRUEu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJRUEq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 16:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9662428E27
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E5D616C3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 20:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E6FC43470;
        Tue, 18 Oct 2022 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666123480;
        bh=OvuK8TjSVTd7lpUp7M+FPHWgAYeh90efWrnuQEV3MXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDwjWw3BT3a+OHABj3gfKhcd566GoSc5FFc4YlxurfSdo9u/gEZz1wUT48NFNJIQT
         qSBDwzCVGQ9RizcI9Cl6O2aBVU6d131L3FraP9hCotg3HnbpNefSdWO3d/eLzT36kf
         fFy3pQ/yEOD+fw2c//l1CuYj6NbEo3CKFz3Gh8OzdjuHKcMdCmWcWsgqgUBiqNHu0h
         UZsYwKfERl1ZgHK6zcA9AVcgMufrn5AbC/ooGAODO01EsmJBfewsCooyqyFUtKKl7h
         3Dfwo+SqXhhyhgHgqH4gIK/LAIQLnPjHa4AHt+dFy1bq3TUnDQIRJNSZt6VK41hbFR
         MfBd9XMjQCk6w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     keescook@chromium.org, ebiggers@kernel.org, jason@zx2c4.com,
        herbert@gondor.apana.org.au, nikunj@amd.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 2/3] crypto: gf128mul - make gf128mul_lle time invariant
Date:   Tue, 18 Oct 2022 22:04:21 +0200
Message-Id: <20221018200422.179372-3-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018200422.179372-1-ardb@kernel.org>
References: <20221018200422.179372-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4986; i=ardb@kernel.org; h=from:subject; bh=OvuK8TjSVTd7lpUp7M+FPHWgAYeh90efWrnuQEV3MXo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjTwbDN4ntcjhmurmmhS4HvbemXRuCBorbAa+tnCwA 1pptEQSJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY08GwwAKCRDDTyI5ktmPJGGTDA DDJINIRfWLRMDxbDS8Ar2RulUgaWS8hNuQjQHcgG12J4lUoTnVWZ//hOASHsIIL1Yuk+PbjFpSbuW9 635j+Jj4de/f7N8P8ot9B5Rcx7pOyDuVuyVYxNEsPfRIhEf/lJbSiWlX70pkBxSX/L502GthD6051U mKJlJukIq1wrzvd+owP216YQAlLeJvr+dx25jdfHGRAvOtKsdCYd8J1pS5W4EhOOaa3NsxuFPRMll4 LfjE6hcG6oG5gnaTPJHyCvyxgYngSfjXPoZOWvokJQuHBnFkd3gvSdQVGeuGyuAdAO8q+Q2IsRJl+d QCIuCe1BqitkCg7P69qxPH2eA6iZGCL2Zk9zOgNFzuwEYCSBh1sBIpHQi1DWrpB1rdtWn6Z2H1+NWD Fpiuv32dQMLS/2KL9fRMjHoUVUA8fcjs9iys6janP69r2532GJwZ2NM729lfUGgEJtsK/z5i8r4s0j cMXcIULKv85274BkacgzYsbxu9anLfqMf9W6Uc6AjN7xw=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gf128mul library has different variants with different
memory/performance tradeoffs, where the faster ones use 4k or 64k lookup
tables precomputed at runtime, which are based on one of the
multiplication factors, which is commonly the key for keyed hash
algorithms such as GHASH.

The slowest variant is gf128_mul_lle() [and its bbe/ble counterparts],
which does not use precomputed lookup tables, but it still relies on a
single u16[256] lookup table which is input independent. The use of such
a table may cause the execution time of gf128_mul_lle() to correlate
with the value of the inputs, which is generally something that must be
avoided for cryptographic algorithms. On top of that, the function uses
a sequence of if () statements that conditionally invoke be128_xor()
based on which bits are set in the second argument of the function,
which is usually a pointer to the multiplication factor that represents
the key.

In order to remove the correlation between the execution time of
gf128_mul_lle() and the value of its inputs, let's address the
identified shortcomings:
- add a time invariant version of gf128mul_x8_lle() that replaces the
  table lookup with the expression that is used at compile time to
  populate the lookup table;
- make the invocations of be128_xor() unconditional, but pass a zero
  vector as the third argument if the associated bit in the key is
  cleared.

The resulting code is likely to be significantly slower. However, given
that this is the slowest version already, making it even slower in order
to make it more secure is assumed to be justified.

The bbe and ble counterparts could receive the same treatment, but the
former is never used anywhere in the kernel, and the latter is only
used in the driver for a asynchronous crypto h/w accelerator (Chelsio),
where timing variances are unlikely to matter.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crypto/gf128mul.c | 58 +++++++++++++-------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/lib/crypto/gf128mul.c b/lib/crypto/gf128mul.c
index a69ae3e6c16c..cd0cb1d3bf36 100644
--- a/lib/crypto/gf128mul.c
+++ b/lib/crypto/gf128mul.c
@@ -146,6 +146,17 @@ static void gf128mul_x8_lle(be128 *x)
 	x->a = cpu_to_be64((a >> 8) ^ (_tt << 48));
 }
 
+/* time invariant version of gf128mul_x8_lle */
+static void gf128mul_x8_lle_ti(be128 *x)
+{
+	u64 a = be64_to_cpu(x->a);
+	u64 b = be64_to_cpu(x->b);
+	u64 _tt = xda_le(b & 0xff); /* avoid table lookup */
+
+	x->b = cpu_to_be64((b >> 8) | (a << 56));
+	x->a = cpu_to_be64((a >> 8) ^ (_tt << 48));
+}
+
 static void gf128mul_x8_bbe(be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
@@ -169,38 +180,47 @@ EXPORT_SYMBOL(gf128mul_x8_ble);
 
 void gf128mul_lle(be128 *r, const be128 *b)
 {
-	be128 p[8];
+	/*
+	 * The p array should be aligned to twice the size of its element type,
+	 * so that every even/odd pair is guaranteed to share a cacheline
+	 * (assuming a cacheline size of 32 bytes or more, which is by far the
+	 * most common). This ensures that each be128_xor() call in the loop
+	 * takes the same amount of time regardless of the value of 'ch', which
+	 * is derived from function parameter 'b', which is commonly used as a
+	 * key, e.g., for GHASH. The odd array elements are all set to zero,
+	 * making each be128_xor() a NOP if its associated bit in 'ch' is not
+	 * set, and this is equivalent to calling be128_xor() conditionally.
+	 * This approach aims to avoid leaking information about such keys
+	 * through execution time invariances.
+	 *
+	 * Unfortunately, __aligned(16) or higher does not work on x86 for
+	 * variables on the stack so we need to perform the alignment by hand.
+	 */
+	be128 array[16 + 3] = {};
+	be128 *p = PTR_ALIGN(&array[0], 2 * sizeof(be128));
 	int i;
 
 	p[0] = *r;
 	for (i = 0; i < 7; ++i)
-		gf128mul_x_lle(&p[i + 1], &p[i]);
+		gf128mul_x_lle(&p[2 * i + 2], &p[2 * i]);
 
 	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[15 - i];
 
-		if (ch & 0x80)
-			be128_xor(r, r, &p[0]);
-		if (ch & 0x40)
-			be128_xor(r, r, &p[1]);
-		if (ch & 0x20)
-			be128_xor(r, r, &p[2]);
-		if (ch & 0x10)
-			be128_xor(r, r, &p[3]);
-		if (ch & 0x08)
-			be128_xor(r, r, &p[4]);
-		if (ch & 0x04)
-			be128_xor(r, r, &p[5]);
-		if (ch & 0x02)
-			be128_xor(r, r, &p[6]);
-		if (ch & 0x01)
-			be128_xor(r, r, &p[7]);
+		be128_xor(r, r, &p[ 0 + !(ch & 0x80)]);
+		be128_xor(r, r, &p[ 2 + !(ch & 0x40)]);
+		be128_xor(r, r, &p[ 4 + !(ch & 0x20)]);
+		be128_xor(r, r, &p[ 6 + !(ch & 0x10)]);
+		be128_xor(r, r, &p[ 8 + !(ch & 0x08)]);
+		be128_xor(r, r, &p[10 + !(ch & 0x04)]);
+		be128_xor(r, r, &p[12 + !(ch & 0x02)]);
+		be128_xor(r, r, &p[14 + !(ch & 0x01)]);
 
 		if (++i >= 16)
 			break;
 
-		gf128mul_x8_lle(r);
+		gf128mul_x8_lle_ti(r); /* use the time invariant version */
 	}
 }
 EXPORT_SYMBOL(gf128mul_lle);
-- 
2.35.1

