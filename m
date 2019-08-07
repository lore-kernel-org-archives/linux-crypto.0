Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52393C433FF
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 16:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 102BE2229C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 16:51:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C27CNwGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbfHGQvL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 12:51:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35534 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388969AbfHGQvK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 12:51:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so740166wmg.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 09:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLlvnkoDJOpHD1CGuCZk2WrcRcYWmQiL8g5My/PEJwQ=;
        b=C27CNwGsnoSNeelmpWFQZlr8wkcAgkdvU3Hzs9aFcHrmRYEEniYMeskknBvx7efAaQ
         XiMgLuWPaUwCHvwSH1DkM7aKfeDj0DXckvcJ/fRb/PUH+K6/lg8Z5AgcvA+jgjM3OOx0
         J4R7Up4G69KCzu1C8/nASD84/CiZ3v3T/tmZPQclXjUHspBXmSy3BluoxWIwNKrqN2a8
         +st5w72WVqrWTkWYXMGHKeE5o1awDG0Ul/9jEWDFj/3HRpcSdTByzZw6NK8KIsaae1yA
         /Vg9UDxi7hEawkzigrBnb58t63NbsPvxZd05lNM6cmegnk/8BHwuoAlxuXthdvl7m6Zo
         6XNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLlvnkoDJOpHD1CGuCZk2WrcRcYWmQiL8g5My/PEJwQ=;
        b=g0rYOBqeDPfKRrHtLVMws0FkXYQByugT6VjORNpH12O5BPVXyWcule9vyVm9sIl+9e
         S5ZatZf2jUVEbeTvj/QCRanA5zsAOU2l2NrZAwnb/9wE1tV0aGtxrPU2+LzIuugnD4kW
         sFV4MolNDIdVELlb7yVwHt5yWEIUVMuo1AsCZ641Xyh0Pcfljy4jHTtYabt147OX+OGr
         zKCGQxUxpKb9yQRBh5UunNnJF9/hmKOL5ob5Qb+z7LTEK6Zcu9K8mLXiGHSjfVNqYUYT
         pEQQzuOqKTbU3sIopQbl4HBBbI42W5TMeH+oKq4I5CqmsTW+7h1chQCCg1ZBJ7N2D5mo
         NdSw==
X-Gm-Message-State: APjAAAWu3NL55K+3Yfbv5PoSgr/ARZfFhedobihlfQfxV46gpLfEJt3Q
        utMKaXuZG5U+df8d5Rsd5ppyQucNECruKwwnYTJgdQ==
X-Google-Smtp-Source: APXvYqyoZLamGM81i+1/jrzt8tRzizsZWAAVQqEuQGvvvYeqpSdZxletHIoteY8Jx+9ePYi3j13se1p0wyqrl3CuNzU=
X-Received: by 2002:a7b:c0d0:: with SMTP id s16mr783690wmh.136.1565196666754;
 Wed, 07 Aug 2019 09:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com> <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 7 Aug 2019 19:50:54 +0300
Message-ID: <CAKv+Gu_OLV5m_b1mXUQYNaHkCywNJe45jW+sx6k3uR-bWSWepQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(trim cc)

