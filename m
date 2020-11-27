Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52979C63777
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 06:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13080221FF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 06:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392563AbgK0GXf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 01:23:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33402 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389406AbgK0GXe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 01:23:34 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiXAH-0000tA-P8; Fri, 27 Nov 2020 17:23:30 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2020 17:23:29 +1100
Date:   Fri, 27 Nov 2020 17:23:29 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        George Cherian <gcherian@marvell.com>
Subject: [PATCH] crypto: cpt - Fix sparse warnings in cptpf
Message-ID: <20201127062329.GA6708@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a few sparse warnings that were missed in the
last round.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 24d63bdc5dd2..711b1acdd4e0 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -244,7 +244,7 @@ static int do_cpt_init(struct cpt_device *cpt, struct microcode *mcode)
 
 struct ucode_header {
 	u8 version[CPT_UCODE_VERSION_SZ];
-	u32 code_length;
+	__be32 code_length;
 	u32 data_length;
 	u64 sram_address;
 };
@@ -288,10 +288,10 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 
 	/* Byte swap 64-bit */
 	for (j = 0; j < (mcode->code_size / 8); j++)
-		((u64 *)mcode->code)[j] = cpu_to_be64(((u64 *)mcode->code)[j]);
+		((__be64 *)mcode->code)[j] = cpu_to_be64(((u64 *)mcode->code)[j]);
 	/*  MC needs 16-bit swap */
 	for (j = 0; j < (mcode->code_size / 2); j++)
-		((u16 *)mcode->code)[j] = cpu_to_be16(((u16 *)mcode->code)[j]);
+		((__be16 *)mcode->code)[j] = cpu_to_be16(((u16 *)mcode->code)[j]);
 
 	dev_dbg(dev, "mcode->code_size = %u\n", mcode->code_size);
 	dev_dbg(dev, "mcode->is_ae = %u\n", mcode->is_ae);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
