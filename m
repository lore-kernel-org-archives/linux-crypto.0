Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB55BC10F13
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B918120866
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062761;
	bh=0WDneeP6/BzEmBWJaHOPlPNyiUS81sVPMFvnGb2crLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MmgLd461LRLH+unLfeMmCRX7lom6ok1dLN5nqYFaFYRWiWiGdlrtHF1Bw+hCxN5v9
	 rB+IewutxIz9gbt9u9vHu17QBIT0UOlnLmeGj6Kcz9myyQ0dvrwoTd6GV9JJqmckTc
	 O6fWl4VAtqPqbmpo1kNY3FvhviHAKFebJw3GcJh0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbfCaUF6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbfCaUF6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D0E20872;
        Sun, 31 Mar 2019 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062756;
        bh=0WDneeP6/BzEmBWJaHOPlPNyiUS81sVPMFvnGb2crLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kbss/utiPm0o0HvZdbQC1W7ChloB4dd+MjIZelWdd32IKP8vnwP4lrXf4irmtAxzU
         TodQwXx1K6VpWRz79RTrpvQ4KSwhJD/CdBZJTnTR9y+lkZrPKH9pcjIaasYCessxzO
         iRJVi0r+4Pr/cHjvnQeOpIRj6+2C1ww4TKIfzh3Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 01/18] crypto: x86/poly1305 - fix overflow during partial reduction
Date:   Sun, 31 Mar 2019 13:04:11 -0700
Message-Id: <20190331200428.26597-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The x86_64 implementation of Poly1305 produces the wrong result on some
inputs because poly1305_4block_avx2() incorrectly assumes that when
partially reducing the accumulator, the bits carried from limb 'd4' to
limb 'h0' fit in a 32-bit integer.  This is true for poly1305-generic
which processes only one block at a time.  However, it's not true for
the AVX2 implementation, which processes 4 blocks at a time and
therefore can produce intermediate limbs about 4x larger.

Fix it by making the relevant calculations use 64-bit arithmetic rather
than 32-bit.  Note that most of the carries already used 64-bit
arithmetic, but the d4 -> h0 carry was different for some reason.

To be safe I also made the same change to the corresponding SSE2 code,
though that only operates on 1 or 2 blocks at a time.  I don't think
it's really needed for poly1305_block_sse2(), but it doesn't hurt
because it's already x86_64 code.  It *might* be needed for
poly1305_2block_sse2(), but overflows aren't easy to reproduce there.

This bug was originally detected by my patches that improve testmgr to
fuzz algorithms against their generic implementation.  But also add a
test vector which reproduces it directly (in the AVX2 case).

Fixes: b1ccc8f4b631 ("crypto: poly1305 - Add a four block AVX2 variant for x86_64")
Fixes: c70f4abef07a ("crypto: poly1305 - Add a SSE2 SIMD variant for x86_64")
Cc: <stable@vger.kernel.org> # v4.3+
Cc: Martin Willi <martin@strongswan.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/poly1305-avx2-x86_64.S | 14 +++++---
 arch/x86/crypto/poly1305-sse2-x86_64.S | 22 ++++++++-----
 crypto/testmgr.h                       | 44 +++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/arch/x86/crypto/poly1305-avx2-x86_64.S b/arch/x86/crypto/poly1305-avx2-x86_64.S
index 3b6e70d085da8..8457cdd47f751 100644
--- a/arch/x86/crypto/poly1305-avx2-x86_64.S
+++ b/arch/x86/crypto/poly1305-avx2-x86_64.S
@@ -323,6 +323,12 @@ ENTRY(poly1305_4block_avx2)
 	vpaddq		t2,t1,t1
 	vmovq		t1x,d4
 
+	# Now do a partial reduction mod (2^130)-5, carrying h0 -> h1 -> h2 ->
+	# h3 -> h4 -> h0 -> h1 to get h0,h2,h3,h4 < 2^26 and h1 < 2^26 + a small
+	# amount.  Careful: we must not assume the carry bits 'd0 >> 26',
+	# 'd1 >> 26', 'd2 >> 26', 'd3 >> 26', and '(d4 >> 26) * 5' fit in 32-bit
+	# integers.  It's true in a single-block implementation, but not here.
+
 	# d1 += d0 >> 26
 	mov		d0,%rax
 	shr		$26,%rax
