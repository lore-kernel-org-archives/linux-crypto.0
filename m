Return-Path: <SRS0=bFPd=CD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47346C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 01:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E1F120639
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 01:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgHYBlh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:41:37 -0400
Received: from [216.24.177.18] ([216.24.177.18]:58840 "EHLO fornost.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgHYBlh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 21:41:37 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kANuT-0005C7-Ds; Tue, 25 Aug 2020 11:38:02 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Aug 2020 11:38:01 +1000
Date:   Tue, 25 Aug 2020 11:38:01 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/gcm - Fix endianness warnings
Message-ID: <20200825013801.GA16040@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch changes a couple u128's to be128 which is the correct
type to use and fixes a few sparse warnings.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index da1034867aaa..8536008e3e35 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -347,7 +347,7 @@ static int gcm_encrypt(struct aead_request *req)
 	u8 buf[AES_BLOCK_SIZE];
 	u8 iv[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
-	u128 lengths;
+	be128 lengths;
 	u8 *tag;
 	int err;
 
@@ -461,7 +461,7 @@ static int gcm_decrypt(struct aead_request *req)
 	u8 buf[AES_BLOCK_SIZE];
 	u8 iv[AES_BLOCK_SIZE];
 	u64 dg[2] = {};
-	u128 lengths;
+	be128 lengths;
 	u8 *tag;
 	int err;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
