Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A382C4119E0;
	Thu, 27 Aug 2026 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828328; cv=fail; b=qmM0SxZAuU6el9CTLW0cL2/NmMHqfTf5tYM89ZVOQ8tmxVihbeylOf8VCXIt8dgEMvDaYwDjGDeeK75ZWeMgcMkZuFfoElhDqpTReoOJr2ysMoU5inv0Ml+0ONUD8Q3FIatHFkA1jxjxuO2snY1p8AbtPbZerQiO9zLgUfrTzyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828328; c=relaxed/simple;
	bh=77QOSfY3LDrt+RqKJDh8Y9peZ3KDrmLxDPni55YCN1k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpVYpoxs614psTGbSzBrsZXwVUxSpSzD0lpdqVsGmdz4oqEEOwOCBWky4o0pYhP/ajqjY42/S7r0GRd8bBZD0OwC9wqEdTwSfODcn4+D8lxgrjgGlfn9Ee73TXNIi+B18Sg8hayuOmdqr2LBXQFAjEgDV+h0oneLrA9tNAO8Znw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ClzMld4W; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qYuhKkBB; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ClzMld4W";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qYuhKkBB"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67R9Gxfe1734818;
	Thu, 27 Aug 2026 05:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0gmQABGDkd4TnJbpefbFvpr2MnLf7Y3mgUK3YYHe+
	KA=; b=ClzMld4WOzIeaqO3EMBIDsbYXdJMDC46vXnbbB9niA3J3SeuYPc8ra/su
	B4ji3AgCpET0YPsbEhNt5OrD9iPZZWgo3RhTCvh06tAS7kW+PJdJpfS+yC+A9pdo
	IL/ejlp1iTtPZaQMK4J5thyP0rMq0OyN3rcDXjLdtitaNoRAxNjIkiLN9z/lAZb7
	hduliDWcAIwgeTtP0QR3ozHNWBozUTT3QkvdV3Gtv2mhvfVAJwzALkYz/EMOHf/+
	ad7T5H86xy8AH8JMumZZRRUu0ItUtgZmqZXLHIFHJUG7Ki0E2Szzu7rssoUQP+T9
	4nZwOmVah9j7Eo6Z76+tJcFpsuFTA==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gad8sa1gh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 05:58:42 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMs90VvOZ+5W6mWOjAPLUIqXrnq0XcsJ4BufuqhBiiKxVuTR2X/fYq8cXyehMVXmZIl3QdnMimJk7XLY+yVIPNVUeu/atn2UMUaW0jflUVUbKJejBAzdutlsLogZ2kokft89xLAcDpSHv2klm1Qg7oO++3o2OpQZjngKKdzfYuyoUdizxLXORzT57sGjme7p1VJJNJ3QDZ/AMQKcdwOg7N5t/UnlqO2Dk16pgj0Uktzwfoni12fA+vKBpRE0I09LumtBtpFnxWHRujSDnkaJ+/l4MeUFMrKdv5ldR9b77DIkXGFRMfJLsXq1GbNZQuyx8YIL5VIgK5Eir56ETv7Ybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gmQABGDkd4TnJbpefbFvpr2MnLf7Y3mgUK3YYHe+KA=;
 b=IHN0rnYwJ6ccgPszero6wKXOmySf9sLzDEM/rvQbQDlhK8R/LhRq3mjyAWtCuoUB/NDeZ+GvK2E/ARMlEW+7uFCpbOLdFgAQysiSidAYAS2WVgCQXdimoyXmyEO6vub2nlNRIT+cZHx+3HzdIeFfa5kKNEh4KKv+X2mKU3S0pIb/qE4d9Ivm7i9wfLJs0fOoUUuajD+Qq4eaD+udx65ntauTFcx0YoPJ6LsmPlV62jssNgajNgXEvDmZ028C+wHDrFGR6NDeem8w31jjmOnhL53QzhYCw550fFck5e6RxlZHVyKvwTxmD+hC+uy+cl0RQlVpNHF0p+a0IU4zgPyp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gmQABGDkd4TnJbpefbFvpr2MnLf7Y3mgUK3YYHe+KA=;
 b=qYuhKkBBt7WIDQsGNiwTMkxCzNfTfxcq3zBZCn78Fg1BRQcJBoXrLEnuHFld3PdTuXJLhJVcfBUi1lgzRUue4M019VO9Pn3tknYnDIBkvIdj+nwBjVTR5WSDN8JbDh5WPaLbjvC5tuDVAMhYeRaoYNhGOGyp+G7U0uke1aU+wMo=
