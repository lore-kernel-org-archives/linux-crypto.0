Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA9323C367;
	Thu,  6 Feb 2025 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738879954; cv=fail; b=ZCeZdJxR0ExPhe09g2aoF+fqtFRW1N003SYPPzz2w1wTNx63fQ/gIJ6FXG9n1E24CFySb7MMs+4pfin10Mxk8TS0RBWkkhWpmsHJVdbv2nnNGsF0hIzxUME69S6ia5d/LNdjl/SbWg4b16S1HuZThq8PGp7CSpNDKyLPps/ySNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738879954; c=relaxed/simple;
	bh=C/HKRQjA9Z/3lP6yQU6DF7LnU33UhbQComseguP5Vi4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oKFwcjW59ej1f7ldHKgDUSkRrwzhS8J6d74OPeY4jsz1l6Rd6v2pX5l5p4t/yHv2rWsNNi89OxXTU9aZRpxLZjzT7JynF1p+jsEVvu2qkqKgasjYPs7rr6g4teR7EKc9500efji7vOwFFCZNpNWcAMqHbzOujchAX4MwU0X773A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pZX2eWOK; arc=fail smtp.client-ip=40.107.220.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pZX2eWOK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ersB1IOFRNxgKIsFageqvfLA6i2Xo1VdGCpT2VKdxdkgPF95Bo1N65i8WDYmVHfgCzoq0fJyLbjwQBVka1COjyIk5WVfN2x6BFFY07RZrvS5l+Li0A6bkSP3OyRGOdLxVbd0R4XkSOOqwVDZh7+amZCkZyr8aZ8jW4QO0XcK9IwKM97OU9zLas8Y86Qcxyb/H8BDj2k7KluV2+TkgOpnAPSmbedcBFGQO6NEWkrYwE45vP7ot4FAB7iZu7peWs/BSP3yHi0sBpDbvKBZ8ZKivxpZCDPVI7ZqIsSbYCvgUALT/GCP5IHmjG/gscql2wOKu8xIQ5iNOu/yX76e+JhAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QGH74ulhxXlF6AxmHSJwJMdnh62/b2+XypTETEFoX8=;
 b=i4fufH+vop2a9/YpZhTWxZtzbhe+ltia09rvxXr4ncjdRMB8ZHkKNN2BbHwI9sjekwolXGEHwDspPuu+xvv09ki9V6bZgANJ46ulGNU5J9vLCCWBg60cWNR40JpX0Ch97sBPsFIZ6vY4FqVkCAqap1cZpuhy+WeRgEtCL6krVv/slV4FACoW0hEvRvq5aHDNS3V9O3uEnXTfbn7ekesanPEv1ANgq7WLtOUOzcWV8kTi6b2TmURp4+gvq3ZzrRWmGvw5d0DcjU+ntBD+0rRao0AH706hyLe2iWzrf9+uHRml8dgx9annJJHgSXgu9WXxhkcfJpQzn8DMu46Ksc99Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QGH74ulhxXlF6AxmHSJwJMdnh62/b2+XypTETEFoX8=;
 b=pZX2eWOKV3Yr8wn6mQRuQ7ogknMYsWkK1oLcDL26HLHwvRzCM9zqgPi2vanhxuPP2mmcn9HfkVnaMWyt3GaJbPIlvQbty8Img2Jm1QIOfOi34E8SMqGrqWo/ROS4uPTJF25Vr/v2IjLunZAfcGOnqf/aDdaBnsFo4AwhwJv2/Co=
