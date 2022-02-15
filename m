Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BD4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Feb 2022 10:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiBOK5k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Feb 2022 05:57:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiBOK5k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Feb 2022 05:57:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00795DAAF0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Feb 2022 02:57:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B7C8B81865
        for <linux-crypto@vger.kernel.org>; Tue, 15 Feb 2022 10:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB39C340EB;
        Tue, 15 Feb 2022 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644922647;
        bh=oTrrbRmvPOFAHBlsmqIuLvsKMgFwaN/MTk2ofTZGwAI=;
        h=From:To:Cc:Subject:Date:From;
        b=gGGYu6jT1S+XIoLAHhVM170umN7lwohClPwaL9A8SjsKWeuvggm1i2E4hRux957sx
         zOB/S9Q3NksN1pVNyxQaCQbXLfHfTq5UucNI9vZnWHDJKFMm4S1EpLtAT/I7E97LSd
         X6wmO0xaDwv82CsZh9XrxpHZ3mL/7B4gFsRT3eM7e8pfdEhjsFf4Xpwy4QmUqfCYjX
         gprVZWIFWU8iCNHaNfk9ZUtZBkgYNZjPHhsIk2yL/MVGWJU9l5gya7yIGsLAR32fJb
         dX7rlffzLpjLyWZkZv52njXmCzS6xevXt25G/UoB8xneW3MH/IcOtuQSh1sNglhA9E
         ZwPm8ExcxqFvQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: crypto_xor - use helpers for unaligned accesses
Date:   Tue, 15 Feb 2022 11:57:17 +0100
Message-Id: <20220215105717.184572-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3596; h=from:subject; bh=oTrrbRmvPOFAHBlsmqIuLvsKMgFwaN/MTk2ofTZGwAI=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiC4cMjGT6hEYvEcFtYby/v4hMPyz+LdZ0f+M0xulp rLWuSGCJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYguHDAAKCRDDTyI5ktmPJG1aC/ 0VEcyR5BQv+pGd2tStWuwK16qEH/rL5kE5n0K8GnPhBC45t43z2gE6a+yrm2D8zu354SHe8N/Vz3qR I9s1DZASaZPOOuz4DUGNqc6Vb4N3uypgUqr5t6nrhRIBfsl7c7a3ugzXIvrOU+c0o6qGnc76wOQcEP p12HNy9UlDD4Jlk8K5h6SU1+2NFtISQrJ3FnbBTO830/b+QOBVZuMutVycBXO7ymHZh2HT2Opp4MXT TNKQL4F4Y8F7DX8QdltuBUs1jDkPZgXnrpi7foItY4cfOsDT9Mjn3bdCAf4fO+ukrkkJJ+Onj3Rh1B WjEeyN2ZQp1m/5GIoWjPkQjBFtu+8fT4Jsf8hHSlqgPiU5OqNiiagbLcKOvVU8VF98pJ+66WREmHKD rOkPmNfAHTsBNpJ0wZRHrxTlbXNaY2k/v+2u1/PNG++GrhPQjCLSAha4KQg1rObBXPf85UmVaC9Phr pAceevOwzoOujX/ZnhBO04T/FXNoDfXmzButdUW5kxx6A=
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
 crypto/algapi.c         | 24 +++++++++++++++++++++---
 include/crypto/algapi.h | 11 +++++++++--
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 76fdaa16bd4a..5f96ac51269a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1002,7 +1002,13 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
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
@@ -1010,7 +1016,13 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
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
@@ -1018,7 +1030,13 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
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
index f76ec723ceae..932ae31b0b4d 100644
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
@@ -173,9 +177,12 @@ static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
 		unsigned long *d = (unsigned long *)dst;
 		unsigned long *s1 = (unsigned long *)src1;
 		unsigned long *s2 = (unsigned long *)src2;
+		unsigned long l;
 
 		while (size > 0) {
-			*d++ = *s1++ ^ *s2++;
+			l = get_unaligned(d) ^ get_unaligned(s1++)
+			  ^ get_unaligned(s2++);
+			put_unaligned(l, d++);
 			size -= sizeof(unsigned long);
 		}
 	} else {
-- 
2.30.2

