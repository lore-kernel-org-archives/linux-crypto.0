Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA482C31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 14:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9276020818
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 14:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qfM7LKzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfHFOOo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 10:14:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40626 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfHFOOo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 10:14:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so76652382wmj.5
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 07:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Ei+qyr30ADMStmrXbGOvT04rXjCgtbzdychwxSklsY=;
        b=qfM7LKzgSh6i2YXOBOdCSL8777pATcpk9FYGemPv+r1YYtfmS956x9FntlmHfdoKF7
         GG2J/2r/eXojpEzUoFD0q+3avRrwSxyMu06TmYns5ZUJph8E7bjsqgeKVGchFAw1v/MF
         nk6cuBb0wjB4h8N/SIWVGyLzhTVUTayEqyl5J+0K0FSwxVQjHd7uHbp0bwI07LjcHYeo
         EdCBNrNu1PEFJJvT4bj0uXDsUY+c4eGBRpzUTqWhJhMRvfCvEsaNPfrxUKYMCJEzMdmS
         sLdgVvptmThhMOe0faHcAPowATrb/LKIRk9ou2kTfKZLoLCckyxTioxr1Otor+aJi0zm
         0qqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Ei+qyr30ADMStmrXbGOvT04rXjCgtbzdychwxSklsY=;
        b=JG+Uh+0+5EsTjZjhRKXHiIYEy2dBBT5//ou88pfr+W5P37+6Dox8hdTo+BdfeCMDEV
         MJ9cVfRZTsKn2l5QEYE8U8rr0Q89kMYSAbwR3ZAod/kymuryBiHMOudHdShSmon+Xhpb
         YymN1O/MWYTkpsd/MdxwZKpN8cOZ8uJ7qxNiPaf8iTcm8QRRn6CDgpdj8VZzLRCsueQB
         yBI+d2nn/9oMQ5XoAvavflzp165kEIkwB4u/yhmLce7wEfIHS46U01FyoCJ8GresEmqQ
         VFkYqc3JHVxHbfNd+Nc/JkmaDpDLkhuMJKTw1Zesre1f0SPBAEPrZ2xi0SQhlghsvvpC
         e4PQ==
X-Gm-Message-State: APjAAAWHgFJUHGnP5sDeotke4Pg3v3LjufDGmMCHClXgfyHQY0IEJ+ls
        wG3OXHVPzTOpynvzUduskYdOewqbGqgog+fXnhooyA==
X-Google-Smtp-Source: APXvYqyXPfryTPvihxZzIbYk3r7fAdglMfw20NzrU/a5SvSv2iBBkrQbRCSy/ZqSCxlOzNWm5GNpfURir++l23fBkvU=
X-Received: by 2002:a7b:c0d0:: with SMTP id s16mr4844505wmh.136.1565100881152;
 Tue, 06 Aug 2019 07:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
 <20190806080234.27998-3-ard.biesheuvel@linaro.org> <22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
 <CAKv+Gu_LQwtM47njiksCJL2tMx_Zv8Paoegfkah--T6Mh55u3A@mail.gmail.com> <922068a1-6123-b4b6-fe2e-d453c28c45dd@gmail.com>
