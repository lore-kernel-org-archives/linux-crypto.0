Return-Path: <SRS0=oSB4=NG=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:56907 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbeJZXQ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 19:16:26 -0400
MIME-Version: 1.0
References: <20181018145712.7538-1-Jason@zx2c4.com> <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch> <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
 <20181025224426.GC6276@lunn.ch> <CAHmME9pf=tCd=RKPTCpYuHLPkYqQwwr3LXEHP+_WXJ7DNjueZQ@mail.gmail.com>
 <20181026130914.GA8279@thunk.org>
In-Reply-To: <20181026130914.GA8279@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 26 Oct 2018 16:38:52 +0200
Message-ID: <CAHmME9p+BsR8O67V=iJcXyKcFQnAqH8mYFmO02O-1=K3raXsrQ@mail.gmail.com>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
To: "Theodore Ts'o" <tytso@mit.edu>, Andrew Lunn <andrew@lunn.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Ted,

On Fri, Oct 26, 2018 at 3:09 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> If that's what you are trying to conditionalize, why don't use
> CONFIG_PM_AUTOSLEEP?  That way if there are other systems that want to
> use the Android wakelocks style of suspend management, your code will
> DTRT, as opposed to depending on CONFIG_ANDROID.

That's a terrific idea; thanks for the suggestion. I'll make that
change for the next patchset version.

Jason
