Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F374BC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E8E2178F
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKHIiM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:38:12 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57997 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfKHIiM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:38:12 -0500
X-Originating-IP: 86.206.246.123
Received: from localhost (lfbn-tou-1-421-123.w86-206.abo.wanadoo.fr [86.206.246.123])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id A147CE0018;
        Fri,  8 Nov 2019 08:38:10 +0000 (UTC)
Date:   Fri, 8 Nov 2019 09:38:10 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH] crypto: inside-secure - Fixed authenc w/ (3)DES fails on
 Macchiatobin
Message-ID: <20191108083810.GB111259@kwain>
References: <1573199165-8279-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1573199165-8279-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Nov 08, 2019 at 08:46:05AM +0100, Pascal van Leeuwen wrote:
> Fixed 2 copy-paste mistakes made during commit 13a1bb93f7b1c9 ("crypto:
> inside-secure - Fixed warnings on inconsistent byte order handling")
> that caused authenc w/ (3)DES to consistently fail on Macchiatobin (but
> strangely work fine on x86+FPGA??).
> Now fully tested on both platforms.

Can you add a Fixes: tag?

Thanks!
Antoine

> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 98f9fc6..c029956 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -405,7 +405,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  
>  	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
>  		for (i = 0; i < keys.enckeylen / sizeof(u32); i++) {
> -			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
> +			if (le32_to_cpu(ctx->key[i]) !=
> +			    ((u32 *)keys.enckey)[i]) {
>  				ctx->base.needs_inv = true;
>  				break;
>  			}
> @@ -459,7 +460,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  
>  	/* Now copy the keys into the context */
>  	for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
> -		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
> +		ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
>  	ctx->key_len = keys.enckeylen;
>  
>  	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
