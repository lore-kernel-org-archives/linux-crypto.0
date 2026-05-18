Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E7339A056;
	Mon, 18 May 2026 21:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140611; cv=fail; b=r+D3wg452RxbugQReSv9GREW1Lr5sDb9HIA8pfobeLpSXsPw/f/P9FsCZSOFu5+Ftnogbui7Mk8XCvTpuZX7chvQgE7+2j9Cs2MSX0axlug5pSBh+qY3EJRlVqSTGbcH0gK7hdW/MKkpcx/83BaXHla1//4snf5perMp2nAhHTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140611; c=relaxed/simple;
	bh=rKYIvXC25wzTl0jXKC3FRoTzjQDXVseWkZOl1u/VIvo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOrFO7EgmcjMeDSpy0rQWfOC+by7I9jZNvv6PKFNnHoQVFBy0fYcLWx3AUpyVU21TohtCP97R0dsQYfys5dlWG/tQv8GnjdCO/5G6Qhk3ou17CS7xgzFahqVirIqG2pJ0zhF3Gp4zYMjn2FUmi1CBb5xc/vDQRNRnw++CJybX+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M1C+aooX; arc=fail smtp.client-ip=40.93.196.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M1C+aooX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFAohUF6KptbAnKslkHzndez3e8JN0Pffrrt0IYOeB5jPsZa0KQsuC9Wv30iIhQve+W5iNeLTWR2eAlbiZDYddU1bBTUnW2nJXPGNjr83hZv7L5M864ejsYksBO7/Kaa9HIIAExS+YbIAorcdOR4vTdssVQBRJDBFE2JlrEzAMD4u84xxSb+eeJBKx97iBFVU3dmLNGVwQ5qiskpR4OdSvtfyyiw6uDCegETc3DI5O2RxjDETOtEvcI0D393yjGDzPmkuAISiuZIH88nhUDPofaxZftyalRw2en2sMwr7NWND4xKPqXz1g08ScYFtbBEri62yy7koP8zer8tIjERAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bURHpmQ+XUNZ+547l6//EHJUYIiln5h/x6j1ncjuQIA=;
 b=jsBSN2yf0V/jAatlCaArM80LtS/SvnY+tiqwdkQdMXJ+P67nX2N2VNsDHaYa1Z72m0iIxZghaLCdB9SvafbSoe+WqR4qOXinajzbPclWxNyXV3SGKXTssIs5syaCN4YH41q9Hkr1EHhug6ew7D8r+oOIk1JbBJvVgQPJktFwggXadN7qQXEmHtyz2La8YSIzaNcCXFq90/wU27fsiMEWA1hAaADxzBAt/gKt2uuwOh3SJbNhHPBgHn+eQNwk3mpN+7NPOHiV5ewIPN+1M1pgCkjTbouINeXR2vhe+d+rFNbbU99+o163WP2N7TnyhEFSyS6apD5fJmN5CaUkK7Kd0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bURHpmQ+XUNZ+547l6//EHJUYIiln5h/x6j1ncjuQIA=;
 b=M1C+aooXfMdS1bJTqZWgNwfJPKhTVeyGXCFCGpghRUp2oP2D/B96W4ydSHPuHCTtB8U/3Peixqn1IGXJHjxMRtjm66bZ68Hed0iWKgnHyDJBZfWoUPNWyP18tdexasw64hcy8UD1uyFF3hBaTzIVkCGysDseTDs7ZzS/TvjmPwo=
