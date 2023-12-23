Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5385F14F96
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="LXmNlnus"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNHpBRE015681;
	Sat, 23 Dec 2023 10:10:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=oTbs3cmFB6EKBlw3wpiAvBPHvntPaDTvCod9KAqMzz0=; b=
	LXmNlnusVGH2P7+WomoSTfqs7KAVHeX2K1ykzYnEcJWkPKl6J9WG3pPfzWimk28P
	WdY6Rng+zlMi3jV/QlRMATrpsUhoLpg5g6PoGIYShEIA3us8+0b+qdko2FLRlaXZ
	Vs+uqEUs9bjmuzb9UBkOTkurd8PCUHIhCd6aGh2bltYd/TtRZ0D3tZ6RaxYXz30E
	YgVDcoQ9wBEAVJYdRiq0rqWdMd3KwIVPajcX5gC8v+k1sZwmIeoQZ+BcG+nWbEpc
	RHCMJtYA3O7BXpvIrZqHQ49wbngzYM9QlNg6FDxGslGhcTu9ACHH8L+Td0nu59jt
	JQ4aFHDMKPs0aMnWcbMeyQ==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5uq4g8cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgVA1Czvk+aQcH8BWSEYUxIx+goZtgJ4L9BDuv6esnnn25hFRMtVzsrYdXkS2aLsHR7rg4fWRGnp/GAzIq8AiQi7vtBXwGcgily45Pw+Iu+nChc6c9kuo8n05+ATSmkqZ8EUtmh8vL9puMoOBw79DIL5/tkbx0U9fTu0ZRYw+RbKo9laO+6rxekimy5mc5dIGjRHJJG59LaTUG1L5Ow29DCi9yd8duqZd22m6x9wzqdVBOgnSc2sWhxGtUkw/AZCZrNGi0m5HLUgEZQwyYst1FihwlniWhGi3MYCM2lW34O5gxRjPcnUpGLwB6x/CEGXVcmyPcoqxdMH+pV17p+2CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTbs3cmFB6EKBlw3wpiAvBPHvntPaDTvCod9KAqMzz0=;
 b=IymuKTdMGqL83Zika1y7i57DyNJizN1z2nEBdCMFeRSJtMsiAqH0q4WMUDom1l1ycJ7a0oeKrluAWJiujKkyXshGMHe9FKIR4cKCAD7xgK1Yjioj3maPxXisKmwIzNuc7Br4ALIW+0DJyods1vfCBgv5mqsbZdpG0b9KYp59GChhJpSOxUylFik9kl/9EhhsdwbekxGUoJ069a3ThpF4dhdvZAW2sG/nTf1hB+nVLkjgkYeta4q9j9rtcD3jp6G0CLE3d59sj+oX5TRceox02d9Dxkhb+rE7C1u0hwzsVoQO/EagH7Rmma3cfRXXCbWp4kWjuwMrXz/yOCPcAd8RvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:46 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:46 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 09/14] crypto: sahara - use devm_clk_get_enabled()
