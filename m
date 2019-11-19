Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A72DC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1AB7222AB
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="d0hOyv1O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfKSPoZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:44:25 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:38029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfKSPoZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:44:25 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a5c4fb1f
        for <linux-crypto@vger.kernel.org>;
        Tue, 19 Nov 2019 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=EaSpi3ev2hu2gYauMBq2VFKivkk=; b=d0hOyv
        1OLoC1tk8T+2Jh4pj7fmNrJs9OoebzMl+BErbtOARcTpDHSb7TqHXebLwmWZNF6S
        8dvBgrMYPDF7/6Vohdfy1XnP+TLPblvOvdcoq+Y/faYtayRKtQ5qxzwpGbjIeX0O
        5wbsWq3wQBz33VbfGVNXb6937AEu/MKdlr/9AZZPWT45haPG9rL3ApaOWQIyJhtb
        l8/vyG16sJm9O4XfpUph86/yktk3XV1hVHO+VZwS8FKe91pZGT38YM7VpSmwg/mF
        RF94uK85ntI2aefRG7nShlIRcOQOGZD26J6eEpO75sDpB1lpx4TmuQ+Encmxq+3U
        +iDkpsgnxgz/ZSpA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f76ec426 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 19 Nov 2019 14:51:34 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id n14so19293436oie.13
        for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2019 07:44:23 -0800 (PST)
X-Gm-Message-State: APjAAAW6n7sLiw7nOLrdfVc47pi4o3RZzE6/W8BuNRZb2C+i3JqXxOXB
        GkTaL0DjLhaAguaRlCiIu5sU+9h4gvRksDrgpCw=
X-Google-Smtp-Source: APXvYqx8HPDQWd6XpKquxSK6zbuA2vj8AXStyGEaSUupyK76Ii8GbodZtAHTlIbbuUtD0OgVxWGtwwjy7SjK3e2niYg=
X-Received: by 2002:aca:af0c:: with SMTP id y12mr4874054oie.52.1574178262759;
 Tue, 19 Nov 2019 07:44:22 -0800 (PST)
MIME-Version: 1.0
References: <20191108122240.28479-1-ardb@kernel.org> <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
 <20191115090921.jn45akou3cw4flps@gondor.apana.org.au> <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
 <CAKv+Gu96xbhS+yHbEjx6dD-rOcB8QYp-Gnnc3WMWfJ9KVbJzcg@mail.gmail.com>
In-Reply-To: <CAKv+Gu96xbhS+yHbEjx6dD-rOcB8QYp-Gnnc3WMWfJ9KVbJzcg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 19 Nov 2019 16:44:11 +0100
X-Gmail-Original-Message-ID: <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
Message-ID: <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for WireGuard
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 19, 2019 at 4:34 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> > - Zinc's generic C implementation of poly1305, which is faster and has
> > separate implementations for u64 and u128.

I assume your AndyP comment below didn't apply to this top item here.
This one should be fairly uncontroversial in your opinion, right?

> > - x86_64 ChaCha20 from Zinc. Will be fun to discuss with Martin and Andy.
> > - x86_64 Poly1305 from Zinc.
>
> As I pointed out in the private discussions we had, there are two
> aspects two AndyP's benchmarking that don't carry over 100% to the
> Linux kernel:
> - Every microarchitecture is given equal weight, regardless of the
> likelihood that the code will actually run on it. This makes some
> sense for OpenSSL, I guess, but not for the kernel.
> - Benchmarks are typically based on the performance of the core
> cryptographics transformation rather than a representative workload.
> This is especially relevant for network use cases, where packet sizes
> are not necessarily fixed and usually not a multiple of the block size
> (as opposed to disk encryption, where every single call is the same
> size and a power of 2)
>
> So for future changes, could we please include performance numbers
> based on realistic workloads?

Yea I share your concerns here. From preliminary results, I think the
Poly1305 code will be globally better, and I don't think we'll need an
abundance of discussion about it.

The ChaCha case is more interesting. I'll submit this with lots of
packet-sized microbenchmarks, as well as on-the-wire WireGuard
testing. Eric - I'm guessing you don't care too much about Adamantium
performance on x86 where people are probably better off with AES-XTS,
right? Are there other specific real world cases we care about? IPsec
is another one, but those concerns, packet-size wise, are more or less
the same as for WireGuard. But anyway, we can cross this bridge when
we come to it.


> > - WireGuard! Hurrah!
> >
> I'm a bit surprised that this only appears at the end of your list :-)

Haha, "last but not least" :)

>
> > If you have any feedback on how you'd like this prioritized, please
> > pipe up. For example Dave - would you like WireGuard *now* or sometime
> > later? I can probably get that cooking this week, though I do have
> > some testing and fuzzing of it to do on top of the patches that just
> > landed in cryptodev.
> >
>
> We're at -rc8, and wireguard itself will not go via the crypto tree so
> you should wait until after the merge window, rebase it onto -rc1 and
> repost it.

Thanks, yea, that makes sense. Netdev also has its own merge window
schedule that I should aim to meet. I guess, based on this if I'm
understanding correctly, we're looking at WireGuard for 5.5?

Jason