In-Reply-To: <922068a1-6123-b4b6-fe2e-d453c28c45dd@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 6 Aug 2019 17:14:29 +0300
Message-ID: <CAKv+Gu8mQSb0JX5s0AuKTti+kTFUg=2mFZ+ntoYHvHpP-MDnig@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] md/dm-crypt - switch to AES library for EBOIV
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 6 Aug 2019 at 16:19, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 06/08/2019 14:17, Ard Biesheuvel wrote:
> > On Tue, 6 Aug 2019 at 13:43, Milan Broz <gmazyland@gmail.com> wrote:
> >>
> >> On 06/08/2019 10:02, Ard Biesheuvel wrote:
> >>> The EBOIV IV mode reuses the same AES encryption key that is used for
> >>> encrypting the data, and uses it to perform a single block encryption
> >>> of the byte offset to produce the IV.
> >>>
> >>> Since table-based AES is known to be susceptible to known-plaintext
> >>> attacks on the key, and given that the same key is used to encrypt
> >>> the byte offset (which is known to an attacker), we should be
> >>> careful not to permit arbitrary instantiations where the allocated
> >>> AES cipher is provided by aes-generic or other table-based drivers
> >>> that are known to be time variant and thus susceptible to this kind
> >>> of attack.
> >>>
> >>> Instead, let's switch to the new AES library, which has a D-cache
> >>> footprint that is only 1/32th of the generic AES driver, and which
> >>> contains some mitigations to reduce the timing variance even further.
> >>
> >> NACK.
> >>
> >> We discussed here that we will not limit combinations inside dm-crypt.
> >> For generic crypto API, this policy should be different, but I really
> >> do not want these IVs to be visible outside of dm-crypt.
> >>
> >> Allowing arbitrary combinations of a cipher, mode, and IV is how dm-crypt
> >> works since the beginning, and I really do not see the reason to change it.
> >>
> >> This IV mode is intended to be used for accessing old BitLocker images,
> >> so I do not care about performance much.
> >>
> >
> > Apologies for being blunt, but you are basically driving home the
> > point I made before about why the cipher API should become internal to
> > the crypto subsystem.
> >
> > Even though EBOIV is explicitly only intended for accessing old
> > BitLocker images, you prioritize non-functional properties like API
> > symmetry and tradition over sound cryptographic engineering practice,
> > even after I pointed out to you that
> > a) the way EBOIV uses the same symmetric key for two different
> > purposes is a bad idea in general, and
> > b) table based AES in particular is a hazard for this mode, since the
> > way the IV is generated is susceptible to exactly the attack that
> > table based AES is most criticized for.
> >
> > So if you insist on supporting EBOIV in combination with arbitrary
> > skciphers or AEADs (or AES on systems where crypto_alloc_cipher()
> > produces a table based AES driver), how do you intend to mitigate
> > these issues?
>  I am not going to mitigate these. We will never format new devices
> using these exotic configurations. And if user enforces it, there can be
> a reason - or it is just stupid, like using cipher_null.
> (Which is entirely insecure but very useful for testing.)
>
> The IV concept in dm-crypt is straightforward and allows many insecure
> and obscure combinations (aes-ecb-null, for example - and this is used
> for millions of chipset encrypted drivers, people used it to access through
> dmcrypt without the USB bridge.) The same applies for obscure cryptloop
> image combinations. (I would better spent time to remove cryptoloop,
> it is much worse that what we are discussing here :)
>
> So I see no reason to spend hours and hours attacks for devices
> that use crypto that is obsolete anyway (all new drives use XTS).
>
> I would like to provide way to access data on existing, maybe obsolete and insecure,
> encrypted images from foreign OSes.
>
> But all that said is meant in the isolated context of dm-crypt driver,
> if you want to provide generic API, it perhaps makes sense to enforce such a policy.
>
> I understand you want to propose more secure ways of implementing crypto,
> but then - if you decide to remove existing API I used, we can switch to something better.
> (Is there something better except AES-only lib you used?)
>
> I just disagree with adding various checks for cipher/mode/iv combinations inside dm-crypt.
> It was meant to be configurable from userspace.
>

OK, so you are using that the dm-crypt user space tools will only
allow eboiv to be instantiated in combination with cbc(aes)? If so, do
you have a problem with patch #1 as well, which just double checks
that at the kernel level. With that patch applied, we can at least
avoid having to support every combination imaginable forever, while
the discussion takes place.

In any case, if performance does not really matter, restricting
ourselves to CBC mode has the beneficial side effect that the same tfm
used for decrypting the data could be used to encrypt the IV, and you
don't need to instantiate another cipher at all. On most systems,
cbc(aes) will be provided by a time invariant driver, and even if it
is costly to invoke this in some cases, it will at least not create
any security holes.
