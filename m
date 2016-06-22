From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: Jitter RNG - use ktime_get_ns as fallback
Date: Wed, 22 Jun 2016 19:26:06 +0200
Message-ID: <2249326.PVY2Dy3CIm@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Arnd Bergmann <arnd@arndb.de>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	y2038 Mailman List <y2038@lists.linaro.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <keescook@chromium.org>
To: herbert@gondor.apana.org.au, John Stultz <john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi John, Herbert,

Changes v2: use ktime_get_ns instead of ktime_get_raw_ns

The testing was re-performed and indicate no difference to the previous testing.

Ciao
Stephan

---8<---

As part of the Y2038 development, __getnstimeofday is not supposed to be
used any more. It is now replaced with ktime_get_ns. The Jitter RNG uses
the time stamp to measure the execution time of a given code path and
tries to detect variations in the execution time. Therefore, the only
requirement the Jitter RNG has, is a sufficient high resolution to
detect these variations.

The change was tested on x86 to show an identical behavior as RDTSC. The
used test code simply measures the execution time of the heart of the
RNG:

        jent_get_nstime(&time);
        jent_memaccess(ec, min);
        jent_fold_time(NULL, time, &folded, min);
        jent_get_nstime(&time2);
        return ((time2 - time));

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy-kcapi.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 597cedd..be1577c 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -87,24 +87,28 @@ void jent_memcpy(void *dest, const void *src, unsigned int n)
 	memcpy(dest, src, n);
 }
 
+/*
+ * Obtain a high-resolution time stamp value. The time stamp is used to measure
+ * the execution time of a given code path and its variations. Hence, the time
+ * stamp must have a sufficiently high resolution.
+ *
+ * Note, if the function returns zero because a given architecture does not
+ * implement a high-resolution time stamp, the RNG code's runtime test
+ * will detect it and will not produce output.
+ */
 void jent_get_nstime(__u64 *out)
 {
-	struct timespec ts;
 	__u64 tmp = 0;
 
 	tmp = random_get_entropy();
 
 	/*
-	 * If random_get_entropy does not return a value (which is possible on,
-	 * for example, MIPS), invoke __getnstimeofday
+	 * If random_get_entropy does not return a value, i.e. it is not
+	 * implemented for a given architecture, use a clock source.
 	 * hoping that there are timers we can work with.
 	 */
-	if ((0 == tmp) &&
-	   (0 == __getnstimeofday(&ts))) {
-		tmp = ts.tv_sec;
-		tmp = tmp << 32;
-		tmp = tmp | ts.tv_nsec;
-	}
+	if (tmp == 0)
+		tmp = ktime_get_ns();
 
 	*out = tmp;
 }
-- 
2.5.5
