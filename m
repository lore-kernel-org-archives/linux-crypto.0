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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D412C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 331DD208C2
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elE0LCj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfHLUIM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37241 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfHLUIM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id bj8so1274820plb.4;
        Mon, 12 Aug 2019 13:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QK9nbOQLmR2o+Rue6/mhiH1zSdAqfrSWD3bg8umpWQ4=;
        b=elE0LCj5jrc//mNgwtPk7q2HxGJ9PalFmmt6jkrmQTs4USe3uO3wZhTpaIuwtnhSRI
         rfpkyu7zVs5SX/0PyDhB/sS2nKtSHkFvg+N/zCCd6QIk+xmBCmO3/WOrDixFhe33osqC
         /6Ov18Mmp/xTdjnj0o4hlnY6JmZ1WEIcuIoPFHIV2jOYFBK2sBsEM62CQjXjQNT5BfFd
         XvNxHcFeHG1s/p00qWGbnezj2R87UlwMikQqXeGEadgHptiwGq21Im2gaxZ+j8VcfkkC
         qiLF24T4N/AROwrzrpyMpoghsIh22jaXbu0LgL1ogwoHqgcJpxnEOhzPOK0AZ0R0rSm+
         Saqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QK9nbOQLmR2o+Rue6/mhiH1zSdAqfrSWD3bg8umpWQ4=;
        b=qAuejXJbEUWln1JyYxEDqGpO1YAkMSgWmln/9IMagZQH/M+Ve4kjjxJxdL/6VkB4fM
         jjdDNLCdCxA3WZYflxBOCG2C5QaY3FesMe0FSNCBa7t29YrQN6ExC3JAgtzFFyeYmBhB
         JJsSWepiAy/IMiyG0aXC/QdIJ45m929Mf/uWtAe7YuUerP8OgXRLPX63Wjj1qOwbpZIN
         7ljMC8M9oDrdtnFf1KnU5GFixQQrOsWbSRqs1vd0oPvLHl9bcoCxDr3lCgNNSwkDC5NL
         9Y4l3cXhctEDQ8FXrjRu+Qyn135oJRvv9ZP+XBd4+nBChiQ2VRXsf1LRvFjLmzohNSNQ
         cRcA==
X-Gm-Message-State: APjAAAXWtKzC6coTP+7gw/R3SiADGu+Ip79MeMeVFfNCRwAeZEUmhqMy
        cQTMVQtqbogdgUo1uRz+UiEEfVus
X-Google-Smtp-Source: APXvYqzUcUa6q53OLTQTTjNEbd4FlLyUE6qrRLHTYIRsdsu9Vvcz8V982u7N1vxL4+dVP/3l2EX2IA==
X-Received: by 2002:a17:902:a70c:: with SMTP id w12mr7069221plq.288.1565640490986;
        Mon, 12 Aug 2019 13:08:10 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:10 -0700 (PDT)
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
Subject: [PATCH v7 08/15] crypto: caam - share definition for MAX_SDLEN
Date:   Mon, 12 Aug 2019 13:07:32 -0700
Message-Id: <20190812200739.30389-9-andrew.smirnov@gmail.com>
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

Both qi.h and cammalg_qi2.h seem to define identical versions of
MAX_SDLEN. Move it to desc_constr.h to avoid duplication.

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
 drivers/crypto/caam/caamalg_qi2.h | 27 ---------------------------
 drivers/crypto/caam/desc_constr.h | 27 +++++++++++++++++++++++++++
 drivers/crypto/caam/qi.h          | 26 --------------------------
 3 files changed, 27 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index be5085451053..a5e0785917b5 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -90,33 +90,6 @@ struct dpaa2_caam_priv_per_cpu {
 	struct dpaa2_io *dpio;
 };
 
