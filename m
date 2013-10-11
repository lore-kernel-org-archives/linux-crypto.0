From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Fri, 11 Oct 2013 20:38:51 +0200
Message-ID: <2579337.FPgJGgHYdz@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59382 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3JKSjE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Oct 2013 14:39:04 -0400
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S151> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Fri, 11 Oct 2013 20:38:55 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the CPU Jitter RNG [1] is a true random number generator that is 
intended to work in user and kernel space equally well on a large number 
of different CPUs. The heart of the RNG is about 30 lines of code. The 
current implementation allows seamless hooking into the kernel crypto 
API as well as the Linux /dev/random driver. With its inherent non-
blocking behavior, it could solve the problem of a blocking /dev/random.

Over the last months, new tests were executed. The list of tests now 
cover all major operating systems and CPU types as well as microkernels 
of NOVA, Fiasco.OC and Pistacio. More than 200 different systems are 
tested. And for those, the tests show that the Jitter RNG produces high-
quality output. See [2] appendix F for details.

When talking with developers from different chip manufactures, I was 
told that even they see the execution timing jitter in their tests and 
cannot eliminate the timing jitter. Nor are they able to explain to 100% 
certainty the root cause of the jitter. Therefore, the noise source 
looks appropriate for general use.

I am asking whether this RNG would good as an inclusion into the Linux 
kernel for:

- kernel crypto API to provide a true random number generator as part of 
this API (see [2] appendix B for a description)

- inclusion into /dev/random as an entropy provider of last resort when 
the entropy estimator falls low.

Patches for both are provided in the source code tarball at [1].

A full description of the RNG together with all testing is provided at 
[2] or [3].

I will present the RNG at the Linux Symposium in Ottawa this year. There 
I can give a detailed description of the design and testing.

[1] http://www.chronox.de

[2] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

[3] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

Ciao
Stephan
