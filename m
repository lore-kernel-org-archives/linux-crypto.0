Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA8DC432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 11:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27642146E
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 11:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="E7B4xf/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfIZLsj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 07:48:39 -0400
Received: from mail.toke.dk ([52.28.52.200]:56781 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfIZLsj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 07:48:39 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2019 07:48:38 EDT
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1569497917; bh=2ozAWmHQqzsPDD0WmdG2auChc9T1w49xSlDI6ZfDT7o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=E7B4xf/sxTyXBeJoIGW4nq+Nma+qA/w0+mvTe4vhnAMnXOMwoNqN3gDE5hVdmdNzh
         /cy8vHjKBAT2ogyoiI6miZ76hx67WQMVHN6a2BVqXmNEVEsuXo+5o7swBUAPCBWqHv
         VMmzaEdMsV2Uv19vqCGkyzwg2EJEb01nOVmOnVhCTdWd4ObjWDaCmz3mtvmwvX1xkx
         N27rxXs/S8RzJjikh/vluQgPD3Jx6octJQQJEEF38ED/mcB5ByakvsgPj4OAYlok2R
         So9Nhhgnw01AwyOqMWr8VQnGQ5pUR3ZKQGpfV25KDOG2KIbUNkX5Z+F9X+p9L2Xo7C
         n9nJBQm/HWwGw==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        Catalin Marinas <catalin.marinas@arm.com>,
        Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: chapoly acceleration hardware [Was: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API]
In-Reply-To: <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org> <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com> <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com> <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com>
Date:   Thu, 26 Sep 2019 13:38:36 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <8736gj2soz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> [CC +willy, toke, dave, netdev]
>
> Hi Pascal
>
> On Thu, Sep 26, 2019 at 12:19 PM Pascal Van Leeuwen
> <pvanleeuwen@verimatrix.com> wrote:
>> Actually, that assumption is factually wrong. I don't know if anything
>> is *publicly* available, but I can assure you the silicon is running in
>> labs already. And something will be publicly available early next year
>> at the latest. Which could nicely coincide with having Wireguard support
>> in the kernel (which I would also like to see happen BTW) ...
>>
>> Not "at some point". It will. Very soon. Maybe not in consumer or server
>> CPUs, but definitely in the embedded (networking) space.
>> And it *will* be much faster than the embedded CPU next to it, so it will
>> be worth using it for something like bulk packet encryption.
>
> Super! I was wondering if you could speak a bit more about the
> interface. My biggest questions surround latency. Will it be
> synchronous or asynchronous? If the latter, why? What will its
> latencies be? How deep will its buffers be? The reason I ask is that a
> lot of crypto acceleration hardware of the past has been fast and
> having very deep buffers, but at great expense of latency. In the
> networking context, keeping latency low is pretty important. Already
> WireGuard is multi-threaded which isn't super great all the time for
> latency (improvements are a work in progress). If you're involved with
> the design of the hardware, perhaps this is something you can help
> ensure winds up working well? For example, AES-NI is straightforward
> and good, but Intel can do that because they are the CPU. It sounds
> like your silicon will be adjacent. How do you envision this working
> in a low latency environment?

Being asynchronous doesn't *necessarily* have to hurt latency; you just
need the right queue back-pressure.


We already have multiple queues in the stack. With an async crypto
engine we would go from something like:

stack -> [qdisc] -> wg if -> [wireguard buffer] -> netdev driver ->
device -> [device buffer] -> wire

to

stack -> [qdisc] -> wg if -> [wireguard buffer] -> crypto stack ->
crypto device -> [crypto device buffer] -> wg post-crypto -> netdev
driver -> device -> [device buffer] -> wire

(where everything in [] is a packet queue).

The wireguard buffer is the source of the latency you're alluding to
above (the comment about multi-threaded behaviour), so we probably need
to fix that anyway. For the device buffer we have BQL to keep it at a
minimum. So that leaves the buffering in the crypto offload device. If
we add something like BQL to the crypto offload drivers, we could
conceivably avoid having that add a significant amount of latency. In
fact, doing so may benefit other users of crypto offloads as well, no?
Presumably ipsec has this same issue?


Caveat: I am fairly ignorant about the inner workings of the crypto
subsystem, so please excuse any inaccuracies in the above; the diagrams
are solely for illustrative purposes... :)

-Toke
