From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 8 Dec 2016 16:31:27 +0530
Message-ID: <CANc+2y6ru8x01tsxHKPiEEvyYZ5=gbxZuV-ok2QpjNmKFiAUMg@mail.gmail.com>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au> <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au> <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au> <20161208092400.GA9743@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        maxime.ripard@free-electrons.com, Chen-Yu Tsai <wens@csie.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34153 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbcLHLB3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 06:01:29 -0500
In-Reply-To: <20161208092400.GA9743@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> The hwrng interface was always meant to be an interface for real
>> hardware random number generators.  People rely on that so we
>> should not provide bogus entropy sources through this interface.
>>
>
> Why not adding a KCONFIG HW_RANDOM_ACCEPT_ALSO_PRNG with big warning ?
> Or a HW_PRNG Kconfig which do the same than hwrandom with /dev/prng ?
> With that it will be much easier to convert in-tree PRNG that you want to remove.

I do have driver for a PRNG that I was planning to post in sometime.
Upon seeing this thread I think the code has to be changed.

I completely agree with Corentin, adding /dev/prng or /dev/hw_prng
will make it easier to move existing code. It can be made explicit
that using new device will provide only pseudo random number.

Thanks,
PrasannaKumar
