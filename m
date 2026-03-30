Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DF43A963E;
	Mon, 30 Mar 2026 22:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909643; cv=fail; b=BMwxOSJUj5PIRtrm6PTGVZt7FThLScsLh0tiCuSv4f4fo8Ns7l/D6AoOw58lAkj/wxWIqRzjWRe3H37r2XEbc1+Wg5W1MX6mdS5fgaXRmK1QfBP5+RfKRFz9LTcPp2uCQYi6ZtNVqv1Rlr9B001b+vFjlMOVtPh1I1wTqiMKmuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909643; c=relaxed/simple;
	bh=YmemP6ofOCKc2FHxRMDNzuR3yq1Vj+ZM/zB4xu8HDDA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOpHy7C+k3YPMamXYsVzhnkxZC2AT8sBVEWOdFaby8opAHtVlcvJC53kX9vLu7YeJl4tc1wG2l7lRNwM/DnAbdVsNNsBpax1hKm65EyOpIXxzWyhcTVWlHVNcxnrfYdo1DvmUT6yZx/jSKvNFAIgthFQxGUPBKywwILa+TyQ4DM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ox+qaeOD; arc=fail smtp.client-ip=40.93.198.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ox+qaeOD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wd9ENMiq9V9ZxVt3t84zx7wkKDj/1eybk8698lrG03m8bzs3XPQn20PufxFGaQNZhsuro1o4KYukNRF/2j3tSMcsRDl5TKECr/nv9Ek83xOcEyRE9HjNYDpxne6lVyynjk5zl9N18dHSyCgjaivPiNAYOwis2SPHZVVPobE1RIOpv5diJ0ySDVP1Sw2XYRqiJVrlPY5YzCR53o+95jzhLQyAdxFTcVuo/dptaWEpu2A2zQTw6ptAhjA/kwVVv1OrefxFM44IMQFUIdrp4dflAp2oj4MqJ2e5J3fvorSSIyxA9oG1liyvWAyR2okfa8qiRF4eTgDVOoSRqQAyrrRPyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiFoupWjjJvgdXIeIwYFT38ZdVED44EmVVFLkFPvvoQ=;
 b=wP//N0BeJNe3S+ZMRU4OmF0M54oO7R7H01M710DcXDK5h/oBQYbe6/L1qYPbXVUBg/Ne3NgXRk6oxUkQXWGgWxwGd9JKtnp5So3c4x5x3N7KkVA7bNsGg41cmKQ+5wlD1clOzTCfngMwcQF3xXpXCkndHrhDfCMSQxb0YBrvFuH5s0ra/7NoyjmGhGV/HLkirzVi+eoYeUesPzfFAKZCCCKSkTJlYeHpDJ4ozoqbTN3GXaT3SN9h/ldYUxP1INbRvTzinhpB4mcJePo+7NzIu3gfe4AW4dzNPpeJvAzHUjeq00ky3WEOhn2rEYwhKTwZi5+xLqP32pat5hiTDULWfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiFoupWjjJvgdXIeIwYFT38ZdVED44EmVVFLkFPvvoQ=;
 b=ox+qaeODX0Xde7yuWa92F1HkfJQihFsNc/hwbkVysONBcSoKiLJW54JxtvpTa0hxCYqhbKnSEHW/x4F3XNG6QfV0oUOiGrxPga/JSMhrzZcgOgKBx5p1ZWWC+U16MrBj7V5QdGGqfBlPAA0DK5RrtFUmObkmjCKxe3hkxKpWOno=
Received: from BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::22)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:27:05 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:2c7:cafe::31) by BL1P222CA0017.outlook.office365.com
 (2603:10b6:208:2c7::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:26:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:27:05 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:27:01 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 4/6] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 30 Mar 2026 22:26:51 +0000
