Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D03DC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5A420656
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+vCoJvW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbfHTUYd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39173 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730973AbfHTUYc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so3855518pgi.6;
        Tue, 20 Aug 2019 13:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2eBqPIoxevMmE/mBwN+zxV8wmRRFIxeRu2Wf0NcZ98=;
        b=g+vCoJvWYAlVegeoNjKXW2KDu+dKDsFbKi/KupoEps64YhuxurDhLvvM4jGe1YgrVN
         XtZv/0mcirL1RqJoyeE1wvYQpRCXlPxcsT5u3OuBDBT0wc8aRBn2fprUhM1pvrD8Jx2y
         nCuT5TMq8yYXN1QGKRdCwdgZEPkuu6f2bKPR45ULSm+QWKJYod4T/uWkZDohSnZ/0ByI
         oX8BIW4g6H7THQxshXkz2oZgyyI+Zxhkg+humwrxciYObbY0d95cKEtDCx7OggQq1PRx
         0jmuWsewVza7dxMrBfz+2Du71IkmwRzOGmwQdrJoA5ZOqFEHBUWZ2tbwIxbVaExzy/ex
         l0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2eBqPIoxevMmE/mBwN+zxV8wmRRFIxeRu2Wf0NcZ98=;
        b=MYGbjfu1cC0A/5sTn4WYp3G/OBctHnxlSeJIr1fJNLjdw+YZrb6WYrZwckD+g5WNkX
         Lty9lCDp4i99pwHNwN51GEjG81jEsrUHUOB0BLXDkcxpXu6bQ+CKCgCbLpxTnV421Pze
         vUTDUiuzZ68lhCw7xcaDJSME7PXumLXsekqo7KPcSboVLYXC9Ts1VEx3LgSkiebVAutA
         okwKT5Gi1nDJZB4tsq2UOSlS4E44+80pyX1plmptwaxsZg8OI9ywR0/T3h4IN85zTeYw
         AMfr2j69Ewqkr4faEhnW29l56MPWPDpf3KE1duifIerxOnl8rknj1IKoC9H7kaDrl3wO
         h0ZA==
X-Gm-Message-State: APjAAAUk/cKy1ypxpHt1vLBQ9pRQwxlrInZktSC/FECtXRRAGOIEcpzV
        nzOJ2GYgs4DcDw3JQNO4/yE2WEc8X0g=
X-Google-Smtp-Source: APXvYqwNnLgMCbIY0LGO6XuNl4MR7p86vCcIo/J7IMi296jLJPThjcUTquy17hIHPXFkDZckK+8Zeg==
X-Received: by 2002:a17:90a:cc11:: with SMTP id b17mr1720274pju.136.1566332671006;
        Tue, 20 Aug 2019 13:24:31 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:30 -0700 (PDT)
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
Subject: [PATCH v8 09/16] crypto: caam - make CAAM_PTR_SZ dynamic
Date:   Tue, 20 Aug 2019 13:23:55 -0700
Message-Id: <20190820202402.24951-10-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/ctrl.c        |  1 +
 drivers/crypto/caam/desc_constr.h | 12 +++++++++---
 drivers/crypto/caam/error.c       |  3 +++
 6 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 947ba8ef487a..2053b3a71b48 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -74,7 +74,7 @@
 
 #define CHACHAPOLY_DESC_JOB_IO_LEN	(AEAD_DESC_JOB_IO_LEN + CAAM_CMD_SZ * 6)
 
-#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
+#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN_MIN)
 #define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
 
 struct caam_alg_entry {
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 8a07edb45dad..65399cb2a770 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -560,7 +560,7 @@ struct ahash_edesc {
 	dma_addr_t sec4_sg_dma;
 	int src_nents;
 	int sec4_sg_bytes;
-	u32 hw_desc[DESC_JOB_IO_LEN / sizeof(u32)] ____cacheline_aligned;
+	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
 	struct sec4_sg_entry sec4_sg[0];
 };
 
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 7fbda1b08360..e8baacaabe07 100644
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
index 0b4007068c31..47b92451756f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -602,6 +602,7 @@ static int caam_probe(struct platform_device *pdev)
 	caam_imx = (bool)imx_soc_match;
 
 	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
+	caam_ptr_sz = sizeof(dma_addr_t);
 	caam_dpaa2 = !!(comp_params & CTPR_MS_DPAA2);
 	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
 
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 1fe50a4fefaa..89187831d74f 100644
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
index b7fbf1be37a4..17c6108b6d41 100644
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

