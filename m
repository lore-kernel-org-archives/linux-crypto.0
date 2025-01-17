Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AC119CC27;
	Fri, 17 Jan 2025 23:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737155170; cv=fail; b=dyBRgRxWeOqIPzUJwdPa1j56KW5BolsJIiduHGI06qIRtDufEXnJD1VtdZ4asork6WFmWGNL9xPVewCvAng63RqRsRZfXJrEBl6CzmwU7hCJMxdpM34AYlJSs3hc14MEtttfR3ONzWUmB2XSAki8B02NA2Q7kT+y2bBYCyqRwxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737155170; c=relaxed/simple;
	bh=OTR9h8QePVb5IZyKL8sdfIiNUaUsUbJbPVe+DTAgcSQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=meFN2ns5UiN2mer2hcpcYNg9zvGJVJmxPgItt3P96NGug5al+MyrktEa4vMvbjIOl502MGwotU1PjAbO/EPj92sdorpTWEItDws339n74XhVMf5fcd0JueYAGgD61spsQwjKMXVvBSmNC9HFNJjw7yhVYe6JVbIEj14MxXFf39k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z52x9VYb; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z52x9VYb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WDTzUlS5Zf6F+7M0zf8oMT1bn2sffstDn92HwjJmY9SkMkLEh6yrxuO3Sym056qUH989tAMK5UYTLDgj1aurQkRV0iyWvyZe0p/xMZMqFy0vzyRDaezMwO0+SL/s9eUvUMD+qZZAWnvp7VSWtGk5NbDJWhhXMn54084KYND3ZLaDF1cpq1FY38s0Dq5GbOvgTurSbLBdzhJKvUAA8kgd9gdNF1N2398emLHM36es2k+X3C2P9er6o2ozFG49mgdCyEtf1+gssXi+hxdRAEjx+Xbfm5+oAaXP8dIIrhjA8ftK0zyFiaymDGhjrmg8IXwMGQF+aTeFNSk+z+vDCmwOKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ySIk3pBIjSKn4YITxkTGquDYfdPwbdRvOGnaUY9hSI=;
 b=kZELUwuG0fAIBCAQS2J+Knd4ZHmsnWttGjBXcT3WmeuhSjHP78VQZV1JEphHQlbAwveqcE1pQmsM2Lh0IhTi5iv8LYfFfty5wFlgRKcStP783fkbP4GktSbx7XGC4wXEE2GAa1wyjrMAKKJ5mW1jm9Iz/f1S/1UgmljUcurcZOKirm89pwQdO7tDUzEBdl7Gz6db2QKDyPrew32rLQBsAtsKclNYOaUtjVtVryJUC6wKFxXO6Xn9Ych2v+2/PuL2vIKuYdrUwR6gLVQavrudlcebuykevG8dsYMlreNcYxU/RxGty8GlYxZuX4w0Cj1vgTX08N3EmgEkhx6u4znTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ySIk3pBIjSKn4YITxkTGquDYfdPwbdRvOGnaUY9hSI=;
 b=z52x9VYbxeaC7r8RoOFmPtZyBZ0GWq8iJgUTTN9CqYqR4MeFbwZ1TbIG4TznKmgzrUUFdp7+89mMrXp1spWgfo3rhhEi8O/4abhRzGcGhqPzlbsfy+HHgMi7TE/LR5pxNRNDxRtFA2S9mUKwBIYBTTUBqN5hvCFS1XgIFrmsRBw=
