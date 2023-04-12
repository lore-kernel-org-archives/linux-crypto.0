Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96184C77B71
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDLLAv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDLLAu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DFE6583
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61E1A62889
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D0EC4339C;
        Wed, 12 Apr 2023 11:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297248;
        bh=VyfOUC2SaMgU8pz1GST90q6y2SQtV0uyViPVyABOX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umjmB07QxbRqVZROTjokkPRvAlTrVYwziXenh4tiFebx6Ce5vdqAQ6ppwBCF6MNGi
         35WBz0eSfsCQmBza84L1848Pc4WipotdE2NzVzvFxcagQHEsKCganATyNIDS57Vu8Y
         LzTmhhtvn+AKrIzGyTxYkUuenGFNnd6Iq0ZHrh8ACCOYmn0wscdGnXum6C2KzZZ5sJ
         6xP+OJj2JAzDBzxl26phxgqFdJIbPHTiwlIo7r5XYUMXP8FZgc1kKlCaR3tIk4tm1P
         s6tFw1RaIMQuNVFQRNuAu1D6VnJxgt+GtA4Fz7oQKUIIGNaUD2EkbeQ/tU+bO+U5/q
         SyGdK/M5F6Rcg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 01/13] crypto: x86/aegis128 - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:23 +0200
Message-Id: <20230412110035.361447-2-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=ardb@kernel.org; h=from:subject; bh=VyfOUC2SaMgU8pz1GST90q6y2SQtV0uyViPVyABOX3E=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs31mGafJbpZ9M09V3zVwePHHFa8M7E5kWmVvfd1th8 vfuy30uHaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiho8ZGU6aGFaVNAnlLbik 5WywbGeK7fe/N04vzNf7M8W6VPbTu0BGhosfVNd2mOU3bz10wanV5CtTopL/kz0r94f7r9Vo1Sn x5wcA
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

