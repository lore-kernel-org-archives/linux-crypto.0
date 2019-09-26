Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9158BC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 13:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60340222C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 13:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ui7A0IxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfIZNQH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:16:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38894 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfIZNQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 09:16:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id 3so2540525wmi.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 06:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYKCkf/9udb08zDyVDa+j9RshyXNha3pc6th2ByyF9c=;
        b=Ui7A0IxWRvD0n0EPRBZpCiL8RXAZI/9JhGIUii+M0h6Q8WYWVbYy0nUBC7r3squbUl
         irrFobTVKHJX3kf4n2zrVZeYwzoTefH4ZWP6FUhvrECNsblCL7Dqm0k7k5Udg33WQaHp
         0F3e6q2ovkiS0FX0g/BxfK45pGLxom7LBR2tdpqaU3rTF54kruEBUhnkIsP+/xwFrhVn
         Uo8ij4fKonWcV1N6ZhF5oxpZ1PwKOEeSIwy4HeUINl2afp7e43/lFpUZaiqlcxezNgXe
         d80HRJckphF7lqkcfbirFGMlowoIItQF+dcGBtm8Y5fh2hRT4U+zzPVykdybR+hNFP/H
         lYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYKCkf/9udb08zDyVDa+j9RshyXNha3pc6th2ByyF9c=;
        b=QEOGrjlte/1vE1AEKMum/arWaJxkwmDazKoINy4dORyoJ9AWHg85bBGObkdt1UFv69
         yEL9aTI7V7x1S/X3mTxOLtjDdsE+gKiiNoQiUbefTKn58GoSbpjC7o95CMvOMivXM2SH
         aLymDjLlaUazV6Pt4T8h2zM30UaGkWoEqZfLMDtMTWPPHiIhGZBTN35wvgGmwa0hHSVU
         zK51PKSaBWDxO6TsQ9rBk/yikB0BYARAAq+bhl5p1LZCMKlWH3/Xo0MmZkfv72F81CPE
         wbRIOT8iHT8PdUB4Z14Ju8V/XREEBwPjb8H8RDt4Roo4T69ItTo9b2KxMoBnfmYzT5Pw
         qPiQ==
X-Gm-Message-State: APjAAAVl8aOpFB+W9EfKQLlTzCfhKsebqr8QqL/2lWtMgpZGu89BRRLC
        rUD4Tx8QQOEIM1pRuvnDCdB4Z9z6bdItyBWRoJaWuA==
X-Google-Smtp-Source: APXvYqxJi0lkkMXSCOu7S2Y50VqJ9EZ89R56Po9SG6oZxbjYPkG0NwzF/unO72G5Jlie6aCd2LhWvNpvk/J3Ul2zGKg=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr2812638wmc.136.1569503763943;
 Thu, 26 Sep 2019 06:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com> <MN2PR20MB29731267C4670FBD46D6C743CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29731267C4670FBD46D6C743CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 26 Sep 2019 15:15:52 +0200
Message-ID: <CAKv+Gu_eNK1HFxTY379kpCpF8FQQFHEdC1Th=s5f7Fy3bebOjQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Sep 2019 at 15:06, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
...
> >
> > My preference would be to address this by permitting per-request keys
> > in the AEAD layer. That way, we can instantiate the transform only
> > once, and just invoke it with the appropriate key on the hot path (and
> > avoid any per-keypair allocations)
> >
> This part I do not really understand. Why would you need to allocate a
> new transform if you change the key? Why can't you just call setkey()
> on the already allocated transform?
>

Because the single transform will be shared between all users running
on different CPUs etc, and so the key should not be part of the TFM
state but of the request state.

> >
> > It all depends on whether we are interested in supporting async
> > accelerators or not, and it is clear what my position is on this
> > point.
> >
> Maybe not for an initial upstream, but it should be a longer-term goal.
>
> >
> > What I *don't* want is to merge WireGuard with its own library based
> > crypto now, and extend that later for async accelerators once people
> > realize that we really do need that as well.
> >
> What's wrong with a step-by-step approach though? i.e. merge it with
> library calls now and then gradually work towards the goal of integrating
> (a tweaked version of) the Crypto API where that actually makes sense?
> Rome wasn't built in one day either ...
>

I should clarify: what I don't want is two frameworks in the kernel
for doing async crypto, the existing one plus a new library-based one.
