Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BCFC76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A39021849
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/fT5sHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfGQPZ4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37052 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbfGQPZZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so11004006pfa.4;
        Wed, 17 Jul 2019 08:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8tXOek1IeFKzJfJBGkdp9fjsRG4DvXBHvm0+MVhl4uE=;
        b=G/fT5sHTxJdWukzY08OmYDIz3+OJM7KcgjJSIYY4ExyG+8egID8UtAbH9Pvb2JYu05
         VB404JD2EmAllBOYKch5clADHFajwS5F625+bw9bN+2jal3YNtjGhUtsdne6PKd/2TtT
         z/JSPQmEDKd6gLCkznO2wc6vsHAsO/2Lbz9ckXVkXwWz0arth0rJsNm3ELGfVNSsL79D
         x424Tv1Y8QfHmxOSSDr+pFEL2h41of38+xFjI94Sss473PjLyJLHLUcjLBlj999rzPNm
         0lvayGxYCKuFWVBDX0+Wtdquo0GhdkXVYvgdwhc1OmL6K8c6KZGfR9w8pzBSjgZts32e
         mlxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8tXOek1IeFKzJfJBGkdp9fjsRG4DvXBHvm0+MVhl4uE=;
        b=ltryl103QwuqrvfpxarMGAvbmjXNIN2Nl93u0XWZ38ZIlOJDUSl6b7rF3j1/x9CUVu
         HuAgTjxCzDazRzobzL63y9WB3tlFnBDINNdiLRr24MKL2tXrBxzHV4eQy1U1jWI11vrH
         CuO/QsJkykWL0sM/5xV0TT25tpgiyAiMhd7HQ/MvoMPZPCLGDkMwCrGJCgG5EBeLL+lJ
         W1NHDyKdQbTcR7Q0ruETjDsaBVQbTeJG32k75eZPAuLupDXpzJW99Z653mws39eLxIzi
         bFiRk7ytJi4B0LfjTh8/rYjSj4t9JiD1ijvtCvZR/iUlI065fIzzJHAKQxSIFSiQY1OQ
         ZE1A==
X-Gm-Message-State: APjAAAW7l5kuWn0BY29ubw2cEXU3bNUIpbMpoYa5H1kjM++UupVWrw+M
        7IEKCtBzWvEhpkHfYy98Rmt16sEn
X-Google-Smtp-Source: APXvYqw3rDpat0jg0o+OfO+eIw1oF0HpVX82VX0gHBT245ejpmc9YTI0yFzlPiHacnQIVvxI+p/eEA==
X-Received: by 2002:a63:20d:: with SMTP id 13mr29906327pgc.253.1563377124068;
        Wed, 17 Jul 2019 08:25:24 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:23 -0700 (PDT)
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
Subject: [PATCH v6 08/14] crypto: caam - make CAAM_PTR_SZ dynamic
Date:   Wed, 17 Jul 2019 08:24:52 -0700
Message-Id: <20190717152458.22337-9-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717152458.22337-1-andrew.smirnov@gmail.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
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

