Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793216934;
	b=OKwPLtD79kYnTrhJErtA5gn3pYYiR1p/4SZACvXmvaatieW3IAS0V4aURZQp21jIK08l
	 ieFY4fxqRciUz4S1hHu4Hky+vba+gFPciNylvNHz8g3bglH2aWs4vA2CO2G1iiowiukD/
	 T+7/a8JQodx99nSDafUW4Q9zOS/Qd8syPiSoZ87Fj/SVIRrUUG8UGTeJkBs/c8jYGnfu/
	 1LRVQ470d5rCMPESsj+RltRYBJT56bTxCpaZA5c6QWp4UxKPbP0Ty8BE6QWdPh8nciRAJ
	 2jx+jsJ4j/NJahJj19+mvzsp7gB0abduAxo2L2wBy0OZtHqZmIqNLlrY93H1GEKqURw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216934;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=oZ3rtw++Z/KIUuv5THoGOrT8+ZRVNw9dCKfCBdXT5TI=;
	b=BAFTbLjVuEUkvuk2AA8JmGVDImB1qzrFMmw6NM0bjbx7cQIDGGTI96TShOMdyK4p/PDr
	 nGV8cXaBg2SqXQTGitDxENUxCUMA6Kna7dpWiizojY1CHuNDaCDvi0Gg9Q72v5MsJxUF6
	 ZLAy1wryNNXKEwVYcG5C60fsxNhSyOSaY51V25OceLqF+sQs4WjIPQDG8Bbjl6W3WUvm5
	 e8hEtV8MpFOGvKD+bhzqIpTTnpook/BJ0/5ui5SX/NKmWluPW1nksYs02nboNJUGUwZo9
	 MFdALDknJ+qMKNrSbSTZta92LVqFcHXpp2uiJFPuf+62FYDn09YwmYbMJDmmaXk+HjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=xL5PgNfj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.32
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013032.outbound.protection.outlook.com [40.107.201.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA623606A31A;
	Wed, 28 Oct 2026 19:48:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA623606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=xL5PgNfj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5Km59AhSR9LF3nFpLHsXS63IUl64N8GI7jp5jFbfxTegojlS/nVZm/suKIVBk8TrikBEM2vW5kolvAZvsUI43OIncEZbGi0Rqk3l9YfTqlnWIdNfio8EDC3wdE2FzFpkt+KEj86Pk6IGKC7yTAJGWDn1R7hn2GW5ks8B3hjt1I0rEB3bwcw+/4P9TEocDd9UqUAQH7CJYJBEtUR38MrCGO6uUv5hiktzlsEhxJyExpbKdxi1UZAHxFEl5J+tr+3p1625j2XjaF2jJ2J2kOXt4jzmqhJ9nIKKYb9/LIABOLnLMGfFQkT3KrvcFTQzXUTezSYAzz8BZ/uDF5atSSGSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZ3rtw++Z/KIUuv5THoGOrT8+ZRVNw9dCKfCBdXT5TI=;
 b=cslaYG1N2HqnEFHzyiBWk9UyZPUohgveJgN0nRchOURnhm2sS/dPdqx1FqVZzRUXn/isSMsUEskJDFGyiPaTjvzPb87CK3Zuu2vL9OZqq2CoSIfH6o7NrVb03FjzimZpiEyWIOm3pDF66k3ovgSIkicoTMpO9RCU84zk+GUpbYZ/W69KfSucCHyvQFV1bHI6CYaJicz6E9WUUe1H/GMQCxr5aA4YI0cwhhDVX/DkYIuLDwrdu12yj47q+l+Lke4YF6EZN8Wl8Mk3ZbC+h8Vl6xiVwaISbhNbEs3krlZBSG9E6TQKbimg/6iMaUbSejLVJWwlgG0ALxfWill/OsxfvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZ3rtw++Z/KIUuv5THoGOrT8+ZRVNw9dCKfCBdXT5TI=;
 b=xL5PgNfjvAXiwKClp6oGkAN1oBmTw0MB2EXgxwkob49VcIJTzwSTa++BpxLD9NXZA0Smocqi4i6O71QWZiN7tncXA4e86QV0aUVgVJDX9AvucD24g1PvzJzhi/5GqZ/HHt9Uo1NhCYvddhqldHu8vCBMKFAvtK0CplRrQ3bzR2s=
Received: from CH0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:610:76::16)
 by MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 19:48:48 +0000
