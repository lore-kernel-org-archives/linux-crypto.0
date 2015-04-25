From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 0/6] Seeding DRBG with more entropy
Date: Sat, 25 Apr 2015 17:40 +0200
Message-ID: <1631051.qmxH657I75@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Paul Bolle <pebolle@tiscali.nl>, andreas.steffen@strongswan.org,
	tytso@mit.edu, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

5. trigger the async invocation of the in-kernel /dev/random with a buffer of
   size entropy

6. return the DRBG instance to the caller without waiting for the completion
   of step 5

7. at some point in time, the in-kernel /dev/random returns with a full buffer
   which is then used to re-seed the DRBG

This way, we will get entropy during the first initialization without
blocking.

The patch set adds an in-kernel /dev/random equivalent that was discussed with
Ted Ts'o last July -- see [2] and [3]. A test module for testing the
asynchronous operation of the in-kernel /dev/random is given with the code
below.

Ted: shall we really create and maintain a new entropy pool (the kernel_pool),
or should the in-kernel /dev/random logic draw directly from the input_pool?
In other words, shall we drop the first patch and update the 2nd patch to
use input_pool? Also, I would not recommend using the blocking_pool as this
would mix kernel and user land operation.

Note: the DRBG and Jitter RNG patches are against the current cryptodev-2.6
tree.

The new Jitter RNG is an RNG that has large set of tests and was presented on
LKML some time back. After speaking with mathematicians at NIST, that Jitter
RNG approach would be acceptable from their side as a noise source. Note, I
personally think that the Jitter RNG has sufficient entropy in almost all
circumstances (see the massive testing I conducted on all more widely used
CPUs as shown in [4]).


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

[2] https://lkml.org/lkml/2014/4/27/174

[3] http://comments.gmane.org/gmane.linux.kernel/1701117

[4] http://www.chronox.de/jent.html


Stephan Mueller (6):
  random: Addition of kernel_pool
  random: Async and sync API for accessing kernel_pool
  crypto: drbg - prepare for async seeding
  crypto: drbg - add async seeding operation
  crypto: drbg - use Jitter RNG to obtain seed
  crypto: add jitterentropy RNG

 crypto/Kconfig         |  10 +
 crypto/Makefile        |   2 +
 crypto/drbg.c          | 161 +++++++--
 crypto/jitterentropy.c | 909 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c       |   4 +
 drivers/char/random.c  | 168 ++++++++-
 include/crypto/drbg.h  |   4 +
 include/linux/random.h |  20 ++
 8 files changed, 1238 insertions(+), 40 deletions(-)
 create mode 100644 crypto/jitterentropy.c

---
/*
 * Test module for verifying the correct operation of the
 * in-kernel /dev/random handling
 *
 * Use: compile, load into the kernel and observe dmesg
 *
 * Written by: Stephan Mueller <smueller@chronox.de>
 * Copyright (c) 2014
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, and the entire permission notice in its entirety,
 *    including the disclaimer of warranties.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior
 *    written permission.
 *
 * ALTERNATIVELY, this product may be distributed under the terms of
 * the GNU General Public License, in which case the provisions of the GPL are
 * required INSTEAD OF the above restrictions.  (This clause is
 * necessary due to a potential bad interaction between the GPL and
 * the restrictions contained in a BSD-style copyright.)
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
 * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

#include <linux/random.h>
#include <linux/module.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
MODULE_DESCRIPTION("Test module for verifying the correct operation of async LRNG operation");

static struct random_work my_work;
static struct random_work my_work1;
static struct random_work my_work2;
static struct random_work my_work3;
static struct random_work my_work4;
static struct random_work my_work5;
static struct random_work my_work6;
static struct random_work my_work7;
static struct random_work my_work8;
static struct random_work my_work9;
#define LEN 10
static char buffer[LEN];

static char *string = "a";
static char *string2 = "b";
static char *string3 = "c";
static char *string4 = "d";
static char *string5 = "e";
static char *string6 = "f";
static char *string7 = "g";
static char *string8 = "h";
static char *string9 = "i";

void lrng_cb(void *buf, ssize_t buflen, void *private)
{
	printk("received %d bytes for %s\n", (int)buflen, (char *)private);
}

static void cn(struct random_work *work)
{
	get_blocking_random_bytes_cancel(work);
	cancel_work_sync(&work->rw_work);
}

static int __init lrng_init(void)
{
	get_blocking_random_bytes_cb(NULL, &my_work, buffer, LEN,
				     string, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work1, buffer, LEN,
				     string, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work2, buffer, LEN,
				     string2, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work3, buffer, LEN,
				     string3, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work4, buffer, LEN,
				     string4, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work5, buffer, LEN,
				     string5, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work6, buffer, LEN,
				     string6, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work7, buffer, LEN,
				     string7, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work8, buffer, LEN,
				     string8, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work9, buffer, LEN,
				     string9, lrng_cb);

	/*
	 * cancel one work to see that work can be canceled independent from
	 * others
	 */
	cn(&my_work);
	/* try again to verify that double cancellation is harmless */
        cn(&my_work);

	return 0;
}

static void __exit lrng_exit(void)
{
	cn(&my_work1);
	cn(&my_work2);
	cn(&my_work3);
	cn(&my_work4);
	cn(&my_work5);
	cn(&my_work6);
	cn(&my_work7);
	cn(&my_work8);
	cn(&my_work9);
}

module_init(lrng_init);
module_exit(lrng_exit);
-- 
2.1.0
