Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE05C4A4836;
	Fri, 16 Oct 2026 12:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154793; cv=fail; b=rNwJGdGxrBtBF1lqqmFVEmxAb+3d7TRhblRd90b5hrCU8wfiWdNF7eXajiYtAHzRMiJjT80GLM7UZx1kzX56Ch0tYES57LgSsgJQ1SQt/aQBdwXyAuugjuXcu9SwisypHshzEJ1Xk0E2Z/+i25XaoRGodplCyTCx3YADFklPMHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154793; c=relaxed/simple;
	bh=GR+qrnrjIRtaBAzReHzZ8r2pxiuFtvxoilH6uNxhHvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSgadiVvUHI1hkqeDh85xYZ/gFJFALmRcC0Jft3RjpI1rOjzUHbb/JLfnQ13PTBNlYVhQLl3IRm/kLFq3I0jXUqYP0tGCWsVH9vsJgvuxXWrpmxqPMr7raa5BynSXewsKoHyxutXj8Fu4DffpL+fDvVL1Ww6UBmOK2jcuEgjqJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=enqS8zDw; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=bBeNSstV; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="enqS8zDw";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="bBeNSstV"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACxf04171205;
	Fri, 16 Oct 2026 07:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe
	7A=; b=enqS8zDwpO04tDE4y0sb57nCyZA1dBIildhgMovCWXCNV1fyOHt+/L8rL
	WaHP8JsocBmH9kEXMdjR67iw8SzE2wF7OVnGzda+XDfKYEur1ZSXWMn9dynKlaYH
	5oiXGeJOK4hX3D4ERlk0pdoxLvsbLJnuD/ZACw/80KcqbAMOJq42hXhxoA0KJ6Uf
	TOXqtsfMNW/T85ghLB4jt3LPt5kvJPFvqyP49ZXBLH1Vkg+ZIjoHcjIJaXz1lE0G
	f60rK01CBeP0o8rccuE+MbX3/wkFcRjm1z+k39DZsCuR1/CkcpsqpPoqO79Wfd8B
	O3lLZlONau5B6ee0bnUnoMGrhWjhg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013027.outbound.protection.outlook.com [40.107.201.27])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhanrub9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:21 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFvh87A6LIJ6gd30sjJYcNlaUJSASgKopn6Bi0vec1884jHYY6J8USaATb8rIkKGXTvfyVrc89KZbGO6JlUaMYnXqGiuqBOMKsBz1putnS8LyClFkW15BUbX/eOtyogFtlB25TafYobvdy8TyoyCCVAmBYXiN1Ckv32ZA1XiIDRwdVIFJUjfaosshnXaIVQ3xJKyPPnIb1HlpvmMiFWFrR2gcuyVj6B3EZobfm74gG1wzCx6GoA1evJNmFCldiCkyeopP030D499RUgpqT8Q98KJMg4lSc5pMeRUKfwugI4gBtu2EXUomYF7dR7GfZuc0pihS+MoEOklb1Mb9I90EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe7A=;
 b=ww+Qmr8cYOEUy2nuXHO2IsMpXJdVDD0cgKV45DjxW9OQiGCHOiW2ThfdrH1fRrbonniH6tHkTg441WTNyIedaXS+GnLgObxNDOZYsqCOCCU6m2/40AA89j0BLj9DtmHDna5xwrFlPi1malbtn4Pjxj7s3T6/SaP+CZjCSxHkbn8ThYLmSszk5N3e3lapSK/PGL1UxHMevxNp5kF6brtC6MHVcPFIDghnBSMoU/91ND0RP+L6pCOjA8SekhC1+vU3E032IJDIArUxFDTa3/MygL1sBh/p+0shD2wbgi5H9Y8ewqxiSj+DIuHJA5BlR6zm3X8d3F/bfI7Tfis0AcGA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvFqDckfZT85PyrkHGhKkwSp03EnO9FSYviBJkcVe7A=;
 b=bBeNSstVjUC6cX9A5lR8JwSovaqCxUPToQBVMTXgi6nfbFqsGYFas9h6OM/E2JnvLp5KV4dFd/y+m0UNmZrGUYTIWJYDPdMjWSu66Ds+N+VyWOS2bWZ7e338/ohHajByx3h87k7h7ikot6zGcC2Iuv/FJXc8nSa68c0gJfV5+oI=
