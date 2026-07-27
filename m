Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22863BCD38;
	Mon, 27 Jul 2026 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179177; cv=fail; b=TjBb19igE2FYTA/iudrpU5HJZygpLyST3ZOYnnMuhyz2TF5XjzWCN3VPBnlaHInq6eFemcY3qt9oweCC3WlrRAXMxnHXCCIjy+a+GHHAFYoevXDed/kbOYQtgPoMzDidkAOXlj2D03eMKN2LtE4K0yJDmfwxpmsDItIYANV6054=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179177; c=relaxed/simple;
	bh=/83gPufzdkkvhOl3R4HenyPE6tPlZuB1RaxemwjrWYY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a06RIuZQdrLMI3kFFJZQm3oie8qeKKfAiZ5DyJe6sHelRyJyR38L6/qqF55VMiVoHMstUgQmILo/oKx+Q8LW5qvro+4ZTM2Wj4qpYwTJ2LVP4hCTHMsBDwTMGjfYrDTUp23Os9q77ahO84Nq+LZYTNNzLYkrGd8WBVU3XHQlx/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1t0lW4zm; arc=fail smtp.client-ip=52.101.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1t0lW4zm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebtYI8mSGmES7vmiAdLlX+vXggB1PP6LS5dXry0F48xPsjB6lsFhEjm+KJWN9A/c0RX2SylYIiZODG5xbMkUihW7lyjx7apfsMdT4ODjdUKrqR7FMHra4D/Ng2L5oFEo8i5QMwWfCCztBsksK4XSBULRo9+E1+mygp0QliTaW0cIr4W/pjlqBgAudMQbUiyNvA7F5JGUskSwsFn9xsoZYQKhCAm2MVS9ces6qMjudDap1+b9ATBavbD9SAACFuS4a6CSu3U5FPAJEEkphOTJFpclsI5CehcBmkgGHyByuU/aeJI1V150v/V9roaRFj8EswZ1lzreja3JqYLNQcuXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jjy2OG8DStM+ZTT4W92uU9upjmqYtC0dOAR4RWjzB3g=;
 b=N8WQsFS45bFFTNmRCxsEwPbSJedjAdSPiiIdhuU6KdBAQct13+r/N0LHFClGjlpxvkMVeKqmv2OcaOCUhDqEwMWb7oJtmkuiOyoRKCcKM84Rg0yWOW2sqQ3Kr1E2WchTwMsHRmeC9O5GDrEGIRX4O++a24nzhjvq3y3zukq3Pa9Vok0KpiGPd1Xzn0UyNQyZjq2Nm27R2l4uu6j3oIpVMynC52/9fhXZmCZBWxDVnb3aFUztSbdsomxENBvLlpp3zZmC/J8ImzMOtt2epTdsppY6akD4MJdesJmwkgDXkEFqEgdTQi2zT3jxgFo/FyXIrgM/KIgKDvw0majnsP9ElQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jjy2OG8DStM+ZTT4W92uU9upjmqYtC0dOAR4RWjzB3g=;
 b=1t0lW4zmO9LCceqbXxKYTK7QUeWa6K0CK64Ca2kvGCKOKajt07HgdoEJ+DTBHQe1xFyEUefvudbLvel21zUHwg9aw0sYzYMKVMh9hpk2w6ZU+WWjF3FO0hYvSGWBqqLxdDj1iqvegkMdQ8QVl9H1bIbsA4mdGeobyswNoVswE/k=
