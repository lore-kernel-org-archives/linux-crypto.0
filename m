Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68044C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jan 2022 22:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353392AbiA2Wpq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Jan 2022 17:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353381AbiA2Wpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jan 2022 17:45:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C7BC061714
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jan 2022 14:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4694A60DFF
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jan 2022 22:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17619C340EB;
        Sat, 29 Jan 2022 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643496343;
        bh=UVJykemlpoHDqykVn2Whh0E9TSYL5jrYB1Yq24Y6vZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjqoUJ1RIEhWFRBIKKLwX224fllM8HF4isunjHCw8+GJD3hAbqH7qt/r6jQCdnZmO
         Pl3is6Tcmt7+RD+je+N637oK40Kkxo55vHi7vpj+c5u9XRnRrAH3GyWenpc2l/cbjm
         OOarj9JoCW9eXJnd/psKqlZHAq+HFrre9SuaQeQqCjKHe8zYEBCBVoob35puvYGg11
         Rtgc7lx1gvg9ObamU+ljI58cLj5+Tg1XwStW/C/o5gn+0mUw9tSZ71JGEbKKYNv6iP
         ygl/tGKaHk66hzeNQY4+fnOw5qafBct1f8zqJyvZWLEHuffmZonIkG+bTEgSF920hY
         OLVSRQaDPFSUA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 2/2] crypto: arm/xor - make vectorized C code Clang-friendly
Date:   Sat, 29 Jan 2022 23:45:29 +0100
Message-Id: <20220129224529.76887-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220129224529.76887-1-ardb@kernel.org>
References: <20220129224529.76887-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1954; h=from:subject; bh=UVJykemlpoHDqykVn2Whh0E9TSYL5jrYB1Yq24Y6vZ8=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh9cOIZq+c1+DqFDwO940fhmui0wv0U3MpykwvLE9g Dg30ugSJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfXDiAAKCRDDTyI5ktmPJD2fDA CC5l2QiNjCLrbndf+o6UAL7eSXhxNmqZ85mXu1Hh2qD1x1H28i59n2dn7DNEwnLeTsZY0lID41wyVh JOjDKP6ETjFVcvKL1siPB8mddZ4V07eickpGFa+gTB5Py/i9rh+9Bc0FuJafJ4/q8qLj/9bG507CcW 40RI/R4aY2vkpmQnRcSP3Q3zscNxXRJ32eVlsaeb47tslCW4WKB2mL8KfpsU8e46OXLTRpYjrwemhV Bl0injUQVuAWl/bNgO6c3mK/OqulSQdXjbxREvZXMmGN1o4ElcuLxEg6P4PDh324wywBsHq9ISV3kz qu3iAbqSML7jnR3TvVE9KH/P0cYBiaIFhE976O9XTkhTcnLctbTBd2kPclxnBplnK7n/dBBNO4yI3a s7w2v2Z/Ho2e9pe1hoqU211mDEf1NYErTlCpgyTOkGUUkC1mFyexitQc7Je58GksdY8Ocr+MCn5RU8 KVktu5rcByVi+5QGUD9mTvev2qipspsP6CocbmcGdoZ/c=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ARM version of the accelerated XOR routines are simply the 8-way C
routines passed through the auto-vectorizer with SIMD codegen enabled.
This used to require GCC version 4.6 at least, but given that 5.1 is now
the baseline, this check is no longer necessary, and actually
misidentifies Clang as GCC < 4.6 as Clang defines the GCC major/minor as
well, but makes no attempt at doing this in a way that conveys feature
parity with a certain version of GCC (which would not be a great idea in
the first place).

So let's drop the version check, and make the auto-vectorize pragma
(which is based on a GCC-specific command line option) GCC-only. Since
Clang performs SIMD auto-vectorization by default at -O2, no pragma is
necessary here.

Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/lib/xor-neon.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
index b99dd8e1c93f..522510baed49 100644
--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -17,17 +17,11 @@ MODULE_LICENSE("GPL");
 /*
  * Pull in the reference implementations while instructing GCC (through
  * -ftree-vectorize) to attempt to exploit implicit parallelism and emit
- * NEON instructions.
+ * NEON instructions. Clang does this by default at O2 so no pragma is
+ * needed.
  */
-#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
+#ifdef CONFIG_CC_IS_GCC
 #pragma GCC optimize "tree-vectorize"
-#else
-/*
- * While older versions of GCC do not generate incorrect code, they fail to
- * recognize the parallel nature of these functions, and emit plain ARM code,
- * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
- */
-#warning This code requires at least version 4.6 of GCC
 #endif
 
 #pragma GCC diagnostic ignored "-Wunused-variable"
-- 
2.30.2

