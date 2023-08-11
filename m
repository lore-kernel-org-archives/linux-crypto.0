Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E0BC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbjHKJaf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbjHKJaT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:19 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630C630DC
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:18 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTF-0020eD-H9; Fri, 11 Aug 2023 17:30:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:13 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:13 +0800
Subject: [PATCH 17/36] crypto: engine - Create internal/engine.h
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTF-0020eD-H9@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Create crypto/internal/engine.h to house details that should not
be used by drivers.  It is empty for the time being.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_engine.c           |    2 +-
 include/crypto/internal/engine.h |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index ba43dfba2fa9..a75162bc1bf4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -9,8 +9,8 @@
 
 #include <crypto/aead.h>
 #include <crypto/akcipher.h>
-#include <crypto/engine.h>
 #include <crypto/hash.h>
+#include <crypto/internal/engine.h>
 #include <crypto/kpp.h>
 #include <crypto/skcipher.h>
 #include <linux/err.h>
diff --git a/include/crypto/internal/engine.h b/include/crypto/internal/engine.h
new file mode 100644
index 000000000000..ffa1bb39d5e4
--- /dev/null
+++ b/include/crypto/internal/engine.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Crypto engine API
+ *
+ * Copyright (c) 2016 Baolin Wang <baolin.wang@linaro.org>
+ * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#ifndef _CRYPTO_INTERNAL_ENGINE_H
+#define _CRYPTO_INTERNAL_ENGINE_H
+
+#include <crypto/engine.h>
+
+#endif
