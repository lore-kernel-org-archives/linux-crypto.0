Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:42791 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbeJZId7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 04:33:59 -0400
MIME-Version: 1.0
References: <20181018145712.7538-1-Jason@zx2c4.com> <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch> <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
 <20181025223746.GB6276@lunn.ch>
In-Reply-To: <20181025223746.GB6276@lunn.ch>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 26 Oct 2018 01:59:03 +0200
Message-ID: <CAHmME9pZ7qn6nas5=voYcUOrOPPOyo_PS0G=3tTjHgXKn1YujQ@mail.gmail.com>
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

On Fri, Oct 26, 2018 at 12:37 AM Andrew Lunn <andrew@lunn.ch> wrote:
> I can understand that. But on the flip side, CAKE reached something
> like version 19 before it got merged. Wireguard is looking similar.
> An addition like the above, is not controversial. You could submit
> such a single patch in a weeks time when net-next reopens, and
> probably version 1 or 2 will get accepted.

Alright, maybe I'll give it a try that way. Previously, every time I
wanted to send things upstream for WireGuard, I'd be sure to find
other users in the tree of what I was adding, since WireGuard wasn't
ready for patchsets yet. But I guess now that some series have begun,
it's more acceptable to add APIs here and there as you described.

Jason
