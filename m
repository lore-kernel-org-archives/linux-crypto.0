From: Stephan Mueller <smueller@chronox.de>
Subject: Re: JZ4780 RNG and entropy depletion
Date: Mon, 15 Aug 2016 06:58:22 +0200
Message-ID: <1631486.kUYLoWEbIP@tauon.atsec.com>
References: <CAH8yC8=S7ZaK9o+VCjRrpF0gNwTEL9a-SfQmFkjt97j6h34kBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35968 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbcHOE60 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2016 00:58:26 -0400
In-Reply-To: <CAH8yC8=S7ZaK9o+VCjRrpF0gNwTEL9a-SfQmFkjt97j6h34kBw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 14. August 2016, 01:33:32 CEST schrieb Jeffrey Walton:

Hi Jeffrey,

> Hi Everyone,
> 
> I have a MIPSEL ci20 dev board for testing. The board has a hardware
> based rng, but its suffering entropy depletion. I have Debian's
> rng-tools package installed.
> 
> The board lacks /dev/hwrng. /dev/random blocks indefinitely after
> draining the device. "Indefinitely" may not be accurate, but I killed
> a program that waited over 4 hours for 16 bytes after draining
> /dev/random.
> 
> The ci20's documentation is a bit scant, but it can be found at
> http://mipscreator.imgtec.com/CI20/hardware/soc/JZ4780_PM.pdf. I'm not
> sure what the output rate is, but it seems to be capable of one
> machine word (4 bytes) every few milliseconds. Without a delay, I can
> see values being shifted into the register mapped at 0x100000DC.
> 
> I have a few questions:
> 
>   * Is there a driver for JZ4780 rng?

What is the PCI ID?

>   * Is there a particular package for the driver that needs to be installed?
> * What causes/triggers /dev/hwrng to replenish /dev/random?

Using rngd which is triggered by /dev/random automatically when its entropy 
level falls below a threshold.

Ciao
Stephan
