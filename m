From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v11 0/5] /dev/random - a new approach
Date: Sun, 14 May 2017 16:26:49 +0200
Message-ID: <7746835.7W6fIIgSam@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

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

The LRNG has a flexible design by allowing an easy replacement of the
deterministic random number generator component. Currently implemented DRNGs
are an SP800-90A DRBG and a ChaCha20 DRNG.

[1] http://www.chronox.de/lrng.html

Changes v11 (compared to v9):
* port to 4.12-rc1
* contintionally compile JitterRNG code depending on CONFIG_CRYPTO_JITTERENTROPY
* update error code path when lrng_hash_buffer fails to report the successfully
  read entropy
* remove LRNG_DRBG_BLOCKLEN_BYTES in favor of LRNG_DRBG_BLOCKSIZE
* add get_random_u64 and get_random_u32 from legacy /dev/random to prevent
  any modifications of random.c
* move LRNG to drivers/char/
* wakeup user space writers only when entropy in pool is low (not when primary
  DRBG entropy is low)
* LFSR alteration to space the processed words 67 words apart to counter
  polynomial taps that are close together which may be affected by dependencies
* Always mix in an interrupt time stamp even when considered stuck, just do not
  increment number of collected interrupts used to determine the entropy content

Stephan Mueller (5):
  crypto: DRBG - externalize DRBG functions for LRNG
  random: conditionally compile code depending on LRNG
  Linux Random Number Generator
  LRNG - enable compile
  LRNG - add ChaCha20 support

 crypto/drbg.c                  |   11 +-
 drivers/char/Kconfig           |    9 +
 drivers/char/Makefile          |   15 +-
 drivers/char/lrng_base.c       | 2283 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/lrng_kcapi.c      |  173 +++
 drivers/char/lrng_standalone.c |  325 ++++++
 include/crypto/drbg.h          |    7 +
 include/linux/genhd.h          |    5 +
 8 files changed, 2821 insertions(+), 7 deletions(-)
 create mode 100644 drivers/char/lrng_base.c
 create mode 100644 drivers/char/lrng_kcapi.c
 create mode 100644 drivers/char/lrng_standalone.c

-- 
2.9.3
