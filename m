Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278CF155C99;
	Mon, 27 May 2024 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823642; cv=fail; b=NXqxOH9goalyW3ge7xn85LKxHnZ6gjfp6DoT6413cEiklF1E8rY4eszbxAbhESaEw0l2msx40vgbZot3kR3rnBj7xNT5ijTCvAiQ9hGTWeO/rFpkAIKiIsfQLrJs7Zhcb5fCXGmfItASAR/sggoqSudrsl1EVcaRTCve26WCF6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823642; c=relaxed/simple;
	bh=YvGVSI5yLsVfrmqvZo9WsBMZWpMDeBIHDrJrwFLMFw4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lS9D3HjffizLsQwsNVSyMbnZFzaQbjmO3+eTqspTa7j7ZG4j6zEjofPW5Vq9qeB5MUCcrEofMle8vishgToU7To9xg2O82S+GN48AVY49FHXVPEP5FWIzEQUW2buzFSyC4dfpu1535fpym0PranNj9Pin3ysti+ypkTLLBpA23k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NJSzqBcZ; arc=fail smtp.client-ip=40.107.236.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NJSzqBcZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1EtETxHY3lntpk+hoQ86tg9F2WqfqzMJfqo5pQ2zeYcuzsWrrFcJz7i2Vjaf9Q5Sr6cN7D/VTSfkuZod0tNqzW0OaG4OW63/lMUSkms04ZI6zD65MlcfELI4N6gw+moDE0Tu6a/EeV92iB7dLbFDxpWCoD+a3g/QvKnCnWTsHRREFfJInyDO8snTOydhz/977AgZxOrAGNpMh251GcFr3KvpY7IZ0y+0Y3MvggnMv7xa7jqzquLjhpNnZ4jduJTsnzKnc+jCk5K1YeanID8F1RjGuC87KOAzJ51Sw/QG9KOUlIGzEyYeMaWA6DoZDnKps09OzGQzV2JLmc0qocT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8WekG4SsiDrYTszcQi305jWDJBY/UD4mb+BW9y4IkM=;
 b=JUY/vwUuCyliHg1GRhrUG6pZSKRty5w37MvXm/IC852pKPPDwj+FozszP/LQpcFlemnG4bs11j7TZflE4fcRVHfmMWSwMbWK0K0dJpRoJXyE5kzteR2uwgqdasOzm1VauiJrkyyeXTwU9FdzbaxVP2KTS1oz+AhAVsYvInvphutUpbiacijNmrhrfbb1ehIovyxVyDKHgomsitSsBXUkol+suvAmovGh7m49HIhPQDYv2E44WCDYwMiGg594ELOgJKS3JleTsvJX3smSE8KaBzim9x1Wu4bYfYpNKMayJ+EKaZN6EV2mSw62u44uazcMI/MtZ8DNpPAtEcA2ZwwqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8WekG4SsiDrYTszcQi305jWDJBY/UD4mb+BW9y4IkM=;
 b=NJSzqBcZbcwWmork69HJDUiTdVYwRWjDpUl/O+7Zx2hqF9tAKdoX+K6AC+Yl8k/jaf0Pxkm/jgiS34XRjo2ZwjX95t0LgMzLqSNpGXJAipJue02G4CqZsw5vQuADLGM5FR8hEMB6uFw+BYvVhXkHWB9zWJgds3ZcLhVJ7yPm1lA=
Received: from CH2PR05CA0025.namprd05.prod.outlook.com (2603:10b6:610::38) by
 DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.29; Mon, 27 May 2024 15:27:16 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::21) by CH2PR05CA0025.outlook.office365.com
 (2603:10b6:610::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.16 via Frontend
 Transport; Mon, 27 May 2024 15:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 27 May 2024 15:27:14 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 May
 2024 10:27:10 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] crypto: ccp: align psp_platform_access_msg
