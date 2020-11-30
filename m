Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB9FC64E7B
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 12:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B0B206D8
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 12:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wzHBkoKU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgK3M1I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 07:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgK3M1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 07:27:07 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-175-141.w2-15.abo.wanadoo.fr [2.15.255.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA9F206D8;
        Mon, 30 Nov 2020 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606739187;
        bh=4i4aC+L8/av2e2xk7qTJ9B87Pdoegzuc+2nQGoIJxu8=;
        h=From:To:Cc:Subject:Date:From;
        b=wzHBkoKUMJrWBHEgwLdRdO+iRvjRMDC4a0Hkz28iHVT/WOsxMBUnVXP3Uliph7Eyq
         ieRKIxlXHRK2tpIgyJqDBZoK+0boUSOyAwqkbl4FXgv+8aX/OVbjNZO8g4iCqytA8c
         DNvbwgIuPMsIymk5lkaIGzW6yjSn13ZVE5ujTr6Y=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, geert@linux-m68k.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: aegis128 - avoid spurious references crypto_aegis128_update_simd
Date:   Mon, 30 Nov 2020 13:26:20 +0100
Message-Id: <20201130122620.16640-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Geert reports that builds where CONFIG_CRYPTO_AEGIS128_SIMD is not set
may still emit references to crypto_aegis128_update_simd(), which
cannot be satisfied and therefore break the build. These references
only exist in functions that can be optimized away, but apparently,
the compiler is not always able to prove this.

So add some explicit checks for CONFIG_CRYPTO_AEGIS128_SIMD to help the
compiler figure this out.

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 2b05f79475d3..89dc1c559689 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -89,7 +89,7 @@ static void crypto_aegis128_update_a(struct aegis_state *state,
 				     const union aegis_block *msg,
 				     bool do_simd)
 {
-	if (do_simd) {
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) && do_simd) {
 		crypto_aegis128_update_simd(state, msg);
 		return;
 	}
@@ -101,7 +101,7 @@ static void crypto_aegis128_update_a(struct aegis_state *state,
 static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg,
 				     bool do_simd)
 {
-	if (do_simd) {
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) && do_simd) {
 		crypto_aegis128_update_simd(state, msg);
 		return;
 	}
-- 
2.17.1

