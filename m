Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813C4C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Mar 2022 13:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiCFNf0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Mar 2022 08:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiCFNfZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Mar 2022 08:35:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72942674D8
        for <linux-crypto@vger.kernel.org>; Sun,  6 Mar 2022 05:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646573672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=okoQz+er1mtEpQhlIGMyzYLA+XWNBq1rEiDyj9tRP68=;
        b=BqA4NPtqXkB7FHBoPugboWqLMWVosCUYNvrN3vlq3wlFifR7aRWzGXUwqtK0XF36qhrNnk
        fOw2hfjanAJfPYV15EAaaOYMpzUXwvYxa3dyLw/5dMFYOtIVKhHxoWm8zOTISyys1F3rYo
        CZ3n7MEQNtdo4M+kF5PLL2I1z1gXn8A=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-sNNUSPgSOuGRn1_zhvNSmg-1; Sun, 06 Mar 2022 08:34:31 -0500
X-MC-Unique: sNNUSPgSOuGRn1_zhvNSmg-1
Received: by mail-ot1-f71.google.com with SMTP id t26-20020a0568301e3a00b005af6b88cf12so10475897otr.12
        for <linux-crypto@vger.kernel.org>; Sun, 06 Mar 2022 05:34:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=okoQz+er1mtEpQhlIGMyzYLA+XWNBq1rEiDyj9tRP68=;
        b=iyXObDLV6akBt933e1NbxAyuYX8N+fc8n53RAlFFJ1KiF8ppjoxHIsUMwjpsoKvpNP
         Womg+AzWwHDAcD4yI5XjXVtK/y+9efu6KuYakuiUkbu/41oBrv0s5lQUdffgXkh+k/zE
         KuxiWUAD4dACiBnA0CFqDu2RrejThsv323OJ4U+IZ9S/YmhjAe//+zYImXQoHZykIrJl
         Bq9YkdHX9ZoPvBHM6HEfad+83k6a1nN+2Lw+u0wk4a/SgM8mQ0n1C5xN6Ngszrbm3klZ
         YBGEuLmeu9Dzpb4dI+FHd+2Rqd0t7EmH/MXYm+oi0qZt3R56vdOKbBnwKIMZX6Yzhmep
         9izQ==
X-Gm-Message-State: AOAM530QCx3epU2m4OB3FfeoEZOTTdQiH78/yOT6GDI+509GDVelxzBO
        O8/vGRnx51PdsBX4LmtuPldoG+Ruv1kvcmV1h43qHYcIJAtCxOYvNcwo0ZdVIgiCr+a7GwArldt
        K3VNR0gYEIH2f8o1R9jJpHhd7
X-Received: by 2002:a9d:7f9a:0:b0:5af:2536:dc29 with SMTP id t26-20020a9d7f9a000000b005af2536dc29mr3471310otp.104.1646573670314;
        Sun, 06 Mar 2022 05:34:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaaMvi3dDG3tIwVh9fM7WWyJYLsZ3KFmX1mlcZ05fQFQ3xHHEkBj58TgspRgd7PjdBBd2YHQ==
X-Received: by 2002:a9d:7f9a:0:b0:5af:2536:dc29 with SMTP id t26-20020a9d7f9a000000b005af2536dc29mr3471299otp.104.1646573670094;
        Sun, 06 Mar 2022 05:34:30 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id m2-20020a9d4002000000b005a2678bbc5csm4770810ote.24.2022.03.06.05.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 05:34:29 -0800 (PST)
From:   trix@redhat.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] arm64: crypto: cleanup comments
Date:   Sun,  6 Mar 2022 05:34:20 -0800
Message-Id: <20220306133420.769037-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

For spdx, use // for *.c files

Replacements
significanty to significantly

Signed-off-by: Tom Rix <trix@redhat.com>
---
 arch/arm64/crypto/sha3-ce-glue.c   | 2 +-
 arch/arm64/crypto/sha512-armv8.pl  | 2 +-
 arch/arm64/crypto/sha512-ce-glue.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index 8c65cecf560a9..250e1377c481b 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  * sha3-ce-glue.c - core SHA-3 transform using v8.2 Crypto Extensions
  *
diff --git a/arch/arm64/crypto/sha512-armv8.pl b/arch/arm64/crypto/sha512-armv8.pl
index 2d8655d5b1af5..35ec9ae99fe16 100644
--- a/arch/arm64/crypto/sha512-armv8.pl
+++ b/arch/arm64/crypto/sha512-armv8.pl
@@ -43,7 +43,7 @@
 #	on Cortex-A53 (or by 4 cycles per round).
 # (***)	Super-impressive coefficients over gcc-generated code are
 #	indication of some compiler "pathology", most notably code
-#	generated with -mgeneral-regs-only is significanty faster
+#	generated with -mgeneral-regs-only is significantly faster
 #	and the gap is only 40-90%.
 #
 # October 2016.
diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
index e62a094a9d526..94cb7580deb7b 100644
--- a/arch/arm64/crypto/sha512-ce-glue.c
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  * sha512-ce-glue.c - SHA-384/SHA-512 using ARMv8 Crypto Extensions
  *
-- 
2.26.3

