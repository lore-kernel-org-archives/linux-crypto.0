Return-Path: <SRS0=D8v3=2E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9639C43603
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Dec 2019 12:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B334824656
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Dec 2019 12:21:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="NoPXyBKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfLNMVi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Dec 2019 07:21:38 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48683 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfLNMVh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Dec 2019 07:21:37 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c6ff35cf
        for <linux-crypto@vger.kernel.org>;
        Sat, 14 Dec 2019 11:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ojweuQz62vOngeheg6Nx+3FJJho=; b=NoPXyB
        KHPu0yiMDStcsqchdntSiPi5vE90CqLoJOb5wTTJdtnXr+i1o6pibdtaqJBlqgzi
        E4EYs6aVv+E1rlahKySo/tXsb0RnAaXgnPWtKEahJ361yYR7vyX0xx/INkIRq19F
        V86e/atkUqDwz0ErRUJznvfvLYy7E1jPBmPnZm3nSESrsocEDhafh/UQphYhnDGj
        Oyyr5HNy5JWNOmqEwBhNafqfirSu3h2mDypNBgHzc1jf6SnHC43gOJ4gsI8LsI5/
        /nl5Fzd7UE2kzx9oZ21DxVSxAmMJXo+Y3D2Tdf7kwJ0Lwp/Mfvi8EY8fpy1W/lkH
        Bi4ZKejAiAjSxjnQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7eedbdd7 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sat, 14 Dec 2019 11:25:33 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id 59so2588782otp.12
        for <linux-crypto@vger.kernel.org>; Sat, 14 Dec 2019 04:21:35 -0800 (PST)
X-Gm-Message-State: APjAAAWi78sDHiGV1p/BFBZochRj4ZRBjW/fK8nMdNhB4vJoL7xZzB4p
        5ktYV8YG1bR8BwTOdraEqKCzoT6k3hhnxYpFj2M=
X-Google-Smtp-Source: APXvYqwiN2b4NCR3E4Jk8IbK+OmqyIW9eKrDedx3uwK4uO8d3VC6BofBd95BgjTuLSRQoMSRjO6fF18YAY8/h6Axkrs=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr20599877otm.243.1576326095185;
 Sat, 14 Dec 2019 04:21:35 -0800 (PST)
MIME-Version: 1.0
References: <20191213032849.GC1109@sol.localdomain> <20191214085608.b53yiogf432zxyw7@gondor.apana.org.au>
In-Reply-To: <20191214085608.b53yiogf432zxyw7@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 14 Dec 2019 13:21:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9rrwXJ7H6PENEzSzHUQusa3QpnNvSMV9-=++j8UDMVbsQ@mail.gmail.com>
Message-ID: <CAHmME9rrwXJ7H6PENEzSzHUQusa3QpnNvSMV9-=++j8UDMVbsQ@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Sat, Dec 14, 2019 at 9:56 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Now, it's possible that the performance gain outweighs this, and I too would
> > like to have the C implementation of Poly1305 be faster.  So if you'd like to
> > argue for the performance gain, fine, and if there's a significant performance
> > gain I don't have an objection.  But I'm not sure why you're at the same time
> > trying to argue that *adding* an extra implementation somehow makes the code
> > easier to audit and doesn't add complexity...
>
> Right.  We need the numbers not because we're somehow attached
> to the existing code, but we need them to show that we should
> carry the burden of having two C implementations, 32-bit vs 64-bit.

This info is now in the commit message of the version in my tree,
rather than sprinkled around casually in these threads. I also did a
bit more benchmarking this morning.

From <https://git.zx2c4.com/linux-dev/commit/?h=jd/crypto-5.5&id=900b79e1ff48f1f294ef3e9fb2520699c8895860>:
> Testing with kbench9000, depending on the CPU, the update function for
> the 32x32 version has been improved by 4%-7%, and for the 64x64 by
> 19%-30%. The 32x32 gains are small, but I think there's great value in
> having a parallel implementation to the 64x64 one so that the two can be
> compared side-by-side as nice stand-alone units.

I'll resubmit this on Monday.

Regards,
Jason
