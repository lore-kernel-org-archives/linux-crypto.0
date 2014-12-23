From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/5] hwrng: core - Drop current rng in set_current_rng
Date: Tue, 23 Dec 2014 16:40:21 +1100
Message-ID: <E1Y3ICj-0007dO-44@gondolin.me.apana.org.au>
References: <20141223053909.GA28001@gondor.apana.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Rusty Russell <rusty@rustcorp.com.au>, LKP <lkp@01.org>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
	amit.shah@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Rather than having callers of set_current_rng call drop_current_rng,
we can do it directly in set_current_rng.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1d342f0..787ef42 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -70,6 +70,7 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
+static void drop_current_rng(void);
 static void start_khwrngd(void);
 
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
@@ -105,6 +106,7 @@ static inline void cleanup_rng(struct kref *kref)
 static void set_current_rng(struct hwrng *rng)
 {
 	BUG_ON(!mutex_is_locked(&rng_mutex));
+	drop_current_rng();
 	current_rng = rng;
 }
 
@@ -315,7 +317,6 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 			err = hwrng_init(rng);
 			if (err)
 				break;
-			drop_current_rng();
 			set_current_rng(rng);
 			err = 0;
 			break;
