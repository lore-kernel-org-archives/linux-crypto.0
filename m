Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B5038734B;
	Fri, 23 Jan 2026 05:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146289; cv=fail; b=BU9YSCTO2WtGFYT7hkf0S6zKXt3zIjtiGD301ttEa44H9mc050TIXDetQh3b7WSvunIkDPa5yqc3yugNHLeI/LgXtCU2S538WNccrQPsFE8Ph6GQti9LQMQ8PrBTH3VbZ84o+mUETNaaNbuuSzGl+vz+3jqcCy/1ahRlr7v6QX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146289; c=relaxed/simple;
	bh=FhWkVSsN4wlgl5cUmJgsGeXE8XIoVWpS6SGLnT1b6DQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oM+9N/JG1ogabpzK7B8j61M/sPCm09pOWHMwxbM/sP/K8tiyhbCA51U0rbQ1SRDvBGhwuqRLXMBRmC7hcYgVhUSTEfdOQ2nBzPqErwgDtAf96pjVNlflQ2TXH+Fo4n0sp8Q0pNtNJTcXTOyrHXxzUDdbsieY8zqaZLWnWbEpU3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jibY7dz3; arc=fail smtp.client-ip=52.101.46.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jibY7dz3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mimcS2nPQmiJJWlsp9o4QvTO1wRW6+GEz5syeOnrEFoVC2lyWos9qLTOCbs7zIwSTSHPgu6HEgCATesOKby6DD2bKLjVq4ohLuGNHT1bawoPcIEOvuRqefSstTco0Mun6Va1HDmU7hSvtkflSez57PIrle9H0gfzPs8oyacbN4jhQoZrAnxBzJ33Mcya+SLJGs98AiZAB6LUbC46pxrIe+8Xjc+ScDfwl7DmGEcmbEsH+neKkyK3W9Wm+b2S9DjZ2D/LwQd0Pqa0XHVPcsvYfjkYT+OlR2B9VaBMn70viCnLhibU1rPOkMi+Up31viNxQ4mvIJindPaXA8YqGME9vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yO3dGOf11YDLWPmuMCyt8sL4a1m1wZ3volY0kbA5++I=;
 b=x3CQWb1eaS9caes0kgyJ+cI9CuMEcFFOvNfPofytVDRARZOv25BAqH2ny4GF7n6huCuKMVeY4laAeaXvpVoU3GYcGxQw0jE3XzQR8Rs08MuV1LVtAWT/ACRb2RstWBdfbJm+2hVGH9LDsnJoROYl8yqshwBZES0go2YHEqADNzLiAAboYWCet3mxObgOGQht3KuJ3JpurEjI4j0QPiaPd3icmSI/YMEYbL4SiwNYnb5UnceVUadUtmGEx5NmnJ5d3xRBp37JuJrv9cLL78lz5fxsOhKHc3H/s7bAti/GaLcePa+YoLxQWTHVz34htnAuC1tCsMyA3XVSwY2K8wcBgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yO3dGOf11YDLWPmuMCyt8sL4a1m1wZ3volY0kbA5++I=;
 b=jibY7dz3N4KMCUdcQUtMTkVXaQ8MKCh5YDhi54bqZTc9VHXtkPBxnFpkOmw422fhXMzP52pb9rw24gMGVbpZ3EhsEjA0pcic0SSpzWFa8EzEQ5PKVzme56EojcwEMGpdiqtaJ6lb6E33ZFJA10twobZ47j8FEpQgSiYRpPQ2l4M=
