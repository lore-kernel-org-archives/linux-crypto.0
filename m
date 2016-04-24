From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 0/6] /dev/random - a new approach
Date: Sun, 24 Apr 2016 12:38:54 +0200
Message-ID: <1589319.WyasadRQQe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandyinchina@gmail.com, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert, Ted,

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

Stephan Mueller (6):
  crypto: DRBG - externalize DRBG functions for LRNG
  random: conditionally compile code depending on LRNG
  crypto: Linux Random Number Generator
  crypto: LRNG - enable compile
  crypto: LRNG - hook LRNG into interrupt handler
  hyperv IRQ handler: trigger LRNG

 crypto/Kconfig         |   10 +
 crypto/Makefile        |    1 +
 crypto/drbg.c          |   11 +-
 crypto/lrng.c          | 1743 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/random.c  |    8 +
 drivers/hv/vmbus_drv.c |    3 +
 include/crypto/drbg.h  |    7 +
 include/linux/genhd.h  |    5 +
 include/linux/random.h |    9 +-
 kernel/irq/handle.c    |    1 +
 10 files changed, 1791 insertions(+), 7 deletions(-)
 create mode 100644 crypto/lrng.c

-- 
2.5.5
