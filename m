Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21998C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 01:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDEC8207FF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 01:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569547861;
	bh=mKqwnVC9gbpPEZzirTc8SYhkl392eSt9iEKsKV/+OUs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ICyoFDn3vRMrDik6Zf42bzHTxu9APUmKKEi2xAIkyOZg+2PDb0lvk2hCdvcqqtenp
	 Rmg9G0XO2WJskII6ZsAAcGp/U3islfCJdiaJb52PavNaEjlcGxaJkuDzD0umjPqBLp
	 u5JVA/78W0JM4kt6I2zldvGsDw6CFJ9qQ6tsfPPA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfI0Ba7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 21:30:59 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46557 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfI0Ba7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 21:30:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so784475ljl.13
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 18:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/kNRa+FZLOFlIwuCXVz7nJiD6HA2dI+YJ9/E6wCcQ4=;
        b=TVHyiGBDvae6bZXGebhK/blHgPNDjYfumORGT+FpcUBXfboYigbCjBueMnw3bBb7L6
         g7hfpEIO29H1AJ3VvzodmMvDz6YoOOInaCxs+zhXJ4G5oUM2MEaoAtVDu2+GYod5vpio
         EQF9WIp691oAklRXwcgbwGjj9XLQHHXpCTYdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/kNRa+FZLOFlIwuCXVz7nJiD6HA2dI+YJ9/E6wCcQ4=;
        b=k6sX+C85rTAy85kT/wuoEDoC1Mbbp9f13WCfywDLblhDFMqws13zny72niEBiKmANi
         m8nQSa/YIQcMJj0GXv4F4rSC2h7VRLFBKd5SJK/2QVPHZWwUOZ9f1LK/EBvH/e1zMuOo
         2xRzZ3OpEpCUWYOXU/mtOyL9oN98NGX30w+yX+gQuDGdmVKtaZBoVHCD6xKccq27U9zx
         ZZxOckND1z5qa34AiSgO/z/KJ01Lp045r4Xvg5carJJQIqXHyD7arLhQ7vTwia18a2FM
         aM2Rui1giC1+l4GaAx5bs7IUtdsL7FYRmDoGbFLaNxI547vFhl1amRYufqk7VmcRpsrr
         M6/A==
X-Gm-Message-State: APjAAAXhh80phijYzXGyOxZlCOEOChAyCvK4+H1FZVvVi243ti/NpqfB
        UgFqcE4+13Di2w4yC8clquXfeziNmaU=
X-Google-Smtp-Source: APXvYqzArWyZzepswWsmTGZMdQi64somFOQA0arkcwJC4SwaFP010tSDYp56iNj6SixdiuQtqgTA2A==
X-Received: by 2002:a2e:a316:: with SMTP id l22mr924819lje.211.1569547855509;
        Thu, 26 Sep 2019 18:30:55 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id k17sm165770lja.61.2019.09.26.18.30.54
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 18:30:54 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id b20so828858ljj.5
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 18:30:54 -0700 (PDT)
X-Received: by 2002:a2e:3e07:: with SMTP id l7mr959811lja.180.1569547853755;
 Thu, 26 Sep 2019 18:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com> <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 26 Sep 2019 18:30:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
Message-ID: <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
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

On Thu, Sep 26, 2019 at 5:15 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> That remark is just very stupid. The hardware ALREADY exists, and
> more hardware is in the pipeline. Once this stuff is designed in, it
> usually stays in for many years to come. And these are chips sold in
> _serious_ quantities, to be used in things like wireless routers and
> DSL, cable and FTTH modems, 5G base stations, etc. etc.

Yes, I very much mentioned routers. I believe those can happen much
more quickly.

But I would very much hope that that is not the only situation where
you'd see wireguard used.

I'd want to see wireguard in an end-to-end situation from the very
client hardware. So laptops, phones, desktops. Not the untrusted (to
me) hw in between.

> No, these are just the routers going into *everyone's* home. And 5G
> basestations arriving at every other street corner. I wouldn't call
> that rare, exactly.

That's fine for a corporate tunnel between devices. Which is certainly
one use case for wireguard.

But if you want VPN for your own needs for security, you want it at
the _client_. Not at the router box. So that case really does matter.

And I really don't see the hardware happening in that space. So the
bad crypto interfaces only make the client _worse_.

See?

But on to the arguments that we actually agree on:

> Hey, no argument there. I don't see any good reason why the key can't
> be on the stack. I doubt any hardware would be able to DMA that as-is
> directly, and in any case, key changes should be infrequent, so copying
> it to some DMA buffer should not be a performance problem.
> So maybe that's an area for improvement: allow that to be on the stack.

It's not even just the stack. It's really that the crypto interfaces
are *designed* so that you have to allocate things separately, and
can't embed these things in your own data structures.

And they are that way, because the crypto interfaces aren't actually
about (just) hiding the hardware interface: they are about hiding
_all_ the encryption details.

There's no way to say "hey, I know the crypto I use, I know the key
size I have, I know the state size it needs, I can preallocate those
AS PART of my own data structures".

Because the interface is designed to be so "generic" that you simply
can't do those things, they are all external allocations, which is
inevitably slower when you don't have hardware.

And you've shown that you don't care about that "don't have hardware"
situation, and seem to think it's the only case that matters. That's
your job, after all.

But however much you try to claim otherwise, there's all these
situations where the hardware just isn't there, and the crypto
interface just forces nasty overhead for absolutely no good reason.

