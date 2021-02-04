Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E9FC433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA0D64F58
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhBDLPA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbhBDLMx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:53 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6CBC0611BD
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:28 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m1so2641032wml.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhRaK7PEb1+VQbMXp2izacC8TWHkvWpyOp/JFxz8PSk=;
        b=t5B27kseFaSQ07V34VI0+HtMHwzq/iu5wofl4aAA12lmp4bvmT9K7iM/vMiDXIvfmp
         5gVTdvI880u0uezN8PA5uIEwySqb7up76wrmGmKbG1myjs2VLsWE41EmwhWLr4HqTC1N
         dSWu8oC3jxsrIUtMphZ3UnYweS/gT1cGYPQro/LAqTh8PfiMVie9VOuiCMMw/FCWcRVp
         KYrsbsjbMBWMfB4KzcX4FNY+xNmfKOi2vhUA9bUpdllUDvj/CfDlineW9XKQ3Y3VG35l
         XWS4BgTzWKinSO0ZTFANwZbF6Ha33pKPf9YaE8v6ow6eiLsU6AlkdjcQfU9JeHTSEMv0
         eGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhRaK7PEb1+VQbMXp2izacC8TWHkvWpyOp/JFxz8PSk=;
        b=k4b8PKgRhgcncvUprI8L8744DdIcFq7fssBZARV4a2ddTQpGwxs1/qDnhrLSAnI9QG
         oV42uXVAbgwBpZuI2ii8ilzuUrCmqmkCzwbm2vTz4YknR8Cy/akh6/puUL+TMfuuCGVc
         wmApRbhSug/48mTD4XFWRx1ZeFqJ1xinjraNCmtcUFZChfNt0TkcpeyNWox8qG/1kBIe
         pwt2WBAbzhcZTYsvJuNfY6Ib84agmoKpnVVEeW87WwQD53ZKNeuMvYckjYpRfW94jb8e
         HRyGlXfVKyb/tOSNekbJMKGUUdc/rRhKcQ/JYGEcZYBhWh/nqIMmpBYuZyeNzguKyH0i
         HLiQ==
X-Gm-Message-State: AOAM5315znERCDv58fsbFVNlFU83kSg2u2JwjiAIc+Tjz8BBXlLwOyRE
        DyxBem5JvhGjRn/WP5WWr+lx9hA9IOrveg==
X-Google-Smtp-Source: ABdhPJy3ovJmVWJwfdQ/ifr6A3rN/+QEp57dStSFcBGixXRzwdnUgrj5/e3P+zqOCrmcKmI+TdyFRA==
X-Received: by 2002:a1c:6688:: with SMTP id a130mr6944242wmc.1.1612437025976;
        Thu, 04 Feb 2021 03:10:25 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:25 -0800 (PST)
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
Subject: [PATCH 19/20] crypto: nx: Demote header comment and add description for 'nbytes'
Date:   Thu,  4 Feb 2021 11:09:59 +0000
Message-Id: <20210204111000.2800436-20-lee.jones@linaro.org>
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
 drivers/crypto/nx/nx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 0d2dc5be7f192..010be6793c9fc 100644
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
-- 
2.25.1

