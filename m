Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F95548D883;
	Wed, 14 Oct 2026 21:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012514; cv=fail; b=CjGSfj+tn1Xb4VmAuqAYb+uGHcvYkRgM9Is/G5Vg70o5HOD+scPKSC2arrnHHQj8+uj5mdlyLAegRwGi3Thzs1SwHMMeOA4AOwZWoCAqJvPqKg2cPSI2/Unla/bfkfNV3gx4HvUNxbia6+XdIrNW14SAC7w8Qmq/qUIZQlLh5tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012514; c=relaxed/simple;
	bh=yHHSdApTo3pZGcEdFNQpodwPu7WHSyURPWb6JxUPiIo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIDbAYealHahomx2426y+QVYaHW3oNHL/Hf5ZW1pN0xhsxkUkJGO/EquTbzdfBZX85c3T6nJfWUnymU5vqTeNUDyJhvnYz3BYLm2kpBU+tsXYT49RR0e5C+O/Hin8vi9NXdbw6oIPijIUsxerHm9h3LckL3Z5U3STLOe2yVx+JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LD0B4GZc; arc=fail smtp.client-ip=52.101.61.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LD0B4GZc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lM91cbuSECs/hEgpyn1pS5EaoN0BVYxb9ehaLyvQ5vn3Brx1gW0Btiq+xfOHZpeaMPUSuwQ9yjDLgKFct2nDTd6LYO6r34DSKf4FcUpQEqTsVuYGNVVvYIJ6jagF+AKh0dq07i6uXo6x6f4q4FAXu/Ohouobzv1vcapFwmv4eockDO8tyU2b1UNeaKAHc0gOIm+/hI3GyZSjwjmxwujqAwI44l8XL12t992Y2S3JPSukWPnv59qp27npHKVTcpqEXab2EDnH1QP5yggtxXHVB7mU0H5qGZd7183RueTnaP3PPA8sOJMmUAZkK8v7RO+D2AI3mEixZqG3nyKFQ9Mzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRMrryxgm2ZcaADd1ITwVor9w4Ct54HBktQqAqoUwn0=;
 b=aBpLvK9J/fJvs62MLosKS6/3O9HWCBxl1sp4iwVnf/tTeDqIujmtaqqHc6A5XryyqBEitxxXrlcz1NdmUuDmhXPzJA6oTikBhc82HfgQwD+0njxgkcx+HALaQ1j9ifkLvcXvwccwPc3BR/JNsbUZTW6H7LnxitiVsF4cOqBYqddnL6QGY4v6Vm+0OPYf6z1CQ87BcOqDRa3v5qyUwM8G1NPzvlzweZOmm77KRr2kPOX+zIDJW8JYivfYxJSCxksJ8N9Eh4E/pXyOUeKn+Em9492uce0RuJ/7UQ4enfnAEl8SEMTlDgx/vuBMrPHo1Otr89NrcA7g7VbRIaim5F99EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRMrryxgm2ZcaADd1ITwVor9w4Ct54HBktQqAqoUwn0=;
 b=LD0B4GZcrKe9kORUkZfZC5Mii/w2Vt/hY7sCjNNCwhbo6JShdg9ZKp1iRffg9wKRIG1aNxGba6KnqiTy0v68goHsMH/pFhotQL2iC75tnf+I4welRZLJvgESYCCaema5mjHDvtIhDTbTUoqcopxfDs0WKT8wwdjlxdKq0Awk0uM=