On Wed, 7 Aug 2019 at 19:14, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Wednesday, August 7, 2019 5:40 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; ebiggers@kernel.org;
> > agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com; gmazyland@gmail.com
> > Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> >
> > On Wed, 7 Aug 2019 at 16:52, Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > >
> > > Ard,
> > >
> > > > -----Original Message-----
> > > > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > Sent: Wednesday, August 7, 2019 3:17 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; ebiggers@kernel.org;
> > > > agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com; gmazyland@gmail.com
> > > > Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> > > >
> > > > On Wed, 7 Aug 2019 at 10:28, Pascal Van Leeuwen
> > > > <pvanleeuwen@verimatrix.com> wrote:
> > > > >
> > > > > Ard,
> > > > >
> > > > > I've actually been following this discussion with some interest, as it has
> > > > > some relevance for some of the things I am doing at the moment as well.
> > > > >
> > > > > For example, for my CTS implementation I need to crypt one or two
> > > > > seperate blocks and for the inside-secure driver I sometimes need to do
> > > > > some single crypto block precomputes. (the XTS driver additionally
> > > > > also already did such a single block encrypt for the tweak, also using
> > > > > a seperate (non-sk)cipher instance - very similar to your IV case)
> > > > >
> > > > > Long story short, the current approach is to allocate a seperate
> > > > > cipher instance so you can conveniently do crypto_cipher_en/decrypt_one.
> > > > > (it would be nice to have a matching crypto_skcipher_en/decrypt_one
> > > > > function available from the crypto API for these purposes?)
> > > > > But if I understand you correctly, you may end up with an insecure
> > > > > table-based implementation if you do that. Not what I want :-(
> > > > >
> > > >
> > > > Table based AES is known to be vulnerable to plaintext attacks on the
> > > > key, since each byte of the input xor'ed with the key is used as an
> > > > index for doing Sbox lookups, and so with enough samples, there is an
> > > > exploitable statistical correlation between the response time and the
> > > > key.
> > > >
> > > > So in the context of EBOIV, where the user might specify a SIMD based
> > > > time invariant skcipher, it would be really bad if the known plaintext
> > > > encryptions of the byte offsets that occur with the *same* key would
> > > > happen with a different cipher that is allocated implicitly and ends
> > > > up being fulfilled by, e.g., aes-generic, since in that case, each
> > > > block en/decryption is preceded by a single, time-variant AES
> > > > invocation with an easily guessable input.
> > > >
> > > No need to tell me, doing crypto has been my dayjob for nearly 18.5 years
> > > now :-)
> > >
> >
> > I didn't mean to imply that you don't know your stuff :-) I am just
> > reiterating the EBOIV issue so we can compare it to the issue you are
> > bringing up
> >
> Fair enough :-)
>
> > > > In your case, we are not dealing with known plaintext attacks,
> > > >
> > > Since this is XTS, which is used for disk encryption, I would argue
> > > we do! For the tweak encryption, the sector number is known plaintext,
> > > same as for EBOIV. Also, you may be able to control data being written
> > > to the disk encrypted, either directly or indirectly.
> > > OK, part of the data into the CTS encryption will be previous ciphertext,
> > > but that may be just 1 byte with the rest being the known plaintext.
> > >
> >
> > The tweak encryption uses a dedicated key, so leaking it does not have
> > the same impact as it does in the EBOIV case.
> >
> Well ... yes and no. The spec defines them as seperately controllable -
> deviating from the original XEX definition - but in most practicle use cases
> I've seen, the same key is used for both, as having 2 keys just increases
> key  storage requirements and does not actually improve effective security
> (of the algorithm itself, implementation peculiarities like this one aside
> :-), as  XEX has been proven secure using a single key. And the security
> proof for XTS actually builds on that while using 2 keys deviates from it.
>

Regardless of all of that, the Linux implementation does in fact use
separate keys for tweak and data. That is why the key sizes are double
wrt ordinary AES, i.e., 32 bytes for XTS-AES-128 and 64 bytes for
XTS-AES-256.

> > And a plaintext attack
> > on the data encryption part of XTS involves knowing the value of the
> > tweak as well, so you'd have to successfully attack the tweak before
> > you can attack the data. So while your point is valid, it's definitely
> > less broken than EBOIV.
> >
> For the data encryption, you have a very valid point (which I admit I
> completely overlooked). For the tweak encryption itself, however ...
>
> But even if you would use 2 independent keys, if you first break the
> tweak key, the tweak becomes known plaintext and you can then continue
> breaking the data encryption key :-) It's a bit harder, but far from
> impossible.
>

Agreed.

> > > > and the
> > > > higher latency of h/w accelerated crypto makes me less worried that
> > > > the final, user observable latency would strongly correlate the way
> > > > aes-generic in isolation does.
> > > >
> > > If that latency is constant - which it usually is - then it doesn't
> > > really matter for correlation, it just filters out.
> > >
> >
> > Due to the asynchronous nature of the driver, we'll usually be calling
> > into the OS scheduler after queuing one or perhaps several blocks for
> > processing by the hardware. Even if the processing time is fixed, the
> > time it takes for the OS to respond to the completion IRQ and process
> > the output is unlikely to correlate the way a table based software
> > implementation does, especially if several blocks can be in flight at
> > the same time.
> >
> Ok, I didn't know the details of that ... still, don't underestimate
> the power of statistical analysis. You'd think a SoC would generate
> enough power or EMI noise to hide your puny little crypto accelerator's
> contribution to that - well, think again. You'd be surprised by what
> the guys in our attack lab manage to achieve.
>
> > But note that we are basically in agreement here: falling back to
> > table based AES is undesirable, but for EBOIV it is just much worse
> > than for other modes.
> >
> Much worse than *certain* other modes. It's definitely something that
> always needs to be in the back of your mind as long as there is some
> possibility you end up with a not-so-secure implementation.
>

