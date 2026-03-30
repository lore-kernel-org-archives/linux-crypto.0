Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010048.outbound.protection.outlook.com [40.93.198.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B82B3E2765;
	Mon, 30 Mar 2026 22:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909550; cv=fail; b=XTTvI6L9Nvty50Bq4AYU2cR9045jUWDMX570iQ38jjVlN6JGQeVjO/d6uK2ZUxHsNkmvoOw7HiBHpi62ylypSWS8pDkGmZresmaTWm7p/JU6IGq/jilFf2W9wGgvNJy2MTW0e42CntHyFqZhYcOVNtCedTMvmxDzQ9m0Frq9x0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909550; c=relaxed/simple;
	bh=nGYWRpZe74T3A8cKInxUoqUgXbFx4bTMQUDBsciZMgs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JEF+5Quf/5Fk39KdnbR+iXA7bFx5JXuAdNAr7oWI28q0CKMi7J72m9Q3T+KzI3QquRnizjLn74QyaVats/hVF9T4a/E/WfbhFwseVnnhfHgT9SMe4JLT9ejJSMJaHmUSI1ccGvkxRxQ3+jaTM+mFBxXdz+NDuaURpagSecS6yKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kUY7DfQe; arc=fail smtp.client-ip=40.93.198.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kUY7DfQe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/WN7B4YocB8M//4cRE2u1TyEvtBuWJcqzSefw9VuQt/KHsTij8H5kb2fIYuoHPkSJFDyI9wtwAbLb5tQ0MWToW4Se2dXguEXRmzssZmIolJyWcnBwwP4UUKH9ZJxv9MR/WKb9fuJO8T7u8wTdNPLzywJNrdvJtiPJ/p8rObXRJfO60O7Gl2X8csZG7LWPt+PQv8l2Ax4h9BEXf15o99FpZbJfOtN8ObPyGG/9yiT+wBqkP7vBAe6nQv3uj91JRLwvpXktDL57PX3wJY6mY6rwKF784hQpabJjIC/xRa0JXzLdpu/Vo6mTjgXfGbA4NXYwae/6U9y6pQBU6gOPZezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDEjg2gV12AEtF+Bklri8W3gV+iB+zqZGjN7Tgxvjao=;
 b=PqP/4wpMXZRuAfNb5tLJQ5U2KnZrJ153aUIbdPctTrVLJXcjBF4D69xfOexQoSsXgOHYoIl6mfwJ5holHwt7fDA8Ktzo42I2FwlCGBr7ZrcMrn7gWqHCoLYhDO+vszT3HEGkb0AYBOBS9R5BkhILFsBUmQT3G36B95PCEBgbSSKW/f7b4eTFdZN+kB1P0HgguVSTi3/D47Nn+FsZRnoYRn/44mAQN1eQmWZN7mpcZYM2Q21mEv9uTkYpyjMxbFkl1H33W5mLThb14A1RK9TR6TUwd4nd44JeVJNht+5i/3dqyOBevgfgNavf0cKBGEbHQu3OKwBT1uoJyg0iISt3HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDEjg2gV12AEtF+Bklri8W3gV+iB+zqZGjN7Tgxvjao=;
 b=kUY7DfQe+X3MgtgzmwIbFQIq/Ep+9gVO2MVeaDNIKA56divK8OtfthDTBkO9IQsv7VzmsfIcjoXAnsLUlbHh4szKsdNiTkQnFRt4vWvPFFDfQ2IR6u45wkBDcoK6u5kumVT2Ocixhz9VwRgbhzUo4+M9/xxErwc60UdmRZjSTso=
Received: from BL1PR13CA0115.namprd13.prod.outlook.com (2603:10b6:208:2b9::30)
 by BL3PR12MB6572.namprd12.prod.outlook.com (2603:10b6:208:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 22:25:32 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::52) by BL1PR13CA0115.outlook.office365.com
 (2603:10b6:208:2b9::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Mon,
 30 Mar 2026 22:25:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Mon, 30 Mar 2026 22:25:31 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 30 Mar
 2026 17:25:29 -0500
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
Subject: [PATCH v3 0/6] Add RMPOPT support.
Date: Mon, 30 Mar 2026 22:25:07 +0000
Message-ID: <cover.1774654874.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|BL3PR12MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: 334744f9-3d84-4ec5-68e8-08de8eab4155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|921020|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9u73myT6SQ0UNDRSqVa07s4T296GYv4XHhWxp4EJ/Cd8LB4pFe6zJcwy0pxf6lHmLhF/OD34oECX71NpydrFNN3bHm1Imxhy9hLx2puwsPg9hPI3AUomSm7PQHKHTTQomLItoR4xhzQ94Sj73VxdhrSWg3oqPd89sAqSUpQPs5QDmL+qrvSqRJZ6JHrlOqBVUkvQ8z74PUbpwVdN697UuohqgYKQbG/ZIJHg6JseqUXehsz0CJjw57uJyVsOIYnTCAQvuDAwVbMw+7pwmkcCg9Z2GK1uI1w0yGKdqyh4C19zymEKwCtN/dsjbYy7T7u1NTvq87mHYTS9Gym7WX0hvAuAk7yF43gUi9a2KEpoiWJ7JNOCTjtxWcZCRVopLVAzzVex2W44V3fqvJihOrpcPD8qzPou06rCIkcNk8A6QQSSSPyUipWeiQAMCs3d9KCn/3jxh0FbZxTNnjLGpDS+ZmygdvPDCCXfQsoDs13bjayrxGXb9mNS9b5HBUm8EXDhlStmnV3lXDvZFq9XLgDmbviiY/EE3FqXY/SJwLwQMYTEFAZRBQeRbeURUNNTDn8OC6F6k/edrCrwUV2fY/VmzfZqfHhz0J0RWsp/ATIm5wyEMeazb0Y6UY2Ae7o+YdnJ2vnGK9Vhixw0E5lZErX0CFGdGlLFdWjIVuMD/dMDjdKFg5qb2i74xvOiKaEm2bhULGJiM7zvdBymnoTx1ANMrKMbA1Vz67nFPzOqLuG60QcY+2P9Qzy9pLgUCzgn2jZ8YCIoyFJNnekvlaI/sSCPymmT6BUTj4eNaNPpC1xS2aX1F7XhyrwyzQ2/Hv6n/rmd
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(921020)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ee7QnGV05casOfGSHvR8Alcy3ByPOP8jw+/Bje5e0dyXwx5x5aN2H+f2vbngBLs7+rE4xihsmzRElCSso23UicBoZRJdKVOHjeMRCYWTNlC9QfYynk2ui8DFRKiry6RLLN2khRwFdduKwoGcarKbeFVaChh38esnzYBU/ic36eblc5xTMtfGuOTCRgGHaXdHbzWnQnAIjbeYAzinCHVK4PT/E8LPrE4RQ8mEc2UpPPhA+0yqvdF0ooCfoDdqGbFUK6dAayZB9JP+DXEDH5+HATKhgVevA9DtCF6Dn0xCDMINmhN+hFndThrc5I/yCDG7nZsfoIRhFkJLSZ8rKewjPx70xlx16P4BLV6fIleLAxkfdsFjTzC4kRkZ7eqXy5yXughd6FYXm69uUu/imNumdCkxguu/68EB3glZL0vHF56+IThGsFYfWTqUys92Wvra
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:25:31.9396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 334744f9-3d84-4ec5-68e8-08de8eab4155
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6572

From: Ashish Kalra <ashish.kalra@amd.com>

In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
to RMP checks on writes to provide integrity of SEV-SNP guest memory.

The RMPOPT architecture enables optimizations whereby the RMP checks
can be skipped if 1GB regions of memory are known to not contain any
SNP guest memory.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks for the hypervisor and non-SNP guests. 

RMPOPT instruction currently supports two functions. In case of the
verify and report status function the CPU will read the RMP contents,
verify the entire 1GB region starting at the provided SPA is HV-owned.
For the entire 1GB region it checks that all RMP entries in this region
are HV-owned (i.e, not in assigned state) and then accordingly updates
the RMPOPT table to indicate if optimization has been enabled and
provide indication to software if the optimization was successful.

In case of report status function, the CPU returns the optimization
status for the 1GB region.

The RMPOPT table is managed by a combination of software and hardware.
Software uses the RMPOPT instruction to set bits in the table,
indicating that regions of memory are entirely HV-owned.  Hardware
automatically clears bits in the RMPOPT table when RMP contents are
changed during RMPUPDATE instruction.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

As SNP is enabled by default the hypervisor and non-SNP guests are
subject to RMP write checks to provide integrity of SNP guest memory.

This patch-series adds support to enable RMP optimizations for up to
2TB of system RAM across the system and allow RMPUPDATE to disable
those optimizations as SNP guests are launched.

Support for RAM larger than 2 TB will be added in follow-on series.

This series also introduces support to re-enable RMP optimizations
during SNP guest termination, after guest pages have been converted
back to shared.

RMP optimizations are performed asynchronously by queuing work on a
dedicated workqueue after a 10 second delay.

Delaying work allows batching of multiple SNP guest terminations.

Once 1GB hugetlb guest_memfd support is merged, support for 
re-enabling RMPOPT optimizations during 1GB page cleanup will be added
in follow-on series.

Additionally add debugfs interface to report per-CPU RMPOPT status
across all system RAM.

v3:
- Drop all RMPOPT kthread support and introduce adding custom and
dedicated workqueue to schedule delayed and asynchronous RMPOPT work.
- Drop the guest_memfd inode cleanup interface and add support to
re-enable RMP optimizations during guest shutdown using the 
asynchronous and delayed workqueue interface.
- Introduce new __rmpopt() helper and rmpopt() and 
rmpopt_report_status() wrappers on top which use rax and rcx
parameters to closely match RMPOPT specs. 
- Use new optimized RMPOPT loop to issue RMPOPT instructions on all
system RAM upto 2TB and all CPUs, by optimizing each range on one CPU
first, then let other CPUs execute RMPOPT in parallel so they can skip
most work as the range has already been optimized.
- Also add support for running the optimized RMPOPT loop only on 
one thread per core. 
- Replace all PUD_SIZE references with SZ_1G to conform to 1GB regions
as specified by RMPOPT specifications and not be dependent on PUD_SIZE
which makes the RMPOPT patch-set independent of x86 page table sizes.
- Use wrmsrq_on_cpu() to program the RMPOPT_BASE MSR registers on 
all CPUs that removes all ugly casting to use on_each_cpu_mask().
- Fix inline commits and patch commit messages


v2:
- Drop all NUMA and Socket configuration and enablement support and 
enable RMPOPT support for up to 2TB of system RAM.
- Drop get_cpumask_of_primary_threads() and enable per-core RMPOPT
base MSRs and issue RMPOPT instruction on all CPUs.
- Drop the configfs interface to manually re-enable RMP optimizations.
- Add new guest_memfd cleanup interface to automatically re-enable
RMP optimizations during guest shutdown.
- Include references to the public RMPOPT documentation.
- Move debugfs directory for RMPOPT under architecuture specific
parent directory.

Ashish Kalra (6):
  x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
  x86/sev: Add support for enabling RMPOPT
  x86/sev: Add support to perform RMP optimizations asynchronously
  x86/sev: Add interface to re-enable RMP optimizations.
  KVM: SEV: Perform RMP optimizations on SNP guest shutdown
  x86/sev: Add debugfs support for RMPOPT

 arch/x86/include/asm/cpufeatures.h |   2 +-
 arch/x86/include/asm/msr-index.h   |   3 +
 arch/x86/include/asm/sev.h         |   2 +
 arch/x86/kernel/cpu/scattered.c    |   1 +
 arch/x86/kvm/svm/sev.c             |   2 +
 arch/x86/virt/svm/sev.c            | 263 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c       |   4 +
 7 files changed, 276 insertions(+), 1 deletion(-)

-- 
2.43.0

