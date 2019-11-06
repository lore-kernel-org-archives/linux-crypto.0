Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE54C5DF65
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3CF20663
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xf2Ks/Jq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfKFOOA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:14:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36044 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731854AbfKFONb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:13:31 -0500
Received: by mail-wm1-f67.google.com with SMTP id c22so3546747wmd.1
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QNZ1kA4q8aBB50NVJWu8PbKcs9AjHNKMK3pxZ9fNJP4=;
        b=Xf2Ks/Jq/ihGwNCma8VLqakFtNZHKXIuWjUMxPXRRbJUiPMCjNJdWtn/qgWP/5sax7
         Ujfw6TL3LrTHr+uDBhPChxFljQzS5xgGpRxtwOO3Cwx5CN9yZ8J+CA955DxnUVBtrQY9
         UQ1bY0WghbSRoxyO+YnPSEFpDzUjl87KqEH5SgdaSVeeYvhaF4C+6ymBYsygd0tMpK+B
         v1Ysb6J+hZxqg7dNd/kemAXJbzAWO4QDbjPoSV2WnuX18FdLVu+FkYfbLwr3DTApGJwK
         qos9OGs4AuUlU8h/o/Y+yYw2NPn+omvenj9islnObpixtFKklAt0n2mEtWosrHsO99wv
         YyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QNZ1kA4q8aBB50NVJWu8PbKcs9AjHNKMK3pxZ9fNJP4=;
        b=Hv2DQ3iMw7RQt1lJXlX2HDYg8+8P9FwVTs4bLHX2NaI25MmLnpuMkqVpohZr9RbwYY
         jvXGSJwAz1qdd7wGLW42e+bcHUSVQXnZpJyG29XghuRMyFRb89/DQ4YNl1EwAdhes+bS
         503T40lN++3UIpboDTt82Q6vXqjzBsWbDm4/IAY5nXoFRy+00ZzY/QJVXO/Gq847b5cU
         OvdwT8GBXaEvVQcfbqr+eLhdm/DssxRBntGtfcxbeqsfz2V+9sPkETb9+pTm4A7DlL3U
         jqf6jMSR9JSZYFKjiGmnFNZui8lKBDL11jrJemPcsSizhVCLwJZx9tVFLYopXcxhnMJs
         hLIw==
X-Gm-Message-State: APjAAAXfAvwr+pnMzqSN18xpF6eyS0GLddtyNcoukilEPlLUeiyX8Rx+
        MG522DzbOV0Bj4lvfHIef36113dkTfBC7w==
X-Google-Smtp-Source: APXvYqxlrxPHyV7WtfZwm6qyJvzgfUOUugHAQxtpX4eBnKipnxbgOwtoZZo0ZBiVDsCnO8UnT+Wz5A==
X-Received: by 2002:a1c:544b:: with SMTP id p11mr2802294wmi.46.1573049609122;
        Wed, 06 Nov 2019 06:13:29 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id b3sm2837556wma.13.2019.11.06.06.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:13:28 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 04/10] linux/random.h: Remove arch_has_random, arch_has_random_seed
Date:   Wed,  6 Nov 2019 15:13:02 +0100
Message-Id: <20191106141308.30535-5-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106141308.30535-1-rth@twiddle.net>
References: <20191106141308.30535-1-rth@twiddle.net>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The arm64 version of archrandom.h will need to be able to test for
support and read the random number without preemption, so a separate
query predicate is not practical.

Since this part of the generic interface is unused, remove it.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 include/linux/random.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index f189c927fdea..7fd0360908d2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -175,10 +175,6 @@ static inline bool arch_get_random_int(unsigned int *v)
 {
 	return 0;
 }
-static inline bool arch_has_random(void)
-{
-	return 0;
-}
 static inline bool arch_get_random_seed_long(unsigned long *v)
 {
 	return 0;
@@ -187,10 +183,6 @@ static inline bool arch_get_random_seed_int(unsigned int *v)
 {
 	return 0;
 }
-static inline bool arch_has_random_seed(void)
-{
-	return 0;
-}
 #endif
 
 /* Pseudo random number generator from numerical recipes. */
-- 
2.17.1

