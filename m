Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5B64DF4D5;
	Wed, 30 Sep 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773216; cv=fail; b=anQTkuy1fgBLT/RW+LGHsKHKUMBpNWxv6X8LPm7NLka5KDMmdS5qeu3VTkxbhftIpxptBmCChJi0T8loFEkRqBirXLz4gzH8qrCXwiAFH7qxcXSBxU64iPVCQcCarUcWGHNchtelQmXFC+dzhGrGB0J3UEIeMG5m0gSF9V55igI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773216; c=relaxed/simple;
	bh=YC/A7S75qv+4+3WlQfVYWpfOLT28k6/ecphUxP7SPDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CV0UwEXgzPigakR0VnWRnHld23EL6QnAdiFS8ypeOBjZ9fPxElAlS7ycZkfan+67qh3nYO36a/ZmfwcatjiBfp4r3UJJaCbx52tdiWGcj7fy5gxB2v4wzAm1P5UkGB9KilGOLnzGfUNivIJM+qv0oCamozVMibBvAT9nXVU8ohY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=pXVWTB3y; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=HRBDsatR; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="pXVWTB3y";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="HRBDsatR"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5ePY2989907;
	Wed, 30 Sep 2026 08:00:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+
	WQ=; b=pXVWTB3yyNwhGIBzmpFYAl9JsQpqZlgMvvoMwIwsddZQZVvQdHX2XLvNd
	etzAQMMTSWWpolTqD2X/pub14Sk0WEdFzTiVIlIFEMw3Qe2xstw0HWQPUiKYtPWR
	yNb6+EwIqvqsyvXu6gydRTuk1pUgAkiXDmtNMXbr41ytPikKygF4y4vYthsGzClu
	zR5OiLF87JrMaXcoewtoMpHHD0q80TvTRBdjo8t8sOwkin8sPjTeC3T1cg5tmBO3
	xJWDOiVO8+7ZqmTitdpsxTNiuozrygMtMzHn6u2pIYmx3dqvAwovJmbuv11QVyYM
	i6dMGZP0mBRgSQAlMnJ0Si/zhO8vw==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h10t1rq0n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:01 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A4QZqYZAO07ywfUNxHTjP1Mqcgy/mGDNia86Hfkh6fP8pu+XughQR6+BnH8WFQEC/ms8fbx40mSxU/zGF4FMz/DoIN63ishlD4asWB9x1AIqR26qPI/ruKKHV82nhmQfj+6X/vJnJMzieIY7q6ETxQYveLhz3dpw6F6Fn7oH2PtJ+Z9IREyPvwJVG6GFKSJ2GDdnpY2+uvXHSrJ6J2RBcNa1pzM3pDXLoS6PJHyBBsOdSmTpiKSOkkuMFQqyMQXyEQ3uLoKb/rfBoZ5UqaDVo/pdYhEMC2xrujDW8Z2XGLwKyPwS+1+gFiczBlz1VuDsytAL94AofwHLksa0oSw92w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=zFJKoSI/o/BcAzq1fqbQH/eAVIbQdnSyasKhrzqR1YGgBWWoGG4mmfxUQpc8EogLQ8f1L+D8/sQitDkuV+yyPvuEZ4J0mnja8alTrTC08nUpiIAVDmDipjqMxzeGpXQG3YofYQpafYCzidvL9OkBd14EU2j8n02dcYwB22IJhvkrGPPPlASabRyXAz7zoUo2jSm9rGLQ5NSch0u9U1JWlMUYJVEa6XxgRorMMk1dDefMWO92d7gJ0PjrofEedQgfFpJC+isc9oo88Avvtu4elRdIWt7n5kfm15vvv2ZR3Eo18MC/Cg+UpvBMhzzUGh0xB32rx4mrEqb/3euYSGU32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=HRBDsatR7zUabE1GswijE59FF5BCS2PPn26Qa3dO91qTsSbQrpOJ+7kU8QDSQZTO99tSWHDd/f4v1n3Wts9sATdROdt1HAJrJtomL4zPnXx9GZtPHmyaO4zbG9WITM1ktw2i8/EgsBoPMiRMCc3DxUxjYsoR4Ja8wzBkjEoxdD4=
