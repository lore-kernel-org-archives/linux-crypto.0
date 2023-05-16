Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE46C77B75
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 18:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjEPSO3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 14:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEPSO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 14:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21232420A
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 11:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA8986351F
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 18:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2DEC4339B;
        Tue, 16 May 2023 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684260867;
        bh=jfDxPqpHA0GQF2a7OMKuszIKEHTxP81kP5w+2MzNhrs=;
        h=From:To:Cc:Subject:Date:From;
        b=tIXuUZhID5gPpQ7N96+Y0/A4JKkaCMNeq7KxLAQ17JJNdEgB+4RwXoERV0OPazers
         dGlLWWpGWG8fZYs5AUiMuJTXNHjAB3X+SYZRajxTCz0pxJT4TzMRY/ThEYXWeaW3pr
         VakucT86Rg6C1cIbwRQAvqpSXI4cYxgARlWrfAu1ON9wXc98tcVWDSBvSwq8mA4sMJ
         X2/HXx9YGEfZZY0bD4IRBWKW1uLjpSzb8a1iA4g1cCUbSnmxfKqDlttJ4ko8mrOg9w
         pFR5HnTs4aYPgEURKU4EdaIKh39Wjes34U2y66yXV/M8oC2EncFffdQf1fe09OeFGe
         x68Z1f0R7Pp+Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com
Subject: [PATCH] crypto: x86/aria - Use 16 byte alignment for GFNI constant vectors
Date:   Tue, 16 May 2023 20:14:19 +0200
Message-Id: <20230516181419.3633842-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1448; i=ardb@kernel.org; h=from:subject; bh=jfDxPqpHA0GQF2a7OMKuszIKEHTxP81kP5w+2MzNhrs=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JISX5+O+21eViTR//Jn1aV/R5kdMP2c/8WyPnMHiKRbx7s GKO/hHpjlIWBjEOBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARNmaG/4mrZacHvPv+ZNqr MpGr9S9PbX88Y2rPpvUbRYVXaoTs8k5nZHjlKal4pzDxHOfGufVhz8/2shoFSF1kf7FHfFoky7/ FG1kB
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The GFNI routines in the AVX version of the ARIA implementation now use
explicit VMOVDQA instructions to load the constant input vectors, which
means they must be 16 byte aligned. So ensure that this is the case, by
dropping the section split and the incorrect .align 8 directive, and
emitting the constants into the 16-byte aligned section instead.

Note that the AVX2 version of this code deviates from this pattern, and
does not require a similar fix, given that it loads these contants as
8-byte memory operands, for which AVX2 permits any alignment.

Cc: Taehee Yoo <ap420073@gmail.com>
Fixes: 8b84475318641c2b ("crypto: x86/aria-avx - Do not use avx2 instructions")
Reported-by: syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com
Tested-by: syzbot+a6abcf08bad8b18fd198@syzkaller.appspotmail.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index 7c1abc513f34621e..9556dacd984154a2 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -773,8 +773,6 @@
 	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
 
 #ifdef CONFIG_AS_GFNI
-.section	.rodata.cst8, "aM", @progbits, 8
-.align 8
 /* AES affine: */
 #define tf_aff_const BV8(1, 1, 0, 0, 0, 1, 1, 0)
 .Ltf_aff_bitmatrix:
-- 
2.39.2