Received: from PH8PR02CA0027.namprd02.prod.outlook.com (2603:10b6:510:2da::18)
 by SJ2PR12MB9239.namprd12.prod.outlook.com (2603:10b6:a03:55e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Fri, 17 Jan
 2025 23:06:02 +0000
Received: from SJ1PEPF000023D5.namprd21.prod.outlook.com
 (2603:10b6:510:2da:cafe::3) by PH8PR02CA0027.outlook.office365.com
 (2603:10b6:510:2da::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 23:06:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D5.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.0 via Frontend Transport; Fri, 17 Jan 2025 23:06:01 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 17 Jan
 2025 17:06:00 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, David Miller
	<davem@davemloft.net>, John Allen <john.allen@amd.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] crypto: ccp - Fix check for the primary ASP device
Date: Fri, 17 Jan 2025 17:05:47 -0600
Message-ID: <9cb3a054c95327fe26de41419dd23c914f141614.1737155147.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D5:EE_|SJ2PR12MB9239:EE_
X-MS-Office365-Filtering-Correlation-Id: ecdd0a57-e4fd-4a76-58b0-08dd374b831a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qxgldtWcx8aFQP2h3rVXh1ocb6e+F++yno9jD6WTPqvyDQBjQ9gue9vJKcxv?=
 =?us-ascii?Q?rx6kVFpymyfCaKV3n/MDToRhEr+t01FwJUlEJfYtej3WnPsvFTsbwgYTvLeO?=
 =?us-ascii?Q?goHNTRvIm/itsEwt6HxYvX3QmdVbLuMKmSr4R+TeA8udhRPwfPTvZt5IdvYT?=
 =?us-ascii?Q?bbUuTR3xzBEU2hkfFrSCy/N9lcmGFSf6OOMqsT0qOWtsUVVZBEoDJ9VSyIGX?=
 =?us-ascii?Q?PY5LkAktZJgi6+UOo/lMrHmi2JtOTnw6lV/wnF8pOthHvqS7XuXqfPxCPaUj?=
 =?us-ascii?Q?DNiJuMNUQ5hfQafgS3//oiizgl/vom1PHfPbESZK7vPtUeuivClbahZsar7d?=
 =?us-ascii?Q?xZd0onEWWBIrVBO2X4qNxcqVPxR4fK1nnGnfZRuhHyKXO3XAA7gocRPDR6s9?=
 =?us-ascii?Q?nQX2hTvArGEOjeqTuRZIij5KS/TvWFFSbNd2vSNMc9vOFC4T2X9RNS98GLA7?=
 =?us-ascii?Q?S/r0Dbf65FjlF5xm72wnxYXy/OdKgnvyK/NaGSYDMeLvPNZvaNsxq1/W75X0?=
 =?us-ascii?Q?0nKlluDnTnuTu+yiAKOYJ3AztuctB+ZJk8mrpxy6iGbN2i3jyTnkGsUYqUDn?=
 =?us-ascii?Q?zGe6kS1FembvyLwvSVDIVtOfQUassa+x2a8ScjNwHRqfuE7gW+jaRPZREmIP?=
 =?us-ascii?Q?0vUk5r5Y3vERgFdQZD2cRZ9QSxUQHtQJ84ZMqQ9vTREzw02ZHsqfemmA/YJk?=
 =?us-ascii?Q?6Rve66vVlzFVXWxKZYjG5oU1y/6yllxTrSrM1Pdq1gQxw45YbyAD8Cuk24Aj?=
 =?us-ascii?Q?HzT0Q0n8dZT5u9SKd9nRhjKySKll9bAbm/MfDhp3xG6wfGLOlmhQuPiIdwKa?=
 =?us-ascii?Q?w2AKNHzJPglOKSJD4lE29OFIN/Te0Zy8APwm63KRxTAfeGxyN5PJfxGrAABm?=
 =?us-ascii?Q?EPwG5Yna84w1MauU4CfhaZ6EUYnBCZStgulRAXK/M0QAVWhFcyi5i3XWbjq7?=
 =?us-ascii?Q?jfA2k/r/32hKMprld4xgK05aRpoBu9BXRBvzDDlGC9Ve9f7uxGC+TAxL8E27?=
 =?us-ascii?Q?hz7EK2FEf/qEApslKDJjZIdlHWQhBvyR+pQuufuS3SVzsv/9a8d8vPV7NBMX?=
 =?us-ascii?Q?NUsr5nlr7X8woz1lkf7yoCxskPMt80lSXV29B5W1L7cc/xKZW1jlJuIxzMBI?=
 =?us-ascii?Q?BqCT1HmqSX01zcm4c6DEHiJj5gETGstMWgY+fkoz+nBO70YNZo42JJa+kvVx?=
 =?us-ascii?Q?Sa8V8yNtQ8DxL3ce3k2E1OvgwtWw1wP6M7eZ96iN6TnIx5ALepHc8D4Ui7Ql?=
 =?us-ascii?Q?2SiuFmMUCkCVKzns+4JBh23FpUPEt1sRiIQG3Vgx/aPVBAHADXZMO7zd6qMF?=
 =?us-ascii?Q?TcJgebhpJx9bF0QNWi29gZEti5zfzWyaCxqDyPRqQrQBG6FxeBdclXBoAtyP?=
 =?us-ascii?Q?DN1bYu61OU6hU92Y07G/urIvRGsl3xnqrN6dE2gELbGVeA9mX5W3DDfRFqsL?=
 =?us-ascii?Q?qIkdncmxBWZxBYuFY5oEfTz6y08IWgjZFbLgSbQMjbE4i7BPP4d/Oaj2EDhA?=
 =?us-ascii?Q?sQ8V6YKekFVlvec=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 23:06:01.6532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecdd0a57-e4fd-4a76-58b0-08dd374b831a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D5.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9239

Currently, the ASP primary device check does not have support for PCI
domains, and, as a result, when the system is configured with PCI domains
(PCI segments) the wrong device can be selected as primary. This results
in commands submitted to the device timing out and failing. The device
check also relies on specific device and function assignments that may
not hold in the future.

Fix the primary ASP device check to include support for PCI domains and
to perform proper checking of the Bus/Device/Function positions.

Fixes: 2a6170dfe755 ("crypto: ccp: Add Platform Security Processor (PSP) device support")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 248d98fd8c48..157f9a9ed636 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -189,14 +189,17 @@ static bool sp_pci_is_master(struct sp_device *sp)
 	pdev_new = to_pci_dev(dev_new);
 	pdev_cur = to_pci_dev(dev_cur);
 
-	if (pdev_new->bus->number < pdev_cur->bus->number)
-		return true;
+	if (pci_domain_nr(pdev_new->bus) != pci_domain_nr(pdev_cur->bus))
+		return pci_domain_nr(pdev_new->bus) < pci_domain_nr(pdev_cur->bus);
 
-	if (PCI_SLOT(pdev_new->devfn) < PCI_SLOT(pdev_cur->devfn))
-		return true;
+	if (pdev_new->bus->number != pdev_cur->bus->number)
+		return pdev_new->bus->number < pdev_cur->bus->number;
 
-	if (PCI_FUNC(pdev_new->devfn) < PCI_FUNC(pdev_cur->devfn))
-		return true;
+	if (PCI_SLOT(pdev_new->devfn) != PCI_SLOT(pdev_cur->devfn))
+		return PCI_SLOT(pdev_new->devfn) < PCI_SLOT(pdev_cur->devfn);
+
+	if (PCI_FUNC(pdev_new->devfn) != PCI_FUNC(pdev_cur->devfn))
+		return PCI_FUNC(pdev_new->devfn) < PCI_FUNC(pdev_cur->devfn);
 
 	return false;
 }

base-commit: cd26cd65476711e2c69e0a049c0eeef4b743f5ac
-- 
2.46.2

