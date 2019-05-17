Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90721C04E87
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6B32082E
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfEQJ3S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 05:29:18 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38965 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbfEQJ3R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 05:29:17 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZAp-00056U-Q4; Fri, 17 May 2019 11:29:07 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZAp-0004Iu-6q; Fri, 17 May 2019 11:29:07 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3] crypto: caam: print messages in caam_dump_sg at debug level
Date:   Fri, 17 May 2019 11:29:05 +0200
Message-Id: <20190517092905.1264-4-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517092905.1264-1-s.hauer@pengutronix.de>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

caam_dump_sg() is only compiled in when DEBUG is defined, hence the
messages are debug messages. Remove the @level argument from
caam_dump_sg() and print all messages at debug level.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/crypto/caam/caamalg.c     | 8 ++++----
 drivers/crypto/caam/caamalg_qi.c  | 2 +-
 drivers/crypto/caam/caamalg_qi2.c | 4 ++--
 drivers/crypto/caam/error.c       | 6 +++---
 drivers/crypto/caam/error.h       | 2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 1395b4860f23..af2047fd9b30 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -989,7 +989,7 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
 
-	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
@@ -1024,7 +1024,7 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	print_hex_dump_debug("dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv, ivsize, 1);
-	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
@@ -1232,7 +1232,7 @@ static void init_skcipher_job(struct skcipher_request *req,
 	dev_dbg(jrdev, "asked=%d, cryptlen%d\n",
 	       (int)edesc->src_nents > 1 ? 100 : req->cryptlen, req->cryptlen);
 
-	caam_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__)": ",
+	caam_dump_sg("src    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->src,
 		     edesc->src_nents > 1 ? 100 : req->cryptlen, 1);
 
@@ -1594,7 +1594,7 @@ static int aead_decrypt(struct aead_request *req)
 	u32 *desc;
 	int ret = 0;
 
-	caam_dump_sg(KERN_ERR, "dec src@" __stringify(__LINE__)": ",
+	caam_dump_sg("dec src@" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->src,
 		     req->assoclen + req->cryptlen, 1);
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 66df91c5a6eb..146bb06e6075 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1181,7 +1181,7 @@ static void skcipher_done(struct caam_drv_req *drv_req, u32 status)
 	print_hex_dump_debug("dstiv  @" __stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
-	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 33a4df6b81de..b897b1ad1218 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1323,7 +1323,7 @@ static void skcipher_encrypt_done(void *cbk_ctx, u32 status)
 	print_hex_dump_debug("dstiv  @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 			     edesc->src_nents > 1 ? 100 : ivsize, 1);
-	caam_dump_sg(KERN_DEBUG, "dst    @" __stringify(__LINE__)": ",
+	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
@@ -1361,7 +1361,7 @@ static void skcipher_decrypt_done(void *cbk_ctx, u32 status)
 	print_hex_dump_debug("dstiv  @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 			     edesc->src_nents > 1 ? 100 : ivsize, 1);
-	caam_dump_sg(KERN_DEBUG, "dst    @" __stringify(__LINE__)": ",
+	caam_dump_sg("dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index a4129a35a330..8069403315c3 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -13,7 +13,7 @@
 #ifdef DEBUG
 #include <linux/highmem.h>
 
-void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
+void caam_dump_sg(const char *prefix_str, int prefix_type,
 		  int rowsize, int groupsize, struct scatterlist *sg,
 		  size_t tlen, bool ascii)
 {
@@ -35,7 +35,7 @@ void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
 
 		buf = it_page + it->offset;
 		len = min_t(size_t, tlen, it->length);
-		print_hex_dump(level, prefix_str, prefix_type, rowsize,
+		print_hex_dump_debug(prefix_str, prefix_type, rowsize,
 			       groupsize, buf, len, ascii);
 		tlen -= len;
 
@@ -43,7 +43,7 @@ void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
 	}
 }
 #else
-void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
+void caam_dump_sg(const char *prefix_str, int prefix_type,
 		  int rowsize, int groupsize, struct scatterlist *sg,
 		  size_t tlen, bool ascii)
 {}
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
index 8c6b83e02a70..d9726e66edbf 100644
--- a/drivers/crypto/caam/error.h
+++ b/drivers/crypto/caam/error.h
@@ -17,7 +17,7 @@ void caam_strstatus(struct device *dev, u32 status, bool qi_v2);
 #define caam_jr_strstatus(jrdev, status) caam_strstatus(jrdev, status, false)
 #define caam_qi2_strstatus(qidev, status) caam_strstatus(qidev, status, true)
 
-void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
+void caam_dump_sg(const char *prefix_str, int prefix_type,
 		  int rowsize, int groupsize, struct scatterlist *sg,
 		  size_t tlen, bool ascii);
 
-- 
2.20.1

