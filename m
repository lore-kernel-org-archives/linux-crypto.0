Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B888C77B75
	for <linux-crypto@archiver.kernel.org>; Mon,  8 May 2023 11:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjEHL6K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 May 2023 07:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbjEHL5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 May 2023 07:57:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BA54641E
        for <linux-crypto@vger.kernel.org>; Mon,  8 May 2023 04:55:25 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64115e652eeso33927756b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 May 2023 04:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683546924; x=1686138924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRIRI8aArNgE1fextAvbnFu2fBTu5X0gP4d56RcrLtU=;
        b=dPMbOuJszGZR9AahCXbvkNUwii+U9QMTSbyX/g4rgl2Q6FpYBFAPcbDw395JVWTi3S
         E6urCy+MpwA2mwwR1jCyAvffT1l31W8/LPIcJGeeFTD5aLYHDEquT54qiJ2PiGwewAK/
         7/al2D5PTVEakeiZsNEdWqALf2XkQL0K7k9aFb+4iJxePbBgZXZVkfp8vW4aBTIcs+SD
         +bz/l9nW3Yjj7WFv+zwFHYEfdt26tbRHLOQXJbw4w/Xh1zaR7Z1ODfJ0Z4leFb0BXw7C
         UqtjGgxhDIEAThPM+W99EdZymdIczjmy/IDVSEpiG7tDS91x79zJImn26Sq77ax+bOHo
         zOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683546924; x=1686138924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRIRI8aArNgE1fextAvbnFu2fBTu5X0gP4d56RcrLtU=;
        b=BL58L/SI+lxouHybwIMCOSo5X7ty08O+Nc7r7C2m5mP6u1p+ar1K0VGkmP9NpjZTwm
         Ao50uKqWrGXvtcjvf9dM4WGSfwtqY3q46nYQpWNoNkFjbRzMbkGerDWQ8GscNIUox4n6
         T5UGlUyYHqW/jkumQx/2J3H6gu0w7gwNi8g6XBJxzNBtVgF0yVXqsd5cMGc35TuJiGP1
         aldt6jslYBYB0e7+JAldsBrW1+JOn0rK5JgU13iih5ibSyK5GZDmm1Nwqkyi0+QYPxv/
         GdEfx+1F6a2P8Q2MUui3fG5OGN5LUC65z5RJghfVbyh7ADkAVszGNisETuN2WQsOWmDS
         phIg==
X-Gm-Message-State: AC+VfDw9P4MW0yj1hJaSK3HrQDYkaKLHD+cPD7TH+PIwCZAfJGnao20P
        2Lo5hacVYquKhse3uGnVSwcOAg==
X-Google-Smtp-Source: ACHHUZ6789eMhEedD+DjgP1qLrd+M1OvHlv3gMG5XLhQSR4jt23EMajfCnuU+TlGtnZrH0ieEuaCGA==
X-Received: by 2002:a17:902:e550:b0:1a6:e564:6044 with SMTP id n16-20020a170902e55000b001a6e5646044mr12627890plf.7.1683546924015;
        Mon, 08 May 2023 04:55:24 -0700 (PDT)
Received: from sunil-laptop.. ([106.51.189.144])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902904900b001aaed524541sm7015149plz.227.2023.05.08.04.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 04:55:23 -0700 (PDT)
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
Subject: [PATCH V5 18/21] RISC-V: time.c: Add ACPI support for time_init()
Date:   Mon,  8 May 2023 17:22:34 +0530
Message-Id: <20230508115237.216337-19-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508115237.216337-1-sunilvl@ventanamicro.com>
References: <20230508115237.216337-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On ACPI based platforms, timer related information is
available in RHCT. Add ACPI based probe support to the
timer initialization.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/time.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index babaf3b48ba8..23641e82a9df 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/acpi.h>
 #include <linux/of_clk.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
@@ -18,17 +19,29 @@ EXPORT_SYMBOL_GPL(riscv_timebase);
 void __init time_init(void)
 {
 	struct device_node *cpu;
+	struct acpi_table_rhct *rhct;
+	acpi_status status;
 	u32 prop;
 
-	cpu = of_find_node_by_path("/cpus");
-	if (!cpu || of_property_read_u32(cpu, "timebase-frequency", &prop))
-		panic(KERN_WARNING "RISC-V system with no 'timebase-frequency' in DTS\n");
-	of_node_put(cpu);
-	riscv_timebase = prop;
+	if (acpi_disabled) {
+		cpu = of_find_node_by_path("/cpus");
+		if (!cpu || of_property_read_u32(cpu, "timebase-frequency", &prop))
+			panic("RISC-V system with no 'timebase-frequency' in DTS\n");
+
+		of_node_put(cpu);
+		riscv_timebase = prop;
+		of_clk_init(NULL);
+	} else {
+		status = acpi_get_table(ACPI_SIG_RHCT, 0, (struct acpi_table_header **)&rhct);
+		if (ACPI_FAILURE(status))
+			panic("RISC-V ACPI system with no RHCT table\n");
+
+		riscv_timebase = rhct->time_base_freq;
+		acpi_put_table((struct acpi_table_header *)rhct);
+	}
 
 	lpj_fine = riscv_timebase / HZ;
 
-	of_clk_init(NULL);
 	timer_probe();
 
 	tick_setup_hrtimer_broadcast();
-- 
2.34.1

