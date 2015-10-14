From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v4 8/8] zram: enable contextless compression alg in zram
Date: Wed, 14 Oct 2015 16:38:24 +0900
Message-ID: <1444808304-29320-9-git-send-email-iamjoonsoo.kim@lge.com>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now, zram uses contextless compression API and there is no reason
to limit compression algorithm through hard-wired string. This patch
remove it so enable all contextless compression algorithm in the
system.

After this patch, available compression algorithm for zram can be
retrieved by searching contextless compression in /proc/crypto.

cat /proc/crypto | grep ccomp -B 7
name         : lz4
[snip...]
type         : ccomp

Previous interface comp_algorithm attr will remain to set new algorithm.
Read from previous interface also works for compatibility but it will
be wrong.

Note that after this patch is applied, there is no way to know current
compression algorithm so it's really bad thing. Please let me know proper
solution if someone have better idea.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 Documentation/blockdev/zram.txt | 29 +++++++++++++++++++++++------
 drivers/block/zram/Kconfig      |  9 ---------
 drivers/block/zram/zcomp.c      | 17 +++++++----------
 drivers/block/zram/zram_drv.c   |  1 +
 4 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 5bda503..7a165c2 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -81,15 +81,32 @@ dynamic max_comp_streams. Only multi stream backend supports dynamic
 max_comp_streams adjustment.
 
 3) Select compression algorithm
-	Using comp_algorithm device attribute one can see available and
-	currently selected (shown in square brackets) compression algorithms,
-	change selected compression algorithm (once the device is initialised
-	there is no way to change compression algorithm).
+	You can find available compression algorithms by searching contextless
+	compression algorithm (type: ccomp) in /proc/crypto.
+	Using comp_algorithm device attribute one can change selected
+	compression algorithm (once the device is initialised there is no way
+	to change compression algorithm).
 
 	Examples:
 	#show supported compression algorithms
-	cat /sys/block/zram0/comp_algorithm
-	lzo [lz4]
+	cat /proc/crypto | grep ccomp -B 7
+	name         : lz4
+	driver       : lz4-generic
+	module       : kernel
+	priority     : 0
+	refcnt       : 1
+	selftest     : passed
+	internal     : no
+	type         : ccomp
+	--
+	name         : lzo
+	driver       : lzo-generic
+	module       : kernel
+	priority     : 0
+	refcnt       : 1
+	selftest     : passed
+	internal     : no
+	type         : ccomp
 
 	#select lzo compression algorithm
 	echo lzo > /sys/block/zram0/comp_algorithm
diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 7619bed..36ec96f 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -13,12 +13,3 @@ config ZRAM
 	  disks and maybe many more.
 
 	  See zram.txt for more information.
-
-config ZRAM_LZ4_COMPRESS
-	bool "Enable LZ4 algorithm support"
-	depends on ZRAM
-	select CRYPTO_LZ4
-	default n
-	help
-	  This option enables LZ4 compression algorithm support. Compression
-	  algorithm can be changed using `comp_algorithm' device attribute.
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 9be83db..f91c0659 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -41,22 +41,16 @@ struct zcomp_strm_multi {
 
 static const char * const backends[] = {
 	"lzo",
-#ifdef CONFIG_ZRAM_LZ4_COMPRESS
 	"lz4",
-#endif
 	NULL
 };
 
 static const char *find_backend(const char *compress)
 {
-	int i = 0;
-	while (backends[i]) {
-		if (sysfs_streq(compress, backends[i]) &&
-			crypto_has_comp(backends[i], 0, 0))
-			break;
-		i++;
-	}
-	return backends[i];
+	if (crypto_has_comp(compress, 0, 0))
+		return compress;
+
+	return NULL;
 }
 
 static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
@@ -277,6 +271,9 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
 	int i = 0;
 
 	while (backends[i]) {
+		if (!crypto_has_comp(backends[i], 0, 0))
+			continue;
+
 		if (!strcmp(comp, backends[i]))
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
 					"[%s] ", backends[i]);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6f04fb2..6b4cf85 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -352,6 +352,7 @@ static ssize_t comp_algorithm_show(struct device *dev,
 	size_t sz;
 	struct zram *zram = dev_to_zram(dev);
 
+	deprecated_attr_warn("comp_algorithm");
 	down_read(&zram->init_lock);
 	sz = zcomp_available_show(zram->compressor, buf);
 	up_read(&zram->init_lock);
-- 
1.9.1
