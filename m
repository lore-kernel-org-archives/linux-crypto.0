Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CE11FDE31;
	Fri, 16 Oct 2026 11:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151364; cv=fail; b=gCSBlnNzSj3NK59fAg78p2vL3qz/SMu1az4GSNvm9Eizrf5A51GWmFmSTeJvwQVsKeEf1AWdUsrYantixQdI7KCHPuicv3GU23Ze0DSmKnEdocKvkZZdqe17WEIQyFWD2eMCtTibBjF73zkQBpGBRyaj5vNKTJLO15/ePPdNaG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151364; c=relaxed/simple;
	bh=krPhkZUy/lYMIa2GzJ+rUFawyJFH2xWoZZ9AkkuM+M8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGM77peZcEmB9Z1C8PkgDM0arL58QPO8ZG/3TDto6o3IkRbz57ruws//svVnytrYaBi+rcmNQHPsUkJUt+Qtv43jmHzPkC2ifxmB4+1Yp1oamviC5YzUDrb5Sn/2M4TS6ZCcxWzJYMKz0mopcHhMgHctw3Ffp3U+MYHXEngRLuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=U3rXWw5N; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=NPQt1/0W; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="U3rXWw5N";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="NPQt1/0W"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACsEs559820;
	Fri, 16 Oct 2026 06:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2H
	V8=; b=U3rXWw5NJw0UA7RTq1Z58UmW0/SAy3ExvBK+yd3eS4Q1tCk/IABrNgWWo
	WFCjy9R2d/+QjmsH3NBGHeVO5mV47bdv3yO3NVDh0QsfjlpFGoPOsfJwx8vs+TKh
	gKu9fFt+J7+3+ez6FSMGII6bYSncouq5rbndgS/s1r09GYisaysXkfhnxgnEAuh7
	52M0L/OBj7ZW5hmNa5Y8oXBTRcvXd6zd37dCU76oaVA4MHrtG6xju4WFnh8FY8W0
	BvJ5qSC3H2w5dXZCdMw1wpyxIDhH/PAD1WmfOCAhm+TdYf0jC5ngxWYWNUXM3iOB
	Tk5V8Wm0UAS69mGp+5egJ7qunpVPQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8gvr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:18 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EA/qdi4Mp5f1FIqxH2HM2jqaGfUdJASc6tQs+Tm5rs4kR1vYJnLUPPONvhuzvCO+3sd+jDqsCjNJPhpvMaU7YdG+J/Uec2AWzFBYpwJldaqwFyJMClfdAJqygnYeLmt4QQSG0kMiaIW/kc84/7iFDpzRqKfdskeXxO+b/2IT8amSPYAan3VKlIXjvb3eOGTBL2Om3BXlTptGuxBK4kj6mLGV+mjzQqsA51UA/Wm1hS9CPzIDMJgehrpS2RukwOqSqIWTqq/4HxnU0s/tCbXSxtSzE23YbgiP/+iIwSHoqUIEfMlZgEf+8msmX5KZ+PDGebwbBKPkbQ05k0JjyzRolA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
 b=oLPtaVa1+P6K5kQoaB3eehywiJIgMCKWjt/8dvbvNODwlUm7TLe0ji07YBQXpFsnHxZMK4frVeKHMiabC2zLfZD/ZJx2+EEB2NFOJtVgMmlPHXIjZI7hcoiHed660tt+NECffFe0jmwr6ftkA2TAtj3eaAH18PQVNT8RGbQj5QcHdBp7vkfOzIvwNYygwo5pZEEhr5vF4k+7w4JZeQaRp/4uL2jeq4T08cSMt2YdxMzAY5U0VGcv7iHjb45mVPWulT0kNZQyMb6zHMcTB6bnnEjdKK3LGoR9ZZp/F4F/wAU3O3PmPj+TGnnzTEzb4ugls4g8at2tl0I772ehU0Gs1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
 b=NPQt1/0WoWVAWP+kYD+4U6Y8oBKiz/N2W2ka6wvf4/F837w7Ol9B/B+WI5DUlt6ZWTWSiCz83zrWdm/5vP2stPM3jAzagKZnk16cpS38fzJMYfXcghDZ1ycTWfC+CFW7SC9KoZL1YqjZq6jUn7xcKrixhK6LWBIMcYmrMCDLLK4=
