From: Stephan Mueller <smueller@chronox.de>
Subject: Re: hwrng: Some concerns about add_hwgenerator_randomness
Date: Mon, 23 Nov 2015 12:32:20 +0100
Message-ID: <7284232.Rfr2UkYBuS@tauon.atsec.com>
References: <CAFtRNNz9mdXuL-+EY=pqSpnza2RMJjoU0X+Y06ZRWgEEmsyXVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, mpm@selenic.com,
	herbert@gondor.apana.org.au, Theodore Ts'o <tytso@mit.edu>
To: Nick Kossifidis <mickflemm@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34543 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbbKWLcY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2015 06:32:24 -0500
In-Reply-To: <CAFtRNNz9mdXuL-+EY=pqSpnza2RMJjoU0X+Y06ZRWgEEmsyXVg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 22. November 2015, 02:15:12 schrieb Nick Kossifidis:

Hi Nick,

>Hello all,
>
>I've been doing some reading on hw_random core and the drivers that
>use it and it seems that three of them use the quality parameter on
>the hwrng struct. When a driver sets this value, it ends up directly
>on credit_entropy_bits in random through add_hwgenerator_randomness
>and there is no way of disabling this behavior.

IIRC, you can disable or alter the quality value them using the kernel command 
line.
>
>Even if the user sets hw_random's default_quality to 0 (the
>default/safe value), the value on the hwrng struct overrides it:
>
>hw_random/core.c:
>current_quality = rng->quality ? : default_quality;

Looking at that code, I would think that this is wrong as this overwrites the 
kernel command line option.
>
>The three drivers that set rng->quality are:
>
>virtio-rng: sets it to 1000
>chaoskey: sets it to 1024 + 1023 (!) which gets re-set to 1024 in hwrng_init
>zcrypt: sets it to 900 by default but provides a module option to
>disable this behavior and set it to 0 (so that's an exception)
>
>I suggest to use the quality parameter of hwrng as "minimum entropy"
>or "guaranteed entropy" of the hwrng and if default_quality (the value
>set by the user) is larger than this, use it as an upper boundary
>(because the device can't "guarantee" more entropy), else If
>default_quality is less than this or zero, use default_quality
>instead. Do you agree with this, should I send a patch for it ?
>
>Also there is another issue when drivers call
>add_hwgenerator_randomness directly, ath9k does this -on
>wireless-testing- to provide random data from its ADC and use the
>wireless card as an entropy source. Other drivers might also do it in
>the future (I couldn't find more users other than hw_random/core.c and
>ath9k for now). Again there is no way to check or override the quality
>parameter passed there and it goes directly to random's
>credit_entropy_bits. Is this function meant to be used by anyone or is
>it an API between hw_random and random only ? The documentation on
>hw_random (it's declared on hw_random.h) hasn't been updated to
>reflect how this function should be used or what restrictions apply to
>the quality parameter when used (the commit log said that developers
>should be careful but nothing specific).
>
>We could have a parameter like "max_hwgenerator_quality" on random
>that makes it possible to filter the quality parameter passed on
>add_hwgenerator_randomness, no matter who uses it.
>
>Finally I suggest that we have an ioctl on random to completely
>disable add_hwgenerator_randomness and that's because if someone wants

Again, I thought you can set that with the kernel command line, provided the 
aforementioned code is changed.

>to use a userspace daemon to seed random through /dev/hwrng by doing
>further statistical analysis/monitoring (e.g. rngd or something
>similar), he/she will be mixing the same data on the pool twice (one
>through hw_random -> add_hwgenerator_randomness -even with zero
>quality- and one trough sysctl). I 'd also like to send a patch for
>this if you agree.
>
>Thanks a lot for your time, have a nice weekend.


Ciao
Stephan
