From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 0/5] /dev/random - a new approach
Date: Thu, 11 Aug 2016 14:24:21 +0200
Message-ID: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, Ted Tso <tytso@mit.edu>
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

Changes v6:
* port to 4.8-rc1
* add missing memzero_explicit to ChaCha20 DRNG
* use kernel-doc documentation style
* use of min3 in lrng_get_pool to beautify code
* prevent fast noise sources from dominating slow noise sources
  in case of /dev/random
* set read wakeup threshold to 64 bits to comply with legacy /dev/random
* simplify the interrupt to entropy amount conversion code
* move wakeup call of entropy-providers to a code location where /dev/urandom
  will benefit from the wake up as well (i.e. when the primary DRBG entropy
  runs low because of /dev/urandom reseeds, the entropy provider is woken up)
* inject current time into primary DRBG at the time of seeding from noise
  sources (suggested by Sandy Harris)

Changes v5:
* fix treating LRNG_POOL_SIZE_BITS as entropy value in lrng_get_pool
* use CTR DRBG with AES256 as default due to its superior speed -- on X86_64
  executing within a KVM I get read speeds of up to 850 MB/s now. When using a
  fake NUMA system with 4 nodes on 4 CPUs, I still get up to 430 MB/s read speed
  with four parallel reads. Note, this patch applies to the current
  cryptodev-2.6 tree.
* simplify lrng_get_arch
* use DRBG security strengths as defined in SP800-57 section 5.6.1
* add security strength to /proc/sys/kernel/random/lrng_type
* add ChaCha20 DRNG: in case the kernel crypto API is not compiled, the ChaCha20
  DRNG with the SHA-1 C implementations are used to drive the cryptographic part
  of the LRNG.The ChaCha20 RNG is described in [1]. I analyzed it with a user
  space version of it.
* Editorial changes requested by checkpatch.pl

Changes v4:
* port to 4.7-rc1
* Use classical twisted LFSR approach to collect entropic data as requested by
  George Spelvin. The LFSR is based on a primitive and irreducible polynomial
  whose taps are not too close to the location the current byte is mixed in.
  Primitive polynomials for other entropy pool sizes are offered in the code.
* The reading of the entropy pool is performed with a hash. The hash can be
  specified at compile time. The pre-defined hashes are the same as used for
  the DRBG type (e.g. a SHA256 Hash DRBG implies the use of SHA-256, an AES256
  CTR DRBG implies the use of CMAC-AES).
* Addition of the example defines for a CTR DRBG with AES128 which can be
  enabled during compile time.
* Entropy estimate: one bit of entropy per interrupt. In case a system does
  not have a high-resolution timer, apply 1/10th bit of entropy per interrupt.
  The interrupt estimates can be changed arbitrarily at compile time.
* Use kmalloc_node for the per-NUMA node secondary DRBGs.
* Add boot time entropy tests discussed in section 3.4.3 [1].
* Align all buffers that are processed by the kernel crypto API to an 8 byte
  boundary. This boundary covers all currently existing cipher implementations.

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
  crypto: LRNG - add ChaCha20 support

 crypto/Kconfig           |   10 +
 crypto/Makefile          |    7 +
 crypto/drbg.c            |   11 +-
 crypto/lrng_base.c       | 1960 ++++++++++++++++++++++++++++++++++++++++++++++
 crypto/lrng_kcapi.c      |  167 ++++
 crypto/lrng_standalone.c |  220 ++++++
 drivers/char/random.c    |    8 +
 include/crypto/drbg.h    |    7 +
 include/linux/genhd.h    |    5 +
 include/linux/random.h   |    7 +-
 10 files changed, 2395 insertions(+), 7 deletions(-)
 create mode 100644 crypto/lrng_base.c
 create mode 100644 crypto/lrng_kcapi.c
 create mode 100644 crypto/lrng_standalone.c

-- 
2.7.4
