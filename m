Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48005ECDE3D
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 18:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A2F32086E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 18:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYBl9sA5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A2F32086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbeJTCfV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Oct 2018 22:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbeJTCfV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 22:35:21 -0400
Received: from gmail.com (unknown [104.132.51.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9FB2086E;
        Fri, 19 Oct 2018 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539973687;
        bh=Lic+bmBwgTZYCKOk4vb2DxF8sAEEHd55Yyu/Acg0Dqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QYBl9sA5TbLQ6NUL8laDFUU2UDZXdulDFHgXVkXaCizSdbWb84WEwJLnVmeFdcLJr
         /Ihsxu9kSN6z/CTU85alYwMK+TdUJKZ44tcY+YkkIuMLMnF/3Y5z4xqAobOO67wjHe
         JZKnxDqXhaVH2K9wal9izNTRH51Zj6vRBfGIM5YY=
Date:   Fri, 19 Oct 2018 11:28:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kaiser <gkaiser@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Michael Halcrow <mhalcrow@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v2 04/12] crypto: chacha - add XChaCha12 support
Message-ID: <20181019182804.GA246441@gmail.com>
References: <20181015175424.97147-1-ebiggers@kernel.org>
 <20181015175424.97147-5-ebiggers@kernel.org>
 <CAKv+Gu_wVmnEND3MGTG7bqqynbBqyzmE_gTmqZfrT551_n9Hmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_wVmnEND3MGTG7bqqynbBqyzmE_gTmqZfrT551_n9Hmw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181019182805.17kL2GdcRLLEVvBexUwOLfi08Fof6okJmmtwfjZ802M@z>

Hi Ard,

On Fri, Oct 19, 2018 at 10:34:41PM +0800, Ard Biesheuvel wrote:
> > diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
> > index ae79e9983c72f..3d261f5cd156d 100644
> > --- a/include/crypto/chacha.h
> > +++ b/include/crypto/chacha.h
> > @@ -5,6 +5,11 @@
> >   * XChaCha extends ChaCha's nonce to 192 bits, while provably retaining ChaCha's
> >   * security.  Here they share the same key size, tfm context, and setkey
> >   * function; only their IV size and encrypt/decrypt function differ.
> > + *
> > + * The ChaCha paper specifies 20, 12, and 8-round variants.  In general, it is
> > + * recommended to use the 20-round variant ChaCha20.  However, the other
> > + * variants can be needed in some performance-sensitive scenarios.  The generic
> > + * ChaCha code currently allows only the 20 and 12-round variants.
> >   */
> >
> >  #ifndef _CRYPTO_CHACHA_H
> > @@ -39,6 +44,8 @@ void crypto_chacha_init(u32 *state, struct chacha_ctx *ctx, u8 *iv);
> >
> >  int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
> >                            unsigned int keysize);
> > +int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
> > +                          unsigned int keysize);
> >
> >  int crypto_chacha_crypt(struct skcipher_request *req);
> >  int crypto_xchacha_crypt(struct skcipher_request *req);
> > diff --git a/lib/chacha.c b/lib/chacha.c
> > index 0a2c2e5b7b84d..c4d69a83fcd2d 100644
> > --- a/lib/chacha.c
> > +++ b/lib/chacha.c
> > @@ -21,7 +21,7 @@ static void chacha_permute(u32 *x, int nrounds)
> >         int i;
> >
> >         /* whitelist the allowed round counts */
> > -       BUG_ON(nrounds != 20);
> > +       BUG_ON(nrounds != 20 && nrounds != 12);
> >
> 
> I didn't spot this until this patch, but BUG_ON() may bring down the
> kernel, and so it should really only be used as a last resort. (i.e.,
> if this is called from non-process context things may explode rather
> painfully)
> 
> I didn't look at the entire file [which is a bit cumbersome while
> reviewing incremental changes like this] and so I don't really have
> another suggestion right now, but please try to come up with something
> better if you can.
> 

I'll change it to WARN_ON_ONCE(), I guess.  I do still want it to be very noisy
if something fishy is going on with the round count.

- Eric
