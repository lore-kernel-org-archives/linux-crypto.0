From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] bfin_crc: don't include linux/unaligned/access_ok.h
Date: Wed, 19 Nov 2014 21:16:04 +0100
Message-ID: <1416428164-9874-1-git-send-email-johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Berg <johannes.berg@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40845 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbaKSUQO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 15:16:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a specific implementation, <asm/unaligned.h> is the
multiplexer that has the arch-specific knowledge of which
of the implementations needs to be used, so include that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/crypto/bfin_crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index b099e33cb073..e96eddc0e0b3 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -21,13 +21,13 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <linux/unaligned/access_ok.h>
 #include <linux/crypto.h>
 #include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
+#include <asm/unaligned.h>
 
 #include <asm/dma.h>
 #include <asm/portmux.h>
-- 
2.1.1
