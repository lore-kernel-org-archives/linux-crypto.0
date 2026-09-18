Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FC44E3240;
	Fri, 18 Sep 2026 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727024; cv=fail; b=F9jQ7B+DvNn9I595O4Nu1emO11joaBnwfeD6jr1lrR5fK7o0LClelEGwbMmleoEbXkDi31HoOSzz8tgkKygWi1YLwIxKOFnSURW97Pggs8cHtd7uUv2IAvcBu4ab6Mxh1BZy3VIdWD362BFlvsmOVJ4ialIFIvG2VX+W5BW2/Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727024; c=relaxed/simple;
	bh=Ge9j09OItfl39sMD0+R3OKL8fXxzjj6qvomlEshNfas=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbTNhha6rcjGIZDkz9+7ICIVkBUTsCQNivpuQLRYaKnqAhKawb0IqR5IQgeXrAQd8qcTQE8evNZ0b0WM07s1jA/caYPglMBLrziN2yiRCOdHJ8+vxu65rPglj7fToZQUvwZbj+gtbrqk2mE6hlXXsQjmCy42lH5Brj/8W0WihMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Y77peWA0; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=M0S6g5w6; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Y77peWA0";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="M0S6g5w6"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9cRIG3870217;
	Fri, 18 Sep 2026 05:23:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNX
	uQ=; b=Y77peWA0wySxpCyjpBGM5wZB38fd6Rx3UQI2JySJwkCz83NTFKXsQy66V
	MEi5EUOpRCrABtVg166M0wI1UalR1x3Jao4omltLv2OMdLq9Jp105DSUNGwpw9TO
	vZMWELtCuj64DXolJkuNZn751BTVwwJ2uTqnQQvg4whEl+XWayxf/hrnI/HGeM7A
	z6jKPnTpgdCZtb/LBmOrJNss0vDOPzXpelbGdz3c3yT+xT2LKf1KRE6q8lQxMOwv
	JdVbbtdtdz9Z1cZoa8zwC/z3pcBJqdmjW1AhV7JUtxudVztNaOVHIKgKTNjGevuQ
	DGZZXdAz+zcUTa0T3ZiyJ/Zag7afA==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012021.outbound.protection.outlook.com [52.101.53.21])
	by m0380145.ppops.net (PPS) with ESMTPS id 4grx6d9ymx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:40 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PAqHUiqagY4J2RHV7FWOH06wX+wYTaTb/l3QfX/3O/L7cLVkI/HR2dcqG9JgRDRTdMj/g2OfvggbYA+sS7FIbt497T10WaMZY7eaElAu2qEMIGYAQJYh2CamHRXLvAJSpOfCTjXUbKSXTl41NuvBQoswoYTc4DDqTFQWo6qCkxuHHS9b4jA3U7qUwLvrcAdRIhUi3KwF3v2I1dziLb2H6K6kLmNejZMS8ea8j+xSdJfTdQOMshiMGytdzSsuT2dj8vla8PvV+O7/eaElnkTiz6Anq6E6wCKYNR9feZW7E5enjWjfOqAj06aLpZSvyEXSMvKhHByLJ+uNYroB3fw5JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNXuQ=;
 b=r1e5YY03AxhOF2rm0ORhup14J7oEH6IGssEnqZ1fpZy3Ja9mortevRYry+JxBrkTr9nM0qotdqZC+6eulZMEuIzsGAtp3i4qug2Al5GGqcEuTFnC9ltUnQICumQzOyygJ5PxD2Xs3fpZgvXNBeNUmvI0JPFxIoR1aUoVF50D3z7Vi4GIc4ZO5Xu9dR7jJPKLW4lR2PyslQz2xxJCRyvIxGTMWsFamtonB1bxcVCVuy4OC7KiOqeLDF69IGT1pgikZcS5d3kPVzF3zXYihdHiiL4YT1SIUvRcERsGSv1KM8Uz/Tp0WV5OiCHvUrsRWeOBw6qoMitzxBOGLSjbaOT8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNXuQ=;
 b=M0S6g5w6Eg+/lZvf1g4rgTs4UTBz26SlS1/I6ocwfV1RJA3mYWn3HGm2m8VJ9qbWDN1yD40WrqYnX1qR+Zla3EkGE6/v1TDofmpkjkszWRug5fW9hwYHbUrafzKGT/SliD6LY48LP8R6QFArXXGHakFPlem8om42/zTjBoVLxPs=
