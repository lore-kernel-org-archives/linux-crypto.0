Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13432C31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 09:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D380020848
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 09:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WYpWGUjm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfFQJPO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 05:15:14 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44768 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfFQJPN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 05:15:13 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so19510118iob.11
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 02:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BBlAq8Hgbk1PhfyJUI7i/pP6QgmDuBb0PZdu9I+mRE8=;
        b=WYpWGUjmF/b5U2DhXFfHaq8D+8s5go2/jFOJkLk2uW4kq/Fv7IjgWsCIoP43Tynt7H
         2blO6czII4FOD+tpOnQXimX+P037O7oXWstll/m5VLtgOnz5kU/beNS0K5g4+DUssMf8
         v127qxFMTsWiy5evx4nnTswUoRAa8OusVmK004aPXfXLNTQ29ioi4+qt3LdgKW5v7Adt
         CrF2/V2eQnw6tmt8vvq7hN31gUyYz8pwsXZajaxSBLTYz5WfRkyePZV4qr+pLxZWYGlC
         dBDm8qNvcoQd4zGwUNIu2drZ6m41Tg2gN6jU6vUjKCRfjbvfnQhz8dfskKQb57+eBbpc
         tY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BBlAq8Hgbk1PhfyJUI7i/pP6QgmDuBb0PZdu9I+mRE8=;
        b=KO/JyJhgPkKXb46/L0KuDEt+Gx6+1GCrBLNF63LZ132JVM8Bjjt/bSoyPgI20H9wPC
         Rnm299J5dNDMd8HmQDEn6gne3F3Lie2gcPqkecBvm/IEoUo58gq7X6wtcX59soiNaQf6
         dXJ5TRXy9pZbGEx0YQ5icqUUYQ9I2sYQqdY99HZJPrcuQfjTl+bkLYb9D6jSGw4KmtNQ
         ZKMMbxk1E7iIAtQq/In5iwivalbhaGwhDVFOaL7GbAJcM+pJePvqRFQE2jNrg/JCOxLN
         Xujfz15rus1FY+yupOvZ4Fi1mX+A+mYdXFncZKd+rqB2NMnWj8NnsHhrUEh4Ql8GgVXQ
         mXyQ==
X-Gm-Message-State: APjAAAWXm6hk1xMOV8gv3PWOPDoCa+dVqZq9vLHXu9OLt80LUsRSXp7r
        q/6DtenL2Mieyv/Kw29id/2ik96Yo0nUWUWINL5Z1g==
X-Google-Smtp-Source: APXvYqxHcte7o9+S4aNU6gOiMoSXJgqAwijNG58b3jo5O5B7NSygezT1xkWpPBvKULdZoH6xNXgeQQY7neDGSv8dDwY=
X-Received: by 2002:a02:3308:: with SMTP id c8mr14821917jae.103.1560762912862;
 Mon, 17 Jun 2019 02:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
In-Reply-To: <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 11:15:01 +0200
Message-ID: <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Jun 2019 at 10:52, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> On Sun, Jun 16, 2019 at 11:44 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > [+Cc dm-devel and linux-fscrypt]
> >
> > On Fri, Jun 14, 2019 at 10:34:01AM +0200, Ard Biesheuvel wrote:
> > > This series is presented as an RFC for a couple of reasons:
> > > - it is only build tested
> > > - it is unclear whether this is the right way to move away from the use of
> > >   bare ciphers in non-crypto code
> > > - we haven't really discussed whether moving away from the use of bare ciphers
> > >   in non-crypto code is a goal we agree on
> > >
> > > This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
> > > where the digest size of the hash must be a valid key length for the cipher.
> > > The setkey() operation takes the hash of the input key, and sets into the
> > > cipher as the encryption key. Digest operations accept input up to the
> > > block size of the cipher, and perform a single block encryption operation to
> > > produce the ESSIV output.
> ...
> > I agree that moving away from bare block ciphers is generally a good idea.  For
> > fscrypt I'm fine with moving ESSIV into the crypto API, though I'm not sure a
> > shash template is the best approach.  Did you also consider making it a skcipher
> > template so that users can do e.g. "essiv(cbc(aes),sha256,aes)"?  That would
> > simplify things much more on the fscrypt side, since then all the ESSIV-related
> > code would go away entirely except for changing the string "cbc(aes)" to
> > "essiv(cbc(aes),sha256,aes)".
>
> I will also add that going the skcipher route rather than shash will
> allow hardware tfm providers like CryptoCell that can do the ESSIV
> part in hardware implement that as a single API call and/or hardware
> invocation flow.
> For those system that benefit from hardware providers this can be beneficial.
>

Ah yes, thanks for reminding me. There was some debate in the past
about this, but I don't remember the details.

I think implementing essiv() as a skcipher template is indeed going to
be the best approach, I will look into that.
