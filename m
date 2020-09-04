Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CED2C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66239206C9
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 08:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgIDI1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:27:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42654 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgIDI1K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 04:27:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kE73p-0001OD-Ti; Fri, 04 Sep 2020 18:27:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2020 18:27:05 +1000
Date:   Fri, 4 Sep 2020 18:27:05 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] crypto: ux500 - Fix sparse endianness warnings
Message-ID: <20200904082705.GA1139@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a couple of sparse endianness warnings in the
ux500 driver.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index e64e764bb035..c3adeb2e5823 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irqreturn.h>
+#include <linux/kernel.h>
 #include <linux/klist.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -91,17 +92,6 @@ struct cryp_ctx {
 
 static struct cryp_driver_data driver_data;
 
-/**
- * uint8p_to_uint32_be - 4*uint8 to uint32 big endian
- * @in: Data to convert.
- */
-static inline u32 uint8p_to_uint32_be(u8 *in)
-{
-	u32 *data = (u32 *)in;
-
-	return cpu_to_be32p(data);
-}
-
 /**
  * swap_bits_in_byte - mirror the bits in a byte
  * @b: the byte to be mirrored
@@ -284,6 +274,7 @@ static int cfg_ivs(struct cryp_device_data *device_data, struct cryp_ctx *ctx)
 	int i;
 	int status = 0;
 	int num_of_regs = ctx->blocksize / 8;
+	__be32 *civ = (__be32 *)ctx->iv;
 	u32 iv[AES_BLOCK_SIZE / 4];
 
 	dev_dbg(device_data->dev, "[%s]", __func__);
@@ -300,7 +291,7 @@ static int cfg_ivs(struct cryp_device_data *device_data, struct cryp_ctx *ctx)
 	}
 
 	for (i = 0; i < ctx->blocksize / 4; i++)
-		iv[i] = uint8p_to_uint32_be(ctx->iv + i*4);
+		iv[i] = be32_to_cpup(civ + i);
 
 	for (i = 0; i < num_of_regs; i++) {
 		status = cfg_iv(device_data, iv[i*2], iv[i*2+1],
@@ -339,23 +330,24 @@ static int cfg_keys(struct cryp_ctx *ctx)
 	int i;
 	int num_of_regs = ctx->keylen / 8;
 	u32 swapped_key[CRYP_MAX_KEY_SIZE / 4];
+	__be32 *ckey = (__be32 *)ctx->key;
 	int cryp_error = 0;
 
 	dev_dbg(ctx->device->dev, "[%s]", __func__);
 
 	if (mode_is_aes(ctx->config.algomode)) {
-		swap_words_in_key_and_bits_in_byte((u8 *)ctx->key,
+		swap_words_in_key_and_bits_in_byte((u8 *)ckey,
 						   (u8 *)swapped_key,
 						   ctx->keylen);
 	} else {
 		for (i = 0; i < ctx->keylen / 4; i++)
-			swapped_key[i] = uint8p_to_uint32_be(ctx->key + i*4);
+			swapped_key[i] = be32_to_cpup(ckey + i);
 	}
 
 	for (i = 0; i < num_of_regs; i++) {
 		cryp_error = set_key(ctx->device,
-				     *(((u32 *)swapped_key)+i*2),
-				     *(((u32 *)swapped_key)+i*2+1),
+				     swapped_key[i * 2],
+				     swapped_key[i * 2 + 1],
 				     (enum cryp_key_reg_index) i);
 
 		if (cryp_error != 0) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
