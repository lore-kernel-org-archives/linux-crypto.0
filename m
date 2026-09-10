Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7173D568FBA;
	Thu, 10 Sep 2026 17:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063072; cv=fail; b=b4kBGoGe/HgyTsooC8Ki82bRcHAxNov01PIpAJC0iw6UaeidLM21A9EpP03YL51f4P1XYg5FKWfMSjJw8+fzQp5Y2qDv+ArzQiWYEp6dweGxTnBKk2qNRIG9oDLncJxVLetX2+soj2B5gVQbaAnRDxvhdILji0IqO1cbWkddPx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063072; c=relaxed/simple;
	bh=Ge9j09OItfl39sMD0+R3OKL8fXxzjj6qvomlEshNfas=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hghoFhUm1bjJ/JoDjAlw+FJ/J8htPqlPFW38XSaAoSpn4BOkE9QhFYZcimrk+wp/oyEha6gUg+fVXRLQpw+kHS3Je6vNMviA9R+hbEL6RcR/YnKZSUTu5Ni4eGtjYU/p6vYAZHVjxVqavmAlA+IRSJMbentZ7szSYGLu2H0W5NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=MHaIpFdd; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=d2yWebh6; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="MHaIpFdd";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="d2yWebh6"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGGGwG3546639;
	Thu, 10 Sep 2026 12:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNX
	uQ=; b=MHaIpFddwETvqHutPMmGlHlSByXGU8+jnHlv2k+6fIyI519b+XJbtmjEM
	zFVaRYf0siMYrrfnf9eeJ0DZ6kIAr90kMtZTArvf/KBD9ydZNKmqCQF2lq74LAAR
	QM9LseVmUuDq5TQynYeF4AztdREb6IeC+f5DaEDLCSEsCr/FTbBoXaQg/WMizMy7
	nymGnwZGt0vvAXune48KHjqhbIWaDJWZRp8QBT/Z+tlTBJ411u5hmcA3U1c3YI8D
	Upo+jHYn39VvfWAJWFp0D3hhJFtykYRMJhmfzDFAHhqbGI7m17hyYL43IcdtVTBE
	h7ikYIDsIPD00JUzHab6Ff3gbdKxQ==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyx20n8m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbNqq4JyGIjz2qccKyuXAgadJiQBM1QzfqALKeAhBSr9kMzpNLjWqdfmkZnmk9+9X23YSU+IZ/y2QYFhQANtrrn1G2fpLL2LfIg1GabgZ9Qxhi3IujocjxCmyZJVhnqbtVP0YcE2QdUfI29Ozuo5PwqyIYXtmtjh/L0aPUUGX7Uj4Rh5Tkd8E0AaLHPHE9OwMgX9MA9uccxcZiCq+YhgzbTWAun0hYUXiFHsrhfFfD2ljq++NCDWWCiJ4bD59hgeYsaUHdyJZNDeYS7kKiTi7cZQIvYK75u+14/kvadk+G1xbUSNnsCWJKYKwFhuK2MZNmlzDAPXJADJxyMIzpij7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNXuQ=;
 b=i7GtkcwH9dhFcukglFUgtEu0iqR7/V0Rk81bP0F4XlvsQqU1QVrWwZCHInknQhbjdieD09O1CbNMqeCONJQFUcwBQqdGbsr62LtazIDe1aXRMuZG9oOmjk5kAOqL7y4iCGgr8Tlc4avUB+8ZjQYH1h+tnnvgSJLY6rX5RzY4A0UJex+AgPUw9FUz5LUm3d/LZcKOer02yN02jMzL1/0ogquFjlIkY1nJIeOMu1nkwet801SguM2dKOK6jMgYoVgc1fs8VRKTIXofBCb/G5ALc/ZVJlhYHYNcXHQJTKX29WlhK/ayW8FX8B2qZoIbHC79pXEMUK+atzDUQlnmTQCh1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNXuQ=;
 b=d2yWebh6rk+nuC2LNNss+fF3c97RKUz9fC3JzpfkbpKTHO9qyqa1btcA6SOimk713+4StxgU7b4wL9a2t4v/jfEolV+BRmFjJyNoj4ZaEeb3Pp9MN3m8jj2K+vYEbxWK/Yveq70FxQ8+nwoSDWnKEoLupwrObHiTuNwnOi79oM4=
Received: from MW4PR03CA0062.namprd03.prod.outlook.com (2603:10b6:303:b6::7)
 by DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:57:42 +0000
