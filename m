Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1B9C7619A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDLLBP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDLLBC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B738D6EAD
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5378963256
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93934C433D2;
        Wed, 12 Apr 2023 11:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297259;
        bh=5xYP4xdbKfF7TFdddJFji/S1DKTwXAgbtRcwhupiGTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBFt+YQR6gmlzPhkQ4TxKFCdzSUAMC8oA3yrw7B0tI9Vwr6OLm8k/1TAbst/qYayK
         c9pwl4w1NFdSReLf3LIiBX9S0HA/Dv4nYHDjAyQR+GKdTSzjsBzNQNhro/NrT7NZu4
         xemqD6JV8KJdn8BNsLRRJAjecftteCQZdf9BQVwhq8rTnWAzW+oEzeFV51TVjv73Iy
         TGNxCTcuzYtMdjA58VvOQyneOuCJedbWnRMQ4a5csoIDdvfBC6Ov8qmYRLxVf4nhD9
         3BFN6lyXYTdh3JLbXJ8xbu4T/eZSTASHhKy6TcfgJ7z6Y8bV1qB+Vc7DXa3Q1RIJM/
         lDLhJtpLgOirw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 08/13] crypto: x86/des3 - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:30 +0200
Message-Id: <20230412110035.361447-9-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4853; i=ardb@kernel.org; h=from:subject; bh=5xYP4xdbKfF7TFdddJFji/S1DKTwXAgbtRcwhupiGTo=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs3yd0yin/qQ/uXdFJNImbcmbbni2dc3bbabPM/DSzw 0m0kfFPRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIP3WG/7FJ176J7pKZ8e3i AmsTi02dxtKRGtwS3ImnT23azJ4odYKR4ZN9pYxAUNasuxfVbkj3HPqrd/m87byUwJqZ6Vsu5dZ N4gcA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Co-developed-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/des3_ede-asm_64.S | 96 +++++++++++++-------
 1 file changed, 64 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/des3_ede-asm_64.S b/arch/x86/crypto/des3_ede-asm_64.S
index f4c760f4cade6d7b..cf21b998e77cc4ea 100644
--- a/arch/x86/crypto/des3_ede-asm_64.S
+++ b/arch/x86/crypto/des3_ede-asm_64.S
@@ -129,21 +129,29 @@
 	movzbl RW0bl, RT2d; \
 	movzbl RW0bh, RT3d; \
 	shrq $16, RW0; \
-	movq s8(, RT0, 8), RT0; \
-	xorq s6(, RT1, 8), to; \
+	leaq s8(%rip), RW1; \
+	movq (RW1, RT0, 8), RT0; \
+	leaq s6(%rip), RW1; \
+	xorq (RW1, RT1, 8), to; \
 	movzbl RW0bl, RL1d; \
 	movzbl RW0bh, RT1d; \
 	shrl $16, RW0d; \
-	xorq s4(, RT2, 8), RT0; \
-	xorq s2(, RT3, 8), to; \
+	leaq s4(%rip), RW1; \
+	xorq (RW1, RT2, 8), RT0; \
+	leaq s2(%rip), RW1; \
+	xorq (RW1, RT3, 8), to; \
 	movzbl RW0bl, RT2d; \
 	movzbl RW0bh, RT3d; \
-	xorq s7(, RL1, 8), RT0; \
-	xorq s5(, RT1, 8), to; \
-	xorq s3(, RT2, 8), RT0; \
+	leaq s7(%rip), RW1; \
+	xorq (RW1, RL1, 8), RT0; \
+	leaq s5(%rip), RW1; \
+	xorq (RW1, RT1, 8), to; \
+	leaq s3(%rip), RW1; \
+	xorq (RW1, RT2, 8), RT0; \
 	load_next_key(n, RW0); \
 	xorq RT0, to; \
-	xorq s1(, RT3, 8), to; \
+	leaq s1(%rip), RW1; \
+	xorq (RW1, RT3, 8), to; \
 
 #define load_next_key(n, RWx) \
 	movq (((n) + 1) * 8)(CTX), RWx;
@@ -355,65 +363,89 @@ SYM_FUNC_END(des3_ede_x86_64_crypt_blk)
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	shrq $16, RW0; \
-	xorq s8(, RT3, 8), to##0; \
-	xorq s6(, RT1, 8), to##0; \
+	leaq s8(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s6(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	shrq $16, RW0; \
-	xorq s4(, RT3, 8), to##0; \
-	xorq s2(, RT1, 8), to##0; \
+	leaq s4(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s2(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	shrl $16, RW0d; \
-	xorq s7(, RT3, 8), to##0; \
-	xorq s5(, RT1, 8), to##0; \
+	leaq s7(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s5(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 	movzbl RW0bl, RT3d; \
 	movzbl RW0bh, RT1d; \
 	load_next_key(n, RW0); \
-	xorq s3(, RT3, 8), to##0; \
-	xorq s1(, RT1, 8), to##0; \
+	leaq s3(%rip), RT2; \
+	xorq (RT2, RT3, 8), to##0; \
+	leaq s1(%rip), RT2; \
+	xorq (RT2, RT1, 8), to##0; \
 		xorq from##1, RW1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		shrq $16, RW1; \
-		xorq s8(, RT3, 8), to##1; \
-		xorq s6(, RT1, 8), to##1; \
+		leaq s8(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s6(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		shrq $16, RW1; \
-		xorq s4(, RT3, 8), to##1; \
-		xorq s2(, RT1, 8), to##1; \
+		leaq s4(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s2(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		shrl $16, RW1d; \
-		xorq s7(, RT3, 8), to##1; \
-		xorq s5(, RT1, 8), to##1; \
+		leaq s7(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s5(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 		movzbl RW1bl, RT3d; \
 		movzbl RW1bh, RT1d; \
 		do_movq(RW0, RW1); \
-		xorq s3(, RT3, 8), to##1; \
-		xorq s1(, RT1, 8), to##1; \
+		leaq s3(%rip), RT2; \
+		xorq (RT2, RT3, 8), to##1; \
+		leaq s1(%rip), RT2; \
+		xorq (RT2, RT1, 8), to##1; \
 			xorq from##2, RW2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			shrq $16, RW2; \
-			xorq s8(, RT3, 8), to##2; \
-			xorq s6(, RT1, 8), to##2; \
+			leaq s8(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s6(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			shrq $16, RW2; \
-			xorq s4(, RT3, 8), to##2; \
-			xorq s2(, RT1, 8), to##2; \
+			leaq s4(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s2(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			shrl $16, RW2d; \
-			xorq s7(, RT3, 8), to##2; \
-			xorq s5(, RT1, 8), to##2; \
+			leaq s7(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s5(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2; \
 			movzbl RW2bl, RT3d; \
 			movzbl RW2bh, RT1d; \
 			do_movq(RW0, RW2); \
-			xorq s3(, RT3, 8), to##2; \
-			xorq s1(, RT1, 8), to##2;
+			leaq s3(%rip), RT2; \
+			xorq (RT2, RT3, 8), to##2; \
+			leaq s1(%rip), RT2; \
+			xorq (RT2, RT1, 8), to##2;
 
 #define __movq(src, dst) \
 	movq src, dst;
-- 
2.39.2

