From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [v4.7-6816-g797cee982eef] Call-trace: modprobe | asymmetric-keys?
Date: Sun, 31 Jul 2016 12:30:44 +0200
Message-ID: <CA+icZUVGc-BYMJYSO+9JM82r_Z6x1cNW+Bg+WyYaaCYbnEtLcQ@mail.gmail.com>
References: <CA+icZUVTG9hjrHarFts_SV1oAX1-fH7YMeHkC8oXcAd=1AKKvw@mail.gmail.com>
 <20160730142547.GA22578@gondor.apana.org.au>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:34387 "EHLO
	mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbcGaKaq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Jul 2016 06:30:46 -0400
In-Reply-To: <20160730142547.GA22578@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 30, 2016 at 4:25 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Jul 30, 2016 at 02:55:12PM +0200, Sedat Dilek wrote:
>> [ CC "MODULE SUPPORT" | "ASYMMETRIC KEYS" | "CRYPTO API" maintainers ]
>>
>> Hi,
>>
>> with latest Linus Git (v4.7-6816-g797cee982eef) I see the following
>> call-trace in my Ubuntu/precise AMD64 system...
>
> This should be fixed by
>
> https://patchwork.kernel.org/patch/9250679/
>
> which I will push to Linus soon.
>

[ CC Nicolai ]

I have stolen the mentioned patch [1] from your crypto-2.6.git#master tree...

And it fixes the issue for me!

Even it's too late for credits...

    Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
    Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

I had also libmpi on my radar, but if you do not know where the
problem exactly is...

Many thanks for the quick reply - it helped me a lot.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/herbert/crypto-2.6.git/patch/?id=4816c9406430d0d3d4fa58a212a7a869d429b315
[2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=127827b9c295db35fa7e49d00ac5d14faeda9461

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
