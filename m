Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944CA1A3167;
	Mon,  9 Jun 2025 04:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444700; cv=fail; b=nw/c30zTxcD20erBobubZejxw+s2jdl5uUE6b03qc7kjvJz0Kdw2cuErAhBR1fuTHw9BHMs2cJ4RVz4fPdzGKj8Lw16s8A491sKlmQjG7Ez3Pdo2bs1bxvM7Di3MebVE65RbJk76nP8YZhWIuBxbZJIoiaKAGVGgT/nD7+MCyko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444700; c=relaxed/simple;
	bh=xDFoTrEyFWx78D4tU78qUWyI5L/Kup/KhTl1k5p6htI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwhZV+M8Uo8DKKFnEz1Z2cEIctyMSniU6iuoF6Y8eDQYAeetFQ06VfaBQ1FqyuyqzzuKmCj8MSlg4Wn3CO0N1Qs8X8PE8g5KZx9aK7CqF0YzFJRPNDMc16/i+6mzJ3stFLOBUsKHc7JMSHyzGF+Z8GXfVNBgwH1GC6oiknP3XMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0ClwDbj6; arc=fail smtp.client-ip=40.107.220.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0ClwDbj6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghPvTDQB4frzCtjSt+agg7jY1+VAOgUOAyBR53h10eWK8j4sPLmo/dUJ8takyE9+FnDJVyBDwFC7ltKl6NrReHHIQRbDAPy743JUeSiZ0wJJFbgt3ofRwcAPbP9XppTQ0oo3f6I61Em5/AVl2hzGnH59hljiKiPqKJ5o84tfr7R6cefcvu8KKOcyOYS02TsFaNsPrW9HctlFNagaisCwbVw0nnqxwkPyT+XUQqsCy0r0HgdlgCGAvshnR5c1LAugHiggQmpgGLCUAQIldKk2FOjucrE0cn5MjpuWcPV+Z/BXKg6/7pgAmkWDN51xYscwbBJv24am0z9ipV595idg0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVUkp8WzpxndSYh1LUC9UT1Eb0l4ajhkHj/WiNmQYTk=;
 b=hX1Y0wOQIeEHEpfPYfU0oPtZdqmPcnxSY/BmDCOILi1tyo1/ly8NctVh0tpQYQ7WtLwHU1+sJglLH6SZTjJcg5K7vVI1Tpg5z50MzY0XaPHA+gJkLZJWUo2DiTRsxJ8/4ZIFPmYg/dzrd4mo4yf5Y7YVfy1OJnzx3HjfxWDEuoMfh4WCj2Xd244IqtJkzaruGcE9lK8wNDB1Y0CRm2zlDkbLwWt2g/A07MwTn8588lukth9HzjXotZ1KvCdXb0JPw+9CUfFyM7wNaYZ+XWk6mmB65MSfzU6+doD469ITB+rQYHGhA9UWjPxHYLg8Gb/v4TYxFnJULZj+7+mknNUNiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVUkp8WzpxndSYh1LUC9UT1Eb0l4ajhkHj/WiNmQYTk=;
 b=0ClwDbj6Zm5SPDnr+wcIvU4wgUKECs85cii8MZ1HP9PzTk6VK/CN5ifsm0g1XTeFOAhML7GPZt9h96I4/7pnWMvyv8bH/w7LO6QCn9J9dZ3m3joqNQmSGVFGZlr2PGB3vBXReDiq+QHPwXQ4gXI0Vwx99c/KaM9qRV0fFn0V3jo=
Received: from BL1PR13CA0094.namprd13.prod.outlook.com (2603:10b6:208:2b9::9)
 by LV8PR12MB9156.namprd12.prod.outlook.com (2603:10b6:408:181::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Mon, 9 Jun
 2025 04:51:35 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:2b9::4) by BL1PR13CA0094.outlook.office365.com
 (2603:10b6:208:2b9::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.16 via Frontend Transport; Mon,
 9 Jun 2025 04:51:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:35 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:34 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:34 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:31 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 4/6] crypto: xilinx: Select dependant Kconfig option for CRYPTO_DRBG_CTR
