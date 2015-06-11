From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: picoxcell - Include linux/sizes.h
Date: Thu, 11 Jun 2015 11:28:32 +0800
Message-ID: <E1Z2tAO-0002iw-Gy@gondolin.me.apana.org.au>
References: <20150611032703.GA10416@gondor.apana.org.au>
To: Jamie Iles <jamie@jamieiles.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42493 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbFKD2f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 23:28:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This driver uses SZ_64K so it should include linux/sizes.h rather
than relying on others to pull it in for it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index eb2a0ca..aabf9d4 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -40,6 +40,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 
