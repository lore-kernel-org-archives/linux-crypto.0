Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BDCC77B73
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjDHP14 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjDHP1y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7558610242
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1597660AB4
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548A3C433EF;
        Sat,  8 Apr 2023 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967672;
        bh=WCIInqLVBgl0lnWstcFe7pmbtXMzjb9G1XFch4e7MRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUkop1AMFtlKcwRSaf0dsTeELozYiEpUwj/mPXmIGAiGkdhWDc3Xiqik9NPS2YhlU
         KHgHyz9DDU5ggtNyVUD+hCcaAqDrnHd4s/X3F22aNIa4buG8iwTE4uH/mK68X4Dp1z
         r0AWwccxMuE8WWcLuwA5BMU/cO76jeNBZEr5qj046hw9N3c/nk9vW9XB3yNKaBfHmV
         4kVY41L7U7sMJ0mLfHqWy6ws1Dxj6AEus2Da0WLoVVdeRvdK3r4eooh5o8wjazuQPd
         3RgqDcDDq3vVepe/aOJwBMK2g/wsGp2m9RMsBRkvGyi+tu8BozA0XMQlRFU+gHEDtY
         Rkgs+DKASt6CQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 09/10] crypto: x86/ghash - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:21 +0200
Message-Id: <20230408152722.3975985-10-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1040; i=ardb@kernel.org; h=from:subject; bh=WCIInqLVBgl0lnWstcFe7pmbtXMzjb9G1XFch4e7MRM=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/cap81vSJFvL+yUm7TJ7/kt4t4Za3mLD+HCXi+89n 3z7HFfcUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACayK5Lhv1dj8O9cE7a9046u mGpXZCF1Iywr1Y5Hi382O/eMgLCZvxj++y0RXLFZ6ejOA5Vcb5Q/XGfxdjf9YaiqH20spfSeK3g lLwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 257ed9446f3ee1a9..99cb983ded9e369f 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -93,7 +93,7 @@ SYM_FUNC_START(clmul_ghash_mul)
 	FRAME_BEGIN
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
-	movaps .Lbswap_mask, BSWAP
+	movaps .Lbswap_mask(%rip), BSWAP
 	pshufb BSWAP, DATA
 	call __clmul_gf128mul_ble
 	pshufb BSWAP, DATA
@@ -110,7 +110,7 @@ SYM_FUNC_START(clmul_ghash_update)
 	FRAME_BEGIN
 	cmp $16, %rdx
 	jb .Lupdate_just_ret	# check length
-	movaps .Lbswap_mask, BSWAP
+	movaps .Lbswap_mask(%rip), BSWAP
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
 	pshufb BSWAP, DATA
-- 
2.39.2

