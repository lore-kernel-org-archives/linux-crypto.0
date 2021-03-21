Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374AEC433C1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 12:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0198661931
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 12:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCUMJ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Mar 2021 08:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCUMJV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Mar 2021 08:09:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A42C061574;
        Sun, 21 Mar 2021 05:09:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso7087142pjb.3;
        Sun, 21 Mar 2021 05:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=65xS++HGiZkujdsZR4AQVb+3YXoj/1io84bOdJMhmhE=;
        b=bX3lXOrO99s+3URCG1rF3xz08Ldc7x+dIV0nXOWv60xnvaHBCA2XKu/37JqTJAS4Eb
         o9Y7s5NB/uVox+SOei06QbwVEbdkLsvAt8pDUTMwZ2zvMIuO42JO2b0LmokFl/oWSQCi
         TlYOUENU67DT/L/AvN6g994qx8C6k/9vP/HjhaFOdEDrZtu2ui7F3Fofi6iCb80PAl50
         CMp+zjL7/K3HegSe8iU4V+DfJkN+qX/JDKge1Bw2JuBMkMwDizMGb8DF0NWsZRCaUzWD
         oULps5sVbquDI+slsmrOx5kMiPMMRGOGhSp24togDpNGhHzCwJVhK2LhurGH/mxmu+t9
         0X8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=65xS++HGiZkujdsZR4AQVb+3YXoj/1io84bOdJMhmhE=;
        b=j+BEDGZLxygca8Ldzj8/PiRTAErwIaHHPpaWAGdgC51h+muGmpEaO3PmAvKwIlbVdB
         woHqA7hgyKmKWSS0O6X4kRNjgS1FUfC/Fh4OOOpH9r0klocnCLWlcchx3x61CyvHDu8Q
         DqV3nzMWZasVqPushhrsXnbQa4HOIolsYfRWqDrofUcbz4rJfQ+eqjSn8yZeN/87HoEu
         5OS9Tc/WiI4jxvFInvY2CqCOKwxyoCKzgade+pYNMIdQGfdByOPH6+3QNmsECr12qWmN
         2EtAt2NwzZWM6c8Td+Ya5YL62FKmovOaapp8Oi9hRDHMMrzlVnGJzf3sSBNQVC/F3mf8
         rG/g==
X-Gm-Message-State: AOAM531yHdlB3PUlE2WxLjp3+rW48rrGr/V8E3oVGGwSJBy1t9PfIks3
        palBemB+Dvn5SQNxCHVZymU=
X-Google-Smtp-Source: ABdhPJyWQ0F9qunwou6ZDyiMMtoHuyGgMdWrBXh1xagauBYeVvDzAz3d4QbAnuNvcal40z3iFpqWFw==
X-Received: by 2002:a17:90b:33c7:: with SMTP id lk7mr8038357pjb.95.1616328560906;
        Sun, 21 Mar 2021 05:09:20 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:4cb7:d0cb:1241:5cf8])
        by smtp.googlemail.com with ESMTPSA id f11sm10080642pga.34.2021.03.21.05.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 05:09:20 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com, corbet@lwn.net,
        rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ux500: fix incorrect kernel-doc comment syntax
Date:   Sun, 21 Mar 2021 17:39:12 +0530
Message-Id: <20210321120912.12905-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are certain files in drivers/crypto/ux500, which follow this syntax,
but the content inside does not comply with kernel-doc.
Such lines were probably not meant for kernel-doc parsing, but are parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.

E.g., presence of kernel-doc like comment in the header lines for
drivers/crypto/ux500/cryp/cryp.h at header causes this warning:

"warning: expecting prototype for ST(). Prototype was for _CRYP_H_() instead"

