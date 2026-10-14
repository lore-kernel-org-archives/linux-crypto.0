Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4C14DDB4D;
	Wed, 14 Oct 2026 23:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792019250; cv=fail; b=glneFtZvSuhdPw/viOR8ObTpiEPSM9e4jQYBxXoQsz1+Hq+znhhAhzheLC+jf8Fed7jAwWyeATKYjdxv4eGp1FGiTQ2tgbIQcfkb8dZOcsR0NcDE+QkBHMLRsV7S6oNqRh65FqY+TeF2gpaEEMSIh6OdME4HUwhSoRsIJfIEts0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792019250; c=relaxed/simple;
	bh=/02SYSnXuIXBcYM1Vfs/wB7tJBTfw8O8pWYrtkTcfmA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pc7DOCrbMr2cfVVNnhTOd4r89bOc5Fl0AhMB0N8gCX6ywCFNihofyfqAQBBXg+KbM87JUvSUXuHrh8dPyUvPJInR8VBVJ6Wyp/pNninH4rsdUKrN/5hQHpn5zEOBvTuLHc29oKF6vy3Qxw7EW49i5fVU1CVNMmwOJeN5EhxVRSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TADr9NMT; arc=fail smtp.client-ip=40.107.200.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TADr9NMT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ln2pZQe4niU7sWkD/h2YW+EI2ty33qLFJ88lfdOGSfeav3CQxgBqhn4A6HJU+AnAmh7ID2+1M7UBMDmUFOEeDUK1SC16ZtdW/qOZBaYbNM5RayJegDD8wRZ4pkdJLc+SHBY4gnu5Bna3sAJ/EgXm0DPbtgUI5SHdTxCoSCO06l/5YExC5FldcmynXW5J82BO600vSKiQKeESquW7irXKNLJASFptKqSx2UNNe2pB6t5gU5N62TukGoeFMnpW2VoL8T6LB7upVHZpt4ORzdf67aZRh1Sh7T7/PXiChc8+dGmPqr2oF4VSlD4xzly7E6eUnfBfcVjqi1Nog2U2smccHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slbK0K7mmi7fm7zc3ypDmJ6H6Vce8I4WcEKwZ40LjyM=;
 b=fYeKJyXbk8OcsUb+Se0EZDg8huar+nsfDZS/+rfqkt7q/yebj7oDTdpssXS7VeGMJK+vajORc26kgGEznsJNzjGx9gVWY8GHu6W1oPcUzcYa6h+J7kzZo9a5xQhYsoGOo9Xafbq/c2Am6EVuu9OqWn8xGhSr/q1449YaWwJ2xs4VM8qJ+YZCTDHS/Kgq87EjCaIeJklBXgGpNutveANBfLLw2MwL2NyahZhFfAVuXyXQh6EJGDGHHzJhH4V9NmVCljhmUAP656VoJOsInV4OQsrq5m1pU/cqhHhDvV1b+KGWigcYAhPtddk2l+LzOmrlMNkdgmPMon5zUrp54BOutA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slbK0K7mmi7fm7zc3ypDmJ6H6Vce8I4WcEKwZ40LjyM=;
 b=TADr9NMTOg501PDO96BLkOvytYkM8ogIxoqHQofrmcp/TUUBeTm4dH6kG5fmQ3JO+3qp9liY10ggXJp4H7SQvv42YrRdg1UJJIEN6RwAh6sbzvfpB+XPDIfwV/nZLVrTxtA95cVzmcNkHVdog3lQyk+vkTaopc/Jz4PEc0wFXk8=
