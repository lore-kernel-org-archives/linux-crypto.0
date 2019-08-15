Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C48FC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 11:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E128C2083B
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 11:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbfHOLhh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 07:37:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57156 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfHOLhh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 07:37:37 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hyE4U-0002nS-L7; Thu, 15 Aug 2019 21:37:34 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hyE4S-0007FI-Oq; Thu, 15 Aug 2019 21:37:32 +1000
Date:   Thu, 15 Aug 2019 21:37:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v4 06/30] crypto: caam/des - switch to new verification
 routines
Message-ID: <20190815113732.GB27723@gondor.apana.org.au>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
 <20190805170037.31330-7-ard.biesheuvel@linaro.org>
 <20190815045421.GA24765@gondor.apana.org.au>
 <CAKv+Gu93e1T0nzZYgzfvMdzQ6x=3WKHBTQ1vx7n+UHecQLVS6Q@mail.gmail.com>
 <CAKv+Gu8aX_QQ4WuydX6pu+GZeRzi8_vZ24Dp0dJddpNLfcTxfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8aX_QQ4WuydX6pu+GZeRzi8_vZ24Dp0dJddpNLfcTxfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 15, 2019 at 08:43:38AM +0300, Ard Biesheuvel wrote:
>
> So I will end up with
> 
> static inline int verify_skcipher_des_key(struct crypto_skcipher *tfm,
>   const u8 *key)
> static inline int verify_skcipher_des3_key(struct crypto_skcipher *tfm,
>    const u8 *key)
> static inline int verify_ablkcipher_des_key(struct crypto_skcipher *tfm,
>     const u8 *key)
> static inline int verify_ablkcipher_des3_key(struct crypto_skcipher *tfm,
>      const u8 *key)
> static inline int verify_aead_des3_key(struct crypto_aead *tfm, const u8 *key,
>        int keylen)
> static inline int verify_aead_des_key(struct crypto_aead *tfm, const u8 *key,
>       int keylen)
> 
> Is that what you had in mind?

Yes and hopefully we will be able to get rid of ablkcipher at some
point.

As a rule we want to make the job as easy as possible for driver
authors so we should leave the burden of such trivial things with
the API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