-/*
- * The CAAM QI hardware constructs a job descriptor which points
- * to shared descriptor (as pointed by context_a of FQ to CAAM).
- * When the job descriptor is executed by deco, the whole job
- * descriptor together with shared descriptor gets loaded in
- * deco buffer which is 64 words long (each 32-bit).
- *
- * The job descriptor constructed by QI hardware has layout:
- *
- *	HEADER		(1 word)
- *	Shdesc ptr	(1 or 2 words)
- *	SEQ_OUT_PTR	(1 word)
- *	Out ptr		(1 or 2 words)
- *	Out length	(1 word)
- *	SEQ_IN_PTR	(1 word)
- *	In ptr		(1 or 2 words)
- *	In length	(1 word)
- *
- * The shdesc ptr is used to fetch shared descriptor contents
- * into deco buffer.
- *
- * Apart from shdesc contents, the total number of words that
- * get loaded in deco buffer are '8' or '11'. The remaining words
- * in deco buffer can be used for storing shared descriptor.
- */
-#define MAX_SDLEN	((CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN) / CAAM_CMD_SZ)
-
 /* Length of a single buffer in the QI driver memory cache */
 #define CAAM_QI_MEMCACHE_SIZE	512
 
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 5988a26a2441..c364f9a94046 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -18,6 +18,33 @@
 #define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
 #define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
 
+/*
+ * The CAAM QI hardware constructs a job descriptor which points
+ * to shared descriptor (as pointed by context_a of FQ to CAAM).
+ * When the job descriptor is executed by deco, the whole job
+ * descriptor together with shared descriptor gets loaded in
+ * deco buffer which is 64 words long (each 32-bit).
+ *
+ * The job descriptor constructed by QI hardware has layout:
+ *
+ *	HEADER		(1 word)
+ *	Shdesc ptr	(1 or 2 words)
+ *	SEQ_OUT_PTR	(1 word)
+ *	Out ptr		(1 or 2 words)
+ *	Out length	(1 word)
+ *	SEQ_IN_PTR	(1 word)
+ *	In ptr		(1 or 2 words)
+ *	In length	(1 word)
+ *
+ * The shdesc ptr is used to fetch shared descriptor contents
+ * into deco buffer.
+ *
+ * Apart from shdesc contents, the total number of words that
+ * get loaded in deco buffer are '8' or '11'. The remaining words
+ * in deco buffer can be used for storing shared descriptor.
+ */
+#define MAX_SDLEN	((CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN) / CAAM_CMD_SZ)
+
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
 			      &__func__[sizeof("append")]); } while (0)
diff --git a/drivers/crypto/caam/qi.h b/drivers/crypto/caam/qi.h
index f93c9c7ed430..db0549549e3b 100644
--- a/drivers/crypto/caam/qi.h
+++ b/drivers/crypto/caam/qi.h
@@ -14,32 +14,6 @@
 #include "desc.h"
 #include "desc_constr.h"
 
-/*
- * CAAM hardware constructs a job descriptor which points to a shared descriptor
- * (as pointed by context_a of to-CAAM FQ).
- * When the job descriptor is executed by DECO, the whole job descriptor
- * together with shared descriptor gets loaded in DECO buffer, which is
- * 64 words (each 32-bit) long.
- *
- * The job descriptor constructed by CAAM hardware has the following layout:
- *
- *	HEADER		(1 word)
- *	Shdesc ptr	(1 or 2 words)
- *	SEQ_OUT_PTR	(1 word)
- *	Out ptr		(1 or 2 words)
- *	Out length	(1 word)
- *	SEQ_IN_PTR	(1 word)
- *	In ptr		(1 or 2 words)
- *	In length	(1 word)
- *
- * The shdesc ptr is used to fetch shared descriptor contents into DECO buffer.
- *
- * Apart from shdesc contents, the total number of words that get loaded in DECO
- * buffer are '8' or '11'. The remaining words in DECO buffer can be used for
- * storing shared descriptor.
- */
-#define MAX_SDLEN	((CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN) / CAAM_CMD_SZ)
-
 /* Length of a single buffer in the QI driver memory cache */
 #define CAAM_QI_MEMCACHE_SIZE	768
 
-- 
2.21.0

