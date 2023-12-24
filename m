Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1C63C10
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mqs9PNxd"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO81DaK029862;
	Sun, 24 Dec 2023 00:21:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=oTbs3cmFB6EKBlw3wpiAvBPHvntPaDTvCod9KAqMzz0=; b=
	mqs9PNxdE5+Kf/TamUyA3i78cbgxR6G/H3jQmbkFM61qf+09NRYe3ATUmvm/Wd/p
	RcZN9pY2hf9fHXaH2tbXlanDkc9EfQm64qP0bXeKv9ONj69IRsRkVmJ2xhUKpG24
	WFbx58b2JTbEJolPY1ZEGSB+npybZU1Gd9MmXM/zfUH99g3sBYQVbX+aEB7sJI0P
	sw4mwhCRhF2bp8c2z0BngrtqaSPUT8ClA4ceHPZDKfXMD6k2nrTq57GPrGlx/g2V
	UUgIKKMgeioZlW7c1JdfdEeHUQjFQw4jA4lFtEhhpUtdsKDlVu9etv/jUQ5gfFj4
	F/yBmlSYK+DhgmFO6TJJcw==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5uq4gk8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7OIMC81tW7uCdp8fXLBNFiaqO+IHB8gma5IkjAi0D7n1yUFOMTsOzWLqphHsHjAn0ni1RzrW/MMTO8TMGMK8Iw+fe85NYMvjD9QXz1NV9/duAUbcyiDlacjm7JT1HUGjRkpjIJ7AAuN7DWfP/CEt5n8t+wjJ/BVdnSenVwFtf3GbzFEWRl06HoZ12MjsSqdu+K01vHVtgbOxmd7zz4O7bjuofkmoEtQvEA83CCLvs4eLrQMorzLWKxFcUi5BWBs+0bcgKZCanCtaNKOcvPVAUzqUzvshxfMfJbeZWM7x1G299b8fKcaZXgGB06vB3OvOiRJsc24okT4qOjExqbWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTbs3cmFB6EKBlw3wpiAvBPHvntPaDTvCod9KAqMzz0=;
 b=c0k/TfOyEDPjb/mbFq85hH4B5PTsikurBpJgZ3zeVCIwuFUDtuiy8g1rrdVcd90jVXjwFbXI7wJjSvlWiRjTwwLE8ktOMNxswqjyUk37CVCdQFPCQzwvu8ueEWeu+x2uEkUO6vwuTVc1AIaOCGfmSlOoZZwcdHYV/xdWBM9JyULN3avBqw8q3ZZArccdBwtPqshBP8RMqCnI6KKGJ2StEKbwOxySdCeSbDCXGNiN88s/5SY+WX4tyeismn27G7TLMdv63jqnM3ymYFygGL1fMKzc3b9Uge8Sc5rYMoi0G7xt1KgphBH/7CxD8v7Q6jwwqG6qEEdLU81s40QxtWYRUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:13 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:13 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 09/14] crypto: sahara - use devm_clk_get_enabled()