Again, agreed, which also happens to be the reason why I am arguing
that the bare cipher API should not be exposed outside of the crypto
subsystem at all.

> > > > > However, in many cases there would actually be a very good reason
> > > > > NOT to want to use the main skcipher for this. As that is some
> > > > > hardware accelerator with terrible latency that you wouldn't want
> > > > > to use to process just one cipher block. For that, you want to have
> > > > > some SW implementation that is efficient on a single block instead.
> > > > >
> > > >
> > > > Indeed. Note that for EBOIV, such performance concerns are deemed
> > > > irrelevant, but it is an issue in the general case.
> > > >
> > > Yes, my interest was purely in the generic case.
> > >
> > > > > In my humble opinion, such insecure table based implementations just
> > > > > shouldn't exist at all - you can always do better, possibly at the
> > > > > expense of some performance degradation. Or you should at least have
> > > > > some flag  available to specify you have some security requirements
> > > > > and such an implementation is not an acceptable response.
> > > > >
> > > >
> > > > We did some work to reduce the time variance of AES: there is the
> > > > aes-ti driver, and there is now also the AES library, which is known
> > > > to be slower than aes-generic, but does include some mitigations for
> > > > cache timing attacks.
> > > >
> > > > Other than that, I have little to offer, given that the performance vs
> > > > security tradeoffs were decided long before security became a thing
> > > > like it is today, and so removing aes-generic is not an option,
> > > > especially since the scalar alternatives we have are not truly time
> > > > invariant either.
> > > >
> > > Replacing aes-generic with a truly time-invariant implementation could
> > > be an option.
> >
> > If you can find a truly time-invariant C implementation of AES that
> > isn't orders of magnitude slower than aes-generic, I'm sure we can
> > merge it.
> >
> I guess the "orders of a magnitude slower" thing is the catch here :-)
>
> But from my perspective, crypto performance is irrelevant if it is not
> secure at all. (after all, it's crypto, so the *intent* is security)
> Of course there's gradation in security levels, but timing-attack
> resistance really is the lowest of the lowest IMHO.
>

I am not disagreeing with that at all. This is actually one of the
main reasons for my work on refactoring the way AES is being used in
the kernel: for historical reasons, many drivers have a hard
dependency on CONFIG_CRYPTO_AES, and pull in the aes-generic driver,
and so at the moment, it is not possible to disable it. Going forward,
I'd like to refine this further so that aes-generic can be replaced by
aes-ti.

> > > Or selecting aes-generic only if some (new) "allow_insecure"
> > > flag is set on the cipher request. (Obviously, you want to default to
> > > secure, not insecure. Speaking as someone who earns his living doing
> > > security :-)
> > >
> >
> > We all do. But we all have different use cases to worry about, and
> > different experiences and backgrounds :-)
> >
> > The main problem is that banning aes-generic is a bit too rigorous
> > imo. It highly depends on whether there is known plaintext and whether
> > there are observable latencies in the first place.
> >
> Agree on the banning part, but it would be good if you could be *certain*
> somehow that you don't end up with it. For certain use cases, a (much)
> slower, but more, secure implementation may be the better choice. As you
> already discovered by yourself.
>

See above. In the future, I'd like to ensure that aes-generic does not
have to be built into the core kernel (which will be possible once
existing core kernel users that require AES switch to the AES library
or stop using AES altogether). That way, the module can be blacklisted
or omitted from the kernel build altogether (as well as other modules
that reimplement that same algorithm using arch specific assembly
code)

> > > (Disclaimer: I do not know anything about the aes-generic implementation,
> > > I'm just taking your word for it that it is not secure (enough) ...)
> > >
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
