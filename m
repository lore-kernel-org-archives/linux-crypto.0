Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E2DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 07:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiBWHHj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 02:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238533AbiBWHHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 02:07:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38508A1B6
        for <linux-crypto@vger.kernel.org>; Tue, 22 Feb 2022 23:07:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D289B614CC
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 07:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC5BC340E7;
        Wed, 23 Feb 2022 07:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645600031;
        bh=JRTomZkeDAUGX5ynEJbc79c4T54YfaZMZeCXKOwpl04=;
        h=From:To:Cc:Subject:Date:From;
        b=UGD+m+9ys6vYs+O69ec838zXBUKQPgvlrWUEzUBGeZ2yNodEPuk5ydkCXCQJa4tPX
         xNwk7Li/1mscATLbIElcxQJpw8ykrOwT35NWGLXS2FFi0AX8buuoJ04zRWNEjaMn28
         KjbbchY10gGj3Vrq6in9kBs3hmu02trhtgyUWZoz8J71R20KUWpsN7q94S4q071PWO
         iDhCqMFXuy5oSmhcUmL4Y76sEUseSP6Gvyj45a4Y/Gn8/e/pzBBMlVtbFjft4eCNov
         8bIUcC+S6d9GIGLsfIuiisMdqmSJRUDsbe4bnABokt6RYqVVKFWzetuoTbwIUOVaS1
         mKRl+dSEpR5/g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] crypto: crypto_xor - use helpers for unaligned accesses
Date:   Wed, 23 Feb 2022 08:07:01 +0100
Message-Id: <20220223070701.1457542-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3600; h=from:subject; bh=JRTomZkeDAUGX5ynEJbc79c4T54YfaZMZeCXKOwpl04=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiFd0U4Tb9euK9PgHy2S/6vYudag7p/Ij573eBaFnl ZkvCJwuJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYhXdFAAKCRDDTyI5ktmPJBiTC/ wNEoRQDmhh47aJYN0SgqB3KtvZOAiyQZlG69DAFxv6sO7pgl9GCO04VuK/+MtifRSCnEmDKDh/hPGV zx+CFl1jUWJisQjot4iA217kliuhnL7+pARE1Q8VuEHFBMtxbq39VLQNcYuPOgZ0LgAYICvSsHY1LC ErkLSjgnd+L0QSzr5l6ko8bfT2Q8IAub6MKk8GeaIdm5mdpaeg5H6Lq2tPUodZmnT0I7SvNcJ5XANI Wwse6ArIOPp+Uiv+UP7WODF8CqNYwIZTBOjILS5ndaLujh7miVbmwG/hSKdiVbiGVx9eYQsJN2aJfw sAnH4uVo7IoxmySNVlsbmuYuL3GZTJwuIdEsbQqHvZvyjmrBwgWTrpETAXcG+PLkiLYeI4v3bwxAsw qxUkHG8NiS6AgJpGvJqbcGpinmL9mcqpql3cEdpQnHegdHKwDB1CFj9IfgxIPO6ITOG4UUBmKbYT5M 5132JcgZ3lrgYNMv3FOW788Ti+08GbUszjXWljGwNntCg=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dereferencing a misaligned pointer is undefined behavior in C, and may
result in codegen on architectures such as ARM that trigger alignments
traps and expensive fixups in software.

Instead, use the get_aligned()/put_aligned() accessors, which are cheap
or even completely free when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y.

In the converse case, the prior alignment checks ensure that the casts
are safe, and so no unaligned accessors are necessary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: fix issue in crypto_xor_cpy()

 crypto/algapi.c         | 24 +++++++++++++++++---
 include/crypto/algapi.h | 10 ++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9f15e11f5d73..a6a10f2ee0dc 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1008,7 +1008,13 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 	}
 
 	while (IS_ENABLED(CONFIG_64BIT) && len >= 8 && !(relalign & 7)) {
-		*(u64 *)dst = *(u64 *)src1 ^  *(u64 *)src2;
+		if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+			u64 l = get_unaligned((u64 *)src1) ^
+				get_unaligned((u64 *)src2);
+			put_unaligned(l, (u64 *)dst);
+		} else {
+			*(u64 *)dst = *(u64 *)src1 ^ *(u64 *)src2;
+		}
 		dst += 8;
 		src1 += 8;
 		src2 += 8;
@@ -1016,7 +1022,13 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 	}
 
 	while (len >= 4 && !(relalign & 3)) {
-		*(u32 *)dst = *(u32 *)src1 ^ *(u32 *)src2;
+		if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+			u32 l = get_unaligned((u32 *)src1) ^
+				get_unaligned((u32 *)src2);
+			put_unaligned(l, (u32 *)dst);
+		} else {
+			*(u32 *)dst = *(u32 *)src1 ^ *(u32 *)src2;
+		}
 		dst += 4;
 		src1 += 4;
 		src2 += 4;
@@ -1024,7 +1036,13 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 	}
 
 	while (len >= 2 && !(relalign & 1)) {
-		*(u16 *)dst = *(u16 *)src1 ^ *(u16 *)src2;
+		if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+			u16 l = get_unaligned((u16 *)src1) ^
+				get_unaligned((u16 *)src2);
+			put_unaligned(l, (u16 *)dst);
+		} else {
+			*(u16 *)dst = *(u16 *)src1 ^ *(u16 *)src2;
+		}
 		dst += 2;
 		src1 += 2;
 		src2 += 2;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index f76ec723ceae..f50c5d1725da 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -13,6 +13,8 @@
 #include <linux/list.h>
 #include <linux/types.h>
 
+#include <asm/unaligned.h>
+
 /*
  * Maximum values for blocksize and alignmask, used to allocate
  * static buffers that are big enough for any combination of
@@ -154,9 +156,11 @@ static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
 	    (size % sizeof(unsigned long)) == 0) {
 		unsigned long *d = (unsigned long *)dst;
 		unsigned long *s = (unsigned long *)src;
+		unsigned long l;
 
 		while (size > 0) {
-			*d++ ^= *s++;
+			l = get_unaligned(d) ^ get_unaligned(s++);
+			put_unaligned(l, d++);
 			size -= sizeof(unsigned long);
 		}
 	} else {
@@ -173,9 +177,11 @@ static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
 		unsigned long *d = (unsigned long *)dst;
 		unsigned long *s1 = (unsigned long *)src1;
 		unsigned long *s2 = (unsigned long *)src2;
+		unsigned long l;
 
 		while (size > 0) {
-			*d++ = *s1++ ^ *s2++;
+			l = get_unaligned(s1++) ^ get_unaligned(s2++);
+			put_unaligned(l, d++);
 			size -= sizeof(unsigned long);
 		}
 	} else {
-- 
2.30.2