Received: from CO1PEPF00012E82.namprd03.prod.outlook.com
 (2603:10b6:303:b6:cafe::4a) by MW4PR03CA0062.outlook.office365.com
 (2603:10b6:303:b6::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00012E82.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:41 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:54 -0500
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:54 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:54 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHurjB3763781;
	Thu, 10 Sep 2026 12:56:54 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Thu, 10 Sep 2026 23:26:12 +0530
Message-ID: <20260910175619.2122149-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E82:EE_|DM4PR10MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: f6e492e2-f4db-4b50-1059-08df0f650247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|1800799024|82310400026|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1AAczsJxEpkhc4aDgddjCfp6D7WxAxKJWOhSBYRHYwavwmlyN7Tl+XBAWH6LeHEgUW072CRVwIJik+OOHrMW05Tq+80OzEpjNgqSk6/Z4cRSE4SGFH48N6/hYxTffok56JevHryV1xwXkNtb3n3tHOHiaoJOlo+Sk6pIbqzVsBNh/xVGH7X9lJgiBxUhQ/rItnYSbeCG01vWREE00Clst44PuiRZxCxt1CpofIdNKbUw/Yb3ybNTbZ5/nriPl6vkXv+DqaCrN5RdXrfenIA+IrFnl7IwZaBEV2ovJtYqQH+EUvqcpzEswabtY8J1mgbqwVkgGRuD+6fAgmOrxpho6XNKsbosFzOr9LSpCDQo16IE97yglpij85cOd6R4tOogJ9UGjUvyKuNyPBJ2KTLYufq1p+XYfiTdxWGTcUobycPySwXHmUxBlYrolveg+uc36wfY3YK/hN+njYtG7U8qnp5dXV7REDRoHDQJD/FPna1SRRW6Gz6WQjzcK5sPMVawxk4zkMfOMTUgD/6sBTpV4WC1js3P2sBjp2amBodo7iLqwztkZ58Lz48VscNiD33qv2hCiFunx9DL2wGyTRNS/pI8CTj/U/fQjuA7E8u6F1YlW6HVUjRdJdAnoZmsbBwf1ZnwiSvwabBrlLtQ4vU9f9+jAHOm0bYnks3DyrTw87oyHGK4Fl6FoMFMdIOBpWOL1RhVdjAfA4kgbYMcmerl8Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(1800799024)(82310400026)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X3oedpm+nlJUWXm4qML5lps05bBJjn2AC+2ajXFHFto06R1q35HsHojdMibC8qysABYJDys+JQ9Vn4NommOwJSOGnT7ahewaogg+5Eiktrhf1usXM6NQXT0ExGjVuYqeKbmq6ttyBV3d1Dmp8uCRhX84KEuXzot/IVRxt8v6xjP4axcSztUTdpN4D6lxWVzFIa5MV/8NhDJQ076G5FGucM+yGn6bGGzByrtEpNHUM0x8bZBcZDzokiYOBVq4cINrJIqfE0NxpMgjuDPOSw1lS7gMvaNqsH2k5UgKwVrajRlvBcwVBRvWLV2WLCd2OkN6JGiLycLf8NbNANZs02FqgvMzliODdVD+QR4+Fy2oJtD+/Aw+ZKRdM1ip4KxZ3ZXwCqVY316bxw05IzRDboSzo6STdJgh4Z1YWqNr/GIE6+YmFlm3bLj0e1Y5yuMeP77I
X-Exchange-RoutingPolicyChecked:
	Dz+ofApcIy+I914ISu1UelbeiC1ny9lWcJicdi8Jf9ChZkakYFswb9tZIVk/4LrlAqzSV3442fqHyUAYOZJu52BPT5qrT+Hpx+R6jK6b07B92hhbu9k60Wh/ZK1Vh7k84IN5wPNfWdoICiM1UTbSgcI9fUE+pE7KfeugThYgLEbDVQysGZlHn6joWIBXIq4mEQUCVyH/BiuhbAwRqGnzSecX2V1XZu99b/7fv5/hP9OIIyk8fG49BURBBPHIrO7Z35hOV8BPH5+N+ysgUPmVTr0NS0WJ1yxbkNhdYjU5NCKvbhNpbnuzauqgQ94CDHLtkeMLvBlQylyJnkgiiY0zHA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:41.2859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e492e2-f4db-4b50-1059-08df0f650247
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E82.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7505
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX3DZIu8RoQfJB
 lKjRZhStBaAgHQ9YV/5sdzKPv7CZSOg6/7goWdsM+z2MzQ3FD1jCEOim+XE06Gz6PRN9ki1LyR2
 3F9PoYMerjNSwWPLwJKFKxX2/bGZ504=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX9H4ZYdsizDkw
 i5NfFX68EIEpIbVQqqZf56WHlXTDGUqRUvmyAm2p5uQiztzDU6C3fq4tTR3lBH08JqFG5/fyX8W
 P7ejFkvhqCVlOP5P5G634mUkEFtiF88nIETCngGLRXRFahXrhFmqeLWBOO9ga9rcqb6TmQpW5kX
 fGNxeuumLIz3PCmWSWL+7fiFJqDRU4tgT+qXCX8NdB8Oi86xYwrf0M1sL+RNY6vGwmrhAGd7MkZ
 s3q1qR0LuQYldNXM+uWDoJu3jBSIuOPPJ3d6hnarbqq//s7zDV8LcRwfg9ttCuvqZIXP/QY+CEv
 dwdCZe2jeGAkGLuHqkN9aDz/3THy7p+5cFczM1mhJDMwIbCqTg6/S5581lulYqCrevJAPW7z86Q
 Xd8wgR6oxfbzbDLNgHjBdfJo4cUlzWrOhfdtEDN2h0xhBJy4nvvTjKbcNaC9sQfMH0HSFJJxvsW
 WcIWRUeJAzLEqXfzyhA==
X-Proofpoint-ORIG-GUID: TdRodD5KzURB6FR8Sj3DtWB6endV8b0V
X-Proofpoint-GUID: TdRodD5KzURB6FR8Sj3DtWB6endV8b0V
X-Authority-Analysis: v=2.4 cv=UJ5Ijyfy c=1 sm=1 tr=0 ts=6aa2ef99 cx=c_pps
 a=gX39by8dV5dKUPXqjYrUqQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index aeccc235cb667..bc3591ec58a1c 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -510,6 +515,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

