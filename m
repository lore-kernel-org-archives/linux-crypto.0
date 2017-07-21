From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Fri, 21 Jul 2017 17:17:05 +0200
Message-ID: <4074127.U4nTXhg6YI@tauon.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <2787001.lEj6P09Sfm@tauon.chronox.de> <CAK8P3a2+t1Wy1vgz-ie4h=Epsdy2hrM2ycmEsFptwNqwJ57CCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2+t1Wy1vgz-ie4h=Epsdy2hrM2ycmEsFptwNqwJ57CCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 21. Juli 2017, 17:09:11 CEST schrieb Arnd Bergmann:

Hi Arnd,

> On Fri, Jul 21, 2017 at 10:57 AM, Stephan Müller <smueller@chronox.de> 
wrote:
> > Am Freitag, 21. Juli 2017, 05:08:47 CEST schrieb Theodore Ts'o:
> >> Um, the timer is the largest number of interrupts on my system.  Compare:
> >>             CPU0       CPU1       CPU2       CPU3
> >>  
> >>  LOC:    6396552    6038865    6558646    6057102   Local timer
> >>  interrupts
> >> 
> >> with the number of disk related interrupts:
> >>  120:      21492     139284      40513    1705886   PCI-MSI 376832-edge
> >> 
> >> ahci[0000:00:17.0]
> > 
> > They seem to be not picked up with the add_interrupt_randomness function.
> 
> On x86, the local APIC timer has some special handling in
> arch/x86/entry/entry_64.S that does not go through handle_irq_event().
> 
> I would assume that this is different when you boot with the "noapictimer"
> option and use the hpet clockevent instead.
> 
> On other architectures, the timer interrupt is often handled as a regular
> IRQ as well.

Thank you for the hint.

Yet, I would think that timer interrupts can be identified by 
add_interrupt_randomness, either by the IRQ or the stuck test that was is 
suggested with the LRNG patch set.

Ciao
Stephan
