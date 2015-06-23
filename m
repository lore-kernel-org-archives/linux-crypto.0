From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: jitterentropy - avoid compiler warnings
Date: Tue, 23 Jun 2015 16:18:54 +0200
Message-ID: <1446731.BXdYRBoPhr@tachyon.chronox.de>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com> <33380936.3jDOACMRCz@tachyon.chronox.de> <CAMuHMdUw9FJE3kWEQf+TNTaLB9gMjdHEGt27bnD--qoGX22H7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUw9FJE3kWEQf+TNTaLB9gMjdHEGt27bnD--qoGX22H7Q@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Geert, Guenter,

may I ask that you check that the following patch compiles without errors or warnings on your systems?

Though, when I test that patch with the AVR32 cross compiler, I get a warning about the code being not relaxable.

Thank you very much.

---8<---
The core of the Jitter RNG is intended to be compiled with -O0. To
ensure that the Jitter RNG can be compiled on all architectures,
separate out the RNG core into a stand-alone C file that can be compiled
with -O0 which does not depend on any kernel include file.

As no kernel includes can be used in the C file implementing the core
RNG, any dependencies on kernel code must be extracted.

A second file provides the link to the kernel and the kernel crypto API
that can be compiled with the regular compile options of the kernel.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Makefile              |   4 +-
 crypto/jitterentropy-kcapi.c | 208 ++++++++++++++++++++++++++++++++++++++++++
 crypto/jitterentropy.c       | 213 ++++++++-----------------------------------
 3 files changed, 248 insertions(+), 177 deletions(-)
 create mode 100644 crypto/jitterentropy-kcapi.c

