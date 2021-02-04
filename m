Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039A8C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9C864DBA
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbhBDLRZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235716AbhBDLMT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:19 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8523FC0611C0
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:23 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id w4so2744673wmi.4
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZFcUa8z9ij8GsVZGG8CeCF7Ivx0FCQR9n9Ud5IB6q0=;
        b=yoOOHsJmUFa9/ZMIOvUiWAVGaV0lecpKRROSNn73bOTaoWxilhWpNvougW3IaJU11M
         BVkhVn/LG7rzlvj+VFlMOu2jZ16XdmDP7j7nFPRSoQfbQGizNQ0MysoTX/Ih0sURIkkJ
         jj2NKa4nkkgpng7ay0Yb/XckBZF6BoHaNRvJxyE0CFDhvk/OQMGNw6P52ILsu/BLONMX
         sGU9ch76oz25jqxjuLtMuFlH5wg1GQjs8Su8XyxDU7H84HQ6aUmAroBCLgq4h+/I22QB
         U8SZRrv4BsmpmnvZt6lJ9Y4abHaGLyIEQ9BJGCbmgZEEN4Cbv/Cjar+aCibvBqgV7jDz
         IW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZFcUa8z9ij8GsVZGG8CeCF7Ivx0FCQR9n9Ud5IB6q0=;
        b=KGppnKUiWVWglRkjH+SH1uouvYgywF/LJfNaZTNTpfS38EtD15s+NhnWCUAMIbE93y
         V7n9sQ3Px/qWgPVSnp8gt6K9KzxTbH8WEj3DVO6+FBMZ+nocGwgy7SmSNwLiIKWyzVmC
         rYkbrGsmoy2sBBMmuv27JrH8sFv4B2y+iIpaDQoeoZYoMtMSPbTAKzxVVGRcis7SUPNF
         0Da4PrvEd/F5SXHJr8IouoNEXl2qcmq05TXdT5tgp25NZeLuapBMdjMTk0jzsPKZFLPl
         3yq47BM210DuOgoXjPdYte7j9U0yLoRI1pY0RSTW0juBaFVJo7Y3y13mH/fGelAwtCHm
         +bsQ==
X-Gm-Message-State: AOAM533bLW5KzI4hW/g+d6aB0E0UWjGYX4ekgIhHIGGu8aIbSTbdTQpm
        8AQ5ZnKPVruYnm8yLttC97A9Cw==
X-Google-Smtp-Source: ABdhPJyH2Oy1OTUDZXbRtCQuenPHqsyeaSnIpQ8LSjm16+yMUa9mogmKK1zeOQjPoP79U3cAkVO7Jg==
X-Received: by 2002:a1c:1f4d:: with SMTP id f74mr7213122wmf.12.1612437022191;
        Thu, 04 Feb 2021 03:10:22 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:21 -0800 (PST)
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
Subject: [PATCH 16/20] crypto: vmx: Source headers are not good kernel-doc candidates
Date:   Thu,  4 Feb 2021 11:09:56 +0000
Message-Id: <20210204111000.2800436-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
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
2.25.1

