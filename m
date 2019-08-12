Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24038C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0071208C2
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWz4Yaf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfHLUIO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33696 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfHLUIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so9222346pgn.0;
        Mon, 12 Aug 2019 13:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ezw5+uYU8DBMcqxS+YGEM+lHRvPRuincO7Au07w6j+w=;
        b=FWz4Yaf8tHYgEdMpb8LLDifPfXFu4OowhTsPLhdvdClRaQlrEAvAKOjsOgsfYmwxoP
         hZel8zbY/EdiriBDVzguv5LMItH3rJxyFyAfGVs1aAGC6FYuo5wTuHs58BUPRvKko8s1
         +/InFh0NQYns73bH0+aMHfqRRVCJ1iWxWk4hrMv4v8dlCKRa2wEksrelUKDuGufPhaaV
         65ZOtRHr4mKOsUjBQgzTVGJqpRz2J6U9WqvCo7LI7dx4VyQwmWmRltqNrLc7xK0Jv6dd
         n9HHDWHtSY/QE3YGs3N5aK5TwCbveQ4qMzF8mo+8oCLwArjcWcoG2RIJj7sJKKjbcO3a
         wZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ezw5+uYU8DBMcqxS+YGEM+lHRvPRuincO7Au07w6j+w=;
        b=ontbo0EutzO+A7WuslcTA0B8tS1wJ8j2qu3Nrjd116wA9e+1eY318bw/KtgLltRN5O
         uvIABCY3EAwxCFn39JXwRkoBRoAkZhs7QSWDAIJYLyBS/TfbzrAVR86ikGkbnXLlMi4Y
         B6FlrKC+4FT6SunimJQKVTQlxfA5jlVuiPFA5ebaM1Tv27QReSc0OXgj5e2ntUcK677S
         bX+J1WvjOiwNi71xJcz9rEWpHG7mm8geVE3/ghwfzdHQLy1N+qt6m7nReXEY217F2J/3
         XyzVnLVLOzivI47KsN/nVIppFAOiqksvq/8J1Eh2Mz92ZK4sgC2Q/5RIBkPDEXIHTYbo
         SDaQ==
X-Gm-Message-State: APjAAAXmwVJ2Vu7WtEFLo6puIMXo2JSyWjSGTjtYSpLqJIJUiWzLP4BR
        2Kxjfh+PeCyVXwNhmgviP0uslFJf
X-Google-Smtp-Source: APXvYqydKFYR35MjN0XFxpChvsR2fD/2iokmjMSXQsWwSYC9lR8DSGDdHDHJ2ufExgCYEFTMpxelhw==
X-Received: by 2002:a63:1c22:: with SMTP id c34mr31433404pgc.56.1565640492519;
        Mon, 12 Aug 2019 13:08:12 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:11 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 09/15] crypto: caam - make CAAM_PTR_SZ dynamic
Date:   Mon, 12 Aug 2019 13:07:33 -0700
Message-Id: <20190812200739.30389-10-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812200739.30389-1-andrew.smirnov@gmail.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to be able to configure CAAM pointer size at run-time, which
needed to support i.MX8MQ, which is 64-bit SoC with 32-bit pointer
size, convert CAAM_PTR_SZ to refer to a global variable of the same
name ("caam_ptr_sz") and adjust the rest of the code accordingly. No
functional change intended.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/caamalg.c     |  2 +-
 drivers/crypto/caam/caamhash.c    |  2 +-
 drivers/crypto/caam/caamrng.c     |  2 +-
 drivers/crypto/caam/ctrl.c        |  2 ++
 drivers/crypto/caam/desc_constr.h | 12 +++++++++---
 drivers/crypto/caam/error.c       |  3 +++
 6 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 43f18253e5b6..4dda2f50a724 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -74,7 +74,7 @@
 
 #define CHACHAPOLY_DESC_JOB_IO_LEN	(AEAD_DESC_JOB_IO_LEN + CAAM_CMD_SZ * 6)
 
-#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
+#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN_MIN)
 #define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
 
 struct caam_alg_entry {
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e4ac5d591ad6..955cb4d7c910 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -538,7 +538,7 @@ struct ahash_edesc {
 	dma_addr_t sec4_sg_dma;
 	int src_nents;
 	int sec4_sg_bytes;
-	u32 hw_desc[DESC_JOB_IO_LEN / sizeof(u32)] ____cacheline_aligned;
+	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
 	struct sec4_sg_entry sec4_sg[0];
 };
 
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 561bcb535184..511f0b44e258 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -53,7 +53,7 @@
 					 L1_CACHE_BYTES)
 
 /* length of descriptors */
-#define DESC_JOB_O_LEN			(CAAM_CMD_SZ * 2 + CAAM_PTR_SZ * 2)
+#define DESC_JOB_O_LEN			(CAAM_CMD_SZ * 2 + CAAM_PTR_SZ_MAX * 2)
 #define DESC_RNG_LEN			(3 * CAAM_CMD_SZ)
 
 /* Buffer, its dma address and lock */
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ef6ebe63652a..2f608206947a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -601,6 +601,8 @@ static int caam_probe(struct platform_device *pdev)
 	}
 	caam_imx = (bool)imx_soc_match;
 
+	caam_ptr_sz = sizeof(dma_addr_t);
+
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index c364f9a94046..e0dc1e27ee80 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -14,9 +14,14 @@
 
 #define IMMEDIATE (1 << 23)
 #define CAAM_CMD_SZ sizeof(u32)
-#define CAAM_PTR_SZ sizeof(dma_addr_t)
+#define CAAM_PTR_SZ caam_ptr_sz
+#define CAAM_PTR_SZ_MAX sizeof(dma_addr_t)
+#define CAAM_PTR_SZ_MIN sizeof(u32)
 #define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
-#define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
+#define __DESC_JOB_IO_LEN(n) (CAAM_CMD_SZ * 5 + (n) * 3)
+#define DESC_JOB_IO_LEN __DESC_JOB_IO_LEN(CAAM_PTR_SZ)
+#define DESC_JOB_IO_LEN_MAX __DESC_JOB_IO_LEN(CAAM_PTR_SZ_MAX)
+#define DESC_JOB_IO_LEN_MIN __DESC_JOB_IO_LEN(CAAM_PTR_SZ_MIN)
 
 /*
  * The CAAM QI hardware constructs a job descriptor which points
@@ -43,7 +48,7 @@
  * get loaded in deco buffer are '8' or '11'. The remaining words
  * in deco buffer can be used for storing shared descriptor.
  */
-#define MAX_SDLEN	((CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN) / CAAM_CMD_SZ)
+#define MAX_SDLEN	((CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN_MIN) / CAAM_CMD_SZ)
 
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
@@ -64,6 +69,7 @@
 			       (LDOFF_ENABLE_AUTO_NFIFO << LDST_OFFSET_SHIFT))
 
 extern bool caam_little_end;
+extern size_t caam_ptr_sz;
 
 /*
  * HW fetches 4 S/G table entries at a time, irrespective of how many entries
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 4f0d45865aa2..885cd364a01d 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -56,6 +56,9 @@ EXPORT_SYMBOL(caam_little_end);
 bool caam_imx;
 EXPORT_SYMBOL(caam_imx);
 
+size_t caam_ptr_sz;
+EXPORT_SYMBOL(caam_ptr_sz);
+
 static const struct {
 	u8 value;
 	const char *error_text;
-- 
2.21.0

