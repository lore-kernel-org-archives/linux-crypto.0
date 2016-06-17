From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: use timespec64 for jent_get_nstime
Date: Fri, 17 Jun 2016 17:59:41 +0200
Message-ID: <20160617155952.1021006-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
	Stephan Mueller <smueller@chronox.de>,
	Kees Cook <keescook@chromium.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The jent_get_nstime() function uses __getnstimeofday() to get
something similar to a 64-bit nanosecond counter. As we want
to get rid of struct timespec to fix the y2038 overflow,
this patch changes the code to use __getnstimeofday64()
instead, which returns a timespec64 structure.

Nothing changes about the algorithm, but it looks like it
might be better to use

 *out = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;

or even

 *out = ktime_get_raw_fast_ns();

to get an actual nanosecond value and avoid the predictable
jitter that happens at the end of a second. Checking whether
or not this would be good needs investigation by someone who
understands the code better than me.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/jitterentropy-kcapi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 597cedd3531c..82ac44eff20d 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -89,7 +89,7 @@ void jent_memcpy(void *dest, const void *src, unsigned int n)
 
 void jent_get_nstime(__u64 *out)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	__u64 tmp = 0;
 
 	tmp = random_get_entropy();
@@ -98,9 +98,11 @@ void jent_get_nstime(__u64 *out)
 	 * If random_get_entropy does not return a value (which is possible on,
 	 * for example, MIPS), invoke __getnstimeofday
 	 * hoping that there are timers we can work with.
+	 *
+	 * should we have a __ktime_get_ns() instead?
 	 */
 	if ((0 == tmp) &&
-	   (0 == __getnstimeofday(&ts))) {
+	   (0 == __getnstimeofday64(&ts))) {
 		tmp = ts.tv_sec;
 		tmp = tmp << 32;
 		tmp = tmp | ts.tv_nsec;
-- 
2.9.0