Date: Sat, 23 Dec 2023 20:11:03 +0200
Message-Id: <20231223181108.3819741-9-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
References: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: a8afb11e-7970-4162-3569-08dc03e27c9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jwcER8Rhad8G1Y/iLocMbbDnzwvaZdjT25AyPAUpRTNDk63GxaBtwL51ZMJIbkbUZXlmG/PoGbzQ31qdhhf0bpa4YNv9AL+S6JqwTLejeC5xo+qaE3dQLJTaZCqXBxs5nPB1Smx8d5ZXE4JD0/f8meVCkM0XsFTyDLtK4EIZ1r7w+hsCVjE+aNbS+TxFe28z0gHW1a4zmxjUFquv30u8R5ZmfOWBALm1PdZ0a4aQhhlJTTEkLpHOXadrDksk42AIk9RVftuifUmoLZtU59zZuax9G4lhJSDCdnOu7EgpBFZOwYz5CTnbE0f/XMIY0ibFeSqpsfmPF2UttPPrxY3GT+C/XfVp3T8FejMIDnzU2HxWfup5uW/2E2Gi1v5xy7pHfKYpCtOP7w2cVHrZrhNdSYQQHUCxIF81y0ltHnD8Pj4Du0ImhsZ7oE3iQ9928e7y7ov7X/cfkXzF7V5FiDuRRhl9x6dWg2eTRJCRO/BOdWMgtmak8m055vbOGzeDdC4TfC0j3rSUMreiZJ06Upt3P7aIc8LrGphT4WxAbwB0oo5qetagJORlb+5QWo2u2mVTJrI7pCLA8wFVZWA28e255Ak42ss9sPcYZ6FOQr5MqLMQ/C3PIUG8sK9oOkx5EtlH
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BmxZMzRtV3Igasg6OA8TB3FNwEhBsTsBvB/FLvU5nBopc9vVoo5WZAbA+A45?=
 =?us-ascii?Q?NsM84voRSHPcgkVhHvJNAR4ezGqJ+gKf60KxwFK7Ytz4R+zL780SjpvN6SS+?=
 =?us-ascii?Q?WSbs+mhL6lMGw02oGoGWZxv6wZlpkUt97ixE3I+EyIp/VyX26PJSdKhHIcJH?=
 =?us-ascii?Q?dfzxk9TmGixIJurE7Nh8wjbOk9ukSZ1HftRo1R1FNtJogVDaBwEIamQh+E64?=
 =?us-ascii?Q?LkR7Jf68xytwKYtZkEYmjXlEQv6Q6y298Zk89DoSV7eounGXJhuzQCkBp3Yc?=
 =?us-ascii?Q?7vWH4dxUhji1xqvuV0OJjNYvCKnaLxurk3YNl6LrdgYSP5PnJ/yg8LVf/fOw?=
 =?us-ascii?Q?LNlYs+NcuzkbQATgOA25Sh0py99/NhKQrOZDoRUNS2w7RiqHyCNwBTgo8L95?=
 =?us-ascii?Q?2Pm6PJXZ1tTCFpCIeK+5PO647b3Hjb66/8i+V6WKIV9g0W66Z8E3kczDnFMS?=
 =?us-ascii?Q?XX/b37sFBpRVUV1QzCNNiWdt0gLH4L/Yj/gcEhpvdtL14R27cHR8cbecLauu?=
 =?us-ascii?Q?qDpfJ2W/7kZKzOvXDxZ7Ap862oVxOcNL1jRCH4lmal3LuV/8vgjScJ0B4jCG?=
 =?us-ascii?Q?8/RVXVbgEXnT4NW8RPiWBV0QUVlEdAWkh24VmZ3qYInPQd/UJ0bPSUg08KAz?=
 =?us-ascii?Q?bVafQ+cK0o/0CEw4+Q5n9aQoonX+JRk7NCiX3yQKiTtdDXpNc20a1kz1h4zA?=
 =?us-ascii?Q?ZTCNpWRpRVG1KN+EQ2zRNBWtLfEm71i90DalYmIZwjDljfGQy1GiccfWjKJ+?=
 =?us-ascii?Q?hKSp1jb/qliWMvdcXxTrLm2l803ARQ+a3sEo/TgQqDyeTSZ9SbqYWCmNtmW+?=
 =?us-ascii?Q?BALQxUk4EofQecDTBUD3JQgpwBYZuPdL7jlr7sasFgbbBwoBQaWv5VvrPIFO?=
 =?us-ascii?Q?Nh0e3ufTKoX0fFHOV+ep9rh+NzlA++z73orB9yeI2cVxOVe1PH8J/Ruu1Yso?=
 =?us-ascii?Q?+xzYHaz3PnbUsk4Pl9Rt7MjvroG8UERmyXMw1TLzwOFWls2tHITxDIG32hUA?=
 =?us-ascii?Q?Sd1E/st3+/oYBSPkbNFuyVlmiA2IuaDA5cXPo7EYqPYOh42Ema+v7O4oBEka?=
 =?us-ascii?Q?1MrJpPddysAT2xNK3e3vsKekhciHX0aYC/fj0fwq8cJGs7bBLOUM57w6l5Q/?=
 =?us-ascii?Q?iSOxpNZQsTtL+IroC2L1kgryNuBVQkokMeexhacm0NHhtpuqOvLuucFVFzKs?=
 =?us-ascii?Q?tdkPkElreoBFbpW5ms1dqgvZJarugop1yexGx/lFg+nCxnTTSJOw+/KJ+AUQ?=
 =?us-ascii?Q?gGwgzG7NBjRW/SAqBr785v30eSzBeGHEkHEIqRBrDBMGoPv2RU4SEebM07o1?=
 =?us-ascii?Q?G2Aan86+rQ+LDApuutWZHXpRJKijrBASzt1SY/ke+Wg+wriCkcIc/eyjfg0y?=
 =?us-ascii?Q?1FUysfdsuGliEzXMvcFJH9MgYNaEiayBjhiZblJGanHqFhKcB+WKFoKV/lI4?=
 =?us-ascii?Q?W9hl8EjXKQYk+Pbmho7lCE+l3decy1PdlpziamaC3RO+J/afZ9NvihcJihCA?=
 =?us-ascii?Q?9T4Y1PXY/8hbuXSeQBSj3DpBiCQhiyf8DzhPg4b2Kw7UM/PuuYVEWsnvb3LX?=
 =?us-ascii?Q?OjxFpCIHQp7bHy2ZtV1geqbMQMKAQXhodAYu1ylNzvehrpeePSebkXPf00Cx?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8afb11e-7970-4162-3569-08dc03e27c9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:46.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LmVr1ZE0MvKXavCeYG+QCzgJFslWjvR0QvVXJqLKeht1cCtWT3zpwpbyGAmT+w1Dja+4F2Bb9N3O84G52mKwWklKE+JVNMqDbLiGQTNy2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: QRQ1cMy2MwW7Gu3pOpi_x84dJB4oDjz3
