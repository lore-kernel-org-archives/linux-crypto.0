Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011025.outbound.protection.outlook.com [52.101.57.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BAE3E0C77;
	Tue, 30 Jun 2026 18:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782843131; cv=fail; b=MaQQtDL9+AHCHWwbyo98ZGqoDRHpN7Yq/Ecj9O0WzQT4uBxwrSy15gCb7xcr8GRQ3hH3TEt5T0sd2/ot4VsBAo4bzVRwMDvUmAHOcL3TM3bS6/2Jgwr4U+d2aXhpKEbpaCLXbK9tNiBq7n58m3zd3bO6fqke2EWOsb8dcZYIub4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782843131; c=relaxed/simple;
	bh=VlmQ9vcwI/56XLT+yE3GK7+A5+nneJSXyqRJE9qL0ZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tz012oQ9IrabXEHb8tC2T6E+60Fu8tyigOxYYDIVx2dBtuP95Nj8fGEBOJrrD+vpi8VbBQ1tdQeJP6sPJ2NY1ObRkdHxRLWNnGnO+xA2tHAz90V8OGtcyY86M5Fv+pXjVkqtQM3bDRJYAgRhaB1SH6qd03wjySuPR5at+nz7+IQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K8a3jIkp; arc=fail smtp.client-ip=52.101.57.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K8a3jIkp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FfNftc6UE2oHP/g4FYemEJ5ymy5yLN4mQvCLM7vXI0lUgnxnCWg91fRjg9nkpHT0XUzpLzPsvpxPxkhFkw90PoB51scxHFuVm5X3A6819neBL8Xj/WmQKTO0rH6JfxzIopzJzEas0qamWw9ZsH682kR2DpjPHJGln0QapuTSnI+yrRRAOOj7JeBx+wBsIUB+xHnzwn54SjS0qeY0Ww5KiNNk1VycgfpU2pn+wmeTX2GSz79Ryrr80Yw1e+6NUYXbH897lRLAcRHbrvbgfWtwsEDJE/q8fUinT76VgvtZ7Yz1twpRZ+ub6GEf79aeGfNTZnT5lCoMZ2NmsaAonPPg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpmBsMSqmwgp2T6HHA41q7fT6yXGZHeDp0/uwighjwY=;
 b=u/N9F5Py0Zb6aJWyeGX2fTZxD3kmUrFLQRzK3Km24AzZEP4P0omLTwjdAYnunQF7/WtEka6+CZINNeskdjK0odFsnRPjyGufkLlSaM/hjeIcySpMsxIpIb9krpaA1z3A4QHZ/msiMU33zUm3YuVCafQ4CqDl5ZjnJ9e9LHNvXf6RPfwU8Hc4wE2MS4bf2RSL31nT94+UWZhkPgaRzJZrYdrqihgmYpPLc5MZP0MGFLgs3Pia91AXUiXpoOfeGi5BaWMMAc0+sl90gNpnSScvyq3OOBbNhU0AoFu2xcSpUBXY2Ozb6QRCcNXexOErZb4I+8+sVv8VvUBlUIcGsISFmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpmBsMSqmwgp2T6HHA41q7fT6yXGZHeDp0/uwighjwY=;
 b=K8a3jIkpqYB0RkM1KQ2P7nEppVt3PlUkqhj3gv+xjDCybyUZEhu3u41yoP2Ocgw8IWzdfOFbFiSmDCp6cvi0Jl4mXKfTtEzERyu+Fg/mrwU6drM3qn1D884dDkHJsibvBOQ0mesgW2Uu/Vm+W3uayXgujOpGQbj87u6Kaot/q7s=
Received: from BN9PR03CA0745.namprd03.prod.outlook.com (2603:10b6:408:110::30)
 by IA0PR12MB8256.namprd12.prod.outlook.com (2603:10b6:208:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 18:12:04 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:408:110:cafe::56) by BN9PR03CA0745.outlook.office365.com
 (2603:10b6:408:110::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.18 via Frontend Transport; Tue,
 30 Jun 2026 18:12:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:12:04 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:12:04 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:12:03 -0700
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
Subject: [PATCH v10 5/6] x86/sev: Add interface to re-enable RMP optimizations.
Date: Tue, 30 Jun 2026 18:11:46 +0000
Message-ID: <ce128e2a3f479447c0213f011e3a630ef6964790.1782841284.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782841284.git.ashish.kalra@amd.com>
References: <cover.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|IA0PR12MB8256:EE_
X-MS-Office365-Filtering-Correlation-Id: 0760da0e-37d9-46db-aba7-08ded6d3171c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|7416014|376014|82310400026|921020|22082099003|11063799006|18002099003|5023799004|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	3v1+Y+bmz6U51J5EE5GECM/FaPJVQxe6XwNOs1/YyXTkvQyCFr2c88ZkZBwONZeOwS57+Et6FK3qstbiZjyCFz4RivX1VXHsz6xTPdfwu272RyoOBsedgJ4BDz6ctYlzMv9ANCU29ycmT6vI6vaiRPWBLfWGCdUitmb7X+A9T5yFBEOnOPdgF3z2ZtxemB2Muc0t1YMwzOIO4xY8GyVnS/2yYQyF0L2JB/dv7Ede8wtqxXyD1XOPUFW908LGzakdEin253/xIlKQv4Oo3A442gBcECq7qEX1dLvpSiaihXH/NWYNUmZCg6NtGh8NqNxgXNJE//hx4JnIBSVZpJhTnWx+e0e1IRUGxUyzZFpu1qpu4Wpe+BXF6qWdo8tXPbsWKol20VoNRZ3QbJA16N/qwR6m1qm0ZGFn0OaoM394esTFPSTzIOKV/VAZ0WIfAUH5CWUoeimr288UC8j6wLH4CraTca3VKdkUb3mNRUU1gnDZ0yMrsxUvP4AprED/XzsEpz/MM5lhR8YhJkSkvFD87F6iiH+eoG7QDoBctjTLotUp1Zt+xWGZKWw/mcDpRTLfX6ohpU9SFHx2lWnpjPBZ+pSQKGwjCq6u9eN6I9JqzwikIqBCjROVtwdDd2frFz8DR5eCN+rM1zjsOFSUtkqDgBaVq+tLo1jWTru5F7Oy0E9qs7mtajHqi0MBMAD7LvGRN64K7EcZGmJ/6OmMG0eiVTRqQO4BGTeEYSkCToePGCf+HvkIqr7fUjRDRD+qtqL2
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(7416014)(376014)(82310400026)(921020)(22082099003)(11063799006)(18002099003)(5023799004)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g+c/PUbti3l5JDKu5VditBSRJGhBitQaMQ7cgeRa0JRjTewiwP+cCqpo+ooacccrxqfxOYzh//2NaLR0p6X9NLfNflCZDWtZ11V/OT8dkBIX/uS69GMa1mc/rdDCq3jdF05+RML4EHxTHOiAMZGNAl7eFWlLR9ySsq0g7LEJx0UoYKRRX0xhTPcQld26MSBKgpBxklGwMR2F6is4UYEDYvphrYCzjKWq694lm1FRLVvbc9qupSrAFfmuNwsLFEsmKNS1DbFr+uMrsTxiSedDL9XYBdy+7b7efV07mVGNN47ih8n5pbCpSb+tm6TlgQw41AJm01YWLCsh1oIWjojpHfaQqlvjz46+nn3e+zSkVDLky63CXQK7FugE+czSyFM5BD7Hd0/KgFAVhXvcVC2N9fut8/t6lYDN7DimYwltdt/Oep7Red83N/T+MaQKx19j
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:12:04.7097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0760da0e-37d9-46db-aba7-08ded6d3171c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8256

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
index 0243989f229b..54b4ae5c3735 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 int snp_prepare(void);
+void snp_rmpopt_all_physmem(void);
 void snp_setup_rmpopt(void);
 void snp_clear_rmpopt_capable(void);
 void snp_shutdown(void);
@@ -682,6 +683,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline int snp_prepare(void) { return -ENODEV; }
+static inline void snp_rmpopt_all_physmem(void) {}
 static inline void snp_setup_rmpopt(void) {}
 static inline void snp_clear_rmpopt_capable(void) {}
 static inline void snp_shutdown(void) {}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 40b06e959ee8..6672c7f17825 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -735,6 +735,21 @@ static void rmpopt_work_handler(struct work_struct *work)
 	free_cpumask_var(follower_mask);
 }
 
+void snp_rmpopt_all_physmem(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_capable)
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

