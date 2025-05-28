Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5C4111AD;
	Wed, 28 May 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748463635; cv=fail; b=uAOnkfIWzK6bnrRHZTGoibTTeaiPWG/mUwpj9+ZyBfcQAdMEpmorG22QpjD60dr3q43BI+j/CGqKVHu5G2X5W0tFQPXKCNAXv4kGxgIpn/waVNBBcTuAi3rX3dsEy7YENP51MJY8HEfkZ4Nj9GN5jf4/Fqn1DExxjWgIrFmjdV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748463635; c=relaxed/simple;
	bh=WoJxDOx44LNESwMPsbkXFJFEQ6S3tzdfWXjQ+MCeLOg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TmOIg+cUJSzJAwZh0AdtDPWqb2LVMMFo94eULJOBr2M7J5V9W+K2JMxjW92OaQKBIOVPAUaoMB++iPLU8eQeLv/UzY6ZBCinabc0Cw1Ms+TbI2PUKLUR4f1rVHkU19LsbIVW9iylg8cQp4rfk+yQu9364Ig4jZVrZbe7J8q+1fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DxNy3Xdq; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DxNy3Xdq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8gneR5WS43kP+mnj+USyagFsja43hU416TURQn9X9Fr9HQJSxYzsE13wpJXvJJxf01CxW5ybkcJPIiruFveY37WjKYWBWfN6yXulqXUg8TAwuuQm5mQbG7lBvkxzdNy24CawR7wBnEJWhHBXcLXJJhYM0J3jkkIE5fyjmzR/bRWd2eVxEe7lCHvkg2tQMtQ6rnVVH1DQsCl58kPyUEzSTuQdIE9RUJjMlPZsVJj0RQ31OiNTw1xurJF788Uhovpe1+U4WXKnvpfNTqZzgmWcr75d8OrfltV1SaWHF4KWBMla/bidMAMFn3e9VOEVvJpSinbhCLvU8cYXkc5MAO8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jD/6H+fuQ1LbZDJaAWt18qBzO+eNun7TkpkFR5QdZIE=;
 b=l/5OGy+TDRsEfq/7uYn7pQCm3thiu2qPajw+zKYSNe0Lx2U2kN7t9nowWboK5m9iNPVhWFqagjoZrVCebBOu2HCHnfMX45rk7vvZIiS3QdwqIAC39fPMBZOE1hw3gIoFklSuI3BOCzFBxXr9Fpx7fJird+PmbjepIHVTWS1eWIcSaQyPbRH2zx3mF/+eN3cbDaAng1UQx9XAOGTWrCn6c200sA/OsTeXFdyarQQoqTgGtDPvUTEedFjSvZGbi2UUgp2I6gIFupd6sFp03cFPXd4D4NyT4uLr9fXFHStMBQjQIkGDEm+VYo9wYkyZP767evjT/3grKSKybrUVu4rpdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD/6H+fuQ1LbZDJaAWt18qBzO+eNun7TkpkFR5QdZIE=;
 b=DxNy3Xdq0Cw504WakEIQ0U3WzOmBSNHuwbRplDf783f174EobLOkiP2eZTVlJ5/LoLrkKpVFw0uel7dI1As0evJ5JHqeTgaGoaKtNk0yXsW+dGfUqTq6EFYY/hf33Gwm9TJkiuwzJzwscf2hHMjlM6PRFV7penmGO72hH7Jn/AY=
