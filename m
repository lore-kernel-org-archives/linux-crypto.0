Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A948E0D3;
	Wed, 14 Oct 2026 21:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012460; cv=fail; b=nDd3mhnN/DqwNPrnk9QHlTw+uDlpB+Z2xbiMBK+bpXUaUbGTlThODzFh/fnEutqjPmfnTP7dJGxVaEznrDf+PYtf+N/jEflXyCwYWLM7iKlcttiFiwiVdHyH5hbKV77fOgYpiBwjM6tliH/hJSacUPkDTjI06pgDHz+iIycJ8cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012460; c=relaxed/simple;
	bh=XHSb9bRGV2Tv6eVRIw4aphKuR1ZjkZz8dVsORjQUuUU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Uh7omTxYL307Ve/gZ3kVLSk3XnjYDRJ2xH2tOaRgd/PXCRrHUSgjbQ37TzFhENjZK/oC+TdOpjDCjcSLbQiyYYYxgsaCPIZ+KAerYbyoaXSRKYbJKaRVx4+hMVO/ZCOspG1nfgLrVCEtx0e5a9qOZFLsA2eduHgFgOFCUYfP71E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xxS9y4bD; arc=fail smtp.client-ip=52.101.201.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xxS9y4bD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVee9Sb1ogMjPO18Vj3bGPb8PLlRO9uYibwcfHcqJBo4BsLaQs0keqGwNrvlGadsyA5N3dBI0vYFS2BS0ysOARwcr2GGgzN4i1lhAeVBzwksvi0Xv7+2r01i+XJtzW2gu9xstmE71nV0NJMKhLFln/Ggjt/2E6DvLce/9f3R9y90c/nS4qTl+vprVBDbFGocusOba1qYNdkYFlgRmDGo30TmoNsoFCevsjWMlrzBiZGpmqcIKbVCumd8mkRPrSRwxodlnsLcExyutoNSFH7gXnH2wqNETX3ftpBVHhnOa0AgNcfN6vAxvIRFoPPWDjajRr2g8Z2r/0LXSwMM07AO+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/K6elI9S1x7K/b2SSqm3h4VV9Io2Dqs8l6kPq/S+wqE=;
 b=U3uthCTS++DJR0z2ae6Hak4P2XIqcWKthsEtbNjcrebGh70mUtitS4jvPHi10UaC3VfNKvbp3iqPiu+ULpMz9BR+7Ob99iBl3kXj3NLziTNaBYS7+7MM8ArWopSL7nKbX5Bu5yqm0/Y1Ubj0wyQNDHf8uol7h8KSKecK3uGZd2bq9f+WGTFFLNoRqHt+qp+ZaZqn5ELx+geZIf6mBovevStBBtCZ+DVfXF0jO89z/SElpPpPrKvmF6z7/UmXsr1OzGDdnbViWSmX+v+SNOiYKpTG6Wym9ocxnOSyo6ibKRrodcnnLP1uIxAx5DQrmNELBcpZ14/QoJQVqkN7FeG7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/K6elI9S1x7K/b2SSqm3h4VV9Io2Dqs8l6kPq/S+wqE=;
 b=xxS9y4bDVmakc8k++qjZW+xbDDesSndv3/P4VUQ+AHizbWZ534M/HlP1Dkpqq+URu+pSVVVi9j3HS6f87DFT21/LOLAaKvJhMGX7BfHrew69D8ZxA1aqD/Iax7EcEHXB5J6D9g8ACdM7M2sy+eL0sID/iSqsFXEs3HDBmky2XFk=
