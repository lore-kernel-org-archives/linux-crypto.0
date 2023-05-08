Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB42C77B7F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 May 2023 11:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjEHL6n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 May 2023 07:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjEHL6F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 May 2023 07:58:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E5F473F9
        for <linux-crypto@vger.kernel.org>; Mon,  8 May 2023 04:55:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1aaebed5bd6so30384915ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 May 2023 04:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683546941; x=1686138941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38k1Pzb7K1cfn0j2an7l+ypiTAB8VfWPvQzIb1c40CU=;
        b=PChmFsn3jZ8YIN6et/HE2FT9KTKcn+85yUyr9DAN37WxMFW8+DniecytVJXMB+E4Yt
         cwg8NffeENFCvkKnaWixs6tUyDd3Pe6n2aLn4UIePpKETvgDRw/tKZj+YWWWcT4mL8PX
         tYib/TSvHrN7Ey/NaA2sBIl3ZhsF/OALW01VQPmUVWr5lFOnvHHzhr8ONcBU4wdYDXUM
         2glikRs238NvoLM/xUbz0Xj6aUVZA+JwoGLMj1OClPKRSjyvFoYHdvDFP9z9Wm3UBUso
         nG8WFplmCxjrRVNpFWVJOLFxXe7WeRsIP9yzHVTVBjY97ncMG5iq4wNUkEILfoLw9j50
         tEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683546941; x=1686138941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38k1Pzb7K1cfn0j2an7l+ypiTAB8VfWPvQzIb1c40CU=;
        b=TspC2VjOeEq2xCprnd3sNrGEGv9GCM4XddCPUcfyXR8MycrasSZycmYiUC69h0NqoF
         mOA3RIJqAYxElDP1gqL4QUcGQ2l0pXA1KJV62RCwrTdW4drxM1LQ7RwyJCBAxfpErcM0
         azFPWhJRURIX2aBHHdQCxp+/DTI8jdbMV7N96XSwP1vPwFxtCZFFprw/BDM5vPdiRqeI
         kHr0KEXZMSfuHlnu7nTP5cKYzQX76CqVs7pSD+uoc4q3xPUmajzlPMrfCTA8DX7M4KGC
         fQSxic6GXAauQ/ZxS4dKK8Tp/rwwfTXgN5RDt9rXIlblfl9Qmpq3QanwQgY399n85xFT
         IW6w==
X-Gm-Message-State: AC+VfDxcOCjr7XPOOMid02gIKl5l8AodqDtXCJQUS0w69CMGuouJ5GKt
        KeAqZDdr1OL6LTGW3p1kKXnyBw==
X-Google-Smtp-Source: ACHHUZ6zMo1/GVdCMuvw4uqUNbB5el8P538gaRe9zZQmHaDTlvRjtiHbiNIa2a1kNbjX1A6CxKl+VA==
X-Received: by 2002:a17:902:8c96:b0:1a9:631b:7d68 with SMTP id t22-20020a1709028c9600b001a9631b7d68mr8947702plo.8.1683546941248;
        Mon, 08 May 2023 04:55:41 -0700 (PDT)
Received: from sunil-laptop.. ([106.51.189.144])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902904900b001aaed524541sm7015149plz.227.2023.05.08.04.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 04:55:40 -0700 (PDT)
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
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH V5 20/21] RISC-V: Enable ACPI in defconfig
Date:   Mon,  8 May 2023 17:22:36 +0530
Message-Id: <20230508115237.216337-21-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508115237.216337-1-sunilvl@ventanamicro.com>
References: <20230508115237.216337-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support to build ACPI subsystem in defconfig.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index d98d6e90b2b8..d3d1fbf2dd5f 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -37,6 +37,7 @@ CONFIG_PM=y
 CONFIG_CPU_IDLE=y
 CONFIG_VIRTUALIZATION=y
 CONFIG_KVM=m
+CONFIG_ACPI=y
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
-- 
2.34.1

