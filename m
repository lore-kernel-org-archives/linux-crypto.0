Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C7FC77B6E
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjDHP1l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHP1l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F02728
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ADF0601D6
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683ADC433D2;
        Sat,  8 Apr 2023 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967659;
        bh=VyfOUC2SaMgU8pz1GST90q6y2SQtV0uyViPVyABOX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dofKYlGN2hqY7Y5mSNYSdHmF+0wEh+TtC7zbvUerAfAN5nTY3YibKmbAb4f6rDm4X
         UZRtn8zNguim0Rpeep20f7a91DFNqfDtnv7qzqfaaMwVs0SBSToaSGbocbExmz430V
         nTpPng0ycgLotGsqoRI5ZXuAPAXycT14M58D2tTBIBUwm33yt/+3jn6aFsOb34SrNl
         0GLP9LRw+mR8z099+jU+jL/GM1LfwrOpjcSxThoWw+pG4MuMp63cXhj9+6GVbrel/3
         EbBmiQAOY4qguoYYXGrBgorcfLrKeCyarlC8UFqKYNjSVXcXtmkZmeStzQB7GlPmL+
         StUxHCm6dWBGQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 01/10] crypto: x86/aegis128 - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:13 +0200
Message-Id: <20230408152722.3975985-2-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=ardb@kernel.org; h=from:subject; bh=VyfOUC2SaMgU8pz1GST90q6y2SQtV0uyViPVyABOX3E=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/bwM0+S3Sj+Zpqvvmrk8eOKK14Z3JjItMre+77bC5 O/dl/tcOkpZGMQ4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBETvIz/A/rMlYJjr28XpR/ ddjB4+mXlv5rizLrm7l2wfuHrSXnS8sYGV435O3//8H36FXOLk+lx2e452+bvWPh+nf2cUvTJ7U 23GMGAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index cdf3215ec272ced2..ad7f4c89162568b0 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -201,8 +201,8 @@ SYM_FUNC_START(crypto_aegis128_aesni_init)
 	movdqa KEY, STATE4
 
 	/* load the constants: */
-	movdqa .Laegis128_const_0, STATE2
-	movdqa .Laegis128_const_1, STATE1
+	movdqa .Laegis128_const_0(%rip), STATE2
+	movdqa .Laegis128_const_1(%rip), STATE1
 	pxor STATE2, STATE3
 	pxor STATE1, STATE4
 
@@ -682,7 +682,7 @@ SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	punpcklbw T0, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
-	movdqa .Laegis128_counter, T1
+	movdqa .Laegis128_counter(%rip), T1
 	pcmpgtb T1, T0
 	pand T0, MSG
 
-- 
2.39.2

