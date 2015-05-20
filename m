From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v7 0/5] Seeding DRBG with more entropy
Date: Wed, 20 May 2015 19:44:08 +0200
Message-ID: <1693038.ndeE0L22jl@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58031 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbbETRsc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 13:48:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

as of now, the DRBG is only seeded from get_random_bytes. In various
circumstances, the nonblocking_pool behind get_random_bytes may not be fully
seeded from hardware events at the time the DRBG requires to be seeded.
Based on the discussion in [1], the DRBG seeding is updated such that it
does not completely rely on get_random_bytes any more.

The seeding approach can be characterized as follows:

1. pull buffer of size entropy + nonce from get_random_bytes

2. pull another buffer of size entropy + nonce from my Jitter RNG

3. concatenate both buffers

4. seed the DRBG with the concatenated buffer

5. trigger the async invocation of the blocking API for accessing
   the nonblocking pool with a buffer of size entropy

6. return the DRBG instance to the caller without waiting for the completion
   of step 5

7. at some point in time, the blocking API returns with a full buffer
   which is then used to re-seed the DRBG

This way, we will get entropy during the first initialization without
blocking.

The patch set adds a blocking API to access the nonblocking pool to wait
until the nonblocking pool is initialized.

Note: the DRBG and Jitter RNG patches are against the current cryptodev-2.6
tree.

The new Jitter RNG is an RNG that has large set of tests and was presented on
LKML some time back. After speaking with mathematicians at NIST, that Jitter
RNG approach would be acceptable from their side as a noise source. Note, I
personally think that the Jitter RNG has sufficient entropy in almost all
circumstances (see the massive testing I conducted on all more widely used
CPUs as shown in [2]).

Changes v7:
* patch 01: Catch ERESTARTSYS error for wait_event_interruptible
* patch 03: move the cancel invocation to drbg_uninstantiate to ensure that
  the ->fini function pointer is not yet invoked before the cancel is completed.
  As the cancel operation may potentially invoke crypto operations, the
  cipher state must be available.
* patch 04: deallocate Jitter RNG after nonblocking_pool is fully initialized.
  The change implies that regardless of the state of the nonblocking_pool, the
  Jitter RNG is used for the initial seeding in any case and only dropped for
  later reseeding operations.

Changes v6:
* patch 01: simplify patch by just adding a blocking API call to random.c as
  suggested by Herbert Xu.
* patch 03: move the async operation into this patch: the DRBG is in control
  of the async work.

Changes v5:
* drop patch 01 and therefore drop the creation of a kernel pool
* change patch 02 to use the nonblocking pool and block until the nonblocking
  pool is initialized or until the cancel operation is triggered.

Changes v4:
* Patch 02: Change get_blocking_random_bytes_cb to allow callers to call it
  multiple times without re-initializing the work data structure. Furthermore,
  only change the pointers to the output buffer and callback if work is not
  pending to avoid race conditions.
* Patch 04: No canceling of seeding during drbg_seed as the invocation of
  get_blocking_random_bytes_cb can now be done repeatedly without
  re-initializing the work data structure.

Changes v3:
* Patch 01: Correct calculation of entropy count as pointed out by Herbert Xu
* Patch 06: Correct a trivial coding issue in jent_entropy_init for
  checking JENT_EMINVARVAR reported by cppcheck

Changes v2:
* Use Dual BSD/GPL license in MODULE_LICENSE as suggested by
  Paul Bolle <pebolle@tiscali.nl>
* Patch 05, drbg_dealloc_state: only deallocate Jitter RNG if one was
  instantiated in the first place. There are two main reasons why the Jitter RNG
  may not be allocated: either it is not available as kernel module/in vmlinuz
  or during init time of the Jitter RNG, the performed testing shows that the
  underlying hardware is not suitable for the Jitter RNG (e.g. has a too coarse
  timer).


[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg13891.html

[2] http://www.chronox.de/jent.html

 crypto/Kconfig         |  10 +
 crypto/Makefile        |   2 +
 crypto/drbg.c          | 143 ++++++--
 crypto/jitterentropy.c | 909 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c       |   4 +
 drivers/char/random.c  |  18 +
 include/crypto/drbg.h  |   5 +
 include/linux/random.h |   1 +
 8 files changed, 1065 insertions(+), 27 deletions(-)
 create mode 100644 crypto/jitterentropy.c

-- 
2.1.0
