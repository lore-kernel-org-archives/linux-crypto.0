Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013022.outbound.protection.outlook.com [40.107.201.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCE73B2FFF;
	Thu, 10 Sep 2026 22:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077649; cv=fail; b=CQWY/yMFKANXfaBZnlnHiM2R0T9IAs+MW68d9EW7zFkq8QLebCOYHkAJk5bt9vHhQkHdKmhGAb9vVdh7o2qkBuHgs0OFArYK2aZK86gdlw0Va4hc220KsAfrt6PnTzaZ+sjCCRedcsGXa0HBZl0jQk6H7vBRNqkyiovPGrcFnew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077649; c=relaxed/simple;
	bh=Z+lBPRspMHWamrDyoqvIdibJlMYeLXzDumTvD+yLwPk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwrmycC35zU5QIPYNPFfcTQmWltCuOhf62eChFyo1u/PLZ33MHLOW4pfn3azkY8l0zRgmO+yI/nBDJG+MCIne1GBCUPJw5shjNWNDyHfQCctC/9OS+D0tA99Z23xWJnGgl4H1keFTCnoAGCiKCDB7THlxywPLPYgS7Hjw6H8Cz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CVsYmmgU; arc=fail smtp.client-ip=40.107.201.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CVsYmmgU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ns3ZkoR23r1VsaerECbuZcqSbMETrnHMuwbp/oOFKiZWzTizmd03keANEfCtrgOsK5Q1AlNaTY06ct97ht8EIPyQTjKzXDb/BhtqmokboSVQ1avUpqAaLG4N5HCu4DBoU+SHVS0/qQesC5RiTmAJi2WlLwMjBEPuDTMLxZE/LlvhKRMj+CImSRmtzxmYz6gHPkHtlp1r7yseBCargMl9Td/HNjOj3YpDNA5CD8YA27+RKjKyUVP/3BIo2AEXY7pcU+hZ9yt0DFXwSdA8oUNJMJ/i0qP5tihwSGjSV4KBQNgAjPhekb8ZEVMh7TepYQHqeD2SWN6gb41jSlZNOrt/ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aD4RYHbmka90X9bPBHoIzFcYX+7mcXV8A2e+OQfIys=;
 b=UEy1KuBfMMzMJHQrPuNJ26owRxSu6DXyMq36StY90ZibwNg2IsePW73vokbP81b3fc2p9CNQZ8Jpgj3aOMzQ/GstweOhcc9Gr/AQw2xEemcsIo6l/sNvKR1gzzbQvASv6SD7A1NtUhynIFOLG+aaFFyRhRREGr2uuF1ORZQMAQbbfHdC/14hO2qnTMTJ5nDWAg3sAOmNsleR32FOJ+4iqjSAw5jR3S++Y2ikrua+IU8uQfuUPb9WGWkphake+Z6QRfEAYk4aPASSotSN5j46YqErrrvk89tM92YM4qqp5DlliUj4yu5xa+aiVwZ+VDyy5U5DdMfXpeJzHwZr9ptCQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aD4RYHbmka90X9bPBHoIzFcYX+7mcXV8A2e+OQfIys=;
 b=CVsYmmgUc06UVMrlmV2hAc4fu9sUbOpR2OdwJRm51BLhOoZiz4kjcpY+zILU/w5UftrALFXLY60zehqCLTunGERuCSOlPPlNZBk5djqWezv2OgwY4Fb6Gjs7qov45eijvfR7K8LWyXD9Ro8HI5JvIL4KlUIaIy2Jk7moMY4DxrA=
Received: from BN9PR03CA0957.namprd03.prod.outlook.com (2603:10b6:408:108::32)
 by PH7PR12MB6695.namprd12.prod.outlook.com (2603:10b6:510:1b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 22:00:36 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:108:cafe::23) by BN9PR03CA0957.outlook.office365.com
 (2603:10b6:408:108::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.8 via Frontend Transport; Thu, 10
 Sep 2026 22:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 22:00:35 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 17:00:33 -0500
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
Subject: [PATCH v14 5/5] x86/sev: Re-enable RMP optimizations on SNP guest shutdown
Date: Thu, 10 Sep 2026 22:00:24 +0000
Message-ID: <a2dace70da1ea687b81a237372d4b7b6e82f1cd3.1788984053.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788984053.git.ashish.kalra@amd.com>
References: <cover.1788984053.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|PH7PR12MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e349d9-779c-4760-28d2-08df0f86f147
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|7416014|376014|82310400026|5023799004|56012099006|11063799006|10067099003|921020|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	W2t2Op1Er2tnNCe/uFQZ8rQBLZzgpg0VQDjSGxjAbx8R5NjW7xHqrJlo2J0zYyDwmjyqf69wagngGxR9OgVssLfO2fpbV0DKvuJBf/LsmEncVn2EbcAe1N4Awhrsfc+UTdFjBpSokEaeEALgiFHT2k0pZPmVjNo8usT8/q/0Xw3E0wReoNcxnGt/cXHzKKV/LMk/gN8z8Fnm4QxjZ/AgGRkitp7JI5rc55x1HmSr2+jrUpe+bkh1C3DLihOOKrcwovT1Qaz6dJ9R/eOTNiLybAzm3Ad74weIpxtx/xTy6ys4ein05jXGzatEgt7TVzUTdc4SJYV7nvUXEjXrAibTf9+VCs1PpEwkZwXbfDrkjf6xNKZ11tj0eJhjk1uT85uFWP4KNKifaeRHnbl2+43+adXRMe67QnwUH25lbqrPejRBoA1nKJOCusPZ/cbNZHgsGvmE0z/0rXxbpVU6BddA72sahYHfgDNCgLz3WwkVF8gThluSRe9mILeLyhK7d9FXn227pQQ0J821VGudLM5qAk+3Si7ECzRZz/ywOVtcKQM36kxW62DLe+a8eE3WBJ2/7WhYhJJM/SltaemX14wR0yCqtMU6l27BFddhTV0x3Nd20mY/QwQz6nONdG2gkcWsYGAxNM7Go2FfkS37BDCdC4R946fvKi/Mlr1RdZa4OLureZh6Lehq9hKdrXW162j+Y+OPLPkhFAVMLvAM6qb7cnv3rBFLNBn0eflEeCL54rwYchXmRjbUuojAt2w+zYSh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(7416014)(376014)(82310400026)(5023799004)(56012099006)(11063799006)(10067099003)(921020)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J8zfr3R+QF39K4OCPz/kUh1qjbdk8BrgPrAZRmnbO+hfbSHvofJr1vwufLGBNcJtVj/WGwP6ImilKyMdVQNbpNBig+1onh21eyARpqwj2qIOh89iaDLq25uGHPUG3/fhNbYI/S3MIhN0rVTLrPBXmmyHt5F3WJJi4lRqldHfLFYwfwtta5W456hfXCtu2ooEyhTczPGIv1LMqHo592DwqcdndGar9ZAqpOMWYML82x2vOVd7xQ1Drzfxl3vuyOQ2MqojVihxs2nV6zLUllKglrReVsLNzcRKwKAHwixkco1WsJsbork3HXrnrWgUBEPR3dxY53ZjbSC7O0sfAtiU0Eplj/l/AqRCDREPiPVsHVKxtkMEzPzMqE4dXxg6i8k+I6+qnV1gAr11PCayy6e2F+Y+O420mPk7NSeLcxbY6QPdG8nZxBgUoL5aCfvxx1wV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 22:00:35.7475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e349d9-779c-4760-28d2-08df0f86f147
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6695

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
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/kvm/svm/sev.c     |  2 ++
 arch/x86/virt/svm/sev.c    | 31 +++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

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
index 5705723f1f41..d8e6b8a08b79 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3032,6 +3032,8 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		snp_rmpopt_all_physmem();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 35678b1f535d..c16f82642390 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -640,6 +640,37 @@ static void do_rmpopt_work(struct work_struct *work)
 	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
 }
 
+/*
+ * Delay, in milliseconds, before the RMP re-optimization pass runs after an SNP
+ * guest is torn down, passed as the delay to mod_delayed_work().  This coalesces
+ * a burst of teardowns into a single scan and gives each guest's pages time to
+ * be converted back to the shared, hypervisor-owned state.  The 10 second value
+ * is a heuristic trading re-optimization latency against scanning too eagerly.
+ */
+#define RMPOPT_WORK_TIMEOUT	(10 * MSEC_PER_SEC)
+
+/*
+ * Perform RMP optimizations on memory freed by terminating guests.  The scan
+ * is deferred, so it normally runs after sev_gmem_invalidate() has converted
+ * this guest's pages back to shared, and picks them up then.  A very large
+ * guest whose conversion has not finished by then is picked up by a later
+ * teardown's scan.
+ */
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

