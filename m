From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 28 Oct 2013 16:40:13 +0100
Message-ID: <2049321.gMV6JUDze7@tauon>
References: <2579337.FPgJGgHYdz@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58179 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3J1Pke (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Oct 2013 11:40:34 -0400
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S1A2> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 28 Oct 2013 16:40:20 +0100
In-Reply-To: <2579337.FPgJGgHYdz@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 11. Oktober 2013, 20:38:51 schrieb Stephan Mueller:

Hi Ted,

>Hi,
>
>the CPU Jitter RNG [1] is a true random number generator that is
>intended to work in user and kernel space equally well on a large
>number of different CPUs. The heart of the RNG is about 30 lines of
>code. The current implementation allows seamless hooking into the
>kernel crypto API as well as the Linux /dev/random driver. With its
>inherent non- blocking behavior, it could solve the problem of a
>blocking /dev/random.
>
>Over the last months, new tests were executed. The list of tests now
>cover all major operating systems and CPU types as well as microkernels
>of NOVA, Fiasco.OC and Pistacio. More than 200 different systems are
>tested. And for those, the tests show that the Jitter RNG produces
>high- quality output. See [2] appendix F for details.

Apart from adding more test results from more systems (now including 
Windows), I added more updates:

- The structure of the Linux kernel code is updated such that the common 
C code can go to straight to the lib/ directory or any other directory 
that seems suitable for common code. If it is of help, I can create a 
patch file to add the CPU Jitter RNG to the Linux kernel code instead of 
manually copying into a kernel tree for testing it with random.c.

- Based on Sandy Harris' discussion in 
http://permalink.gmane.org/gmane.comp.encryption.general/16219, the 
patch for random.c is updated that the initialization function of the 
entropy pools init_std_data now contains a call to the CPU Jitter RNG to 
mix in 256 bits of entropy when the entropy pool is filled.

If it is accepted that the CPU Jitter RNG delivers entropy, the latter 
update may now allow us to get rid of storing the seed file during 
shutdown and restoring it during the next boot sequence.

Please see the latest patch to random.c in the file patches/linux-3.11-
random.patch delivered with [1].

Ciao
Stephan

[1] http://www.chronox.de/jent/jitterentropy-20131028.tar.bz2
