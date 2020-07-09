Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140C9C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 09:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4AEA206E2
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594287745;
	bh=ZAjHkJLONygrWg/ikVKkkavc6Qm9bZ5dhpu1WnwpGLI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EiqZoaQRb9K+h2HDAFBT//8v8W1KhlUZ3bwQfprNQ2bTlJCyRGx2X1W7ZfikecHUK
	 611CZqkLnQff0LW/603NHg9zSScT5IoRunX4nxgzVyeLW4R272L69AtjrN6dSuNTal
	 XmKAXoSjnLvNRfQijO/YiXSA4R3aCU/F97UYgsoo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgGIJmZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 05:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgGIJmX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 05:42:23 -0400
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6B9206E2
        for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2020 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594287743;
        bh=ZAjHkJLONygrWg/ikVKkkavc6Qm9bZ5dhpu1WnwpGLI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=v9wtveuRLQkb1oIc7t08YbQibPkSgfIUjWHkV+DRIzsF7excgLLGMAhM1sZNHOkjS
         b/+U4s0XaBFO8qENEhoGdsg2cjOEU86kzr/tcH67REPdOG+/qeEJUfgU/0xN9isYwz
         DsRzQ7Y1GMTQW4bqVj7qENInNBpc0rk0W92PbKYE=
Received: by mail-oo1-f47.google.com with SMTP id a9so232170oof.12
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2020 02:42:23 -0700 (PDT)
X-Gm-Message-State: AOAM530btDQNWppN948NBx8+76I6Dbe1pNIHW37j7yoUZbbd2rw8M35O
        f5fiCa8ViffbH42GO1vKvQF+6j+5ETiCsJwynbY=
X-Google-Smtp-Source: ABdhPJxulkyQApz6Yec++bZLN+74EQ4N2SFTUM6oGD5PBcsgw7pIXPhfsvyoH36mW3LCFp3/RZNEuiRx5HsiCs31iNQ=
X-Received: by 2002:a4a:9210:: with SMTP id f16mr54527547ooh.13.1594287742521;
 Thu, 09 Jul 2020 02:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au> <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
 <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
 <8e974767-7aa6-c644-8562-445a90206f47@nxp.com> <20200709004728.GA4492@gondor.apana.org.au>
 <036c2f99-7f9c-28ae-02bf-99e5fbdedba2@nxp.com>
In-Reply-To: <036c2f99-7f9c-28ae-02bf-99e5fbdedba2@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 9 Jul 2020 12:42:11 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHOhVXcN4EdmDyhrLdYP5joedtLiXbUpHQzre_Eo_Um+w@mail.gmail.com>
Message-ID: <CAMj1kXHOhVXcN4EdmDyhrLdYP5joedtLiXbUpHQzre_Eo_Um+w@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 9 Jul 2020 at 11:53, Horia Geant=C4=83 <horia.geanta@nxp.com> wrote=
:
>
> On 7/9/2020 3:47 AM, Herbert Xu wrote:
> > On Wed, Jul 08, 2020 at 07:24:08PM +0300, Horia Geant=C4=83 wrote:
> >>
> >> I think the commit message should be updated to reflect this logic:
> >> indeed, caam's implementation of ecb(arc4) is broken,
> >> but instead of fixing it, crypto API-based ecb(arc4)
> >> is removed completely from the kernel (hence from caam driver)
> >> due to skcipher limitations in terms of handling the keystream.
> >
> > Actually that's not quite true.  The reason I create this patch
> > in the first place is to remove this limitation from skcipher.
> >
> But the reason / context has changed in the meantime right?
>
> If skcipher limitation is eliminated,
> will it be possible to add ecb(arc4) implementation back in caam,
> this time with the state stored in the request object?
>
> My understanding is: no, if Ard's arc4 RFC series is merged.
>

I would like the skcipher chaining discussion to focus on relevant and
typical skciphers like XTS and CBC-CTS, which is already tricky enough
to get right. As 'fixing' ecb(arc4) may open up security holes (given
that leaving the TFM version of the key untouched makes it more likely
that it gets reused inadvertently), I would prefer to get rid of it
entirely.

And what is the point of accelerated ecb(arc4) anyway? The internal
users all require sync skciphers (and those WEP/WPA fallbacks are
rarely used in practice, given that only ancient Wifi hardware relies
on them). We did identify a AF_ALG skcipher user that will be better
off using a C implementation in userland. And using RC4 for TLS was
explicitly forbidden by RFC 7465 5 years ago ...