Received: from CH0PR03CA0396.namprd03.prod.outlook.com (2603:10b6:610:11b::16)
 by MN0PR12MB5762.namprd12.prod.outlook.com (2603:10b6:208:375::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Wed, 14 Oct
 2026 21:14:50 +0000
Received: from DS4PEPF000001C1.namprd21.prod.outlook.com
 (2603:10b6:610:11b:cafe::16) by CH0PR03CA0396.outlook.office365.com
 (2603:10b6:610:11b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 21:14:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS4PEPF000001C1.mail.protection.outlook.com (10.167.23.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.3 via Frontend Transport; Wed, 14 Oct 2026 21:14:49 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 16:14:41 -0500
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
	<nikunj@amd.com>, <darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 2/2] x86/sev: Only announce RMPOPT optimizations when SNP is enabled
Date: Wed, 14 Oct 2026 21:14:38 +0000
Message-ID: <5fbbf065e912fc011ec0f043db90f530b55c4517.1792011434.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792011434.git.ashish.kalra@amd.com>
References: <cover.1792011434.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS4PEPF000001C1:EE_|MN0PR12MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b1ab84-8e72-417f-3bef-08df2a382ea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|1800799024|36860700016|376014|22082099003|10067099003|18002099003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	FymYO+oUO54xPyJ8OOo+ZIuz0QXhaAZail4ji6rLoplpK8zeQhbCKwnX9B6zTObI+tA4JSuYk9RJl6u1qboTtK33YR0faG4GuYkttwTiqrzAdpRwugHSzugkuD/9tTq4Bp1RVxsuDvC4e002XMZwuvgfrARpuZjeeZUdI7PTJ0gP3eYwa5s/VVN5szNodmdYlMSjWFcSKQn4elmJs7okr1pUUD6pX0Sr/bmB/F05L4Xzzo/9RP6CGZ8Ib1tYshbWEQcYfY5UpKRi4YmHkzGCCgxeU90G3uXaN8juozMdQJlJwFSMuEW5zFgr5TYYGVeA62bXHCDca8yHgxNdqzOjONT25xknNyLkGfkY8KykAkRXgy5Dx0IyNdFOBJVqmnVJqsCB8HkWJACDMNx+IN71aYOAIFDkIdr5J/i4Ngp4h1Z/8C0Gmp/P5AEJG5CideMb0xzBD6EeiTe/e+KzGm7+5SszM/F1QjVOYqflNhBemqQ2y9cEm4Kc4RsZwefBWfs9UNYRgjgYv/BnUPUdiiOXvt6RnUvTx4yDE/XwghgHV966H697SM8a9KsNBE5C+cVnn4HXMU5yxgLmFj5nrD+cOH23y7ekXyHbR9hssFxTzHA2fls3vHuXtbf6K6MYqBvNC3ognwbbSL9pWIdGJmqfgTNLatW2NBgHd9TiuhfZTWaJN/al24stDHsnqJXVYdgtL1ToCTH4qqw9AykienMjlAWFy+bg94IxIVabbs5awhIZo3q4ue1h5D4FfyQBh6xp
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(1800799024)(36860700016)(376014)(22082099003)(10067099003)(18002099003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3X94ztjuCjf0IKJ1ijOScNFPKpWxKyEw96Rl+jY+TLTRd72wY603m34mmXdO9cWIezBpeROjdj5U2tmIJoxBy5X681NhSedrhYaMM3RwdfG9zheGSoEEMI5bJxLXUQ977O1lyUYDkP/w/tWYKK4cgAe79KPaV8uJizRD0tquoENJtC/dKjdOiZrvQB4hWGABmR1Ep8rIl6eMFBUeQCab2tacLQq+jzR/AqK1u23iw+FLIchYA5c+M5HueVshUq0I5p226ruaL5XNyBlkpGPgR7u8SGLHpY/fAvas2s4Ao6hWUd4PfOK9lScfgIxwLZNNCzc96Q3mu9FzOGYhWaD962XNVjS3ZRV6Ye8RtuHfzdmV9Yh++YJdJozV6tXvQWSVqDqc+eN+Ou3lPc8AbxAs4pCezG7MfifbJIjxC8PcKPPq+0nZ47Tac6nzRa6RxSXG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:14:49.8092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b1ab84-8e72-417f-3bef-08df2a382ea3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001C1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5762

From: Ashish Kalra <ashish.kalra@amd.com>

rmpopt_init() sets up the RMPOPT workqueue and prints "RMPOPT
optimizations enabled" gated only on X86_FEATURE_RMPOPT, which is a CPUID
bit advertised independently of whether SNP is active.  On a system where
SNP is disabled in the BIOS the workqueue is allocated and the message is
printed at boot even though RMPOPT is never used (snp_enable_rmpopt() bails
out on a non-SNP host).

X86_FEATURE_SEV_SNP is resolved in bsp_determine_snp(), well before this
initcall, and is cleared when the SNP host cannot be brought up (including
SNP disabled in the BIOS).  Gate rmpopt_init() on it as well, so the setup
and the announcement only happen on an SNP host.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 43e4945e6cdf..81b9efd55c51 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -639,7 +639,8 @@ static void do_rmpopt_work(struct work_struct *work)
 
 static int __init rmpopt_init(void)
 {
-	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP) ||
+	    !cpu_feature_enabled(X86_FEATURE_RMPOPT))
 		return -ENODEV;
 
 	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
-- 
2.43.0

