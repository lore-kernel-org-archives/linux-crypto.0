From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: drbg - use pragmas for disabling optimization
Date: Tue, 09 Jun 2015 04:08:49 +0200
Message-ID: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
To: herbert@gondor.apana.org.au
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I performed measurements of the upper and lower boundary of the minimum and
Shannon entropy for the RNG before the patch and after the patch. The values
are very similar which demonstrates that the change does not affect the
cryptographic characteristics of the RNG.

The tests are available at:

[1] shows the lower boundary of the fully non-optimized RNG

[2] shows the lower boundary of the RNG with the patch below

[3] shows the upper boundary of the fully non-optimized RNG

[4] shows the upper boundary of the RNG with the patch below

The pictures are fully explained in [5], but the key values are the minimum
and Shannon entropy numbers in the legend of the graphs.
 
[1] http://www.eperm.de/userspace-foldtime-testO0.data-single-time-dist-delta-3036-hist.pdf

[2] http://www.eperm.de/userspace-foldtime-test-pragmas-O2.data-single-time-dist-delta-2370-hist.pdf

[3] http://www.eperm.de/userspace-foldtime-testO0.data-varying-time-dist-delta-7302-hist.pdf

[4] http://www.eperm.de/userspace-foldtime-test-pragmas-O2.data-varying-time-dist-delta-7055-hist.pdf

[5] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

---8<---
Replace the global -O0 compiler flag from the Makefile with GCC
pragmas to mark only the functions required to be compiled without
optimizations.

This patch also adds a comment describing the rationale for the
functions chosen to be compiled without optimizations.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Makefile        |  1 -
 crypto/jitterentropy.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 83b3c44..c842035 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -97,7 +97,6 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
-CFLAGS_jitterentropy.o = -O0
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 20dc178..9ba99e6 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -57,10 +57,6 @@
 #include <linux/crypto.h>
 #include <crypto/internal/rng.h>
 
-#ifdef __OPTIMIZE__
- #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
-#endif
-
 /* The entropy pool */
 struct rand_data {
 	/* all data values that are vital to maintain the security
@@ -188,6 +184,20 @@ static __u64 jent_loop_shuffle(struct rand_data *ec,
  * Noise sources
  ***************************************************************************/
 
+/*
+ * The disabling of the optimizations is performed as documented and assessed
+ * thoroughly in http://www.chronox.de/jent.html. However, instead of disabling
+ * the optimization of the entire C file, only the main functions the jitter is
+ * measured for are not optimized. These functions include the noise sources as
+ * well as the main functions triggering the noise sources. As the time
+ * measurement is done from one invocation of the jitter noise source to the
+ * next, even the execution jitter of the code invoking the noise sources
+ * contribute to the overall randomness as well. The behavior of the RNG and the
+ * statistical characteristics when only the mentioned functions are not
+ * optimized is almost equal to the a completely non-optimized RNG compilation
+ * as tested with the test tools provided at the initially mentioned web site.
+ */
+
 /**
  * CPU Jitter noise source -- this is the noise source based on the CPU
  *			      execution time jitter
@@ -222,6 +232,8 @@ static __u64 jent_loop_shuffle(struct rand_data *ec,
  *
  * @return Number of loops the folding operation is performed
  */
+#pragma GCC push_options
+#pragma GCC optimize ("-O0")
 static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
 			    __u64 *folded, __u64 loop_cnt)
 {
@@ -251,6 +263,7 @@ static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
 	*folded = new;
 	return fold_loop_cnt;
 }
+#pragma GCC pop_options
 
 /**
  * Memory Access noise source -- this is a noise source based on variations in
@@ -279,6 +292,8 @@ static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
  *
  * @return Number of memory access operations
  */
+#pragma GCC push_options
+#pragma GCC optimize ("-O0")
 static unsigned int jent_memaccess(struct rand_data *ec, __u64 loop_cnt)
 {
 	unsigned char *tmpval = NULL;
@@ -318,6 +333,7 @@ static unsigned int jent_memaccess(struct rand_data *ec, __u64 loop_cnt)
 	}
 	return i;
 }
+#pragma GCC pop_options
 
 /***************************************************************************
  * Start of entropy processing logic
@@ -366,6 +382,8 @@ static void jent_stuck(struct rand_data *ec, __u64 current_delta)
  *
  * @return One random bit
  */
+#pragma GCC push_options
+#pragma GCC optimize ("-O0")
 static __u64 jent_measure_jitter(struct rand_data *ec)
 {
 	__u64 time = 0;
@@ -395,6 +413,7 @@ static __u64 jent_measure_jitter(struct rand_data *ec)
 
 	return data;
 }
+#pragma GCC pop_options
 
 /**
  * Von Neuman unbias as explained in RFC 4086 section 4.2. As shown in the
@@ -495,6 +514,8 @@ static void jent_stir_pool(struct rand_data *entropy_collector)
  * Input:
  * @ec Reference to entropy collector
  */
+#pragma GCC push_options
+#pragma GCC optimize ("-O0")
 static void jent_gen_entropy(struct rand_data *ec)
 {
 	unsigned int k = 0;
@@ -556,6 +577,7 @@ static void jent_gen_entropy(struct rand_data *ec)
 	if (ec->stir)
 		jent_stir_pool(ec);
 }
+#pragma GCC pop_options
 
 /**
  * The continuous test required by FIPS 140-2 -- the function automatically
-- 
2.4.2
