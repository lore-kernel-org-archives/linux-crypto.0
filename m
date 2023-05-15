Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245A1C7EE24
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 05:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjEOFzD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 01:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbjEOFxq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 01:53:46 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEAC40D2
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:51:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ab0c697c84so93709215ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684129879; x=1686721879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyhfCZ5csOlZFGV4bhDymGpgdY5PFJC+Se96opk/VAw=;
        b=AnL2j24wiBNq5v78GDROig1xLUrOx8h7ldC25D+ya3xCvdB2Cv6x/6EEOs3hacULd2
         8kshuNt3lSbuTbUCxMMydaYbDgbLGGkQYF7VvUPmmdHEjfzNRfK52vMXWLoUBtkUYU66
         /1Vkpniy4IB5u0FronR2BKK81QkaHnP4mZS9hIUeMsDm89LPJt9ZDBW1qsmy9ATcDoUe
         ZUdQ/dLi4QBdzZiGDejUDFDcmcRioeNP7GlTjrMEoUTxypHnl1Ha/1GEkbFoxk2mOq7F
         cxfxhihFFkfOCDgWJxLB5qBeVTl/dD98uba439zjJC6xaUs0Af2GvhbH/w6mQQIVimlx
         zqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684129879; x=1686721879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyhfCZ5csOlZFGV4bhDymGpgdY5PFJC+Se96opk/VAw=;
        b=dOPijlm2rvSijCboX5OiutZSj89FduoS8ebMh98GF5seAsicp6NJQkdo5kPI+ovbUn
         wi0iQV1Iz80zxsCpEB3hPN5GGY0P9sEmVHwt7rjYOEfhODb0lCT5NDrGuEBSqHSviIRp
         f0R/5mEcnDmkeiRSo1BeinZklZZW92Xan9aGx+mp22n2rHTxFmiozxNh/4KZZ5AW0oHY
         ce8f+d/JA3Xepx4ekkWlCrnkJwG4BXQx0AKRJLv17qHM50gJqIsR+C8InNQC79L0yjjV
         CLArVPyZ2aAp5UCxeX0i+HDG+jD7acQvcMjdZPlV4kisbrFoVOClrFYpsgfJLtBJruF+
         cJlQ==
X-Gm-Message-State: AC+VfDx8GpsAr1QpbCBf+MNuXk6FxYrMOT4Wp3nqTd/evb20krC+TlWb
        7WaKriWCWkY9AEAz7VDTyBjkgw==
X-Google-Smtp-Source: ACHHUZ6dlE8FK5RNiVWExNjaEeoRVHoi1ORW2kRCde6fEx68FmWzSQePGHLtWxaeL+3DUBkY9Jd8UQ==
X-Received: by 2002:a17:902:b94c:b0:1a9:8769:36b7 with SMTP id h12-20020a170902b94c00b001a9876936b7mr32730620pls.5.1684129879165;
        Sun, 14 May 2023 22:51:19 -0700 (PDT)
Received: from localhost.localdomain ([106.51.191.118])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001ab28f620d0sm12423277plt.290.2023.05.14.22.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 22:51:18 -0700 (PDT)
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
Subject: [PATCH V6 15/21] RISC-V: cpu: Enable cpuinfo for ACPI systems
Date:   Mon, 15 May 2023 11:19:22 +0530
Message-Id: <20230515054928.2079268-16-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
References: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On ACPI based platforms, few details like ISA need to be read
from the ACPI table. Enable cpuinfo on ACPI based systems.

ACPI has nothing similar to DT compatible property for each CPU.
Hence, cpuinfo will not print "uarch".

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/cpu.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index c96aa56cf1c7..5de6fb703cc2 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -3,10 +3,12 @@
  * Copyright (C) 2012 Regents of the University of California
  */
 
+#include <linux/acpi.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/of.h>
+#include <asm/acpi.h>
 #include <asm/cpufeature.h>
 #include <asm/csr.h>
 #include <asm/hwcap.h>
@@ -283,23 +285,35 @@ static void c_stop(struct seq_file *m, void *v)
 static int c_show(struct seq_file *m, void *v)
 {
 	unsigned long cpu_id = (unsigned long)v - 1;
-	struct device_node *node = of_get_cpu_node(cpu_id, NULL);
 	struct riscv_cpuinfo *ci = per_cpu_ptr(&riscv_cpuinfo, cpu_id);
+	struct device_node *node;
 	const char *compat, *isa;
 
 	seq_printf(m, "processor\t: %lu\n", cpu_id);
 	seq_printf(m, "hart\t\t: %lu\n", cpuid_to_hartid_map(cpu_id));
-	if (!of_property_read_string(node, "riscv,isa", &isa))
-		print_isa(m, isa);
-	print_mmu(m);
-	if (!of_property_read_string(node, "compatible", &compat)
-	    && strcmp(compat, "riscv"))
-		seq_printf(m, "uarch\t\t: %s\n", compat);
+
+	if (acpi_disabled) {
+		node = of_get_cpu_node(cpu_id, NULL);
+		if (!of_property_read_string(node, "riscv,isa", &isa))
+			print_isa(m, isa);
+
+		print_mmu(m);
+		if (!of_property_read_string(node, "compatible", &compat) &&
+		    strcmp(compat, "riscv"))
+			seq_printf(m, "uarch\t\t: %s\n", compat);
+
+		of_node_put(node);
+	} else {
+		if (!acpi_get_riscv_isa(NULL, cpu_id, &isa))
+			print_isa(m, isa);
+
+		print_mmu(m);
+	}
+
 	seq_printf(m, "mvendorid\t: 0x%lx\n", ci->mvendorid);
 	seq_printf(m, "marchid\t\t: 0x%lx\n", ci->marchid);
 	seq_printf(m, "mimpid\t\t: 0x%lx\n", ci->mimpid);
 	seq_puts(m, "\n");
-	of_node_put(node);
 
 	return 0;
 }
-- 
2.34.1

