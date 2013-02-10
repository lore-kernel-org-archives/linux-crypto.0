From: Jeff Epler <jepler@unpythonic.net>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Sun, 10 Feb 2013 09:53:17 -0600
Message-ID: <20130210155317.GA3070@unpythonic.net>
References: <51157686.9000404@chronox.de>
 <20130209180629.GD8091@thunk.org>
 <20130210015751.GA13690@unpythonic.net>
 <5117969A.1080909@chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5117969A.1080909@chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

OK, my original reading of the mixing code was not accurate.  This time
around, I started with the original posted tarball and turned the use of
the CPU clock into a very simple and clearly bad "clock" that will
provide no entropy.


--- jitterentropy-0.1/jitterentropy.c   2013-02-08 15:22:22.000000000 -0600
+++ jitterentropy-0.1-me/jitterentropy.c        2013-02-10 09:45:07.000000000 -0600
@@ -270,12 +270,13 @@
 typedef uint64_t __u64;
 
 static int fips_enabled = 0;
-#define jitterentropy_schedule sched_yield()
+#define jitterentropy_schedule (0)
 static inline void jitterentropy_get_nstime(__u64 *out)
 {
-       struct timespec time;
-       if (clock_gettime(CLOCK_REALTIME, &time) == 0)
-               *out = time.tv_nsec;
+        static __u64 t = 0;
+        const __u64 delta2 = 257;
+        static __u64 delta;
+        *out = (t += (delta += delta2));
 }
 
 /* note: these helper functions are shamelessly stolen from the kernel :-) */


This give a generator that has Entropy = 7.999907 bits per byte
and fails 6 in 10000 FIPS 140-2 tests.  It also passes some (but not
all) dieharder tests.

Jeff
