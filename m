Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC933793BF;
	Mon, 10 Aug 2026 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786389700; cv=fail; b=aeng+65ZllQpFPUw86ldWC+1qHS1LkphIZlvLa20cJjaidPyXbgLnstG2cvObxCVKPFHLgAKLOksEjGq2hvo+VWBXYNIjaMr41CpLVaUfXO0zE3qYun5OB3V1JghIdCpxMi3/EG8ohqhGW42dmlSYpVCX+PHeRYNDwE2hi7aejs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786389700; c=relaxed/simple;
	bh=qvWNai0ES7mTf7ZvjBPYqi8697xHSnfL4pgSt/GPAbs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNATluNWdKLKt+38dzk2ZhmhiLX7HMDmXNAz21l83ayq5bpyeux2akFORwxivqF6jW7mRhezQD9TvBJvVdJhdDfzq4a5ebrw81tvZLn6KwjqustbuCXYsfNLxPeMTTC9f0GygE//OFl/6ofBgmndVG1b51peJIvJcL4B6w8JIL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TUWOq+o5; arc=fail smtp.client-ip=40.93.196.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TUWOq+o5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgcTLKOqyc6vfj4BtIulbJ0KuqvJKrkV9UX6dwVApkZARhI0kgDGx2jlgm7LJiRjtM3WmZbmtrCVSzxbgf7H7VWdbZNP9Z4UPLLQHYIW8IF6yfHB0cb136/0oIPMHZMv23JyZTOPtjGmmKC2E3l6XjzHSv3v9yWe2ow8G38MU7D3IGybTzzoctXj3+VO1nVuibTU8YGt+4saVfacQmjfnj/c/07Fs74W0vHKur0CGq75NLNnugrTk6ZFSBzUGZ4sskJ9AsH7dICwOgLYKEIo2V8yWAERN55+HlL8TzpJDUCGzAsngfvoOA2pRH1AKylJlU5gaiGFpDhmH6Kedz575Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45qC+C/BLdjKkN1+fwWDM9N7hCT53EoYkRbcO57HcZM=;
 b=pw6cww3Qy2F6Ak37dZQ1qvZ5YALqqHE9iaMfIa99CAFFZCeV834ZZVYw2uF/ywX3YXiUBizw4h4Kw5CHycICMLD3W8+fSfGk1IpVZgZn/bfLX2k+xm3fs3lAl/YIJOQztujOLC9AA4f4fBYXzJlMmvZ9hBHGwCw39GKJMdQ5m0LjJyA00LCKz+bqiH+RElggbo2AMsL5+bj40klpBVW7/6OqVaW6UcGlEByEG6tsSnPJ+RebZcBRQCJ+MhakoWCfyueniOFwxVQjwJTOjgY4r0J1WFDuDEI0JU87EyxZyNQ6iNs5NGU0WGdY8KiN2CQzyG+spnIffV+qwB1NRAxyaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45qC+C/BLdjKkN1+fwWDM9N7hCT53EoYkRbcO57HcZM=;
 b=TUWOq+o5YZECb5614m7pHHO2+CAzcp8GJiEhdmKixESYc0aqLodmWnXed8YounwKdknw8/ZUorttlNhahfrLywp2oQTpxuuRGe1/0bM+/wrrZ7CF3EdmD6yaNOoaGyGDm6ldaTH+oC4YPR+4zKcion91rrUgfZc16Y0OaDqMpcc=
Received: from DS1P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:242::12) by
 SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 19:21:29 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:8:242:cafe::5c) by DS1P221CA0021.outlook.office365.com
 (2603:10b6:8:242::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 19:21:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 19:21:29 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 14:21:27 -0500
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
Subject: [PATCH v12 1/5] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
Date: Mon, 10 Aug 2026 19:21:17 +0000
Message-ID: <780266f690d89e32f911296b9b88d9f84d8c1796.1786389115.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: d264f53e-bfdd-4c6d-c8d3-08def7149460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700016|23010399003|22082099003|18002099003|11063799006|56012099006|3023799007|13003099007|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	sC0j54R/L+0WspVzRIjIdIk+g2GgcF/l+1F2Uick+Cjts1DcFPBMS2E7Gei41HMgfLil8hZLnmu4m935705qDSR5DRLdN5OLvUVQEUXe0EMdZ5tmqdyU2UPYsU82o26Qi76fci2Dwsias94QtAxlfPH8hdk30ldLw493A2KA32MAs/lVByI8yeQO1k3v/d/IWWSCDHGvBclEoH0v+6jNF/rfm82tUQBYFPo3PCvlNR9w55fv/iJintw301gpO+nNQvYAhJQrU4zWcW3I27ldJqAtskPUxiwPEC3hL9stUvC+4Jw9gvtmP2HCYXEaruHUVtXzZzppj/f6f69F5lq2YV3fQYJvOO3s9mkAJtLUZU2ocAJtn4w3gc1j/4vjF1V46SHcE75lW+DlJ9rEWpQZyhv8hptQFE7eyw9fJorqyN7y+y2O7sKvybDpuLxQqxfN/DDKS0jQZqFD1rYnr62kVdCEDsz4XnDscq5Y56sZ8XjZCnsV57ytfMddyH1kvavFrsrTbX1mK8BNsLdqGZG1TQ3IAx3AJadZBrO07nlt9V+3IB2np1H7jOgJ5W3U6nb+2y+VSAG5uhlsWyDCa4rKM+fXY01XNHmxGgBWgjuY/kl2ORYGaA1zIQ6YnyoaISYJ5I0LukPq/PtXwAedMpYRp8z8KHgeQXKWFQY3VplN8Yb/owx1f+AKe2dHzNyRO96JFsbeI+Kl6877F9NoOPpatA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700016)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(3023799007)(13003099007)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zu7hsjYlCk+5W2sXvkRC2LjZDakq0TanIb5ig1W/3UGcyn9Z1zmE3RhZQzpWHgzPyUPT4p+FJlqJyD4fF/RRqql+b02+SItH4vd5GiPeGVAPuiVtk0J0DhxE+yyC2QiB2SE9bxoADbWmYPNhhXhAKQAbcRx+SYP+vlmO8M9AFjRHnQTELJP4P0W3XUJAyXYDQkDqRlG2mka7kROHj/Kotw2UEe7RLmuhpvIALR0zyryQy4k/ebxb3TKLi10I/Ze6g9v9HdUC0e1qk3sAVuIhbf+JECwTOdcAN9wmn8YkpCvi3PScFM67lsRw20cmVucVmt1RtNYZUcuPf3QCWCvXvCx4byMKhL4tFjeglkxOk5Cj2G21zeyTv/oQNbMaxWbGfqIbaWH6L/Z2nlBhUpjwY4TGNlQ7o/AfW3jMQUZ7K3V7ab8E+NQ7Ib+bcYqpSAsd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 19:21:29.3231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d264f53e-bfdd-4c6d-c8d3-08def7149460
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction that reduces the performance overhead of RMP
checks for the hypervisor and non-SNP guests by allowing those checks to be
skipped when 1-GB memory regions are known to contain no SEV-SNP guest memory.

For more information on the RMPOPT instruction, see the AMD64 RMPOPT
technical documentation.

  [ bp: Zap respective tools/ change. ]

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/39e9ee269a572c516a3f4e937bfe12d00697d5e6.1782841284.git.ashish.kalra@amd.com
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 3d0940a3b9f3..dbccde9ee5cd 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 /* free: was #define X86_FEATURE_UP	( 3*32+ 9) * "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 937129ce6a96..021c0bf22de2 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -67,6 +67,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
+	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
 	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
-- 
2.43.0

