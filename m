Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F73E6DE7;
	Wed, 14 Oct 2026 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012479; cv=fail; b=m1FcIzaCefA0Pu9nIfdqQLqnWoN/YS/OM9t110q2cq1MMQZCxRpRMNRqAuTqeqrwH2opsjh0GTXQXH3wKIB/uOXOg5ZEen1xhIPQcPoPixVBggrGt8QE/aMOe7y5NCqbTG6zWtQVtWwnvdphDLzuUB6U+Z3+L7oq1UYBLuA1eGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012479; c=relaxed/simple;
	bh=nq3KMJ+dTEPeDUCdp8kTiHPWiFzxfsDkcYQRnOvgYpU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MEbgPb4/3gnNMCOq6gyOw8aVWdHR795Zkx8Y1wbxAFu630EUTbFnosRWYc/HpPvu8yhh3+pMJHnuX+UnSCkWNGyIRuBKUDcM42svCrE7ebYs+M/GhvHf3qVBaIQG51a06Ul2LksqihnNPsvwBeOix5SEO3fE1BNUO6CBFND7TAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sr3u+K3T; arc=fail smtp.client-ip=40.107.208.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sr3u+K3T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M70eXM3NkNieiPH0GoIIRmytnEr/UjIIE790PgN6AAx1VdAkGFXwEuPTKozCub8sdD+Pg/lN22MucnRUle71Q7jpGenf/+oYr9NANW1W6uetIV6UMQ3GT0//Do/csevyxcoM9GNJwBpbBVAAkj2LwpHcbvUpHdogIHRMgv6OVKiXTQZvqhmIE5zsPZU1YOxurqpbWsvWL/7lHkHxfPwZKjfcolHNf6oJEHuzWvgk/dl0nm7ElbfF03Yae3f++kfTcfpjSnoBfbm5kLOZmFk2ebBW/3+GhZyihRj+r7IJU4eIRScXrPxjI7TIoXMtTBEWOIBo3NOU+FeH1TgMZSWquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YMFrjD0uGhWDdx2lMpVT5JUBMge1OddG0L19mwdSx0=;
 b=rZgMej1fIN3RAdHpPg79zCEcwBDLMBx7WZDSShT+kVvU3bIgavBy8DEpA28vd4DJlJujoH0dNX72oKOtiGmG9yqQK9EtuzSLwKgzPrc/rnrpoyoX72YAV0M5PqgIeTbuprazg4owh563RfHXhsxyi9qY7UgKROA0bIE3b0oGLSEp1Mz3l8MFEq62zdLD1aWWEBmjssulrMgWzWyeX1V0CRt7QLBsKmIpZ2hsH+XO7L5/vr3HoUNRiqKOenjaM6Bp5aJUK/lQS1JxIj7BZmROGpxyNDaHpNbgqPqD/HyaJRRe7c9gvk3NaREMUZVP9qIy5v5OnuqnEu3IdNn0s+i7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YMFrjD0uGhWDdx2lMpVT5JUBMge1OddG0L19mwdSx0=;
 b=sr3u+K3TaotntURM+8cgut6O4ExT+pwKqaHpQ+ZwP1HyV9XLHPYmB1JH3gg/BTYBN0VmhUrW2ANK05ZTmOuDxa0eTNITP022dBvX7Pn+8OWDr0tRtfpKdQZkHZQp8oxK3yB0cHgmw++cpaRCnaWMvbIdXk3p7pQaShuL0QxDayI=
