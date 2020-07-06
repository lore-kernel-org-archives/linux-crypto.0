Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4C5C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 20:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522F72073E
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 20:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDSwn1IK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGFUkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 16:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgGFUkx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 16:40:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6D2C061755
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 13:40:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z15so31390129wrl.8
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 13:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y41M1YxlKMi8fy++W0D9aY498rV6BUbWxLDmFQDP1Ww=;
        b=rDSwn1IKnuGBhIb4T2tURULMieFysyKw1GeOwIVN2lR3nysIuciw+sQTU7z9idf0TL
         KuyzPdkIokA1cWCXIwL7KpgFX2qSedqEogrr2ry35B1CTmC2CcQDHNiZwrood+SnVJzO
         Ob/XM2ZhHi5XaIs2mrfyaUbYlGmR47NFnMBiXFYOFtD+k0qbugQdrLvqEkfnL5OjaiN0
         KHJlVR/sUNIqAJ8Zh8F7YIRjNKpDlq7npCkgHAgz9c75wb2XRSat6fL4Xg8YKB262k6J
         kx3M3QXRe55NlnBagRs3h+ROnc9oiBdWUlkbQZka+VZJaDSNU7gl3v8QmmOtL/+Oub6A
         oeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y41M1YxlKMi8fy++W0D9aY498rV6BUbWxLDmFQDP1Ww=;
        b=iNDck/VwB1NDdSooNOhA+23ZZ01pU1NZK5Ui8/m97vjhHZCx3bMa54X0P+kao+ZWdC
         Zy552p/rVhTxGjTi09Zp/NPvBuUgWpXXr4A9JuVA6ajVzTV783x+OyppGWSQu2Pp4q06
         t7JQ07cdi51l1+zv5Dt0xg3ZIkXh2z6wLAytW+eOtt8HbgN247bBjq66RzDKGLf4wdvz
         8EnHNvrBFwk9mP8414aea7iIqBM7/9nwDs14/5PEpDNHfdc8tWNKz4zcQCZGvv6A9NDH
         r9IXlDj3UeZsUSOTmjI6upbK5tI0UAwgvDpearmx0ksrBYrvXykYczu2lHUqK5i+Yoxm
         tD4A==
X-Gm-Message-State: AOAM531f4g2UJqXXk0YawEFtauLGPgrSmIMmlTNCDLLrzoyHX6t9pCEV
        SJ+u0wliHGi/cX53Mv0k5CY=
X-Google-Smtp-Source: ABdhPJxpitpHuHVuaRE8wWCKlHCsE9zcrppEQ6fWUfrl5SgY1Cgj1FNI7yM6xj3Cr6A2OoChI5IF/A==
X-Received: by 2002:adf:82f5:: with SMTP id 108mr49930198wrc.218.1594068051967;
        Mon, 06 Jul 2020 13:40:51 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id f17sm829053wme.14.2020.07.06.13.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:40:51 -0700 (PDT)
Date:   Mon, 6 Jul 2020 22:40:49 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Eric Biggers <ebiggers@google.com>,
        Tero Kristo <t-kristo@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH v3 06/13] crypto: sun8i-ss - permit asynchronous skcipher
 as fallback
Message-ID: <20200706204049.GA25432@Red>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-7-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630121907.24274-7-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:19:00PM +0200, Ard Biesheuvel wrote:
> Even though the sun8i-ss driver implements asynchronous versions of
> ecb(aes) and cbc(aes), the fallbacks it allocates are required to be
> synchronous. Given that SIMD based software implementations are usually
> asynchronous as well, even though they rarely complete asynchronously
> (this typically only happens in cases where the request was made from
> softirq context, while SIMD was already in use in the task context that
> it interrupted), these implementations are disregarded, and either the
> generic C version or another table based version implemented in assembler
> is selected instead.
> 
> Since falling back to synchronous AES is not only a performance issue, but
> potentially a security issue as well (due to the fact that table based AES
> is not time invariant), let's fix this, by allocating an ordinary skcipher
> as the fallback, and invoke it with the completion routine that was given
> to the outer request.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 39 ++++++++++----------
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h        |  3 +-
>  2 files changed, 22 insertions(+), 20 deletions(-)
> 

> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
> index 29c44f279112..42658b134228 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
> @@ -159,6 +159,7 @@ struct sun8i_cipher_req_ctx {
>  	unsigned int ivlen;
>  	unsigned int keylen;
>  	void *biv;
> +	struct skcipher_request fallback_req;   // keep at the end

Hello

You forgot to add it to the kerneldoc of the struct sun8i_cipher_req_ctx
otherwise:
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun8i-a83t-bananapi-m3

thanks
