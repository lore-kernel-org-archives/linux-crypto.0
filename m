Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B76C17440
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 06:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611E321882
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 06:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qzu+cLoM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfKIGgc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 01:36:32 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:42555 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfKIGgb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 01:36:31 -0500
Received: by mail-wr1-f49.google.com with SMTP id a15so9314959wrf.9
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 22:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bRbMBT5BGFdZ7hjiEjksJO2VlNdac8E3y7B9gDKQGiA=;
        b=Qzu+cLoMCEoaiH/wuRIoRdKso65PS5Ou76cODP0bFSdGr6WdoW+qR4s0GwOuMzwOAw
         6zPHXmbhnyQlXbAVbylI1PpLhI2l0bx8bCo2n4CSW56VsEVW4RU/hQajhvOk3M8Vk78D
         9lveO47Ph5iUiG5PKagCMjGD2b1j0NW3t0+n36qG2gSE6mTFatuOtceaxlOpo9L+gH7y
         GZ25VexgavIcj/4r21NsI0ebUr9lRenNYIIIxvcyJtouAEIsBuUDID6QygmMHz8y0jyG
         cuWRTZWl7OXDeHY9HJSNJIo9lqYppZw5w4FnEB+LVXIzNSKSSzpdGodYpMApE+qayjDE
         5+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bRbMBT5BGFdZ7hjiEjksJO2VlNdac8E3y7B9gDKQGiA=;
        b=fZkZvcxQy3aB4tnPeBXpWbeswNK1+S/LO1h7/+pOsyI8v2IAzwTum/tklCGMn8lnXb
         C7WQNZbaXrJ5h2PywolfJDsnBmx9xjXy1dQlCm0q+X2etZhr8BRbGo8MT6ZWPfxUfa1e
         pS6V/Lo0hp2va6zI/cG3/p28lBtRsIr+no7FZSQIBbEgoxyh8FShQz7qIggqClvU5V/P
         s2YOyh4OndOazGF1/+PfTAIiOUN4ghtnki7Kr+yKr2h2HGZYYOsFKb1I2ZqFwaZKASC7
         HJWSCpw/aN6AId/ldT61htNESglgGZQWJheTLtQayD7H6NVuNDbyG5aZhsGQKmCnvIJ0
         lYkA==
X-Gm-Message-State: APjAAAVgbX12FbB314omNaLkYdsSwtyimJ1DtF017dEoKevSBAGMFQsn
        pF7AZyGKSb5xnqRZ/+P5PIEn+yt49YvVi9BaFHQ=
X-Google-Smtp-Source: APXvYqx38PFiauwAnXlk/XAaoHI8lkz+ln3UnDLwuCaxkR6YvyjpwDnJBBSrO9e26oJzA6lIj1+o8+V7UyAIub6s5MY=
X-Received: by 2002:a5d:4803:: with SMTP id l3mr11870708wrq.381.1573281388025;
 Fri, 08 Nov 2019 22:36:28 -0800 (PST)
MIME-Version: 1.0
References: <XnsAB01A0BBA9FB8fgotham@195.159.176.226> <20191109050353.GD23325@mit.edu>
In-Reply-To: <20191109050353.GD23325@mit.edu>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sat, 9 Nov 2019 14:36:14 +0800
Message-ID: <CACXcFmmFH0Bg3O98XOt-vaS4=fwDQxfnuUtgHZxp7hDswAdfTQ@mail.gmail.com>
Subject: Re: Remove PRNG from Linux Kernel
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Frederick Gotham <cauldwell.thomas@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Theodore Y. Ts'o <tytso@mit.edu> wrote:

> On Fri, Nov 08, 2019 at 03:48:02PM -0000, Frederick Gotham wrote:
> >
> > There cannot be any software-based psuedo-random number generators on my
> > device, and so far I've removed three of them:
> >
> > (1) The built-in PRNG inside OpenSSL
> > (2) The Intel RDRAND engine inside OpenSSL
> > (3) The simulator library that goes with the tpm2tss engine for OpenSSL
> > (tcti-mssim)
>
> Why must there not be a "pseudo-random number generator"?  Who made
> that rule?  What is the goal of not allowing such a thing?

I assume the reason is that you have very high security requirements.

If so, replacing PRNGs with something hardware-based may be a
reasonable idea. However, that does not seem entirely clear, given
that well-implemented & well-seeded PRNGs have been shown to
be adequate for crypto purposes, e.g. in Schneier et al's Yarrow
paper.

> Note that in general, most people would not refer to such things as a
> "PRNG", but a Cryptographic Random Number Generator (CRNG).  And in
> general, it's considered a very good thing put a CRNG in front of a
> hardware random number generator for several reasons:
>
>   (1) Hardware random number generators, including TPM-based RNG's are
>       slow, and
>
>   (2) using a hardware RNG directly means you are investing all of
>       your trust in the hardware RNG --- and hardware RNG have been known to
>       have their share of insecurities.

Yes, putting a mixer in front of an HRNG is almost always a good idea.
Since Linux has a built-in mixer, you might as well use that.

> What makes you so sure that the you can trust the implementation of
> the TPM's random number generator?
>
> Far better is to mix multiple entropy sources together, so that if one
> happens to be insecure, or has failed in some way, you still will have
> protection from the other entropy sources.
>
> > I need to remove the PRNG from the Linux kernel and replace it with something
> > that interfaces directly with the TPM2 chip.

Far better, I'd say to arrange for the chip to reseed the random(4) driver.

If you really don't want to ever use any CRNG, then either remove the
/dev/urandom interface or make it a link to /dev/random. I do not
think that is either necessary or a good idea, but it is possible & does
not require messing with the kernel.

> > Has this been done before?
>
> As far as I know, no, because most people would consider this a
> Really, REALLY, **REALLY** bad idea.  Note that the TPM2 chip has a
> very slow connection to the main CPU, and there are many applications
> which will need session keys at a high rate (for example, opening
> multiple https connections when browsing a web page), for which the
> TPM2 would be totally unsuited.
>
> If you really want to use the TPM2 chip, there are userspace libraries
> which will access it directly, and you can see how slow and painful
> using the TPM chip really would be....

I'd say using almost anything as your sole entropy source would be
a serious error if security requirements are high. You want at least
two sources both because that leaves you safe if one fails and
because, even if someone discovers some flaw that makes it easy
to attack one source, the presence of the other makes the attack
extremely difficult.

The random(4) driver does collect entropy from interrupts etc.
and, depending on what your machine will be doing, that may
well be all the second source you need.

If you have RDRAND, that would be a fine second source. If
your board has an unused sound card equivalent, then
Denker's Turbid would be another. I'd use either or both if
available.