Received: from SJ0PR03CA0100.namprd03.prod.outlook.com (2603:10b6:a03:333::15)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 19:06:10 +0000
Received: from CO1PEPF00012E83.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::60) by SJ0PR03CA0100.outlook.office365.com
 (2603:10b6:a03:333::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Mon,
 27 Jul 2026 19:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E83.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:06:10 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:06:09 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 12:06:08 -0700
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
Subject: [PATCH v11 5/6] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 27 Jul 2026 19:05:54 +0000
Message-ID: <afc058ce32417dc45e3f7cd9536d0fafafcacb4b.1784844080.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784844080.git.ashish.kalra@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E83:EE_|DM6PR12MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: 9902e8cd-f125-4926-fcf9-08deec121ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|36860700016|82310400026|22082099003|10067099003|56012099006|18002099003|5023799004|11063799006|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	uydyQqJG+80pOHJMJMz0pFqESpZ2vK0Yb5elI+TiSgCrGJKKeAukZfMEgzfiVx+WfMWwj+R5lZJHOOAMwtb1HdIGo2fmFxjdJ4/WE3GtQcB8ZjnEepYWS8Tiu8nZr+Nfxaf2Ak3j1XoZF3dnEdnXVpD9lJDp7u3dlU/sF2jzdRg99i5UCcxN6VepmCpnCGDtdWLYnOkE3JWZL+qlGE9vyOfTwtZWxsifl0Obmog59PniGTXmy/QTcmQW2c0+/8QWxdo2O/kLGhRZXqCMnCSqG8LesrHez88N3Qhb+0+WLrSnArtmRZGLOBvjRcyxCiKMtOc5mG+3GhQUwnh1IcVBTSxekFPutssLu6gCFAF8N5b37S1D4u5T+xtBhQLkWoKtPWIt8Qb196yqkuUKvPZpVmtcf0g+m3TRpMsDT34WRe1ND2OdbM7hEnauzyS1sSNdRUwoLzSABJw+gqBQbir+EFO1bFsRnkn0UJB9Tq9AXz65UzDDjI/488J5S/eLo9yVsb4dP36Bnhty7JwAqkLsESopJyZ1LrFyLJ4SZ0sRxjqSDiF1ZaPwvwLXUiy2WEFTBdGgkReKeh49HUzViMqd9MkVOanXrNSTUJSNrr1hSxiu3C65mBUEvRXPP1aDIZTdtMU5BUVVWa+3nRVMArEduwN09nMjnZtdzKn1af0FMQTMYiAUUHpZCSqZnhQINQXN4avR35ZWOui/SKHJJHto32o5s3VD6uS732Us2VMYLBCiF+Wu3TY/QGoeeivyKJao
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(36860700016)(82310400026)(22082099003)(10067099003)(56012099006)(18002099003)(5023799004)(11063799006)(6133799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yjz+thVbtDGoLphyODZy5rNCE6ws/c/CD9WeiszV/LeYHp3ocFGcpkoZ6itI9CaMj9DktpZC0SYF6HqSwA+YfI1LwXXuAGC5Nm0g6AgG9IrLqtLAwiFpw4I46thm5WmQejzD6Gdgwp5LNWO2HO39IiKhZBJYlVn35m7uvpZVzwbrK6yTv1t9YVCnT5cWaiiB55TtehI24mIofzXTYumQGtwn1hbd/39lL7i36THQtJ0BRIZ+j6Qv0W4UZEuhg9/MPsnIwUQWvaI5dpb2OzeTrD+VPBlXTtNUm4rsl441y6jZsarAPvj9watT28XnIYhqht3TR8sXyYWi/CxOW4sZXRK0xuOJBx3ty/peMe3+otCht+5maMKG2nDcbfgUOksDgs4SIY/XGzkhSCquOEEZ8cn5zOtGnwMtCZG3e5yIB0rgudQ+8ZwxTLuL02zz0mWd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:06:10.0356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9902e8cd-f125-4926-fcf9-08deec121ea8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E83.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-CPU table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Normal guest events clear RMP optimizations: pages are converted from
shared to private as SNP guests are launched, and large pages are split
and collapsed during guest operation -- both clear the RMPOPT
optimizations for the affected 1GB regions.  Conversely, guest pages are
converted back to shared during SNP guest termination, so those regions
may become eligible for RMPOPT optimization again.

Without some intervention, all RMP optimizations would eventually be
lost.  Add an interface to re-optimize all of physical memory.

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
index 04b19e64f832..291a360291eb 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -710,6 +710,21 @@ static void rmpopt_work_handler(struct work_struct *work)
 	free_cpumask_var(follower_mask);
 }
 
+void snp_rmpopt_all_physmem(void)
+{
+	if (!rmpopt_capable())
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
+EXPORT_SYMBOL_FOR_MODULES(snp_rmpopt_all_physmem, "kvm-amd");
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
-- 
2.43.0

