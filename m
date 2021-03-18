Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5B9C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF82D64F6A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCRMpD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhCRMok (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:40 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9AC06175F
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o16so5400991wrn.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zaL0nEsFAcBhqqjVU0O9HWEXuIfJLm4ctcMaPZZ2Fv8=;
        b=u1uybo/3FAiXPDTpmZbhBVHRlCyMsvBiUVr1KAvKPW/DdL0v2F3sz3aE7rCh9B0/Le
         RhXj8JlOQu6ABxbUgMbvk1ThGTUYdZxSOzQDxKtLxJGHVSSR7Y3FbnziMeJD2pscp5YE
         PXNc30MtxRnWOQORn2ijZxgqSSepMjnOJ4It8tGdYoTBFlKAZO/815gsueRm0M4uZHU/
         jcUnbDyyyrmBvnVBvdi4/PioB1vuvbHs14VrSoBzUDMfKDZOukoeTgMU/lCJRceY/sud
         NofUP7YfGoSyhb/jtbSfFNqRkJ7HbdkH90gZO0pXAu2VgHuJItjKA/NXnzRAibHwKcz7
         XFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zaL0nEsFAcBhqqjVU0O9HWEXuIfJLm4ctcMaPZZ2Fv8=;
        b=qCSDY1a1Q8CxNq0qDjZfDi27tHO3G/XodqQthwm6yITamTYWC7bdthU4fTuLJWUOO6
         4ximYGviKHcsG1bmcyBwQdEMtJFpdLnJuMO2XVUZaZKU4LvirdvgXydHNPQXqi5nIa1d
         UqVHNfWHhTOisWGcRrMU/EdeI885IU4HGXTfon9CuARzOUVo4qDMFoF+ZQ9wN8bLWh7M
         2kkxiq+/9S4nkDTlxmZ8Vs7Cp5KBBZND0+pazFH+KPSid/0ZNyhG1lkmWUwefjjYG+5c
         l3FbeYRypjmzGIgIGX/DmZ+Z7FbUEvkTuL4GmEq+F04KhJD/wjum1me9MHkup9Lin40J
         Bn6g==
X-Gm-Message-State: AOAM531lYLymr6M6nHTV8OBh+rJ55l1H0BAAzw1w6XJvImLh7uZS+oHU
        XwNq9He+QmSuvPvJyX9+i6/APQ==
X-Google-Smtp-Source: ABdhPJyjLfIa9YueaDjBRXGN+wEAk47szCZUoN6lqkyrN05yel9okdpLdt34EXFVhs28uVSpXSBIxQ==
X-Received: by 2002:adf:c587:: with SMTP id m7mr9362514wrg.369.1616071479028;
        Thu, 18 Mar 2021 05:44:39 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id q15sm2813900wrx.56.2021.03.18.05.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 05:44:38 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kent Yoder <yoder1@us.ibm.com>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 09/10] crypto: nx: nx-aes-cbc: Repair some kernel-doc problems
Date:   Thu, 18 Mar 2021 12:44:21 +0000
Message-Id: <20210318124422.3200180-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124422.3200180-1-lee.jones@linaro.org>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/nx/nx-aes-cbc.c:24: warning: Function parameter or member 'tfm' not described in 'cbc_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-cbc.c:24: warning: Function parameter or member 'in_key' not described in 'cbc_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-cbc.c:24: warning: Function parameter or member 'key_len' not described in 'cbc_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-cbc.c:24: warning: expecting prototype for Nest Accelerators driver(). Prototype was for cbc_aes_nx_set_key() instead
 drivers/crypto/nx/nx_debugfs.c:34: warning: Function parameter or member 'drv' not described in 'nx_debugfs_init'
 drivers/crypto/nx/nx_debugfs.c:34: warning: expecting prototype for Nest Accelerators driver(). Prototype was for nx_debugfs_init() instead
 drivers/crypto/nx/nx.c:31: warning: Incorrect use of kernel-doc format:  * nx_hcall_sync - make an H_COP_OP hcall for the passed in op structure
 drivers/crypto/nx/nx.c:43: warning: Function parameter or member 'nx_ctx' not described in 'nx_hcall_sync'
 drivers/crypto/nx/nx.c:43: warning: Function parameter or member 'op' not described in 'nx_hcall_sync'
 drivers/crypto/nx/nx.c:43: warning: Function parameter or member 'may_sleep' not described in 'nx_hcall_sync'
 drivers/crypto/nx/nx.c:43: warning: expecting prototype for Nest Accelerators driver(). Prototype was for nx_hcall_sync() instead
 drivers/crypto/nx/nx.c:209: warning: Function parameter or member 'nbytes' not described in 'trim_sg_list'

Cc: "Breno Leitão" <leitao@debian.org>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kent Yoder <yoder1@us.ibm.com>
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/nx/nx-aes-cbc.c | 2 +-
 drivers/crypto/nx/nx.c         | 5 +++--
 drivers/crypto/nx/nx_debugfs.c | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 92e921eceed75..d6314ea9ae896 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * AES CBC routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 1d0e8a1ba1605..010e87d9da36b 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Routines supporting the Power 7+ Nest Accelerators driver
  *
  * Copyright (C) 2011-2012 International Business Machines Inc.
@@ -200,7 +200,8 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
  * @sg: sg list head
  * @end: sg lisg end
  * @delta:  is the amount we need to crop in order to bound the list.
- *
+ * @nbytes: length of data in the scatterlists or data length - whichever
+ *          is greater.
  */
 static long int trim_sg_list(struct nx_sg *sg,
 			     struct nx_sg *end,
diff --git a/drivers/crypto/nx/nx_debugfs.c b/drivers/crypto/nx/nx_debugfs.c
index 1975bcbee9974..ee7cd88bb10a7 100644
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
2.27.0

