Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D4827C854;
	Thu,  5 Jun 2025 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155900; cv=fail; b=G2G/oOlZsiU6KqByfikLaSFmKfSHJZvCn121MKJUqJM8TcnPOFzA1NtTt9XtFj87sFNAGglBswfggw/sB7oNYvGnkobx5YemqJ7OZ7eaHlKqNx65ofDbO5wsllFzdnnuQoAWpNm2X4CafbmnXwVN4axWYFri9H+EUZHq7SUuq7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155900; c=relaxed/simple;
	bh=T0f8maNTVNyV3MdqwdwfMY9M1JBddlXjy+Mof+NEhjU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hEvACIo6D5o0FOkSqhQgz+x+jGU82TAVbmKUQEhTBoOEkP3TSyFSABjQYT3JbZQ0/uOPy+9yDYBw1Lumo8Fy/yKQbK7B/A7wsrjRGyYaaNe9e0iCdrtdaOyW93rJi37A7IxgC31p98yib+G4UkDbyjJCNJpXMvXRRcC9QBaGNbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rVdZ8sTU; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rVdZ8sTU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BoxR5R5bBulzOTXVycTL9OROvXsuaj5jnw/0Q/7iKq9IBsfy61s2CzzxBmQl6V8cqO9HFh47ZH85Z02EFFaSoROiwVYmKm4vwnoQF8456byQm26nILFrzwLqSM3wnw3/PiNXtcizaLTVqQXr0mEiIdIwZGq2fI5usrECT93IHHYY/2HyQj5KGjcKOK6iuD+yjTrnFwW6u9A+wJajrJc7ZDcOrP56my2aXEUCCZqsNsC8JU5jMalxQfqlDIyYSz7qZ0PE/QgUkCHf7/0G3nDzqXGSDXIiZvrWeg0cAV0tZqcBHAT0m+RfsIs1tgsD27fxYkIOYEyfSsWXIBh/Ob2gBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6v7js+9uBOfp5VjcOsR/vZEE7yB+kuZwLQ3Pj9q3zU=;
 b=Emy+rD6PGKOCfN0OEa/DQCPwy4n/7WjGvuiYOyyCd+XHyR88UkBrMbhtdTJ7Pld0B8LsUA2lB0w/E8wmr7/SMx2PWZOLE68kyq3qTvrPJzCCOnKuD15DN2/ZtmtKkiTpZWvj5TtxDR1LojV/YSyUj9cw6iZAEV8mmq3TdZlk82I8COcOCTSIZUoRHpDNcNd0Xeyl4M/dzKsGZbVWY4TKQSiN1G/4tHO3/2mx112tQftlW6ctiCTqOEkZ/Ko7V0kjVqM78NwbRUqJpf3ulTyrDSzBqUnFRt2S+xiBYfmpgtkmIxSze7Oe6P0zDeDcIRevjtErx+pU5XmcO8KZSh3Ukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6v7js+9uBOfp5VjcOsR/vZEE7yB+kuZwLQ3Pj9q3zU=;
 b=rVdZ8sTUhzS4+BcCCnxh8SUn2uefu7DDiAlHh8LFQJBniWvwiY/r7QO30MP2X0/1iVqC0HgfMB1ZWKQMEw2RmI3Idrk9fiGSeywN7KiO9h+g+ZHfnoTbwDqJASLYn65JWru3djlIfA9OoqNSV2uHnqUfKTJIF73LFvZ49FU1Qo0=
Received: from BN8PR04CA0022.namprd04.prod.outlook.com (2603:10b6:408:70::35)
 by CH3PR12MB8902.namprd12.prod.outlook.com (2603:10b6:610:17d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 20:38:15 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:408:70:cafe::7d) by BN8PR04CA0022.outlook.office365.com
 (2603:10b6:408:70::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.32 via Frontend Transport; Thu,
 5 Jun 2025 20:38:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Thu, 5 Jun 2025 20:38:14 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 5 Jun
 2025 15:38:13 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <aik@amd.com>, <dionnaglaze@google.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] crypto: ccp: Fix SNP panic notifier unregistration
