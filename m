Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9144EC7EE24
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 05:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbjEOFyt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 01:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbjEOFxj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 01:53:39 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D886440F9
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:51:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1aaea3909d1so115130925ad.2
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684129872; x=1686721872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fWBNL8Yoxn6F5OA39mGQO+nKX7WWRbncPVBB9F2/Cag=;
        b=P5iXY6lKg2w2zAPzFqWsqzcPgrUcluhvD0qbjWlme23GRx5MQJkTL9q0qRcC1v366q
         hsHnCTsBwmZ8Ba+Cz99o2bUFiSrJEyjXoTt7DFhUiX8a26ecgDs3bQzU9I9E0Iav07EE
         Pe37wzQNFZwo+1/roBpAaaet/ssTvRyB7HOFU0gv0P5P6uwTlo/ZPfcsVL2iMTtKp9U3
         gTx3ebHH5xr4VkkEXDqjzyaTGeMqPmZEJdkkK3g3oVQjDMPthuIQYYGMnpQ05LivQrXK
         QfbnvcxaooHEfzjBfzEAGKne+mz+w2/I6TlIoxdhMRcwGZc51Qrlkfe+CzSpfJGr1Puz
         DhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684129872; x=1686721872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fWBNL8Yoxn6F5OA39mGQO+nKX7WWRbncPVBB9F2/Cag=;
        b=cnszdvXDBm7nRy7p0Ds3X3M793oNIByDoY9R0dWhVzWxYGo2sI9QONMlc0rbD5pxMv
         foitkVXnA9Brw8qU2sYzs5JO8cKnc/A3IwQ/JVYK/7G4uyEl0Cx1lBbAYVdEHDRGOb8s
         Oy7sFwZV78bQFoqugnFcAMR0AHaOOEwZ+248H52k/Rc5A2sUnX64SYtIId3uCETC95ZM
         K14l4uKw6lIi1Vhdl/jBehlKBLtleN4UDBKfssQ98RVtUBHiNegVy98q4rUKHiva3J1d
         TbnjsNnfnq2Z4j1P8Nfh6TDNs7YesPDyP6BKVnGYzMTbR0ApAOyzOMzNvOiePvZb30RZ
         RpNA==
X-Gm-Message-State: AC+VfDwx1/3z7t9mM8QTDhMcHyINafWCjx6bL2f3AM7YwtSSgeLCx33A
        jSZ8uEhKv274Lbf0gWVZR9FSBA==
X-Google-Smtp-Source: ACHHUZ4jYf4/QP9L3KSs4U0vKc8qwWvbMuz+31XECBf+Fvr/sjS5ltK2iCuZknMrrPIPjb8hjIs41g==
X-Received: by 2002:a17:902:e882:b0:1aa:f3c4:74e5 with SMTP id w2-20020a170902e88200b001aaf3c474e5mr40753396plg.0.1684129872331;
        Sun, 14 May 2023 22:51:12 -0700 (PDT)
Received: from localhost.localdomain ([106.51.191.118])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001ab28f620d0sm12423277plt.290.2023.05.14.22.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 22:51:11 -0700 (PDT)
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
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH V6 14/21] RISC-V: cpufeature: Add ACPI support in riscv_fill_hwcap()
Date:   Mon, 15 May 2023 11:19:21 +0530
Message-Id: <20230515054928.2079268-15-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
References: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On ACPI based systems, the information about the hart
like ISA is provided by the RISC-V Hart Capabilities Table (RHCT).
Enable filling up hwcap structure based on the information in RHCT.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/cpufeature.c | 41 +++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index c607db2c842c..6ba8e20c5346 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/ctype.h>
 #include <linux/log2.h>
@@ -13,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <asm/acpi.h>
 #include <asm/alternative.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
@@ -100,6 +102,8 @@ void __init riscv_fill_hwcap(void)
 	char print_str[NUM_ALPHA_EXTS + 1];
 	int i, j, rc;
 	unsigned long isa2hwcap[26] = {0};
+	struct acpi_table_header *rhct;
+	acpi_status status;
 	unsigned int cpu;
 
 	isa2hwcap['i' - 'a'] = COMPAT_HWCAP_ISA_I;
@@ -113,22 +117,36 @@ void __init riscv_fill_hwcap(void)
 
 	bitmap_zero(riscv_isa, RISCV_ISA_EXT_MAX);
 
+	if (!acpi_disabled) {
+		status = acpi_get_table(ACPI_SIG_RHCT, 0, &rhct);
+		if (ACPI_FAILURE(status))
+			return;
+	}
+
 	for_each_possible_cpu(cpu) {
 		unsigned long this_hwcap = 0;
 		DECLARE_BITMAP(this_isa, RISCV_ISA_EXT_MAX);
 		const char *temp;
 
-		node = of_cpu_device_node_get(cpu);
-		if (!node) {
-			pr_warn("Unable to find cpu node\n");
-			continue;
-		}
+		if (acpi_disabled) {
+			node = of_cpu_device_node_get(cpu);
+			if (!node) {
+				pr_warn("Unable to find cpu node\n");
+				continue;
+			}
 
-		rc = of_property_read_string(node, "riscv,isa", &isa);
-		of_node_put(node);
-		if (rc) {
-			pr_warn("Unable to find \"riscv,isa\" devicetree entry\n");
-			continue;
+			rc = of_property_read_string(node, "riscv,isa", &isa);
+			of_node_put(node);
+			if (rc) {
+				pr_warn("Unable to find \"riscv,isa\" devicetree entry\n");
+				continue;
+			}
+		} else {
+			rc = acpi_get_riscv_isa(rhct, cpu, &isa);
+			if (rc < 0) {
+				pr_warn("Unable to get ISA for the hart - %d\n", cpu);
+				continue;
+			}
 		}
 
 		temp = isa;
@@ -265,6 +283,9 @@ void __init riscv_fill_hwcap(void)
 			bitmap_and(riscv_isa, riscv_isa, this_isa, RISCV_ISA_EXT_MAX);
 	}
 
+	if (!acpi_disabled && rhct)
+		acpi_put_table((struct acpi_table_header *)rhct);
+
 	/* We don't support systems with F but without D, so mask those out
 	 * here. */
 	if ((elf_hwcap & COMPAT_HWCAP_ISA_F) && !(elf_hwcap & COMPAT_HWCAP_ISA_D)) {
-- 
2.34.1

