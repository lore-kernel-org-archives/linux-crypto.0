Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A53AAF4F;
	Mon, 10 Aug 2026 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389787; cv=fail; b=KqReypsjx8CucbLElcPiAhNWnwjtDST0TXehTiG+bJeROHz7MqK0PhBxBOk/+SEmt3Bw4Htqu1fUiSY2IANC8uSuSGCqqpeJperwwlKtW6Nb/hjzx0bMVQT2fAFSpt9t2ai1YfIaFV3OFTfZ/cIMRcbX6L4dAEqRGpOTabrhyH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389787; c=relaxed/simple;
	bh=8HHoV9G64Yx6NaWyyn+Ns6lZRbyazbcxSitaY3j1g3I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gD552B8BRChuktxViugWjc+/o4VRWRR9SVEBFSMOctYaVXL/zCSaUZywv83n4Iza0oLvyWGoMhOOe1AEgKe3i93EXmLGxQ3lDHH1ANOiS7i7LKdFrYDPBadK8HbdzJeKBJU/1WxcPIy8ab0L03cKH/LtqQ29HDgR+hAgJ97+coY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QNCpIfqg; arc=fail smtp.client-ip=40.93.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QNCpIfqg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upgUm6sJx+82jozDPAorZkfwpTLzJnYqZEjykHZCteTRYPZojsRQOtuCTC/dHzfp8v2hlT/O/UREBJNoZIY3LsBzoT4X6v/AIiPhY+5+y3M54v530mXmOKxoTgD0X/TbdD4MV09LfcDcFkLRL0o/mO9YhLlsM3GVMuxJrr+/RLn4VbeK7uRDz4Xb3B9d7Ef+hcVWfBQjn/ZUkG8sqQ2DnV4nTds9CCuAUi95hkPpetVg+XIS1hzoSPXKbOCNzg5l9BVoaWGMHQtf+RURCsRFTUU/7aXZ1QiAXLp4IEBsP0gvJ2VR/apaphsQKHdo/fuzuJhQdDVees8OL1GmZ599Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXtGHCBxcOtlEL1tpJoN39J9HEV4nKKk0Jjougxbfu0=;
 b=dGHVYxyhWQfxOjWIux31iNc9tw6b/C6f/eOXbM4G+0/JVnZMQa2qiryzHqATicH6/yggodnyakvnpUKtEUGHTWLleIkK9Bmgx7IfleOPwAinPAy7l3eHzQGKevvEncC6j0mjwY0b1Qi+DcHd8gMVO4qc+a7F+1sMGPnpa+P0RtG5sfBNsEslUKhw2TubyQhioZ2T0AJ+Fs+0RXvZrWkWy9jVyQNTxVCyFsLGLsokfRxMlRPFjI2riHLtJhEUBMzw0LCe4FQhNHd4lvPdCJdanSwi10pXfO8srDZ6hv+wntpJjnefbv8OBGB9rN/urmys95Q+X9UhoY/kHsMVgmhwKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXtGHCBxcOtlEL1tpJoN39J9HEV4nKKk0Jjougxbfu0=;
 b=QNCpIfqgaR4vMxCWn0vlc7wzc23BwoJbF2rVNsVdPU5ts0CMtWjTu4CgezD346D2qrLRdpVSvUCvtE8pNCPjG+9haAraZHWpi7w6Nm5oRqG2vKp7qHM1DJcql7/tO115FfzIrTf21WELzKcg0u/9zHHKRTXlgeVOS00G9JEwCb8=