X-Proofpoint-ORIG-GUID: QRQ1cMy2MwW7Gu3pOpi_x84dJB4oDjz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=978 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Use devm_clk_get_enabled() helper to simplify probe/remove code. Also, use
dev_err_probe() for error reporting.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index ba7d3a917101..619a1df69410 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1352,17 +1352,15 @@ static int sahara_probe(struct platform_device *pdev)
 	}
 
 	/* clocks */
-	dev->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
-	if (IS_ERR(dev->clk_ipg)) {
-		dev_err(&pdev->dev, "Could not get ipg clock\n");
-		return PTR_ERR(dev->clk_ipg);
-	}
+	dev->clk_ipg = devm_clk_get_enabled(&pdev->dev, "ipg");
+	if (IS_ERR(dev->clk_ipg))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dev->clk_ipg),
+				     "Could not get ipg clock\n");
 
-	dev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
-	if (IS_ERR(dev->clk_ahb)) {
-		dev_err(&pdev->dev, "Could not get ahb clock\n");
-		return PTR_ERR(dev->clk_ahb);
-	}
+	dev->clk_ahb = devm_clk_get_enabled(&pdev->dev, "ahb");
+	if (IS_ERR(dev->clk_ahb))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dev->clk_ahb),
+				     "Could not get ahb clock\n");
 
 	/* Allocate HW descriptors */
 	dev->hw_desc[0] = dmam_alloc_coherent(&pdev->dev,
@@ -1422,13 +1420,6 @@ static int sahara_probe(struct platform_device *pdev)
 
 	init_completion(&dev->dma_completion);
 
-	err = clk_prepare_enable(dev->clk_ipg);
-	if (err)
-		return err;
-	err = clk_prepare_enable(dev->clk_ahb);
-	if (err)
-		goto clk_ipg_disable;
-
 	version = sahara_read(dev, SAHARA_REG_VERSION);
 	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx27-sahara")) {
 		if (version != SAHARA_VERSION_3)
@@ -1466,9 +1457,6 @@ static int sahara_probe(struct platform_device *pdev)
 err_algs:
 	kthread_stop(dev->kthread);
 	dev_ptr = NULL;
-	clk_disable_unprepare(dev->clk_ahb);
-clk_ipg_disable:
-	clk_disable_unprepare(dev->clk_ipg);
 
 	return err;
 }
@@ -1481,9 +1469,6 @@ static void sahara_remove(struct platform_device *pdev)
 
 	sahara_unregister_algs(dev);
 
-	clk_disable_unprepare(dev->clk_ipg);
-	clk_disable_unprepare(dev->clk_ahb);
-
 	dev_ptr = NULL;
 }
 
-- 
2.34.1