Date: Sun, 24 Dec 2023 10:21:39 +0200
Message-Id: <20231224082144.3894863-10-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
References: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0094.eurprd09.prod.outlook.com
 (2603:10a6:803:78::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: 1443a529-7efd-49a7-fa84-08dc04594aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	wyuf4BPX7Bqvo6H0lADs3o3/aMTY6kpkLZ26gwncncExqCvahu9HM2171qYoMkZG5GLn9To4RqREiWH6GIR7m5n/uS7O7NRP82m6WIEChIXoWudfOekh89gQDr51Xq7RQiOPBXUnB3qa/dj2+obm3zgtckngOSd18ZC8/e2FSZVLa2SriTiLL0Kj1v1nJlU9H5zxotOU1/uHXXFvcZy1n1TCZIJEkBnhkJMg0PH/J7E3Fk1sox0mgVMoSop3nT3dPh1YvOB+SvY3q3ojqiC4XdyCU9IMvZ8w0QLLD08ydnV4wIkVskrTj6jpfHAE5+LF6aUPf5GJMMJaipsWufaJFDbMGk7+GU3ZkRqdAKkUJfsq22Mfbn/qBAHwuWyakTVbY8o08kiQhNW0aG/T/aU41Io80h9DAQMrItKFug6/xGoTO94+0YaLu1dFkPetwQdt+PIZYbA/aYPLU3R4SMfNL5cMG4dXZruVJrvOq15N71uQugtyWpcvgEUPkd8I0FT3OuUFSm1ieifwxwayujemw3m2ja2VkZfAkVxBWzgeaARUrf3tCoCz7ieZg5FRuNh03C2OZ43mtvIBimb7J/LxHIljQSyCG2IengAfPJmUl3Iyz+aO+weasqhDn3GArm1R
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?JqhSB6uaCcNMU8bu89tppxpy69TzwjmrgVicBERvBOj5xbVHu0Q1MWO4SYQi?=
 =?us-ascii?Q?ZDtwbOe1ceS1Z9xPvbHeUpxoY2e+hrxltTPAbFIH1BfpAj2c1Kn1kmDzyxdi?=
 =?us-ascii?Q?6NXjreOu2t0Qk+0hjNjFSY55P1M1x0jvv4wUqiQdtoHrXAWhGs7JEIhFXr19?=
 =?us-ascii?Q?MKZsiHWEqiMh82EhKuYvpZZylrn1JSK5UunsKwed1bErArG7bBex5w14fw+K?=
 =?us-ascii?Q?jteP7FMWI4AoWO2MQS8v4XKBXSlvT97llz6wX4EGESluQqJjZ80UZGaeewpL?=
 =?us-ascii?Q?YI9lsQA+atRoIBQwhoLgqZ2sfbR80udTH8CUjrE/6t9NFr3WFfNJ42SeASno?=
 =?us-ascii?Q?Kdfuf8X0gNaPLJuahILpgWU3LpRXl2UUGYQ7QYW73GNjOad5lhOD8ruenqSO?=
 =?us-ascii?Q?LEnhJESAAQ7dd4c8MMN7H+sYs++WEQc/wTZX0q9mdgqMI0DglDZw35Qi6lZ+?=
 =?us-ascii?Q?GTXma9+jV0qw2JwdgSH1e139smZOky2VSmT6wNPSeBS2U1R+y8mr31jjOe+V?=
 =?us-ascii?Q?KuLDuFd9GFxLQOrqW344bQ4d1a2O9WM8RK6GyfbGCJV1bqJm/VTDjh1ZnHvr?=
 =?us-ascii?Q?Hyp9jpIAZkBYHKgiZEIEde3Qy4nc5kXZ3tEV9dCvU16E4PcHBDVpgCzMyXUq?=
 =?us-ascii?Q?E6EhNG2KkKDqJHt0II96x2t+opZLhNlz7Qx7d+NOyaiQGWZi0h6YuBwuFSHt?=
 =?us-ascii?Q?AnSLXxDBoE6+F9sIekoKfD+4wPtXpSRb8fTWJsk1PQ+LKChsIs6xa9TyhGZi?=
 =?us-ascii?Q?6a0fROyLftQcMjIF2Na4AZ2qpZc4v5Tn8S7N164HYGP3s/qbpf8XnhSIFHwc?=
 =?us-ascii?Q?lVC0578gH3NM+V3rEVbDifF4vHS/k77Z8Re0r0mG92yHOOiMPdg7yXvgTtra?=
 =?us-ascii?Q?n6WymroYPMceCjsjRPxCiiCupJabIMLTF0Ci9Lt1mq07EPeL+4/Zy1QRs3W1?=
 =?us-ascii?Q?DVK1/felZYIt6molMLoof95jSSFU+4F72cIzdCwsDUGHhCCmBmM98uoP4gJJ?=
 =?us-ascii?Q?6AEXby7Rr3TjLxsZBGWxoZflICWaeRjGXAL+4uhbtjyPTjw/bfEwAX/1AqmI?=
 =?us-ascii?Q?DGhP7mqMKKueAZVN9Eef72hy/qqEuMd+N+K4wJf5utrli5srr7R8ZrXmefuD?=
 =?us-ascii?Q?Me7Yaz4X5IX36imqzHKVT1DsAJlunMcMGkGh90ct1dhN1RtSuXy5T4BR9NPR?=
 =?us-ascii?Q?V/dTYWQsJ5qwGWOrqnoGEX4Q97no766/3PqXys8G5FV6DJmnmbF7LOTYjpXa?=
 =?us-ascii?Q?ex+CZckTXIRI8r4e+62CG4ZUykt+MK6BdryM+lCUbS2TOp3V8HGR92ahRISt?=
 =?us-ascii?Q?ni8JzYjNIdv1Gjleu2vgKevot5J8qx9AivDy9G1VbL0DsJYgOBA4+Z5CPrQ1?=
 =?us-ascii?Q?C99W5WifOOxMOgoc4/YJpxvkYjA85Tt+rYpma36AmaAGBa0QfHRSTwfCMz9I?=
 =?us-ascii?Q?8Jdm5ozGzxnh9KfTTQu+2DdqzkkNAINCORxPrTyvGAhX7grH/60D7koC47xH?=
 =?us-ascii?Q?adT9K/xlIkixxSzytaWk7fOlkDlzB5nU0ZSurP7TJcnHq8MlvRUFYFALrSHu?=
 =?us-ascii?Q?DcLI/XDTfrFEfW0QOrnCi/v1qOJ4TmKQbGVEJdlx4c6nV6htvYQR9JC7dEVt?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1443a529-7efd-49a7-fa84-08dc04594aa0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:13.1911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EhiLJ8ZpnOPR/RiRxX03PK0Jmh8Q9WT8H3mSv9pn6V5eZWdjPyMoMhqZhFvOlGzT5sB8R1bEZ5haGGSi4hhM8OfYAD3cPP9sXtbuepNHzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-GUID: yeqOHGeonpJs1gb4mOigtsErFJpsZLZc
X-Proofpoint-ORIG-GUID: yeqOHGeonpJs1gb4mOigtsErFJpsZLZc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=978 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

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

