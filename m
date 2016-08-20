From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: drbg - fix error return code
Date: Sat, 20 Aug 2016 15:06:51 +0000
Message-ID: <1471705611-19309-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36773 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752765AbcHTPG5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Aug 2016 11:06:57 -0400
Received: by mail-pf0-f196.google.com with SMTP id y134so3173653pfg.3
        for <linux-crypto@vger.kernel.org>; Sat, 20 Aug 2016 08:06:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix to return a negative error code from the error handling
case instead of 0.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 crypto/drbg.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index edf3ce0..fb33f7d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1178,12 +1178,16 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		goto err;
 
 	drbg->Vbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
-	if (!drbg->Vbuf)
+	if (!drbg->Vbuf) {
+		ret = -ENOMEM;
 		goto fini;
+	}
 	drbg->V = PTR_ALIGN(drbg->Vbuf, ret + 1);
 	drbg->Cbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
-	if (!drbg->Cbuf)
+	if (!drbg->Cbuf) {
+		ret = -ENOMEM;
 		goto fini;
+	}
 	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
 	/* scratchpad is only generated for CTR and Hash */
 	if (drbg->core->flags & DRBG_HMAC)
@@ -1199,8 +1203,10 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 
 	if (0 < sb_size) {
 		drbg->scratchpadbuf = kzalloc(sb_size + ret, GFP_KERNEL);
-		if (!drbg->scratchpadbuf)
+		if (!drbg->scratchpadbuf) {
+			ret = -ENOMEM;
 			goto fini;
+		}
 		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
 	}
 
@@ -1999,7 +2005,7 @@ static int __init drbg_init(void)
 {
 	unsigned int i = 0; /* pointer to drbg_algs */
 	unsigned int j = 0; /* pointer to drbg_cores */
-	int ret = -EFAULT;
+	int ret;
 
 	ret = drbg_healthcheck_sanity();
 	if (ret)
@@ -2009,7 +2015,7 @@ static int __init drbg_init(void)
 		pr_info("DRBG: Cannot register all DRBG types"
 			"(slots needed: %zu, slots available: %zu)\n",
 			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
-		return ret;
+		return -EFAULT;
 	}
 
 	/*