Received: from DS1PR03CA0018.namprd03.prod.outlook.com (2603:10b6:8:233::15)
 by PH3PPFEDB06D67A.namprd10.prod.outlook.com (2603:10b6:518:1::7d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 11:49:16 +0000
Received: from CY5PEPF00000E74.namprd02.prod.outlook.com
 (2603:10b6:8:233:cafe::95) by DS1PR03CA0018.outlook.office365.com
 (2603:10b6:8:233::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:49:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY5PEPF00000E74.mail.protection.outlook.com (10.167.247.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:14 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:42 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:41 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:41 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmemj1508727;
	Fri, 16 Oct 2026 06:48:41 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Fri, 16 Oct 2026 17:17:58 +0530
Message-ID: <20261016114806.1749515-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E74:EE_|PH3PPFEDB06D67A:EE_
X-MS-Office365-Filtering-Correlation-Id: 49ce1fc6-7b01-4245-bacb-08df2b7b8094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|23010399003|56012099006|261009223027099003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	LuKpPAWQjZiz20XLVVI4s2yfnZo77sBzbOT2McintF93SJfIBFg99RvEjgXvHt8ja5rmtVBNPy0abuMWKeXvcUoPCz69rRD0CXWjOswI2FXzsJKvMazU173CgI8jDbaq9kX14YH4wsOYQMNVaoZkpuusVrC/p8ModuYtHsuESjCa3Xz7b/sunHBcfVMnNg2oGSQ/CR4VpUXY9aNVbDD+TBfRq5yxO9Q9uxPYFBN6InavtvCxImvekWIlacK8nfzx7PXM0BjMhQgFF0GPONk6ycK1JVhOeRLoV2Hp3KXufGMwMrHTu88mJno7bYtfpsbyy5LK2/kucAXRN2EhjkNXXNDjbhQNBb9tH9hQm1tCHpYrXRfKPtTerpYLR//eU19uLcLRMWFVF3KuxVRCWIM8mKpwEeBoe88nDhDJq0UzY6+bck6bgBmfJwsOtPa5gOot7F5V0nQlWViVCHokR5LZikPkpkdkEm2ph6q08BZ9AbWlNKbCo2/kpnZJhUi4lbEqrbmiHHErAHpgAWKSvuVUfzHq+M9jB/2YwtCvA+tSe8hdIA9yFZ40yavo+OlO7s3UrMSMUIscfMPTwTdLmIyKhbeSFN9BX4YGWT/VdkSccsaqQpPQ/ypB2VdCyXAW7hqnpWBO9bY7NlkOtxB8kV7j213uX5UB5f6Ndx/ZneG2tRWgKNXcDSCru0IguBUkJMwEEfx40NZ1p7zxYjCEI2gFUQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(23010399003)(56012099006)(261009223027099003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wU/wnM7gD0RT4D1ORhtVy9StG1UpbnZsxaXwngRCtR4DYOVnRX9DOzWfzKfCTJQq15ha4GItA0mmMHw/egSwvDn2q7ZShypx6g6kzsr2XkUnwkE6Vuq0plMIJ/anYk/S4+i8Edvz03h6oyG0THJVg0eom250JTqBYdWXKpDw9sNEt2QoDEXEuczrpM5+KY2KuSIISUOSpGkkbAHY2smIkEWu/YM4LfVAgWcTIdxCTj7AJtVjGX0bsxsuPTmE1oC2nPfWMmfjk0ANFVWM0oeoBxKf60uyFjU++C2fZTNQzpg9lYDRfqFWnsBAtHCUnB7vE+KXlIT8GLnue6imfFK/MrvL5hsWcSmj2SXbYl7We8xwlmYntQcdbloV3ydgoYfSFW7ev+yhJnORo4b7xdVKeEBVJWFLdjuAZQVw9JOpKiVcpkgubDA2+unx9S0mmYZu
X-Exchange-RoutingPolicyChecked:
	MQy/aI5ny/PinVA4tuohiUy+z4fQ8pUROrWjm/ARxZJQ+0HP65MHwQoAA5R54Cs3j22SxV/iPOJQ8glqAVlUzCpy+hm7bfb+23Fesg7loWOwI2MRDS6Az1Zfv4JQ8Jyr5azrSN0VI+723yLiO18PS5jL2HEQ6rMost78DLR5SkzqWYCJ2e5UK653OGuJw0K+vnXEbL5nvjLhi4bJelHrpHK7A8TBYDE4Rx/R7J99QFO3p8TYVvNeyOdpV1tXphVZazrkJIvNwE/5n5vN02D4MgIRkFcO20wOjs3L4fNH3Ei09upTeoffOGn59wPknUO/TsgBJSRGVRbdnvC+IZLnLA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:14.7222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ce1fc6-7b01-4245-bacb-08df2b7b8094
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFEDB06D67A
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX29xYU2paTFEG
 WKPFkditXLuoYSZacYAxpFGnykgJs/9ecUUt0leuUV+o4rZ7+1r4AkmIUrXTXSIFQu1PR/kbs31
 nc81J66dEPpGCftog4usWCJUErmyRlk=
X-Proofpoint-ORIG-GUID: 1gqx-lkdrBQG14lz5l-jDLb6j7Kee1ou
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad20f3e cx=c_pps
 a=iBoLJ+TzW6OYwHE2Vh/RVw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX6mPruQSYCQqX
 o62HZgB5bweuT1oP9f+5W2MHDUcfnjRVC+H8oGC5M4UOlcQxA9QOy45JkP4CIwjejZX8eci7ss1
 lTOlqNk+rraWLKnQ2PlnBZuOgy9MebkGjUDH85YRdIWnqYuwzO0JV4ZAW5liuMgeIegkpswIUFN
 yjUr1dU5i6pxq9OP0cAjuahI1h/Sqm27AQg4RyhvzdZqY/9pH7CfdCJMAm0Ot+UsLsPgD3J2KVA
 nnuwSMvGvV/vdxKnbi2v74nIFv3maxtMBRL3JDNWVTLNVP6ErpoH1x8Sag+/Eq9G0cjIp+tX3YB
 hR0Ys+CpyV+tD//YitWWffbN07/f20nYTok/8+uT2OJHEb9UXlDAtt5Sy0hDxv/Ex8+L3PEpth4
 BW4PQ1gjYvgNi51yGBET43h4c84LixUzJ3FvdltPrtE+QSZv4o3D77G+Yo+AhMwO+E7FnrkvccX
 frceqn19qK7O1WZtqWw==
X-Proofpoint-GUID: 1gqx-lkdrBQG14lz5l-jDLb6j7Kee1ou
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues. Also move them into
differnt groups in __dma_from_device_group_begin/end() to separate the
cache lines for transports of different directions.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 29 +++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.h | 14 ++++++++++----
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 5be1bcaeee5ed..83d964e884086 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->src_padding;
+	u8 *dst_padding = rctx->dst_padding;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -491,8 +496,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
+	}
 	if (diff_dst)
 		kfree(dst);
 
@@ -880,9 +887,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents = 0;
 	int dst_mapped_nents = 0;
 
-	u8 *src_assoc_padbuf = rctx->padding;
-	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *src_assoc_padbuf = rctx->aad_padding;
+	u8 *src_crypt_padbuf = rctx->src_padding;
+	u8 *dst_crypt_padbuf = rctx->dst_padding;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1132,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->aad_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index cc20538ad6f36..f1b0396b322a0 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -108,15 +108,21 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
- * @padding: padding buffer for handling unaligned data
+ * @src_padding: padding buffer for handling unaligned data in src
+ * @aad_padding: padding buffer for handling unaligned data in aad
+ * @dst_padding: padding buffer for handling unaligned data in dst
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
-	__dma_from_device_group_end();
+	__dma_from_device_group_begin(to_device);
+	u8 src_padding[AES_BLOCK_SIZE];
+	u8 aad_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(to_device);
+	__dma_from_device_group_begin(from_device);
+	u8 dst_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(from_device);
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

