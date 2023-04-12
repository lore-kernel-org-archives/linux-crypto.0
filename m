Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF27C77B6E
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjDLLBR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDLLBO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F876E80
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C02662889
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2243C433D2;
        Wed, 12 Apr 2023 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297262;
        bh=Em7n8Yu3fpuklxDgt7kSen6J5HDRU2CHTf0mvOk/VXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLwSFHuxumLEd66E7pWBfWlk6BaxpYm6klPr7ZJCB0PFtPoNlrrMo/NGXi4ehgU//
         FmYjwl7hsSSV6iwoiLww6gR2Y2BIRKiC3w+4NKBhdnslxrP2OO/+zfMRCbaQLUUQAH
         4J8wmdtFw7Ld3ffilsGNq8pB4tIHavU2RX4Kk+UG0u1uRxjdZm243A2pAP9wGcdwe6
         1heQTzcGkrCisyUaHa+RzYlB4Q26zjBI+sDZkv7CFpC3E1Uwl7aUnAQuI8UJySzIFe
         hTDuibp4PLF8nOD6G/wIZGt2tl62k1xdz3S2oaPQK+KmVixrLkwUIJRDOwPqGiHXqW
         6qo9iPVQzoDKw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 10/13] crypto: x86/sha256 - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:32 +0200
Message-Id: <20230412110035.361447-11-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1743; i=ardb@kernel.org; h=from:subject; bh=Em7n8Yu3fpuklxDgt7kSen6J5HDRU2CHTf0mvOk/VXI=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs3//Y1k03+9xcdLoniqYffRH4QDFJ8a1g7qHp1u8es 8mWzNzbUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACayyICRYUOl1OVdCoyN3PY+ zDnsX/PzH9inrZn7T8lQkcFHo8luLsNfUQ7Rqy/1vmcfNzm/3o85XFJy7dkCp/5U38mJu+dullj CAAA=
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