Date: Mon, 9 Jun 2025 10:21:08 +0530
Message-ID: <20250609045110.1786634-5-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609045110.1786634-1-h.jain@amd.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|LV8PR12MB9156:EE_
X-MS-Office365-Filtering-Correlation-Id: c95427ed-e3c0-4d44-e36e-08dda7114fc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AS3IU7u0Qm98NV60bZ3BhRF7ixohRyiT+f+94q2+ttR4fQmsVY7jNeSJTLb9?=
 =?us-ascii?Q?0mEr7HXuQGVCIt0JCPigwyaNffjXXAnUDc59ScEKhoc0GQxoslwj9e6p66Qw?=
 =?us-ascii?Q?9IC8+NXfftA582wMtQyXzNVvrA5S8h3HUztipo4sHhYc6au3oNRUcB6J59TD?=
 =?us-ascii?Q?Gva/dUlWJQBHq6UhjQ67RtQBbrMLAOacCmgnzkvhtsheZ1fyYRXuihZlye5X?=
 =?us-ascii?Q?FhzMlqUkDv9TkyLidJE282U+nYowGv17IUtc0vYLX31MJjtfWsMszXH1Os7s?=
 =?us-ascii?Q?OtLIqRGF2RKXoenuEZD93CanhhcusbcDW9bV4oFKT2jTRWcgAItLm6EyNW6z?=
 =?us-ascii?Q?ZHVjrzdxx+jXz32e1Of82+zXJqB5I7kWUm4tcJJv33XS0gtzCDliFbdX9xfx?=
 =?us-ascii?Q?SqgwMiMciJOdpu+t23zEokgyQ25JAdjOt2Nq3ARPjKsGVHk+7p2Vd4S19Wcj?=
 =?us-ascii?Q?upiwiNg6+IV55riK9pdXMKPatXh7sBvkMyW9+gFSsBmQSMit8LXxt0xKKzGM?=
 =?us-ascii?Q?0SE8HSzEwBn5CgdMv71gE954Ra7ktdo/UHAspUb2AAXSVlaPEQFwCQQf/g2F?=
 =?us-ascii?Q?PngLHFIauoR3Lq1CyhdKskuKC6OAO+wtSMrYQlPg5ujxnD5WQ6kedPR9CvRm?=
 =?us-ascii?Q?DYV7byrBtKfNjsrHtIPl86GP0uqOdmaiKQNCERw2F5M4fmbkzsln9nYTeXK8?=
 =?us-ascii?Q?Xp2kWw1nqFGXr4A9To/UWF2u1c95n6qcEXXSgsaZxDxAYUoH7X9JBxZbODl2?=
 =?us-ascii?Q?bOiOlwjAxe5v0FTTVG9maYW3XOygMBrJh3FFdfAxI5pbhbxrFDsg8JhA5VDK?=
 =?us-ascii?Q?wN/aNa9bIROZ03djL2/iIUl+zm3KPBFgFx5UApGAj2wleCpiiHYhb5iod355?=
 =?us-ascii?Q?DwyC06SbZc2F56Txt7tHzIVJk7G3bivhwLR5y2mfCP2jzlJTZD2uEMPexrQT?=
 =?us-ascii?Q?/J3oAAaMDxSCx4w9mGDZckmZKHmqbOeOEIqY1zfxV5aOmzZfcINmaV2+FK3S?=
 =?us-ascii?Q?HIYcfvu8DvDzkpV/hauXVi/isPKvxZe0MmoJuk+uulcFuguksOAsUJU6oQIF?=
 =?us-ascii?Q?v9uLV3SWWRUFbAkCxR5uU0I297tbfoKBVXFcVi4vdQ3QgTsN+JVaeVNRQwoZ?=
 =?us-ascii?Q?UHtqd5u21H0XHofUXhr+uMdBiXMnxNTfuqqj0C2prrG4/LtW2gkxO1Nx/bK8?=
 =?us-ascii?Q?QQkR9Ed4JL//ok65lHZKQiV0s1pzTJzLymkkjQGwXZRUxUbKjx67NJt4Nr5d?=
 =?us-ascii?Q?2+V5uZcpo1kX6XdAC+BUOSSTQH41RAkxBA++G7zY+6Gvhu/RMZU4907mBx9r?=
 =?us-ascii?Q?KQ2ka89XJmxmgnbg4HIPT2u074H+iqH2MHBIy1cl61MEYhK4ZlBxx0yOgdjt?=
 =?us-ascii?Q?rp6J6ST2VvnUoWDF18CvIRqZAGKVQhWSAb7ZNohB5sNUrieFictwgqe5aTe+?=
 =?us-ascii?Q?92DkQ82BJBRvbMaQemj8aeOGuSBX/ySyCb5iNItrN8TYsYzsxPo4gAAmsSrK?=
 =?us-ascii?Q?PI1RuM9ISbxlBdNQ3tfUALjrwNSIjUmCLovtjmgffrC2v0Edv4jJSX9EHQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:35.0690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c95427ed-e3c0-4d44-e36e-08dda7114fc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9156

CRYPTO_DRBG_MENU Kconfig option is dependant on CRYPTO_DRBG_CTR.
Select CRYPTO_DRBG_MENU to fix warning reported by kernel test robot.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505301900.Ufegky8f-lkp@intel.com/
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1bbac5298ffa..cfbc06451fec 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -714,6 +714,7 @@ config CRYPTO_DEV_TEGRA
 config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
+	select CRYPTO_DRBG_MENU
 	select CRYPTO_DRBG_CTR
 	select CRYPTO_RNG
 	select HW_RANDOM
-- 
2.34.1

