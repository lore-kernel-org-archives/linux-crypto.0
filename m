From: Joe Perches <joe@perches.com>
Subject: [PATCH 08/18] random: Remove pr_fmt duplicate logging prefixes
Date: Thu, 10 May 2018 08:45:34 -0700
Message-ID: <25a039fce9e2f58d05f976ea32b7415085d35b57.1525964385.git.joe@perches.com>
References: <cover.1525964381.git.joe@perches.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525964381.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Converting pr_fmt from a simple define to use KBUILD_MODNAME added
some duplicate logging prefixes to existing uses.

Remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/hw_random/via-rng.c | 10 +++++-----
 drivers/char/random.c            | 16 +++++++---------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index ffe9b0c6c647..b9367e055468 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -24,6 +24,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -137,8 +139,7 @@ static int via_rng_init(struct hwrng *rng)
 	 * register */
 	if (((c->x86 == 6) && (c->x86_model >= 0x0f))  || (c->x86 > 6)){
 		if (!boot_cpu_has(X86_FEATURE_XSTORE_EN)) {
-			pr_err(PFX "can't enable hardware RNG "
-				"if XSTORE is not enabled\n");
+			pr_err("can't enable hardware RNG if XSTORE is not enabled\n");
 			return -ENODEV;
 		}
 		return 0;
@@ -176,7 +177,7 @@ static int via_rng_init(struct hwrng *rng)
 	   unneeded */
 	rdmsr(MSR_VIA_RNG, lo, hi);
 	if ((lo & VIA_RNG_ENABLE) == 0) {
-		pr_err(PFX "cannot enable VIA C3 RNG, aborting\n");
+		pr_err("cannot enable VIA C3 RNG, aborting\n");
 		return -ENODEV;
 	}
 
@@ -202,8 +203,7 @@ static int __init mod_init(void)
 	pr_info("VIA RNG detected\n");
 	err = hwrng_register(&via_rng);
 	if (err) {
-		pr_err(PFX "RNG registering failed (%d)\n",
-		       err);
+		pr_err("RNG registering failed (%d)\n", err);
 		goto out;
 	}
 out:
diff --git a/drivers/char/random.c b/drivers/char/random.c
index cd888d4ee605..d1e35cfcce8e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -693,7 +693,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	}
 
 	if (unlikely(entropy_count < 0)) {
-		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
+		pr_warn("negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		WARN_ON(1);
 		entropy_count = 0;
@@ -857,7 +857,7 @@ static int crng_fast_load(const char *cp, size_t len)
 		invalidate_batched_entropy();
 		crng_init = 1;
 		wake_up_interruptible(&crng_init_wait);
-		pr_notice("random: fast init done\n");
+		pr_notice("fast init done\n");
 	}
 	return 1;
 }
@@ -942,16 +942,14 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		crng_init = 2;
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
-		pr_notice("random: crng init done\n");
+		pr_notice("crng init done\n");
 		if (unseeded_warning.missed) {
-			pr_notice("random: %d get_random_xx warning(s) missed "
-				  "due to ratelimiting\n",
+			pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
 				  unseeded_warning.missed);
 			unseeded_warning.missed = 0;
 		}
 		if (urandom_warning.missed) {
-			pr_notice("random: %d urandom warning(s) missed "
-				  "due to ratelimiting\n",
+			pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
 				  urandom_warning.missed);
 			urandom_warning.missed = 0;
 		}
@@ -1380,7 +1378,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		ibytes = 0;
 
 	if (unlikely(entropy_count < 0)) {
-		pr_warn("random: negative entropy count: pool %s count %d\n",
+		pr_warn("negative entropy count: pool %s count %d\n",
 			r->name, entropy_count);
 		WARN_ON(1);
 		entropy_count = 0;
@@ -1596,7 +1594,7 @@ static void _warn_unseeded_randomness(const char *func_name, void *caller,
 	print_once = true;
 #endif
 	if (__ratelimit(&unseeded_warning))
-		pr_notice("random: %s called from %pS with crng_init=%d\n",
+		pr_notice("%s called from %pS with crng_init=%d\n",
 			  func_name, caller, crng_init);
 }
 
-- 
2.15.0