diff --git a/crypto/Makefile b/crypto/Makefile
index 0077476..a16a7e7 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -106,7 +106,9 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
-obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy.o
+obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
+CFLAGS_jitterentropy.o = -O0
+jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
new file mode 100644
index 0000000..b32d834
--- /dev/null
+++ b/crypto/jitterentropy-kcapi.c
@@ -0,0 +1,208 @@
+/*
+ * Non-physical true random number generator based on timing jitter --
+ * Linux Kernel Crypto API specific code
+ *
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2015
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * ALTERNATIVELY, this product may be distributed under the terms of
+ * the GNU General Public License, in which case the provisions of the GPL2 are
+ * required INSTEAD OF the above restrictions.  (This clause is
+ * necessary due to a potential bad interaction between the GPL and
+ * the restrictions contained in a BSD-style copyright.)
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/fips.h>
+#include <linux/time.h>
+#include <linux/crypto.h>
+#include <crypto/internal/rng.h>
+
+struct rand_data;
+int jent_read_entropy(struct rand_data *ec, unsigned char *data,
+		      unsigned int len);
+int jent_entropy_init(void);
+struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
+					       unsigned int flags);
+void jent_entropy_collector_free(struct rand_data *entropy_collector);
+
+/***************************************************************************
+ * Helper function
+ ***************************************************************************/
+
+__u64 jent_rol64(__u64 word, unsigned int shift)
+{
+	return rol64(word, shift);
+}
+
+void *jent_zalloc(unsigned int len)
+{
+	return kzalloc(len, GFP_KERNEL);
+}
+
+void jent_zfree(void *ptr)
+{
+	kzfree(ptr);
+}
+
+int jent_fips_enabled(void)
+{
+	return fips_enabled;
+}
+
+void jent_panic(char *s)
+{
+	panic(s);
+}
+
+void jent_memcpy(void *dest, const void *src, unsigned int n)
+{
+	memcpy(dest, src, n);
+}
+
+void jent_get_nstime(__u64 *out)
+{
+	struct timespec ts;
+	__u64 tmp = 0;
+
+	tmp = random_get_entropy();
+
+	/*
+	 * If random_get_entropy does not return a value (which is possible on,
+	 * for example, MIPS), invoke __getnstimeofday
+	 * hoping that there are timers we can work with.
+	 *
+	 * The list of available timers can be obtained from
+	 * /sys/devices/system/clocksource/clocksource0/available_clocksource
+	 * and are registered with clocksource_register()
+	 */
+	if ((0 == tmp) &&
+	   (0 == __getnstimeofday(&ts))) {
+		tmp = ts.tv_sec;
+		tmp = tmp << 32;
+		tmp = tmp | ts.tv_nsec;
+	}
+
+	*out = tmp;
+}
+
+/***************************************************************************
+ * Kernel crypto API interface
+ ***************************************************************************/
+
+struct jitterentropy {
+	spinlock_t jent_lock;
+	struct rand_data *entropy_collector;
+};
+
+static int jent_kcapi_init(struct crypto_tfm *tfm)
+{
+	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
+	int ret = 0;
+
+	rng->entropy_collector = jent_entropy_collector_alloc(1, 0);
+	if (!rng->entropy_collector)
+		ret = -ENOMEM;
+
+	spin_lock_init(&rng->jent_lock);
+	return ret;
+}
+
+static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
+{
+	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
+
+	spin_lock(&rng->jent_lock);
+	if (rng->entropy_collector)
+		jent_entropy_collector_free(rng->entropy_collector);
+	rng->entropy_collector = NULL;
+	spin_unlock(&rng->jent_lock);
+}
+
+static int jent_kcapi_random(struct crypto_rng *tfm,
+			     const u8 *src, unsigned int slen,
+			     u8 *rdata, unsigned int dlen)
+{
+	struct jitterentropy *rng = crypto_rng_ctx(tfm);
+	int ret = 0;
+
+	spin_lock(&rng->jent_lock);
+	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
+	spin_unlock(&rng->jent_lock);
+
+	return ret;
+}
+
+static int jent_kcapi_reset(struct crypto_rng *tfm,
+			    const u8 *seed, unsigned int slen)
+{
+	return 0;
+}
+
+static struct rng_alg jent_alg = {
+	.generate		= jent_kcapi_random,
+	.seed			= jent_kcapi_reset,
+	.seedsize		= 0,
+	.base			= {
+		.cra_name               = "jitterentropy_rng",
+		.cra_driver_name        = "jitterentropy_rng",
+		.cra_priority           = 100,
+		.cra_ctxsize            = sizeof(struct jitterentropy),
+		.cra_module             = THIS_MODULE,
+		.cra_init               = jent_kcapi_init,
+		.cra_exit               = jent_kcapi_cleanup,
+
+	}
+};
+
+static int __init jent_mod_init(void)
+{
+	int ret = 0;
+
+	ret = jent_entropy_init();
+	if (ret) {
+		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
+		return -EFAULT;
+	}
+	return crypto_register_rng(&jent_alg);
+}
+
+static void __exit jent_mod_exit(void)
+{
+	crypto_unregister_rng(&jent_alg);
+}
+
+module_init(jent_mod_init);
+module_exit(jent_mod_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Non-physical True Random Number Generator based on CPU Jitter");
+MODULE_ALIAS_CRYPTO("jitterentropy_rng");
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index d3c3045..6dfb220 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -1,7 +1,8 @@
 /*
- * Non-physical true random number generator based on timing jitter.
+ * Non-physical true random number generator based on timing jitter --
+ * Jitter RNG standalone code.
  *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2014
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2015
  *
  * Design
  * ======
@@ -49,13 +50,14 @@
  * version 1.1.0 provided at http://www.chronox.de/jent.html
  */
 
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/fips.h>
-#include <linux/time.h>
-#include <linux/crypto.h>
-#include <crypto/internal/rng.h>
+#ifdef __OPTIMIZE__
+ #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
+#endif
+
+typedef	unsigned long long	__u64;
+typedef	long long		__s64;
+typedef	unsigned int		__u32;
+#define NULL    ((void *) 0)
 
 /* The entropy pool */
 struct rand_data {
@@ -93,8 +95,6 @@ struct rand_data {
 					   * entropy, saves MEMORY_SIZE RAM for
 					   * entropy collector */
 
-#define DRIVER_NAME     "jitterentropy"
-
 /* -- error codes for init function -- */
 #define JENT_ENOTIME		1 /* Timer service not available */
 #define JENT_ECOARSETIME	2 /* Timer too coarse for RNG */
@@ -110,32 +110,13 @@ struct rand_data {
  * Helper functions
  ***************************************************************************/
 
-static inline void jent_get_nstime(__u64 *out)
-{
-	struct timespec ts;
-	__u64 tmp = 0;
-
-	tmp = random_get_entropy();
-
-	/*
-	 * If random_get_entropy does not return a value (which is possible on,
-	 * for example, MIPS), invoke __getnstimeofday
-	 * hoping that there are timers we can work with.
-	 *
-	 * The list of available timers can be obtained from
-	 * /sys/devices/system/clocksource/clocksource0/available_clocksource
-	 * and are registered with clocksource_register()
-	 */
-	if ((0 == tmp) &&
-	   (0 == __getnstimeofday(&ts))) {
-		tmp = ts.tv_sec;
-		tmp = tmp << 32;
-		tmp = tmp | ts.tv_nsec;
-	}
-
-	*out = tmp;
-}
-
+void jent_get_nstime(__u64 *out);
+__u64 jent_rol64(__u64 word, unsigned int shift);
+void *jent_zalloc(unsigned int len);
+void jent_zfree(void *ptr);
+int jent_fips_enabled(void);
+void jent_panic(char *s);
+void jent_memcpy(void *dest, const void *src, unsigned int n);
 
 /**
  * Update of the loop count used for the next round of
@@ -184,20 +165,6 @@ static __u64 jent_loop_shuffle(struct rand_data *ec,
  * Noise sources
  ***************************************************************************/
 
-/*
- * The disabling of the optimizations is performed as documented and assessed
- * thoroughly in http://www.chronox.de/jent.html. However, instead of disabling
- * the optimization of the entire C file, only the main functions the jitter is
- * measured for are not optimized. These functions include the noise sources as
- * well as the main functions triggering the noise sources. As the time
- * measurement is done from one invocation of the jitter noise source to the
- * next, even the execution jitter of the code invoking the noise sources
- * contribute to the overall randomness as well. The behavior of the RNG and the
- * statistical characteristics when only the mentioned functions are not
- * optimized is almost equal to the a completely non-optimized RNG compilation
- * as tested with the test tools provided at the initially mentioned web site.
- */
-
 /**
  * CPU Jitter noise source -- this is the noise source based on the CPU
  *			      execution time jitter
@@ -232,8 +199,6 @@ static __u64 jent_loop_shuffle(struct rand_data *ec,
  *
  * @return Number of loops the folding operation is performed
  */
-#pragma GCC push_options
-#pragma GCC optimize ("-O0")
 static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
 			    __u64 *folded, __u64 loop_cnt)
 {
@@ -263,7 +228,6 @@ static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
 	*folded = new;
 	return fold_loop_cnt;
 }
-#pragma GCC pop_options
 
 /**
  * Memory Access noise source -- this is a noise source based on variations in
@@ -292,8 +256,6 @@ static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
  *
  * @return Number of memory access operations
  */
-#pragma GCC push_options
-#pragma GCC optimize ("-O0")
 static unsigned int jent_memaccess(struct rand_data *ec, __u64 loop_cnt)
 {
 	unsigned char *tmpval = NULL;
@@ -333,7 +295,6 @@ static unsigned int jent_memaccess(struct rand_data *ec, __u64 loop_cnt)
 	}
 	return i;
 }
-#pragma GCC pop_options
 
 /***************************************************************************
  * Start of entropy processing logic
@@ -382,8 +343,6 @@ static void jent_stuck(struct rand_data *ec, __u64 current_delta)
  *
  * @return One random bit
  */
-#pragma GCC push_options
-#pragma GCC optimize ("-O0")
 static __u64 jent_measure_jitter(struct rand_data *ec)
 {
 	__u64 time = 0;
@@ -413,7 +372,6 @@ static __u64 jent_measure_jitter(struct rand_data *ec)
 
 	return data;
 }
-#pragma GCC pop_options
 
 /**
  * Von Neuman unbias as explained in RFC 4086 section 4.2. As shown in the
@@ -502,7 +460,7 @@ static void jent_stir_pool(struct rand_data *entropy_collector)
 		 */
 		if ((entropy_collector->data >> i) & 1)
 			mixer.u64 ^= constant.u64;
-		mixer.u64 = rol64(mixer.u64, 1);
+		mixer.u64 = jent_rol64(mixer.u64, 1);
 	}
 	entropy_collector->data ^= mixer.u64;
 }
