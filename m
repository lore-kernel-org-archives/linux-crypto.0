Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:43351 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbeJZHMU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 03:12:20 -0400
Date: Fri, 26 Oct 2018 00:37:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
Message-ID: <20181025223746.GB6276@lunn.ch>
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

> > > +             net_dbg_ratelimited("%s: Could not decrypt invalid cookie response\n",
> > > +                                 wg->dev->name);
> >
> > It might be worth adding a netdev_dbg_ratelimited(), which takes a
> > netdev as its first parameter, just line netdev_dbg().
> 
> That sounds like it could be useful. Though, I'm trying hard to make
> the first patch submission _not_ need to touch any of the rest of the
> networking stack. I've actually got a small list of interesting
> networking stack changes that might be useful for WireGuard, but I
> think I'd prefer to submit these after this is all merged, and each
> one separately for a separate discussion, if that's okay with you.

Hi Jason

I can understand that. But on the flip side, CAKE reached something
like version 19 before it got merged. Wireguard is looking similar.
An addition like the above, is not controversial. You could submit
such a single patch in a weeks time when net-next reopens, and
probably version 1 or 2 will get accepted.

	 Andrew
