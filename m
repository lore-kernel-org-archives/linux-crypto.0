Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC8AC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F378364F5C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhBDLNU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbhBDLMM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:12 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C713C061352
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:14 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id j11so2752102wmi.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jD3fDhqrGmZlQJN4sE5tqUAObb8EheXiffPU2HNHONI=;
        b=SZwwWIeVUbG3QySuaV0bjefGVojXmvsBnf9OYpQkKUvrnDCTOz+SDdZdx557SGy7El
         E5ZPs6j/XSEL0D9wmKBdkDNTySxzq7Vl49xedFQDnrCEJgbQ0EHVSWrfHHw492aotv79
         dsEeAEPP5du/ijeMImA+bpaUTWR6LihUNwMRIHRtnNX2w5vTdds2aC/l7z/HBN9VKjoN
         7FMf1ohwJF0XNhE6UhUhflqOFeQl46S78SZdtcf42pFpO8iBsgjvfiybhLV7g5Gsq7lZ
         kG6ah3FwOu28XQyE91aJ22X5TQkQ8NGIKw5HmYmygpAe0sBXNdgqLD6U16BiIuAn3rAG
         QmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jD3fDhqrGmZlQJN4sE5tqUAObb8EheXiffPU2HNHONI=;
        b=eOFQ9B6X8WUkJyZ9cjLYFYSVBEK9CP9htTxWmPtKRqWtah8A/z5aVra3zQsFSVxu+q
         cJmKpkuwOSQUT+1i6y7zTDz2mZV+8eQawEWAFrFha8FE1PgSml9SWMfNYklnMPIlOUnz
         imZTDlJrQgT2UxwOGvPL/3mFGFxF3EKIQpkJVZno22RxgZ6UO2MQtKP+vAE9tGY0lSq9
         W1aA2GOZ05XtZRUHLKiM1yrASyIRXp0lNUw5euCE8/LuAovCRkvmVZIxLIWBsKEks2qU
         DmhMdN7/BRgGRbA7fF4i247QPQj9tIJDEOD1lRZNXnEP4kzCy0a+m/4BOBrXSuXlXJWq
         e5rA==
X-Gm-Message-State: AOAM533q177SNU15A0VvZW6JVG5P3/8E+pEvzyo/CUIXBiqcYlBrHFMr
        hZOtqEpuD4CfAF6yEgcJV066gA==
X-Google-Smtp-Source: ABdhPJzVT/7n6AdOU6B1akQQoIhqbYcrMOm6Gs+rjqT0lZnEi6yTeq/L26AxS87ReLE9AQ6SRbroOg==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr3910742wmb.116.1612437013148;
        Thu, 04 Feb 2021 03:10:13 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Shujuan Chen <shujuan.chen@stericsson.com>,
        Jonas Linde <jonas.linde@stericsson.com>,
        Niklas Hernaeus <niklas.hernaeus@stericsson.com>,
        Joakim Bech <joakim.xx.bech@stericsson.com>,
        Berne Hebark <berne.herbark@stericsson.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 08/20] crypto: ux500: cryp: Demote some conformant non-kernel headers fix another
Date:   Thu,  4 Feb 2021 11:09:48 +0000
Message-Id: <20210204111000.2800436-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/ux500/cryp/cryp.c:19: warning: Incorrect use of kernel-doc format:  * cryp_wait_until_done - wait until the device logic is not busy
 drivers/crypto/ux500/cryp/cryp.c:22: warning: Function parameter or member 'device_data' not described in 'cryp_wait_until_done'
 drivers/crypto/ux500/cryp/cryp.c:22: warning: expecting prototype for ST(). Prototype was for cryp_wait_until_done() instead
 drivers/crypto/ux500/cryp/cryp.c:292: warning: Function parameter or member 'cryp_mode' not described in 'cryp_save_device_context'

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Shujuan Chen <shujuan.chen@stericsson.com>
Cc: Jonas Linde <jonas.linde@stericsson.com>
Cc: Niklas Hernaeus <niklas.hernaeus@stericsson.com>
Cc: Joakim Bech <joakim.xx.bech@stericsson.com>
Cc: Berne Hebark <berne.herbark@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.c b/drivers/crypto/ux500/cryp/cryp.c
index 9866c2a5e9a70..759d0d9786fd1 100644
--- a/drivers/crypto/ux500/cryp/cryp.c
+++ b/drivers/crypto/ux500/cryp/cryp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * Copyright (C) ST-Ericsson SA 2010
  * Author: Shujuan Chen <shujuan.chen@stericsson.com> for ST-Ericsson.
  * Author: Jonas Linde <jonas.linde@stericsson.com> for ST-Ericsson.
@@ -15,7 +15,7 @@
 #include "cryp_p.h"
 #include "cryp.h"
 
-/**
+/*
  * cryp_wait_until_done - wait until the device logic is not busy
  */
 void cryp_wait_until_done(struct cryp_device_data *device_data)
@@ -285,6 +285,7 @@ int cryp_configure_init_vector(struct cryp_device_data *device_data,
  *				other device context parameter
  * @device_data: Pointer to the device data struct for base address.
  * @ctx: Crypto device context
+ * @cryp_mode: Mode: Polling, Interrupt or DMA
  */
 void cryp_save_device_context(struct cryp_device_data *device_data,
 			      struct cryp_device_context *ctx,
-- 
2.25.1