@@ -514,8 +472,6 @@ static void jent_stir_pool(struct rand_data *entropy_collector)
  * Input:
  * @ec Reference to entropy collector
  */
-#pragma GCC push_options
-#pragma GCC optimize ("-O0")
 static void jent_gen_entropy(struct rand_data *ec)
 {
 	unsigned int k = 0;
@@ -565,7 +521,7 @@ static void jent_gen_entropy(struct rand_data *ec)
 		ec->data ^= ((ec->data >> 30) & 1);
 		ec->data ^= ((ec->data >> 27) & 1);
 		ec->data ^= ((ec->data >> 22) & 1);
-		ec->data = rol64(ec->data, 1);
+		ec->data = jent_rol64(ec->data, 1);
 
 		/*
 		 * We multiply the loop value with ->osr to obtain the
@@ -577,7 +533,6 @@ static void jent_gen_entropy(struct rand_data *ec)
 	if (ec->stir)
 		jent_stir_pool(ec);
 }
-#pragma GCC pop_options
 
 /**
  * The continuous test required by FIPS 140-2 -- the function automatically
@@ -589,7 +544,7 @@ static void jent_gen_entropy(struct rand_data *ec)
  */
 static void jent_fips_test(struct rand_data *ec)
 {
-	if (!fips_enabled)
+	if (!jent_fips_enabled())
 		return;
 
 	/* prime the FIPS test */
@@ -599,12 +554,11 @@ static void jent_fips_test(struct rand_data *ec)
 	}
 
 	if (ec->data == ec->old_data)
-		panic(DRIVER_NAME ": Duplicate output detected\n");
+		jent_panic("jitterentropy: Duplicate output detected\n");
 
 	ec->old_data = ec->data;
 }
 