Received: from BY5PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:1e0::13)
 by IA1PR10MB6900.namprd10.prod.outlook.com (2603:10b6:208:420::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:46:16 +0000
Received: from CO1PEPF00018861.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::30) by BY5PR03CA0003.outlook.office365.com
 (2603:10b6:a03:1e0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 12:46:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00018861.mail.protection.outlook.com (10.167.249.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:13 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:24 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:23 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:23 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjMkK1587619;
	Fri, 16 Oct 2026 07:45:23 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Fri, 16 Oct 2026 18:14:44 +0530
Message-ID: <20261016124456.1802080-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00018861:EE_|IA1PR10MB6900:EE_
X-MS-Office365-Filtering-Correlation-Id: 4559606e-8541-4cd4-7cb3-08df2b837638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|23010399003|82310400026|56012099006|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	2zqSKqtpcgNnlQVe13SGRyhzwp8sh9X+SoBF3/1rzF+w9zVDWvzwoV9+gFtOP0hEUOh0nBc/gqGLDI/BaytGhYRDgzFq6SykX1EPe2lXX0fnX2/3RpepnaK5uz8ZCZTfjgNBWpCC2MCywQZ/cnRXvUBiYKNXtvx8KelvmKQ9Be3yYBqjS+4DMa5G/IaA4wicrVUj81eD7KhQ8k8GVcGqmhOgsnT0CiPj+5b4A0mKzXfjyLhFIM1MS2o01a7aM2GUGNfuxrdrlGJ2pD+5ZxVUP1LNST6dY5XaEYPaqFGwCvOIzoK9Ew92VeCeHF/yBH3K6OmvngAUIsxJrPLYE4HJ8qoAjKMPcTe3VxcO6Dgrz65nf41FHXovguFGG2TvcIKYhn7wwrQLe3G7XaBtSbR3ZNdF7E5NcfT/WgfuKqhLQ9hs9BYj7A/ooPzr2AmV9CnUhrbF5FRpGS6PZzeioblTRr0168f4GdDLvKwQUbKJSVEzf+sLBQHf5GDsIFnERWeF9mIlSgG2YP0a6aBN5LqVFA9DMEyE5Bd2YX9G6z5xORE1rbo9C4J7zo1nWsaaXYq90CsWwZvFJykG4VlsKj+VetyIpCY9wymT3mIUrTAPUczmNvtsKklJWHshEB2zKifQ6CD/MtQ8PGDlGxzjBilCVm3accVHGAYs6cekfGzM0z9sf2JIaNt2VDRJ8kLIBCqeW7YWjN3+DIw+mQ+T93+Arg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(23010399003)(82310400026)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Yis3F/FVun34hU/wW8+Iu5fSjTrsbaeR3xL4sWyO8RK4zzCRAGOdKT82SxZV/NHzw1+lKvHX8pTNj1D2ad0jFk61MPczUBtJycM8Dm9aqJ0MmYjXdkO94QjLy3DopnyKXKymcAGJLJtgL+/uked7bz5kqCptgtujH4EM4T+LaCltG53j+3PSfEetUWrUplUQNf3LP8edqs12ue6PMsOQxRQkPtylnqPrgAFft7ImSSClQqJuvmCWzOQpOjINnaH52k2w6FRk3c/RkFrShr7VV9fqfRfg12PrlL61K/fRvJ6DXX7AuwDCSKdnytYt1H/mbbf32Np1BkgHnVGeZ2FX0sGZ09B82jbyZWZSoStkaTr4hS2dEWUuwBz6t2OUa/JNkgn0ZvXCnAR0QqDNBjpxiTr/2ZPXKLMHYf+ctMe2Uqvu+lx04bNGa+u50hpaSu5y
X-Exchange-RoutingPolicyChecked:
	WcHZXotHgPHyynQGjMM/5KudDL/vK0zDWd7CA0rLLAEBbViJOMV7sEtti6VnvPclcKB6FLbWp6hCve5/qpVfsvVRPNu6EUpT1iVtEMrZBS6K8eoWKIaZk79KHAv+wtQbw02bAJMVOLiStqMngyFckPVG6KwDhr02lP7aKl2njDiWwBczb0xffQ/bGemaO6R6uJgp8pYnFqGkEpCeWiEbH4gEKnQMLdlQsEHnxDm4mFI9q+su+h0hECxQEzUURW4pkgXsPK5icZQN720CHB6XF+91IU6kSIShrNZ79fGGv8WN3o14+8IiKRNmei6XVjeHOJ/AM0XlqBKwZMbPbWtksQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:13.2753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4559606e-8541-4cd4-7cb3-08df2b837638
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018861.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6900
X-Proofpoint-ORIG-GUID: YijWRla8EFxCqENL64Ms_kRZtRxSgPRF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX70Axg9TSX2Lo
 wruoAX1ZjEwJHVteNBX5zfaWGVMbEznlZNtmntu3/ExfkLE18A500Ui1LsQ653DXN3EgCjWAkvz
 BkNVoGRXOPMCmKWBTYNbVxi/PH5PTww5ObNoC83I2ZJMnkZlN0CQ0eSwgvJrjixMNPDolNgTAWK
 JACiG57YAMb9eNVmBbHJw8G8g/yqoFU91mdFR7KUYqW2TrKjuQrKONlfwZil2P5cgqHudU5zolw
 5VyGz9u5Vy+UyCiKBFoAk777HTPnfFi0UT6XWCO3mUTPrJp7eWxPAaQNzb0WgVqt47a3DtH2xkn
 TgpakIZLWRLoYE6IcZ8i3hFPq6TDlMl/1/ifuu3ujtTtMdgtNl+i34DfmTNCWLIlPfo+F1p+k6z
 QCh4Zp921Rh0Cfp0vh+13PIRPh1UFvkk6ia30HsDAQ/8WJxYw8GjuRsJOSMhpg8ZTMKrcDfdgWK
 Zax+GeyIGQJ9AXqBG8w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX3x+ySFFS1dqS
 63NOW4UTWdrpcTAQ8i9Ptbtmc/gO5W0wSnQjVxWJ92rzWrekokWaNP4j72qdUKUj72XTXk9wJqI
 Y6y+qfhogGuLxow5Scw7UnwFq7tohzw=
X-Authority-Analysis: v=2.4 cv=NvhE4MdJ c=1 sm=1 tr=0 ts=6ad21c9d cx=c_pps
 a=KTU/bV3Cu5xqMUx6SKv27w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-GUID: YijWRla8EFxCqENL64Ms_kRZtRxSgPRF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160050

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption. While we are here, also change function
signature to change buflen from int to unsigned int.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 drivers/crypto/ti/dthev2-common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 8f8c4a93af616..ca8bab4950d28 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -49,7 +49,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -58,7 +58,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..75d9a097650da 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -126,7 +126,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
  **/
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen);
+				 unsigned int buflen);
 
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
-- 
2.34.1

