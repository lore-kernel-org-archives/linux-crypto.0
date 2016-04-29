From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 0/5] /dev/random - a new approach
Date: Fri, 29 Apr 2016 08:21:46 +0200
Message-ID: <2346517.m8UHYeMDSf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	joe@perches.com, Pavel Machek <pavel@ucw.cz>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, Ted Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54138 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbcD2GZx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 02:25:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, Ted, Andi,

The following patch set provides a different approach to /dev/random which
I call Linux Random Number Generator (LRNG) to collect entropy within the Linux
kernel. The main improvements compared to the legacy /dev/random is to provide
sufficient entropy during boot time as well as in virtual environments and when
using SSDs. A secondary design goal is to limit the impact of the entropy
collection on massive parallel systems and also allow the use accelerated
cryptographic primitives. Also, all steps of the entropic data processing are
testable. Finally massive performance improvements are visible at /dev/urandom
and get_random_bytes.

The design and implementation is driven by a set of goals described in [1]
that the LRNG completely implements. Furthermore, [1] includes a
comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
AIS20/31.

To Joe Perches: I have not forgotten the request to move the docuementation and
test code into patches for the kernel tree. But I would like first let the dust
settle before trying to integrate them.

To Andi Kleen: Would it be possible that you test the per-NUMA secondary DRBG
code, please? Simply apply the patches, compile the LRNG (found in the
Cryptographic API menuconfig) and then run your performance tests. Note,
I tested the correctness of the implementation on a per-CPU instantiation test
and using the fake-NUMA setup. But I do not have a real NUMA system. You may
see kernel logs when you boot with the kernel command line option of:
dyndbg="file lrng.c line 1-1900 +p"

Changes v3:
* Convert debug printk to pr_debug as suggested by Joe Perches
* Add missing \n as suggested by Joe Perches
* Do not mix in struck IRQ measurements as requested by Pavel Machek
* Add handling logic for systems without high-res timer as suggested by Pavel
  Machek -- it uses ideas from the add_interrupt_randomness of the legacy
  /dev/random implementation
* add per NUMA node secondary DRBGs as suggested by Andi Kleen -- the
  explanation of how the logic works is given in section 2.1.1 of my
  documentation [1], especially how the initial seeding is performed.

Changes v2:
* Removal of the Jitter RNG fast noise source as requested by Ted
* Addition of processing of add_input_randomness as suggested by Ted
* Update documentation and testing in [1] to cover the updates
* Addition of a SystemTap script to test add_input_randomness
* To clarify the question whether sufficient entropy is present during boot
  I added one more test in 3.3.1 [1] which demonstrates the providing of
  sufficient entropy during initialization. In the worst case of no fast noise
  sources, in the worst case of a virtual machine with only very few hardware
  devices, the testing shows that the secondary DRBG is fully seeded with 256
  bits of entropy before user space injects the random data obtained
  during shutdown of the previous boot (i.e. the requirement phrased by the
  legacy /dev/random implementation). As the writing of the random data into
  /dev/random by user space will happen before any cryptographic service
  is initialized in user space, this test demonstrates that sufficient
  entropy is already present in the LRNG at the time user space requires it
  for seeding cryptographic daemons. Note, this test result was obtained
  for different architectures, such as x86 64 bit, x86 32 bit, ARM 32 bit and
  MIPS 32 bit.

[1] http://www.chronox.de/lrng/doc/lrng.pdf

[2] http://www.chronox.de/lrng.html

Stephan Mueller (5):
  crypto: DRBG - externalize DRBG functions for LRNG
  random: conditionally compile code depending on LRNG
  crypto: Linux Random Number Generator
  crypto: LRNG - enable compile
  random: add interrupt callback to VMBus IRQ handler

 crypto/Kconfig         |   10 +
 crypto/Makefile        |    1 +
 crypto/drbg.c          |   11 +-
 crypto/lrng.c          | 1914 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/random.c  |    9 +
 drivers/hv/vmbus_drv.c |    3 +
 include/crypto/drbg.h  |    7 +
 include/linux/genhd.h  |    5 +
 include/linux/random.h |    7 +-
 9 files changed, 1960 insertions(+), 7 deletions(-)
 create mode 100644 crypto/lrng.c

-- 
2.5.5