Received: from CH3PEPF0002457A.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::ad) by CH0PR04CA0011.outlook.office365.com
 (2603:10b6:610:76::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Wed,
 28 Oct 2026 19:48:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0002457A.mail.protection.outlook.com (10.167.252.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Wed, 28 Oct 2026 19:48:47 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 28 Oct
 2026 14:48:46 -0500
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
Subject: [PATCH v4 0/2] x86/sev: Fix RMPOPT enablement on non-RMPOPT configs
Date: Wed, 28 Oct 2026 19:48:36 +0000
Message-ID: <cover.1793216372.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457A:EE_|MN2PR12MB4373:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c00d54f-3764-4691-128e-08df352c7bb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|82310400026|36860700016|921020|261028144727099003|11063799006|56012099006|261022105027099003|261022075727099003|261009223027099003|261021121427099003|261026140227099003|261021123027099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Z2mPeUzA0HbR9A2bRVjn4t/Ei8j3W5KAbygQQ3LUCWKihVKuRT/5us+zwCyps28Ac1kNEAWFNcr7l7o5T9sMTBkxlCb6+gqo0byY46Gh4+u8UK0m2PMnPgidY3UWBRZiERvveZGukk9OfH15lc753NG7q8ZXwbDbjKjNOZwn3u/k7pDU/vmipZU+lZBNo3fvDN43keDH8Fyrm1ReE1E3mM6bKI8f41qcN+4cNcZo3oWORWbn1OM7boMeIro/Q/+Dadd4IsKng56mOY0V6/JNLKzzCQG5Xpoy1PlgP+qhsjwXUCQQoaeeeZBjHVyp9krsPGXC5rNkmWllz5rc0VncyAXu8jJ3J9dKZwL833hO3C0pSV3k/G2GDpIgjTez+WbRuLauSVTF3GuZR5jDAEqYwop/boOYesX/qgm8C3Ygh3q4XXAziV4JMLSRgncW7xpXM3eehCPTXddVXY1HwCioRnR21wWTY2hSnYk3U/QKVdUpjMLn/JxI3AsfaLsmX7o/MCeTmwVj5CbGagDm+aARHhFeCN2tAtuNvMTC4fNS3louXmwdZ9dLhkzyfK9ALWRVSdbt7l95Wk3n2Kix+W1lenoGS8cOcD2jS6+CY1es1PwYDP/00Ix9aFIX0Um+YikIBiydzeYi+95orYKIsDsDjNssaqYEK+9GD8IfME04yxApasSF5vofpxN9B0JY13ziZCvYB/U40tFlLqmKM7/ZsR4a9Fj/8PYmmkfus+r1m6bBFmxDJign9ov9iqSTY/i1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(82310400026)(36860700016)(921020)(261028144727099003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261009223027099003)(261021121427099003)(261026140227099003)(261021123027099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2RfyMCSmFVr/U7c+kKh9wUvZLcBsV/nu6kaELnpCT+wZiZkZxK/nw1prDOvrCZ9gPB4BmG0vLLxBu++9nHMDsROQmNGmk314+quMfm3TNWAUrb15aTTtdoGCoxQvNDWiG1GIdmSXLAEt2zdJjA6HBl1yM8t1J+w8K5d0b1pWSLmbBkbDXIcyOXeI6jZhO2zCBQgoANxgekVCpb5l/cs8fSSoYZ0TOVmC/z1iD1kDMGnhMK6sznfl3Jowyb3HTgbDaLPeFZ4/prDiCLRCW0sdYje85Il9PvkLArljZlgAWpOV2kI51+CUL5wW0+QfJlNbdUL2F7PuucU6/vlORr/PGxLs+iaGpXwaXKnjmm6HphCmsANA8AXxt7R1Srz8fUuCxn0kn86I1rU+CA22Fg00H5xTJBqs6DQuNAMej82aTiELdUYgghSe7l/ztRAdAvlr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 19:48:47.9430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c00d54f-3764-4691-128e-08df352c7bb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4373

From: Ashish Kalra <ashish.kalra@amd.com>

Two fixes for the RMPOPT series, both for configurations where the
RMPOPT CPUID bit is advertised but RMPOPT is not actually usable:

Patch 1 clears X86_FEATURE_RMPOPT when the platform advertises segmented
RMP but the firmware has it disabled (contiguous RMP) - otherwise
RMPOPT_BASE is programmed and RMPOPT issued, which #GP on a contiguous RMP.

Patch 2 sets up RMPOPT only on an active SNP host by moving the soft-init
(workqueue setup and the "optimizations enabled" message) into
snp_rmptable_init(), so it no longer runs on systems where SNP is not
enabled (e.g. disabled in the BIOS).

v4:
 - Patch 1: drop the inline comment on the common fall-through clear (the
   rationale is in the commit message), and reword the commit message so
   RMPOPT_BASE programming is no longer attributed to the "RMPOPT initcall".
   No functional change; Tom's Reviewed-by retained.
 - Patch 2: instead of gating rmpopt_init() on CC_ATTR_HOST_SEV_SNP, move
   the RMPOPT soft-init into snp_rmptable_init(), which runs only once the
   host RMP table is established (CC_ATTR_HOST_SEV_SNP guaranteed).
   rmpopt_init() keeps its X86_FEATURE_RMPOPT-only gate and drops the
   device_initcall.

v3:
 - Patch 2: gate rmpopt_init() on cc_platform_has(CC_ATTR_HOST_SEV_SNP)
   instead of the X86_FEATURE_SEV_SNP CPUID bit.  SNP can be disabled after
   feature detection (e.g. when AMD IOMMU init fails to enable it), which
   clears CC_ATTR_HOST_SEV_SNP but leaves the CPUID bit set;
   CC_ATTR_HOST_SEV_SNP reflects the final host state and matches the gate
   in snp_enable_rmpopt().

v2:
 - Patch 1: expand the commit message to spell out the CPUID-advertise vs
   firmware-enable distinction and how the configuration arises; drop the
   trailing sentence; add Tom's Reviewed-by.
 - Patch 2: rather than moving the announcement to snp_enable_rmpopt(),
   gate rmpopt_init() on an SNP host and keep the message there (Tom).

Ashish Kalra (2):
  x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
  x86/sev: Set up RMPOPT only on an active SNP host

 arch/x86/virt/svm/sev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


base-commit: 250ee734115bca1c1f7a38d838909aa83cce87ae
-- 
2.43.0

