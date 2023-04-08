Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBD9C77B6C
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjDHP2B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjDHP14 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC49FF3C
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD34960AD5
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA05FC433D2;
        Sat,  8 Apr 2023 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967674;
        bh=Em7n8Yu3fpuklxDgt7kSen6J5HDRU2CHTf0mvOk/VXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0l9gY5u1Tiwqw9syc9pSqCZIQWVjVva3Sln3PWF+2QN+xSjviOFvhbYZYpbF62kx
         L6ZGXMsGfWN3wV5AyJHFwdEiTqPJODwPblPTg2EaJCFiOiQYPbum9Ki+lPjdjI6PqD
         suVjTL0aFFwOu0vQnh/A0X9rxBOf6r4GSsDqS+jGY7miPf4/KZYIBoE+IlFBewFZAS
         Hdx9RXMs39xX1a7w4+yM69bEICyILFejqRdLA5X46z3oea2XSgJNFilfNhePDu+57I
         1+/TsD2ci7d2/UddUNAUzT24VM+tHAL/Er2bulpb9pfnZU+vqHmknDHR1xPGZQbODB
         dgG/nk+S/mlUQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 10/10] crypto: x86/sha256 - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:22 +0200
Message-Id: <20230408152722.3975985-11-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1743; i=ardb@kernel.org; h=from:subject; bh=Em7n8Yu3fpuklxDgt7kSen6J5HDRU2CHTf0mvOk/VXI=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/eaxrZtu9rm56HRPFE0/+iLwgWKS4lvB3EPTrd89Z pMtmbm3o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExEx4+R4ZzC5enZL1UMjS4v nLiWy5q79u/3j50sK28eX7txvXfv04UMfyVmThYwvvrrGoeuHJ8k1+aLf2Oyn91foPDvXEXOryU KvjwA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/sha256-avx2-asm.S | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 3eada94168526665..e2a4024fb0a3f5d5 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -589,19 +589,23 @@ last_block_enter:
 
 .align 16
 loop1:
-	vpaddd	K256+0*32(SRND), X0, XFER
+	leaq	K256+0*32(%rip), INP		## reuse INP as scratch reg
+	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 0*32
 
-	vpaddd	K256+1*32(SRND), X0, XFER
+	leaq	K256+1*32(%rip), INP
+	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 1*32
 
-	vpaddd	K256+2*32(SRND), X0, XFER
+	leaq	K256+2*32(%rip), INP
+	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 2*32
 
-	vpaddd	K256+3*32(SRND), X0, XFER
+	leaq	K256+3*32(%rip), INP
+	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 3*32
 
@@ -611,11 +615,13 @@ loop1:
 
 loop2:
 	## Do last 16 rounds with no scheduling
-	vpaddd	K256+0*32(SRND), X0, XFER
+	leaq	K256+0*32(%rip), INP
+	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
 	DO_4ROUNDS	_XFER + 0*32
 
-	vpaddd	K256+1*32(SRND), X1, XFER
+	leaq	K256+1*32(%rip), INP
+	vpaddd	(INP, SRND), X1, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
 	DO_4ROUNDS	_XFER + 1*32
 	add	$2*32, SRND
-- 
2.39.2