Received: from MN2PR16CA0053.namprd16.prod.outlook.com (2603:10b6:208:234::22)
 by CH9PR10MB997881.namprd10.prod.outlook.com (2603:10b6:610:345::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 12:59:57 +0000
Received: from BN7PEPF000000A8.namprd05.prod.outlook.com
 (2603:10b6:208:234:cafe::8c) by MN2PR16CA0053.outlook.office365.com
 (2603:10b6:208:234::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000A8.mail.protection.outlook.com (10.167.245.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:59:56 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:33 -0500
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:33 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:33 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxWNQ4098316;
	Wed, 30 Sep 2026 07:59:33 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Wed, 30 Sep 2026 18:28:54 +0530
Message-ID: <20260930125859.1749849-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A8:EE_|CH9PR10MB997881:EE_
X-MS-Office365-Filtering-Correlation-Id: 82faca4c-2749-41ca-09ce-08df1ef2ba88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|23010399003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3jEHwpgXjzZ1zQll+8hqQBrDsdHbfx2TjFeRor1dfBuLwWrEyKpnwzxsors/oq03RuGKgwQ9veh+SZheHOjaiFRap5mgBjxDfMitUqECHDDXLV/9tP32bG729sv2SKGhBMSAsgTV/5V5z4NpxlVVB17cb8iDDG8q7mg+3EV8St+deDUy6+hDaPnS9XNTXP+KrFVqf+cWjUaO81W4RUeRU9IXThTwYHl2DvRGBKZfWDL8NggPk/tHfZzynKRy3/Sdb544HGryUGxYC0CUF0FfG5lxBdBAyMkbGgc2gL4Vdp6LqelJu1EB4rjoESyJDdh1kEaLyubW97UCbGXHHXh516GubT7WCPamNFRbT72o642n9WddwZbeCrpcGEF2y95b4zSMKDoToW0f33DHAIoxcDjG0GN8kGYedbfwGWTF3NlhdyA70b8hgPtRvVn5onUcFQZEatWSN4Pzbu9XXR+IFi/p2d/aq+oLw4z71vhZIlfO3pCbaa9YlGfS9lbFQ1WFxvh8fxTlyDnauYPf6Lj/bt9vZoQvhNZow5PlyWmCzlD8u49cLnI8TGJIsFKRS8/xqZBxfQ8oAFh8RHUvUVHOheUC2FR9c1+TVkuuk6Jyf8MsnRzNH8ohadV2TPbOwnKLJLIhxJsE9CgcxrMuwYmfEKj+Dc9vlunsGAs/hduSEJFkg5PiVixLlZu6eni3z1ZaOL+S5rrW4ACmBrRPzeLNkg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nVOsqxtgo29VbfHxulLHyKLHM7B4XdpLVVvAAcl7z+hzoGmdoPdYOHozevYCukBCT6ChOQhobdg8ArNyBouXN85MXn3ljVRQdQNVvqmwKwY7u8M3fJgpeMpAcNs0T4pxbvThwwNUa7eY/boIIFXGQxSeBrCQ6Tw0uxqkAvp1lgsAWZXs/Rgyy3WdTQzHAlmlQD1CqRQr/q0pRoSYfwHFl/9F9wg9aLcDuR5unqXkHfzCIkSqRR+iiuQTV25f9ht9JhE/OaVGt9QLW0Lmtro5tRRIfJYSI97RQksRxlPvLfNsjrehhK1I8NBc6mommkXXciHXKKhjY0OVPEDWdKdnPlxf6SCkUFpqgWd+J10yocC1iaLXtw3NDQ6SQXkR7WCyn1657z/Iqp83mkwp+8PdMsy5IZOhBUZTg4MVrU/BLbTpwHUORQVD9SE7wtmw0Aj+
X-Exchange-RoutingPolicyChecked:
	vo0Re2qswCIWkTXFfI6+m+wK+4/PcwC7BpFOmcnso+Ik4ifKuJbN5p9OKFzFCCuPJlE2ls8bNA+fe5NJbsGaeqzwSWU7gejgJ3IEMz5o6NHZ+t6ASRJd7kRzYgfCpukbJti92rJV45E5lZvHhoK0If/wuu5+rU8xQe56LYa5q27sQQbpPfOhFXL96LK/dRs6MKvFS91j6Zo+QVc3DoT/Rdv8tiwEg3ArzO80424x/uyUZtDKPde/IadgcFDSqOI32fam4FO73Lhn7/z9Cv9Vumovnwz7X6GxTE5Cwa5Kie1S1DU0JYuBlE6Ipr93TQbBcPOgtDSzShdVRr4HJDDh9g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:56.9170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82faca4c-2749-41ca-09ce-08df1ef2ba88
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997881
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXyUPiMgkj85Hw
 trm+JKbEaJ/U98xF98VKwH8OHY0bI8QoS+IG+uGpFx0pJhO4kh/hYqJY6GbQHr5RwtDtFJ/fP0r
 3CgJbwh/Ni4sUblSSoj16tysFODboNs=
X-Proofpoint-ORIG-GUID: GvsBvmin_njAJOt1ehnbqrVZ2ON6kxeU
X-Authority-Analysis: v=2.4 cv=C7R8WgP+ c=1 sm=1 tr=0 ts=6abd07d1 cx=c_pps
 a=Z+ESqgFbrcYkgT1kPBc/rQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-GUID: GvsBvmin_njAJOt1ehnbqrVZ2ON6kxeU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX94B2VKSujZNB
 UR0lICHjhNVDLtqzpQfWAje5WOCjiEv9g2QLb1df/F7V+iGRsQYyAoWGXvby7x1uvdw3cVukAuV
 4wemG671MB8yrN3xBq8oxm51nXJ+SmNKx5TF5D7ufROmLGJuZxAOrIsDXaHCQj05SIWV0Ewj8Of
 sUgXXGuu+UiaZGJIqw17kRp6wsHWl/mWFUiM/LyWdOp5SDMwsSmjcAxMEOnU9Jbh++nEHiwCI8d
 VzSB3PJhvfCVYCxSms0/8Oesbz6vh7EbPxIDl2gRNw+UtmemzmTEdHuY3Ea4XhbPlAmDSh8OcCq
 woy/WplvW7Cti+Rv4PJVLsuFHZkQFQSO5F2WauOxZa/IaR30lETJ6YBGxo5gQPhXIrVPGOV9a7n
 9uzr8ZkqnpNTfo4Zi90uyDidFp9Ln94oJlhTmCVaAHZyJ65lvZ9uSW0MesX8/iX79JyhqxDUXgd
 3gJVv9xKg/yI9UOn0aQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d75b074ca1e39..ccee60800a664 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

