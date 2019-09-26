Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A38ECE58B
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 16:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E084A222C9
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569516181;
	bh=OKNdANJ0A04roUjc6G5+NdkSR5GuEw2E5C4B0TJ5gF8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Nc/pFVwRoEOgcuXo28KvozhxkKrAwM6uH1rb9qEHc9qvlnjN2BokzhKN48NOjY/TG
	 NgkP7WchY6jzNqo7xsPMRtBovnpt8F0Fj2Fau2NXcoDakHDSDahoTpLWJCT/dqGsDc
	 A0EMfJUVA1aGYXTcpP4lsB4Y/bfad7Xvm1WzyQ5w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfIZQm7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 12:42:59 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40687 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfIZQm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 12:42:59 -0400
Received: by mail-lf1-f65.google.com with SMTP id d17so2208402lfa.7
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 09:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCcArD5l0z7DpY04H7ah68ZY1dqCueMrSSG13Ow1NK4=;
        b=Z2+niSAlTDaPDa8oRjcVzXT1eBWbbDmPiXTEk8TsNFZjVABaaLFlfG743ko36nEDnV
         2ogsPiKrqbQxUSX1PXUpCbK+8TynYYHdjW4a2tAuSkDdMYX+CMc9OsuQ/uiO8T4bcTk+
         dEY3onONAg7UkOcvJb4ufTLBqhkzJ/z4c6acc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCcArD5l0z7DpY04H7ah68ZY1dqCueMrSSG13Ow1NK4=;
        b=cYFkhsw58Lk5pp1ajYlhpLHg+IQXRKohmsqVtLfqht4JOd/OmyijrYkrhbAO2XU6I+
         700P3/duw9LnZ4yjNZ4/RWMOn3ZkLUu95MA7/GLag6Su9e4FqLDvxgA9RDJDV2gBSogJ
         RgN/TjIsUiaHU87M9PVwxnATmox95i5dmo8jJDCxsEyKOhE9RYPGMGBCIzbesQp8ROpN
         epX1pRdC25mflTHhh/mxpvn7vDdc7Iu5+I2G3ZxokQ36tknohGZ8rt9SF7Eyahk2lTbB
         aaofTXb6gjC3jfHdcAKFGbi1ezHJN9K9hzkVjVByXl08Skos8w7aNh8UZhEWPpW4a9fl
         OTpQ==
X-Gm-Message-State: APjAAAWvgfOTe/tJ4WQc1nBSjKUFD6VmDcP+3CWUrrjssdNuyTm4Rf60
        Lhou8aA5ZCLebQ4sEN700GFFHihPvXI=
X-Google-Smtp-Source: APXvYqzdhrlEwUCkMFh/A+wjsY694F5Cs/yTzS7DcvhXjeoJ+RjQ1WGygorQv1NhC9yBeuXN9HVmDA==
X-Received: by 2002:ac2:4552:: with SMTP id j18mr2909093lfm.120.1569516176265;
        Thu, 26 Sep 2019 09:42:56 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id z72sm619335ljb.98.2019.09.26.09.42.55
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 09:42:56 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id v24so2897332ljj.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 09:42:55 -0700 (PDT)
X-Received: by 2002:a2e:1208:: with SMTP id t8mr3175782lje.84.1569515731923;
 Thu, 26 Sep 2019 09:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
In-Reply-To: <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 26 Sep 2019 09:35:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
Message-ID: <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
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

On Thu, Sep 26, 2019 at 2:40 AM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> While I agree with the principle of first merging Wireguard without
> hooking it up to the Crypto API and doing the latter in a later,
> separate patch, I DONT'T agree with your bashing of the Crypto API
> or HW crypto acceleration in general.

I'm not bashing hardware crypto acceleration.

But I *am* bashing bad interfaces to it.

Honestly, you need to face a few facts, Pascal.

Really.

First off: availability.

 (a) hardware doesn't exist right now outside your lab

This is a fact.

 (b) hardware simply WILL NOT exist in any huge number for years,
possibly decades. If ever,

This is just reality, Pascal. Even if you release your hardware
tomorrow, where do you think it will exists? Laptops? PC's? Phones?
No. No. And no.

