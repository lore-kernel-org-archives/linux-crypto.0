Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D8CC77B74
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Apr 2023 18:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbjDDSV1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbjDDSVM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2023 14:21:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DB24ED0
        for <linux-crypto@vger.kernel.org>; Tue,  4 Apr 2023 11:21:08 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id cv11so9321086pfb.8
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2023 11:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680632467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3qZ67y38AFkmcquwwQ+jCEdL0KsuQFOs2StQrvk1r4=;
        b=XNL5wXfoQpA8JsGSjQuuq5wSUIpDur/gFmvmgAhrVBcqxN0sZ7ILN08tIz7feSsspz
         ZgbCYW7Oj5TG/XPo/GlGOOTCVPQvrVI4DQ8lbbTyKz6HIn2aemsBMb+T0hx87Cei4nl8
         Rew1Fs1jNngJ2L3xig4oSohNtjluWLOjVmYvF4Un2Goahq3aSJc6R6M3UdIPShqpaUoc
         GqVXWXy1n48x/C3ZJx6nlep571O9amcOnmFi7AWFmX9T3hkv1aGeV00MMWvyTruilF+0
         u0dFJpxCaJt00eocdVaREbn90Dn/FqHHxy7PX/33GkL/I8OH2YaG61/S4jJz2NN6hOSn
         kktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3qZ67y38AFkmcquwwQ+jCEdL0KsuQFOs2StQrvk1r4=;
        b=CeSeAijCl1I8pZsdwOx08VuEiKv3MPZIS/XR4/4/g5cAhQqWfdSGMu2wCwQo+302XS
         Wyl5F6c1rqXVhCWf2Yc9Uv1Y4QOdLyvdxBIrbG3npSiQbJDZ/e/gyF+nLiKWrtbl7Zly
         5NGioQJ17Njh07Aq70IL5XtL3/iWieVzcndz18aFR5rDURN0mvEq83bdYHz4brhvKSXS
         q67mHLgBiC/NKcXWwvXsOSNWN0cQS9R0dlpPqMF9vwKYdkVqSXHfsy4ksHYn1/e9zB7D
         78pmytzwWOwkkA+j8D1418jNhItWG9BLKVv6VO5tI9QZBJfT9ua/hV5+egFpdGlVuzIZ
         Xagw==
X-Gm-Message-State: AAQBX9fv4K/GRegnoqKpaVcCsi6Og671GXJdumF37v+9+C4Vun1tshw8
        XUyyAuLFyTMKkFNooGR2aY4hcw==
X-Google-Smtp-Source: AKy350aJ11cfvfuinWgzemdLN2e0YGrThp1w/tWD+sQXOlzKFnn6WTki0m658NPy4mdIa7czviajYw==
X-Received: by 2002:aa7:9a07:0:b0:62b:47fc:a968 with SMTP id w7-20020aa79a07000000b0062b47fca968mr3052337pfj.8.1680632467769;
        Tue, 04 Apr 2023 11:21:07 -0700 (PDT)
Received: from localhost.localdomain ([106.51.184.50])
        by smtp.gmail.com with ESMTPSA id o12-20020a056a001bcc00b0062dcf5c01f9sm9018524pfw.36.2023.04.04.11.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:21:07 -0700 (PDT)
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
Subject: [PATCH V4 03/23] ACPICA: Add structure definitions for RISC-V RHCT
Date:   Tue,  4 Apr 2023 23:50:17 +0530
Message-Id: <20230404182037.863533-4-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404182037.863533-1-sunilvl@ventanamicro.com>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ACPICA commit 82afd0434e79f74b96a6be88115ddc8343a1ba40

RISC-V Hart Capabilities Table (RHCT) is a new static table.
The ECR to add RHCT is approved by the UEFI forum and will be
available in the next version of the ACPI spec.

Link: https://github.com/acpica/acpica/commit/82afd043
Reference: Mantis: 2349
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
---
 include/acpi/actbl2.h | 48 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index c432fd15db65..86bb79fdfa62 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -47,6 +47,7 @@
 #define ACPI_SIG_PRMT           "PRMT"	/* Platform Runtime Mechanism Table */
 #define ACPI_SIG_RASF           "RASF"	/* RAS Feature table */
 #define ACPI_SIG_RGRT           "RGRT"	/* Regulatory Graphics Resource Table */
+#define ACPI_SIG_RHCT           "RHCT"	/* RISC-V Hart Capabilities Table */
 #define ACPI_SIG_SBST           "SBST"	/* Smart Battery Specification Table */
 #define ACPI_SIG_SDEI           "SDEI"	/* Software Delegated Exception Interface Table */
 #define ACPI_SIG_SDEV           "SDEV"	/* Secure Devices table */
@@ -2604,6 +2605,53 @@ enum acpi_rgrt_image_type {
 	ACPI_RGRT_TYPE_RESERVED = 2	/* 2 and greater are reserved */
 };
 
+/*******************************************************************************
+ *
+ * RHCT - RISC-V Hart Capabilities Table
+ *        Version 1
+ *
+ ******************************************************************************/
+
+struct acpi_table_rhct {
+	struct acpi_table_header header;	/* Common ACPI table header */
+	u32 reserved;
+	u64 time_base_freq;
+	u32 node_count;
+	u32 node_offset;
+};
+
+/*
+ * RHCT subtables
+ */
+struct acpi_rhct_node_header {
+	u16 type;
+	u16 length;
+	u16 revision;
+};
+
+/* Values for RHCT subtable Type above */
+
+enum acpi_rhct_node_type {
+	ACPI_RHCT_NODE_TYPE_ISA_STRING = 0x0000,
+	ACPI_RHCT_NODE_TYPE_HART_INFO = 0xFFFF,
+};
+
+/*
+ * RHCT node specific subtables
+ */
+
+/* ISA string node structure */
+struct acpi_rhct_isa_string {
+	u16 isa_length;
+	char isa[];
+};
+
+/* Hart Info node structure */
+struct acpi_rhct_hart_info {
+	u16 num_offsets;
+	u32 uid;		/* ACPI processor UID */
+};
+
 /*******************************************************************************
  *
  * SBST - Smart Battery Specification Table
-- 
2.34.1