Received: from CH2PR18CA0036.namprd18.prod.outlook.com (2603:10b6:610:55::16)
 by CH3PR12MB9123.namprd12.prod.outlook.com (2603:10b6:610:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 21:14:15 +0000
Received: from DS4PEPF000001C4.namprd21.prod.outlook.com
 (2603:10b6:610:55:cafe::d) by CH2PR18CA0036.outlook.office365.com
 (2603:10b6:610:55::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 21:14:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS4PEPF000001C4.mail.protection.outlook.com (10.167.23.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.3 via Frontend Transport; Wed, 14 Oct 2026 21:14:14 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 16:14:07 -0500
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
Subject: [PATCH v2 0/2] x86/sev: Fix RMPOPT enablement on non-RMPOPT configs
Date: Wed, 14 Oct 2026 21:14:01 +0000
Message-ID: <cover.1792011434.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: DS4PEPF000001C4:EE_|CH3PR12MB9123:EE_
X-MS-Office365-Filtering-Correlation-Id: 0228706a-aacd-4009-f983-08df2a3819dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|23010399003|36860700016|921020|56012099006|11063799006|261009223027099003|18002099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Z8GQfOtGTLoCS640DDQxqWbvShK2UUN4aB3Ma4rEbgFIf2tfudNAUq8ETohSdtWe+UuJJKIA1+SuYf8AhhN0mcvoiHt2GEy9EnwP1aY9tVrTJSAeXJEbiXf06DJ6hgZVVWHXXyIp4BkFY69iZ62juBXnd0ul2cV6790wGGpOYIECKXWP+03lyt2YfIPmSITXSr6ydK7g5zv8BBhh1N2sCURpjNzhhA2FkjZHtKAHFIC05rESLgAnlyt05hGrnJ4n+OGRtTDvhzjxLbuBMCSsS0U6dh4bBjMIt8/axKAyULma4+YlFtjoIq0gKxhindwtC9ATgovPYvahpI+ikRJykclSeql6W6VejjpEv8fJC5Y1OSSsWkUHOLVen0WPgh5gNcQ+0Q7ElXhDLYdrsd/vNpAd3TzlXOYsvXfcWsbre0MrUcJS1l8pYS34PVBPOZ/MTCzU6t6NDr3yGhZwqaCSi1+AEEIL3gJTHe6uL9+h+dgmaxVQ67S8FaMkGqI1iGKwTMvoISZSwvD9vsBmwIuCDmqBUt0XrNABjICQskqK/a0O93PY42YafVBpR3fDpCyVEyPIpKjj+ZjuyTG9H1BP/6/dfSBpPIbjRCCJPUhXIGm3jP221DpGLWeHRfJWUMUIEOU/TR3hX3USyfI59Vv/38JRDqSGA8PgtS+RTlZKIkrRemdaMt7gHR9lVThSFPicS6IY8Pb7QTs1tH+lnsYd35S3hq+Mswm/WyPTvnXZ7zt9EYmczqmeudnG5LXhil3H
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(921020)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qTz+5bYN7q9G92gX6531JaKUfvx5bZUQ4AMlpUJNsr3ImFsbhOEieiTKg9a6OO9lZqZxuLdHYtotA5QzgG9FBE1PDzLySXMz4+gEhVAScCY+cOCFFYMymgtv8BaPrcxnax7Or9pAcQ/Mb82xBaH8AhE3b+XdbDf7zF2D6mg8ZEjYCKKq8vL9RYeruSsk5BmKGCya1BB4qt8E2Y04iWR5ll2datggSZq26u1Xew7R8mMMoUoZLszXUJXAw2XdXjTQHOnale6Imesww2YzNaRBIgetYy+7kI9vKn3ZUtsYHmnJWKRRum0FdCDxSF/kNohSLleMeQslNq6YdRQWBku6lmhXHMAZEMKd+aagHPQDrTmgPY2Q6h9xDzN3rnsSNzyGO5vFJI9I5Pp6jlVQoc3tK7RyROxAZvTW9ZNniBKwWc2LWY9UwkgeystJymNTMKd0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:14:14.9963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0228706a-aacd-4009-f983-08df2a3819dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001C4.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9123

From: Ashish Kalra <ashish.kalra@amd.com>

Two fixes for the RMPOPT series, both for configurations where the
RMPOPT CPUID bit is advertised but RMPOPT is not actually usable:

Patch 1 clears X86_FEATURE_RMPOPT when the platform advertises segmented
RMP but the firmware has it disabled (contiguous RMP) - otherwise the
RMPOPT initcall programs RMPOPT_BASE and issues RMPOPT, which #GP.

Patch 2 gates rmpopt_init() on X86_FEATURE_SEV_SNP as well, so the RMPOPT
workqueue setup and the "optimizations enabled" message only happen on an
SNP host - e.g. not when SNP is disabled in the BIOS.

v2:
 - Patch 1: expand the commit message to spell out the CPUID-advertise vs
   firmware-enable distinction and how the configuration arises; drop the
   trailing sentence; add Tom's Reviewed-by.
 - Patch 2: rather than moving the announcement to snp_enable_rmpopt(),
   gate rmpopt_init() on X86_FEATURE_SEV_SNP and keep the message there
   (Tom).

Ashish Kalra (2):
  x86/sev: Clear RMPOPT when segmented RMP is disabled by firmware
  x86/sev: Only announce RMPOPT optimizations when SNP is enabled

 arch/x86/virt/svm/sev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


base-commit: 250ee734115bca1c1f7a38d838909aa83cce87ae
-- 
2.43.0