Received: from MW4PR03CA0015.namprd03.prod.outlook.com (2603:10b6:303:8f::20)
 by PH7PR12MB6906.namprd12.prod.outlook.com (2603:10b6:510:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 28 May
 2025 20:20:30 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::ca) by MW4PR03CA0015.outlook.office365.com
 (2603:10b6:303:8f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.27 via Frontend Transport; Wed,
 28 May 2025 20:20:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Wed, 28 May 2025 20:20:28 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 28 May
 2025 15:20:28 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<dan.carpenter@linaro.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Fix dereferencing uninitialized error pointer
Date: Wed, 28 May 2025 20:20:18 +0000
Message-ID: <20250528202018.78192-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH7PR12MB6906:EE_
X-MS-Office365-Filtering-Correlation-Id: dc2a070d-4dde-4826-6a78-08dd9e2516bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UgHWRoQHHqiZz/MIbtbKmont/sMUvdTE86DtgHTM9SVOgzyXgQX6035lLs/H?=
 =?us-ascii?Q?aVkZ9H7AdTyOQmmrc23YgxYfuiPlFXmvM6GakB9OVi8dBqwgG2AYLf7ghK8O?=
 =?us-ascii?Q?iCMlTLnDAHDJ4SW4G7UbvnrTYoUl21JgBsTBJ1/MgUz87Hrt7aHwn7Dg5NFM?=
 =?us-ascii?Q?68GD3QRGpnFCKm/2+TCr0cmIgHTBuL5Ej/WGrEl8GLolyBtir4Ac9SFTLq8O?=
 =?us-ascii?Q?6VQgtb18Ug5GxjxU2Vyq812D2xQFySbx9knBrDthAa//Vc7/7zRRg1OZHmLE?=
 =?us-ascii?Q?cn7hHMcfCeS3ZO77oriyNeOyYXc85PTcEvKjBaWt09lLS/QE8+ZlB+RSAgoT?=
 =?us-ascii?Q?+gEdz02+JBrn3MCUCLFGxF/855EJahtWTpJ069+3Dc23IV8mg4imxl5+KRNG?=
 =?us-ascii?Q?Iwa6LSi2VqD8yJuzRhshaAcwBTwMJEGIONczFNbdKIcQfCEKo9RvGiHOdHnl?=
 =?us-ascii?Q?Kvia67Sc41k2Kxye1aKryJgVq6yBNqAxjJ2W2tG5ekSBH7u0tvRLIlDJGzuY?=
 =?us-ascii?Q?tf5qCF67czQUnyoMnd9L8EPj4Y5xRYX9L/SLIPNvjqpgqCzfjmYY4STPGm3R?=
 =?us-ascii?Q?/t29FHOTrff+ZbXTKHc60yB5sW+54KSQpoaXsNr3VU8YMGJa1BC1TkZtuI/y?=
 =?us-ascii?Q?OUoMsgMrBzCA5HrSJG0DBsd26nftUet/DOALcE2AHtEJ0bmkpokEUoqliVzI?=
 =?us-ascii?Q?ZlZVtPD9FSeTsrgerk91xrA2KebY1An0O7tc0kRSJ3yIHH4dEsRDKGSZANFE?=
 =?us-ascii?Q?eOM+cy0r4hjBlF+9aEnJqsO6BIukRB4ajl0mrsIhn07NI4RX43GyAQnRnmqF?=
 =?us-ascii?Q?eDPAJm+YF6VGRCRS8MiuKrDMkzlflgNFH8vAC68oJiyftmCufBHIonSeedaR?=
 =?us-ascii?Q?iMvfxzyXc20gULyzs6VbhReaCm3Eky41u4Y/ZBPg/nWXkR7IRxAxu3GosLJc?=
 =?us-ascii?Q?L4tVgEq1XCzGPVUSpP+vN9Ik3pt4YH9hqhQqhCc7xzJ33ges5noZmcHcTpPg?=
 =?us-ascii?Q?tRUNV4mC3T2XPKDyvejDC4y1H25Mm0gp15a8MxVQUOnA1zNbN8dr69lCby9V?=
 =?us-ascii?Q?lQQt+f1yA8iyEbT3gYGzfdQx0FL6w40hfOSunOjMTbNs+41cnZa0oP/aa7o7?=
 =?us-ascii?Q?xeT3i1vMV0br7tgDy0wY6bLBqMVPxF8UGwZNCFiBIk4WdX6rWpAXD1gP/WkQ?=
 =?us-ascii?Q?wv6IGapNuBy9XJ6+gNM+hMT3zDx1uCZ1W8KoIpDXyeXeiORhgPRDThu3mG0Q?=
 =?us-ascii?Q?0bnC3n1GRtzlLD84luddyKSfroEXjXD+zc2f2HXh/0uPzAYSMW1VW5vD8SZM?=
 =?us-ascii?Q?i7TmLFe+QV6fejcQyP35pF+LrPPRY7sDnvplCvr3cFaCLdnWW2IM+YrDEYXh?=
 =?us-ascii?Q?7swpIsyrawvF1MhfS7bC+PVKssxNHbZzfs1Ch3c0nhIbwcdjOOPkN6Cbp71n?=
 =?us-ascii?Q?C1Z2DX5vXOCa84ocfPTec15FuHDhQTPtTPc6op+YKT3DNMmgb5132SlB9Yx9?=
 =?us-ascii?Q?Hvi3lgT4Ev60rOtCDyN+FeNXB+izdc1HHvAXd47dTaULXcAHPEisIFt9mA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 20:20:28.7994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2a070d-4dde-4826-6a78-08dd9e2516bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6906

From: Ashish Kalra <ashish.kalra@amd.com>

Fix below smatch warnings:
drivers/crypto/ccp/sev-dev.c:1312 __sev_platform_init_locked()
error: we previously assumed 'error' could be null

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505071746.eWOx5QgC-lkp@intel.com/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3451bada884e..8fb94c5f006a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1276,9 +1276,11 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 
 static int __sev_platform_init_locked(int *error)
 {
-	int rc, psp_ret = SEV_RET_NO_FW_CALL;
+	int rc, psp_ret, dfflush_error;
 	struct sev_device *sev;
 
+	psp_ret = dfflush_error = SEV_RET_NO_FW_CALL;
+
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
@@ -1320,10 +1322,10 @@ static int __sev_platform_init_locked(int *error)
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &dfflush_error);
 	if (rc) {
 		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
-			*error, rc);
+			dfflush_error, rc);
 		return rc;
 	}
 
-- 
2.34.1

