From: Jeffrey Walton <noloader@gmail.com>
Subject: JZ4780 RNG and entropy depletion
Date: Sun, 14 Aug 2016 01:33:32 -0400
Message-ID: <CAH8yC8=S7ZaK9o+VCjRrpF0gNwTEL9a-SfQmFkjt97j6h34kBw@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38038 "EHLO
	mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbcHNJVh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Aug 2016 05:21:37 -0400
Received: by mail-it0-f53.google.com with SMTP id c13so7890382ith.1
        for <linux-crypto@vger.kernel.org>; Sun, 14 Aug 2016 02:21:37 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Everyone,

I have a MIPSEL ci20 dev board for testing. The board has a hardware
based rng, but its suffering entropy depletion. I have Debian's
rng-tools package installed.

The board lacks /dev/hwrng. /dev/random blocks indefinitely after
draining the device. "Indefinitely" may not be accurate, but I killed
a program that waited over 4 hours for 16 bytes after draining
/dev/random.

The ci20's documentation is a bit scant, but it can be found at
http://mipscreator.imgtec.com/CI20/hardware/soc/JZ4780_PM.pdf. I'm not
sure what the output rate is, but it seems to be capable of one
machine word (4 bytes) every few milliseconds. Without a delay, I can
see values being shifted into the register mapped at 0x100000DC.

I have a few questions:

  * Is there a driver for JZ4780 rng?
  * Is there a particular package for the driver that needs to be installed?
  * What causes/triggers /dev/hwrng to replenish /dev/random?

Thanks in advance.

Jeff
