Return-Path: <SRS0=oSB4=NG=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60528 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbeJZVqV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Oct 2018 17:46:21 -0400
Date: Fri, 26 Oct 2018 09:09:14 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andrew Lunn <andrew@lunn.ch>, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
Message-ID: <20181026130914.GA8279@thunk.org>
References: <20181018145712.7538-1-Jason@zx2c4.com>
 <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch>
 <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
 <20181025224426.GC6276@lunn.ch>
 <CAHmME9pf=tCd=RKPTCpYuHLPkYqQwwr3LXEHP+_WXJ7DNjueZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pf=tCd=RKPTCpYuHLPkYqQwwr3LXEHP+_WXJ7DNjueZQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 26, 2018 at 01:47:21AM +0200, Jason A. Donenfeld wrote:
> when it goes to sleep (screen blanking, wakelocks, etc). The Android
> model of Linux revolves around this, and hence the suspend semantics
> for WireGuard respect this model and adjust accordingly, using the
> appropriate CONFIG_ANDROID to determine which model we're operating
> under. This is not a bandaid, and it doesn't have to do with forks of
> the Linux kernel.

If that's what you are trying to conditionalize, why don't use
CONFIG_PM_AUTOSLEEP?  That way if there are other systems that want to
use the Android wakelocks style of suspend management, your code will
DTRT, as opposed to depending on CONFIG_ANDROID.

						- Ted
