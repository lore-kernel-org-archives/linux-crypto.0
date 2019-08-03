Return-Path: <SRS0=Wt+L=V7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518C4C433FF
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Aug 2019 07:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4570206C1
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Aug 2019 07:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wHwlfmzW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfHCHg5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Aug 2019 03:36:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35065 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfHCHg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Aug 2019 03:36:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so79406489wrm.2
        for <linux-crypto@vger.kernel.org>; Sat, 03 Aug 2019 00:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=An8x8wOSPqi5lMEbM0lGEptSaInz+eauyvu67l7VMQM=;
        b=wHwlfmzW1gh05xb3up6bhuDJtGl0ShuJ+bdWBNfLCp8DXO31Zr2BqqUPa+yri2uW0B
         2NbWBjOxM9dD2xsI/5T4QaQOgfSP/zVVw8bufZc1RCE8cqc0CQVJBRDbYRIG1ejQvbXh
         CmOZAlrkyWY2qasVr2XuiB/WjK5Qf4HMSzcdNGi4/fgHfpSMoBXv/Jo3YyHkvhJYYuzX
         HnlmpmcjvwLRzPFGl+r26liiFYwXemWFIcuPkiRnxkXAHnqMeGcAPtc8yZ8gEWCa/Y/z
         FFN0yYy58LLG4e9Ig+qr8ZDCixGKyj3blLIEqHscyUXNsTZJBj/cc9DIhqTx6uC0WzDB
         mwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=An8x8wOSPqi5lMEbM0lGEptSaInz+eauyvu67l7VMQM=;
        b=oUZQZasZ3grFzbQ6CDGQbIeUlLTTIHA0bcIPFkn9dzm0A8G0GHmDpcqP/ULHkk2x0B
         lktsRfMWVg8VEHo+JI28uNcUiQN/1IrHIortfhN9WFDeQGd1DG/H07cvIFih3PxYF8C3
         a99U5oKbRKgAwGE/aGJvzzenq4tZcjHlf6O+Rt6vh3uAd1Nr5efeg0cXGiuBAywMw/wf
         0ZR6fLbgYz9IqrZ0zJjH0A7XpY2KiT7KC4Q75jEQYp4p0I94maUPIejUZbwsSAZL2n7Y
         DUDqj3J/ycLqVtA/decluh50mvLx1GPEXpuNOOwYJs7tSWd8q5F8WmCVaCDaX7I7xc4d
         b0aA==
X-Gm-Message-State: APjAAAWPRRS8bD3OwcnbJQIXkAqW0AbF3fBTY8dw/ZS/6lAHlbZDivSn
        McwX6DLhGsc13ZVL3zk2qPlLLTHT4p80zG+092sEoQ==
X-Google-Smtp-Source: APXvYqx3Ws7aJOrJvumZinbBKEWsyCeSAzY7R1Rd1jZRw8ZpwVXzm6F+XQGJUIbwVayBtHfpRZ1eWFoLdQNzR+/f+q0=
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr14016374wrs.93.1564817814955;
 Sat, 03 Aug 2019 00:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190704183017.31570-2-ard.biesheuvel@linaro.org>
 <20190726043117.GA654@gondor.apana.org.au> <CAKv+Gu_Pir7uU4h6GQfh2my2Fu-j2AGPLWNZKzc9_iG6n4xJNA@mail.gmail.com>
 <20190802035515.GA15758@gondor.apana.org.au>
In-Reply-To: <20190802035515.GA15758@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 3 Aug 2019 10:36:44 +0300
Message-ID: <CAKv+Gu_a-tpc4+b4aopGZxHizkOgnqkFMCTzeF0uFo5iXXf24Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/7] crypto: essiv - create wrapper template for ESSIV generation
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

On Fri, 2 Aug 2019 at 06:55, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jul 26, 2019 at 12:00:20PM +0300, Ard Biesheuvel wrote:
> >
> > For Y and Z, it is not straightforward either: since the crypto API
> > permits the use of driver names in addition to the plain CRA names,
> > we'd have to infer from the first parameter which cipher is being
> > used.
>
> We don't really permit that.  It might work but it is certainly not
> guaranteed to work.  The only thing we guarantee is that the
> algorithm name and the canonical driver name will work.  For example,
> with gcm you can either say gcm(aes) or gcm_base(drv_name1, drv_name2).
>
> Anything else is not supported.
>

Understood. But that is not the problem.

The problem is that we want to instantiate a cipher based on the
cipher algorithm that is encapsulated by the skcipher, and how that is
encoded in the name is not straightforward.

To use your GCM analogy: gcm_base(ctr-ppc-spe, ghash-generic) is a
supported aead identifier, but  there is nothing in the name that
identifies the skcipher as one that encapsulates AES.

> So I would envisage something similar for essiv where essiv just has
> U, X and Y (as you said that U and X are independent) while you can
> then have an essiv_base that spells everything out in detail.
>

That might be a useful enhancement by itself, but it does not fix the
issue above. The only way to instantiate the same cipher as the one
encapsulated by "cbc-ppc-spe" is to instantiate the latter, parse the
cipher name and pass it to crypto_alloc_cipher()

> Also, do we allow anything other than HMAC for X? If not then that
> should be encoded either into the name by dropping the hmac in the
> algorithm name and adding it through the driver name, or by checking
> for it in the template creation function.
>
> What I'd like to achieve is a state where we support only what is
> currently supported and no more.
>

Yeah, that makes sense. But we have h/w drivers that instantiate
authenc(X,Y) in its entirety, and passing those driver names is
something that is supported today, so we can't just remove that.

> > > Because this is legacy stuff, I don't want it to support any more
> > > than what is currently being supported by dm-crypt.
> > >
> > > Similary for the skcipher case, given
> > >
> > >         essiv(cbc(X),Y,Z)
> > >
> > > is it ever possible for X != Y? If not then we should just make the
> > > algorithm name essiv(X,Z).
> > >
> >
> > Same problem. We'd need to instantiate the skcipher and parse the cra_name.
> >
> > Perhaps we should introduce a crypto API call that infers the cra_name
> > from a cra_driver_name?
>
> You don't need to do that.  Just copy whatever gcm does in its
> creation function when you invoke it as gcm_base.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