Message-ID: <a30809d43368d6ddeb82e6717be83327282ee52e.1774755884.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774755884.git.ashish.kalra@amd.com>
References: <cover.1774755884.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 0172f12e-bf58-4fae-83b9-08de8eab7902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	1Ewxfk0QtFy5/dcqnRmmY7t7OBFGAsnnsFU7rj5im1c7Drg2axeDAl1sMbyYt5emSNSecgQ4CCwpbMOIj2NhpqV9XJUF7ecJm8Z9XeQoUXtDKiUm50edIW0Uh4QKM5aDwPYTeKdTmjhPLxNXxuH0baRK4/3IF4aqdd72wBFWPNtwYdsUyGXt+mIZqB9MOgyxhTZk8WJhOwfEqWrzOcJASIWnowZKzaCmiKpUxJpfAOhyb8CgvmDBK3MR+1ulZAEvi/kZqijni3aviCRf/OpN17tQLvHJ1WploH86enNNGBt2Tip2MM9wSUbH9r+vzEBgKroIrcQAovdIt0ZtenVOXi004hM2chz0Eu+fKoIyJz4jiU7Ca8jp9Ar5egOh+XZOwdaVbzRLYxMzDmjuH5aBoOcA9AhHXd2F58i+XTwUlh8/uTQ7MPAkWUssQ0kddqv1I4HejneX7VIaPj3g4w/UR7b5JMvlnN8EccH7qE+cUm/+d9mASav5Kq0Y1JwlYZILEm+sU6ILFJ7PVWEWHLQNq/8TIcQiELjRitWd0zfYquL2YLUO+JzbEjVL6geje+HfnZqrkwwiMBFTRLLn5LXNLLP2aH8jOPRsmxB17C3h4NY8mBK1Pqi0Y3O3FPqezRH/QB4DKnua7ExVndJT9uXReHS8O5RgW1qTQL19T9DQowDSulJTdI5k7sjHVlBxojCugZRaU2cJV6gz0/v6en3Hkg1DahhS5QyzR6VQDoUtCOKWLLLrjtbsxLcfPRrz3Yp4Tsqf1E2jeb6SmGVsZAA0N9LGwwCaXRLG6+VhAz2DtwA1XRrUHiGEGxn9Qau7L06B
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0CC8rUYdlTpuidxZlKczKwBTOC+CwprDMmXnn0z0hyrcQQqpi3OdaIFqHRgiRQlIZZoQsiKk9K7W+WJNwvPAl48kkH/Dhe8ypjGa7DKlwnewMC5laikhMvTracbt/4MugBw5w2vMiFfbPtV3rakSB35rXNxZG4T0q7jqoT+rMPHJiZDfLPNbBhki0MG2OAksm9HaWiTqZe3J4dQiEovxG9OAbBMXhDgX8ZuPJclLQqQagR1pTu4S+fjbLakqKCU6iXPOPROx4DgWppzmfJABDo9goWr4m7e3KtDEk/kVt8Qnqpzqqhc+hDfMiZ+8FFbsTQ+tSr2TuZUN5GlzXHajnEmf4DV05mI4/hoEE9HbF9vmjdSGD6w9kWAYMRP9vv0fU5UmHdb//mP6H67lFZmyWMRtcD0qxGKRNuMm7PYXsXW/lteQrvX0h9aRvNizX/X1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:27:05.3504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0172f12e-bf58-4fae-83b9-08de8eab7902
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-processor table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Events such as RMPUPDATE or SNP_INIT can clear RMP optimizations. Add
an interface to re-enable those optimizations.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h   |  2 ++
 arch/x86/virt/svm/sev.c      | 17 +++++++++++++++++
 drivers/crypto/ccp/sev-dev.c |  4 ++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..451fb2b2a0f7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -657,6 +657,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level);
 void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
+int snp_perform_rmp_optimization(void);
 static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
@@ -677,6 +678,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
+static inline int snp_perform_rmp_optimization(void) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1644f8a9b2a2..784c0e79200e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1138,6 +1138,23 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
+int snp_perform_rmp_optimization(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return -EINVAL;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return -EINVAL;
+
+	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED))
+		return -EINVAL;
+
+	rmpopt_all_physmem(FALSE);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_perform_rmp_optimization);
+
 void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 {
 	struct page *page = pfn_to_page(pfn);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index aebf4dad545e..0cbe828d204c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1476,6 +1476,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	}
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
+
+	/* SNP_INIT clears the RMPOPT table, re-enable RMP optimizations */
+	snp_perform_rmp_optimization();
+
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
 		data.tio_en ? "enabled" : "disabled");
-- 
2.43.0

