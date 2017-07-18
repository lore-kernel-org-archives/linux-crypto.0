From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Tue, 18 Jul 2017 16:37:11 +0200
Message-ID: <1780567.qGdv4EjEMp@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <150039607.torZXMN7kc@positron.chronox.de> <20170718085212.GB25267@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170718085212.GB25267@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 18. Juli 2017, 10:52:12 CEST schrieb Greg Kroah-Hartman:

Hi Greg,

> 
> > I have stated the core concerns I have with random.c in [1]. To remedy
> > these core concerns, major changes to random.c are needed. With the past
> > experience, I would doubt that I get the changes into random.c.
> > 
> > [1] https://www.spinics.net/lists/linux-crypto/msg26316.html
> 
> Evolution is the correct way to do this, kernel development relies on
> that.  We don't do the "use this totally different and untested file
> instead!" method.

I am not sure I understand your reply. The offered patch set does not rip out 
existing code. It adds a replacement implementation which can be enabled 
during compile time. Yet it is even disabled per default (and thus the legacy 
code is compiled).

I see such a development approach in numerous different kernel core areas: 
memory allocators (SLAB, SLOB, SLUB), process schedulers, IRQ schedulers.

What is so different for the realm of RNGs?

Ciao
Stephan