Similarly for other files too.

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/crypto/ux500/cryp/cryp.c      |  2 +-
 drivers/crypto/ux500/cryp/cryp.h      |  2 +-
 drivers/crypto/ux500/cryp/cryp_core.c |  2 +-
 drivers/crypto/ux500/cryp/cryp_irq.c  |  2 +-
 drivers/crypto/ux500/cryp/cryp_irq.h  |  4 ++--
 drivers/crypto/ux500/cryp/cryp_irqp.h |  4 ++--
 drivers/crypto/ux500/cryp/cryp_p.h    | 14 +++++++-------
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
index 9866c2a5e9a7..2b9436723d57 100644
--- a/drivers/crypto/ux500/cryp/cryp.c
+++ b/drivers/crypto/ux500/cryp/cryp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
diff --git a/drivers/crypto/ux500/cryp/cryp.h b/drivers/crypto/ux500/cryp/cryp.h
index 8da7f87b339b..db5713d7c940 100644
--- a/drivers/crypto/ux500/cryp/cryp.h
+++ b/drivers/crypto/ux500/cryp/cryp.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index c3adeb2e5823..df68b7bd0a7a 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson.
diff --git a/drivers/crypto/ux500/cryp/cryp_irq.c b/drivers/crypto/ux500/cryp/cryp_irq.c
index 7ebde69e8c76..6d2f07bec98a 100644
--- a/drivers/crypto/ux500/cryp/cryp_irq.c
+++ b/drivers/crypto/ux500/cryp/cryp_irq.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
diff --git a/drivers/crypto/ux500/cryp/cryp_irq.h b/drivers/crypto/ux500/cryp/cryp_irq.h
index 1984f30100ff..da90029ea141 100644
--- a/drivers/crypto/ux500/cryp/cryp_irq.h
+++ b/drivers/crypto/ux500/cryp/cryp_irq.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
@@ -19,7 +19,7 @@ enum cryp_irq_src_id {
 	CRYP_IRQ_SRC_ALL = 0x3
 };
 
-/**
+/*
  * M0 Funtions
  */
 void cryp_enable_irq_src(struct cryp_device_data *device_data, u32 irq_src);
diff --git a/drivers/crypto/ux500/cryp/cryp_irqp.h b/drivers/crypto/ux500/cryp/cryp_irqp.h
index 879ed68a12d7..4981a3f461e5 100644
--- a/drivers/crypto/ux500/cryp/cryp_irqp.h
+++ b/drivers/crypto/ux500/cryp/cryp_irqp.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
@@ -13,7 +13,7 @@
 
 #include "cryp_irq.h"
 
-/**
+/*
  *
  * CRYP Registers - Offset mapping
  *     +-----------------+
diff --git a/drivers/crypto/ux500/cryp/cryp_p.h b/drivers/crypto/ux500/cryp/cryp_p.h
index 0df84eaa8531..ba17b1ffd94d 100644
--- a/drivers/crypto/ux500/cryp/cryp_p.h
+++ b/drivers/crypto/ux500/cryp/cryp_p.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
@@ -17,7 +17,7 @@
 #include "cryp.h"
 #include "cryp_irqp.h"
 
-/**
+/*
  * Generic Macros
  */
 #define CRYP_SET_BITS(reg_name, mask) \
@@ -34,7 +34,7 @@
 	writel_relaxed(((readl_relaxed(reg) & ~(mask)) | \
 		(((u32)val << shift) & (mask))), reg)
 
-/**
+/*
  * CRYP specific Macros
  */
 #define CRYP_PERIPHERAL_ID0		0xE3
@@ -48,7 +48,7 @@
 #define CRYP_PCELL_ID2			0x05
 #define CRYP_PCELL_ID3			0xB1
 
-/**
+/*
  * CRYP register default values
  */
 #define MAX_DEVICE_SUPPORT		2
@@ -62,7 +62,7 @@
 #define CRYP_KEY_DEFAULT		0x0
 #define CRYP_INIT_VECT_DEFAULT		0x0
 
-/**
+/*
  * CRYP Control register specific mask
  */
 #define CRYP_CR_SECURE_MASK		BIT(0)
@@ -91,7 +91,7 @@
 #define CRYP_SR_IFEM_MASK		BIT(0)
 #define CRYP_SR_BUSY_MASK		BIT(4)
 
-/**
+/*
  * Bit position used while setting bits in register
  */
 #define CRYP_CR_PRLG_POS		1
@@ -107,7 +107,7 @@
 
 #define CRYP_SR_BUSY_POS		4
 
-/**
+/*
  * CRYP PCRs------PC_NAND control register
  * BIT_MASK
  */
-- 
2.17.1

