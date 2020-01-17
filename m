Return-Path: <SRS0=A/Go=3G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871FEC33CB1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 16:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DA97217F4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579279426;
	bh=IiJ6N7t5g/544HW//RaB69eXe3oLB3o2rtxnrI3LbX8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=DPQihz+cYahE7uweYG3EG0RPv2mVQObG8dn8XXA9QXMs0iuK6rmPwMG+ur7fqb/av
	 NcHWRb5IRJsq66qvzdAhnLusvV/Ex9BbFjgkc0gzxNa/V3Aj5Rgeb3r1m4LhvM9Dzh
	 +LojXxeunoZ5g8sElse9zhY/Pnj+ik8jfu/aLSrE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgAQQnp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jan 2020 11:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgAQQnp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jan 2020 11:43:45 -0500
Received: from dogfood.home (amontpellier-657-1-18-247.w109-210.abo.wanadoo.fr [109.210.65.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26FED21582;
        Fri, 17 Jan 2020 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579279425;
        bh=IiJ6N7t5g/544HW//RaB69eXe3oLB3o2rtxnrI3LbX8=;
        h=From:To:Cc:Subject:Date:From;
        b=kQLkx+xR3VKJV19EKDldbqG5eaEFTIQbRO87amwtfHaVNEbuKpYRWSNgSRL6teTqf
         x87tfnyDN04/6yrf9SfrjRcDCJ2q3jtgotiV0AU71bzZXJLDff3cFM6vG1/J4ruMnX
         zVCtiHUIO7PWWOX6ReQ8AozC7ihtXtwVX+AdU7QI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: arm/chacha - fix build failured when kernel mode NEON is disabled
Date:   Fri, 17 Jan 2020 17:43:18 +0100
Message-Id: <20200117164318.21941-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the ARM accelerated ChaCha driver is built as part of a configuration
that has kernel mode NEON disabled, we expect the compiler to propagate
the build time constant expression IS_ENABLED(CONFIG_KERNEL_MODE_NEON) in
a way that eliminates all the cross-object references to the actual NEON
routines, which allows the chacha-neon-core.o object to be omitted from
the build entirely.

Unfortunately, this fails to work as expected in some cases, and we may
end up with a build error such as

  chacha-glue.c:(.text+0xc0): undefined reference to `chacha_4block_xor_neon'

caused by the fact that chacha_doneon() has not been eliminated from the
object code, even though it will never be called in practice.

Let's fix this by adding some IS_ENABLED(CONFIG_KERNEL_MODE_NEON) tests
that are not strictly needed from a logical point of view, but should
help the compiler infer that the NEON code paths are unreachable in
those cases.

Fixes: b36d8c09e710c71f ("crypto: arm/chacha - remove dependency on generic ...")
Reported-by: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/chacha-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 6ebbb2b241d2..6fdb0ac62b3d 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -115,7 +115,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		if (!neon) {
+		if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
 			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
 				     nbytes, state, ctx->nrounds);
 			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
@@ -159,7 +159,7 @@ static int do_xchacha(struct skcipher_request *req, bool neon)
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
-	if (!neon) {
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
 		hchacha_block_arm(state, subctx.key, ctx->nrounds);
 	} else {
 		kernel_neon_begin();
-- 
2.20.1

