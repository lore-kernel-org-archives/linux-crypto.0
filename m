Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45602C76191
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF8820665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JY7rnwYC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbfGOUUD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40097 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732605AbfGOUUA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:20:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so8855847pla.7;
        Mon, 15 Jul 2019 13:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8tXOek1IeFKzJfJBGkdp9fjsRG4DvXBHvm0+MVhl4uE=;
        b=JY7rnwYC1ApPReegjn2kGtQjThDI4FyakSNk6GJrANO6X0k6BlJQ5XDmCGd6CupR7a
         F/0eTw+VXQqgc9IgV66OIBBYd2kB42HSCrJ4FuO7TfAG4AIjYqvQwWXu6F/ws1bTud8a
         xQtg79uRuBkWLntMrvj2SZGJw/4I3L6J6nlDk3QvezI2PvIwLOiCQTpk8XrfPMZJjMDk
         wWqKVEXbcMmbx8LRESOq+HAW90kYuCUPnAxMJpO+ZJN0VQZYNPfHGp2SQq+mx6Rgf8A7
         KO9R7uGUqvnFdFghk6oaTxi7TwDrz+vIoeN7ivMKWI5s+tfPsIEpz9hufHX6YAI98Gof
         eNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8tXOek1IeFKzJfJBGkdp9fjsRG4DvXBHvm0+MVhl4uE=;
        b=GxRU/PlCsOWlL+TW19vH1qx8wy8/4cQhNNgDz6dhsqZDe2V23nUTnr26Y1FYAJEJod
         VlQyMcpHnicSsQLkylHyPrAhJ2m5NFt0Vmc///lr2b2BulPgrdB5djnwc851G9LK4ZWo
         GZ3TnYVtEXTQyQpPT2JnE0vCfFkptEL8sAwGOySfnE+xGcGD9PmPqq3RLmA751/5gUOH
         tkBX4jPgrQEbTuadbyXQNx0jfr2KTFwn9RAeL7MfTFPr8xnQmmvs5Q6uVVwArvunL+if
         OlShKyYyHn4O74c4DclGrpDYBaXW+dzyOAMNnqwUr0kWwtUd9iKV2hL1YHiwc6Y2jR62
         TOrA==
X-Gm-Message-State: APjAAAW4s6aPau+eMBkbHnPJ4PmTogP6rwqU0qwcZz35FPOYRenxoW4E
        Qu+Q0JULzdR5P7PnF3kCjf5csIly
X-Google-Smtp-Source: APXvYqxdpzv7mrLCELBVCMKyE5KyBFSMSpu/c6CakbeQD/M32vIuQ1kFF3YtOPuWBTylyxxta/BmEQ==
X-Received: by 2002:a17:902:24a2:: with SMTP id w31mr31145035pla.324.1563221999679;
        Mon, 15 Jul 2019 13:19:59 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:19:59 -0700 (PDT)
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
Subject: [PATCH v5 08/14] crypto: caam - make CAAM_PTR_SZ dynamic
Date:   Mon, 15 Jul 2019 13:19:36 -0700
Message-Id: <20190715201942.17309-9-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190715201942.17309-1-andrew.smirnov@gmail.com>
References: <20190715201942.17309-1-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/desc_constr.h | 10 ++++++++--
 drivers/crypto/caam/error.c       |  3 +++
 6 files changed, 16 insertions(+), 5 deletions(-)

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
index 592ce4a05db8..e5eaaf1efe45 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -606,6 +606,8 @@ static int caam_probe(struct platform_device *pdev)
 	}
 	caam_imx = (bool)imx_soc_match;
 
+	caam_ptr_sz = sizeof(dma_addr_t);
+
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 5988a26a2441..3a83a3332ba9 100644
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
 
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
@@ -37,6 +42,7 @@
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

