Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:43358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbeJZHTA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 03:19:00 -0400
Date: Fri, 26 Oct 2018 00:44:26 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
Message-ID: <20181025224426.GC6276@lunn.ch>
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

> > > +#if defined(CONFIG_PM_SLEEP) && !defined(CONFIG_ANDROID)
> >
> > I don't see any other code which uses this combination. Why is this
> > needed?
> 
> WireGuard clears private key material before going to sleep, so that
> ephemeral keys never live longer in ram than their expiration date.
> This works well for mostly everything, except Android devices where
> crazy out-of-tree wireless drivers (such as qcacld) will actually wake
> and sleep the phone constantly

Hi Jason

Out of tree is important here. To some degree, mainline does not care
about out of tree drivers. Putting in a bandaid for them does not help
get them fixed.

I would drop this bandaid. If the Android community decides to move
wireguard from mainline into their fork, they can put the bandaid back
in again, or get the driver fixed.

   Andrew