Received: from MW4PR03CA0158.namprd03.prod.outlook.com (2603:10b6:303:8d::13)
 by LV1PR12MB999304.namprd12.prod.outlook.com (2603:10b6:408:3f5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 23:07:23 +0000
Received: from MW2PEPF00014678.namprd04.prod.outlook.com
 (2603:10b6:303:8d:cafe::2e) by MW4PR03CA0158.outlook.office365.com
 (2603:10b6:303:8d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 23:07:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MW2PEPF00014678.mail.protection.outlook.com (10.167.249.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 23:07:22 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 18:07:15 -0500
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
Subject: [PATCH v3 0/2] x86/sev: Fix RMPOPT enablement on non-RMPOPT configs
Date: Wed, 14 Oct 2026 23:06:32 +0000
Message-ID: <cover.1792018839.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF00014678:EE_|LV1PR12MB999304:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df8788c-3c14-478f-e48f-08df2a47e7bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|7416014|1800799024|82310400026|56012099006|11063799006|261009223027099003|10067099003|921020|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	H6YFKyodIfoe2Gd9WOOfj9Jd8aVPHifT3BHUwC78g61djQLGJEREWMqkXQ/6k9W0Agv0H8PbJyfLZxit8xBVkCnQx4RvMFITUArlwPb8Xpx5XF0SsfkzO+0r5o24wBL1bggwAwIIMr//VRufeaxopwv07a0HjSLmyVC7j4JqYo09rcgV+lKuNnyNjxa3+1qvYhqsry8SyYSZPUiTSBhS5EpjSmzbI8WRqzHh9EcJoJgnBtWMddajEi3kZZEAetn2//dvZUEArnzjhGQ/KYBcSMG0brxuQf6Wr51UFCLUeCPHZ6cHbIEqhi2SiX/SFES9UtCshpDf10+tMDXv7sw/3wkktRPoWgkqa2yvA3XCefg0oYx7WvWtN7Buar5WZ1HBvrnM+MBRn9JYaK07I15DSh168GMUysJW2xU8noEXeQAPWRV3M0RMBfyveeKD7aG08sf5wAKqTeAPjiyZJuVYkirzwuErkNUY6aUJNgrnqRrfmlP3mz0QCzpemH1IXmI6t6K3nWRIr3rRL9GHdK555D0G4T9Zk3rC2+wjmN4z26bVbXyXh3WTOd6u3ATJFSdZC/XuceZHXhBrNrAjUX0DojnpAH9JE0Fdp3mZnhU0mQXksLif12oTnYllnvZFIfgHNu1OW458vxp6KuGmJ4gxaxfqkQzA/PxIjpIqelLF+kXiUfcmvgamKHkWG/a0izuEvzy3yyxoITA7sANTaoMHNRoXSeuXaDgh5N0v2KVWIOjcswXvqfMKvbQ1jEN5VbZP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(7416014)(1800799024)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(921020)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	viEsyjprmCQLAtGnMsE9rSHBw5kl2ry5BR6Nsiygpffdyi8reUxxljyTo7W0OjROrdVrRxwIFzKK1QQ+NMzp1nO78sf5nbF8/5QIDAUQQvw/8CNhIWc3daWFO+IEtUEeyMtbGP6lC4xKPv6SefwORe5oOYnMzA956EbnJlVPs/4by8FL5A0hchHBlTLru5Wp+4wiI3+x9aj0U4O9jd5UB1fUMGP5ZLJgAOpM5TaApKuO72bx4uoW2AzHI7oIrxoA3Q9kn9NrrhoOyDmROZ3IUs8zWQ2buBgGw9V4/OKxx4NWR05GCVlpdDLF/GvCSs2odyJJCfRA3ZZQHjcSfRM8ZT+NIYnM1Qedc8YefrEsbepkjQq4TMN4I8xIk/Tye+UXqmL5C1IJ9qx2tfTaVILx3Ort7CKNb3v59SgdNvyDVRl0Q1hppXtUpU1mGdNhaOlD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 23:07:22.8054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df8788c-3c14-478f-e48f-08df2a47e7bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014678.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB999304

From: Ashish Kalra <ashish.kalra@amd.com>

Two fixes for the RMPOPT series, both for configurations where the
RMPOPT CPUID bit is advertised but RMPOPT is not actually usable:

Patch 1 clears X86_FEATURE_RMPOPT when the platform advertises segmented
RMP but the firmware has it disabled (contiguous RMP) - otherwise the
RMPOPT initcall programs RMPOPT_BASE and issues RMPOPT, which #GP.

Patch 2 gates rmpopt_init() on an active SNP host, so the RMPOPT workqueue
setup and the "optimizations enabled" message only happen on an SNP host -
e.g. not when SNP is disabled in the BIOS.

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
  x86/sev: Only announce RMPOPT optimizations when SNP is enabled

 arch/x86/virt/svm/sev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


base-commit: 250ee734115bca1c1f7a38d838909aa83cce87ae
-- 
2.43.0

