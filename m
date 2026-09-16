Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010024.outbound.protection.outlook.com [52.101.201.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB914657C2;
	Wed, 16 Sep 2026 22:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596977; cv=fail; b=taWH7xW6dAXDMP+vpftVn38EQYbCAKFYRzm5bt7QrX59YZxrIOxHOFwcjCdpC68/wCo1lrZfXAWElsQriOvFnZdhFWb+0NmAFOFBhqEGiXY/L23Yr3I5W7aB+tJtfBYlDmLObjam1Qptzy8LgD4LBxJIdraQcRrBoBSpTFbzWLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596977; c=relaxed/simple;
	bh=JiEsn2nFiNy96AhW93+Ovn5MdyQxmZ6vj4Z/C/JnbRU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xt36uQzVtp0tP2gpiKvsbwkHwssTg517VInQGltVluLA769/pXQFw4zF47Tg7uhrio3MpJZ2sG9lqmDylhuhLvAcNu2lkVlqYzRxJ5jQq14wNmbwo9+yB7iC2qIYtPIYEZZJoWtyJB2mj9TH70wzhAIQN2OpRuv6WeLO//kbp6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kENMo65b; arc=fail smtp.client-ip=52.101.201.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kENMo65b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1Pz6cK9WWefhD9XUw1TXNyAOo+Dq+yaiENB40+xMVA0hcl9GpH8gp6BPEuZk1bFivEwcPQdGKuMtKr6BLzxcpMaHOxLwtLfi9ueym8+jNWLUeYfFi+RFbgzkLDbvLrJilVosHGHFpGXEK84LsU8Q6h0fNI3pVHMicMf1uC3NJPbXH5CNQw/TY6Tf8yeesgPhLabk8INT/PN7Gg19ETY14swofki1V6BmMmJzBo/mfhVXWO6hUUS1FcZHInjfjOce4SubzlWBoIZfW/G7l+6UXiUjmcvxJetgDpmB1AqTS3PrbkV7qoYIaQ2wrc9DZawO8OEDlYGYGOqqcRnkDHkeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mw4iglQk0dlTUyHTRW1lm9fP8hCwuZuT1/2sS4LzHcY=;
 b=gYIdnjUYugMOX9KGW9m8lFzsTDNutRp9lRiVh8QHQOF0TG8Em/MQVRgseazHkJcw9zE4w00SkUdLnGPDo9RnUJ6lzgSuVf7mbi9Dbd8QLo7vuweNLAgRsSYCDauDhE0LpWC7KEmLYOwxm0z3thy1Iv4boVGsFr/Z10hdBKsY0bgQsyOhFWOfbXWRl5hz1cj4e0KcZw02IaJ04XVfcm++A0IXsTNgcrY6nBVMcudqrypI+9wRHf7s+gygMy7MUPtBEiaSsdqULeXYkGGkcP2EHJBGpTubYj4C7s/qgVbajg5fyZuiH9RAkRveC/1NdGRUEWEP9x1Ts0JoK4t2kZt/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mw4iglQk0dlTUyHTRW1lm9fP8hCwuZuT1/2sS4LzHcY=;
 b=kENMo65boqtztoy0GPUzilln9xQjqKh9CzpnlQCFpccn8X+e0JdmNudBcHE9OAxSPoYAxE98z+KcA73goiF5tZcPJ26EyR7pXqI7+w9lUtkEQEixJJLmKhnoYyOY5q6F0zYzvd5uZV5CCfvsIlKvxwP001SG2utN2XPnQPQBHeg=
Received: from SJ0PR13CA0191.namprd13.prod.outlook.com (2603:10b6:a03:2c3::16)
 by PH7PR12MB9203.namprd12.prod.outlook.com (2603:10b6:510:2f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 22:15:56 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::40) by SJ0PR13CA0191.outlook.office365.com
 (2603:10b6:a03:2c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.7 via Frontend Transport; Wed, 16
 Sep 2026 22:15:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 22:15:56 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 17:15:51 -0500
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
Subject: [PATCH v16 5/5] x86/sev: Re-enable RMP optimizations on SNP guest shutdown
Date: Wed, 16 Sep 2026 22:15:37 +0000
Message-ID: <7a15a880ea6b6d53b3702def3b3434307656afd7.1789594774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789594774.git.ashish.kalra@amd.com>
References: <cover.1789594774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|PH7PR12MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cff6f0c-80f7-45d5-00fd-08df14401460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|7416014|82310400026|1800799024|921020|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Os+Bif6SkLROewAw+GGh33upxyh5ilhfrgTa6H71Y4Hx4cb02Cvk8aD0RUKny7/zLM3YUEtaHGkY+0/RHx6QiX3q3fPIfAk4Mp9BsxZIjLfdz2atuzfTS8xFq6iVY4Vl9qmAel2bFvItHwJ65mbCgeBkRMJh5VY2G6AAyjIRZ2DOoghulb6XxPf0K5IEZYPsvrRAtjv686ehze27JaWnyvLGPjczP43fj9ip//yiL1elXzc9qU1Htg8xHflrKfWqgcrdG7hUwILa09WTvkqamLgYp6DobH9kYFbhajA0n7DXvI6pY1ER2HLh75J6zQmhR4qfCOPxQFq1Znioy2OcRKv69GHUeSJ/LSDjnKcXgx27oBIgyl4HZ+Lm/IdsaUKl2D5sjc6cBOV4g7ZPJt2FK86r5NUeLb2c3MNKijFuEeAvIwycmJ2AQ8csIY9OGuBM+/ISnK2zpMzwOZ+QKaYhLdmqtzVxmflNTHWPj4k8tiHxpYqe6hbWOg4T+ym5MnUrNtDy0fTGR7RF6GRTkHSErZY18PQ4NvWPLggKJZmEZZ3E2Zm8pYsMVSNrrQIiWWZe3rhmEH7jA3zPgWRnJ0W0MFJLOToJliHkykA4Yq33byjVxwwnsVqf9DrEOAgYOBD+g5be6ZAQv36K6PyoVxPd/LuJNIpA28BoJbXUJDCo8ebH38tWt7JTf6RpL7EjQBIPVc7pIV9HoWDyI9dN4q0LtvdV4rh+fdoVd9SRbFfAtg8/avkjWVMQ2g/zR2NGtuO5
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(7416014)(82310400026)(1800799024)(921020)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FrJyJCRmZzB0IzVRME4vrjDF5jhEJ0WMGzeeD25NO5yN5TgOvJ+jRXOPdIZrXMqrc0KuCOBV8CVm1E0ad8M6jGQXm7SrpQ2T+fXqnc85JCh+xvRbqtzHk7hcf0nrZH7i9icZaRPR2TYCqnOMCKJqvOxi4applASRNJRsjxGqJT0uFQRwX9PexlAtYyBhzHQJ1EIvltsHiiAV/wQfoPfnpqRtG9rreZbcRTG1G8kmt3q01Hx07Y6XOKQEF3kGGjzelksveJZiEY6pCq8FvpJI2rtxNOj8pSwU9eoC3YbUnTef9SAifz9XJgXDgw+Q2oRTdcXW/0UOL5RXbimHTzwMa13R75HSpNnAWd89oiMv6ZE7tyFRxbeRQtBddm3om5f8iWnparuVuys0bD0nqGwUdpgEa2657GvsqRyqHpFvhdcCvlWgi78hQiTiZ9m7ShVb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 22:15:56.0907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cff6f0c-80f7-45d5-00fd-08df14401460
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9203

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
re-optimize all of physical memory on SNP guest teardown by calling
snp_enable_rmpopt().

snp_enable_rmpopt() performs the re-optimization after a delay, using
mod_delayed_work() so that the delay timer is reset on each call. This
batches multiple guest terminations into a single pass: the
re-optimization runs 10 seconds after the *last* termination rather than
after the first. mod_delayed_work() also re-queues work that is already
in-flight, so a re-scan request during an active scan is not silently
dropped.

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
Changes in v15:
- Call snp_enable_rmpopt() on guest teardown instead of a separate
  snp_rmpopt_all_physmem(); the delayed re-optimization now lives in
  snp_enable_rmpopt().
 arch/x86/kvm/svm/sev.c  | 2 ++
 arch/x86/virt/svm/sev.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5705723f1f41..4d5e30af1ade 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3032,6 +3032,8 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		snp_enable_rmpopt();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd97135cacc2..13d9acb319aa 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -702,7 +702,7 @@ void snp_enable_rmpopt(void)
 
 	pr_info_once("RMPOPT optimizations enabled\n");
 }
-EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
+EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp,kvm-amd");
 
 /*
  * Do the necessary preparations which are verified by the firmware as
-- 
2.43.0

