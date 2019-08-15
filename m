Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91583C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 04:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A576208C2
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 04:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="biAYEOQh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfHOE7r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 00:59:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56098 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfHOE7r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 00:59:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so250431wmf.5
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2019 21:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7r3GrsKm+2UK/xPfP/njs6YmgftMt6txBYE2dN+ouo=;
        b=biAYEOQhtytUlyJpOiXnvcSnR1/7WJ1nuhw+ACmwN7VWYcOabJ+0N6FwIk+o7Z3R3v
         /TEYgrwFC18O2PnT7sb7CH0ANCHfPu3fyUT4Xc/N7V4dugNfHi64+T6++WE5I/kizwdG
         hcbcqWE06u9C2S34QcPjTlULJhF8uf1GDy5a6x3OhpYWTAofcZDvl+6Y827E3vgb6gJL
         kchw4gC/kygPZNUJCJyTrwH+VJn0bVBQfnpgWxaDGoEThwbVXHyqyRNZbtc7sO2g3ToK
         QZzuyIjJJO4VgggVBgCnSTJEqhFD2LF5lE37dhFxSioDmydW/euBlOLxgFQrzdmsyLy9
         QfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7r3GrsKm+2UK/xPfP/njs6YmgftMt6txBYE2dN+ouo=;
        b=Ho645oE89j4mPjPfRRszdRIUJBNGIu3bZFyTlqT6KjEdhmhfoNH7a65cDKvFdBisT0
         guMSKV/6MAUmcKLGTfbdp4fMTGNnqWxk+qq5MEG9IL6diP0LNS7k9eTFV1dDwloULAC4
         P/2z/gd8sKzwAiw8jtBYhmJcBpPsrHZjAPpJiEmwpWlCjiunthXxcQV6nh9OdGHTsRzV
         CyK7rw0c/yda/mOwWuag52IUjkhMF+xCZOaZHiJUcM+J0Wip7X55WkIQZCSdD55oQorZ
         j1nyOia5MMzG8TEsPJmHhU3WV1USBfos/9Et/MqctG3M280LHeed/h8H/65OHWWgbS4q
         YhFA==
X-Gm-Message-State: APjAAAWsyoHkvl6yGEzpw8xwtaI2z0si75wcwPQsM8eqyOVfh5qhSm+L
        KPri93VmJmv+uo0b0l/ic7kQ/iNgu53F2ZOWxCdXiA==
X-Google-Smtp-Source: APXvYqxGcPdaMer0ONFG2I2gsJ4PSUhsr7GYEUw376kmI/NVQmX1WUdUJmFOqfEcyjlzXmrI51RmTQ21n7xDGi0W5Z4=
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr635593wmi.61.1565845185178;
 Wed, 14 Aug 2019 21:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
In-Reply-To: <20190815023734.GB23782@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 07:59:34 +0300
Message-ID: <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for ESSIV generation
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

On Thu, 15 Aug 2019 at 05:37, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 14, 2019 at 07:37:43PM +0300, Ard Biesheuvel wrote:
> >
> > +     /* Block cipher, e.g., "aes" */
> > +     crypto_set_spawn(&ictx->essiv_cipher_spawn, inst);
> > +     err = crypto_grab_spawn(&ictx->essiv_cipher_spawn, essiv_cipher_name,
> > +                             CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_MASK);
> > +     if (err)
> > +             goto out_drop_skcipher;
> > +     essiv_cipher_alg = ictx->essiv_cipher_spawn.alg;
> > +
> > +     /* Synchronous hash, e.g., "sha256" */
> > +     _hash_alg = crypto_alg_mod_lookup(shash_name,
> > +                                       CRYPTO_ALG_TYPE_SHASH,
> > +                                       CRYPTO_ALG_TYPE_MASK);
> > +     if (IS_ERR(_hash_alg)) {
> > +             err = PTR_ERR(_hash_alg);
> > +             goto out_drop_essiv_cipher;
> > +     }
> > +     hash_alg = __crypto_shash_alg(_hash_alg);
> > +     err = crypto_init_shash_spawn(&ictx->hash_spawn, hash_alg, inst);
> > +     if (err)
> > +             goto out_put_hash;
>
> I wouldn't use spawns for these two algorithms.  The point of
> spawns is mainly to serve as a notification channel so we can
> tear down the top-level instance when a better underlying spawn
> implementation is added to the system.
>
> For these two algorithms, we don't really care about their performance
> to do such a tear-down since they only operate on small pieces of
> data.
>
> Therefore just keep things simple and allocate them in the tfm
> init function.
>

So how do I ensure that the cipher and shash are actually loaded at
create() time, and that they are still loaded at TFM init time?
