From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] crypto/digest.c should #include "internal.h"
Date: Wed, 27 Feb 2008 23:21:03 +0200
Message-ID: <20080227212103.GQ29269@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41787 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbYB0VWO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:14 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Every file should include the headers containing the externs for its 
global code (in this case for struct crypto_{init,exit}_digest_ops()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8680cc7b83fdcef7fbb84f9eac3f26f3d3e16b45 foobar
diff --git a/crypto/digest.c b/crypto/digest.c
index 6fd43bd..b526cc3 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -21,6 +21,8 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
+#include "internal.h"
+
 static int init(struct hash_desc *desc)
 {
 	struct crypto_tfm *tfm = crypto_hash_tfm(desc->tfm);
