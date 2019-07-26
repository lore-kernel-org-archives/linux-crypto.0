Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2408C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9145022ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGZMdJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:33:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55857 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGZMdJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:33:09 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 519CE60015;
        Fri, 26 Jul 2019 12:33:06 +0000 (UTC)
Date:   Fri, 26 Jul 2019 14:33:05 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Message-ID: <20190726123305.GD3235@kwain>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 05, 2019 at 08:49:23AM +0200, Pascal van Leeuwen wrote:
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Could you add a commit message?

> -		/* H/W capabilities selection */
> -		val = EIP197_FUNCTION_RSVD;
> -		val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
> -		val |= EIP197_PROTOCOL_ENCRYPT_HASH | EIP197_PROTOCOL_HASH_DECRYPT;
> -		val |= EIP197_ALG_DES_ECB | EIP197_ALG_DES_CBC;
> -		val |= EIP197_ALG_3DES_ECB | EIP197_ALG_3DES_CBC;
> -		val |= EIP197_ALG_AES_ECB | EIP197_ALG_AES_CBC;
> -		val |= EIP197_ALG_MD5 | EIP197_ALG_HMAC_MD5;
> -		val |= EIP197_ALG_SHA1 | EIP197_ALG_HMAC_SHA1;
> -		val |= EIP197_ALG_SHA2 | EIP197_ALG_HMAC_SHA2;
> -		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
> +		/* H/W capabilities selection: just enable everything */
> +		writel(EIP197_FUNCTION_ALL,
> +		       EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));

This should be in a separate patch. I'm also not sure about it, as
controlling exactly what algs are enabled in the h/w could prevent
misconfiguration issues in the control descriptors.

> @@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
>  				    u32 length)
> -	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> +	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {

I think it's better for maintenance and readability to have something
like:

  if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC ||
      ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD)

> +struct safexcel_alg_template safexcel_alg_ctr_aes = {
> +	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,

Same comment as in patch 1 about the .engines member of the struct.

> +	.alg.skcipher = {
> +		.setkey = safexcel_skcipher_aesctr_setkey,
> +		.encrypt = safexcel_ctr_aes_encrypt,
> +		.decrypt = safexcel_ctr_aes_decrypt,
> +		/* Add 4 to include the 4 byte nonce! */
> +		.min_keysize = AES_MIN_KEY_SIZE + 4,
> +		.max_keysize = AES_MAX_KEY_SIZE + 4,

You could use CTR_RFC3686_NONCE_SIZE here (maybe in other places in the
patch as well).

> +		.ivsize = 8,

And CTR_RFC3686_IV_SIZE here.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