Date: Thu, 5 Jun 2025 20:38:03 +0000
Message-ID: <20250605203803.4688-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|CH3PR12MB8902:EE_
X-MS-Office365-Filtering-Correlation-Id: 3941764d-d4a4-4ef0-942e-08dda470e4fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h3xIGsahqsDm1E/ic328STnJSlMeg0lqDpRydy9x+VOVep6oBhT4r8SUIFBC?=
 =?us-ascii?Q?1d2+gYx72n+7JOikfRmPKjEsWwj5jPTJTK5FPicNkmTjYnanc+Rideu4qXzH?=
 =?us-ascii?Q?YzUkywPw2zagqZmo38qIOAHeHMTQbHxsH2gDKxaxH8vn0RAAzZbF2kLHexrT?=
 =?us-ascii?Q?ljqUU+TdPCIp+pJmdCtxfq4xwrkvnbDmSoyCUGYNQ8Fs8HUV6/YqQOKkZhts?=
 =?us-ascii?Q?Szcg6SF/fcKS8uneBIhtPY9nylpGmqdIp1gLN7PyxXeDUsfjr7zz1PN+NyJU?=
 =?us-ascii?Q?Gd6FXBF2v/8j1z/W4n+MZV9qK9hmWmps65hhFfTdqgpIlepjNh93jY+sHQ+j?=
 =?us-ascii?Q?7dGVsVzEPy1885bfeaCx0tHcWNkw3d6r1oJGYg0y0q6ei8kJLEavxxXRQ2H/?=
 =?us-ascii?Q?EAgKOHZoSnqPb1jmzLuTZ1L6R6kDJeznuKKNBlYyqTAWQvgAx5Axe9X15gfj?=
 =?us-ascii?Q?uRzOl6ImwgDX3EDDtKoTrOEMkO66kxgtaeL4kYsTr1bWiotzXWhO/Cf3PNII?=
 =?us-ascii?Q?jadG8Jlb0QnPwnSathJPjVV7unTAygBF6dvtyzo9gZwk5ZGh4IsOH3b5Y0Ui?=
 =?us-ascii?Q?63vjTfRVJsxaUcEs9fO2aNgA3G/3Fw4K4f86aCDGEAk1OGnBHEL1tY4cX8T8?=
 =?us-ascii?Q?m6+Hh55xxSuoFzHx4C9YcV1NlhcuTXfnsU1qaBshmbb4Kt9riQ22Oz63rytt?=
 =?us-ascii?Q?QPzNxOaoOWVIXv8RZ/nw9Pxlp7PTvTq2Lm4kdBOz23PHCmBnCJT68QEzXLqt?=
 =?us-ascii?Q?QpWPwcoSVUXER6cb1fLWYSynWr6sH+UqoNvDE6alBk4oMwDwDnyRPye0plgN?=
 =?us-ascii?Q?lY9QBO7VtJHPym19dIp77Ag6mwKOqKhozuMaP6y8nN+8vMJ2nnn9V26LxKs1?=
 =?us-ascii?Q?+ppsJRh43Gma/MJ9ps6y2TwtV7H0QsMmlitl//mSrGsvzLs5zfhlH6xj+FKQ?=
 =?us-ascii?Q?ydKNgPDtqY53Dx8XYYHkLE82fdO/XU4DRocDi3WUiEUANc/lyuxcNH8Qcxec?=
 =?us-ascii?Q?CRUqa2b1iBv2MKnOTN0PrmvDtd1TWBfNgDm3R9XYcANoh2C/Z7iqCdTX/IA0?=
 =?us-ascii?Q?1bohfbQ+DtwhgmkmNHiuBoiDGFAeExrZhp2m1dClKcs30etOSImqGgv/fzKd?=
 =?us-ascii?Q?NO/sZIr0WAq4ZpUhLg98amgMk0EwGsNIEhiFBsLDJ0ugjBZts4wMLlCkWb8U?=
 =?us-ascii?Q?xFg7yew4fCszZpLDJmjQQfxLRK/gW8biL5kgXKzgDEowTijY++UOh0euZles?=
 =?us-ascii?Q?Jf7/mU2SDKz6Wp3tdKGr9nSWD4QTkWsVUDzYKT/FjatGDRQW2hw47YyuHy9Y?=
 =?us-ascii?Q?ZyV8NB734/j2lQw8LIFz/BOdtf3zYDNJrMiJyi+ammCrJhnVXe+xcquspJPr?=
 =?us-ascii?Q?Pmb3I2pHLGHYGTu4jlFiM3Q9OiC6sqta+ogBk0qEbyZbQQZBoEbBGoUj0QdH?=
 =?us-ascii?Q?nFXBKklnJ0u8ZykknRP5K7D8oVubI9nIhljRoJaekYKJAeuwEGX075Oof/II?=
 =?us-ascii?Q?wGBce9JN337knb7OzCu6DxSQ8Tu2OZVmqMVZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 20:38:14.1091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3941764d-d4a4-4ef0-942e-08dda470e4fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8902

From: Ashish Kalra <ashish.kalra@amd.com>

Panic notifiers are invoked with RCU read lock held and when the
SNP panic notifier tries to unregister itself from the panic
notifier callback itself it causes a deadlock as notifier
unregistration does RCU synchronization.

Code flow for SNP panic notifier:
snp_shutdown_on_panic() ->
__sev_firmware_shutdown() ->
__sev_snp_shutdown_locked() ->
atomic_notifier_chain_unregister(.., &snp_panic_notifier)

Fix SNP panic notifier to unregister itself during SNP shutdown
only if panic is not in progress.

Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fb94c5f006a..0ba5fe3b7883 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1787,8 +1787,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
+	if (!panic)
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						 &snp_panic_notifier);
 
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
-- 
2.34.1

