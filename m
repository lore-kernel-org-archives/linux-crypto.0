Return-Path: <SRS0=CriU=VS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C722EC76188
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jul 2019 09:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 883712085A
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jul 2019 09:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y8XAoLGX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfGUJuV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jul 2019 05:50:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35967 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGUJuU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jul 2019 05:50:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so28510990wme.1
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jul 2019 02:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQaXx84yWJDYOO2wjLxF1QV6zoVPN9ZxOOdoAW7u+BM=;
        b=y8XAoLGX2iH50XgryNmDwfuWVYGdZdKO60N8llqHSZxaim56KJI6E/96fwVOtTeas8
         kmg0ecVjwc7CfZ5CIVqkbYmge0b5w+Y0qbwt21zcU7eOUr9FdXwqa5Ry1vFeH+ULOrSx
         7ikSE99Ar0WahmR5qHw2hfP+Cq9nmEywvod0EFfIu/uXMzhRd1LpUmj7rJ6BsIchkndQ
         YTVR5FcFgzXfN9333I5Pm6/OmmcEWCVFVKYpYBdw5Go3RPtQcDNON9XGJl8sRyBN5STL
         RdQE5ulvc3wlRC4S8t3OO4b7V7LAws/U52hD9Ru8Ik4TwOfh7oWrH8/5YIhaNcicxrNu
         NRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQaXx84yWJDYOO2wjLxF1QV6zoVPN9ZxOOdoAW7u+BM=;
        b=YwrfIv/em2KSa64Ox5HysoXU3oZsSa44BmmC2r7eW/iZaIofjv3s6OFgNYvwiqt2aU
         WVdMas668H7r6yfqqvrrah9qrkFgKLoKz0haflipJepYVIFLh87YJMGCBjh8nv7+NZ2M
         Lr3WiLyvySQNNCHEaiatRV/Wy6p9lZ8Gs+C8ggRmBvyYzXY3jlkrGO0NzSqQ6CHa90Zg
         E8vZsQOXh5wwv6Ia7h4dkqdWYoAlzGR6UtaS3NBf4c4PCa/8uUYFyNU5ldkTHg9KxTwy
         ptlOuS2d8huZQISvWtssL6vklltqO8crFdcBNTH5/ujHrqOFbNDuuSobijIoZxs/cTSY
         uDnQ==
X-Gm-Message-State: APjAAAWOVevt1WpbJX9BnUvnoXzWbmsHr9K/36rqwp/loPhl39iMsSxj
        1/iUFnJX9S2hFejMFkBmaUTAuhk3ZuN0F2IoxeaCeQ==
X-Google-Smtp-Source: APXvYqye8yDdcXSDxXz1NeD+aCt85eq+4ajcVUtTYtafRYlbuL+czLGoNh21v0Bdz5CxdHGa/NFkDT+w3ALqZg6jyZQ=
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr60152036wmm.10.1563702618401;
 Sun, 21 Jul 2019 02:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190716221639.GA44406@gmail.com> <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au> <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au> <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com> <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
In-Reply-To: <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 21 Jul 2019 12:50:06 +0300
Message-ID: <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 20 Jul 2019 at 10:35, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 20/07/2019 08:58, Eric Biggers wrote:
> > On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
> >> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
> >> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
> >> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
> >> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
> >>
> >
> > Can't the "missing modules in initramfs" issue be solved by using a
> > MODULE_SOFTDEP()?  Actually, why isn't that being used for xts -> ecb already?
> >
> > (There was also a bug where CONFIG_CRYPTO_XTS didn't select CONFIG_CRYPTO_ECB,
> > but that was simply a bug, which was fixed.)
>
> Sure, and it is solved now. (Some systems with a hardcoded list of modules
> have to be manually updated etc., but that is just bad design).
> It can be done properly from the beginning.
>
> I just want to say that that switching to XEX looks like wasting time to me
> for no additional benefit.
>
> Fully implementing XTS does make much more sense for me, even though it is long-term
> the effort and the only user, for now, would be testmgr.
>
> So, there are no users because it does not work. It makes no sense
> to implement it, because there are no users... (sorry, sounds like catch 22 :)
>
> (Maybe someone can use it for keyslot encryption for keys not aligned to
> block size, dunno. Actually, some filesystem encryption could have use for it.)
>
> > Or "xts" and "xex" could go in the same kernel module xts.ko, which would make
> > this a non-issue.
>
> If it is not available for users, I really see no reason to introduce XEX when
> it is just XTS with full blocks.
>
> If it is visible to users, it needs some work in userspace - XEX (as XTS) need two keys,
> people are already confused enough that 256bit key in AES-XTS means AES-128...
> So the examples, hints, man pages need to be updated, at least.
>

OK, consider me persuaded. We are already exposing xts(...) to
userland, and since we already implement a proper subset of true XTS,
it will be simply a matter of making sure that the existing XTS
implementations don't regress in performance on the non-CTS code
paths.

It would be useful, though, to have some generic helper functions,
e.g., like the one we have for CBC, or the one I recently proposed for
CTS, so that existing implementations (such as the bit sliced AES) can
easily be augmented with a CTS code path (but performance may not be
optimal in those cases). For the ARM implementations based on AES
instructions, it should be reasonably straight forward to implement it
close to optimally by reusing some of the code I added for CBC-CTS
(but I won't get around to doing that for a while). If there are any
volunteers for looking into the generic or x86/AES-NI implementations,
please come forward :-) Also, if any of the publications that were
quoted in this thread have suitable test vectors, that would be good
to know.