Received: from DS1PR07CA0025.namprd07.prod.outlook.com (2603:10b6:8:44d::9) by
 DS0PR12MB999081.namprd12.prod.outlook.com (2603:10b6:8:2ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 21:14:33 +0000
Received: from DS4PEPF000001C0.namprd21.prod.outlook.com
 (2603:10b6:8:44d:cafe::5e) by DS1PR07CA0025.outlook.office365.com
 (2603:10b6:8:44d::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 21:14:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS4PEPF000001C0.mail.protection.outlook.com (10.167.23.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.3 via Frontend Transport; Wed, 14 Oct 2026 21:14:33 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 16:14:25 -0500
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
Subject: [PATCH v2 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
Date: Wed, 14 Oct 2026 21:14:22 +0000
Message-ID: <c8f9022fab27f4adc73ad09a9eb84257621c60a2.1792011434.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS4PEPF000001C0:EE_|DS0PR12MB999081:EE_
X-MS-Office365-Filtering-Correlation-Id: 66156df6-ec9c-4333-185f-08df2a3824b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|376014|7416014|82310400026|921020|56012099006|11063799006|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	yAdZ0AJWm5XnYb4/hsKrx1WvKQTU/A5PSlgygpdVMNZwxA6El42DExHO074B1G1akNftnGPrX628ui/TDNN4dZ1O+4OoDMb/m0Wgmkfyb+dN1dfpcpBcxPdzA1B2ZrpqDnjT55jQ8fS9I7axlXRWXTEE23wWRtYTpfw21f7wDk9jkEAjgv8BbNa/3D92smmVmXMgSvxYJHVuRXUMnhbHZ9pESt9CFl+Dx9E91vaarvWXJ+GcJ3jbRdXR2t0m4Gd7dJDmweT57I9VXp49h6p1yWFshe8sJrYVUDEFCOMRNtiU9sM+ACrocmkdltFtimvl+oNi1OIyYgwaFASkyx7XpQZdNfyQQr+XfAU+8e4lBjzcXw4oE4DDkZy6AoWh0QyrKNoxjkyYErrsLUvVglPHZM+LVf2Ums5CyqmoohPJEQ+Pq7tQw+KubT32fjdYPxcT0I2D4G9jwRogoXUjEHEeutguDwfo2j0uS2oPsHRuAY8GYST4u2TTDb+TqP5moRK4g4uql+AbqPcUiHmHvb89pJrPF/7dAcrEeDSIeGULIqFv0k54GjQPVU114WH06dyQFhewrLIOaUStVUskl3uCd/sA03lHbd4Qw1B5bEuREs7njen0h26WgZdOoIDP9NgbbeKBWgPr0lbaPdAdbLx6Ki1qXSlZxdf+KvR31Lmf90vg9Jpjy9REjSCgOv6jOtMh2DGMaZHhzg0Ga/Df5T9C5yN0QrXR0M3TWLN1gsALTomK5L0mfNtBACO+ZjfnETUo
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(376014)(7416014)(82310400026)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ti/XhAesUeMN4F1mnBr06Dpw0U9C/d7LeTDdv4mR+dNtfeKPxIy7ntGAqtjtBn2UnYg8r5lpZh24Qygh2YoJAJTrYUgmYZx8cjrFfgjgPJOPQY79xmCclfXH2MfnWVYuXDd19F8gy1yQ79f7LhBSqkIXrpMXpyWGD9VycI0rTooAnkIxBd64hx9rRcfxiVXdgVuLpFRZZHi5dj9fSTm4rAyzS+RU+XoacU7iUlS7TsiUMHxyAV2C+CtAZsypiiyKe8DCl356BQsJA0VSh4KVPa4kf6U9EOpoetC4ibkMOZel40C7nvBzmMoRFoNv+JZteulkfnNeU8YZu6PvoEcowem5E+ei1hQl18iTK5fEJDQz+ewDB997Gl6x7sTcLdzA3i3xK1EljemTTUJjwX/zgLfJECC7xhhXh9IMBSkzzXJHeNPu2DvaQ6ugvYm/5KHi
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:14:33.1692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66156df6-ec9c-4333-185f-08df2a3824b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001C0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999081

From: Ashish Kalra <ashish.kalra@amd.com>

Segmented RMP has two independent states: the CPU *advertises* support via
the X86_FEATURE_SEGMENTED_RMP CPUID bit, and the firmware *enables* it via
MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED].  A platform can advertise segmented RMP
(CPUID bit set) while the firmware leaves it disabled (SEG_RMP_ENABLED
clear) -- e.g. through a BIOS option to disable Segmented RMP -- in which
case the system runs with a contiguous RMP.

snp_probe_rmptable_info() clears X86_FEATURE_RMPOPT only when the CPU does
not advertise segmented RMP, or when the segmented RMP table probe fails.
It misses the advertised-but-firmware-disabled case: that path falls
through to the contiguous probe with X86_FEATURE_RMPOPT still set.

X86_FEATURE_RMPOPT is a CPUID bit advertised independently of whether
segmented RMP is enabled, but RMPOPT requires an enabled segmented RMP.
With the capability left set, the RMPOPT initcall programs RMPOPT_BASE and
issues the RMPOPT instruction, both of which #GP on a contiguous RMP:

  unchecked MSR access error: WRMSR to 0xc0010139 ...
  general protection fault ... snp_enable_rmpopt

Clear X86_FEATURE_RMPOPT on the common contiguous fall-through so it covers
both "segmented RMP not supported" and "segmented RMP supported but
disabled by firmware".

Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---

Note: 15d974be0a3b as applied narrowed the contiguous fall-through clear
into an else branch, dropping the "SEGMENTED_RMP advertised but disabled by
firmware" case the posted series (v16 3/5) covered; this restores it.
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

