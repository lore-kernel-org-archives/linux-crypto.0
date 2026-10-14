Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043D751FCCE
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984213; cv=fail; b=J/KF/UzFZnDqpwQEMke3Z8lXVYWb8J9uTSQvixTrNzaHhBTqDP0y0UwDLMKC5nBVKZBDG+74UJFQZV6cav75wtdcYCJ01aLZr+0NxO/dsPVhY2s+Dv4VyQXoc9aahlTy1xrpW3s+CxIYHUBpuUqIToH6azvojDrU9j+Nyn+o/oQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984213; c=relaxed/simple;
	bh=NsAKIkZYYrue3eV1qWm5KMQ9c6MD5cAFdo6Nfg46lCE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIdV6WD61XEK40QlTkFxyL/BvheoYuZ7SxREcurpGo7OQPuSv9RJAXNGtU0/hEaIubbP8NO4d8gK81n1wZjLhleTHWG7eidNt7o0abEzHN0o5wA2i1d5YjVKvVFOWrjblp4GhtBbsljnaQzgXs/QtF7S1z8jntY0J3Fia1fIDno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uM84kD3m; arc=fail smtp.client-ip=52.101.53.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uM84kD3m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ft2YXHMK29zkRvxBkmScNGAPukazzu8JrAkU4INLPB6w/LTvPgpaPLqMr9AmL5Pg4ZsNbtyI+ey4ootAcj3kk/S53X3o8ftwwi0YUGfcdHN+1fvwh1YV1vNvtDWWjxkmzAFi9dsgFAsx4MXXdlVmS+HLHcdnxJ7nvEIqXO7t/ZJ5fZlnrGGL0Vz1PUjp80Q9YCfqpnfHPT8GOlA8+WDmwTOfGTO++cXD1veanN81iIJxwzOR3faOgwB9HOJjXW05D434MRnU4OL+HeQvnlnSoly85UnlJ2a//Xo8b/c0UX5QgGksm7ml20I06TcHmh3DE77BZ0Vi2TL0QOlwOrsqYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNSSL2XUejToa/5G8x8nDCpmH2FVIRYYbizBxX6skdQ=;
 b=fSdazIuEFlmjIY2dH2w7rxDlXRFDOD2Zt65Nl6QSwHsVV/zmnl5ct+GyABA9NS+g0kVngp0bwSOreFqf1Kp4T5M2s7A8/011SHjnzdNcd7A4m+v6Q+W2PPaF2Bhgc5vs3gMDg5WgdZGBI2ra0atW12FTCqP40w1tXZQWB8pYQrHKWnefCUw6Cb5kHwmbJ7BcSI8UwxjvOvIh8EJmLCzjg4W1C+H/tczIQA9TCd7N4QS2rzKIrWTUNS6TNXfUFgXSiyIKXcq8eWBqAzVPz2u9I/TyX5fQJl8SMeydMbm1KuMqz+gn/y/N2gZdnkk3zrhun1MwGuG5q0r4NIsPyeUdyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNSSL2XUejToa/5G8x8nDCpmH2FVIRYYbizBxX6skdQ=;
 b=uM84kD3m4Vkooq/f9aluwXvubfwUhk6qMXcK1PmoYixoBqBIlMtczLotRNRAFjNytf7RSkyowNuNtG8MunCzvW6IpjoD8OgCKdCiAuWdsdAgIwt2AjDRuqiheoWqFY7hg3DFIRXw+aM0RfMe1bAoaqmp9as51cMhVtfIXFDaSvM=
Received: from MW4P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::30)
 by PH5PR12MB953872.namprd12.prod.outlook.com (2603:10b6:510:501::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Wed, 14 Oct
 2026 13:23:23 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:303:115:cafe::8d) by MW4P220CA0025.outlook.office365.com
 (2603:10b6:303:115::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 13:23:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 13:23:22 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 08:23:15 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH 2/4] crypto: ccp - Check SNP initialization state after copying user inputs
