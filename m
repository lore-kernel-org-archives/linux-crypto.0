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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46C6C433C1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 12:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BEB61944
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Mar 2021 12:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCUMa5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Mar 2021 08:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCUMaY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Mar 2021 08:30:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99953C061574;
        Sun, 21 Mar 2021 05:30:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w8so6944302pjf.4;
        Sun, 21 Mar 2021 05:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KfMzPZjWj4vEWxC64jkBmTku/Bg4RYDhn1mRma2jDt8=;
        b=hegytKpYdRSuP2KRtRXvnXoxRL6o5TUG6vOY4yeXASkte2gkTvZzYhTtSmPnxAq+v9
         9Hcn68jY5tETkaXali7jJZwmv0qJJ4qKDuqsQ8a/7ddrRCBVr6rqHtAjCCWEmMoSxQ8C
         xj4AvwuHiarQk0OF3AUhT21yIOgrguIaVndkjaXXDmonXpLrs+xulUoFFlHr7JvvfuqQ
         ag67lyTseGR3cQkkgmZO5w9Kb3IY4mII+7z3Mz3U8K+LLGglSTA5zny0fZLXhXRrIChW
         GDcrbjaL8URhLtnkfkr4BuqnJBntGZJ1y1NI4r8LA9fGb9CHVhb0KibU1KZ7Z6Jt34zb
         AAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KfMzPZjWj4vEWxC64jkBmTku/Bg4RYDhn1mRma2jDt8=;
        b=ly/6mNKY3JtSmjp5KZCjhid67A0cPJ9USF/tExkuwPgNPxlPcpuMqhIeon/IKU3iUD
         WZH/TIXkG6zQP8GFvVx2SzbjA7YNPfv2FN2W59YAwxbv1VMqGpWvC0IKqUOdRWOHNaLm
         1jDIJ5TN2SJfX0nU3aI324j9q961gOUHlP5gUr3U5jbimpQO0t+1uFLy7P7XKNECeBxA
         UpgWP7UFxmEp138H1O4xiErcpgHxBO0NLnLQnbuQFPbLLjc3T9NHXQZNcm6HXABGKjhU
         u4CVt+l/EFMf/sgaG13BhhdxF1aX6vaQUhDckMBN5Y7z+K/4SnWNaSVOlNc2QAa6+XSK
         AosQ==
X-Gm-Message-State: AOAM533ff/iBBcxCyFvaWPKuO0Y2MvGn6YDJPi9R4hmfzarg8CBKCpoG
        F0EwMkkoLhHBiCTCxIScfcrK/5p0lcx5hfo0
X-Google-Smtp-Source: ABdhPJxrZpRtLJ/jkSAjBSxfQgEgy62uvjYCzEAtSUy2I9ELjZgwt4OUC4GFVa3L3gPwSN14gkfhNg==
X-Received: by 2002:a17:90a:8c08:: with SMTP id a8mr8252584pjo.136.1616329820543;
        Sun, 21 Mar 2021 05:30:20 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:4cb7:d0cb:1241:5cf8])
        by smtp.googlemail.com with ESMTPSA id f135sm10627171pfa.102.2021.03.21.05.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 05:30:20 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com, corbet@lwn.net,
        rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org, leitao@debian.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] crypto: nx: fix incorrect kernel-doc comment syntax in files
Date:   Sun, 21 Mar 2021 18:00:07 +0530
Message-Id: <20210321123007.15505-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are certain files in drivers/crypto/nx, which follow this syntax,
but the content inside does not comply with kernel-doc.
Such lines were probably not meant for kernel-doc parsing, but are parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.

E.g., presence of kernel-doc like comment in the header lines for
drivers/crypto/nx/nx-sha256.c at header causes these warnings:
"warning: Function parameter or member 'tfm' not described in 'nx_crypto_ctx_sha256_init'"
"warning: expecting prototype for SHA(). Prototype was for nx_crypto_ctx_sha256_init() instead"

Similarly for other files too.

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
* Applies perfectly on next-20210319

 drivers/crypto/nx/nx-aes-cbc.c  | 2 +-
 drivers/crypto/nx/nx-aes-ccm.c  | 2 +-
 drivers/crypto/nx/nx-aes-ctr.c  | 2 +-
 drivers/crypto/nx/nx-aes-ecb.c  | 2 +-
 drivers/crypto/nx/nx-aes-gcm.c  | 2 +-
 drivers/crypto/nx/nx-aes-xcbc.c | 2 +-
 drivers/crypto/nx/nx-sha256.c   | 2 +-
 drivers/crypto/nx/nx-sha512.c   | 2 +-
 drivers/crypto/nx/nx.c          | 2 +-
 drivers/crypto/nx/nx_debugfs.c  | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 92e921eceed7..d6314ea9ae89 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES CBC routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 4c9362eebefd..e7384d107573 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES CCM routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 6d5ce1a66f1e..13f518802343 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES CTR routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index 77e338dc33f1..7a729dc2bc17 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES ECB routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 19c6ed5baea4..fc9baca13920 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES GCM routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-aes-xcbc.c b/drivers/crypto/nx/nx-aes-xcbc.c
index 48dc1c98ca52..eb5c8f689360 100644
--- a/drivers/crypto/nx/nx-aes-xcbc.c
+++ b/drivers/crypto/nx/nx-aes-xcbc.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES XCBC routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index 90d9a37a57f6..b0ad665e4bda 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * SHA-256 routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index eb8627a0f317..c29103a1a0b6 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * SHA-512 routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 1d0e8a1ba160..13bb705ba6a4 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx_debugfs.c b/drivers/crypto/nx/nx_debugfs.c
index 1975bcbee997..ee7cd88bb10a 100644
--- a/drivers/crypto/nx/nx_debugfs.c
+++ b/drivers/crypto/nx/nx_debugfs.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * debugfs routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
-- 
2.17.1

