Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012062.outbound.protection.outlook.com [40.107.209.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67C3313E21;
	Mon, 13 Apr 2026 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109463; cv=fail; b=VcFz9KH5ijZb1HSbJYb3++3UKyWeW913LOgC2No4jYUaFZiYay/SVQFxlXoin1i6DLYABs3OxFK+ydVkhtJBVuSSIYGbQGyJVn+6s6pIAfN+Y3rC4vQ0uNHJWzQDFAN3uQZ6vE1LXTsKRz5XZjvvOtyOmxZt+oQkdONCy5xM34E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109463; c=relaxed/simple;
	bh=esefAw/fKfyD7xUjJhCGgaA54u4MB9cpoGRoZcpH4Gw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IuL7BR4Cur4o2aoxszNqDe+d7NV7gAjoul8WzbNQh13NSbMQiYbNcsQu05ZKlIXvLz4GkiN9fCsJ6Melbd1rKacAdJu76KAnS2uia6DKFbw0ukzWVCSdiVVcURDehDS1q58FJgREIjfqEfv5OCdSWIY/HXEgsAE9BzfGe9rp0uY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KnlNlHP1; arc=fail smtp.client-ip=40.107.209.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KnlNlHP1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0bNJOjmCbRliQP/Hw9YlkqpPSXDDdqSoztFNAwyUnvRdn5eexgW8nAZOIfM21ai0uvA2m6Jv7wO1OtcEVJiM8faauFwCNJWHB+LgKEN+jM4wCsM0oOfZq8zgK1bno1hoZCKgsQQb47cSVI+hj/zbPV/BxgvnWd41wA3m7MNnfNjPY/91lD/QaY+2iVC3Fvso1MIr0mvwp8q2AUS3tZdNGuERJCsJhHDWfOfu/7pRblguF48MBJavcCm3CRCG29B3d6hjJG3cDRPOY0VIk8GLW/FLoHMdQuFFSPBinc4MxJMfR7YFKrFO3Ouef52WPc7kyRGwlA8ZhWCkjpJqjAV3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCS0wuFKJT4CFaiT5TrKnr11oPt851VL9M/IKt1TS+0=;
 b=XnpF8t93sKGKhb/ts3y+VfSGrdkGTg0Ab15c9sVMwbE8lpzJHunfUJzOgreixXLHJk6/bkcWYQI9xIWlPSqeCbu3202R8w/vbUJiX3ExIERIcgyHQROvvqb73nkM+YJyV0ZZyhFpRzhbOI1Sj5De543KZCMq0UvCgoHMH4/08xMr3FtKr6cBnN6BkwNpSI1Ivdm/wwQPNTggwePnhVQpdvQbrjNRbtsWy5An24BcNrjvbR+CTT8BROp/+7gqutc/2KxXjaS9NB6KICb04WVAQoEYXYRy1H70BH1hxqfCIRhKXJTY7jX6FzASQke4WUt7DG1q2Rei3JRqHuhVQplGNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCS0wuFKJT4CFaiT5TrKnr11oPt851VL9M/IKt1TS+0=;
 b=KnlNlHP1yRUp9dj6sLI91R+7fYDj5SxcauulaEsMqhFZ3jFgYlCeZl51wp5p2fWVcg2fvtKxE4MuzlviEwfj90emtLTWUoQupxCSSDCCHDKkz6Fdd8aKICtGqiIGVqY3dyC5IMULaO9Fy/d7ZW/t/V/UfgMqNBIGdvw/e0AhKxY=
Received: from SJ0PR03CA0039.namprd03.prod.outlook.com (2603:10b6:a03:33e::14)
 by PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.15; Mon, 13 Apr
 2026 19:44:15 +0000
Received: from SJ1PEPF00001CE0.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::3a) by SJ0PR03CA0039.outlook.office365.com
 (2603:10b6:a03:33e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Mon,
 13 Apr 2026 19:44:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE0.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Mon, 13 Apr 2026 19:44:14 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 13 Apr
 2026 14:44:13 -0500
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
Subject: [PATCH v4 5/7] x86/sev: Add interface to re-enable RMP optimizations.
Date: Mon, 13 Apr 2026 19:43:54 +0000
Message-ID: <112cc1213834de1ac97c71314a565ba7dc4af30b.1775874970.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 19e37295-66dd-4758-fca1-08de99950b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|22082099003|56012099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	GB5YokJisPlNeuFxrMgfeKw3fydykOe5SU1YiDh+W7e6f5u7kDACw/a4ihsOkpw9DJUCmK8mJbzBTHDArf4WL79Jl7W5vX07/f17UXqa2dYYnUP4EScKAsjv51YrEOrxgGrgV7cIdtQAugh55av5PML4Ocr05mpn3UPS66R4lotiSMJr6TpxxHLymkxeoPbbzE1cv0iyR/dBJhpoGWbWdXmAjWwEOKtFf64O1sK2lJP3K67ZJz71vyy7tIAqUPCH0hHD5zDUR21KExnMeHNgJ5i2GauRUpkeFSRN9wy6r0sLcNEOD9CyczVCHT8hmDrm4P+iCPMm1cvV5Q//Tj41ubQYaFiCezGOZLus/j9Q66mkQLOw+D37fJDE78/8Ila7LnVV6wMJc2AULuYr/sXsaZrEoP61t+SiIOYBGaV+s+dXDalTgvEhc+12N50BkU6W3J0GHASgrI4BGDWuHJXjGTStD5JmczPC1avz/uhdGpYsP3N9NWJBMArIYQ0Qf5V5QAZchbiiWcaDbirb+G4Elx14g3bkGcuFskuhQT0DYepfeSFklo0+eZsKW73p67OClhHL4yYpCgVYAH+fQlRXJBQKubQoz6+OjXi6wHKM4Q64latL35hlxWF/pgr2cqlyrCRWmuWVWG8lQW1oVxFAkLDXpSQ6z1u+89CUuwhjaigKdgos5U+/Y9nw/+bggERRBXHLdlhBDLtaleY2sC7qOxnaNwGCm2Ff0TdfIQLTRLdkf3JtDL89ndS4EdFmCtXeWBqqhIARjU4d1x8fZLHpjb6r0Uj8CiqTuhlJzVTNtHAXFLdgn5DN73inb953mqzM
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(22082099003)(56012099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8cUp9mXifQnE6v7Z/E2XhT55NSLv9+urypM9IiA4bumka4YWYX0xGUCtQavhzW7prw6QShcsPpIyAf1kUwkM225u68/v7aghUKwM+mKM6by7k+DI8UcKRr0Lse3enRx37LdY5k/Ot/PFmHk618jedzEzdm/JbI8F5YB00rXeFewgh7Nyw04kLurWcPiCpx5ltby/t0cgYGk2DTn+5IdxSmalcE9FXzv81fgL75Xgs5nfCubaHDd/SN1jc2Yp/yT1KwojFItbcRvWfthYa+fTqJZ2mL92g6PjYvfy5EWeZpeobkubfjXIdPw+YuwjY6mstyCy70nglgyBZwZ3ZbPkpIgT/9wChsluKSh6Guj031HeRsJujfqb+q/yBd7fgq4e0SVwbZlJ5k4khyLwvSCHls+AR0QqDB29jihBAPc5Ham9pqhn1lRwNh8b4ej3NKD8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:44:14.9296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e37295-66dd-4758-fca1-08de99950b39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-CPU table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Events such as RMPUPDATE can clear RMP optimizations. Add an interface
to re-enable those optimizations.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 409ab3372f7c..dc9086057060 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 void snp_prepare(void);
+void snp_rmpopt_all_physmem(void);
 void snp_setup_rmpopt(void);
 void snp_shutdown(void);
 #else
@@ -681,6 +682,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline void snp_prepare(void) {}
+static inline void snp_rmpopt_all_physmem(void) {}
 static inline void snp_setup_rmpopt(void) {}
 static inline void snp_shutdown(void) {}
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 56c9fc3fe53a..74ba8ec9de35 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -648,6 +648,16 @@ static void rmpopt_work_handler(struct work_struct *work)
 		cpumask_set_cpu(smp_processor_id(), &rmpopt_cpumask);
 }
 
+void snp_rmpopt_all_physmem(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return;
+
+	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
+			   msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
+}
+EXPORT_SYMBOL_GPL(snp_rmpopt_all_physmem);
+
 void snp_setup_rmpopt(void)
 {
 	u64 rmpopt_base;
-- 
2.43.0