Date: Wed, 14 Oct 2026 08:20:31 -0500
Message-ID: <20261014132145.1726322-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014132145.1726322-1-michael.roth@amd.com>
References: <20261014132145.1726322-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|PH5PR12MB953872:EE_
X-MS-Office365-Filtering-Correlation-Id: ae2b5e66-389c-4c24-b265-08df29f6521a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|6133799003|18002099003|22082099003|3023799007|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SlMQK5cNGCFlsTmi4ck4cNS+0HfJSEBKi0XRCga8fqofPMzx0ZwYyaT6In96cRcTfG9N917ZjphRRJ7h/sJEzrE6eJ2NG6XJzqrL4GYRCCC+0HzdPKdiGifcd92a7nL6w0BoYaMjfKIwjU9VjXtZu0xfPugrfyWKFCxJTmslozmz5sjZKJMpD+jSCW8vNRegILP7Oe9tLUUof2WxUEEEURS3p/bXDCz8AHkX5tuF8R1Z7VmFh2nIMwrDJPuEq36Vz47/mLDqhPJ5H4/HJrPxgkRoiDbJ3ymQeLOdnS1cry9ww8x+0484/XuJOMtEhuahPtFGZJ9U5nBSE6h3i2uFO10OPY5/sVYmeIDioiTQiBRD8Iby1zMzgiNh1AOn5ku51seiWom88o2scuWNaKZXs3N+iSiHJHrDT3wNNZIEQB8ok1IIU7ugzUD/Ir0Q5rsAotpQ3lYj5tiVAQoVz5HR1qjvMAFhVofeGc8zm+sD/uozH90qpmGKbYaTSoLFhP0Kq7f8s5OneJjeg/e9dPDOqqSG6GTwX+0VL/4rmawFxqAQDijXVvYfCFQix76QCSOYQfCkICZKCcO+uDUoXB9B/qyxAgTavqCapL2Xc6Lg42QUttpd4sVp1yjoHBIoiuM6m5lVljmo3HXozuTNqfQ1fdPy83QXZI/Bx+SkkyBRM4rjODbHNXL2lMhEZJDEnqAj1Z1OliW1RXbNZzafepjRng==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(6133799003)(18002099003)(22082099003)(3023799007)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ycQLiUAiw4+5dSLSu4JibEPeMITFTeuAeqNHC4bgmrmvrW458nkHLlA1YlNi8YYWBG+TmsLyya0dWTK6wtBnN1Mg4SMiygJwfapOpFXC1IM/iBLWZA2ijNr0JV9PC1W7tExGQTbbxs8lvQA44DzfCCjnMVaez3RFswRnlwXehBSMyuHxqvfNKWTLp89MFOHkLXvy9QRcBcmU0LZixttZnvMwEB9bUuE55GeK791T8wl4SKfRZnsHbM1OW0w1ElpxU1bbn2uhrlevYkP5ieasam4B2xHn/JtfhrYFhSa2iQ974nWC+uCTBgbm6Tr0HGLkkBdG4rk659v1vP8fNqI4Kfqv+0Rs7T+DulxfMUjZ0S04nO4ArguvXB8zDCnlfSmNmXNlvfG0J4qeRS1Zwu8Wkb4fokutlah/Zs1NV6v1ztUmx7w1mFipxSlUSqWr5RpU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:23:22.4804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2b5e66-389c-4c24-b265-08df29f6521a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR12MB953872

From: Ackerley Tng <ackerleytng@google.com>

When servicing SNP configuration and VLEK load ioctl commands, the
driver checks whether SNP is initialized before copying command inputs
from userspace.

The SNP initialization state is protected by the global SEV command
mutex. To prepare for acquiring the global SEV command mutex only
around firmware command execution rather than across userspace memory
copies, move the SNP initialization check after the userspace copies
and buffer allocations, right before issuing the firmware command.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7de3b6bf71e1..e42cf3aee50a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2639,12 +2639,12 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (!writable)
 		return -EPERM;
 
-	if (!sev->snp_initialized)
-		return -ENODEV;
-
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
 
@@ -2661,9 +2661,6 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
-	if (!sev->snp_initialized)
-		return -ENODEV;
-
 	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
 		return -EFAULT;
 
@@ -2677,7 +2674,11 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+	if (!sev->snp_initialized)
+		ret = -ENODEV;
+	else
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
+
 	kfree(blob);
 
 	return ret;
-- 
2.43.0

