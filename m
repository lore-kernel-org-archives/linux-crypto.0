Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA9AC31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 10:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFB320861
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 10:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JyHeUQCg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfFQK6x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 06:58:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36495 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfFQK6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 06:58:52 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so20211936ioh.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 03:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3uIDgkFwtV6fC3eHfwnFIXovpwkgGVEyNZtxQ+vCmvg=;
        b=JyHeUQCgQDBcUhjSLdwEL8Non5+SLMigJ0PDAlIIuhknO4X5oUbxBkiZYVpmXLa4gA
         Buz67cfsk+9bw8Vv1Pm5nOcAqCW6SZaPP5nCPy86Dz+AbXsP/11/qja9qmhFADgnCGZ9
         5KaURNH578Xhj8iACk3jVQaeW4BK2PHzfCUtJExY0Y5n24EtmG3tBFbzu13xsGAHwniZ
         34caVsTHGlNRMRDUIq27W+Y+yUnVRrWQlsvBWRJ+FtYZBLk0iBCKjaeLuIYpghgVUfT8
         dg4GNkfLH1Q/FEc6yQl0wmx0RNymYEhvTvDwRY1GcQjoivZHwwJwS9OcGD1b23nGF8f6
         ge+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3uIDgkFwtV6fC3eHfwnFIXovpwkgGVEyNZtxQ+vCmvg=;
        b=GJZieC7gwKfBZF6j2+HolPyX9WIC3WoQYsurkoIYIYXGR/pusxs6GjFjwuZfaqYi3J
         y/Ajn/N+r6GouNpDG+dFOSGbh4nHWQfHiDlEwDH7KQMri2UEgXzmqPaYzCjmV3skXuzs
         Z6eP6dGw8BwhH5GiSTYmIHKa+ubazZapWNl3l2G38GxtiZpYQ7B6Kg5OFnQCBP2W1rWx
         6kt8yVhSL3jNMrmVl8NZ9SahYvzagjVJ/6jXitYOH5Lo2S3lo+A/UhzkO7U9voxFxDld
         lP7w6iMJEv7GB3oVAOgkokAuQi95Dra1a2rTesnWQ70vNSfSmJrNBMGJ1VEFD/aLb5Ff
         KgPg==
X-Gm-Message-State: APjAAAXNI03OQz6H91rKSYKgW74IGjwF0HgWL+w/willm3uuBHEd2/Sj
        p9efiTRmvHVU6rysI7UkbFnMHhKiIPoqeg6nT6TBYbsw9Yc=
X-Google-Smtp-Source: APXvYqyxdE7l3lJcOdchpE8rrs9ZQMQ4kYYp6o01m0KkPFK5LIm/xPhYSHQJwPgx1cUDNx+W0ofU7Kz/el3U4ETPYto=
X-Received: by 2002:a02:c90d:: with SMTP id t13mr61091069jao.62.1560769131916;
 Mon, 17 Jun 2019 03:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com> <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
In-Reply-To: <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 12:58:40 +0200
Message-ID: <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Jun 2019 at 12:39, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 17/06/2019 11:15, Ard Biesheuvel wrote:
> >> I will also add that going the skcipher route rather than shash will
> >> allow hardware tfm providers like CryptoCell that can do the ESSIV
> >> part in hardware implement that as a single API call and/or hardware
> >> invocation flow.
> >> For those system that benefit from hardware providers this can be beneficial.
> >>
> >
> > Ah yes, thanks for reminding me. There was some debate in the past
> > about this, but I don't remember the details.
> >
> > I think implementing essiv() as a skcipher template is indeed going to
> > be the best approach, I will look into that.
>
> For ESSIV (that is de-facto standard now), I think there is no problem
> to move it to crypto API.
>
> The problem is with some other IV generators in dm-crypt.
>
> Some do a lot of more work than just IV (it is hackish, it can modify data, this applies
> for loop AES "lmk" and compatible TrueCrypt "tcw" IV implementations).
>
> For these I would strongly say it should remain "hacked" inside dm-crypt only
> (it is unusable for anything else than disk encryption and should not be visible outside).
>
> Moreover, it is purely legacy code - we provide it for users can access old systems only.
>
> If you end with rewriting all IVs as templates, I think it is not a good idea.
>
> If it is only about ESSIV, and patch for dm-crypt is simple, it is a reasonable approach.
>
> (The same applies for simple dmcryp IVs like "plain" "plain64", "plain64be and "benbi" that
> are just linear IVs in various encoded variants.)
>

Agreed.

I am mostly only interested in ensuring that the bare 'cipher'
interface is no longer used outside of the crypto subsystem itself.
Since ESSIV is the only one using that, ESSIV is the only one I intend
to change.