-
 /**
  * Entry function: Obtain entropy for the caller.
  *
@@ -627,15 +581,16 @@ static void jent_fips_test(struct rand_data *ec)
  * The following error codes can occur:
  *	-1	entropy_collector is NULL
  */
-static ssize_t jent_read_entropy(struct rand_data *ec, u8 *data, size_t len)
+int jent_read_entropy(struct rand_data *ec, unsigned char *data,
+		      unsigned int len)
 {
-	u8 *p = data;
+	unsigned char *p = data;
 
 	if (!ec)
-		return -EINVAL;
+		return -1;
 
 	while (0 < len) {
-		size_t tocopy;
+		unsigned int tocopy;
 
 		jent_gen_entropy(ec);
 		jent_fips_test(ec);
@@ -643,7 +598,7 @@ static ssize_t jent_read_entropy(struct rand_data *ec, u8 *data, size_t len)
 			tocopy = (DATA_SIZE_BITS / 8);
 		else
 			tocopy = len;
-		memcpy(p, &ec->data, tocopy);
+		jent_memcpy(p, &ec->data, tocopy);
 
 		len -= tocopy;
 		p += tocopy;
@@ -656,12 +611,12 @@ static ssize_t jent_read_entropy(struct rand_data *ec, u8 *data, size_t len)
  * Initialization logic
  ***************************************************************************/
 
-static struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-						      unsigned int flags)
+struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
+					       unsigned int flags)
 {
 	struct rand_data *entropy_collector;
 
-	entropy_collector = kzalloc(sizeof(struct rand_data), GFP_KERNEL);
+	entropy_collector = jent_zalloc(sizeof(struct rand_data));
 	if (!entropy_collector)
 		return NULL;
 
@@ -669,9 +624,9 @@ static struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 		/* Allocate memory for adding variations based on memory
 		 * access
 		 */
-		entropy_collector->mem = kzalloc(JENT_MEMORY_SIZE, GFP_KERNEL);
+		entropy_collector->mem = jent_zalloc(JENT_MEMORY_SIZE);
 		if (!entropy_collector->mem) {
-			kfree(entropy_collector);
+			jent_zfree(entropy_collector);
 			return NULL;
 		}
 		entropy_collector->memblocksize = JENT_MEMORY_BLOCKSIZE;
@@ -696,17 +651,17 @@ static struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 	return entropy_collector;
 }
 
