Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A05C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092C361288
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhEKNaq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 09:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKNaq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 09:30:46 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB106C061574
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:39 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c15so10592543ljr.7
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BOC1UntVrV5zpNlzc6ixNauCfquIt1wUm//U5RB1WOI=;
        b=TM7CX+82noRx77PkMPt/YgmdCrtU3FwSChdWmTv+NUiRJRwPyRoHaTS7u+oRKQbI45
         7i/hD1qQ42tyKFhX5sv55KqXRx7cV+GKOOF/GDYcBGeEXLwSE9PbO5uSJoPFYO+1xs/C
         E62X9YvJw7hXcDhGiCGyirNeFb1aMI9pDCpt0cYK+7CTgJOTLSVPopnE5KUyTPAoQvXm
         A/XtaRLD9leKaBjN+rWUx5pxYjZ6aVmW/rbU4hU1/5Gl1Q0hgp76bdPIEOt3BtXAXkjF
         hLgOOFBuV5kn7MT8gSU6mJIV347P2xb61AxreK2xvx52aEh+8r5Mqe1r8eC8coepL088
         k1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BOC1UntVrV5zpNlzc6ixNauCfquIt1wUm//U5RB1WOI=;
        b=MjNdB7pj0UEeLVqpVO4kYZ1kGG1rxCexC5J02S70o6e6fHA6p8wo4ypPruCgGtsdv+
         PST9RH+pnQwQoiJTjcI1ebQ//MbK/M32KzqBBNK2Pg0SQIT3/hV76psP6urS8BXsuJoZ
         NVyIQVozWnO2xUSC6NTi6dXyEusI/+hJyYgoAu0qHsYDzbwRC7M7LbhiuLDjGXhCPQZV
         Se8Pmlacz/teFn0omwzfpwo/TzUkUE5UN57itdJ01hvrlypixVQTDGLCH+/fQRa+SsqX
         XqsYlFvJiY5v4vNTlWMkKhFMKzXrT/AvgzZHwMm2rdmVBvzQTPNkH1QhTIao3iEm1sYl
         UdPQ==
X-Gm-Message-State: AOAM531njHgGVDr0KqZHI3D063l226nR2cP65rtfDhXnHjCY+ib+jf/i
        PH7MR6+M6H35vjrXfcmB3UoNYw==
X-Google-Smtp-Source: ABdhPJyYRyB7uWwYBg2eYcXb1/pnGegSSgmXehxzKSGFoDwBt9+LZ6GaE8UVNHOZDswl6+RuaUAw2w==
X-Received: by 2002:a2e:9b84:: with SMTP id z4mr2599640lji.341.1620739778309;
        Tue, 11 May 2021 06:29:38 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m4sm3699740ljc.20.2021.05.11.06.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:29:38 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Deepak Saxena <dsaxena@plexity.net>
Cc:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/5] hw_random: ixp4xx: Use SPDX license tag
Date:   Tue, 11 May 2021 15:29:25 +0200
Message-Id: <20210511132928.814697-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511132928.814697-1-linus.walleij@linaro.org>
References: <20210511132928.814697-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This switches the IXP4xx hardware random driver to use
the SPDX type license tag.

Cc: Deepak Saxena <dsaxena@plexity.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The idea is to apply this through the ARM SoC tree along
with other IXP4xx refactorings.
Please tell me if you prefer another solution.
---
 drivers/char/hw_random/ixp4xx-rng.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/ixp4xx-rng.c b/drivers/char/hw_random/ixp4xx-rng.c
index 34781028caec..defd8176cb68 100644
--- a/drivers/char/hw_random/ixp4xx-rng.c
+++ b/drivers/char/hw_random/ixp4xx-rng.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * drivers/char/hw_random/ixp4xx-rng.c
  *
@@ -8,10 +9,6 @@
  * Copyright 2005 (c) MontaVista Software, Inc.
  *
  * Fixes by Michael Buesch
- *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/kernel.h>
-- 
2.30.2

