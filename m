Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE1313E21;
	Mon, 13 Apr 2026 19:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109396; cv=fail; b=P60SUzl8QOjMp5OWNxSqkXARFcuw2rpAFJG+FZNpg9YZIvveupe7jNu+93uj197F2n5tRnajbd2rHCAsGefMJwUhDDneQ7jJM/Cc9/ZDHA9AyehsaV/cjmTNyRRjmpWlYflCDpevUwjB2vZPxwbwtZg+hC8Jsz72xrCiOGjZ8+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109396; c=relaxed/simple;
	bh=qg9+V2dlEbexBTcbrjqix9LnfwORGCUEVGTRLVXhZh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXP4Q98rAT7DaWBqMpMXC7gwmSLGNxWwTmA0+jzGzxJ4dnUHQaApFvth/dFAlXBUpaoUhlrZNe+fUpCdfXY8Ad/hYpQg96N16xts+aKuFS5U/ynxgaB7q9DTDG0+e4NWF2IkuhT3M1EEsNmFIaK/IxO5hDkXN0FsESpCkyo8WLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iu5fipDw; arc=fail smtp.client-ip=40.107.208.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iu5fipDw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gte4mBnvPWFEsxdTC3yYEc6OqnnrjRWQlnesQGzQUXuPZ3nv3UtPpQRaO3vDAvqvcmSjUfe8Y6mQ3hgncvMtgHGnATLEeEJgGpOJBGof4B/1C2r78yjy4ubnsFXHKo1uLw7P1PNFkFDr14KqNeTubHGGhcpwE8LB74DgTnGqzSe2jsofXJOILZAJHR5DPRci+iq89HTEWZfazeWNg8NhK0LMdEn5qxQqfYKeLY5qNcn4MSmFAhS0frLSQI8w4Sp0hQOVvxeptOlDWtDBA6SgBaxDMthhSzZm2you1j6j+PzbAzdnD77eXTQwCy0o6cHtuwPDsMToLzUu9WhexKx7+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pirRFT48mPpvqu9+IfjzGihheKum364nT/2oVtzuxn8=;
 b=ST/tJeXGNtxJSQt2v+NqOZOrkrPI3rNEHs+NQPNjZSiUaOM/hk10uqOdJVmbqTr4cImVpOvVbzKykgfB7f1ZezBc84EaKxRxJ/dBWZuHXZ1WBnnPXWoGitq8XxO5OrrU7kftT6UCNMqmG9IDxI/VlprAKWXfAkjBw0ByWw6spE6Mc0/ygoL5MIEruLZsgGib6ZIW+86g9V+bhxCsdBMiCCbSijfAzmY+2NjbkcSAyxdBmPSzZvpNbb3uwwCXHHF0OdxFz26YFUtgF2BcHMvvpwPhRMl02h+GOhHsdbqPGURflSq4oM/sXiJIvgVskuwOUf1xRHvTvatJf6kqwCcg/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pirRFT48mPpvqu9+IfjzGihheKum364nT/2oVtzuxn8=;
 b=iu5fipDwuI83sTdTUuY17YBUAGqy6PyerKuhahOcd8lCs3lQhkf3icm7ORDlpJvp/Z3TDvuXH7fYDyMu81Vv2PkHlhqA1S88eI72o19JJeMRlYaEJ1VjIj2pD1k4+AC+sQL5ucUCd8V2R0XIUD6LV08IP2cqFnyUkVAagoX0LpM=