> I already explained the reasons for _not_ doing direct calls above.

And I've tried to explain how direct calls that do the synchronous
thing efficiently would be possible, but then _if_ there is hardware,
they can then fall back to an async interface.

> > So there is absolutely NO DOWNSIDE for hw accelerated crypto to just
> > do it right, and use an interface like this:
> >
> >        if (!chacha20poly1305_decrypt_sg(sg, sg, skb->len, NULL, 0,
> >                                         PACKET_CB(skb)->nonce, key->key,
> >                                         simd_context))
> >                return false;
> >
> Well, for one thing, a HW API should not expect the result to be
> available when the function call returns. (if that's what you
> mean here). That would just be WRONG.

Right. But that also shouldn't mean that when you have synchronous
hardware (ie CPU) you have to set everything up even though it will
never be used.

Put another way: even with hardware acceleration, the queuing
interface should be a simple "do this" interface.

The current crypto interface is basically something that requires all
the setup up-front, whether it's needed or not. And it forces those
very inconvenient and slow external allocations.

And I'm saying that causes problems, because it fundamentally means
that you can't do a good job for the common CPU  case, because you're
paying all those costs even when you need absolutely none of them.
Both at setup time, but also at run-time due to the extra indirection
and cache misses etc.

> Again, HW acceleration does not depend on the indirection _at all_,
> that's there for entirely different purposes I explained above.
> HW acceleration _does_ depend greatly on a truly async ifc though.

Can you realize that the world isn't just all hw acceleration?

Can you admit that the current crypto interface is just horrid for the
non-accelerated case?

Can you perhaps then also think that "maybe there are better models".

> So queue requests on one side, handle results from the other side
> in some callback func off of an interrupt handler.

Actually, what you can do - and what people *have* done - is to admit
that the synchronous case is real and important, and then design
interfaces that work for that one too.

You don't need to allocate resources ahead of time, and you don't have
to disallow just having the state buffer allocated by the caller.

So here's the *wrong* way to do it (and the way that crypto does it):

 - dynamically allocate buffers at "init time"

 - fill in "callback fields" etc before starting the crypto, whether
they are needed or not

 - call a "decrypt" function that then uses the indirect functions you
set up at init time, and possibly waits for it (or calls the callbacks
you set up)

note how it's all this "state machine" model where you add data to the
state machine, and at some point you say "execute" and then either you
wait for things or you get callbacks.

That makes sense for a hw crypto engine. It's how a lot of them work, after all.

But it makes _zero_ sense for the synchronous case. You did a lot of
extra work for that case, and because it was all a styate machine, you
did it particularly inefficiently: not only do you have those separate
allocations with pointer following, the "decrypt()" call ends up doing
an indirect call to the CPU implementation, which is just quite slow
to begin with, particularly in this day and age with retpoline etc.

So what's the alternative?

I claim that a good interface would accept that "Oh, a lot of cases
will be synchronous, and a lot of cases use one fixed
encryption/decryption model".

And it's quite doable. Instead of having those callback fields and
indirection etc, you could have something more akin to this:

 - let the caller know what the state size is and allocate the
synchronous state in its own data structures

 - let the caller just call a static "decrypt_xyz()" function for xyz
decryptrion.

 - if you end up doing it synchronously, that function just returns
"done". No overhead. No extra allocations. No unnecessary stuff. Just
do it, using the buffers provided. End of story. Efficient and simple.

 - BUT.

 - any hardware could have registered itself for "I can do xyz", and
the decrypt_xyz() function would know about those, and *if* it has a
list of accelerators (hopefully sorted by preference etc), it would
try to use them. And if they take the job (they might not - maybe
their queues are full, maybe they don't have room for new keys at the
moment, which might be a separate setup from the queues), the
"decrypt_xyz()" function returns a _cookie_ for that job. It's
probably a pre-allocated one (the hw accelerator might preallocate a
fixed number of in-progress data structures).

And once you have that cookie, and you see "ok, I didn't get the
answer immediately" only THEN do you start filling in things like
callback stuff, or maybe you set up a wait-queue and start waiting for
it, or whatever".

See the difference in models? One forces that asynchronous model, and
actively penalizes the synchronous one.

The other _allows_ an asynchronous model, but is fine with a synchronous one.

> >        aead_request_set_callback(req, 0, NULL, NULL);
> >
> This is just inevitable for HW acceration ...

See above. It really isn't. You could do it *after* the fact, when
you've gotten that ticket from the hardware. Then you say "ok, if the
ticket is done, use these callbacks". Or "I'll now wait for this
ticket to be done" (which is what the above does by setting the
callbacks to zero).

Wouldn't that be lovely for a user?

I suspect it would be a nice model for a hw accelerator too. If you
have full queues or have problems allocating new memory or whatever,
you just let the code fall back to the synchronous interface.

> Trust me, I have whole list of things I don't like about the
> API myself, it's not exacty ideal for HW acceleration  either.

That';s the thing. It's actively detrimental for "I have no HW acceleration".

And apparently it's not optimal for you guys either.

> But the point is - there are those case where you _don't_ know and
> _that_ is what the Crypto API is for. And just generally, crypto
> really _should_ be switchable.

It's very much not what wireguard does.

And honestly, most of the switchable ones have caused way more
security problems than they have "fixed" by being switchable.

                 Linus
