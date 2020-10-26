Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797C0C2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296E3207C4
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603753235;
	bh=AVlRUFxXyeeXEYO6T9ZX4iFl7rmm2ft6LpQ3jwswyTA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=LmoORjk3t+XHS8OHLspNgb/TlwGKrQPs1lzxym2ec75jVxVRq00nUFGpdh3jR+9sV
	 TSkcMXLJX2up6ZFX/faiIqCfW1MdX3L13a1Z8NP8J0wM06FYisCryiSohne66pvvcV
	 eCfKN1v+jYbJaBZ2Dzph6aTBD1OGM/67bFHNylOg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395066AbgJZXAe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393548AbgJZXAe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 19:00:34 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9FED20780;
        Mon, 26 Oct 2020 23:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603753233;
        bh=AVlRUFxXyeeXEYO6T9ZX4iFl7rmm2ft6LpQ3jwswyTA=;
        h=From:To:Cc:Subject:Date:From;
        b=KS13f2jitE1ptufERntwGy+M5/cTsgHy20mDNze5xQyo0WCl9/zuLQ35BXeWjnZm2
         Ua72lNHc7W1Qpn+nhTaUOHpjD03NppXHW5dqBEPpwEjmv9tkTkJDIHbTUYIJJNB3WG
         buuw3fPPQ5W5LBNDSM7xQdIGgqk5qYdJRgUN7AaY=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: arm64/poly1305-neon - reorder PAC authentication with SP update
Date:   Tue, 27 Oct 2020 00:00:27 +0100
Message-Id: <20201026230027.25813-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PAC pointer authentication signs the return address against the value
of the stack pointer, to prevent stack overrun exploits from corrupting
the control flow. However, this requires that the AUTIASP is issued with
SP holding the same value as it held when the PAC value was generated.
The Poly1305 NEON code got this wrong, resulting in crashes on PAC
capable hardware.

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/poly1305-armv8.pl       | 2 +-
 arch/arm64/crypto/poly1305-core.S_shipped | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/poly1305-armv8.pl
index 6e5576d19af8..cbc980fb02e3 100644
--- a/arch/arm64/crypto/poly1305-armv8.pl
+++ b/arch/arm64/crypto/poly1305-armv8.pl
@@ -840,7 +840,6 @@ poly1305_blocks_neon:
 	 ldp	d14,d15,[sp,#64]
 	addp	$ACC2,$ACC2,$ACC2
 	 ldr	x30,[sp,#8]
-	 .inst	0xd50323bf		// autiasp
 
 	////////////////////////////////////////////////////////////////
 	// lazy reduction, but without narrowing
@@ -882,6 +881,7 @@ poly1305_blocks_neon:
 	str	x4,[$ctx,#8]		// set is_base2_26
 
 	ldr	x29,[sp],#80
+	 .inst	0xd50323bf		// autiasp
 	ret
 .size	poly1305_blocks_neon,.-poly1305_blocks_neon
 
diff --git a/arch/arm64/crypto/poly1305-core.S_shipped b/arch/arm64/crypto/poly1305-core.S_shipped
index 8d1c4e420ccd..fb2822abf63a 100644
--- a/arch/arm64/crypto/poly1305-core.S_shipped
+++ b/arch/arm64/crypto/poly1305-core.S_shipped
@@ -779,7 +779,6 @@ poly1305_blocks_neon:
 	 ldp	d14,d15,[sp,#64]
 	addp	v21.2d,v21.2d,v21.2d
 	 ldr	x30,[sp,#8]
-	 .inst	0xd50323bf		// autiasp
 
 	////////////////////////////////////////////////////////////////
 	// lazy reduction, but without narrowing
@@ -821,6 +820,7 @@ poly1305_blocks_neon:
 	str	x4,[x0,#8]		// set is_base2_26
 
 	ldr	x29,[sp],#80
+	 .inst	0xd50323bf		// autiasp
 	ret
 .size	poly1305_blocks_neon,.-poly1305_blocks_neon
 
-- 
2.17.1