Phones are likely the strongest argument for power use, but phones
won't really start using it until it's on the SoC, because while they
care deeply about power, they care even more deeply about a lot of
other things a whole lot more. Form factor, price, and customers that
care.

So phones aren't happening. Not for years, and not until it's a big
deal and standard IP that everybody wants.

Laptops and PC's? No. Look at all the crypto acceleration they have today.

That was sarcasm, btw, just to make it clear. It's simply not a market.

End result: even with hardware, the hardware will be very rare. Maybe
routers that want to sell particular features in the near future.

Again, this isn't theory. This is that pesky little thing called
"reality". It sucks, I know.

But even if you *IGNORE* the fact that hardware doesn't exist right
now, and won't be widely available for years (or longer), there's
another little fact that you are ignoring:

The async crypto interfaces are badly designed. Full stop.

Seriously. This isn't rocket science. This is very very basic Computer
Science 101.

Tell me, what's _the_ most important part about optimizing something?

Yeah, it's "you optimize for the common case". But let's ignore that
part, since I already said that hardware isn't the common case but I
promised that I'd ignore that part.

The _other_ most important part of optimization is that you optimize
for the case that _matters_.

And the async crypto case got that completely wrong, and the wireguard
patch shows that issue very clearly.

The fact is, even you admit that a few CPU cycles don't matter for the
async case where you have hardware acceleration, because the real cost
is going to be in the IO - whether it's DMA, cache coherent
interconnects, or some day some SoC special bus. The CPU cycles just
don't matter, they are entirely in the noise.

What does that mean?  Think about it.

[ Time passes ]

Ok, I'll tell you: it means that the interface shouldn't be designed
for async hw-assisted crypto. The interface should be designed for the
case that _does_ care about CPU cycles, and then the async hw-assisted
crypto should be hidden by a conditional, and its (extra) data
structures should be the ones that are behind some indirect pointers
etc.  Because, as we agreed, the async external hw case really doesn't
care. It it has to traverse a pointer or two, and if it has to have a
*SEPARATE* keystore that has longer lifetimes, then the async code can
set that up on its own, but that should not affect the case that
cares.

Really, this is fundamental, and really, the crypto interfaces got this wrong.

This is in fact _so_ fundamental that the only possible reason you can
disagree is because you don't care about reality or fundamentals, and
you only care about the small particular hardware niche you work in
and nothing else.

You really should think about this a bit.

> However, if you're doing bulk crypto like network packet processing
> (as Wireguard does!) or disk/filesystem encryption, then that cipher
> allocation only happens once every blue moon and the overhead for
> that is totally *irrelevant* as it is amortized over many hours or
> days of runtime.

This is not true. It's not true because the overhead happens ALL THE TIME.

And in 99.9% of all cases there are no upsides from the hw crypto,
because the hardware DOES NOT EXIST.

You think the "common case" is that hardware encryption case, but see
above. It's really not.

And when you _do_ have HW encryption, you could do the indirection.

But that's not an argument for always having the indirection.

What indirection am I talking about?

There's multiple levels of indirection in the existing bad crypto interfaces:

 (a) the data structures themselves. This is things like keys and
state storage, both of which are (often) small enough that they would
be better off on a stack, or embedded in the data structures of the
callers.

 (b) the calling conventions. This is things like indirection -
usually several levels - just to find the function pointer to call to,
and then an indirect call to that function pointer.

and both of those are actively bad things when you don't have those
hardware accelerators.

When you *do* have them, you don't care. Everybody agrees about that.
But you're ignoring the big white elephant in the room, which is that
the hw really is very rare in the end, even if it were to exist at
all.

> While I generally dislike this whole hype of storing stuff in
> textual formats like XML and JSON and then wasting lots of CPU
> cycles on parsing that, I've learned to appreciate the power of
> these textual Crypto API templates, as they allow a hardware
> accelerator to advertise complex combined operations as single
> atomic calls, amortizing the communication overhead between SW
> and HW. It's actually very flexible and powerful!

BUT IT IS FUNDAMENTALLY BADLY DESIGNED!

Really.

You can get the advantages of hw-accelerated crypto with good designs.
The current crypto layer is not that.

The current crypto layer simply has indirection at the wrong level.

