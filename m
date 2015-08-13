From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/2] crypto: export crypto_alg_list and rwsem
Date: Thu, 13 Aug 2015 11:24:13 +0900
Message-ID: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35848 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbbHMCYd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 22:24:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Until now, zram uses compression algorithm through direct call
to core algorithm function, but, it has drawback that we need to add
compression algorithm manually to zram. If we don't do that, we cannot
utilize various compression algorithms in the system. To improve this
situation, zram will be changed to use crypto subsystem in following
patch. There is one problem with this change. Zram has a interface
that what compression algorithm it can support. Although crypto subsystem
has /proc interface to search all of crypto algorithm, but, there is
no way to get just compression algorithm in cryto subsystem. To implement
it on zram-side, crypto_alg_list and rwsem should be exported so
this patch do it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/internal.h      | 2 --
 include/linux/crypto.h | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/internal.h b/crypto/internal.h
index 00e42a3..806f17a 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -45,8 +45,6 @@ struct crypto_larval {
 	u32 mask;
 };
 
-extern struct list_head crypto_alg_list;
-extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 81ef938..ab39f4b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,10 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/rwsem.h>
+
+extern struct list_head crypto_alg_list;
+extern struct rw_semaphore crypto_alg_sem;
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
-- 
1.9.1
