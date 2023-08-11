Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C71AC001DB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbjHKJao (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbjHKJaZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:25 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9D730F2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:22 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTJ-0020es-P2; Fri, 11 Aug 2023 17:30:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:17 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:17 +0800
Subject: [PATCH 19/36] crypto: caam - Include internal/engine.h
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTJ-0020es-P2@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Inlucde internal/engine.h because this driver uses directly
accesses attributes inside struct crypto_engine.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c  |    4 ++--
 drivers/crypto/caam/caamhash.c |    2 +-
 drivers/crypto/caam/caampkc.c  |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index feb86013dbf6..da8182ee86fe 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -56,9 +56,9 @@
 #include "sg_sw_sec4.h"
 #include "key_gen.h"
 #include "caamalg_desc.h"
-#include <crypto/engine.h>
-#include <crypto/xts.h>
 #include <asm/unaligned.h>
+#include <crypto/internal/engine.h>
+#include <crypto/xts.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
 #include <linux/err.h>
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 641c3afd59ca..9ef25387f6b6 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -65,7 +65,7 @@
 #include "sg_sw_sec4.h"
 #include "key_gen.h"
 #include "caamhash_desc.h"
-#include <crypto/engine.h>
+#include <crypto/internal/engine.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 72afc249d42f..72670cd10b87 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -16,6 +16,7 @@
 #include "desc_constr.h"
 #include "sg_sw_sec4.h"
 #include "caampkc.h"
+#include <crypto/internal/engine.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 
