From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: [PATCH 5/8] crypto: remove unused hardirq.h
Date: Sat, 18 Nov 2017 07:02:18 +0800
Message-ID: <1510959741-31109-5-git-send-email-yang.s@alibaba-inc.com>
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Cc: <linux-mm@kvack.org>,
   <linux-fsdevel@vger.kernel.org>,
   <linux-crypto@vger.kernel.org>,
   <netdev@vger.kernel.org>,
  "Yang Shi" <yang.s@alibaba-inc.com>,
  "Herbert Xu" <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by crypto at all.

So, remove the unused hardirq.h.

Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 crypto/ablk_helper.c | 1 -
 crypto/blkcipher.c   | 1 -
 crypto/mcryptd.c     | 1 -
 3 files changed, 3 deletions(-)

diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
index 1441f07..ee52660 100644
--- a/crypto/ablk_helper.c
+++ b/crypto/ablk_helper.c
@@ -28,7 +28,6 @@
 #include <linux/crypto.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/hardirq.h>
 #include <crypto/algapi.h>
 #include <crypto/cryptd.h>
 #include <crypto/ablk_helper.h>
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 6c43a0a..01c0d4a 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -18,7 +18,6 @@
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/errno.h>
-#include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 4e64726..9fa362c 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -26,7 +26,6 @@
 #include <linux/sched.h>
 #include <linux/sched/stat.h>
 #include <linux/slab.h>
-#include <linux/hardirq.h>
 
 #define MCRYPTD_MAX_CPU_QLEN 100
 #define MCRYPTD_BATCH 9
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