Received: from BN0PR04CA0084.namprd04.prod.outlook.com (2603:10b6:408:ea::29)
 by IA3PR10MB8345.namprd10.prod.outlook.com (2603:10b6:208:577::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.7; Fri, 18 Sep
 2026 10:23:37 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::5b) by BN0PR04CA0084.outlook.office365.com
 (2603:10b6:408:ea::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:37 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:16 -0500
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:16 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:16 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANFNZ1534591;
	Fri, 18 Sep 2026 05:23:16 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Fri, 18 Sep 2026 15:52:38 +0530
Message-ID: <20260918102245.2784000-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|IA3PR10MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 17e83c30-5889-4bac-50fc-08df156ee6dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oA3UNTznPrza3D7yhn0rOiPhtz5YH9/ZrNE1YuoPkvn+LO7KhKqLISxGgg/ActjRZL3CD3tG9HURXN4caCFU0vlUHvWmQ5imDMEAbR+ou0b58Isew65aTWCLNNuQXfmwWulay0jactTDpWOVzrz28i4aBKynaZt+gks/MdS3oloRKzgVJXDxzI0fj0tH8vXYeDzDPY5JBfzRZXDKLWVw0HxUs2SGBeSM+5162Ix3GYw/CGheP2IjFoQ5pa5HwnTnXun10PGr5DzmLcKz1VpYKL/RqUueguZEW6hYxPQEuZdQRxGlVy7+tVPyI+bJBnV789a7mxAKyd4KBNpW9e7TSiXpYZX5reAmpm4JRFBjYvS3+0ZpU+QKuXvyhtph4yqFJxMugZYEkeec1mveQaHZIhrzrrXUFKKmagXLEPH2OzgVxryAte0lBnihZrwii56Ebjm3+rV8bvONL0xPMtErK13get4XVdbmCFwWkaNUcsJInJiD6ANYvzcLealCoLsbrnL6NWzsWrGS6d0YQcI0/w9FzYJ4ImvKqcvEF6TVPo27WT28US5rYBpJS7gGBFwTWbnjcUN6CTX4cfBnazU1yzWBwZ/pyqlL166lfaYNI20gu3oewsut7/utcQm7VGw+1Ioucr8djB59UzgZJTkUGHcViUdPMh5kola3lg5obw0rLaRsumAXpTWTmg3rGlOdeeywrwKowOvQjo9hT7b2Hg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lR66ecYChtENkZWG9nFZkhC02vmiw8fbxoFQDTH99nfuV2q2SuRirisxSDJNx1WsKgeneQvnAtJ3hCHx09FsO7W3ActGy2CCAeee8WJ/BMYC1EbY2B6gHQGPUf925Gis3ZByEjG5mnjxemCljN3XMOnsHwhWny5Ll8zRYnrd6hi1YvCCnX+Rhl39TuMMGUvsVloeMQwDWa5gYtJEoxY/ImN2crfIrIWb8BWhSELMYpSG6yJy4z71ni+PfnQWEGIrT0DQEl8wHpaIixxw3e05/1m2dCQVLbLhmToZDPTGuGxgA9rZBrgNbsnOR2D3lamZTiZ8rp3+z5Q/QGUUVW59uHMMPkPypiepIryj1UnRSiYQMUhCAKvjFTp7JyPD1oQ3HlR6SWGs/YkDrarop0qzgkfPfTt8jnKInP2erWMqEE82EDbWHyoT3TJs2Qis/S8R
X-Exchange-RoutingPolicyChecked:
	IvQ/XfRGMFfAfyaYqbs11NIAPuG40oajtnTbzqN9Am6xVUK1kL21J8MYTNLYT0JJQH5RGlO0Qug+Ful2yQqB1TjR6GQD5NPW6GqrsX1lZRAiNMpCuZycDsoYXluNussQaig1fuTOca73NAUuYwruh+bQKuMD50KU8Fe+P9IXNtMeUCfPuwmYYBMbzEMILxW12rxtw4I9ulMUAPdYzpn02HzxTyGi5LHzeL3ZsTmEXxNoXcsa0ksYZYOzp5YGOrrSnF4zXgkSvDKH7eQA/gE52sj1g7QlKBisviYRor+1sDdXGq613moEIuqamKvaNfqTpcDAm4IIEPzxnMwWVT3UkA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:37.2506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e83c30-5889-4bac-50fc-08df156ee6dc
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8345
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX/Nd7zajuXLTI
 h1eRsIJOTK8us3UTJWdDinYJlzLCYx5lV2bfWwlUwkUBt50YRHtEfRY7/w0hCuaySq2VeAm0lH8
 baW6CkbYgZuA6vi47igwmKmY8kHwV6s=
X-Authority-Analysis: v=2.4 cv=Cswq4X4D c=1 sm=1 tr=0 ts=6aad112c cx=c_pps
 a=oYvfaNmKcCZhiE/ts8qH8g==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX/0JZmzDjj0RN
 gDP387FILudJMYmYOsWyjnZYJSCfgzAMdfuOcpmk4p7zI/nz9MpEA3XAMzquSDL7UDm1k+xPZed
 Pd+w58VuzPlC2pvz4T1Q2CCSftsAK+k4ZtvMklvAz1jgZhFUNLbE19XlkCt2SS8gCQV0aH+mliV
 6ddC/AQ4Wpne04MSEz/bdoHUiMEVxza1VGLzVbAh/PimVPhFcmQ1eQ9PsVRrSU0Oi0WNbygY/cG
 kA0bwic8HR5TmbZQ61zvmYNzHuQButdZMADAXqhlt0F98Y3lOWwhlq6F4eQuM+Sa67shtL/+WJo
 XSX47LIXwUszAzYYDi6h8UFtqnDwiKip6JPeg/gasa2bbJMkeFBsewM4kpvr5KXNyZ8dYcsv0+h
 1T+mDtJrz3xvA0kiAIJKWHM23+EwzzashPNclXUUJfUEg0Wb3hzV/LxnslxInlXZqtmeGWavnIT
 G+leUUEdjgNPyLJVWcw==
X-Proofpoint-ORIG-GUID: YYhj9cOC4PR8Okkpp1-Doa0Nie2MHqqX
X-Proofpoint-GUID: YYhj9cOC4PR8Okkpp1-Doa0Nie2MHqqX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