Here's how it should have been done:

 - make the interfaces be direct calls to the crypto you know you want.

 - make the basic key and state buffer be explicit and let people
allocate them on their own stacks or whatever

"But what about hw acceleration?"

 - add a single indirect private pointer that the direct calls can use
for their own state IF THEY HAVE REASON TO

 - make the direct crypto calls just have a couple of conditionals
inside of them

Why? Direct calls with a couple of conditionals are really cheap for
the non-accelerated case. MUCH cheaper than the indirection overhead
(both on a state level and on a "crypto description" level) that the
current code has.

Seriously. The hw accelerated crypto won't care about the "call a
static routine" part. The hw accelerated crypto won't care about the
"I need to allocate a copy of the key because I can't have it on
stack, and need to have it in a DMA'able region". The hw accelerated
crypto won't care about the two extra instructions that do "do I have
any extra state at all, or should I just do the synchronous CPU
version" before it gets called through some indirect pointer.

So there is absolutely NO DOWNSIDE for hw accelerated crypto to just
do it right, and use an interface like this:

       if (!chacha20poly1305_decrypt_sg(sg, sg, skb->len, NULL, 0,
                                        PACKET_CB(skb)->nonce, key->key,
                                        simd_context))
               return false;

because for the hw accelerated case the costs are all elsewhere.

But for synchronous encryption code on the CPU? Avoiding the
indirection can be a huge win. Avoiding allocations, extra cachelines,
all that overhead. Avoiding indirect calls entirely, because doing a
few conditional branches (that will predict perfectly) on the state
will be a lot more efficient, both in direct CPU cycles and in things
like I$ etc.

In contrast, forcing people to use this model:

       if (unlikely(crypto_aead_reqsize(key->tfm) > 0)) {
               req = aead_request_alloc(key->tfm, GFP_ATOMIC);
               if (!req)
                       return false;
       } else {
               req = &stackreq;
               aead_request_set_tfm(req, key->tfm);
       }

       aead_request_set_ad(req, 0);
       aead_request_set_callback(req, 0, NULL, NULL);
       aead_request_set_crypt(req, sg, sg, skb->len,
                              (u8 *)&PACKET_CB(skb)->ivpad);
       err = crypto_aead_decrypt(req);
       if (unlikely(req != &stackreq))
               aead_request_free(req);
       if (err)
               return false;

isn't going to help anybody. It sure as hell doesn't help the
CPU-synchronous case, and see above: it doesn't even help the hw
accelerated case. It could have had _all_ that "tfm" work behind a
private pointer that the CPU case never touches except to see "ok,
it's NULL, I don't have any".

See?

The interface *should* be that chacha20poly1305_decrypt_sg() library
interface, just give it a private pointer it can use and update. Then,
*internally* if can do something like

     bool chacha20poly1305_decrypt_sg(...)
     {
             struct cc20p1305_ptr *state = *state_p;
             if (state) {
                     .. do basically the above complex thing ..
                     return ret; .. or fall back to sw if the hw
queues are full..
             }
             .. do the CPU only thing..
     }

and now you'd have no extra obverhead for the no-hw-accel case, you'd
have a more pleasant interface to use, and you could still use hw
accel if you wanted to.

THIS is why I say that the crypto interface is bad. It was designed
for the wrong objectives. It was designed purely for a SSL-like model
where you do a complex key and algorithm exchange dance, and you
simply don't know ahead of time what crypto you are even using.

And yes, that "I'm doing the SSL thing" used to be a major use of
encryption. I understand why it happened. It was what people did in
the 90's. People thought it was a good idea back then, and it was also
most of the hw acceleration world.

And yes, in that model of "I don't have a clue of what crypto I'm even
using" the model works fine. But honestly, if you can't admit to
yourself that it's wrong for the case where you _do_ know the
algorithm, you have some serious blinders on.

Just from a user standpoint, do you seriously think users _like_
having to do the above 15+ lines of code, vs the single function call?

The crypto interface really isn't pleasant, and you're wrong to
believe that it really helps. The hw acceleration capability could
have been abstracted away, instead of making that indirection be front
and center.

And again - I do realize the historical reasons for it. But
understanding that doesn't magically make it wonderful.

                 Linus