Received: from IA1P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:464::7)
 by IA3PR10MB8705.namprd10.prod.outlook.com (2603:10b6:208:583::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Thu, 27 Aug
 2026 10:58:39 +0000
Received: from BN1PEPF0001806F.namprd04.prod.outlook.com
 (2603:10b6:208:464:cafe::60) by IA1P220CA0023.outlook.office365.com
 (2603:10b6:208:464::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.9 via Frontend Transport; Thu, 27
 Aug 2026 10:58:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF0001806F.mail.protection.outlook.com (10.167.245.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 10:58:39 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:29 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:28 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 05:58:29 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RAwRh81731153;
	Thu, 27 Aug 2026 05:58:28 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] crypto: ti - Fix potential deadlock and allocation bugs in DTHEv2
Date: Thu, 27 Aug 2026 16:27:08 +0530
Message-ID: <20260827105711.527182-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827105711.527182-1-t-pratham@ti.com>
References: <20260827105711.527182-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001806F:EE_|IA3PR10MB8705:EE_
X-MS-Office365-Filtering-Correlation-Id: 57561062-2014-48ac-f7ae-08df042a2694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|23010399003|82310400026|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sPKRSVpGV5x42BAonKNnP5Y84hDgrJyQrXUFGruRbzO6CLd9pUIo6l6AZWDuAhiVphAfBdq1iS8YNiWIbBjCwfHFiIXzDOp05yfMUnaJmjsEc/CixXrAbBWPnMDYCq+E1eeu+LZb9dPNPeW5qQrpn+NMLGD6ldzMkMe70DPVWDN59jGZuJ4H3iEsALaxmRamGroBfYEiEk09LM4qkygruLrfLEX6g53VtD1LKF2sq74pDnt9e3j31RwPECINCbRKLnJxEz6JVO+HDNfrAM87TnRdeCIDHUp5DQfuLgUApHXF79J0l+xkc1hkIqoKEGJtetpjx8QsiwcoEz+7f9qpyFSTb7Uo1Rh6w0aWINOiXrYdau4o55ZbmsvbwjI+Ff8+cN0jVNGZqgRbRMOdu9cy+8xrj9XULArlmXAvEBPLO7UbJhuwMvHH5v6niYNWR+rS78Ots8E5JM5nm7YCrSnglMn43jGoYVKUBicxEMGnRV/WeY2UKU/yWxbj8Ex4c9SMy0I2Tdgty0YxmDNsC+95KdZZMux7eVqbx1AKU8Hs4nFJq8A4Uugp083CfzLwk13cy2RUBzipWbfQFpopqYove0NAuOvAWKtQTYidtthN8BPIKjL0Q/H3l3kcCF7LhKsRr7eUwCDGj5EKKMJjZOAV4Dc70sJCQvvAAV0v1Jz8eQ2jkUg5bb7lLtvdNyxkqGB+204CXU/mzB+YU56R3HVWlw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(23010399003)(82310400026)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yDA1QVmHutoRMV805NOeTDho6knJoDpBTgPIME0OrLmra+QBvyM3CUJF3qc8XFMzPWtkdJJwsEQLEKO2/FPUIFExPNP/XvS+unN5j40v3XGs97GtKvaY21Q0C1ePR294weEF3g77sNhcah6xDfSv9qM1j7WO//jltUCiJZZvQ11ivKt2iVo0DUbIor+E0Qb0eJvt6e6hZuwbxeVmM0MctJVMZ+HXM/hprlCeOcUfQQAAoGxcpXXbQE8mLor+rTD9336tpe7g5jVDiyXslxCi9vre4RlJ49kIRCCM7qvdQqqcQ6cqMUI0b3fd28R6LXrJlEGz+kgIdIyzzM4NvdVZiXrGGNePN/pUW1ug9Tw/HI3zdCOUulVkfxXadWnweReB+LaY2z1XKEeu3xDLq1PNwhG7k5hxFQn/d0P3MqzDwXw4Uqd5gOWGkJEXTfshNN+p
X-Exchange-RoutingPolicyChecked:
	oetmQ8/bgLlVMAivVuTjaKlCtIpVGz5fCBuj81CzkkCNRCK5tBwQM8CJS9hP91e6mnWwL9BZJFfFo4p4pkjmZXdAcyHFWwkV2Inozb17iAKx8OjdBgpCUPZavZoITVEOeUVBjkyB0VicQVcWMjwaSQXT/zdgA+gg23y1fD0Z0Ky91n/CfcINury+x/mcbw8lBjrrX8ZzoD98hNsGjkQQfvh+ogCXGZ/u83WGz3GqQoxSoR9rdaJUl0yzBTErbViMlkXNKJmMlcornCBhOWJ2S3wfyx473DnR632ohVzNuuzZ9Jcb4Udm6ihjVHJlKGt6W5KGfBeAgrqpV5lCvtIrcQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 10:58:39.1122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57561062-2014-48ac-f7ae-08df042a2694
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001806F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8705
X-Proofpoint-ORIG-GUID: Ic4YTNQ2uQX9FXR2MCe-Z_OVn_2WM99y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX1IiZr0PeCFoc
 m+bP+OOT/tANcR6g64xgRj7tIDtMidVCB3pFMOIPEKnq+QtrTjCE1CKd1sVVBr3Woh49Q2MApgC
 jq8KTDYXKY+FPBMjI/OaBhN7AbK40H+jg8MMWnr0/s7KZw4QiDhwaKiLDFuKgSqqg3eGIXA/JQ7
 QEoAppdRqPELEe0kCgJMh4lWcwiqM0M8muY/EuSXEvvRqD2/85TD58jyK0Sq2uLwb5kcQvLb7OX
 /tN8QIlo7gjeYyYjas4eyXvaosR59OMMwfp2JCbqRGyLq2n1ocjT2tajShcRT60z6WsFqAeasWm
 jyqshBAGv5rZ6ze7Hxx24UONsvN4n8X/rNx0aGAHBCTwBPtqpoZ0mHnhZpErT8bhRy6Ng1fHZ4p
 Qgn+4uEfoXR3rqTzVz9MOcxqk4kJ8IWJza6IyRqSK1rPS1llfs/sHYMAZiDL1YRBPvaYfVOA+L5
 yv5G+rhRdNMCRZhgCuA==
X-Authority-Analysis: v=2.4 cv=TJ11jVla c=1 sm=1 tr=0 ts=6a901862 cx=c_pps
 a=lq01mLAL2wBNHDG9j+U+0g==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=rJ-GU4aWsYizkdYqeIgA:9
X-Proofpoint-GUID: Ic4YTNQ2uQX9FXR2MCe-Z_OVn_2WM99y
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfXyl/Y8t0fDL2B
 ttywRUh2RpnL9nsfVNbQWgfCucC1ESM1bc9ZdY4l2f2PmidxRHN41r3Eugqjr228gG0XmyhHpZC
 ulIJtzbq60pfjAJlGg1WjyNpPhlVDm4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270090

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock_bh to spin_(un)lock to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

De-register the algorithms before removing the dev_data from linked list
to avoid any allocation during removal.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cc02449382673..b315c850f05d6 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,11 +39,11 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	if (ctx->dev_data)
 		return ctx->dev_data;
 
-	spin_lock_bh(&dthe_dev_list.lock);
+	spin_lock(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock_bh(&dthe_dev_list.lock);
+	spin_unlock(&dthe_dev_list.lock);
 
 	return dev_data;
 }
@@ -201,12 +201,12 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
+	dthe_unregister_algs();
+
 	spin_lock(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
 	spin_unlock(&dthe_dev_list.lock);
 
-	dthe_unregister_algs();
-
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
-- 
2.34.1