@@ -361,16 +367,16 @@ ENTRY(poly1305_4block_avx2)
 	# h0 += (d4 >> 26) * 5
 	mov		d4,%rax
 	shr		$26,%rax
-	lea		(%eax,%eax,4),%eax
-	add		%eax,%ebx
+	lea		(%rax,%rax,4),%rax
+	add		%rax,%rbx
 	# h4 = d4 & 0x3ffffff
 	mov		d4,%rax
 	and		$0x3ffffff,%eax
 	mov		%eax,h4
 
 	# h1 += h0 >> 26
-	mov		%ebx,%eax
-	shr		$26,%eax
+	mov		%rbx,%rax
+	shr		$26,%rax
 	add		%eax,h1
 	# h0 = h0 & 0x3ffffff
 	andl		$0x3ffffff,%ebx
diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
index e6add74d78a59..6f0be7a869641 100644
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ b/arch/x86/crypto/poly1305-sse2-x86_64.S
@@ -253,16 +253,16 @@ ENTRY(poly1305_block_sse2)
 	# h0 += (d4 >> 26) * 5
 	mov		d4,%rax
 	shr		$26,%rax
-	lea		(%eax,%eax,4),%eax
-	add		%eax,%ebx
+	lea		(%rax,%rax,4),%rax
+	add		%rax,%rbx
 	# h4 = d4 & 0x3ffffff
 	mov		d4,%rax
 	and		$0x3ffffff,%eax
 	mov		%eax,h4
 
 	# h1 += h0 >> 26
-	mov		%ebx,%eax
-	shr		$26,%eax
+	mov		%rbx,%rax
+	shr		$26,%rax
 	add		%eax,h1
 	# h0 = h0 & 0x3ffffff
 	andl		$0x3ffffff,%ebx
@@ -524,6 +524,12 @@ ENTRY(poly1305_2block_sse2)
 	paddq		t2,t1
 	movq		t1,d4
 
+	# Now do a partial reduction mod (2^130)-5, carrying h0 -> h1 -> h2 ->
+	# h3 -> h4 -> h0 -> h1 to get h0,h2,h3,h4 < 2^26 and h1 < 2^26 + a small
+	# amount.  Careful: we must not assume the carry bits 'd0 >> 26',
+	# 'd1 >> 26', 'd2 >> 26', 'd3 >> 26', and '(d4 >> 26) * 5' fit in 32-bit
+	# integers.  It's true in a single-block implementation, but not here.
+
 	# d1 += d0 >> 26
 	mov		d0,%rax
 	shr		$26,%rax
@@ -562,16 +568,16 @@ ENTRY(poly1305_2block_sse2)
 	# h0 += (d4 >> 26) * 5
 	mov		d4,%rax
 	shr		$26,%rax
-	lea		(%eax,%eax,4),%eax
-	add		%eax,%ebx
+	lea		(%rax,%rax,4),%rax
+	add		%rax,%rbx
 	# h4 = d4 & 0x3ffffff
 	mov		d4,%rax
 	and		$0x3ffffff,%eax
 	mov		%eax,h4
 
 	# h1 += h0 >> 26
-	mov		%ebx,%eax
-	shr		$26,%eax
+	mov		%rbx,%rax
+	shr		$26,%rax
 	add		%eax,h1
 	# h0 = h0 & 0x3ffffff
 	andl		$0x3ffffff,%ebx
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index f267633cf13ac..d18a37629f053 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -5634,7 +5634,49 @@ static const struct hash_testvec poly1305_tv_template[] = {
 		.psize		= 80,
 		.digest		= "\x13\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-	},
+	}, { /* Regression test for overflow in AVX2 implementation */
+		.plaintext	= "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff",
+		.psize		= 300,
+		.digest		= "\xfb\x5e\x96\xd8\x61\xd5\xc7\xc8"
+				  "\x78\xe5\x87\xcc\x2d\x5a\x22\xe1",
+	}
 };
 
 /* NHPoly1305 test vectors from https://github.com/google/adiantum */
-- 
2.21.0

