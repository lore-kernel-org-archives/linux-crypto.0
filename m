Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007B7C432C3
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2F764F4F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbhCDAHX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbhCCOhw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 09:37:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0BEC061A2A
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 06:35:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e10so23685708wro.12
        for <linux-crypto@vger.kernel.org>; Wed, 03 Mar 2021 06:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4foJK0tE+WL3lsMryI6KM5lFp3YWmzugBxJCQxMDWAg=;
        b=inVGwKaDwve1QjGO3jdDapDzAs0FwzTQPLRFIf7SaA3wWNHK40p/mxs0i2GoIsGiHT
         t7lE3EBbvOM85d3bDMDXRkCIQydJou0eH5L+svxCsdQcZepoyhJyYEDqb6xT505CStDm
         4pBfUpT719TsH14oSiB+9sZgSA/A/k+k6gGITlEtZrK7j7RfU2pbR32iG/MwWvLPMcyh
         CROUzpdIQBrzk5qQbrI7lpgOQIYz1wzDxv6YlUptI6pj7WwOksxLDvuezKPgZN/IIaqC
         ozTph8dGppYHqhijDMjqB84LSBXZqxTmFlijBAAGDHdrR6Qx/BvU1mhpSwg8Jk6sxGL/
         Vo4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4foJK0tE+WL3lsMryI6KM5lFp3YWmzugBxJCQxMDWAg=;
        b=TZutCZYiTm6Rg71AMtntdu8r0kacT+7QrlsiXqgPPiybKVy0W4k2Xr7HNwbRmJewj4
         +tt+Io11aXYWY2Em3OD/TAIf91hcRBIjVzjQqfus0czqmJ6ix0snURDw5yR9Wv8M3+V9
         pNKFabpLRMjdyPQenAiago8qNXSr/XJhKXKo7CWYIUmt37neLe+2mG9ZDG0F+9aqTLaA
         bhCscCqaQfjjfzHTPXxOA3T4oSOXj1LGNVVv8N6T1zyvyts8uUWJnWrgjuzE+zygz0hT
         jBb6CcUtF3TCa99IiftkjatfTDTWm/HVrRWuR8oJ8WTSe6O6oqJ9CZsuGK6MvQWV+qWo
         0g/A==
X-Gm-Message-State: AOAM5321cZexMRuGwkQwlVvJVgko62lrOxyjOidTzIm/e+Os4I9dAYcB
        bw2eVwaVimFk2byoJXGGtpHn4g==
X-Google-Smtp-Source: ABdhPJzdA8pPcfZiXk+evYjz2Y3wLPi3yh1CrDiz/dUpDBPwE6XlZUV0r3+anNFsYboAx/uy9+O1yg==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr18581487wrp.118.1614782105696;
        Wed, 03 Mar 2021 06:35:05 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f16sm31475923wrt.21.2021.03.03.06.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:35:05 -0800 (PST)
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
        Henrique Cerri <mhcerri@br.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 08/10] crypto: vmx: Source headers are not good kernel-doc candidates
Date:   Wed,  3 Mar 2021 14:34:47 +0000
Message-Id: <20210303143449.3170813-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303143449.3170813-1-lee.jones@linaro.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/vmx/vmx.c:23: warning: expecting prototype for Routines supporting VMX instructions on the Power 8(). Prototype was for p8_init() instead

Cc: "Breno Leitão" <leitao@debian.org>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Henrique Cerri <mhcerri@br.ibm.com>
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index a40d08e75fc0b..7eb713cc87c8c 100644
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
2.27.0

