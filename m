From: Amos Kong <akong@redhat.com>
Subject: [PATCH v5 REPOST 4/6] hw_random: fix unregister race.
Date: Mon,  8 Dec 2014 16:50:38 +0800
Message-ID: <1418028640-4891-5-git-send-email-akong@redhat.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, m@bues.ch,
	mpm@selenic.com, amit.shah@redhat.com
To: linux-crypto@vger.kernel.org
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

The previous patch added one potential problem: we can still be
reading from a hwrng when it's unregistered.  Add a wait for zero
in the hwrng_unregister path.

v5: reset cleanup_done flag, use compiler barrier to prevent recording.
v4: add cleanup_done flag to insure that cleanup is done

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/core.c | 12 ++++++++++++
 include/linux/hw_random.h     |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 83516cb..067270b 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -60,6 +60,7 @@ static DEFINE_MUTEX(rng_mutex);
 static DEFINE_MUTEX(reading_mutex);
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
+static DECLARE_WAIT_QUEUE_HEAD(rng_done);
 static unsigned short current_quality;
 static unsigned short default_quality; /* = 0; default to "off" */
 
@@ -98,6 +99,11 @@ static inline void cleanup_rng(struct kref *kref)
 
 	if (rng->cleanup)
 		rng->cleanup(rng);
+
+	/* cleanup_done should be updated after cleanup finishes */
+	smp_wmb();
+	rng->cleanup_done = true;
+	wake_up_all(&rng_done);
 }
 
 static void set_current_rng(struct hwrng *rng)
@@ -498,6 +504,8 @@ int hwrng_register(struct hwrng *rng)
 		add_early_randomness(rng);
 	}
 
+	rng->cleanup_done = false;
+
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
@@ -529,6 +537,10 @@ void hwrng_unregister(struct hwrng *rng)
 			kthread_stop(hwrng_fill);
 	} else
 		mutex_unlock(&rng_mutex);
+
+	/* Just in case rng is reading right now, wait. */
+	wait_event(rng_done, rng->cleanup_done &&
+		   atomic_read(&rng->ref.refcount) == 0);
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
 
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index c212e71..7832e50 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -46,6 +46,7 @@ struct hwrng {
 	/* internal. */
 	struct list_head list;
 	struct kref ref;
+	bool cleanup_done;
 };
 
 /** Register a new Hardware Random Number Generator driver. */
-- 
1.9.3
