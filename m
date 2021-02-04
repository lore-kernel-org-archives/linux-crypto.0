Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BF7C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8AF64F5C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhBDLPL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbhBDLMo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:44 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7218C0611C1
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:24 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a1so3006625wrq.6
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WH1ZkfxgQ3lo4eJG51Uh12VlkOp1jMaFfnNoEjI139M=;
        b=Fwbq732n3XUVYiF70e2xZk4Vv0WePzbXGtV9K9CQP0xq5MmYe2c1lY5kO8By5tRjBe
         h/KA0K8rJ45UbLKMQLzOekJPUNVk5R0Om5p11Ff0vp99wZakGBPCBj8dWsHSAvV/t1Jy
         Em53nt90VnSrtADHul75DC0T1PvBiYW6mxchyjXt+UDaBOqcW3io+1cHBqMULe5ZSN9k
         9VaxajxrSgxEtiTW6jkWSFCATt4sKdT1RhryJqH+6qBX9rzO/9FE9T8WR7IlAugxKF4f
         AKRQOxG56UXsyGqq9pkdFUnBuY5dZU6VpUrZCTdsDpJvbLR08WYPESgjONFzBpadKw1x
         3MPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WH1ZkfxgQ3lo4eJG51Uh12VlkOp1jMaFfnNoEjI139M=;
        b=TTuqBn5LYKDq1tmhr/zsZYkiTFe9BTMo0YYFLkSJzN7ZfJg+v+QYy3YCjAyAkSikx8
         ZAwcqJXeoMTCyvu5JohM9s1OTNw2kKNIzzY0GPPnPFdgKhxC8UXdo9FynI5jmLwyvNcS
         aSNaXtT2O46ehTUXE7UjectkieE+5NJbqEv6YEPR/Uu25p9yqLQjcO2HQwabQPprKfs+
         qsu9X43Zw3mc6kLdcow4IqflpZlwIGSK+SDlcL5JwLQJwDedmE0/hD3Eown9NHwgvXoU
         ne8+l4CuAOqj//53sbpq7NuB9ThsoWgibcXhxYZa6ebMybsPbU6Gkf6nv5gpc6PRRRSq
         LMbA==
X-Gm-Message-State: AOAM533nJmest3aFp95VWUt0Uhh+F9UbAoyYpbXIRQBFo0Cm5H1NhHEn
        FtcgJjqUmxCwbx/ZYR/5fJsSzQ==
X-Google-Smtp-Source: ABdhPJzjUp9+e7p/dg0UnaZ0rUY3UY0nKqEvrLN6uQoqxKKkifC3adrh0/+QNGokJy751vuZFU+CFw==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr8658453wrq.320.1612437023472;
        Thu, 04 Feb 2021 03:10:23 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:22 -0800 (PST)
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
Subject: [PATCH 17/20] crypto: nx: nx-aes-cbc: Headers comments should not be kernel-doc
Date:   Thu,  4 Feb 2021 11:09:57 +0000
Message-Id: <20210204111000.2800436-18-lee.jones@linaro.org>
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

 drivers/crypto/nx/nx-aes-cbc.c:24: warning: Function parameter or member 'tfm' not described in 'cbc_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-cbc.c:24: warning: Function parameter or member 'in_key' not described in 'cbc_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-cbc.c:24: warning: Function parameter or member 'key_len' not described in 'cbc_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-cbc.c:24: warning: expecting prototype for Nest Accelerators driver(). Prototype was for cbc_aes_nx_set_key() instead

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.25.1

