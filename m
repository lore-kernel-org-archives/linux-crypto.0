From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: get_random_bytes returns bad randomness before seeding is complete
Date: Sun, 04 Jun 2017 07:55:23 +0200
Message-ID: <2038379.NdJWstH9d2@positron.chronox.de>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com> <CACXcFmndxSpytsndqeEsOsyB-nyx_xwBAaG1PMRUmof4U-rDMw@mail.gmail.com> <CAH8yC8m1HRNWTE9=NXkUypMupAoMTCfs2L=EEfwtXpBgT5BrZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59924 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750931AbdFDFz0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 01:55:26 -0400
In-Reply-To: <CAH8yC8m1HRNWTE9=NXkUypMupAoMTCfs2L=EEfwtXpBgT5BrZg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 4. Juni 2017, 00:54:39 CEST schrieb Jeffrey Walton:

Hi Jeffrey,

> On Sat, Jun 3, 2017 at 5:45 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
> > ...
> > Of course this will fail on systems with no high-res timer. Are there
> > still some of those? It might be done in about 1000 times as long on a
> > system that lacks the realtime library's nanosecond timer but has the
> > Posix standard microsecond timer, implying a delay time in the
> > milliseconds. Would that be acceptable in those cases?
> 
> A significant portion of the use cases should include mobile devices.
> Device sales outnumbered desktop and server sales several years ago.
> 
> Many devices are sensor rich. Even the low-end ones come with
> accelorometers for gaming. A typical one has 3 or 4 sensors, and
> higher-end ones have 7 or 8 sensors. An Evo 4G has 7 of them.
> 

I think those devices are covered with the kernels 4.8+. That kernel uses 
solely interrupts as noise source for the first stage we talk about here.

Not having done any particular measurements with the latest kernels on mobile 
devices, but based on my experience with my LRNG assessment, I could fathom 
that mobile devices have a fully seeded ChaCha20 DRNG before user space 
starts.

Just to give an illustration: I have a Lenovo T540 which receives more than 
256 interrupts before late_initcall. On all system with a high-res timer, each 
interrupt will give more than one bit of entropy. Conversely, on my MacBook 
Pro 2015,  at late_initcall the kernel received less than 100 interrupts. In a 
KVM guest with very little devices, I also have some 100 interrupts before 
late_initcall. These measurements are taken with the same kernel and same 
kernel configs.

Ciao
Stephan
