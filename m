Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735BF1F7567;
	Tue,  3 Dec 2024 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242997; cv=fail; b=RzBLiyIy5g+DNsdxYsVNRNYEnm0xxREp8WRoKG9CJr4dTcdcK28u6nXN+VOWvtLIHQMfY1I1mOzBBBRL5Qn25M4NVi3FHEcvv2VihEyd9C35DvISaNwGVH9cYaBS09ui6xU8+PSm+75JcEIfBnu6KwGE6IRfttNnjZC1qLZTLaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242997; c=relaxed/simple;
	bh=X4YF9qQY7FPHjvlz2AOp+f2HLBd9zAAp5nA16Z21BIs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OyiMUxNXWJ/nRYkhTBzoEywYKBpootGSzBioa7tvTta0NxaccObC2RMMofZ+CnAIFhmcEhcvFo/VHki+MysqXwyV837SThnz+/hk2g3nDpdxj49PXHY7LvPcA2lwCRHUkE91NnAEjfZHRX/qpuKwy+LFuQrTK1O0U2XTrkAgYJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pj0q0gnU; arc=fail smtp.client-ip=40.107.100.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pj0q0gnU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYyvaewk856JuUGISmUIM7ObWdZ27o6pq9XHsI0K/RF9PErMDHLR/n1lrWIzdnyn3jf8r1J+m7ZD0eYPqsGwW2Pb38yG/86tRMRayHEo0626tF9kZmFxLA1hFUs0/6NbRPiEt08mewQtwuN/RXQixzbtPPqYzQEf0E1g4JfwglJ+CYlw4tvwjAyfgdGiR0eKTAg5v2fJpb+0UJ+D0Ot+wul4fU+zPxrdA0tdlp4IhIH7m7eBj+5HfdMlHdUxusxqGhj2fDOCeX844grfjLY2gsJEphF/o+K6IbHmbU2vlec6Yx6LnCsIN7w4DFWPsAzxsaU7kXxImVHn9+Ir9yQeWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJKTw8DoswAXgJL2hdvjZ0V+i0zVWtkZBwtbDqi4nVQ=;
 b=voAC2/mHEO1Yq7e2NKTEjtW+DGrB5Ab0TcsW2dyXWWDQ/tzWqgxAVdMKb4RHSN9evAlu27Oi5tBDd+0IXGmcWHiipLuyjhtUQtcU7ASGUIj5aq1xh+NA5wCzT77oEUQjPeIAWSxCrMXnWeVpp4aJ4Ok93J0kZOtVwOgKWDFl2qy8+UT7GHXuzQrVSh757UApJUuY5tS+/U6PaCTFA5WPlUg0ZX2puNSG2wfA3N59wVXX4lI48psME/vRBLMpb4jy38qzp5ORgbMD6OdTe46AcuehSb1SU4xWzyxsszkHwZ1bXf2bNhHptpIovaKzlsXUJ+DxHqO911O241RL1L4cAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJKTw8DoswAXgJL2hdvjZ0V+i0zVWtkZBwtbDqi4nVQ=;
 b=pj0q0gnU3tb+I34TbYKlOEGQZXUuNBylJo8/hRYeZAoTJHuDkBMGpU7gy1pWfVL0w9tBdbJZ2bwxVDnvlEpA2f3lSJbT9vnomHUtwSM8RRdQsfXXPPQVlj9bzMHbYtdUY6N3mkeX4VBeQgvn73sRXK/FnmIbpffufiBmpQviIPs=
Received: from SA9PR13CA0063.namprd13.prod.outlook.com (2603:10b6:806:23::8)
 by SA1PR12MB8118.namprd12.prod.outlook.com (2603:10b6:806:333::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 16:23:09 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:23:cafe::89) by SA9PR13CA0063.outlook.office365.com
 (2603:10b6:806:23::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7 via Frontend Transport; Tue, 3
 Dec 2024 16:23:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 16:23:08 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 10:23:07 -0600
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, "open list:AMD
 CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
	<linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] crypto: ccp: Use scoped guard for mutex
