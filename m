Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010070.outbound.protection.outlook.com [52.101.61.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FB452BE3D;
	Tue, 13 Oct 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791906306; cv=fail; b=DQz/CGkV6nEwt3VzLL8OIN616oq+Y674R7CfnYa0b4mjKh4n6+Uv9w3+uChyk5fhHaZk1zICoHFs6mg2DpeomhwID3fzPvprs8cDp5h3hHyQKOJN7XDI7TbFFUzu5Q6zjLlpIAIlPjQ+YGA8kGhJqM1px/eeasdnXyCI72SI8sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791906306; c=relaxed/simple;
	bh=Jd2lk+SMDM0YzvFo9PkJoNt94FgrL8PPudgFAp7RpTg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATfy745leS9LSJlu+WD+F7l0EAPUg+AG5vo+E3xMjzkHLiTBm7qMNLABPXQ6loRLQz/9X+zQIbEjZT+OVkGmA2mAaSJdtsua60j9UvRx4IYRanVdykdlO1AI5ng6aJ/gBZUjCe7RoMRrZqqWyyD9iCpXYp1qLGNqpKj0t1NpZxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VDtsWh9i; arc=fail smtp.client-ip=52.101.61.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VDtsWh9i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfnVcOmYnzKn4t6TrNNxM3e5C6XjZlPqCCNweegkIywegltP+A2c4bC9h9kXv3YHSk0bwqoQjdsUoGMP/Szd3f3TIzg042MAegClTPhLr0d6Bokarx7zsz4IcSDHjpWRlk1Kk3r5L+fty5iq3tovMwUMez0eoP4mYxe5QkjpHv8ImI+gPryJbd8/ex4hjiHGpEn0DoDPOW5tRDrJDEv/fziZw2Ek4AtSSDgh+jyXIhK0CN9rDtiXrUMA2n0HyVARUibGYFsk7tQcHfjD6c5kge0J5uBP6GO2SaI296FtkzAaIRaHTVjCptlmTgt0FDbyhgAPpSsxXWiR2f0SvmpPsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8iG4TSJpyaTX7Xug0cSr0jQl18/kTXSpgIy9yry9zo=;
 b=HhQ24HlFV4AxdMbg8NPxI/AjDVjxuZcn4qJ08Nyrcmj84zng63pw2TCQpCxD4cMyW5yBhZ7vRJf+ZN6LWTJGXyyM6GZxBSsnjA4vb0OB0D59JfwFnx40J7Tm5qXcp1MIcvUYnm2XKttcglgahZvJKojW+YhNXmVioTj78ydusMkVNd4x9vqsCnue4tjhozbJO6aL7I5pSA7aGZQlR13pEhB59nnWCWWlDNPpJjUL6aQDdD8iovpJneZM4JZ/yeqNKHfHyN4eEstTGb/YSaMOcBcSC+/mQPBYlRqeZsTTfojFea4yECYkCCDQfei9KaF2yKWfD1DFniRbWg4n8+yueQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8iG4TSJpyaTX7Xug0cSr0jQl18/kTXSpgIy9yry9zo=;
 b=VDtsWh9ioAzezSvufc3dtDZnsFwoA8ODCLyBbFLf41IgmMrrH7ul8tVvZFKjQMcPBoD/Ar+PbUgutmWMHn4b5wH+IgteJDdXLKHxq3QdeTWD4ScAnQOpruEo8MJyekPE0jrFMQBcizm/W59wSIbl8tsyU7NRblkpnUYqx9V4H3Q=
Received: from DS7PR03CA0148.namprd03.prod.outlook.com (2603:10b6:5:3b4::33)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Tue, 13 Oct
 2026 15:44:30 +0000
Received: from DS8PEPF000000E3.namprd05.prod.outlook.com
 (2603:10b6:5:3b4:cafe::60) by DS7PR03CA0148.outlook.office365.com
 (2603:10b6:5:3b4::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 15:44:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS8PEPF000000E3.mail.protection.outlook.com (10.167.23.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 13 Oct 2026 15:44:30 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 13 Oct
 2026 10:44:23 -0500
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
Subject: [PATCH 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
Date: Tue, 13 Oct 2026 15:44:18 +0000
Message-ID: <24ec806222fb8cda660269d3360780687403d150.1791905953.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791905953.git.ashish.kalra@amd.com>
References: <cover.1791905953.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS8PEPF000000E3:EE_|DM6PR12MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c445512-664e-447c-7218-08df2940dedc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|7416014|1800799024|36860700016|6133799003|18002099003|22082099003|10067099003|3023799007|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	J89OOIi1uXWxMFCIFTiuktWwRV+MLngZDbxJdiRPLJ5Zw9AO2RcSjY4ShucIBMqPXpcooccvkt0qRWzfC6AF4FVire2C/ORWVY3KH6Lx3s95th23wM57XP3bDZQU084NE6LLSs1It9KDwaiw5/2AkbCvNziz+fhyU6TRMoVOQenTQBL2z2wHVlaNPHwIP0EyytXLkjerhqqWtfRWSVbf07dtpowvidJO6QuFADnYcagr1RAEI/15PDBiXR8FJnmSNUhmlGVS9o/8ASASArPb2J9Hxg0FEqeKMW9OSz3tTq/ZTA6W+8yHZcgQlVF8Db6QInY4H7ZaUl75cd2ypWc8nqVzZZwRegwS9taXc9Qn7SoR+XbfoS/Ymf32M904TjvqJPYcnl3Ck/VAT59tVMr+S88md9jF2+q/Spxfa0+SuJF5odzYHXxeUbHLyoh3snaiXXOxA3Vd3mX5Jpa2gQrZdtjpFZCdNMy/v/FJS+TSQeisFnKMu8lnoldKU3axR8ClqTyljBCEpiaAy5Jd+3RhfwQ58V05FOU3A6bCKgg4NG9ULc60nJifCxcsKPhu8G5JfX/qi9tqzQsZsdX1cxNpWKCYcclQmDdWZHLi+WEs4IicBcW5gtmwxfTnZqYc8L1WPhBprSlNjqVWcv8BzmdU+XqrtN/3r77wfbTc2gE0vB29jc2Yb6vrYT8kURb2r29hVQ4pssf35Uv57z0/ixysBr0G6X2ulWyu/1lHvf3vNomBZGrh3OynVwcfnVxLg5BC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(7416014)(1800799024)(36860700016)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Uw68+Efjk375HPuazSGXs70siNi08XvzRAAGO5ES5nZ9IyVZrx1yJHGYx9Gwu84i5fci4I/0fRDFAm3ex0JMCCkFt23pCmG/uqG4q067r24pwLXRJ54+Cj1Eo6vCck5Sy2QxJtLEgtGSaQcaK0vXA8GIq9tZOFOhKmMm9vak0Mk8mvWSd/3XM3MxOAHnbC9mMHN5nm6VvB0dvGj5WRKOjCv6hiGBrMGMIeQ1E7gnZRkaVy1NbvoGZjwcjbKTwz5QIFGhidkDCLrbmS+/pHZ+lsfMBnO3solTLY+ToCpS5w4bDNuwRh+Z2BAwRZRbstz4+TT8+eZHQ6iPyXQVKNnHKf0pNuT68hJpkH/26LVNTXZJ7OhbwR/bc+U94RGwIDElMKnIe/bCpb2wVhm96NprNfUlHPWcUnFD0+r9pEVDiBxFx4SMHwwRrlIZdH2OyrPO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 15:44:30.2739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c445512-664e-447c-7218-08df2940dedc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS8PEPF000000E3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265

From: Ashish Kalra <ashish.kalra@amd.com>

snp_probe_rmptable_info() only clears X86_FEATURE_RMPOPT when the platform
does not advertise X86_FEATURE_SEGMENTED_RMP, or when the segmented RMP
table probe fails.  It misses the case where the platform advertises
segmented RMP but the firmware has it disabled (MSR_AMD64_RMP_CFG's
SEG_RMP_ENABLED bit is clear), so the system runs with a contiguous RMP:
that path falls through to the contiguous probe with X86_FEATURE_RMPOPT
still set.

X86_FEATURE_RMPOPT is a CPUID bit advertised independently of whether
segmented RMP is enabled, but RMPOPT requires an enabled segmented RMP.
With the capability left set, the RMPOPT initcall programs RMPOPT_BASE and
issues the RMPOPT instruction, both of which #GP on a contiguous RMP:

  unchecked MSR access error: WRMSR to 0xc0010139 ...
  general protection fault ... snp_enable_rmpopt

Clear X86_FEATURE_RMPOPT on the common contiguous fall-through so it covers
both "segmented RMP not supported" and "segmented RMP supported but
disabled by firmware".  The clear runs at BSP init before alternatives, so
the subsequent cpu_feature_enabled(X86_FEATURE_RMPOPT) checks observe it.

Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---

Note: this restores the snp_probe_rmptable_info() structure from the
posted series (v16 3/5), where a single setup_clear_cpu_cap() on the
common contiguous fall-through covered the "SEGMENTED_RMP advertised but
disabled by firmware" case (called out in the v16 cover letter).  When
applied, 15d974be0a3b narrowed that clear into an else branch and dropped
that case.
 arch/x86/virt/svm/sev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd70c4d0b774..43e4945e6cdf 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -827,10 +827,16 @@ bool snp_probe_rmptable_info(void)
 			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 			return false;
 		}
-	} else {
-		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 	}
 
+	/*
+	 * Segmented RMP is either not supported on the platform or is
+	 * disabled by the firmware.  RMPOPT is not supported without
+	 * segmented RMP, so drop the capability before it reaches the
+	 * initcall and faults programming RMPOPT_BASE / issuing RMPOPT.
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+
 	return probe_contiguous_rmptable_info();
 }
 
-- 
2.43.0

