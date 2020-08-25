Return-Path: <SRS0=bFPd=CD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E51C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 01:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C4E20738
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 01:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHYBlb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:41:31 -0400
Received: from [216.24.177.18] ([216.24.177.18]:58840 "EHLO fornost.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgHYBlb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 21:41:31 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kANfw-000554-LA; Tue, 25 Aug 2020 11:23:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Aug 2020 11:23:00 +1000
Date:   Tue, 25 Aug 2020 11:23:00 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] crypto: arm/poly1305 - Add prototype for poly1305_blocks_neon
Message-ID: <20200825012300.GA10236@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a prototype for poly1305_blocks_neon to slience
a compiler warning:

  CC [M]  arch/arm/crypto/poly1305-glue.o
../arch/arm/crypto/poly1305-glue.c:25:13: warning: no previous prototype for `poly1305_blocks_neon' [-Wmissing-prototypes]
 void __weak poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit)
             ^~~~~~~~~~~~~~~~~~~~

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index 13cfef4ae22e..3023c1acfa19 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -20,6 +20,7 @@
 
 void poly1305_init_arm(void *state, const u8 *key);
 void poly1305_blocks_arm(void *state, const u8 *src, u32 len, u32 hibit);
+void poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit);
 void poly1305_emit_arm(void *state, u8 *digest, const u32 *nonce);
 
 void __weak poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
