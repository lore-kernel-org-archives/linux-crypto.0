Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD3DC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80860206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XFkdapvj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfHSOO3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:14:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40935 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfHSOO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 10:14:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id c3so8907776wrd.7
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 07:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wac/8K0PlB5YqvgpI9XB84WnEjzGgiNR49Px3uNmKW4=;
        b=XFkdapvjB9ydQEoU7RWQdtlXojOwik5hizdLU9r2m8gd/IMDBuB1WcWbX6GxKduW06
         eqfg/JzDDnFlhRAb3Zjg1PMHT/2+lIZDLxwtPzakUBcxeeih7FVPqv2b2dSq1hwIJ2qk
         IBMbtHQ4TCDt1a8B6opSINSLFpvToXarInaeq3ntBbVSmSMmAw+jz0Z1J6Q8opDqmOn2
         JCYj4LcgzpcebgU4w4n//XHtfjKUV/DwL+rFvZ/6La2TcOVHb59BvhcNvgMqWiiuLS7S
         bCUN0+cxlt5dQ+AP15mSrdAbsMRm9m3tpLEZCnAsihJhYy6R6f4XotpJfNYDS1d1ZHkI
         oICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wac/8K0PlB5YqvgpI9XB84WnEjzGgiNR49Px3uNmKW4=;
        b=kCF55Lao4XhPGSzfmzPGZn5Ez8ZoKv+FwmAoVBJTbf1t2EouZTJHL4GEAi4yAhS133
         Cfjn5Kba7eQKcM3SIn1yMsetaCGwLmFeRMic/ol42zcPi6II1FD3ULBtMwGloKgdIdpl
         BJ//j8c+sYZjZoT0aY03AgyDcpEixlQlFP4TKFYMspsc60RW0dE739waIUtt9BrzL55l
         Tw74/UbLGAqACuaqDjOXN2dl77mx5I2KTotpiE5E25oEMOO8cnVEYiI5cgDkyVojNOUr
         EVKZ99Ix5vM5Mahl6yG7G63JdqgRfCsIpKV5j0kM+Q7tlisMCS6ZsDE5kQ2IvdmqkkSf
         2tAw==
X-Gm-Message-State: APjAAAWvqc+uxYaO9x5uZIkXPXsEvda8VsSDdHY2Wq1w2xiylJd1hpNF
        0iZ1gwbQa/U+FeI1qZsiPT4Eu0eyihgAEvABeOMt0g==
X-Google-Smtp-Source: APXvYqyBE/UN01L8CYsSaZNoiACjd0jezpOPjy9k/djrhLklovSa5FgtQ4n+jR3Kahaa/J3jbjg98BO3QOEQVhK/O3w=
X-Received: by 2002:a5d:5450:: with SMTP id w16mr14907929wrv.174.1566224066287;
 Mon, 19 Aug 2019 07:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
 <20190815192858.28125-2-ard.biesheuvel@linaro.org> <20190819063218.GA31821@gondor.apana.org.au>
In-Reply-To: <20190819063218.GA31821@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 19 Aug 2019 17:14:25 +0300
Message-ID: <CAKv+Gu9Zcaq5gygGtgmf5f4L6U6sBDd0CVAzrBydjiLDenyrag@mail.gmail.com>
Subject: Re: [PATCH v12 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 19 Aug 2019 at 09:32, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 15, 2019 at 10:28:55PM +0300, Ard Biesheuvel wrote:
> >
> > +     /* Synchronous hash, e.g., "sha256" */
> > +     ictx->hash = crypto_alloc_shash(shash_name, 0, 0);
> > +     if (IS_ERR(ictx->hash)) {
> > +             err = PTR_ERR(ictx->hash);
> > +             goto out_drop_skcipher;
> > +     }
>
> Holding a reference to this algorithm for the life-time of the
> instance is not nice.  How about just doing a lookup as you were
> doing before with crypto_alg_mod_lookup and getting the cra_name
> from that?
>

OK, but it should be the cra_driver_name not the cra_name. Otherwise,
allocating essiv(cbc(aes),sha256-generic) may end up using a different
implementation of sha256, which would be bad.
