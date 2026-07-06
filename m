Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012067.outbound.protection.outlook.com [40.107.200.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C4396560
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335802; cv=fail; b=la/9ifqxzNxjJGdd3Nhi308fnEr7kuyKDL6GHAjoeFmrlmH7P28W3MyuKndh6GPKi2kaNcGNRSMAGgZmgwvXmfIhU4uCRzY4iAX1ZwR6uTnvldXge6Y8piuqJHE0qjpJ3oHirx1P/yXq0ooGHRxfRK5NEEE1lz3K4Z/grVZM3So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335802; c=relaxed/simple;
	bh=8+qCQFlFOxwkb/mA7KdmIvpWACe1lpDXKC3idRhNI3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=li6B72i7NCL242kRsjflVpDx6TheNR0lmSHKyjKTm36gGBzHgaYOrRmWH4udnsOE/UTydlL85yYXAMhiqXDHkWT/KbAktODHaiXvzlugJdvSjwhEGMa5qOnl7q0/Vdu1dfNRnrtbI6VwgwHcLtQVi+6BiXVB8CRC6mW5x6TxiiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d4UEK97l; arc=fail smtp.client-ip=40.107.200.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d4UEK97l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgaSTTkJv3pWtNwCVnP0ksLwFP5vPNsT5R0khUY51GqUUpCVehSNctlmLiOpzyrV9vjy0JSd2c8RsX1u2WZiCByGADiOm+ILIXEI2KzV1opGDUIVeMKKncbNXun5DzLtQQ+SEH18Sj9CcHq+17VcmmGr4MwLFmIdgJCw0AXMuQY3RwZz7bLNh80XYK5mCk6D40IexXwBe7KTaeldGkpooK4Kue7se7UeCza1uXY96TcCevqeKS9l/9HQJpAQZrUJM7ROZjwxQ6tCegSmZc4N3LjUtcUTGdzjq1wqjsIWMw43uT3zgIua+oLb/Eu343yPIBYCPzJmYCWmxncBiSsX9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+V2WChkzPs4dXc8Uc8ZEyB080XvXJjY5Yq3Wi3/R74=;
 b=ofUaScI2tLHD2YFCcEeFZjyvXwwHm1Nr7AhznGapTQZEw7JnwkZJuaM65heopEPsOhzecujjVi/IHpUkvCqY2gUvGn5Na8sVj9B7Kj0c8ypJ3xSUEQrjMfLEEp25LkHSejM9w3HKMsRncNEneK8V3mQrUT29Lv5M0uAskGMpod24J5B66srWeBO7eplyU4FYcm8wBO5mdGYTKRLrMW5/IP5gCW02D/ad8sOwbYFy6WqPY/rQGgDidN3MnBapeOF03QvWZ/xXduZL7xB3/H+aRlXHwu7IUn40Lhigy8y9i71LG+oiitEi7Rt3hSnSGI0WXK4idK+DUUNzVg1u18XSMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+V2WChkzPs4dXc8Uc8ZEyB080XvXJjY5Yq3Wi3/R74=;
 b=d4UEK97lixbjv9031Ls6DEsOqBOSxtAtAtKmw+BjsRY45VZPVgTOqOxYOBx9Q8wESOJpx+lhDJfB2+LMN82KPh5VJpcQ+9rwS/ojEk/oJMn+/NDvtR0EU9nlK6tthClHuUZIGjoTxpW0Y97H+FZh8vwLj0zhFUNI3bjXWNEd7Sg=
Received: from BLAPR03CA0125.namprd03.prod.outlook.com (2603:10b6:208:32e::10)
 by IA0PR12MB8225.namprd12.prod.outlook.com (2603:10b6:208:408::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 11:03:16 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:32e:cafe::9c) by BLAPR03CA0125.outlook.office365.com
 (2603:10b6:208:32e::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Mon, 6
 Jul 2026 11:03:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Mon, 6 Jul 2026 11:03:15 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:15 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:15 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 6 Jul 2026 06:03:13 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 1/3] firmware: xilinx: Rephrase documentation of aes API
Date: Mon, 6 Jul 2026 16:32:52 +0530
Message-ID: <20260706110254.2427551-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706110254.2427551-1-h.jain@amd.com>
References: <20260706110254.2427551-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|IA0PR12MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: 56cb1085-5369-4ed9-2fed-08dedb4e2df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VKx17OplpEs5jQ9uy8M9KYCrr4fCcW1fO26iRh1N+ufq4fqpn+iLj2G+JBMc+YH3MeMy17gbq4WZqy6IMk9iS+Z2Yq+6KC0I3qqfDLZJJXSDKeb8Clo7beQmVJCzwRBpGmj6Nq0LQsQ8xbSYnGG7LKNCN6T4+lu84cGYVHPYRmjHXzMsKRWJ0fq6GUB7JaoT3+i4gSiHJMfQTYVizaA6ViseAynfZWfJmbHrbyg/qSwx5z9Ud4H7i+73IFZruQhPqu9e55BcKw8gE6a5kgA6V2vdwLxoxmF5k1Cb1gl/uqBu9tgzgj96KnCeq3BleboqrMUBc0POhwMAhpNPInKmh5auhzHkJ3DvvSwEDI/4mBcs2J6LG395P0YEU1fDmwYUrRLsNzBRu3r8omQJ9/DfZNuoab28guD0aaNKfG8DHij5v1tb0esQwjpnLOuDMbyjpHlYbyTGxAe8EciwX9uGH0W9fDma0hVhx2PMqNTrWua7fxXPT6d6vkmv3VW0k6YXo9UQIEtySj+Y1NHS3I7douo9VAEl+SZB3I5Rn8mJn5rsAwrmsZ3U0wz91a0SI5MBs/yqownWe+Ma5Vzs7JCkxd9vaGYK62+zFqgIYI/gJRThHYdlHAGWzAhdZpMMQF7b+hY7POYGe931zGCoFLjBBO1Dwri+2i1rkyLhzTO+GB3EU4kwEtSoX7iK9IdkueQYbL9p3Lw7I3bkBGcbQxwhOA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XDGE97Bh+DGjB0v+jdNYjh4dFFQ2EgUOlkkx6Y3PeipHrEtzBqx73s4MyBgnYkq7LZCX2Lj+nCcu1qTVHC5qPY3KJwuGCjwWb0a/3tNwPbVVvo5Hi987X3v0WjQZf64RA1YvfFeYuxVkEqLGVg4RWEHZMzREyf16GZpDDHGCuZ/UX/Ga9NYxnzPiHhNLzzsamc14rx+lRQ+IS3BmMEgd59+RmK9iZoaEX/XJB60raLqp+l0cfqM5nG4d7e1QR3AjwahySACEMpev1K5KMSSIDdFG5GipGOK8Az4tPwNM4hqqEbcDJQ0kL+DICFw9UJNDOugmxpGtWMnbFr06j7IAKwGKo6j06d3m9GPGjnsakZhGnuSqDsIhvRfwqh7tv8zUjzNpAa4X581g44Ks0HR0tuz5ZJ8Yz2vQVP1LeT82+tD06NfkdyqOede5I0v0P2Ki
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:03:15.7663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56cb1085-5369-4ed9-2fed-08dedb4e2df4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8225

Update aes API documentation to remove "+reason" string

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/firmware/xilinx/zynqmp-crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp-crypto.c b/drivers/firmware/xilinx/zynqmp-crypto.c
index f06f1e2f67b8..9ffa14d83377 100644
--- a/drivers/firmware/xilinx/zynqmp-crypto.c
+++ b/drivers/firmware/xilinx/zynqmp-crypto.c
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_key_zero);
  *
  * This function provides support to init AES operation.
  *
- * Return: Returns status, either success or error+reason
+ * Return: Returns status, either success or error code.
  */
 int versal_pm_aes_op_init(const u64 hw_req)
 {
@@ -229,7 +229,7 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_dec_final);
  *
  * This function initialise AES block.
  *
- * Return: Returns status, either success or error+reason
+ * Return: Returns status, either success or error code.
  */
 int versal_pm_aes_init(void)
 {
-- 
2.34.1