Received: from CH0PR08CA0020.namprd08.prod.outlook.com (2603:10b6:610:33::25)
 by DS7PR12MB6095.namprd12.prod.outlook.com (2603:10b6:8:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 21:43:24 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::a5) by CH0PR08CA0020.outlook.office365.com
 (2603:10b6:610:33::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.24 via Frontend Transport; Mon, 18
 May 2026 21:43:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:43:24 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:43:22 -0500
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
Subject: [PATCH v5 5/7] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 18 May 2026 21:43:13 +0000
Message-ID: <4621de2b8354a1076bc5fb75f2a5a47509aa5f4e.1779133590.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779133590.git.ashish.kalra@amd.com>
References: <cover.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|DS7PR12MB6095:EE_
X-MS-Office365-Filtering-Correlation-Id: df495189-144c-4a14-7a5c-08deb5267d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|7416014|921020|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YyHodIRY5NCpgeBQuBMYQOixIVbc5gIWXhbtlrZA2xazbeCjMM3XNCKFJ7TIKFu/NbcSGDB8vKITOqX8fr7VS32eGzRZzX1hfPeMfPLzB1Y1E++uI4yduEEi+Dfa8XGYjsKKqdmWbu0wmyvFcC1oGSs0udMejQn0QurYfn7dZ0tCghBMsoS+h4vgds8eXkgYyVRs/dYYfwIgfUOCbVahqVfU1BYnSnrJa02zznQK8UfYYmqbTj6uGNl+zaYbWLgwgWcNtkKW3tIrvCLHvJZtbS7OwdZFVIUD5CfpnQEciY53ZmU8I4fORdcGmbi/6OsbNixdvPSPZ+RLhNW4vqKyhreMnt+A+N93vS7ZJQ7L+g+3+lZKGzFO5q5ufzVtQzjvkHPyaGn1AoB3XnaZ0oQ3ceCSxa6L1K3U3neTJsL8xNS3qKjplbamthl+gm3kSJQx09uvmJbCgsXEZP7+jKHJKHtgxtalVGAWSGWedEFvZjh8k3OjAd+oNaMaSZ7kLgNZlRHHEqU+c13ZSvndtPfI7B4VzhHK743UxPyWcMblMKIeaxShnKTJ5QfAJS1YzWHYk4gwqLuIztnDR2Y1Nhbmu35x22VnYCS9RMa9zWtNxWmXLjruAwz0vPBLdwxpbt5lRHoKpwMw6+CUopgaWIC9/cJ069s9zi702LJ/z3mL3Y2yGXXbzhyvcKxY9CWGmajqKvuqv01xlTUt5nBWZpriY+uaSduYBSSjmHZxWrOP3gp4qd9GkSKp1RnD9gacbWRtW/HDkQcloZoVbVIv8rReTQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(7416014)(921020)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zGhVx/dK5/4pqNTqVQiK/I3ffzZ5f/7RM8kfEqGoCA4qCK1BVeUUNe5KRw+baVLeiBn5WAnA4W0Yu5KWhIqENeU1tpEWqC+nHVKL9qeOdzvanGefc7Thu1j8lD0EB6pg6x4k5hc4y4ny5u0ozl0Ow6hIbCW+YyKo4IAYDG8dhmRLeENB9+Mfow+eR2zYcG1i+3M3uyJzUMQWik1T5jqlpvmAW6HZ8YbE9VFfnEjtFItoNPibpB9p9zUwPSNe2cEtUwXOoBtFW9wcSNI8ktdLiT/eBClfYWfJ38hF2R08I56xl8I+ndSKBTw+lL8c0glXqpLhMxC8Bb8ymLaoKr7R9hRD474XpYYqUqLgvPXRxCxZ6sRDaM2audJOb7ngHWQqv50raxCWNRSx5ofSoJ57+rACb4LoTuZI86y2DRMhvy92e6mgoxFCA2Eb4iRhzHjy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:43:24.4195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df495189-144c-4a14-7a5c-08deb5267d0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6095

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
index 6fd72a44a51e..09b1c5d33790 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_rmpopt_all_physmem(void);
 void snp_setup_rmpopt(void);
 void snp_shutdown(void);
 #else
@@ -681,6 +682,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_rmpopt_all_physmem(void) {}
 static inline void snp_setup_rmpopt(void) {}
 static inline void snp_shutdown(void) {}
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8876cac052d5..7f8bb09844c1 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -707,6 +707,21 @@ static void rmpopt_work_handler(struct work_struct *work)
 		cpumask_set_cpu(this_cpu, &rmpopt_cpumask);
 }
 
+void snp_rmpopt_all_physmem(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
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

