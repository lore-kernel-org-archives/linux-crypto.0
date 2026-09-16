Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011033.outbound.protection.outlook.com [52.101.57.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECF2448BB5;
	Wed, 16 Sep 2026 19:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588478; cv=fail; b=lsCqJ0zmXd135KhbpdWenayi1tmoNa4bEZL/tluHT89+iV0pJjvcDYecDfHPGZOogL4KigmsLETOOIO2tvhmrRNOsHXzzrp/S7ZkZ2jOKu7S+aWkCSKnKKnl8PndvPjqCs0EYAG7zZzkNK7WK45/p2PlaBFjs9VxTG+RbD51nAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588478; c=relaxed/simple;
	bh=6NN8vVtC81sWuzzx4naYMx8yXzF75v52ZJbCueeHTQ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlvC7eqqdjZAj+71sIQ/p6s3EKzteph7bgnd5gCHwFOClsi0gLdeed9qcA6UHv7b9gyC960V67b52VWZtXo2KbvfkqcyzLTb/uE7KvD0a8WwpEyVhoAq7cfu4vU6VzywNmFI0leVP/R0E+SLmGX81QCY4xXgg3n8MrB9cxHzj2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xhp3YoXH; arc=fail smtp.client-ip=52.101.57.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xhp3YoXH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZIc0dqEO0WbwkWo31DfQYbuL3Xh0/25Dt9hNvHdunij6orir3p3sIM59gne7IYbeCM8iVrePAdgYntviFojitdqN8BoNaqFZyaFprFShx9c8cZeG22eOlN3Hw9tyGTCp/84TqzAQimUUmkO0G422gsoBgiKSUOlZlvhq1yje18PebDeNcz/QIoBMpp5GvBjIzbuYmU5nH0nerBrMOWMv/CmdC5rX9a72FHrdgmCEDOIvF4bHAonkADaHjC3kzgqV7zkdLBsltOXDnw9BX6IqnupfHEO72ImqIS+sKI3jnEJ/7wsBg+uwf57AUFILx9+qfHxmGr3kBMkOYaagwIEdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QiRU+QJ3rJGQlz5hLq1nFn8L9tOYZluDYEzQM9NfIw=;
 b=XCW3EE6RbS151ypZd7gIfrgdmHjDfe9prV3oULuG7pTXaOO0yOMvVbSniGpPkammQtyBVBZ8E1DfFCLGIOtCEpXa2+3CtdqstAXIi2BIzUOo7inJ0DKgTDz9Ta1emvNpgH4arXli0hSvumeRFRfZCtNf6o1JXY/AtoMtIauUJbFP5cqV9WQ5HALkyqwCtM0A9dIPGhtVYPLxcVqSfv6AgNXwf3JhtwRcPh3VnUEdIvYeXYP6mLLpaJPWsYU3HVxTbGNzPbgGMew+msYWG+hNqaPbR5VGPX6IruNcyjGAA7fW/vBjUA8q2sVwpEb/4tda08wMwbwdDAl7+CQaZ+pQrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QiRU+QJ3rJGQlz5hLq1nFn8L9tOYZluDYEzQM9NfIw=;
 b=Xhp3YoXHiciAuJ3XjBprn2aHK0OIaimwZoNhhbWoOT3zDlJWzz+WViVf52QvTORGwdWLbQfDuD7JzaXVcifNkthjJ2f+a/12ShWGixNj+jfkeu+m/9AkHtIGbJ7GDdxpY0m2bAH/BF/vRpWuvB5IMZYje7juYmVNXnoqCEqvF40=
Received: from CH2PR14CA0023.namprd14.prod.outlook.com (2603:10b6:610:60::33)
 by CY5PR12MB6297.namprd12.prod.outlook.com (2603:10b6:930:22::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 19:54:12 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:60:cafe::57) by CH2PR14CA0023.outlook.office365.com
 (2603:10b6:610:60::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 19:54:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 19:54:12 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 14:54:10 -0500
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
Subject: [PATCH v15 5/5] x86/sev: Re-enable RMP optimizations on SNP guest shutdown
Date: Wed, 16 Sep 2026 19:53:55 +0000
Message-ID: <9b4608b96d44fa256b55b6ea91603a02a7cd0a35.1789586444.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789586444.git.ashish.kalra@amd.com>
References: <cover.1789586444.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|CY5PR12MB6297:EE_
X-MS-Office365-Filtering-Correlation-Id: 3309a015-ddb9-43da-a93e-08df142c47db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|23010399003|82310400026|1800799024|921020|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	K/uNsTQJIB5hZWDUZYf9p/uYs/yteqLcvpAizUH01mIr2YAqKLJD6bI0aSorXNnWu9dECYJ+3RL5VqwG9wSjHIQ9THQirjLoVUrQo+y1jaqpJoTHIg/KM+ZsrQQp7vc/wVZAlVR45PpdRPlVLzVB+fyAo/+0Emjnz2vj7UB1pjWjwxWFxLMPob9yaQD8upLBh397aHPibfe796gQhRkP+NghoyOOkYWF0fjLbpW0kZvL/km3BzJcb2Oo3JXZ9cORLvfeKvuA+BgfaUhr44wktb9cTnNEvK9wCkwkpZrTO9dYCYGl/zAb7J/jrM87kH/ykumOe5ItGvAiAHMeylwtRSWeIL/HWLa3UNSaVS79pr+ivxljTODH3R9NsxNu3IZbccTVVMIzP0+JvDrOaH+PBlee53606Gz7VaxrpwaEE+0a81l6AsVo5EEcMvHlQh+trQgaAiCx2aRhFTbx4JyllMVPBW56daI7hgZev/XZAVl4ISLTYD64G8fM2ccDqb3QOSruQfwgTO4lUXO5/hNpU/cuwrEbWcO8wUFxBtP+YXINR0hh/Mt+rnqx7niPaOexXcmYc1wZcYLwUHK4pvt2Uh9+ho6Dp8HCHVfnIZoXw4FVOAUp0m63ME3pvXYaMiSuYYFQ5jbOqQHNqatu1w0JP9DoHUEfwskohuH4/auUjyxsigr70muKPR3A+nlJknvYP9L/muV0YzVz8X9jLm1oRTJjF5N5D0rfPPYyN7c1ViBFWSOyNzpER/3uq2D2NC2T
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(921020)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6J1MCpofYzyH1gf23kEPUbqWLMeOAnlaAllSsYT+Rry1UfmUV+xP2iBgKSpak9INxqfZRO9zpFjlBbtU9MeNpZl5Z/AhnPPNeDh9t6eixiHJVNngkC8aM5dyWoErg5GJcI6n7ABBJU8WHOjte5JH2OYJ9u1S380TMWEmuaVYeVZFSisjlhqOcfq8nYPqmqaG6vxyaKQ1n+mwMFgWPBCJWTWjiEis0VJAJv+ytfkQ2jAZ+o7yZ0avQDutRLVHSBgBubc1qVhcVyUe1hcXQ9WXhzuYwUYFQwKdM9NIQc442Qcqjtf79uC85dW9Gmn+QoefDhzGCE0R00tIkUTx/2wj9ZD151V4uWQrTnARDq1SeT/Cn2c5pLag3tV7bBuUPlyAuJc6fsO3cUAhwQDERXf7rq8KFYthSOQIk2kTBefjHuI5x50CcJpihOesLbjKbLUz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 19:54:12.6049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3309a015-ddb9-43da-a93e-08df142c47db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6297

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
index 54520d4cf280..0f000cc89573 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -700,7 +700,7 @@ void snp_enable_rmpopt(void)
 
 	pr_info_once("RMPOPT optimizations enabled\n");
 }
-EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
+EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp,kvm-amd");
 
 /*
  * Do the necessary preparations which are verified by the firmware as
-- 
2.43.0