Received: from DM6PR06CA0094.namprd06.prod.outlook.com (2603:10b6:5:336::27)
 by CY8PR12MB7316.namprd12.prod.outlook.com (2603:10b6:930:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:22:48 +0000
Received: from DS1PEPF00017098.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::16) by DM6PR06CA0094.outlook.office365.com
 (2603:10b6:5:336::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 19:22:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF00017098.mail.protection.outlook.com (10.167.18.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 19:22:48 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 14:22:46 -0500
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
Subject: [PATCH v12 5/5] x86/sev: Re-enable RMP optimizations on SNP guest shutdown
Date: Mon, 10 Aug 2026 19:22:33 +0000
Message-ID: <f5c65e48ccd8a31680f7808d49d09e85ad6f83b7.1786389115.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786389115.git.ashish.kalra@amd.com>
References: <cover.1786389115.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017098:EE_|CY8PR12MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b578191-7629-42b8-bb19-08def714c373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|7416014|376014|23010399003|11063799006|5023799004|56012099006|10067099003|921020|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	6G6SelqKl7OKcyE/dPnli76+mRHAqkTQtJ31VJ/sSDR1OQFnmmjZueFTyf7NIsS2Crmqry4iksmrhMX+1Ne078JFLWYdLCX8qlGA3V2w5hLyF2hoJnB7ju+9AjwH1d1daXekdgbRZVCOvEHL4AxShyaJS4pmzJ9qqNq7uYJU66JTmXDRCeh2gvUXITpoAo4EDhVCHr4WzI7E0D7e0nhPy8R6XG9wgnAKlVCYYkukys0iIXGwF2+UzrFnkOk5ilrDy7N7n3gm5rlS2mSTcZS2JlwfdTwqGyAylmFRX4TQtJmGB/6a6AsZLJk4ucy+VsRzRpK2kyjlVymlnyTpxSEuPypWYaex++Tke07mREuKtYN3NDPs6vAtXu++peEqRHE6d4g8hWPLpJaV01aaii1rGPIB6yVfz03sfjbQ9j1YMcGn6Sh205VDj4UUyz+Bts1X9Ly7/M+qCvdl4RPSrCVAoST9DSv2/HPURd3bJJblCQwSj8JsTXm60AooUGl9GYWA7XXeI03hOL8KEhwIpX7vzyl9dyZVBJKZEqJKhbX/6f3fp1XtkFsK66gI5w5eWOYCgL3TZGVhosBN6rkr4KZA9drEdFTiC9A9lG0TIm4OR1Yfcjh3aDHdz6qq8zNrAbywj8FmNwBamF8bEXhcOxUq9SHLlpzW5YltaAp2UNvWHojsqrhU6Jov9MG5KC58GQ/4cLI2eADjHVVDpuH6M3+k+VUHyPaU7Lc9TYyQ0G8m0viQiB/HsCGJNJYt24dd20YK
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(7416014)(376014)(23010399003)(11063799006)(5023799004)(56012099006)(10067099003)(921020)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jXD/aMh32jRXXsCo+awe85GbQImLD3fOGq2xfTuxtuoHlE7n7HhK7ZelIxEw58j0UfjnnsxJNusi5hS1tXg4rlWuyKZtNhr0ZuqVcai1fjfLYpNcf0B+z41JGw3y1XILmI8AVmgQUh6mM3yBnP1pDGCmftzR6ELGfhlQTmHqd0NVVgxNx1kFrqrLvCXfzJMiDOga4fHeUMWs/yM0Y/gSCeWRb8IsT9U+b3fKx6akSZWCAFktp9EH9BU+p4tnGazxJG5EOJ/YHyV978oI62HK2RyVUhj95yQcJoqq0Ir+Xw8RrxgG4W+U2glUR5tRacknS03ZjV0QpFyEKfX3dPhmsnQGrGj6lYD/htD60EC3CBPp+ygjtIB86k3Fc2+N6D8vTJXJK87WPyECUWBDW7OIQf3mSAriAiO9GhPtTokxB4bLgOAPtG5/SgnzWaR43voE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:22:48.2938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b578191-7629-42b8-bb19-08def714c373
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017098.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7316

From: Ashish Kalra <ashish.kalra@amd.com>

The RMPOPT table is a per-CPU table which indicates whether 1GB regions
of physical memory are entirely hypervisor-owned.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Normal guest events disable RMP optimizations: pages are converted from
shared to private as SNP guests are launched, and large pages are split
and collapsed during guest operation -- both disable the RMPOPT
optimizations for the affected 1GB regions.

When guests are torn down, their pages are converted back to shared, so
those regions may become eligible for RMPOPT optimization again. Without
some intervention, all RMP optimizations would eventually be lost, so
re-optimize all of physical memory on SNP guest teardown.

Perform the re-optimization after a delay, using mod_delayed_work() so
that the delay timer is reset on each call. This batches multiple guest
terminations into a single pass: the re-optimization runs 10 seconds
after the *last* termination rather than after the first.
mod_delayed_work() also re-queues work that is already in-flight, so a
re-scan request during an active scan is not silently dropped.

Guest teardown is currently the only event that returns guest memory to
hypervisor ownership: SNP guests do not support ballooning or memory
hotplug, so pages freed during a guest's lifetime remain guest-owned.
It is therefore the only point at which memory becomes eligible for RMP
re-optimization, which is why re-optimization is driven by guest
teardown rather than by a periodic scan.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/kvm/svm/sev.c     | 10 ++++++++++
 arch/x86/virt/svm/sev.c    | 27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

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
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 427229347876..c574849b1587 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2992,6 +2992,16 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		/*
+		 * Perform RMP optimizations on memory freed by terminating
+		 * guests.  The scan is deferred, so it normally runs after
+		 * sev_gmem_invalidate() has converted this guest's pages back to
+		 * shared, and picks them up then.  A very large guest whose
+		 * conversion has not finished by then is picked up by a later
+		 * teardown's scan.
+		 */
+		snp_rmpopt_all_physmem();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index b53a12baf4a3..034ed547ac28 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -696,6 +696,33 @@ static void rmpopt_work_handler(struct work_struct *work)
 	on_each_cpu_mask(rmpopt_follower_mask, rmpopt_scan_range, NULL, true);
 }
 
+/*
+ * Delay, in milliseconds, before the RMP re-optimization pass runs after an
+ * SNP guest is torn down.  snp_rmpopt_all_physmem() re-arms the delayed work
+ * with mod_delayed_work() on each teardown, so the pass fires this long after
+ * the last teardown.  This coalesces a burst of teardowns into a single scan
+ * and gives each guest's pages time to be converted back to the shared,
+ * hypervisor-owned state before the scan re-optimizes their 1GB regions.  The
+ * 10 second value is a heuristic trading re-optimization latency against
+ * scanning too eagerly.
+ */
+#define RMPOPT_WORK_TIMEOUT	(10 * MSEC_PER_SEC)
+
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

