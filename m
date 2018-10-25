Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:55895 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbeJZIWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 04:22:16 -0400
MIME-Version: 1.0
References: <20181018145712.7538-1-Jason@zx2c4.com> <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch> <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
 <20181025224426.GC6276@lunn.ch>
In-Reply-To: <20181025224426.GC6276@lunn.ch>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 26 Oct 2018 01:47:21 +0200
Message-ID: <CAHmME9pf=tCd=RKPTCpYuHLPkYqQwwr3LXEHP+_WXJ7DNjueZQ@mail.gmail.com>
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

On Fri, Oct 26, 2018 at 12:44 AM Andrew Lunn <andrew@lunn.ch> wrote:
> Out of tree is important here. To some degree, mainline does not care
> about out of tree drivers. Putting in a bandaid for them does not help
> get them fixed.
>
> I would drop this bandaid. If the Android community decides to move
> wireguard from mainline into their fork, they can put the bandaid back
> in again, or get the driver fixed.

No out-of-tree is really not important here, and sorry if mentioning
that in my explanation was distracting and caused you to
misunderstand. The issue isn't the crazy wireless driver; the issue is
that suspend on Android happens all the time, and the entire Android
way of using Linux is centered around non-stop suspending, with
triggers to wake up (wifi drivers, for example, like the out-of-tree
qcacld one, but presumably in tree ones too), and ways of controlling
when it goes to sleep (screen blanking, wakelocks, etc). The Android
model of Linux revolves around this, and hence the suspend semantics
for WireGuard respect this model and adjust accordingly, using the
appropriate CONFIG_ANDROID to determine which model we're operating
under. This is not a bandaid, and it doesn't have to do with forks of
the Linux kernel.

Jason
