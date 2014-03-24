From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/3] crypto: x86/sha1 - fix stack alignment of AVX2 variant
Date: Mon, 24 Mar 2014 17:10:38 +0100
Message-ID: <1395677439-7478-3-git-send-email-minipli@googlemail.com>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53919 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbaCXQKu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 12:10:50 -0400
Received: by mail-bk0-f52.google.com with SMTP id my13so563210bkb.25
        for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2014 09:10:49 -0700 (PDT)
In-Reply-To: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AVX2 implementation might waste up to a page of stack memory because
of a wrong alignment calculation. This will, in the worst case, increase
the stack usage of sha1_transform_avx2() alone to 5.4 kB -- way to big
for a kernel function. Even worse, it might also allocate *less* bytes
than needed if the stack pointer is already aligned bacause in that case
the 'sub %rbx, %rsp' is effectively moving the stack pointer upwards,
not downwards.

Fix those issues by changing and simplifying the alignment calculation
to use a 32 byte alignment, the alignment really needed.

Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 4f348544d1..bacac22b20 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -636,9 +636,7 @@ _loop3:
 
 	/* Align stack */
 	mov	%rsp, %rbx
-	and	$(0x1000-1), %rbx
-	sub	$(8+32), %rbx
-	sub	%rbx, %rsp
+	and	$~(0x20-1), %rsp
 	push	%rbx
 	sub	$RESERVE_STACK, %rsp
 
@@ -665,8 +663,7 @@ _loop3:
 	avx2_zeroupper
 
 	add	$RESERVE_STACK, %rsp
-	pop	%rbx
-	add	%rbx, %rsp
+	pop	%rsp
 
 	pop	%r15
 	pop	%r14
-- 
1.7.10.4