Received: from SA0PR11CA0176.namprd11.prod.outlook.com (2603:10b6:806:1bb::31)
 by DM4PR12MB6232.namprd12.prod.outlook.com (2603:10b6:8:a5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.10; Fri, 23 Jan 2026 05:31:18 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:1bb:cafe::1c) by SA0PR11CA0176.outlook.office365.com
 (2603:10b6:806:1bb::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Fri,
 23 Jan 2026 05:31:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Fri, 23 Jan 2026 05:31:17 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 23:31:10 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <dan.j.williams@intel.com>, Alexey
 Kardashevskiy <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	"Pratik R . Sampat" <prsampat@amd.com>
Subject: [PATCH kernel 0/2] crypto/ccp: Fixes for PCI IDE
Date: Fri, 23 Jan 2026 16:30:55 +1100
Message-ID: <20260123053057.1350569-1-aik@amd.com>
X-Mailer: git-send-email 2.52.0
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|DM4PR12MB6232:EE_
X-MS-Office365-Filtering-Correlation-Id: e8748f01-596e-4265-942c-08de5a40a238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AifcDj1zMyq1AS756iTdCjHIa+Gd7+9DUlvKtjfEGP/YG+fsYZvxMdM5CBNP?=
 =?us-ascii?Q?cphMkbDVFED2FLZiemJnjFdgkRDthEEsJk9pnmCFwStClIdpE7oZ3xgTb0NZ?=
 =?us-ascii?Q?cA3BVhCiRx167zIGPZFBfehNMkLBx3ObLfWwdpnH0pXh0iAWn8C9l7Cl8rvw?=
 =?us-ascii?Q?Zlyk2GXhq9Q6uiHqL0U9tT9sbJmMc+xjzkGmcwAqHn1D/6fn+NvKM3GKjLyU?=
 =?us-ascii?Q?O60bdJqZ6uprWwZ/73JOQ7RXuMWOVf6kILGjKCHqu77sJHwP7tMszbgt5uIp?=
 =?us-ascii?Q?VlTGmk+ZOyLP0RZtj/M8/cgi0foNT+BTYTIjMeUfJ047nhqWa/bzrs5ZexAa?=
 =?us-ascii?Q?SQf9wIGkmEckUxBfUANypYvoHEUSns8mCmRHeV5AW/m1ekD2f9cwOdpJx6rs?=
 =?us-ascii?Q?orXXj0SXB4hP8fxh4XT9qzOj00MttCk39sRHMAklZPLCKTU0BtaGQkMn/5OD?=
 =?us-ascii?Q?4gSTlrZfJ8ETbBqW7Q9tfxKFx8cHbAVA50jD91urFal0Pl2tP/+6nP/vFyRI?=
 =?us-ascii?Q?xvIdJuhPCY0S1Ovd7tF6ng6Xy1BHuyV8pVshfijjLD3fZWRF6TAGFssSX3zw?=
 =?us-ascii?Q?hvjiO4SnUiuWQr/ZimC80pZmewaQeucFnjkcDztBVMvav26YKEQ81syZddEQ?=
 =?us-ascii?Q?+lMOBf5Mo4wCMB7vFwEBV3bRP4rHgJVtc/Mk29Nxiy8aqoCrlcQmPgDb+tVf?=
 =?us-ascii?Q?SVCsB/LYyIWpxlXLcpfOE2ZtOijeUgkqTMsht+vPceUG/91hdt/5OY96NWkq?=
 =?us-ascii?Q?xGfzI6x31qRIE2j4lCOsv4+C+2SJtjtszvPd0t1jL28QVjGyWehprgst3j7l?=
 =?us-ascii?Q?oIOZGuVVSgid33ILXR0e9QZzAW/Llu6mqf7yClothktbWO7zON/+2f7PBTOf?=
 =?us-ascii?Q?Oawxv5I7TwOcxWxruVJzHdx+D7kZB0Phr1Q8nvsKbtMKjH9A6Yj9ddf8ydjX?=
 =?us-ascii?Q?qYyWGIjuy5DAN5YtsgZRs7Dxmv9asUHL+j0Px0GPD9CApCL5LwowCJBj1c6W?=
 =?us-ascii?Q?muyBRgEqS3mp6Wt32VFrkTYroC1ASk8bWZQdkEPv6HE1uvKUgVNfOsh/jgV5?=
 =?us-ascii?Q?nE59bQblF+tZpKgPFulUAo3mQT9J9D3apjtKeDjKyDKcqF7L7NYcoTGudvcK?=
 =?us-ascii?Q?BasR/67L5M8FUCrKRqeCHDfNA0Cnfs9abNxl4S/KV4Wc47+Ebmf02Fa2z+0a?=
 =?us-ascii?Q?cJP+7S0vOvgs3fItiu0tSkVL2vQVYWBBR3qNU8+83yoSfSDwS5XFvhx7QlV8?=
 =?us-ascii?Q?1Pv9cQEDNVtKeT6XeNlkiOwIUoiySqNd4Q0Q2BXzUUZiiTERixhe6eqJ3I2O?=
 =?us-ascii?Q?P7CgwQ8nZ8m0De5ybEO8xtO2bxssQKg26mYiVvGdjEfsCz2KigUNxQHPcqXx?=
 =?us-ascii?Q?km0W/+mDPxfpZ1zBoANLxhdMeUDStRY16TSroRY4V5/cVFPdrQbg+NGqmF/b?=
 =?us-ascii?Q?+2B0kNK7K6eqc3sT7YWpV4FoqLQZIR4bPXDAnuJ1uvU+VUXk2p9kuwBOTRNT?=
 =?us-ascii?Q?O5lX9iCKLCtGgRfhk0hFjhMPHKzZ9OwItVJZmtT2Z+kbP3aZ5kaRKIGRANZ1?=
 =?us-ascii?Q?8XKn0VUXfflMZZm99qldJ8zE+5rpuGBJJA9Mhc8LXLpcvmaGqG+TXaQ+kXL7?=
 =?us-ascii?Q?8YirO0Z04lnxklN0Rp4WltVbnLukqcTrADbdGUlBgluiapkt9PVTVQsUcnf4?=
 =?us-ascii?Q?xg2QJw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 05:31:17.8847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8748f01-596e-4265-942c-08de5a40a238
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6232

A couple of fixes for bugs discovered recently as we got more of
these devices and tested more configurations with multiple devices
on same and different bridges.


This is based on sha1
0499add8efd7 Paolo Bonzini Merge tag 'kvm-x86-fixes-6.19-rc1' of htts://github.com/kvm-x86/linux into HEAD

Please comment. Thanks.



Alexey Kardashevskiy (2):
  crypto/ccp: Use PCI bridge defaults for IDE
  crypto/ccp: Allow multiple streams on the same root bridge

 drivers/crypto/ccp/sev-dev-tsm.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

-- 
2.52.0

