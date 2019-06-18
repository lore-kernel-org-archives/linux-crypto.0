Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43137C31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 13:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3C9206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 13:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/DsCxTT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFRNMl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 09:12:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36575 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRNMk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 09:12:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so5843689wrs.3;
        Tue, 18 Jun 2019 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7FALWQ6cOh3JsG038fbVz+yiqqz0f79O0ClChfodEQs=;
        b=Q/DsCxTTpuF0/+fAH5Ad7SkE1PEf7KzB0fJmiSFe3Xjj6DuqgZNMeHGkeInINWD7cJ
         Ikx6ys+AQneaMr5n0KwcWnkfDF5TIxTviUkX6TyvNYtHd9KYqkI7bTSr+LvMGZZyjx2W
         2XcDJ4eWGtV/3vi+lK6IMdcjIV/k61XxTIETIq4nloIr254y6uadVtTEjrFn3a9oJ5Zl
         ouXDH8nA7WssQ3LS7eJSiMwDMvY5ELgndTHzN/aANZi3r+XuE1NkLuE7ZE/bNWfND0uH
         5rYsO63g3CRDprdEw7yH9nzGzIeQ4BxagJkD1FsZj+sittr3Dn+TBrqUsJrH5pbz+HYP
         EmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7FALWQ6cOh3JsG038fbVz+yiqqz0f79O0ClChfodEQs=;
        b=ebVSpR1cnq7niqyWVA1LJk7sabuV6OKzmhmP4MvDXT8/XB4jIWhyjZDzCpPK3htxqv
         bdz9AmkyHoFxfU2MgcmV5J3XtgEsx0HtR/50LwM/R/UlzMFkoHallRRcx5VK2GToEMRq
         p82fM3pKZobkWvWey7uX1Iw9kj3dAnduJlFp4FB+X3/qs7rhmokty0FqKSJI4USSc2CS
         ++9BuzvQbU1exPyHnSlDF4jchZkKDoh5WpU6fa6YaGbf4jmhCBloaReBHOD+cBIOtQYM
         qi1CGL7kQdIHzLnoCswUXq9A/2JaqSXltJsW31D6BMDWBtEVGSJac9uBNVjAnmhURfXm
         JyZA==
X-Gm-Message-State: APjAAAXYV6RMacEZCM/YyZfphRuIdFzR4qAbyJ0rYZhEFh33OrxEZUrI
        ivHB2+827jHUrqGCIgaHE8c=
X-Google-Smtp-Source: APXvYqy1MQ2zlBqmr3KXBZUn3NaMXrsL66L7Sz4lxFaGkx9NZeR8KUFacbmwTj+GSE3ktkFEUI2o6w==
X-Received: by 2002:adf:eecf:: with SMTP id a15mr7408693wrp.354.1560863557790;
        Tue, 18 Jun 2019 06:12:37 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id f2sm21287538wrq.48.2019.06.18.06.12.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 06:12:37 -0700 (PDT)
Date:   Tue, 18 Jun 2019 15:12:34 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun4i-ss - reduce stack usage
Message-ID: <20190618131234.GA8474@Red>
References: <20190617132538.2759714-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617132538.2759714-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 03:25:17PM +0200, Arnd Bergmann wrote:
> After the latest addition, the stack usage of sun4i_ss_cipher_poll
> grew beyond the warning limit when KASAN is enabled:
> 
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:118:12: error: stack frame size of 1152 bytes in function 'sun4i_ss_cipher_poll' [-Werror,-Wframe-larger-than=]
> static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
> 
> Reduce it in three ways:
> 
> - split out the new code into a separate function so its stack
>   usage can overlap that of the sun4i_ss_opti_poll() code path
> - mark both special cases as noinline_for_stack, which should
>   ideally result in a tail call that frees the rest of the
>   stack
> - move the buf and obuf variables into the code blocks in
>   which they are used.
> 
> The three separate functions now use 144, 640 and 304 bytes of kernel
> stack, respectively.
> 
> Fixes: 0ae1f46c55f8 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 47 +++++++++++++++--------
>  1 file changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> index 7b0c42882830..4ab14d58e85b 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -12,7 +12,7 @@
>   */
>  #include "sun4i-ss.h"
>  
> -static int sun4i_ss_opti_poll(struct skcipher_request *areq)
> +static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
>  {
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
>  	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
> @@ -114,6 +114,29 @@ static int sun4i_ss_opti_poll(struct skcipher_request *areq)
>  	return err;
>  }
>  
> +
> +static int noinline_for_stack sun4i_ss_cipher_poll_fallback(struct skcipher_request *areq)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
> +	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
> +	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
> +	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, op->fallback_tfm);
> +	int err;
> +
> +	skcipher_request_set_sync_tfm(subreq, op->fallback_tfm);
> +	skcipher_request_set_callback(subreq, areq->base.flags, NULL,
> +				      NULL);
> +	skcipher_request_set_crypt(subreq, areq->src, areq->dst,
> +				   areq->cryptlen, areq->iv);
> +	if (ctx->mode & SS_DECRYPTION)
> +		err = crypto_skcipher_decrypt(subreq);
> +	else
> +		err = crypto_skcipher_encrypt(subreq);
> +	skcipher_request_zero(subreq);
> +
> +	return err;
> +}
> +
>  /* Generic function that support SG with size not multiple of 4 */
>  static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  {
> @@ -140,8 +163,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  	unsigned int todo;
>  	struct sg_mapping_iter mi, mo;
>  	unsigned int oi, oo;	/* offset for in and out */
> -	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
> -	char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
>  	unsigned int ob = 0;	/* offset in buf */
>  	unsigned int obo = 0;	/* offset in bufo*/
>  	unsigned int obl = 0;	/* length of data in bufo */
> @@ -178,20 +199,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  	if (no_chunk == 1 && !need_fallback)
>  		return sun4i_ss_opti_poll(areq);
>  
> -	if (need_fallback) {
> -		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, op->fallback_tfm);
> -		skcipher_request_set_sync_tfm(subreq, op->fallback_tfm);
> -		skcipher_request_set_callback(subreq, areq->base.flags, NULL,
> -					      NULL);
> -		skcipher_request_set_crypt(subreq, areq->src, areq->dst,
> -					   areq->cryptlen, areq->iv);
> -		if (ctx->mode & SS_DECRYPTION)
> -			err = crypto_skcipher_decrypt(subreq);
> -		else
> -			err = crypto_skcipher_encrypt(subreq);
> -		skcipher_request_zero(subreq);
> -		return err;
> -	}
> +	if (need_fallback)
> +		return sun4i_ss_cipher_poll_fallback(areq);
>  
>  	spin_lock_irqsave(&ss->slock, flags);
>  
> @@ -224,6 +233,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  
>  	while (oleft) {
>  		if (ileft) {
> +			char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
> +
>  			/*
>  			 * todo is the number of consecutive 4byte word that we
>  			 * can read from current SG
> @@ -281,6 +292,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
>  				oo = 0;
>  			}
>  		} else {
> +			char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
> +
>  			/*
>  			 * read obl bytes in bufo, we read at maximum for
>  			 * emptying the device
> -- 
> 2.20.0
> 

Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
