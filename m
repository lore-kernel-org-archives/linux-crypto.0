Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDA0C77B73
	for <linux-crypto@archiver.kernel.org>; Mon,  8 May 2023 11:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbjEHLy0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 May 2023 07:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbjEHLxs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 May 2023 07:53:48 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D0840334
        for <linux-crypto@vger.kernel.org>; Mon,  8 May 2023 04:53:36 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ab13da70a3so43455565ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 May 2023 04:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683546816; x=1686138816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9sxg5LZ/1sJSiDItv56ESM72UWoohRRXZed1vK0StQ=;
        b=LI6hJFWMPnsAo7nIAUuNh8he07mq1qgBALuGpR9EPgsWn0RuQgqraPJfQDVda1IPzP
         dxfRnz2+Y1bBoCiW6MOE7juSAhHpWJ5eHqBpRXu6YmP8VojcJM4EoeZQlUqk7qVboH0r
         A+Q9G5B1hyxCv4ivTDFstBhRFjJb8+NWDTdCrbOGDjkl0MIJm5n95AroRQ88lMxfgPqT
         JrBnULZUv/fWaGdmODxR/f+VFKjEDxTExcbSfGxpMgB1dt+zxESFqt+Wjv/vLG4AQVAS
         35iYEQdCAIV6RHM2AkPKMrGfP5t56Mm4wvj4UplcEL3D8qytkfAH0uRNjcFGeSquvRNo
         SSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683546816; x=1686138816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9sxg5LZ/1sJSiDItv56ESM72UWoohRRXZed1vK0StQ=;
        b=LxCfA+erRaRJHtoeVA2Cl2Djbm3u8tPRiSJHkhLzNQbWePClGDhymX7bwrvIONLWti
         YL+tYgQfZbUv+2xlheB/i/XLI/EotzXQCdYh7cYGNGMoYH6YGCQA54gbZxHgOHta6mhT
         POEI3NY4CxF8qDTZZz/+raBPug4FBbB1SXcrduXLiLqYR99Qia2ntAWvLguUOVlXhX5y
         NS1dTtuYrXKkSqItC78Pm9ZDWTnsqP1TuvB1VgLecE1Sxooku03X0QgkrF7zfIP+zyi3
         Dhn8ThwJdHWWEjkDUkKbtG9TEBIv2JlybbrSw+icViBaQYeLtyCMjfuY/U6g8BPkhbDA
         4W2g==
X-Gm-Message-State: AC+VfDwjbTsg9TMDGXyw5wNwS9vnJpqUgeFiNGv0z5MiU4TO3qSZ8dsq
        2/VIRLHgGVabWCkYm7WD3POiKA==
X-Google-Smtp-Source: ACHHUZ52W6P99fGjx1H1aTdF1PS++Nk8GKk+bQ6gsyNGyvgDs6xJ01TMTUEtUHiG/54yN9c7UrsPkQ==
X-Received: by 2002:a17:902:b085:b0:1aa:fdab:24a5 with SMTP id p5-20020a170902b08500b001aafdab24a5mr9199631plr.10.1683546816386;
        Mon, 08 May 2023 04:53:36 -0700 (PDT)
Received: from sunil-laptop.. ([106.51.189.144])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902904900b001aaed524541sm7015149plz.227.2023.05.08.04.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 04:53:36 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Marc Zyngier <maz@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH V5 05/21] ACPI: OSL: Make should_use_kmap() 0 for RISC-V
Date:   Mon,  8 May 2023 17:22:21 +0530
Message-Id: <20230508115237.216337-6-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508115237.216337-1-sunilvl@ventanamicro.com>
References: <20230508115237.216337-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Without this, if the tables are larger than 4K,
acpi_map() will fail.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3269a888fb7a..f725813d0cce 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -276,7 +276,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 	return NULL;
 }
 
-#if defined(CONFIG_IA64) || defined(CONFIG_ARM64)
+#if defined(CONFIG_IA64) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
 /* ioremap will take care of cache attributes */
 #define should_use_kmap(pfn)   0
 #else
-- 
2.34.1