Received: from MN2PR04CA0003.namprd04.prod.outlook.com (2603:10b6:208:d4::16)
 by SA3PR12MB7830.namprd12.prod.outlook.com (2603:10b6:806:315::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Thu, 6 Feb
 2025 22:12:28 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:208:d4:cafe::46) by MN2PR04CA0003.outlook.office365.com
 (2603:10b6:208:d4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.22 via Frontend Transport; Thu,
 6 Feb 2025 22:12:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Thu, 6 Feb 2025 22:12:27 +0000
Received: from andbang9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Feb
 2025 16:12:23 -0600
From: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
To: Tom Lendacky <Thomas.Lendacky@amd.com>, John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, Mario Limonciello <Mario.Limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>, Thomas Rijo-john
	<Rijo-john.Thomas@amd.com>, Rajib Mahapatra <Rajib.Mahapatra@amd.com>,
	"Nimesh Easow" <Nimesh.Easow@amd.com>
Subject: [PATCH] crypto: ccp - Add support for PCI device 0x1134
Date: Fri, 7 Feb 2025 03:41:52 +0530
Message-ID: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|SA3PR12MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: a1cd5482-325a-4167-a13a-08dd46fb5751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MhXG6vTl0d5hUHSIQovpG/DAp1q09K49I5i/+fJjyXPs9bCIkrc1xBudRaDT?=
 =?us-ascii?Q?2tr5+MVL3sZWI8LVH65ogO2SFVfFNa6mCMxr2bDNqxykUjuudeaScq7faTYd?=
 =?us-ascii?Q?wIC+iRNI0eyx/oz5dJpGKteNHTVAHgUfYMxeSbwiJsoSskmZsITtPd5i1zDE?=
 =?us-ascii?Q?CkPyMQlzJ6UbOk+bwj2VnUu/WbpatTLwYJEkIR6PTJshFW1kuaNHb4U2ybGG?=
 =?us-ascii?Q?676c3R1Yn5fGuS1Tkp3tXNFxPjMszbH+sACc6DZwVF4+eywvyZ6/Y/YPtZD/?=
 =?us-ascii?Q?YsOCbuhJQz07GJ2IzCccbb2Dpza0qN3yZvJ31ZTNnCqT1qmtlFgKHf3XnFc8?=
 =?us-ascii?Q?BHSx3SogA/vCzEZjI/IwwlSHk6vsI8QC7P3/QiSlYizqgg/YEG9OjCt9+eqz?=
 =?us-ascii?Q?cVem0nOpcrLZLyCjYx7Rl/2JyxsLYKKh99jtpOLT0MYncsfRPXaDSjMYSCDn?=
 =?us-ascii?Q?lead0fTR1Q25M2769+xu6t2K1aWSTW5VKraFawqnbxW34ihtnc8rNPwZDlzV?=
 =?us-ascii?Q?lod1xxa2VKQh25m6YA1gyLTj0wlTcNP1scNZrepnuGODEbhyIZUnQqWrqRea?=
 =?us-ascii?Q?I7qTHu+QKV4BtrbHrJxKuBHVRUlgT3xG92pOR3t/9w6vhlDIcmat2tkKzpWZ?=
 =?us-ascii?Q?FpnbJSdFRg/cUqGi76zbDyLoVSOu1jyj9tXysN/gSTPoRWNYN+3/OBrqsJuC?=
 =?us-ascii?Q?AnFU2va4+2aNgbSV2x+RqUr452h9h+GeRoLBlLfiIJxkTGqRO3Yi7tw8TRWZ?=
 =?us-ascii?Q?YaW+pBMvzuYImXPPSVheMMyhaEk+aDJPu4guD7CNDQO37W00gMKJc6LMi3w3?=
 =?us-ascii?Q?6k2I81mCXbCDJq8qx/bGcLGSriix2kVbSTPmFI68x0kWNEgNawyMTnUoAI58?=
 =?us-ascii?Q?qaFWKVqCpkvk6ofsvd8X7pwHrF95pdggr2onpaTxWtff6tkn40VqS7VYWz2+?=
 =?us-ascii?Q?QhNh8mHl+/RK69p55uUce85723edwnzEfCTHm7GqmnSdVuurHmEZYPFwMbdE?=
 =?us-ascii?Q?jit3e2hOK4GxJcx8lflNwbdxFYTBYw0NRrK40Ip/jQvo5jsXBnbsNQ+fKbaT?=
 =?us-ascii?Q?0JtwW3pUBrBm7OndLpypVcFv0jCkgYXBziz2kLjnuGbSK4wOf6kT5KIhUd1X?=
 =?us-ascii?Q?A/T8ULqmUkL77N7UHmlBDcLgY7Mn/OR9d98zfCR73rvGL5ojK0eyyyu9ZNTP?=
 =?us-ascii?Q?VNaJJ1nDrfAnV2Ga/g3pIeY5xwxI/XMcrQxbPeTkCVFmARkSJK5Fkp+KsXMH?=
 =?us-ascii?Q?+lPorONsd+AZNX8ZOC5YI1fnnKDP1R+65AJeuUc8pIMzJAqv/xizu/cMdv5P?=
 =?us-ascii?Q?5sS38dTsrYM85NDdaUXLSnVXH+3a5oX2kjnU312Lesej0DTczeLFdd1BDx9I?=
 =?us-ascii?Q?0mqw/OF4bTH4hpwn6zL6Uxpr6dQko9wA7ip19zBDlDvbf2dMk1mQWMJegLx6?=
 =?us-ascii?Q?Ay5fN9C2RNHQ+sOBuJXM9dwlm3owpc5nEBW3uKZ9t1Bbvkyol8nnPhZHllbD?=
 =?us-ascii?Q?wN+zhe7Rj/YAQEg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 22:12:27.1556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cd5482-325a-4167-a13a-08dd46fb5751
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7830

PCI device 0x1134 shares same register features as PCI device 0x17E0.
Hence reuse same data for the new PCI device ID 0x1134.

Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 248d98fd8c48..5357c4308da0 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -529,6 +529,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
 	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	/* Last entry must be zero */
--
2.25.1

