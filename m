Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012071.outbound.protection.outlook.com [40.107.200.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B020A39A049;
	Mon, 18 May 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140631; cv=fail; b=qe428go/kbVuCPY9/MgdV7+cXKuFVclAivzHGO9+k/S2gx0fYN6CCB0BuAGkFU0m668LalqtejMj00AWKpY6aqfDL5Xloo8DRArOBpjIXwhASWEWL/vtdFhZGTrCz3CsPfr/rpzZfjv4/a912P6tJMlsX/t/yEPqJy6aL27oTTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140631; c=relaxed/simple;
	bh=vuGdLL/e7nbmHBQa3VVs/TpNpujz2G3aM+7E5CDFFTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixcwKVKLOcv03xz+sMYNg7k4Lzht4oDocz1+/flBNylD3ycdMXYgsOxeaFP369y6eJuWMqri8qfanrOErWfBeGMBgKspzbU9VZ67WBDnw+iCQYgoLInudR+hFVxJRSXDi41PIMwobXWYehedIs/ocQ4YJO/LeZ2b1aOOguGSAnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3DSMVqV/; arc=fail smtp.client-ip=40.107.200.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3DSMVqV/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G+o+llBurxuepNlbQoP3P+zRvAIh/p5a7j+jhsbPaQpqhQyxtZJI0NzjAxeVBk/K3/6cdpwCAp0U/n8eixOfbxK6bUpa8+bUoI98lV4D2pstyHCisV3o1CPkjO4DNScOazK16Nykh3hCVZsGSgGmE5PIUnlIOZ0NPWXFBaQ028Sh4akod+PwslnlZElQOht7xh6fAsFFZbGQbv3gQofNyDJSn03REW6+6FnufY/IQZOCZjwVC5bIBxuvrbQpa7e3lwc/M3VOD4ghFxB7nSV8V0P+3CjnG/XariusUc2sRuS6I+m9DS6RwxME4mZr/6JrnsWm7CHKhrEEXzPhS7ZTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=lY8YZPUNPcK5X3EA6LmfUZn1sOHZknipzLbAsj1jaQHaD/PqvSE5ACL7zVK8mJPhW4UtAiCvrNN5PknBVF4vQeRm5gHrFDDJJIsPPRlh27ALr4iUH5Q9kaEK+7CJGlpSS1vy/etp4gVoNfeN7hG36aScNiASBYMqwL9T7fuwDADee34djQPocck6z/iDHiq3qEWHlRBIFZTdno7GBKi7DZbMtBAylZFKpbpWMCl5mKBe5VUm4Xj1k7a1T4AsXZ9znqkqywZ4wLh1P68lkd9nvFBoIkAV/+FYIYXeTK5IFR9E8EUxtZrKP/bukSIXveE1WsDh3RHr/YgBEAETBD7qUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=3DSMVqV/Sv4NmXZ+QOnXzVp3SGVz/a2hm9I7b/4OlQtXeChueYfzvcz/U/cAhuLK96bPuIzvYPlY6XGcW234LRRki3SslWJaYtX4qzv4nyMC2YWPLvvWSjcxNtUOPT4HaN3avFKIF2SbJLHvhJmRiBsCZujR8VWGLLYawPPxIBA=
Received: from CH0PR08CA0011.namprd08.prod.outlook.com (2603:10b6:610:33::16)
 by PH7PR12MB6810.namprd12.prod.outlook.com (2603:10b6:510:1b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 21:43:41 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::d2) by CH0PR08CA0011.outlook.office365.com
 (2603:10b6:610:33::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 21:43:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:43:40 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:43:39 -0500
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
Subject: [PATCH v5 6/7] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Mon, 18 May 2026 21:43:30 +0000
Message-ID: <090bcf4d56b3966dbcd6abd60e02b3f5e3f4fdab.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|PH7PR12MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: c231a326-4000-48a5-63e8-08deb52686bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|921020|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	tCYBAgyNjh1cA3rj3Ehc0aRWwUhdpp49HVJm9vQXL8/3ABETlcZ4VfZumChW/AxEalAxSa/elzDVqfwb32OTqCFLUqCTz3W1cNs0sco1FE+mOoqOGVDmGflnAwant59iSGQJ1mXw2Ndmjoit7eCoZzpTj3X5RSIMrT8qUoIGu47EYx6SVWrMs0xHkIVvId0lWCG0P1nj3TNwL43tC86++gYwW07w13jgr2amEo3syxFQdDDzNk8+yBiIT7mGMRrPM3oaplPFvTcif8AUWVeAHMxjGLJR9+VPolvZtd7q+8+kroDtqQiMgYq5VvBq2iBKInirJS2a7SBMdY5HLxJsOVdk5Yvy6VfcyH1VZfYzlFC7yPVRAh0HAJONQM1bxb2S9pgbfZcGkrz3WXTiGahmXfYVzGYfqvRElPLee8ROFVzcYIgMx/XfyVGJLxPx50+YnpYIrJUv1OM3xZ+2vFzGT9twLpLUogxRdTwzwwSus15reMfv3T/fXDqsU2VToIQHaCBPbH/tRN4GDMfMugjxo/lTeadcw+bwndmMcEX36/mehDgNPTSxcsEp4uCOVzJKQEPLfB1RW056jn6FUnWL5ywyt06xM4TlQZ9q7Fm8AygYuTHIsG5v5E49ggQyKOBNWy1emII4cDGNdBkhTc4EsgVm6qqzE/9fVyEL0GzyHE+bDVSBay9RdjQOR5OSLmKgghUJ4SgI1QodNyPH/MD6DaMSX64isCBZB0c9HhpO9oCAvV88ePhF0slam75p7hCe1EhFunQ6C2y63QIpSwKEEA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(921020)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RokE8t6KnJGqa+jaOSb3yLiQQ9CfC8YYZqSetbQkSy/rh9veUIEDUL6+7h4ftZ+SF3KbVTGlMc+iqWQSSb1FKF7ns0ine9dPJf1YufBueTwZ7l3K+1cW/tq8NSJbOyJH3eG0dyii4HzsxZQhEXRCCk9c3bvEAO5kF1l7DULKeaPLtXCpo9WzRjxICOmtimm/TGRTSQtFe/Uay511swQG7UQHlCDMJpzYE5/1t7raV9aKCgHbaAceDnWBVuYN+nyTRZxm2Kv/G9cQpdq1Oz1eZb19Gh9sO8lKnuO2xe+u+cQ8SPA0+YYu0HQmB/DstbLERKkAN4vctb7L3MK9vDjRgYvl0o0cZk+ZyKVTS9UJEJtQ4ZyTFPVG94T2IOxdK44zi5mURzqWUD1DkryN+XW/Lkc/UL/EQLou0T8jV6r4EA/u+DBJOFeW9RTzlb75qBBD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:43:40.6707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c231a326-4000-48a5-63e8-08deb52686bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6810

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are converted from shared to private as SNP guests are launched.
This destroys exisiting RMPOPT optimizations in the regions where
pages are converted.

Conversely, guest pages are converted back to shared during SNP guest
termination and their region may become eligible for RMPOPT
optimization.

To take advantage of this, perform RMPOPT after guest termination.
Do it after a delay so that a single RMPOPT pass can be done if
multiple guests terminate in a short period of time.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e107f368ed2d..29af6f6e603c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3005,6 +3005,8 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		snp_rmpopt_all_physmem();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
-- 
2.43.0

