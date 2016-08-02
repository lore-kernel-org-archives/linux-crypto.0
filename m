From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0020/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:34:49 +0800
Message-ID: <20160802103449.15093-1-baolex.ni@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 arch/s390/crypto/prng.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 41527b1..dc2342e 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -678,7 +678,7 @@ static ssize_t prng_chunksize_show(struct device *dev,
 {
 	return snprintf(buf, PAGE_SIZE, "%u\n", prng_chunk_size);
 }
-static DEVICE_ATTR(chunksize, 0444, prng_chunksize_show, NULL);
+static DEVICE_ATTR(chunksize, S_IRUSR | S_IRGRP | S_IROTH, prng_chunksize_show, NULL);
 
 /* counter attribute (ro) */
 static ssize_t prng_counter_show(struct device *dev,
@@ -697,7 +697,7 @@ static ssize_t prng_counter_show(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", counter);
 }
-static DEVICE_ATTR(byte_counter, 0444, prng_counter_show, NULL);
+static DEVICE_ATTR(byte_counter, S_IRUSR | S_IRGRP | S_IROTH, prng_counter_show, NULL);
 
 /* errorflag attribute (ro) */
 static ssize_t prng_errorflag_show(struct device *dev,
@@ -706,7 +706,7 @@ static ssize_t prng_errorflag_show(struct device *dev,
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", prng_errorflag);
 }
-static DEVICE_ATTR(errorflag, 0444, prng_errorflag_show, NULL);
+static DEVICE_ATTR(errorflag, S_IRUSR | S_IRGRP | S_IROTH, prng_errorflag_show, NULL);
 
 /* mode attribute (ro) */
 static ssize_t prng_mode_show(struct device *dev,
@@ -718,7 +718,7 @@ static ssize_t prng_mode_show(struct device *dev,
 	else
 		return snprintf(buf, PAGE_SIZE, "SHA512\n");
 }
-static DEVICE_ATTR(mode, 0444, prng_mode_show, NULL);
+static DEVICE_ATTR(mode, S_IRUSR | S_IRGRP | S_IROTH, prng_mode_show, NULL);
 
 /* reseed attribute (w) */
 static ssize_t prng_reseed_store(struct device *dev,
@@ -732,7 +732,7 @@ static ssize_t prng_reseed_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR(reseed, 0200, NULL, prng_reseed_store);
+static DEVICE_ATTR(reseed, S_IWUSR, NULL, prng_reseed_store);
 
 /* reseed limit attribute (rw) */
 static ssize_t prng_reseed_limit_show(struct device *dev,
@@ -762,7 +762,7 @@ static ssize_t prng_reseed_limit_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR(reseed_limit, 0644,
+static DEVICE_ATTR(reseed_limit, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
 		   prng_reseed_limit_show, prng_reseed_limit_store);
 
 /* strength attribute (ro) */
@@ -772,7 +772,7 @@ static ssize_t prng_strength_show(struct device *dev,
 {
 	return snprintf(buf, PAGE_SIZE, "256\n");
 }
-static DEVICE_ATTR(strength, 0444, prng_strength_show, NULL);
+static DEVICE_ATTR(strength, S_IRUSR | S_IRGRP | S_IROTH, prng_strength_show, NULL);
 
 static struct attribute *prng_sha512_dev_attrs[] = {
 	&dev_attr_errorflag.attr,
-- 
2.9.2
