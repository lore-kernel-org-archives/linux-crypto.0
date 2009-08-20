From: Alexey Mahotkin <squadette@gmail.com>
Subject: [PATCH] linux/kernel.h, linux/mm.h, linux/slab.h are not needed in crypto/*.c
Date: Thu, 20 Aug 2009 14:44:22 +0400
Message-ID: <1250765062-11749-1-git-send-email-squadette@gmail.com>
Cc: Alexey Mahotkin <squadette@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mynd.rinet.ru ([195.54.209.181]:34023 "EHLO mynd.rinet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbZHTKw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2009 06:52:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Less recompilation dependencies.

---
 arch/x86/crypto/crc32c-intel.c |    1 -
 arch/x86/crypto/fpu.c          |    1 -
 crypto/ablkcipher.c            |    2 --
 crypto/aead.c                  |    2 --
 crypto/ahash.c                 |    2 --
 crypto/algapi.c                |    1 -
 crypto/anubis.c                |    1 -
 crypto/api.c                   |    2 --
 crypto/async_tx/async_memcpy.c |    2 --
 crypto/async_tx/async_memset.c |    2 --
 crypto/async_tx/async_tx.c     |    1 -
 crypto/async_tx/async_xor.c    |    2 --
 crypto/authenc.c               |    2 --
 crypto/blkcipher.c             |    2 --
 crypto/blowfish.c              |    1 -
 crypto/camellia.c              |    1 -
 crypto/cbc.c                   |    2 --
 crypto/ccm.c                   |    2 --
 crypto/chainiv.c               |    1 -
 crypto/cipher.c                |    2 --
 crypto/crc32c.c                |    1 -
 crypto/cryptd.c                |    2 --
 crypto/crypto_null.c           |    1 -
 crypto/ctr.c                   |    2 --
 crypto/cts.c                   |    2 --
 crypto/deflate.c               |    2 --
 crypto/digest.c                |    2 --
 crypto/ecb.c                   |    2 --
 crypto/eseqiv.c                |    2 --
 crypto/gcm.c                   |    2 --
 crypto/gf128mul.c              |    2 --
 crypto/hash.c                  |    2 --
 crypto/hmac.c                  |    2 --
 crypto/khazad.c                |    1 -
 crypto/lrw.c                   |    2 --
 crypto/md4.c                   |    1 -
 crypto/pcbc.c                  |    2 --
 crypto/rmd128.c                |    1 -
 crypto/rmd160.c                |    1 -
 crypto/rmd256.c                |    1 -
 crypto/rmd320.c                |    1 -
 crypto/scatterwalk.c           |    2 --
 crypto/seqiv.c                 |    1 -
 crypto/sha1_generic.c          |    1 -
 crypto/sha256_generic.c        |    1 -
 crypto/sha512_generic.c        |    2 --
 crypto/shash.c                 |    2 --
 crypto/tcrypt.c                |    1 -
 crypto/tea.c                   |    1 -
 crypto/testmgr.c               |    1 -
 crypto/tgr192.c                |    1 -
 crypto/twofish_common.c        |    1 -
 crypto/wp512.c                 |    1 -
 crypto/xcbc.c                  |    3 ---
 crypto/xts.c                   |    2 --
 crypto/zlib.c                  |    2 --
 56 files changed, 0 insertions(+), 88 deletions(-)

diff --git a/arch/x86/crypto/crc32c-intel.c b/arch/x86/crypto/crc32c-intel.c
index b9d0026..34799a6 100644
--- a/arch/x86/crypto/crc32c-intel.c
+++ b/arch/x86/crypto/crc32c-intel.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/kernel.h>
 #include <crypto/internal/hash.h>
 
 #include <asm/cpufeature.h>
diff --git a/arch/x86/crypto/fpu.c b/arch/x86/crypto/fpu.c
index daef6cd..7c36b12 100644
--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -14,7 +14,6 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/i387.h>
 
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index e11ce37..b5447fb 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -16,11 +16,9 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
diff --git a/crypto/aead.c b/crypto/aead.c
index d9aa733..99650c9 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -15,10 +15,8 @@
 #include <crypto/internal/aead.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
diff --git a/crypto/ahash.c b/crypto/ahash.c
index f347637..b2dfb69 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -16,10 +16,8 @@
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 56c62e2..b35a9e7 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -13,7 +13,6 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
diff --git a/crypto/anubis.c b/crypto/anubis.c
index e42c3a8..04b9a5a 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -31,7 +31,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <asm/byteorder.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
diff --git a/crypto/api.c b/crypto/api.c
index d5944f9..972ab02 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -17,12 +17,10 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
-#include <linux/kernel.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/param.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include "internal.h"
 
diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index ddccfb0..403f960 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -23,9 +23,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-#include <linux/kernel.h>
 #include <linux/highmem.h>
-#include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/async_tx.h>
 
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 5b5eb99..4103dc9 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -23,9 +23,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-#include <linux/kernel.h>
 #include <linux/interrupt.h>
-#include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/async_tx.h>
 
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 06eb6cc..04c2c64 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -24,7 +24,6 @@
  *
  */
 #include <linux/rculist.h>