Date: Tue, 3 Dec 2024 10:22:57 -0600
Message-ID: <20241203162257.6566-1-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|SA1PR12MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c8966a8-83e1-4a44-cc76-08dd13b6c647
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?USofDU3Bx7+wia5BoT5+UsXRlxmmUknqSnfSbGCAqgimQuRIqgn0YE8P3Mo9?=
 =?us-ascii?Q?CdDWpELbhOl/eGlJxETNglyuRaU94zorWVYsSLfkw3f8WNVCq0RSzSF6xEWK?=
 =?us-ascii?Q?+/1KK9kRZzD2YPRkGNcwiusC1ZFAM7dO30VxcEPT3dxs/BpkITR4eNn205qs?=
 =?us-ascii?Q?nsbMYwFoV4njxK/bbn6VUphYTjRbH94uVOrtOdjeFkl21FmP52kl6oM6jaSL?=
 =?us-ascii?Q?KzkjxyOetkm1bDmFVHK/FDoBbhpxqtROI5rRvxl8onUrTTsTIrd6lqxjFtzy?=
 =?us-ascii?Q?HA3vwtiBBTqwlw1cRyuUWfpPOOqhJ1bSLFqQbL1QhJuhNRjhU5adGM4jI3SS?=
 =?us-ascii?Q?Dx6e3GKPSyV/Nr8ZIRgimzA4JtGprUHsbyQCLk1Io4HA+AL+1YnuVMHIu7vm?=
 =?us-ascii?Q?tG9zsDLNszpF+lQCMqPWsshcy3YiSXj+U+iOuKAfbJt6bmtTd/77bkd4hgQN?=
 =?us-ascii?Q?jUZdvxlVZPXssrzALRk/QTfxAmV2Ap0e79kilz9c4onUkj+7hp4YaJjdYc3t?=
 =?us-ascii?Q?pYM87ouPsH5fdExdbUvg7uzVZm8A8iZJDE5m9zltHgcGDIgqi9GrUe85Dg51?=
 =?us-ascii?Q?BiZTv4GHKPbVDq66o1DIN5QU+ppSXmPo3TOcxdtSbhYpsrMKHsvTkvoqPP0i?=
 =?us-ascii?Q?H1vt2ztWviwfI6FNG+swgcSNN6riH924vPCsQ5EABuKOSCzrSXJ1xZCaz0wD?=
 =?us-ascii?Q?0gVo2B9R5C6OZOdVOlTA79gsssnURVCkPDT1xp83ZMKl+YnjqUxHwlcqbstn?=
 =?us-ascii?Q?J4tNnsT+YrZCcitegItxOJR6Nmnynv3tf3Rlw4M/draDVpMXjNly77zwn8Ut?=
 =?us-ascii?Q?4ldVlnUp3lwDoP0XCFxQDX4bcK1M005hPZBH9Kb1hfV0hBz2BWYPkmMPmv0J?=
 =?us-ascii?Q?kxipaWqoSbQj3NDFpwFcesnr5BrXNnW/ldVx4QM4p565VbabghfSAw8iiisA?=
 =?us-ascii?Q?CrK3x57xY2I9idx4clnO7fL/oPyl1+TZ48JUoj4ljeeR1H3cCDS1N4/81Lx3?=
 =?us-ascii?Q?eFnuHfajCAjNfLuWK4RdMF5WKwyfgtcXxdfNp0Yt6jGZKBOkZ2bEGi7RINMw?=
 =?us-ascii?Q?LEN8AwZSA6x3YWmZZ7NVKZflMq3ix1g8zSM2bXlZG4F5Ppp5J9A6ngkh9C5U?=
 =?us-ascii?Q?annc2TS9m5/dWJNstjJyCTzG/Oy8lN1mb26wAVy9pXcPTJowtJicevEh2RXg?=
 =?us-ascii?Q?qDSZC2TB4rzkEbMHS4P4I5+7Q8c2woXNNsLLBrzlbdgcl46yf6Wrr5xOOuBD?=
 =?us-ascii?Q?rgTRs/hL/5StoPne/0etP24NktVgIqofMUyD28fzPJvsiSL9I89UoBXj1hQ6?=
 =?us-ascii?Q?VOtlMzUBqk+phq1Jf+GwRjoIe4GVC6uB31SZandWpgw/5+KBY0XItjdzmYLV?=
 =?us-ascii?Q?P0KxsoHgBrcAxd3h0uSObsh9n3f6uHPjTjaThHhlYPICgbgAoewlscvcNW/B?=
 =?us-ascii?Q?4mlbraTwH5IJlqKqw6FKj2WF+ANvHsI7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 16:23:08.7266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8966a8-83e1-4a44-cc76-08dd13b6c647
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8118

Use a scoped guard to simplify the cleanup handling.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v3:
 * Fix logic error
---
 drivers/crypto/ccp/dbc.c | 53 +++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index 5b105a23f6997..410084a9039c9 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -7,6 +7,8 @@
  * Author: Mario Limonciello <mario.limonciello@amd.com>
  */
 
+#include <linux/mutex.h>
+
 #include "dbc.h"
 
 #define DBC_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
@@ -137,64 +139,49 @@ static long dbc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 	dbc_dev = psp_master->dbc_data;
 
-	mutex_lock(&dbc_dev->ioctl_mutex);
+	guard(mutex)(&dbc_dev->ioctl_mutex);
 
 	switch (cmd) {
 	case DBCIOCNONCE:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce)))
+			return -EFAULT;
 
 		ret = send_dbc_nonce(dbc_dev);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce)))
+			return -EFAULT;
 		break;
 	case DBCIOCUID:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid)))
+			return -EFAULT;
 
 		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_setuid);
 		ret = send_dbc_cmd(dbc_dev, PSP_DYNAMIC_BOOST_SET_UID);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid)))
+			return -EFAULT;
 		break;
 	case DBCIOCPARAM:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param)))
+			return -EFAULT;
 
 		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_param);
 		ret = send_dbc_parameter(dbc_dev);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))  {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))
+			return -EFAULT;
 		break;
 	default:
-		ret = -EINVAL;
-
+		return -EINVAL;
 	}
-unlock:
-	mutex_unlock(&dbc_dev->ioctl_mutex);
 
-	return ret;
+	return 0;
 }
 
 static const struct file_operations dbc_fops = {

base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.43.0

