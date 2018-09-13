From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 17:07:08 +0200
Message-ID: <CAKv+Gu-CVsXQmx1BZQMe__LREvWEigd2FdoA2ErLu1ky6gzHtw@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com> <CAHmME9pp8HoisxQWL_eELR-ziiBii-7mcA=oF9UF-WMucewX5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHmME9pp8HoisxQWL_eELR-ziiBii-7mcA=oF9UF-WMucewX5w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13 September 2018 at 16:18, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Thu, Sep 13, 2018 at 1:45 AM Andy Lutomirski <luto@kernel.org> wrote:
>> I'm not convinced that there's any real need for *all* crypto
>> algorithms to move into lib/zinc or to move at all.  As I see it,
>> there are two classes of crypto algorithms in the kernel:
>>
>> a) Crypto that is used by code that chooses its algorithm statically
>> and wants synchronous operations.  These include everything in
>> drivers/char/random.c, but also a bunch of various networking things
>> that are hardcoded and basically everything that uses stack buffers.
>> (This means it includes all the code that I broke when I did
>> VMAP_STACK.  Sign.)
>
> Right, exactly. This is what will wind up using Zinc. I'm working on
> an example usage of this for v4 of the patch submission, which you can
> ogle in a preview here if you're curious:
>
> https://git.zx2c4.com/linux-dev/commit/?h=big_key_rewrite
>
> 28 insertions, 206 deletions :-D
>

I must say, that actually looks pretty good.

>> b) Crypto that is used dynamically.  This includes dm-crypt
>> (aes-xts-plain64, aes-cbc-essiv, etc), all the ALG_IF interfaces, a
>> lot of IPSEC stuff, possibly KCM, and probably many more.  These will
>> get comparatively little benefit from being converted to a zinc-like
>> interface.  For some of these cases, it wouldn't make any sense at all
>> to convert them.  Certainly the ones that do async hardware crypto
>> using DMA engines will never look at all like zinc, even under the
>> hood.
>
> Right, this is what the crypto API will continue to be used for.
>
>
>> I think that, as a short-term goal, it makes a lot of sense to have
>> implementations of the crypto that *new* kernel code (like Wireguard)
>> wants to use in style (a) that live in /lib, and it obviously makes
>> sense to consolidate their implementations with the crypto/
>> implementations in a timely manner.  As a medium-term goal, adding
>> more algorithms as needed for things that could use the simpler APIs
>> (Bluetooth, perhaps) would make sense.
>
> Agreed 100%. With regards to "consolidate their implementations" --
> I've actually already done this after your urging yesterday, and so
> that will be a part of v4.
>
>> But I see no reason at all that /lib should ever contain a grab-bag of
>> crypto implementations just for the heck of it.  They should have real
>> in-kernel users IMO.  And this means that there will probably always
>> be some crypto implementations in crypto/ for things like aes-xts.
>
> Right, precisely.
>
> Jason