-static void jent_entropy_collector_free(struct rand_data *entropy_collector)
+void jent_entropy_collector_free(struct rand_data *entropy_collector)
 {
 	if (entropy_collector->mem)
-		kzfree(entropy_collector->mem);
+		jent_zfree(entropy_collector->mem);
 	entropy_collector->mem = NULL;
 	if (entropy_collector)
-		kzfree(entropy_collector);
+		jent_zfree(entropy_collector);
 	entropy_collector = NULL;
 }
 
-static int jent_entropy_init(void)
+int jent_entropy_init(void)
 {
 	int i;
 	__u64 delta_sum = 0;
@@ -832,97 +787,3 @@ static int jent_entropy_init(void)
 
 	return 0;
 }
-
-/***************************************************************************
- * Kernel crypto API interface
- ***************************************************************************/
-
-struct jitterentropy {
-	spinlock_t jent_lock;
-	struct rand_data *entropy_collector;
-};
-
-static int jent_kcapi_init(struct crypto_tfm *tfm)
-{
-	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-	int ret = 0;
-
-	rng->entropy_collector = jent_entropy_collector_alloc(1, 0);
-	if (!rng->entropy_collector)
-		ret = -ENOMEM;
-
-	spin_lock_init(&rng->jent_lock);
-	return ret;
-}
-
-static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
-{
-	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-
-	spin_lock(&rng->jent_lock);
-	if (rng->entropy_collector)
-		jent_entropy_collector_free(rng->entropy_collector);
-	rng->entropy_collector = NULL;
-	spin_unlock(&rng->jent_lock);
-}
-
-static int jent_kcapi_random(struct crypto_rng *tfm,
-			     const u8 *src, unsigned int slen,
-			     u8 *rdata, unsigned int dlen)
-{
-	struct jitterentropy *rng = crypto_rng_ctx(tfm);
-	int ret = 0;
-
-	spin_lock(&rng->jent_lock);
-	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
-	spin_unlock(&rng->jent_lock);
-
-	return ret;
-}
-
-static int jent_kcapi_reset(struct crypto_rng *tfm,
-			    const u8 *seed, unsigned int slen)
-{
-	return 0;
-}
-
-static struct rng_alg jent_alg = {
-	.generate		= jent_kcapi_random,
-	.seed			= jent_kcapi_reset,
-	.seedsize		= 0,
-	.base			= {
-		.cra_name               = "jitterentropy_rng",
-		.cra_driver_name        = "jitterentropy_rng",
-		.cra_priority           = 100,
-		.cra_ctxsize            = sizeof(struct jitterentropy),
-		.cra_module             = THIS_MODULE,
-		.cra_init               = jent_kcapi_init,
-		.cra_exit               = jent_kcapi_cleanup,
-
-	}
-};
-
-static int __init jent_mod_init(void)
-{
-	int ret = 0;
-
-	ret = jent_entropy_init();
-	if (ret) {
-		pr_info(DRIVER_NAME ": Initialization failed with host not compliant with requirements: %d\n", ret);
-		return -EFAULT;
-	}
-	return crypto_register_rng(&jent_alg);
-}
-
-static void __exit jent_mod_exit(void)
-{
-	crypto_unregister_rng(&jent_alg);
-}
-
-module_init(jent_mod_init);
-module_exit(jent_mod_exit);
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-MODULE_DESCRIPTION("Non-physical True Random Number Generator based on CPU Jitter");
-MODULE_ALIAS_CRYPTO("jitterentropy_rng");
-- 
2.4.3
