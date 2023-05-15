Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415D7C7EE2E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 05:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbjEOFwT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 01:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjEOFvX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 01:51:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEDD35A9
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:50:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-52caed90d17so7757572a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 22:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684129824; x=1686721824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvg+GJpfRbLLmDkZ0StW7roD1sWqDLKd1ZxLgpiB2U8=;
        b=Q4t00pT4ZWzwlaux3rA/dO5uvJj95jGbFN41gz6rgArxZ5h/XZ9tyOePsHbJ3Rkesc
         FLedojP0taJ50To+Akrsw9VkWHGyH6MUVr6aKKY98ZxTlY/jIL46s85d4wD1X+R3YG6g
         3T2wnihVKr5jk9y53f0UCcyh6RbOhxCfIQRXHNA91KXsHtP89ASXn3lI5+2GSUO2C6aj
         Rn9nazjcJ38ZNkQQ8+/t3qwUQenK3qNgGFvus1IHKGS3lSz8xIAfmbQeSkTGgkrhip9/
         W5lLT/wLeFvrviSoVpcbW+OozGXGAnQtqLonpkMBum8HBBGL244pQPb74LiLIZljtdGr
         m1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684129824; x=1686721824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvg+GJpfRbLLmDkZ0StW7roD1sWqDLKd1ZxLgpiB2U8=;
        b=hMvk7GnRcchCpYWAolkQoMIukLVCXicc0bEG7G2vT/4qQS74FnFf7263UPxX5Dy4TF
         tjtWxQ2qukyvcF/e6gt+G4acYHh5v+po/mDWFk9j6Wy8hiaLgnr8L0KQAVVDxYENO8pA
         Gk0kjoK6QBmefgVIYk1fQKJ/iWXJdPcpi/sP/TwQeixLHKcHvuW0K748/WeIOBrjttXc
         TeQluVk0hqlJdeBJMcg8UNJ/03jOvrHLnX5tFbQNgmrKVcdudXKLQ86dhb3Brle+mVE2
         w2k20gBRX9pXpfV5Kc8oS4ff3Y9ZNFBCEUOlWceIGbAbupXfCTKLNbuBSe5kquu1Kp8R
         aRug==
X-Gm-Message-State: AC+VfDwvGICU7OEFzP9Vt01tFHONJi425CqOzFJUhZfmz3RaVz5UKTeA
        JHctEN90GgN5Wga8ori82tYh+w==
X-Google-Smtp-Source: ACHHUZ7xz/6Qsd1dRQfSsQkL104oUqFv86xYEJzP/eDAKJ1EDSsQ0zeVEE6vjHTQLIdZflWGHacgng==
X-Received: by 2002:a17:902:d38c:b0:1ab:675:3e31 with SMTP id e12-20020a170902d38c00b001ab06753e31mr38877950pld.37.1684129824381;
        Sun, 14 May 2023 22:50:24 -0700 (PDT)
Received: from localhost.localdomain ([106.51.191.118])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001ab28f620d0sm12423277plt.290.2023.05.14.22.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 22:50:24 -0700 (PDT)
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
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH V6 07/21] ACPI: processor_core: RISC-V: Enable mapping processor to the hartid
Date:   Mon, 15 May 2023 11:19:14 +0530
Message-Id: <20230515054928.2079268-8-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
References: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

processor_core needs arch-specific functions to map the ACPI ID
to the physical ID. In RISC-V platforms, hartid is the physical id
and RINTC structure in MADT provides this mapping. Add arch-specific
function to get this mapping from RINTC.

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/acpi.h |  3 +++
 drivers/acpi/processor_core.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/riscv/include/asm/acpi.h b/arch/riscv/include/asm/acpi.h
index bcade255bd6e..9be52b6ffae1 100644
--- a/arch/riscv/include/asm/acpi.h
+++ b/arch/riscv/include/asm/acpi.h
@@ -15,6 +15,9 @@
 /* Basic configuration for ACPI */
 #ifdef CONFIG_ACPI
 
+typedef u64 phys_cpuid_t;
+#define PHYS_CPUID_INVALID INVALID_HARTID
+
 /* ACPI table mapping after acpi_permanent_mmap is set */
 void *acpi_os_ioremap(acpi_physical_address phys, acpi_size size);
 #define acpi_os_ioremap acpi_os_ioremap
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 2ac48cda5b20..d6606a9f2da6 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -106,6 +106,32 @@ static int map_gicc_mpidr(struct acpi_subtable_header *entry,
 	return -EINVAL;
 }
 
+/*
+ * Retrieve the RISC-V hartid for the processor
+ */
+static int map_rintc_hartid(struct acpi_subtable_header *entry,
+			    int device_declaration, u32 acpi_id,
+			    phys_cpuid_t *hartid)
+{
+	struct acpi_madt_rintc *rintc =
+	    container_of(entry, struct acpi_madt_rintc, header);
+
+	if (!(rintc->flags & ACPI_MADT_ENABLED))
+		return -ENODEV;
+
+	/* device_declaration means Device object in DSDT, in the
+	 * RISC-V, logical processors are required to
+	 * have a Processor Device object in the DSDT, so we should
+	 * check device_declaration here
+	 */
+	if (device_declaration && rintc->uid == acpi_id) {
+		*hartid = rintc->hart_id;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static phys_cpuid_t map_madt_entry(struct acpi_table_madt *madt,
 				   int type, u32 acpi_id)
 {
@@ -136,6 +162,9 @@ static phys_cpuid_t map_madt_entry(struct acpi_table_madt *madt,
 		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
 			if (!map_gicc_mpidr(header, type, acpi_id, &phys_id))
 				break;
+		} else if (header->type == ACPI_MADT_TYPE_RINTC) {
+			if (!map_rintc_hartid(header, type, acpi_id, &phys_id))
+				break;
 		}
 		entry += header->length;
 	}
-- 
2.34.1

