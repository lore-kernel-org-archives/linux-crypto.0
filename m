Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D08C7EE2A
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 05:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbjEOFxq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 01:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbjEOFwk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 01:52:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2F9273A
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:50:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ab14cb3aaeso87501995ad.2
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684129852; x=1686721852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNB5noEZPasx/OngqcP7wy15OXtx85aYSDWecQ1qX3I=;
        b=crUKtBVQVJV1vWBpuccoTSp8DaYY66fm3VKniawcVP6BKqjaKB4T2BaZyNqDyNPU7n
         9YBY1TuYEPQIP65vBpgmiEENoR1RAcWrcdORTisds+fVFeKk4n6ot+7DHSQjWhfm42Ao
         dd8qhZ0hLmlYljm0LhvMRdBdV5496JPxOHUG3c+dIxD65S9A9Ryz9EyK68M3tzx/B0S9
         JBM/ZcwzO0eRD86zNvVnVbRkCTjmonAhCiFUSmyEaFJ7WoJ5cJ4XrULn3PiTm14zJR8u
         OtxancRacVKlprqQD+tHP/Lkv/v3J35sEnIy3t7ws0ik1FK+XOq34vdkAgHW6F3l3d2P
         kubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684129852; x=1686721852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNB5noEZPasx/OngqcP7wy15OXtx85aYSDWecQ1qX3I=;
        b=RcZj1pGh1FWJ77uWkbRNBt84ExvA66bKxOjqQ2oq9uTa6Z1ekmfAgSatOLPJSnpXIe
         t6wwlIK0nCA9eXzPp2QwIe0tmL8DtUuXwo8iDcInEL72PEL9e4Mu8sGAO+bGvd20cO/9
         OxTXmSuMBCvDTBGZqzfEp4puLv9L4uS8L14tLV6vb9bPrAaVqAfToijLZSdf1IAXOUp9
         WYyH7YEmpXjmuqlvJ95W4ggF2A+z8lwrgISi7IATulGIWbVy4XYoszKneEZwhZYWhRb8
         5hdvMeIPfTPxXTU4kFWEVsUggFLUEwxRxVqunECwk58mvuOikDbjg+WprG/pAWrAkFVa
         wH8A==
X-Gm-Message-State: AC+VfDyDzEqOBBOM6LwLNfaJnvmRhn6PnxBZVFVK2jaJEZ9cvKf5/Trp
        vZsoNXbp9zl5wIg9EKOVqaypdQ==
X-Google-Smtp-Source: ACHHUZ77ebtnzP9PEn9FZrDUXbQi5C1QdeX+0Vl8vrWcZZPVJfFbLqWE1kMFlDBKeV3SaPILOcDi3Q==
X-Received: by 2002:a17:902:b403:b0:1ac:8ad0:1703 with SMTP id x3-20020a170902b40300b001ac8ad01703mr21046473plr.35.1684129851850;
        Sun, 14 May 2023 22:50:51 -0700 (PDT)
Received: from localhost.localdomain ([106.51.191.118])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001ab28f620d0sm12423277plt.290.2023.05.14.22.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 22:50:51 -0700 (PDT)
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
        Sunil V L <sunilvl@ventanamicro.com>,
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
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH V6 11/21] RISC-V: smpboot: Create wrapper setup_smp()
Date:   Mon, 15 May 2023 11:19:18 +0530
Message-Id: <20230515054928.2079268-12-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
References: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

setup_smp() currently assumes DT-based platforms. To enable ACPI,
first make this a wrapper function and move existing code to
a separate DT-specific function.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/kernel/smpboot.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index 445a4efee267..a2e66126b733 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -70,7 +70,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-void __init setup_smp(void)
+static void __init of_parse_and_init_cpus(void)
 {
 	struct device_node *dn;
 	unsigned long hart;
@@ -116,6 +116,11 @@ void __init setup_smp(void)
 	}
 }
 
+void __init setup_smp(void)
+{
+	of_parse_and_init_cpus();
+}
+
 static int start_secondary_cpu(int cpu, struct task_struct *tidle)
 {
 	if (cpu_ops[cpu]->cpu_start)
-- 
2.34.1

