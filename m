Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011049.outbound.protection.outlook.com [52.101.52.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C8C3ACEEB;
	Mon, 15 Jun 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553029; cv=fail; b=VnhuvDya+nMdv3chAvLK3NgftE62NCycSDIzH4qUGabcWOps7LYRJmHkrDG+6Ht9jFFY42bUJJyUR1iLqL1IBWXz17vVPL2YR/dg3xNXC3z4MpV/Dl5gBmWVaBJVpuHQJlstJzbn9R3N9uL71uXPyXZ7iIbAGEi3QcTt/pZJh0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553029; c=relaxed/simple;
	bh=j8ZIHTtgPi8C+puKyVLjpD5cwq2sbhaIm6oBoOJ6tMY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPw3RsI5/5jsxh7djiejoEJ0D2vVQdYdZWV6Zgkr04k4KGFm8bKIT0sevrxdUBdK0lJrbKOwkA7YM4t2cHkQlIlT0hiehNSJOCXYdlatEQsKnUJWdzhYZgPE8htT8tvNzMlqrSkNMrYbTj7KlNK1hrqWyi+ktYPtrgLS3xCdStM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C3btzg8B; arc=fail smtp.client-ip=52.101.52.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C3btzg8B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RN7siqyy2xO0S7ShEtB0I0sjK85Xzuw1/9JiEmkwIpwoYt7leFApjzt4TLKyMzjyiP3csasvmw8QxONp0IJbQMxoVkAedGTyt0kh+JALTkDS0cBghofS9Bwnf2EdqDgj014TbahuBt6oVoJAEj6YZAUkHXRpiDYbYIxzk6PXABjemrDjoq7hF/16vm/oTYdoqUllyEPkKSp0zvuwRoCFUM8PwBoCcoEdL6WqYzGyLWbS15IMqc5i3LeFLfQZ67LnAaDo3PeVl22HneRxrPdBQpIxtIfJ5o6FV/Di70xZ/gHEMX083uQDNAEiMC7NTGu7HrC/cPJKm4cBBSb+DvJtRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BL+/Amnz+09DAFUg6q0UQGSuu4OgbuzSBvCzcmyPP00=;
 b=orMInKGsAT5BSnTs/0Dqy1ep/MVcHZc9JtmF1L/xe6bMCOQTp13RO8FAcGGEKQheJPZzTrhsYDVBajMD06pofjy9wLMD6rZh/MQWBWiK+MVoFvbBTywgno9+Z0eC379hpUO1hIzrIjpSeINZQGex2oPuLsURP8RnCzCJ4tOGd/PocOsTwK7iSO5mnXNG6Wqvz493ZXbUJojSIvVJ663QTdRJgVDcOHZxLwOvjsw61DIIrkEZN4b7Qgk+u8zt5E6RYxzMUbPNQ0E34rooJ51T+Mpavbb63EDUOwi0SdKcAd0+zixTpcY/Bn0ruP3Fu7kGdEbI6+UCSY83Ren6UZW6cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL+/Amnz+09DAFUg6q0UQGSuu4OgbuzSBvCzcmyPP00=;
 b=C3btzg8B6pt5Ku+buodpUraFrRD4D29EovkR6tl6lTBnMsj/bWjJzC5U1Hb4kCV4gMxMtlpD6fdLjYu0pXBUoVpjNZoRBXRLumOqCwAqliXeWwr8gxvIz7acIlmy+bMmGfPm2aMx8zpRS5eV7q8/GIWIk4yXRQNqFEOopc+s9D8=
Received: from MW4PR04CA0350.namprd04.prod.outlook.com (2603:10b6:303:8a::25)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 19:50:19 +0000
Received: from CO1PEPF000075EF.namprd03.prod.outlook.com
 (2603:10b6:303:8a:cafe::6d) by MW4PR04CA0350.outlook.office365.com
 (2603:10b6:303:8a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:50:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075EF.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:50:18 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:50:17 -0500
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
Subject: [PATCH v8 5/7] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 15 Jun 2026 19:49:46 +0000
Message-ID: <cdb8098074de8e150dcf534ab806e38744325a57.1781419998.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781419998.git.ashish.kalra@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EF:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 77f4a183-52d0-4880-7de9-08decb1753f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|18002099003|22082099003|921020|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	74tWGOUmFaHclBP9JYzb+TH4tgzoAxp4RK+XiXeUCZdY1teQPd3M7pK3DYRzf7KRAnDyiCB+5rbVbtO7obnh9/lYdUAHF9zFh+89Z1rVJNaYveMF0EiHY18idkcd9KFvkGUUnodS2d7mzzG5NWdBTPN+QtH++OxXtA4Wqh7+CeXkqgs6JDfZtZAsy1kj2nmiOgiZAJ2RtXNB8nvjr27/hVSiFp0RXODbi35mYOn4UJBHsPqeAfdo+CNoDzc1k8/tuiDs7+croyBJcVaytWfgWe93KDx5rm8JpZOD65yD4qDWYRkzQJMJ6uHeSRtEkIw7IoikkJoZeI2Z5Bliw0g0xtzMTAWnym13zOHarvNdle7WSwM2duoibmJ58glgvXP+0lU2sYQUnpq8nm0uMr8PITELAxW0UvB2mXCpAI0CzNIyTs+TTtS2hvw24pieOJXdem9/k+MPGMpGXPWRk6dwphXQRAv96zKrHguGwBgkPW7HEhHGu0drzlu03o9JTRtu9w1O2UMnrqeFUUH454SEdK35y7Fm7NHO9qVH8KJ+PSVMO1mH/1Mitbfl9c05AQjjodHHasWzIndW0xkBIWCot+dXpV3RMaqpPuKPJRPqc6FHr5kscL99DRvodxiAYws1VaIyREJ7ua8BQB6+jcieIeh+jshNX0+HoErNMHVY+pqgW0FqUlc2il/h1AqW3oz0fF0Z6xZ/aAiqydXOqlJy5XeRo3XMl6wppVVoL9CJw3CjeiK50+DFN61lIEoY/XgWX0rpG1zH7fy+ECo4OIHVmQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(18002099003)(22082099003)(921020)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Wi8D6T/KKPRykTaH2VvlN0VW9uxMZd/ZWZ/tpvZ89KoKXx+A++rEnaV0YeWcJTDaK0Y9ZXwQoZNSDSzLQHiMCNnde9jMq2xZ+p5FiGBBGGnzd98mQyouS5pYFCUeRDXsl/ozjRr1XKJ5Ap7pUvfO2mbRkyaVsqI16Mo95P0yo3bHWp9tybJxCGegi3baTnpCUOiLDZBsHnEVFZgbky1ObTpBsaJIZgjVSVLZUxC2xFX8D/xf5ev/NhPhwBksYetgVVg0xfQBgGsDt6OHheXDKHEBZOD2/WVqnznvqd5xXgiHxclGKJqspMTNVFgbcpqJt3kler7YUkr07jAOWO7f7Awi9g+dHUzGZ+KE1BkUY1rhy0ZECFmZ7gY1gW+SU3HdvYuRfP2A1Wc0wiXPFeNxYssVEzbtPz+3DtZFXlepQkU5IC7PVmK5LxgFnitiT8zp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:50:18.5483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f4a183-52d0-4880-7de9-08decb1753f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-CPU table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Events such as RMPUPDATE can clear RMP optimizations. Add an interface
to re-enable those optimizations.

The interface uses mod_delayed_work() instead of queue_delayed_work()
so that the delay timer is reset on each call. This provides proper
batching semantics: re-optimization runs 10 seconds after the *last*
VM termination rather than after the first. mod_delayed_work() also
re-queues work that is already in-flight, so a re-scan request
during an active scan is not silently dropped.

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
index b63b639bfc30..253a534b9a0d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -782,6 +782,21 @@ static void rmpopt_work_handler(struct work_struct *work)
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
+	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+}
+EXPORT_SYMBOL_GPL(snp_rmpopt_all_physmem);
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
-- 
2.43.0

