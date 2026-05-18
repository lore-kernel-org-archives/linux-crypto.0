Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328439657D;
	Mon, 18 May 2026 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140556; cv=fail; b=bAXB/Y71HignW53kuGXhQsXxuejIhVcmdIlfJblNWyt6hkYCY2BDy2e3zs44xsB6atWGGZWYnHkGEHbtAwjZatvTdylqdyuWGgDTXlbOP549sX7E84vy/f7OmTpy0VBBU3PYsfd222r53NUnnNoJvxYzPrdGsd+IucKrzgfBFQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140556; c=relaxed/simple;
	bh=sDqcWaKII8p3b0bUtEF+0vM3OdtkxTPrI53Fti45BTk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMGtuFt/f+r4mPaNfHU0XqznICcXSL5Q0Fox+Aw5hRjpnd3TGBzMA52ExAOJcmL0EIV2Z5QNPvTAsAOvscYtKFi2tO2UDNUvjOathb9G4aM3lYvW3w7HLqm/BO97/Q9kT7v3tfdpfBUK9IxUHnpR/s9SQ8usi9Iw0b1ulAmDFw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hnrS1//E; arc=fail smtp.client-ip=40.107.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hnrS1//E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlCjozUVV9gcp7UwqMWNK66UNfRtaW94tDt7p0Q0Wwy3JGZBP5AU1kjwdz22cSyx46fwfZDg0FJf41mDrjZl8Co7cZkZ4GSMJo5ZKHIjsK3bdONEcgQ8goyHF4EoySbMSErQCrYzgLnMbdyaq7Ti+qsUccNNbJfn+X4EZHH+eFWhFii/tc7MJrKQqEL7BPF/IGhyI+3DOJbTjeQBZcEXt21cDG+aGvN5M2v0G12QH/tGneC0Xee6e55AN4vbKu3sEdkfAmDkuB1ph3zTbapLbBkAUiDgIXxkBDli7vo7x6fXRnGCs5H8p442pyi/dKqO7RELP+cAuAAx6LXYHIDbIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JmmRf/nL3QrCrrIVhqHcuRXy07ShGxjuAyQuXTnCak=;
 b=GAVShBb9u0frUMy+/2l9RACKSOXduN4Tu1ClOqWdS/wEVjQ8OrnEUTik4uF4OrmexmCp9328t2cNlrxc8w/e6OVBZPZkkiGpK/fWOCC0fLYUIJbgRkf941g13Zi4JgZ1ccBaM8r7YyWvi6ZzMw+uU10A5byvWGxHn8zCwt4omC/I7CEvve7smTaaMO5GwJIfWFD3Kz9LMG863WMdXU/0K9eNhj5UHvgKsNq9qADHtWiuiyAlFjaEiUoG9zFFD0MLftc0LuMGT3qveCrPI5TNnaAP+a3qg/PubbcI1ncuUbcb/kmMvliVKMk29E8+3uvQzfx4O7l4aVFWfmlbQwtuog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JmmRf/nL3QrCrrIVhqHcuRXy07ShGxjuAyQuXTnCak=;
 b=hnrS1//Ez4BEP8CSdJXkwUAPbqzxod2SczwaUOwC6khHI/ryCzWRyRtrwN8zRhCHl3hCWeQxRjGgjLZn2tM5z1vUC27KPK3RYWtjXE9oqfELbFgJLAdayBSgAcpqtY8nzwb6WdgK9oYA64THBJ3YdP1WUzVniNOwfxeAHp0bhJQ=
Received: from CH3P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::6)
 by IA1PR12MB7567.namprd12.prod.outlook.com (2603:10b6:208:42d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 21:42:26 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:1e7:cafe::3f) by CH3P221CA0015.outlook.office365.com
 (2603:10b6:610:1e7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 21:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 21:42:26 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 18 May
 2026 16:42:25 -0500
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
Subject: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
Date: Mon, 18 May 2026 21:42:15 +0000
Message-ID: <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|IA1PR12MB7567:EE_
X-MS-Office365-Filtering-Correlation-Id: 59feeffe-8436-4c67-15d8-08deb5265a94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|376014|82310400026|56012099003|22082099003|18002099003|921020|11063799003;
X-Microsoft-Antispam-Message-Info:
	zV7ATvMb6LF4ApFokEKwov9urpx1+O/CKK6l+o7K+CI1lyE/KiSZceI9NYHErEr6+swh4thkpiImnbKjDAxrBBCKvfYlRaH8JaYPUjXjJEJTgXLNvXrTZGmvJRGmDrKuq7kIaOpLujgcUBSSxjz9bw872fN+3eyOtrWknLQfXE7wmiBqCl5doTuMVzW0bUtJ+JBEMOVurVJOdNAA5cEVreMLBOMkw85ktxhFLtQUJmsW/tJFx2s1Uv62BdZ9xBohcoBffHrK5Acf2ydFb4hhcGQMMsHmmZNqcKjUjIC2K7roZKTprKMirjJZSrX+yhjjqE2UaA8dv8eHoQqMc4atlQjgkYBiUpOMDVIKx2ifRokrrcIsRArEc22/a6lf0cd2nPpJLEajmf2ig8gZlwvYzqEcdnLK8UG9hhIYW7Zc2M+zojXSab3i6N4tkYrj9w0A47UKnJ2aWTSo3YCDaR9eYG1+A5IvVQ4hyLVzuxazecuZjhoRXd/BYR6ZVhPlN+fnAuhy2M4uIEyccDXXvTGUrtneZWFw8dvwFtwuCqyZvOejnHNllIlmaAMAOGzZmo3vyhOOFH36k8LjQVtRNpC2+8RBAGqFxppLDxgVM2cQaU2Brh6uu3uCmRYmZ4ylUdwiqsF2gWdlVVRkV8CoQyHER0ifrSzdWoS5LHfDhTv6RnQTZU98kft2LKBtQfdV1VlWj2QrQVtF1Rq4deYplPHbLSkNiHovs5MVY9LWkZcyQKWZn9usGCAwk6+MYyNYgl1fMho55cHAl9ACizesOP+Fdg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(376014)(82310400026)(56012099003)(22082099003)(18002099003)(921020)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aH9H58izw5XCnqNIGFpb9wLZUPPG4BuVKG681StdcWLfShyrAWS6XeP1F05SuMgWqcz6hpFE6d0zlswf3+5fxd8ZlOgrrEuZBWt3KLSjfSs1BVdbaJuS8gDQHBhOpV3d2KfLFcp2phGLDsoXA8hf491JJca+nycyWf4842OTdN9VbjEKgHyi0oVerCNJXm0cC9zmSi+o7hVRtFT5WSjJVdYi4DAT9w53lhdTx1Y09kl3wkutHGeh37Zf4NdRDVD51N7hf0T1+Uonx0aKYH8/tQHl8HTYTiGKSWS+Hs0V2ceWc4liUO6mK+6W0rz0EP88Y3myf0dKXra/kJSU/EIOuOvzU9phdj43C9AJucRHp2WfajvCvbHM/E3zjKmasqGK/FGwXqGSvugRXjCul/sN+mHvfcVR08/b8M1M+qw39dp3DWm1UasSpF9llS4bh+aJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 21:42:26.5630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59feeffe-8436-4c67-15d8-08deb5265a94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7567

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
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
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

