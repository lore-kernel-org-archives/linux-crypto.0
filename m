Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57FCC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 06:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiI3GKI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 02:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiI3GJ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 02:09:58 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BF75FC4
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 23:09:40 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe9DK-00A52C-J3; Fri, 30 Sep 2022 16:09:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 14:09:34 +0800
Date:   Fri, 30 Sep 2022 14:09:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Walleij <linusw@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: crypto: ixp4xx - Fix sparse warnings
Message-ID: <YzaIHqpGR60bQMt0@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes a number of trivial sparse warnings in ixp4xx.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index c2845857e3dd..8459a2c78423 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -421,7 +421,7 @@ static void one_packet(dma_addr_t phys)
 		break;
 	case CTL_FLAG_GEN_REVAES:
 		ctx = crypto_tfm_ctx(crypt->data.tfm);
-		*(u32 *)ctx->decrypt.npe_ctx &= cpu_to_be32(~CIPH_ENCR);
+		*(__be32 *)ctx->decrypt.npe_ctx &= cpu_to_be32(~CIPH_ENCR);
 		if (atomic_dec_and_test(&ctx->configuring))
 			complete(&ctx->completion);
 		break;
@@ -721,7 +721,7 @@ static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 	crypt->init_len = init_len;
 	crypt->ctl_flags |= CTL_FLAG_GEN_ICV;
 
-	buf->next = 0;
+	buf->next = NULL;
 	buf->buf_len = HMAC_PAD_BLOCKLEN;
 	buf->pkt_len = 0;
 	buf->phys_addr = pad_phys;
@@ -752,7 +752,7 @@ static int setup_auth(struct crypto_tfm *tfm, int encrypt, unsigned int authsize
 #ifndef __ARMEB__
 	cfgword ^= 0xAA000000; /* change the "byte swap" flags */
 #endif
-	*(u32 *)cinfo = cpu_to_be32(cfgword);
+	*(__be32 *)cinfo = cpu_to_be32(cfgword);
 	cinfo += sizeof(cfgword);
 
 	/* write ICV to cryptinfo */
@@ -789,7 +789,7 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	if (!crypt)
 		return -EAGAIN;
 
-	*(u32 *)dir->npe_ctx |= cpu_to_be32(CIPH_ENCR);
+	*(__be32 *)dir->npe_ctx |= cpu_to_be32(CIPH_ENCR);
 
 	crypt->data.tfm = tfm;
 	crypt->crypt_offs = 0;
@@ -847,7 +847,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt, const u8 *key,
 			return err;
 	}
 	/* write cfg word to cryptinfo */
-	*(u32 *)cinfo = cpu_to_be32(cipher_cfg);
+	*(__be32 *)cinfo = cpu_to_be32(cipher_cfg);
 	cinfo += sizeof(cipher_cfg);
 
 	/* write cipher key to cryptinfo */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
