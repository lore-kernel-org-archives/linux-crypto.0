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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2284AC433E2
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Mar 2021 20:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB14E61934
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Mar 2021 20:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCTUZ6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Mar 2021 16:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTUZj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Mar 2021 16:25:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B668CC061574;
        Sat, 20 Mar 2021 13:25:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so9711195pjb.0;
        Sat, 20 Mar 2021 13:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vgEHWfJxSnMvNGltZK35bv4lE0nxYTmBjGCCpSZ2qwE=;
        b=B3AQK37gdKNg75CyXMf9iaXlGL9RQhcnBKwEe3Lieo2WwIYNmzGlinRadiAHCpxnc0
         sct6SsVizPmtD0Wz13XUBxHWj29/ihjOzNHPe4vJiFdv+PuZ9wfPxtoMwhHdVCGWAzVp
         ZSQfzus9F+FSLPgr9VCMTCJxxfOWtfmHHWSFicAV61A9v13xWEGqkYXMhlxOGF3l+jcj
         0dtIy+0LVKzVOzD7uBiQQvtz1hK6bEW3K2sBNtsa1cyQIrv2cAQDFgzdEnIFWfc67xoC
         p6PVv4It8kFPdjLMT2sk7c6yxlqJfZCBf5iH0iyF12uz8TEv82fw0JvSqY7bUq6bDFCP
         2sHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vgEHWfJxSnMvNGltZK35bv4lE0nxYTmBjGCCpSZ2qwE=;
        b=gwyVmglpHNk2WZl77BtlBEWiNCeq2KjtuJrVBGnafd1B3x/MZKrToheHxUFYXJvH0x
         HYlFv3rH2L3NA6D8UTYu3eB8wqVQmThcybYJLmiNY8glYp7NvrOxAtiD0n3JXWCfCHRR
         b+lINTrxVfO+J0Kcf2ra9Z5IM0CgsbQBljRWk1dg0K2wyG0s9M0F2e3rvZxK1hF8jCeg
         Hs/oJieBLMCOpLPTxmNOMGTyb9aplyxBiONZEfYZbM2U+pCFzDXWAYt8nxVh8wVlxo7l
         hTI0zN2ymp8M4/Ccj3V2wFoByi3VkPo8afBiFVjzkRUDi1GN4aQPpq0PwBzBX/fONIbk
         zU4w==
X-Gm-Message-State: AOAM532jiR58iQ5wrfJUjCB98uKQvHvaRPjKdqdIvL10vmQL/+Nsta4k
        M7fg6AHIBoqBJs4CMa97TIY=
X-Google-Smtp-Source: ABdhPJxXOY21EFvd4PI13TZ0reKzvM6BOPt4J0kTB4D7tg4zVYP2zKz48Khz54lVG1zBdJH1yR0q5w==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr5085668pjq.124.1616271938959;
        Sat, 20 Mar 2021 13:25:38 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:1ce8:18d9:6e3d:8c29])
        by smtp.googlemail.com with ESMTPSA id t1sm9252938pfc.173.2021.03.20.13.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 13:25:38 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     leitao@debian.org
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com, corbet@lwn.net,
        rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: vmx: fix incorrect kernel-doc comment syntax in files
Date:   Sun, 21 Mar 2021 01:55:25 +0530
Message-Id: <20210320202525.12562-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are certain files in drivers/crypto/vmx, which follow this syntax,
but the content inside does not comply with kernel-doc.
Such lines were probably not meant for kernel-doc parsing, but are parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.

E.g., presence of kernel-doc like comment in the header line for
drivers/crypto/vmx/vmx.c causes this warning by kernel-doc:

"warning: expecting prototype for Routines supporting VMX instructions on the Power 8(). Prototype was for p8_init() instead"

Similarly for other files too.

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
* Applies perfectly on next-20210319

 drivers/crypto/vmx/aes.c     | 2 +-
 drivers/crypto/vmx/aes_cbc.c | 2 +-
 drivers/crypto/vmx/aes_ctr.c | 2 +-
 drivers/crypto/vmx/aes_xts.c | 2 +-
 drivers/crypto/vmx/ghash.c   | 2 +-
 drivers/crypto/vmx/vmx.c     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index d05c02baebcf..ec06189fbf99 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index d88084447f1c..ed0debc7acb5 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES CBC routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 79ba062ee1c1..9a3da8cd62f3 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES CTR routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 9fee1b1532a4..dabbccb41550 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES XTS routines supporting VMX In-core instructions on Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 14807ac2e3b9..5bc5710a6de0 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * GHASH routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015, 2019 International Business Machines Inc.
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index a40d08e75fc0..7eb713cc87c8 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Routines supporting VMX instructions on the Power 8
  *
  * Copyright (C) 2015 International Business Machines Inc.
-- 
2.17.1