-#include <linux/kernel.h>
 #include <linux/async_tx.h>
 
 #ifdef CONFIG_DMA_ENGINE
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 90dd3f8..60d1705 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -23,9 +23,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-#include <linux/kernel.h>
 #include <linux/interrupt.h>
-#include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/raid/xor.h>
 #include <linux/async_tx.h>
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5793b64..bebb7c1 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -17,10 +17,8 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
 #include <linux/spinlock.h>
 
 struct authenc_instance_ctx {
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 90d26c9..1a126ee 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -18,11 +18,9 @@
 #include <crypto/scatterwalk.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 
 #include "internal.h"
diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index 6f5b487..f954c15 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -18,7 +18,6 @@
  */
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <asm/byteorder.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
diff --git a/crypto/camellia.c b/crypto/camellia.c
index 964635d..b491b4f 100644
--- a/crypto/camellia.c
+++ b/crypto/camellia.c
@@ -33,7 +33,6 @@
 #include <linux/crypto.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <asm/unaligned.h>
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 61ac42e..9e0ad6c 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -13,11 +13,9 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 
 struct crypto_cbc_ctx {
 	struct crypto_cipher *child;
diff --git a/crypto/ccm.c b/crypto/ccm.c
index c36d654..e6895df 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -15,9 +15,7 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 
 #include "internal.h"
 
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index ba200b0..4d54f52 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -18,7 +18,6 @@
 #include <crypto/crypto_wq.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 9a1a731..6687939 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -13,10 +13,8 @@
  *
  */
 
-#include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include "internal.h"
 
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 973bc2c..99a6937 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -39,7 +39,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/kernel.h>
 
 #define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ae5fa99..83c9eb3 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -16,12 +16,10 @@
 #include <crypto/crypto_wq.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 
 #define CRYPTD_MAX_CPU_QLEN 100
 
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index cb71c91..a9744c5 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -21,7 +21,6 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/string.h>
 
 #define NULL_KEY_SIZE		0
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 2d7425f..6233a8e 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -14,11 +14,9 @@
 #include <crypto/ctr.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 
 struct crypto_ctr_ctx {
 	struct crypto_cipher *child;
diff --git a/crypto/cts.c b/crypto/cts.c
index ccf9c5d..b5d650a 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -43,12 +43,10 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <crypto/scatterwalk.h>
-#include <linux/slab.h>
 
 struct crypto_cts_ctx {
 	struct crypto_blkcipher *child;
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 9128da4..5c3f4c6 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -30,9 +30,7 @@
 #include <linux/zlib.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
-#include <linux/mm.h>
 #include <linux/net.h>
-#include <linux/slab.h>
 
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
 #define DEFLATE_DEF_WINBITS		11
diff --git a/crypto/digest.c b/crypto/digest.c
index 5d3f130..d7cdf9b 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -14,11 +14,9 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
-#include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/highmem.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
diff --git a/crypto/ecb.c b/crypto/ecb.c
index a46838e..fbe4673 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -13,10 +13,8 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 
 struct crypto_ecb_ctx {
 	struct crypto_cipher *child;
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 3ca3b66..31b8878 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -20,8 +20,6 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
diff --git a/crypto/gcm.c b/crypto/gcm.c
index e70afd0..fba1717 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -15,9 +15,7 @@
 #include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 
 struct gcm_instance_ctx {
 	struct crypto_skcipher_spawn ctr;
diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index a90d260..836bf70 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -49,9 +49,7 @@
 */
 
 #include <crypto/gf128mul.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 
 #define gf128mul_dat(q) { \
 	q(0x00), q(0x01), q(0x02), q(0x03), q(0x04), q(0x05), q(0x06), q(0x07),\
diff --git a/crypto/hash.c b/crypto/hash.c
index cb86b19..7cf3c1b 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -11,9 +11,7 @@
 
 #include <crypto/internal/hash.h>
 #include <linux/errno.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 0ad39c3..c0c9fad 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -20,10 +20,8 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 
 struct hmac_ctx {
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 527e4e3..8f654f7 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -21,7 +21,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <asm/byteorder.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 358f80b..0ebcf37 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -19,10 +19,8 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
diff --git a/crypto/md4.c b/crypto/md4.c
index 7fca1f5..988f031 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -22,7 +22,6 @@
  */
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index d1b8bdf..4b53681 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -17,10 +17,8 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 
 struct crypto_pcbc_ctx {
 	struct crypto_cipher *child;
diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 1ceb673..c61217c 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -16,7 +16,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 472261f..bc39973 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -16,7 +16,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 72eafa8..2ab21d6 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -16,7 +16,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 86becab..5e1baa4 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -16,7 +16,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 3de89a4..9d4eeda 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -15,8 +15,6 @@
  */
 
 #include <crypto/scatterwalk.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 5a013a8..b2b3f6a 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -18,7 +18,6 @@
 #include <crypto/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 9efef20..5b5c135 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -19,7 +19,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 6349d83..1545d0d 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -20,7 +20,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 3bea38d..abef768 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -11,9 +11,7 @@
  *
  */
 #include <crypto/internal/hash.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
diff --git a/crypto/shash.c b/crypto/shash.c
index 2ccc8b0..7343628 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -13,9 +13,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 #include <linux/err.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d59ba50..4f77db1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -19,7 +19,6 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 #include <linux/moduleparam.h>
diff --git a/crypto/tea.c b/crypto/tea.c
index 412bc74..d7663bf 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -21,7 +21,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <asm/byteorder.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e9e9d84..d70dec6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -17,7 +17,6 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include <crypto/rng.h>
 
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index cbca4f2..2a87d3f 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -24,7 +24,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <asm/byteorder.h>
 #include <linux/types.h>
 
diff --git a/crypto/twofish_common.c b/crypto/twofish_common.c
index 0af216c..f6a112d 100644
--- a/crypto/twofish_common.c
+++ b/crypto/twofish_common.c
@@ -44,7 +44,6 @@
 #include <linux/crypto.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 7234272..302dc5c 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -22,7 +22,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/mm.h>
 #include <asm/byteorder.h>
 #include <linux/types.h>
 
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index b63b633..484fd87 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -23,10 +23,7 @@
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/hardirq.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
 #include <linux/scatterlist.h>
 
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
diff --git a/crypto/xts.c b/crypto/xts.c
index d87b0f3..ade1fdf 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -16,10 +16,8 @@
 #include <crypto/algapi.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
diff --git a/crypto/zlib.c b/crypto/zlib.c
index c301573..68285ea 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -27,9 +27,7 @@
 #include <linux/zlib.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
-#include <linux/mm.h>
 #include <linux/net.h>
-#include <linux/slab.h>
 
 #include <crypto/internal/compress.h>
 
-- 
1.6.0.6

