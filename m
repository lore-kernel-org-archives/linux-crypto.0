Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CA5C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 21:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F70A2240D
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 21:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="PVpEx54f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfKSVnc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 16:43:32 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:52907 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfKSVnc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 16:43:32 -0500
Date:   Tue, 19 Nov 2019 21:43:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1574199809;
        bh=Bk5Tq16bY9GDyfLBVQuefbtFYtwGNwRhj3Y+kpKejv4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=PVpEx54fXcWYaFeLradgHM/WCays8KLYQgJJm3dMEgh6HdazHciuZQGJeIGaul+f1
         G+BlFdM8wbG5EHDWgYjnYviijnAo5Fy1Nl2wYnTUIC5NBlmXB+LLPX+TQ83F4ZuThU
         haqEkKqdVnKwqQVugvTCWbG9o7DmY3HQg0IzRwbY=
To:     Eric Biggers <ebiggers@kernel.org>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for WireGuard
Message-ID: <lrGGVxMWv6iZgJdHE034NrDe1vALt5cBUqfdR_sVoWBeyljevKyV-OuhYsVDLdRYd0KQix_oxneCkXLgZiqfgiYzrhnuUlS8_FOYFuoTY2I=@protonmail.ch>
In-Reply-To: <20191119162311.GA819@sol.localdomain>
References: <20191108122240.28479-1-ardb@kernel.org>
 <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
 <20191115090921.jn45akou3cw4flps@gondor.apana.org.au>
 <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
 <CAKv+Gu96xbhS+yHbEjx6dD-rOcB8QYp-Gnnc3WMWfJ9KVbJzcg@mail.gmail.com>
 <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
 <20191119162311.GA819@sol.localdomain>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tuesday, November 19, 2019 4:23 PM, Eric Biggers <ebiggers@kernel.org> w=
rote:

> On Tue, Nov 19, 2019 at 04:44:11PM +0100, Jason A. Donenfeld wrote:
>
> > > So for future changes, could we please include performance numbers
> > > based on realistic workloads?
> >
> > Yea I share your concerns here. From preliminary results, I think the
> > Poly1305 code will be globally better, and I don't think we'll need an
> > abundance of discussion about it.
> > The ChaCha case is more interesting. I'll submit this with lots of
> > packet-sized microbenchmarks, as well as on-the-wire WireGuard
> > testing. Eric - I'm guessing you don't care too much about Adamantium
> > performance on x86 where people are probably better off with AES-XTS,
> > right? Are there other specific real world cases we care about? IPsec
> > is another one, but those concerns, packet-size wise, are more or less
> > the same as for WireGuard. But anyway, we can cross this bridge when
> > we come to it.
>
> I'd like for Adiantum to continue to be accelerated on x86, but it doesn'=
t have
> to squeeze out all performance possible on x86, given that hardware AES s=
upport
> is available there so most people will use that instead. So if e.g. the C=
haCha
> implementation is still AVX2 accelerated, but it's primarily optimized fo=
r
> networking packets rather than disk encryption, that would probably be fi=
ne.
>
> -   Eric

I'm interested in using Adamantium on x86 and I hope that you folks won't c=
ripple it :(

Jordan
