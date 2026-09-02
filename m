Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010057.outbound.protection.outlook.com [40.93.198.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843E39E18F;
	Wed,  2 Sep 2026 21:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384591; cv=fail; b=JIto66THA9jJX6Lf9DZZC/nbMPnTihupyb/GaDSBHrlwtSgoIqvHFjOoDPIcPAVhUH7QEsKxyuR+SImNBWZvU46B6h5IaODbryeKFdun6PkC+S7zsyQLESLRqTcIJq91zofzJtQ8nRnN6KzIoGj+A8hpE6cxvpSlOpw35Xqy6wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384591; c=relaxed/simple;
	bh=drURAFQcUo3hIdw1hSaaWJmPEGxZwRXQgLK9XwYEfA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Adxa1Evu5YTZuSQhPgcUnFaMWr7c0RIkf/PqDLwmTc8ABJDGD9HN9XKuuX8Qrga8wg2uzezNPZQCxXthN/YcJpWeNwVngm+r0AWvNj7SgohfYlNoB/STc5oxakQSiRZnY7kHJgPn7ZLyqyVKALLhvLrmRdsCZaVECPmk7aRZyYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uVubqQGz; arc=fail smtp.client-ip=40.93.198.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uVubqQGz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3zkwnzGQO3foXEp4RJkoFA1ONvUxAoj5odQmmGM6AmhGmMhgLX3DRsGHmQimBoXSvP2oWYDJwHx4Qzj2FPq0fXsyB/0RxzTj05k30jmGLm0c33HK1u6JSm11o3Ju8KrWZjU0x2Iz4bTdbizK0nUgcc2NmGd16OguXi4K2tCdh2q5phH8ejS7M/ZkBjoWDN0BYroBHrqObaExgbt1tX280HQwtF1AURQgWfPGWpIR45859M7GtrUwqMuCOzr2+FlvcGU1iWXCeT+ExI63htTWGU8rTnmEYxHNJh/t61B0kDcHUhoa3m5cH32Xg0pCBmP32UExizsCXYu2peKer6BMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0yVhsuxHyVY6tx5PUwkVqtsa5YN61Y871A7sXvmIpU=;
 b=msH/9ij/K79/Ioj6i1l2KqFMT48WIgi9vvI+hbAF71Jqu0wb4tUmCdoLO5o3vazvX6omMQ0XQ4/LTxHM2WK8KnnZDnXeeeiK5PusfH8ckh0HSKVYgsmeCfP8zKkzgBvFvXWtA39iUFOw5fANTYmTdkHjcrS6TvL9NE0Z6QJ5elRCGIZq9Uhl9OOxJYNHjKtnmXh/3HIMz6ZQ22Bc54ezdZy0ZbxZ/vrUN7p9If/Ii9RbIbPBHcBPwhy/rAbu5ngkGuSoZ0uXADuaG342z/fd+mgGtPsxm4VcHFi91Bp+UxGKf0GVz2zIU5RngrLWBP72D0u8TKW7oQLhRNmI49EByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0yVhsuxHyVY6tx5PUwkVqtsa5YN61Y871A7sXvmIpU=;
 b=uVubqQGzx9JfE4+9/Qn1yV1bf6DLk6k+EuyG1eKm7T8SBz00eWSEDztclDzg2ZiD0ApVhMhcasBgmTGYCByJzGRj3Zp/D+SWu0lT52A00MQoDZZsDgViYwtOP1yuxCbEWfdOw+SwKDFLf8bYem5QRCyeeg39FLhLZjg0OBRxIhk=
Received: from PH8PR07CA0009.namprd07.prod.outlook.com (2603:10b6:510:2cd::27)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 21:29:38 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:510:2cd:cafe::6f) by PH8PR07CA0009.outlook.office365.com
 (2603:10b6:510:2cd::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 21:29:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 21:29:37 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 16:29:36 -0500
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
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v13 5/5] x86/sev: Re-enable RMP optimizations on SNP guest shutdown
Date: Wed, 2 Sep 2026 21:29:21 +0000
Message-ID: <e8a8d0ec63bda2db61cde7cf298a4ccb6a502c20.1788296083.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788296083.git.ashish.kalra@amd.com>
References: <cover.1788296083.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ad825a8-6763-41e5-f05c-08df09394a92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|1800799024|23010399003|10067099003|11063799006|5023799004|56012099006|6133799003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HkmwsicCpSahHQeP65qFn9cDVDT3WZNfguuXEmUzkj9dY1yYolJDOt+zuL5joOvewZT4gBPRT7sN8kG45OYEkhxE+O0YdvUUtiif/Lwepb7aDE2quo2E/vMZzYfsQM+yWHZwKFXwEz9g4fXCk0Sy+TK1Sqz2FC8fuCE4xtNwAzRfNcq+gpqjQrRtB68HNb2GMdQRUwHjpCxjghtfeoIhD+g7ZzfuZGZas8YUXKFG3EmiBcwiuBParRqCsX+OgCERuQSGMIfd8W+30zk+M+Y5pKQDRJuP0/2eQ/VC6PJ1VAlFJoeS8HrPnKez7Ri49IyBS7BmWu7ocw2uUrtyIiC30nuKavWbfRLV1wwIbIX+7tLpnlUnJo+mtipPjyJQVdmAOJ8kPluwLigDhMLCgOzsrMCo0HnC3CyN/tuNKASQCdhs9SLSkGiwZv5UNI2qpN8y7Eo88HjQC/h13LC5j74GbFsGfHwXFTDwqbcT35K3Tj3mT5oxupms2JIvjNjpkBWGsyQZKZFPboUWBRj8W84+4H7UiWH3LL52EmLQh/0GPn/Yx0vs6FAcC2dS2ZMesxeVb8nqUsqlJuJXMNtsJa3OgGJE+1azupuNejJEB5LDt/h34w/K3/XabvGjvjaQKPOT3tkAVRuR9jTACh/TsPi2OEe5anv8yEBJxwRph80J9LdyUJFt4Q69ramdqmuphQgihuiHSPirqiLadll0N1+mqwYATTZASESbXrFIyfcgbaGQDBKK8a+8dnu7tkJ9TFNE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(5023799004)(56012099006)(6133799003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+6sXNaU1KduA3m7Pubhk067yuG5tDFM/xfVqkReuk46Tbw5o/DFkFhi2WmCHttJpFex2wewF3loYDD7sOCeBIKnpYeKhdhoVD6jnECW2YP133x1tZfUes+SNyzkRU0oHGrYxdNJQ5waUuXV5am3bE+VhwjOmvsM+dWPIbHMENfM16hSAfG4i4wxJSbNcA3OHAWwrraCpRikqFxyc2x0lkfMNawv22jadWXTYpBUvRJucUB6AZ5XrNW+HYXwMeCTLGkfHN3fAFmSppltZDYXAlwQGNC/b+iZp5DNShEk7E0Z0CjT3mTtPQyfD5oSXtDqB/Q+yRYFTEo9wkGw6s8z9zaStPvQB1KONUXHzEckQa17Tq7VlHyyl9YYfCzCZanBe5eSRQ/4i4SaMTAhhRBMN0kNHc5sZR+MG0I6sNf7Stf+1MfGFDxmn38jZNp8Q8eOy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 21:29:37.8207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad825a8-6763-41e5-f05c-08df09394a92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/kvm/svm/sev.c     | 10 ++++++++++
 arch/x86/virt/svm/sev.c    | 27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5638d09b5132..3235e171647d 100644
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
index 5705723f1f41..0babf96e38c6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3032,6 +3032,16 @@ void sev_vm_destroy(struct kvm *kvm)
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
index a4c0fe49b9ec..fb66a1aa6fc3 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -659,6 +659,33 @@ static void do_rmpopt_work(struct work_struct *work)
 	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
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

