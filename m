Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011013.outbound.protection.outlook.com [52.101.57.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073B43E51D4;
	Mon,  8 Jun 2026 18:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780945056; cv=fail; b=paXPhEQHu+d3zYDjoyOL8eUAs0t5rqxnPCvGCD3EcAL2d/nH5oXzRmTc2R0rs9mN8t/r0+PzbDPT/x856AhgW4RZUjX45AqdSt7IZs8ep0xW9QWaIhubAqTRsdhIkvfHIWcAu7RYlSvdIc5LZD0RUGV1sl9bpw5JuiXaWtlgqlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780945056; c=relaxed/simple;
	bh=m5weF4UZXG0z4qhwgMifo29EdtfYnW+9T5xBsbjAzB8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STok8b9PeJC2SDiXdqUsgmPJxfL4P9H2eiw0Zpd6iBqoQ+kn+nMbZNtrZ4mlq9Z4U7gBPtSe6P8hV1LoszDMcP246xfgcZ3HeuMmBRO1y6lrc08IvBXi+EkvMNv0wFCeALCNrLZfKkh0MzVdOY8192OJSwtmn05ErUXy8DANR/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IsMIBUpU; arc=fail smtp.client-ip=52.101.57.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IsMIBUpU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VShXHumOhYa93UWACkobWgSDbusPE20y0R0NlfnfKHQXRRK1AHKVFkPmq3a7CXmz8QvukKYzQ2Abm0L/QNDkL56qrSvqJie5PO/n7NV5EprDagE9fNVDVECiXUQKNlJ4cQj2fxVyxA0HwDPxtQynWBZ0Y6X6XfG77p2TWQi7ECebKI6AJfR6dj+h4HdzLQ2/GYWOvLob7Bop7ZswMw+sLUkjdvWpqJ/mbe+CFc80nIsliib8HvtqZiRZfQJSH3K+2KTkah/+29RHrxYJ4y77eu4bKqjgEXeXmckBJ7ebmcSSrFCzV5UHmmylOwCCg8NluUFUdVYgYBUjbGmKEuQkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K39WI8YSSF/I/h91VDbHVD2yq799BsMSr0kWH8JdiPM=;
 b=xFxOEHpUvD0LwpGuAR1wSrUK0g2DYcnwp2orWfdVW/hT8C6hp4r12tRH6WebKtohTOGccdsyPzUvi8pS36hFxXPZeb8/VW+qUwx32giUzmQVHf6qcEkWJOBF0CJwbed5aHjgq7BkuLCNJc5sNfY1nc5o2GL71IRE3AH9aAGOI+Wmp5LYAx1rX0XSvhutEI1qfo2WBhTMzEyftlJ5z0Th6P5bUzuhClF6xQ2Rdh4itaXLcIse01Fa8Stm9yD6inT/Mtqg6kb5t/W01EPul4zzgvAlDMlMi9d7NSasiYIwXJkUdts03fGuPHvE4dgR4QSpGRLxPmECkoRFMy5EtdROrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K39WI8YSSF/I/h91VDbHVD2yq799BsMSr0kWH8JdiPM=;
 b=IsMIBUpUOsYbYMDkz1FvvTOS/8Dh8IDw8BC6Og4+L14JQ3XHr0Ek181B262Qyn/54C74eOW8UszGMB3OKEbiy/3CtgzxbUFqyoErtHQvm/31iuV6rQGeMm427BpoQUItzzz6YDh78JBDhCv2LPeRyxZKYqgGDB1nEQd56w2dONI=
Received: from SN7P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::33)
 by SJ0PR12MB6830.namprd12.prod.outlook.com (2603:10b6:a03:47c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Mon, 8 Jun 2026
 18:57:29 +0000
Received: from SA2PEPF00003AE8.namprd02.prod.outlook.com
 (2603:10b6:806:124:cafe::87) by SN7P222CA0010.outlook.office365.com
 (2603:10b6:806:124::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.13 via Frontend Transport; Mon, 8
 Jun 2026 18:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003AE8.mail.protection.outlook.com (10.167.248.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 18:57:29 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 13:57:27 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v7 4/6] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 8 Jun 2026 18:57:12 +0000
Message-ID: <1daa81645bd87c34c7298ecc2245aef3b96ff6d2.1780903370.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780903370.git.ashish.kalra@amd.com>
References: <cover.1780903370.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE8:EE_|SJ0PR12MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: decdac2d-d168-4afb-a078-08dec58fc9e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|921020|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ADww5XPuETen8bzIT0kr4MDeE0dhjf7PvTdp3dJo/98bgqDD7gV36eeOrtwy+3K8nfXlI+hDAw8CDmRXc7nCEFfEYLgo5bUY0yO6Ddxzzwo2VXzTb8AcP96JUMPU/mt46aWKY66HkY/PVtQ0TRdKjqjzQ05YgSgVmImZbV6BsFHa+10HUxxnfbts0QGm+v5NvqNF7XXuo0e5NQd49OHZ963Xy/MkDdRHE76UfHaBnbdumv5ds3WAfxiWvvjt/QWzDEKyQ095a0+pNnpqmSiaFCQq+FrsTtcH2C77R9nihWCTmzcNY39Y4M/VrkceFyQHkFAV7by64JnLNU3abCdfak8nTenmJrDnr01oVg5bqnf2/3fl56pUVWgGQ3wULj44VoNSWyWyEGnIGQxwQbNyCj8gVcR2Sz+7sKtDfNH3BYYOhuq2yW2aYEtHxJmAaascMUhiqyscLc6edr/my/UmkZeg04PU0fuYP4VCbhJfYirsuCDVBjG7K9ap17mBQSK8vqkbLiWLzjRo8QU/EYSr+NauMw7E8vQD9l0xdu+EdwkgoR7BYDN1Ja6eDsa49I9W70Xv823L+cwiIKNrV6I8qd6ZkeOGfqxd24NIy0KQZf71JQAGnbfsXgz2pYkDbf2uzEgB5g5OUFgN2w6H9+UtLnivb9l8bZek8lM2uOSvNfkvtHpLIiJNrS9qspQn+C8fFPbBZyCRfgfaSBee35lb3MfqssRuiYNYF3qcSXiDnNO1JzHo2F7hpJ2dIH1GtI7lc75q+pETGKVsZ53Td6en/A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(921020)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	30bnpOVSyHBi3YgLaUD/NGEjKLPKr3Eo3uqvJOkOQQ2XcabV2cgJCd0hDz28fiD4QBR0F7ahZKftqph2W2KKPWcptBC+x3Y2miOZRI7VVOH0TfxOSm1lGft/PNZDEpTPZyzNK3XT/hqx7G0YJfoPQ7dpUO16m0JMsLKFegpC6MlRv54xbi0owRXYND8p69pF5Jh4UO/hOsJKXMA1zTP2oCgIRA3oG7qi2/X1l5XPVpFcZFm/MyeJO+sHmFYIdUqydJJf9JnITkqtPsOoX2naJ9dgmrGiDZ3raMDlT+Qbl5czmoJU7H4pCLClhDxCl3n6qXRT1xtInOVLrHKqKrNGBR2BMXvnbiubijwi5OxD0R0DNQ4MzS2fv75ZFBiylP6dRAYXYBFWGII6ny5e/rQiS5epXf1KrBBUdV9qnRjCYEsZqPtwBq2G/LtltwuLC3pL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:57:29.0957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: decdac2d-d168-4afb-a078-08dec58fc9e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6830

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-CPU table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Events such as RMPUPDATE can clear RMP optimizations. Add an interface
to re-enable those optimizations.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0d662221615a..a11306f25336 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_rmpopt_all_physmem(void);
 void snp_setup_rmpopt(void);
 void snp_clear_rmpopt_configured(void);
 void snp_shutdown(void);
@@ -682,6 +683,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_rmpopt_all_physmem(void) {}
 static inline void snp_setup_rmpopt(void) {}
 static inline void snp_clear_rmpopt_configured(void) {}
 static inline void snp_shutdown(void) {}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index b42788a66d40..db2d4c1f5dd7 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -760,6 +760,21 @@ static void rmpopt_work_handler(struct work_struct *work)
 	free_cpumask_var(follower_mask);
 }
 
+void snp_rmpopt_all_physmem(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_configured)
+		return;
+
+	guard(mutex)(&rmpopt_wq_mutex);
+
+	if (!rmpopt_wq)
+		return;
+
+	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+			   msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+}
+EXPORT_SYMBOL_GPL(snp_rmpopt_all_physmem);
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
-- 
2.43.0