Date: Mon, 27 May 2024 10:26:47 -0500
Message-ID: <20240527152649.3722-4-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240527152649.3722-1-mario.limonciello@amd.com>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e70b9d-2d0f-43e3-6882-08dc7e617cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RZDOvD8NNE4PdZvXuWGlBoh9kgJssJsCnJ63hfIiSrenWkoPYke9QNsGRaPP?=
 =?us-ascii?Q?M+pm6IbtxICiJ0e3n3TXI9eaQqOnY8ETpZcFAbhKWGBqImcZhVuPowbKrcJy?=
 =?us-ascii?Q?sbSfI7cfZsLs2kWsBRMA/ArbZ+wC1b0+zl9ToEM3rEus2xZudD184JKIlOZQ?=
 =?us-ascii?Q?ebks2CLootjvIV545Twi54j1NcEZk0cfuii4vXQ/LEsBtPCBoBU+LtIj4qQ5?=
 =?us-ascii?Q?7eQZCaPbUuVugqdTfqMqHAYR3lSLahQSE0qXn0YDiQpjFkWJsg/t2NbwnD1y?=
 =?us-ascii?Q?k1ULXJRrKfywQq4//xUdqPuDty5OK/4V1C+g7XnfJe5sOi06oVoIuHVHMhnJ?=
 =?us-ascii?Q?9nobhrjZD7VAZBBCa7/M8qISyLYx93v5dOHITitwmEdm7wXLcbS9rQpVz9qo?=
 =?us-ascii?Q?PQL7yn8l1KrmQcdieCubf+1M34fSZVaDCHAfyV3Ae6rol1U5j5/hFQ4fOgQj?=
 =?us-ascii?Q?Anb0jMTx1A2Zck9EkbRr/SQSVMPcSe88ReQlxkwVS0itufEbcMQom9t+dvbX?=
 =?us-ascii?Q?vU4sI/t2fNV7x4B0G7XW7ZaejXrF0WnDwLk+jWa/lVnmyEYAcH9ye9AXIJ/u?=
 =?us-ascii?Q?D2rnVEnT1zQcaxMvNMJGVJ/8MNlKT4i9l9oRaznY4QmWQQDsvtvqhs+5l1RF?=
 =?us-ascii?Q?KFbv9IvHKjG9FEvKHerJLbCYvI+2VXd0hYVxR4z3Qm1x23ZZlWayCIXsxdjR?=
 =?us-ascii?Q?WuB2+wals7QtlDBM1a8ftVH2qixcsZ3htE+7RqgDoi+kx/dLoQsjPRv3waiX?=
 =?us-ascii?Q?NefFhVGs+NHXi7rNZJM4Fvek9pr52T81iefkiDnWe9q2sPV9NH9akSeNxjHP?=
 =?us-ascii?Q?XQih81HpWkOKHeP5rrxBTlOUymzKQFqEkZaRQSbUnZg14DZpLGXsP/boXdFy?=
 =?us-ascii?Q?EiYEteN0QlbV2VQSAIxQuO6J9wzr8+yeypRtDi+BjncYv05PaR4aRfWtTw0M?=
 =?us-ascii?Q?yS+/bIgrRDlyG3h3zMhrjx6dL01JTGBJMwytMIrBijUJ3das3wbGCovD3g9C?=
 =?us-ascii?Q?QOrfJ6bpz6lLJJ8rnZnalT572ZIa2qRPXB1oe51S4aydXmfQKY4zlC+vjlAA?=
 =?us-ascii?Q?ibd/f/df8sfsA/9wk5nLTnijfBafXV0dU/EOooiv1qq09iyahi5qRPpv+q1c?=
 =?us-ascii?Q?3CumL57cLt+L0OJ1embU1W57xuizmWboAaEMHO+1HrcTGvHxF3g2IHgs5Py7?=
 =?us-ascii?Q?D7mXPfq54YVrWVwFj8qZO/Vo96PQtDKlfScQrbmeIzhuFldEmsF4FkMtL1Oj?=
 =?us-ascii?Q?/yR5DVHcvIsWPhRR8cvKCG8Dpj2LgVwv2R+nQHpBw2wVkOee3wBKCFG9Vvsh?=
 =?us-ascii?Q?YxYg7LlTR1mY1KzijjlvJvv7R9jYpSaHblLSLIwnwmkCwrj4Gu0Uz/GeQNKd?=
 =?us-ascii?Q?IwWVWLH0lyaR4ocDtmF0vsePvwz4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:27:14.8005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e70b9d-2d0f-43e3-6882-08dc7e617cb0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154

Align the whitespace so that future messages will also be better
aligned.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 include/linux/psp-platform-access.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
index c1dc87fc536b..23893b33e48c 100644
--- a/include/linux/psp-platform-access.h
+++ b/include/linux/psp-platform-access.h
@@ -6,8 +6,8 @@
 #include <linux/psp.h>
 
 enum psp_platform_access_msg {
-	PSP_CMD_NONE = 0x0,
-	PSP_I2C_REQ_BUS_CMD = 0x64,
+	PSP_CMD_NONE			= 0x0,
+	PSP_I2C_REQ_BUS_CMD		= 0x64,
 	PSP_DYNAMIC_BOOST_GET_NONCE,
 	PSP_DYNAMIC_BOOST_SET_UID,
 	PSP_DYNAMIC_BOOST_GET_PARAMETER,
-- 
2.43.0

