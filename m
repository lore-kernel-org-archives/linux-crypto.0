Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B007FC77B71
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjDLLBQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDLLBN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527616A69
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:01:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D60F4632EB
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A791C4339C;
        Wed, 12 Apr 2023 11:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297261;
        bh=WCIInqLVBgl0lnWstcFe7pmbtXMzjb9G1XFch4e7MRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhYbnuBDrtISvotGsBEsnNMlt9hFKI5WTIhPulC6Wxf5gtgguZFWz2mFFwvz6Jwdn
         iNF5Ym/AwObwcTz8WJ4FmjOb93W3su0a0I21I23pHldTMfs4bUP/ev5Ga6s56DgoO7
         F0AjuE0EGzyb0F5f7kCHhl774Wa7C28MJfgSsVWaKmfNqff9148rWDIapI/PsvjiBv
         M+Inzgyx1Iu2MIUWlxpArBgv2XeA8kMhpF4A4gFHMR8qGRv2npwSP/B3bPMojrvgwD
         8avxUiQcWb5V5Zy/QGrFxxRPrdJHUAaNIgkUmnu+128YBlQiJJqetzh63G8hGGF0KO
         +m1UWIHW2c9fA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 09/13] crypto: x86/ghash - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:31 +0200
Message-Id: <20230412110035.361447-10-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1040; i=ardb@kernel.org; h=from:subject; bh=WCIInqLVBgl0lnWstcFe7pmbtXMzjb9G1XFch4e7MRM=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs3/fU+S1pkq3l/RKTdpk9/yW8W0Mtb7FhfLjLxfeeT 759jivuKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABO5fZ3hv/uzJbWSJS/a47OC Dnjd+Cl0+Mjh4qi2BQZftK8cLT39robhf+K3cy8/RmoJXeX7zrB3+ovsZ3Y6Oz6xZ8f9+Hq7Kz8 /kxcA
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

