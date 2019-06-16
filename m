Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D75C31E50
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 19:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F8D120862
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 19:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AVFyW+HO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFPTNN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 15:13:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36512 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfFPTNN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 15:13:13 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so16699415ioh.3
        for <linux-crypto@vger.kernel.org>; Sun, 16 Jun 2019 12:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=saUshM2iv2FhtdSgUUkXIgTrskoGJu0Ya5EbuRmU4C8=;
        b=AVFyW+HOIC/dDzrlp6oyi565VgYUCIlE1FrmGeeEWn/+HOG49dqLCMEGLSNsBA7tRr
         jaRXDJaL+cFwGxkDv3+sb4bPFcnLic922GupQ5/bglCOFB0kH7x7ZibqhqjV2gKUkiJf
         HjxVM95nwDns58YfY7DlKQMfwihX2fmB8J8iug8VHeK/XOP0i3pn46BhipxHQ9rSSTDU
         5R+D5sN1CnYMiIHkoqkM47R9qJc63gKC9rUvP+Ql5JnYVr0dcsHCoteTcvdBRk8uaRa4
         rhYJYEFLjb3vTrChcI5CzYUM/jpP4NGgef2G+RZoHZOsVGoDNCekvUWRENwsEz1vOnI+
         gxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=saUshM2iv2FhtdSgUUkXIgTrskoGJu0Ya5EbuRmU4C8=;
        b=uUy4brzvQ8kAofT0mEVyzveeeowVfdReGdxZpTu9Pn+lLfnKZQ+HmDjgK0Fft0Cg3+
         kpc/3Hgv4hBFequsX3Mqw5RuWCmZjnDKkqku4A3CzEzQ07WJai5tfse552zC8jsb9u3S
         f7o1EgRkLjdlO4pojYPnwvLo45mtTctcXllWaJzTJYtUAubUQrUhONuIb5f4IeVGwaqe
         UZApKQDbVYp8browfs8/b5T865w5jO5syhBbNQu9hPZMWxJoUyLLSW8GQS5OT4P0tl5/
         4d2EnQ+lCr0RM/EfvGovigzU3r6VHUJs+GSfEIQQLkPVz/sPkHY+xtyguiAByJNWDZUX
         q44A==
X-Gm-Message-State: APjAAAVxZdvTxhKqRd+zWVrn+Kricaxsp12kQp2xFbDORy+4hthy7NyE
        lgZAaXW3+PWBC2RgnGyLTxZgaecSQrurdaRFMq/g2w==
X-Google-Smtp-Source: APXvYqzdRuBylfGxZV2fAUINljLY0ZoCJUaBkiU4gjdAJj4xQb7wKXFKBT192juh48giR7xMv6l0L1lcojs8nIkwvHM=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr12989202iom.283.1560712392550;
 Sun, 16 Jun 2019 12:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org> <9cd635ec-970b-bd1b-59f4-1a07395e69a0@gmail.com>
In-Reply-To: <9cd635ec-970b-bd1b-59f4-1a07395e69a0@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 16 Jun 2019 21:13:01 +0200
Message-ID: <CAKv+Gu88tYOmO=8mi7yP2oj=x_SOB_o7D9jo6v_3xfbUxY2R1A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 15 Jun 2019 at 20:19, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 14/06/2019 10:34, Ard Biesheuvel wrote:
> > This series is presented as an RFC for a couple of reasons:
> > - it is only build tested
> > - it is unclear whether this is the right way to move away from the use of
> >   bare ciphers in non-crypto code
> > - we haven't really discussed whether moving away from the use of bare ciphers
> >   in non-crypto code is a goal we agree on
> >
> > This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
> > where the digest size of the hash must be a valid key length for the cipher.
> > The setkey() operation takes the hash of the input key, and sets into the
> > cipher as the encryption key. Digest operations accept input up to the
> > block size of the cipher, and perform a single block encryption operation to
> > produce the ESSIV output.
> >
> > This matches what both users of ESSIV in the kernel do, and so it is proposed
> > as a replacement for those, in patches #2 and #3.
> >
> > As for the discussion: the code is untested, so it is presented for discussion
> > only. I'd like to understand whether we agree that phasing out the bare cipher
> > interface from non-crypto code is a good idea, and whether this approach is
> > suitable for fscrypt and dm-crypt.
>
> If you want some discussion, it would be very helpful if you cc device-mapper list
> to reach dm-crypt developers. Please add at least dm-devel list.
>
> Just a few comments:
>
>  - ESSIV is useful only for CBC mode. I wish we move to some better mode
> in the future instead of cementing CBC use... But if it helps people
> to actually use unpredictable IV for CBC, it is the right approach.
> (yes, I know XTS has own problems as well... but IMO that should be the default
> for sector/fs-block encryption these days :)
>

I agree that XTS should be preferred. But for some reason, the
kernel's XTS implementation does not support ciphertext stealing (as
opposed to, e.g., OpenSSL), and so CBC ended up being used for
encrypting the filenames in fscrypt.

I am trying to serve both customers with the same solution here,
regardless of whether it is the recommended approach or not.

> - I do not think there is a problem if ESSIV moves to crypto API,
> but there it is presented as a hash... It is really just an IV generator.
>

True. But we don't have the proper abstractions to make this
distinction, and so a shash is currently the best match.

> > - wiring up some essiv(x,y) combinations into the testing framework. I wonder
> >   if anything other than essiv(aes,sha256) makes sense.
>
> In cryptsetup testsuite, we test serpent and twofish ciphers at least, but in
> reality, essiv(aes,sha256) is the most used combination.
> If it makes sense, I can run some tests with dm-crypt and this patchset.
>

OK, that is helpful, thanks. Mind if I ping you once we reach a state
where we need to test for correctness? At the moment, this is still
mostly a discussion piece.
