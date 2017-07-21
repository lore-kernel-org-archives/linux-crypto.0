From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Fri, 21 Jul 2017 17:09:11 +0200
Message-ID: <CAK8P3a2+t1Wy1vgz-ie4h=Epsdy2hrM2ycmEsFptwNqwJ57CCQ@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <5238256.jqB5BlnSCf@positron.chronox.de>
 <20170721030846.m2r3ix4s2modahsw@thunk.org> <2787001.lEj6P09Sfm@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2787001.lEj6P09Sfm@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 21, 2017 at 10:57 AM, Stephan M=C3=BCller <smueller@chronox.de>=
 wrote:
> Am Freitag, 21. Juli 2017, 05:08:47 CEST schrieb Theodore Ts'o:

>> Um, the timer is the largest number of interrupts on my system.  Compare=
:
>>
>>             CPU0       CPU1       CPU2       CPU3
>>  LOC:    6396552    6038865    6558646    6057102   Local timer interrup=
ts
>>
>> with the number of disk related interrupts:
>>
>>  120:      21492     139284      40513    1705886   PCI-MSI 376832-edge
>> ahci[0000:00:17.0]
>
> They seem to be not picked up with the add_interrupt_randomness function.

On x86, the local APIC timer has some special handling in
arch/x86/entry/entry_64.S that does not go through handle_irq_event().

I would assume that this is different when you boot with the "noapictimer"
option and use the hpet clockevent instead.

On other architectures, the timer interrupt is often handled as a regular
IRQ as well.

       Arnd
