Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C870BC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ADDE20673
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbfFFGhd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:37:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37922 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGhd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:37:33 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYm1g-0006bn-NT; Thu, 06 Jun 2019 14:37:28 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYm1c-0003k2-At; Thu, 06 Jun 2019 14:37:24 +0800
Date:   Thu, 6 Jun 2019 14:37:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Message-ID: <20190606063724.n77z7gaf32tmyxng@gondor.apana.org.au>
References: <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
 <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
 <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 30, 2019 at 04:31:09PM +0200, Ard Biesheuvel wrote:
>
> This might work:
>
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index c0ece44f303b..3d313d2a279a 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -1661,7 +1661,8 @@ static int aead_decrypt(struct aead_request *req)
>   * allocate and map the skcipher extended descriptor for skcipher
>   */
>  static struct skcipher_edesc *skcipher_edesc_alloc(struct
> skcipher_request *req,
> -                                                  int desc_bytes)
> +                                                  int desc_bytes,
> +                                                  u8 const *input_iv)
>  {
>         struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>         struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
> @@ -1745,7 +1746,7 @@ static struct skcipher_edesc
> *skcipher_edesc_alloc(struct skcipher_request *req,
>         /* Make sure IV is located in a DMAable area */
>         if (ivsize) {
>                 iv = (u8 *)edesc->hw_desc + desc_bytes + sec4_sg_bytes;
> -               memcpy(iv, req->iv, ivsize);
> +               memcpy(iv, input_iv, ivsize);
> 
>                 iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_TO_DEVICE);
>                 if (dma_mapping_error(jrdev, iv_dma)) {

Hi Ard:

I presume you will be submitting this patch at some point?  When
you do please base it on top of your other one which I'm about to
merge.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