Received: from PH8PR02CA0044.namprd02.prod.outlook.com (2603:10b6:510:2da::9)
 by SA1PR12MB7412.namprd12.prod.outlook.com (2603:10b6:806:2b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 19:43:08 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:510:2da:cafe::6b) by PH8PR02CA0044.outlook.office365.com
 (2603:10b6:510:2da::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:43:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:43:08 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:43:05 -0500
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
Subject: [PATCH v4 2/7] x86/msr: add wrmsrq_on_cpus helper
Date: Mon, 13 Apr 2026 19:42:41 +0000
Message-ID: <662ddafc74fa90be6fdf7dba09bccc53f821f328.1775874970.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|SA1PR12MB7412:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aa0cd15-9479-422c-ac4b-08de9994e37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fKqxc6p2yaSDJ8e/xGL7q9K8W8cjY3ljckF/EHA0mxwGg+b1aKBVktX/vZ9ETfE8I0TDF7pBEho9cu4Xxt3cUAYV7T9mb78gHWO0opD5iY5kxae5GpddWn07T+c+6OuC4uQjIU3OytTAlCEdebUhWIOE/ayW7ilPfG7N3BpBuKAhXAWvPMsmxO0wr9e3ezGLx7TWyr8H6B6XKJgejyFvqMhHgIygzcStOleoCXvwTy25dwpHSlB0D48bt8XzPpp98n+CF8X2mHKwEXe0a87UxzPmShiJgJ7Zuw5Gx6tZCvEkjo9XXAw8E2q28iNg7jAF3iovNCdxWowTs6+C7W0t/FdASxxmMa6mL+8q+lfIR8n2xU2BhCq7OPzUlF82ehTY/OAqshCDQoNOIxmZFmaFFfHvuqBHh/NCkUbeyG2J5doNVV+pVVFoMdid04fBvi26Q5NgIPYzv+7eOmtPOcIjSqBW5PWA0/stp8gg6d1jpVLST1SnNRnUpysfKJH0M7pNnrxblnIwT2UzciM0yqaTIEi57bOkMpXGSf4mnM2gDSoGOHlZkJ0Er910ZDq2QOGFtuIgN87P1zNt6zWGMeCWbyYCa6+gxXs0WanePV8nT/l5hg8AZV9+vDTszC5g71bYezyuCZxaaf7TefwGicJdjIwAw7zzjRe8FWhh60wJgvv1KCOa/XCCkZHJpPH28JvfOePS/xpqyi4Kk0dbfLIobNzLfsRq0LIclv+43+ePb3yEwW+c9iTWRU1Q5O9d6m1RurTv0dKZsgQgdJSmM63aOpcWa9l3d0JClj8At6p1L2BnCACvJ47b3L26lwjXQcF4
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HBbPw4tr9ZjkVcSqy95nO36Txdo5PfjkLbJHclanm32YGXPdFoIR+YPMUlRUor6jlfccpZ4CzSySsJJCvZCfi11vAwdOvhosfaEJOixYBMAsB6Cs74gYhhGDNOp5fwX62OitN6NhuM65FG/dCy/7q9RbF7vNUcIXsXBaAZKiYFiUuhvpxwD91tgAw87Wgah7RPkdy8p8VmWb2EeirBodcaSSY+qaKX8O7B+Fwxq1vMZFKo6fMCtH6sItOUMBXmh39gIf6yWFGxzYBRLH6UxkcmdXMY1n1Q5v393bmcTIFGW+3DdHPnYuc+maTMPh8O9o0ugtp7gBEPzimlOcsVy16viS5PLcYcyhQNHtBVzs1Khfjkkhi0OM4NggMhc9NBaIkIblWjp2/jSHCm7oo/oiwO0pxIcjdBnLsmWSVQ5/oTiQngeY1jq3/fV6VFWezKrM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:43:08.3212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa0cd15-9479-422c-ac4b-08de9994e37a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7412

From: Ashish Kalra <ashish.kalra@amd.com>

The existing wrmsr_on_cpus() takes a per-cpu struct msr array, requiring
callers to allocate and populate per-cpu storage even when every CPU
receives the same value. This is unnecessary overhead for the common
case of writing a single uniform u64 to a per-CPU MSR across multiple
CPUs.

Add wrmsrq_on_cpus() which writes the same u64 value to the specified
MSR on all CPUs in the given cpumask.

Co-developed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/msr.h |  5 +++++
 arch/x86/lib/msr-smp.c     | 20 ++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9c2ea29e12a9..f5f63b4115c8 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -260,6 +260,7 @@ int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 *q);
 int wrmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 q);
+void wrmsrq_on_cpus(const struct cpumask *mask, u32 msr_no, u64 q);
 void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr __percpu *msrs);
 void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr __percpu *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
@@ -289,6 +290,10 @@ static inline int wrmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
 	wrmsrq(msr_no, q);
 	return 0;
 }
+static inline void wrmsrq_on_cpus(const struct cpumask *mask, u32 msr_no, u64 q)
+{
+	wrmsrq_on_cpu(0, msr_no, q);
+}
 static inline void rdmsr_on_cpus(const struct cpumask *m, u32 msr_no,
 				struct msr __percpu *msrs)
 {
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
index b8f63419e6ae..d2c91c9bb47b 100644
--- a/arch/x86/lib/msr-smp.c
+++ b/arch/x86/lib/msr-smp.c
@@ -94,6 +94,26 @@ int wrmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
 }
 EXPORT_SYMBOL(wrmsrq_on_cpu);
 
+void wrmsrq_on_cpus(const struct cpumask *mask, u32 msr_no, u64 q)
+{
+	struct msr_info rv;
+	int this_cpu;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.q = q;
+
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		__wrmsr_on_cpu(&rv);
+
+	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
+	put_cpu();
+}
+EXPORT_SYMBOL(wrmsrq_on_cpus);
+
 static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
 			    struct msr __percpu *msrs,
 			    void (*msr_func) (void *info))
-- 
2.43.0

