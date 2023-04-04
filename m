Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C471DC761A6
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Apr 2023 18:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbjDDS0j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbjDDS0L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2023 14:26:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3B772A0
        for <linux-crypto@vger.kernel.org>; Tue,  4 Apr 2023 11:23:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q102so31475865pjq.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2023 11:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680632608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gqxa4spepTnsUwVbNTwSWIuFxwC658E+AuuPxXktYUk=;
        b=kAvoNYqdv/gD8yskD/3UsIZZx/i7x6fcbhJrbItIXOVXMaf2J/ZphfqXiq9a0kB1u6
         PmIxtinJIL/VK4LPrFwgURCxv3uMUJaXR8WupowGpRdbZYxe85vGf7ADA3kpdGLGAjbw
         doyBX/v48bQyNdsiTbpiqy+9xqhSQ/wjueeo3mWjHXI7j5kcoXr3GBMPSRO6QBlcfYJL
         R/rE84Q8SYe+o93Fsj2ITB9DYOXg1jXgXV57Lpo/XLRh+NBFQ/p1nNn9hZqy4KxK2o/2
         A9STBeEYXkETh3CnhrVKqaS3widasWrESAX5SSaNCUkVwZAhEOTn5+5CcS1XD6b614hV
         WsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gqxa4spepTnsUwVbNTwSWIuFxwC658E+AuuPxXktYUk=;
        b=Gvnh7ObPJX6Hr159d5/rAHXSUpTOgFJ2HIn2JkUMOKL7QabJRxz8NZQ/kz5MspyNf9
         h6P9zxsX7NiPnRsytpFXorE2fLX5z8fyGMUfPEAgfZBrUEnlED70e44gaj4Bk418G3Vu
         HtugV33jjCXs6+se9UdFNV/jpA5XwDQNjGb1OCwXAPwletVZuXNAUltZlxDZqkB7KAJV
         oh5uKyJarSGXshTp/AEqNS5nXJsiQjKrMFRQPtkC8+YnKUfz1XTAg9MJQSl0n+GgZfpb
         31rRx8PLAXLTfmnOir+SYSA+XHXF6itQqo+Oz09rK1rvpMbggJjDHdw0fflbt/SqmLYU
         chLg==
X-Gm-Message-State: AAQBX9fenKYyyvim6hH3IT50efql4rckUmqXJFZYkbXWs1ZAsdFv9LH0
        hknNfyhb4UvZCKnOJMNQeIj3XQ==
X-Google-Smtp-Source: AKy350bWUm4xmbDDUw2nmPYP8Z7MtcO7/jXhnD91vBLbrD3SWPHhJwbKHL30pf+O4r7dr/bP2clOAg==
X-Received: by 2002:a05:6a20:6687:b0:db:6a5a:3ce7 with SMTP id o7-20020a056a20668700b000db6a5a3ce7mr2798195pzh.12.1680632608339;
        Tue, 04 Apr 2023 11:23:28 -0700 (PDT)
Received: from localhost.localdomain ([106.51.184.50])
        by smtp.gmail.com with ESMTPSA id o12-20020a056a001bcc00b0062dcf5c01f9sm9018524pfw.36.2023.04.04.11.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:23:28 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Len Brown <lenb@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marc Zyngier <maz@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sunil V L <sunilvl@ventanamicro.com>
Subject: [PATCH V4 23/23] crypto: hisilicon/qm: Workaround to enable build with RISC-V clang
Date:   Tue,  4 Apr 2023 23:50:37 +0530
Message-Id: <20230404182037.863533-24-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404182037.863533-1-sunilvl@ventanamicro.com>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With CONFIG_ACPI enabled for RISC-V, this driver gets enabled in
allmodconfig build. The gcc tool chain builds this driver removing the
inline arm64 assembly code. However, clang for RISC-V tries to build
the arm64 assembly and below error is seen.

drivers/crypto/hisilicon/qm.c:627:10: error: invalid output constraint '+Q' in asm
                       "+Q" (*((char __iomem *)fun_base))
                       ^
It appears that RISC-V clang is not smart enough to detect
IS_ENABLED(CONFIG_ARM64) and remove the dead code.

As a workaround, move this check to preprocessing stage which works
with the RISC-V clang tool chain.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
---
 drivers/crypto/hisilicon/qm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e4c84433a88a..a5f521529ab2 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -611,13 +611,9 @@ EXPORT_SYMBOL_GPL(hisi_qm_wait_mb_ready);
 static void qm_mb_write(struct hisi_qm *qm, const void *src)
 {
 	void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
-	unsigned long tmp0 = 0, tmp1 = 0;
 
-	if (!IS_ENABLED(CONFIG_ARM64)) {
-		memcpy_toio(fun_base, src, 16);
-		dma_wmb();
-		return;
-	}
+#if IS_ENABLED(CONFIG_ARM64)
+	unsigned long tmp0 = 0, tmp1 = 0;
 
 	asm volatile("ldp %0, %1, %3\n"
 		     "stp %0, %1, %2\n"
@@ -627,6 +623,11 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 		       "+Q" (*((char __iomem *)fun_base))
 		     : "Q" (*((char *)src))
 		     : "memory");
+#else
+	memcpy_toio(fun_base, src, 16);
+	dma_wmb();
+#endif
+
 }
 
 static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
-- 
2.34.1

