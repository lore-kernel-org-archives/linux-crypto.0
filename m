Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E075C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E7BA218A6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RiDwKn+F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfGCIOL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43451 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfGCIOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so803487pgv.10;
        Wed, 03 Jul 2019 01:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PkneT3aecs6Kbwyjtaql2AriO4Q+BBNKS7A4THu3IYU=;
        b=RiDwKn+FlKgrr41ZvjT3tbd7ujE40hDraiJKOBSkwLxwpQDvQ8nTXFKMo46K5IRrdq
         3SaLq94hb4FAzn0zcDq7VsdBMSWi3qpBgs43hguMnPdgEGllxujL3INNOuKqicHETFYF
         lX+BDtu2Yj/1Ze9+QALF3zu2ntdzO1feO8N9HIG+oQ6pNyBUjXVdmIRQedPKammvfsC/
         TBs3AVTOeMfo5L+AmvLhwOgfmjjkq7yqUw//bXdjFVXl1CSm9o1ZrEOwBnkRZNn0OlBp
         E8k50UeA/MX84/LMcfAHTMiTUBpZesq0tc6QRfbHxws/1hgAvXqx54Zrxax3iJey4mt6
         gz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PkneT3aecs6Kbwyjtaql2AriO4Q+BBNKS7A4THu3IYU=;
        b=PWYqAudM+DV+7ebHYAxrIERdOISsXdy4JeFTUTwCUldnv/EbVVCKXP+nJQyYap29ff
         50NwhpV7tvaKiX2V0cgrtYyG1zWqxjTtLxRSQO5BQhxQCQ90/74QaGMZAFg+DIOlmR/1
         XB09M8CRneMKBZ3om19Ny10/lwT2mF/tN0uy29SaEa025dZXTpznYg46ozK49kO5YVnY
         oaTsZKg5zaWQ+nJvmPxlfkv2DTP92D07L/UGgJq3sAwpf6aU1lf5HHOiGTDkYAt0Zz0Q
         IqeznlqvDMcvU8X2cAOAAbyfZHgQCHtskgCk31MKFaC2ipk9yjLkDAH22Onc7sdtTb/U
         R9Kg==
X-Gm-Message-State: APjAAAUK+6elrLE7/Oeag0b6aXhcrbHDBKwu3VEiAr3RBk8IZEzwkGyT
        b4UjKIeFCN7NT/obYrRRiOgbk+tfDQI=
X-Google-Smtp-Source: APXvYqwZzveMeYPZadlqmFOO4kJHKq3ImJw1NWDaYErehoJdabJXzHqx0oCVnpu1UlopyRnZRgEB2w==
X-Received: by 2002:a65:64d3:: with SMTP id t19mr26322063pgv.112.1562141650474;
        Wed, 03 Jul 2019 01:14:10 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:09 -0700 (PDT)
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
Subject: [PATCH v4 10/16] crypto: caam - make CAAM_PTR_SZ dynamic
Date:   Wed,  3 Jul 2019 01:13:21 -0700
Message-Id: <20190703081327.17505-11-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703081327.17505-1-andrew.smirnov@gmail.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
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
index 4b03c967009b..7f13ccc1e603 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -74,7 +74,7 @@
 
 #define CHACHAPOLY_DESC_JOB_IO_LEN	(AEAD_DESC_JOB_IO_LEN + CAAM_CMD_SZ * 6)
 
-#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
+#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN_MIN)
 #define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
 
 struct caam_alg_entry {
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index a87526f62737..4bfec53ccb8e 100644
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
index 908d3ecf6d1c..42692a2bc2f3 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -605,6 +605,8 @@ static int caam_probe(struct platform_device *pdev)
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

