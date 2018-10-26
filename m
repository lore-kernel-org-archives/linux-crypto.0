Return-Path: <SRS0=oSB4=NG=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:45253 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbeJZIfC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 04:35:02 -0400
MIME-Version: 1.0
References: <20181018145712.7538-1-Jason@zx2c4.com> <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch> <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
 <20181025225344.GD6276@lunn.ch>
In-Reply-To: <20181025225344.GD6276@lunn.ch>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 26 Oct 2018 02:00:04 +0200
Message-ID: <CAHmME9ocqh0CGv2Gnj7k148Pe7nk8rEn2eo47rVZ4d_44RRfCA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
To: Andrew Lunn <andrew@lunn.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andrew,

On Fri, Oct 26, 2018 at 12:53 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > This is on the hot path, actually. Well, it's not on path of data
> > packets, but I do consider handshake packets to be fairly "warm".
>
> So for me, hot path is something called 10 million timers per
> second. How often do handshake packets happen?

I can actually imagine situations in which this rate might happen.
Handshake performance is important.

Jason
