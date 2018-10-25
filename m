Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:43366 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbeJZH2S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 03:28:18 -0400
Date: Fri, 26 Oct 2018 00:53:44 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
Message-ID: <20181025225344.GD6276@lunn.ch>
References: <20181018145712.7538-1-Jason@zx2c4.com>
 <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch>
 <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> > > +static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
> > > +             size_t first_len, size_t second_len, size_t third_len,
> > > +             size_t data_len, const u8 chaining_key[NOISE_HASH_LEN])
> > > +{
> > > +     u8 output[BLAKE2S_HASH_SIZE + 1];
> > > +     u8 secret[BLAKE2S_HASH_SIZE];
> > > +
> > > +     WARN_ON(IS_ENABLED(DEBUG) &&
> > > +             (first_len > BLAKE2S_HASH_SIZE ||
> > > +              second_len > BLAKE2S_HASH_SIZE ||
> > > +              third_len > BLAKE2S_HASH_SIZE ||
> > > +              ((second_len || second_dst || third_len || third_dst) &&
> > > +               (!first_len || !first_dst)) ||
> > > +              ((third_len || third_dst) && (!second_len || !second_dst))));
> >
> > Maybe split this up into a number of WARN_ON()s. At the moment, if it
> > fires, you have little idea why, there are so many comparisons. Also,
> > is this on the hot path? I guess not, since this is keys, not
> > packets. Do you need to care about DEBUG here?
> 
> This is on the hot path, actually. Well, it's not on path of data
> packets, but I do consider handshake packets to be fairly "warm".

Hi Jason

So for me, hot path is something called 10 million timers per
second. How often do handshake packets happen?

> I'm not especially keen on splitting that up into multiple warn_ons,
> mostly because if that is ever hint, something is seriously wrong,
> and the whole flow would likely then need auditing anyway.

On the flip side, if you think this is so unlikely, it probably means
it is hard to reproduce. And then you will wish you knew exactly which
triggered. If you can get the disassembly and stack trace you might be
able to figure it out, but have a print could be a lot easier.

Anyway, it was just a suggestion. No worries.

	Andrew
