From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH][RFC] Tests on 200 different CPUs/Arches and OSes with CPU Jitter RNG (resent)
Date: Mon, 09 Sep 2013 11:31:04 +0200
Message-ID: <1907842.Ud0MaQAcW8@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandy harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vgen.kernel.org>, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55304 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3IIJbO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 05:31:14 -0400
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SDC> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 9 Sep 2013 11:31:05 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

(this is a reply to [3] and possibly an addition to your blog [4])

I prepared a new release of the CPU Jitter RNG available at [1]. The 
core of the RNG remains unchanged. However, there are the following 
changes:

- addition of a patch to integrate the RNG into /dev/random as explained 
in appendix B.3 of [2], although the long-term goal of the RNG is rather 
the integration into the kernel crypto API when considering the Linux 
kernel as outlined in appendix B.1 of [2]

- ensure that the code is compiled without optimization based on the 
reasons outlined in section 5.1 of [2]

- addition of chapter 5.1 to [2] explaining how the entropy is collected

- additional code to execute the CPU Jitter RNG on different OSes 
(specifically AIX, MacOS and z/OS -- other Unixes are good without 
additional changes)

Please note, I will present the RNG with a talk at the Linux Symposium 
in Ottawa this year.

I performed additional testing with a Von-Neumann De-Skew operation as 
defined in RFC 1750 section 5.2.2 showing that this De-Skew operation 
does not make the statistics of the RNG better.

>On Tue, May 21, 2013 at 3:01 PM, Theodore Ts'o <tytso@mit.edu> wrote:


>> I continue to be suspicious about claims that userspace timing
>> measurements are measuring anything other than OS behaviour.


>
>Yes, but they do seem to contain some entropy. See links in the
>original post of this thread, the havege stuff and especially the
>McGuire et al paper.

With the initially shown implementation and documentation I did not 
really show that sufficient entropy is gathered from the CPU execution 
jitter -- i.e. that there is unpredictable jitter in the execution time. 
With a new test I now closed that hole. The newly added test 
measures the entropy gathered during execution jitter collection, i.e. 
heart of the RNG in terms of how much statistical entropy it provides. 
The description of the test is given in section 5.1 of [2]. To ensure 
that the statistical entropy measurements are indeed showing the 
information theoretical entropy, section 4.4 of [2] outlines that 
patterns are not identified in the output of the RNG which would 
diminish the information theoretical entropy compared to the statistical 
entropy.

That test was then executed on about 200 different systems with the 
results given in appendix F of [2]. The table stated there supported by 
the many graphs demonstrates that the CPU Jitter random number generator 
delivers high-quality entropy on:

- a large range of CPUs ranging from embedded systems of MIPS and ARM 
CPUs, covering desktop systems with AMD and Intel x86 32 bit and 64 bit 
CPUs up to server CPUs of Intel Itanium, Sparc, POWER and IBM System Z;

- a large range of operating systems: Linux (including Android), 
OpenBSD, FreeBSD, NetBSD, AIX, OpenIndiana (OpenSolaris), AIX, z/OS;

- a range of different compilers: GCC, Clang and the z/OS C compiler.

The test results show an interesting yet common trend -- i.e. common for 
the different CPU types: the newer the CPU is, the more CPU execution 
time jitter is present.

[2] appendix F.37 contains entropy measurements on different operating 
systems on the very same hardware, indicating that the jitter 
measurements are present regardless of the OS.

With the test results, Ted's concerns should be covered.

[...]



>> For devices like Linux routers, what we desperately need is hardware
>> assist;  [or] mix
>> in additional timing information either at kernel device driver
>> level,
>> or from systems such as HAVEGE.

The concern with HAVEGE is that it is very complex. The implementation 
is far from being straight forward.


>> 
>> What I'm against is relying only on solutions such as HAVEGE or
>> replacing /dev/random with something scheme that only relies on CPU
>> timing and ignores interrupt timing.


>
>My question is how to incorporate some of that into /dev/random.
>At one point, timing info was used along with other stuff. Some
>of that got deleted later, What is the current state? Should we
>add more?

Please see the suggestion for an integration with /dev/random given in 
appendix B.3 of [2]. The source code for the integration is given in 
patches/linux-3.9-random.patch which is described in patches/README. The 
patch only utilizes the CPU Jitter RNG when the entropy in the entropy 
pool falls below the low threshold, i.e. when no entropy from other 
sources is present.

[1] http://www.chronox.de/jent/jitterentropy-20130818.tar.bz2

[2] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

[3] http://www.gossamer-threads.com/lists/linux/kernel/1716565#1716565

[4] https://plus.google.com/u/0/117091380454742934025/posts/SDcoemc9V3J


Ciao
Stephan
