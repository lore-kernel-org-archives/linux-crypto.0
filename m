Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D915E9C
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="VwWAiwJM"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI0MfN004538;
	Sat, 23 Dec 2023 10:10:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=Uz655i0lnZajLzx004uBUnAj+0q5ECAJU6oreE+oOAw=; b=
	VwWAiwJMfTVS3wU9/xnMeiqLJSRLsQJjCAWTNCopfQSPH+9H4ikB/tlYm9PfpCey
	M/qERnbgP19QimQ3SAdLQ2CYW7i4tSWc6KJVQ9yyI8fc2N2q9UyeqNIGrZBRfop4
	1Ze5oeYOCqX8WkJNr/D8tZFZLT9nGq8Hg9rR9WPUeYw8a1M9sRhU+RLno1Xawu2K
	rTyYY68qIFZzlKCTAiPVje/P1y/cxs2LAPnxAfJhJIpQJ8uQNNEVdWvhkQQdM4CQ
	9JxOFsPigy4RrZ2Sv0lYZrvnDhktdQud6Ig4gib1rGk/oDKBdvthV5nsj306KkzG
	JXJc6yb47jONGQrqOzJkJw==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm04cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4Wc6yWgkSzP6hD+4dH92l+mmKiMhVckH8Em5fpAh5x6qkxtvEZdlznPFefg8pdN/1AGUxfY72V8xFId6Gzbp1qEdQ9v/ODDmQNgq5E+HldxQ83xmPwJqfrnZjlCw3MbZ3E8O1cCFYmFzNuRaD3iX//gMS0Z1J40yAnqqF93G6UJG2K4/H2hWG0g+RtkpYbnpcebjU4RVTr5SXLQ/7Hejea97W8aHapVLEiiPqzsyFJ8bYuqqrdG7zRsYcPW4CwTLG/BlS+hklqMgb3DOA7ZrlzZHjoWbpSVyGh//6rpbLxZyM5ZZE4m8PFHQHTxdEOvXCJpZfsdeEQV/QBJ3GXx3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uz655i0lnZajLzx004uBUnAj+0q5ECAJU6oreE+oOAw=;
 b=h59eMUZ03hZaK/tCAIs5J8piOhoHFfOgSrhn82F/5H2w30d2s5F26GctCf4ytsj9kCCwgryoivXQS9YyfNIvRfhzpRjBk+Xqr5BtzrmHzym77ZgtSr4s5SWWDc+ysTahvz+tUTlAUKaFrZD9BDb2zUANgIXM9WOdq+BPhRWxo8sIuc8WbdWB6+Kwf1ciZz86rD1SXfREdUrPBOJRz8N6tEeaaYNLtYJgBCR2gYk/TSvKiYUpovzSaA+v/HMgyysxarj517OhdDVT15HNeOXuuegba6+cT07q4naQUYZ0mnoheern+QfKaZyjLqnx3fU5pDrHp91o4V5lIRHrJm1Qcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:48 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 10/14] crypto: sahara - use dev_err_probe()
Date: Sat, 23 Dec 2023 20:11:04 +0200
Message-Id: <20231223181108.3819741-10-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 04512e31-7f61-4b3a-6783-08dc03e27d71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PMuroFKm6/pDRnVSPYhB0Uc4oUiwAmz3NEY3KkXLCzmTBNJ23FxHiVfywMdWIyXOuwb7UQ440CvWVfvyoTuFtn92NkXiWaoX7aU526gbC1SvAcKYQmNKCIs6QvJQCs17I0miO6PcrbOVS2buCApwQDlVnT2LK0yJfMp3Yzdv6oGa5Xm/bzkpIUtTk1qOUhnoAZx8Q/235ZfnRH4o/rjZPj7P9R42p2cHPP7l/htRLlq56w0JddFNxyfN+MZDi2cZcmuR2vVSKKsOW9tFmMDTc+QXDuZhbCTU4cAxNWlyylLcaJ2O8/YA1rXkFHeHNrQ7qBG68VMQd93Uu/Scn8KXtyj9Dhu+qEWvppsgUs5CbBWDzBqpEWftN/aA2D0WzMot8ci0kl7Bt9KxQckGIo4hRWReqfaM8aImUfWDiPxlaw7cslinCGva2d8yFekjqUMhu7WMF4iJcBc9tm4m1TZ39iUJ4tVpfnczV2zYclIJ8YZeZn1eHX710io3UTsIMxS76RfZE9C0q92BKdKAInsucGZyByxP3nTu53Ne3xeOqIWxpRifjJVTZA5FufLNZL79gQEboY6rK7ZY4NEnp+weE71NCWWgP87E02OdrfpYTGi+Iwc6P+mWf63I5jjCUlpy
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?bZgjbj5sIhhSZqqd49VqzJWbo9KRdwAw98sIq9EbaWjCMpRnJs80fMaKTpmd?=
 =?us-ascii?Q?U/irJc0VkCLAgPR3O2kN2bRjbT2yzvtsdZMQw+KQ3OHVLRlRnGVUyCEh3iBN?=
 =?us-ascii?Q?T3NLGH7UIQ40qHUx6ZwmtY/Q2lNcAW/kpkOaNgaJnn+4n9fpQsaD8a7NWRE1?=
 =?us-ascii?Q?WsLUxE1sfCNntdq44MkiCcnEvT7LonxSqZG63s93NKgJmndAZMVqMZ0UYExX?=
 =?us-ascii?Q?PZ1uP7nBwPstVpL44Ulw9FMGpXCeeTR8KWkVYKPV9gjnFY6WqSig4TyXDAeO?=
 =?us-ascii?Q?hV1i9xFfrV/UGQPLgNkCU3mdwxRTFj6U1NV5iJPngO4RLMIjkGORiWCYd3LC?=
 =?us-ascii?Q?uxCFXpRTqIGPD0KRzu4XZfW5ClZ6dwlYamQYu/NmjsHV2tK8qUTHuywHxQBG?=
 =?us-ascii?Q?LarpcuLanjKqmCRnhNPV2PZzBRpkRi3O+gknj7xQe7hesnh5+ASkr5pLLeEX?=
 =?us-ascii?Q?4y46eLCvZzSxpQxB/j0MzUs9OgKE9xwjwFfboY5I0U3sazTgSOwB1GsVveLN?=
 =?us-ascii?Q?fez06Rd1C6F6CG5ZvtGRGzWLA5tjccNghB3LRIHwFUoDaDO5/kVFJixwwzgw?=
 =?us-ascii?Q?j/CL0Ikji1xRb114rfk/nEdnGDiPRp5sLryOYOg7WUyJ/eNb/QwWjhQwJDUY?=
 =?us-ascii?Q?mjrArvs8zenDlXnrXrQ6WguZivuF+ZEJaPxl0W0GTqHHnTEid6eAoL/NpyTc?=
 =?us-ascii?Q?SxiwzV2v2u8Rr8bp/tQZCFXWqWZRHlKbQ7XeETIW/dZxVLcJstWF2wyOUCrL?=
 =?us-ascii?Q?ZWYqnPcT95Zon4Ots1Wk9O6DIt0Jd/YBrpww6JsN4zzKMzZA3C+Mrr+t8F0n?=
 =?us-ascii?Q?fXCL/L8VCN02wF80hCn2WC+vJWaj0LqQFgYK2XsohXWE8eTBw57rWLAjlfiY?=
 =?us-ascii?Q?CwlT1ii0JVknOsDQ3SuVqtSeSk02r8y1dqZYSTmQR8CQT47L0VGU3FMXYc8G?=
 =?us-ascii?Q?LAtLxtrUz68D7ZhNe9y2K6LGoZN/p8pCR8mbOBJ/3W3p8OrjuuDNH7qDGrNZ?=
 =?us-ascii?Q?R94DSotlb0YDAC8MLQW5uXg4icBcn4NCtZk1lhqjr5vav0h6vBlv4lNw4VF4?=
 =?us-ascii?Q?dTF9k7N3ryKaj8zjxp4f8PD3ar30e9v88HSqXXcI0lnvRMJ57qZyjh3RJfr7?=
 =?us-ascii?Q?PK0oA9JMdL3ila7058mcvcOgs/Pa4DgD/y3v/BzpqO0vS3G58wXmIbL1eYsm?=
 =?us-ascii?Q?z5BA7rDw3yFcNv5Edwk4MUeIUdWiO9pCATPu36IP4xpTz1fKhq2qVNEbGnLA?=
 =?us-ascii?Q?tbJSWKFu/HllXwWyES2HII8YkFKPZAHt4rA1wx0m4CDIAsiAytvJbVjEftoa?=
 =?us-ascii?Q?ORQJUBivxnyDZZ2G/fWk9h4fk2EqCpfyC1fxnkbq1upwdCo0qAs1wNTnUZj7?=
 =?us-ascii?Q?deeuCzksKciJUW1ABKlmFZZ9SqyWtNQevKPBaIDL2UyIgH51taxOvjdb4+BS?=
 =?us-ascii?Q?B3HMprDwKdlB4acmPIqFfI7z9O6taRsN2hXf/M131mlnGsl4xc3vsyrfrJqy?=
 =?us-ascii?Q?Vo+yXV8TBAYpM9HhyjjM8TByYGG6Rflqxu5hvSD/MuAQpcR0y78VVifAmFhw?=
 =?us-ascii?Q?E7X1u+z8ZoZzO3obbgAi5lxWlKI8MCozdmlVhSqEBfGCGHXgVP0OASNxOs2d?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04512e31-7f61-4b3a-6783-08dc03e27d71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:48.3143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ztZ08vmATUXnEPIWMyt/1T1icnPgr85f/bU1zhiUlkperkuO6IavuZePX9xI9IvOJYzZ/CRaDgtjKI3oDocsHmV1u6TCaHosAK2SfTp3Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: EW8P1vUD_Jq48IJMQvNMosFbPRmgK4-q
X-Proofpoint-ORIG-GUID: EW8P1vUD_Jq48IJMQvNMosFbPRmgK4-q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=861
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Switch to use dev_err_probe() to simplify the error paths and unify
message template. While at it, also remove explicit error messages
from every potential -ENOMEM.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 619a1df69410..253a3dafdff1 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1346,10 +1346,9 @@ static int sahara_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
 			       0, dev_name(&pdev->dev), dev);
-	if (err) {
-		dev_err(&pdev->dev, "failed to request irq\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err,
+				     "failed to request irq\n");
 
 	/* clocks */
 	dev->clk_ipg = devm_clk_get_enabled(&pdev->dev, "ipg");
@@ -1366,10 +1365,8 @@ static int sahara_probe(struct platform_device *pdev)
 	dev->hw_desc[0] = dmam_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
 			&dev->hw_phys_desc[0], GFP_KERNEL);
-	if (!dev->hw_desc[0]) {
-		dev_err(&pdev->dev, "Could not allocate hw descriptors\n");
+	if (!dev->hw_desc[0])
 		return -ENOMEM;
-	}
 	dev->hw_desc[1] = dev->hw_desc[0] + 1;
 	dev->hw_phys_desc[1] = dev->hw_phys_desc[0] +
 				sizeof(struct sahara_hw_desc);
@@ -1377,10 +1374,8 @@ static int sahara_probe(struct platform_device *pdev)
 	/* Allocate space for iv and key */
 	dev->key_base = dmam_alloc_coherent(&pdev->dev, 2 * AES_KEYSIZE_128,
 				&dev->key_phys_base, GFP_KERNEL);
-	if (!dev->key_base) {
-		dev_err(&pdev->dev, "Could not allocate memory for key\n");
+	if (!dev->key_base)
 		return -ENOMEM;
-	}
 	dev->iv_base = dev->key_base + AES_KEYSIZE_128;
 	dev->iv_phys_base = dev->key_phys_base + AES_KEYSIZE_128;
 
@@ -1388,19 +1383,15 @@ static int sahara_probe(struct platform_device *pdev)
 	dev->context_base = dmam_alloc_coherent(&pdev->dev,
 					SHA256_DIGEST_SIZE + 4,
 					&dev->context_phys_base, GFP_KERNEL);
-	if (!dev->context_base) {
-		dev_err(&pdev->dev, "Could not allocate memory for MDHA context\n");
+	if (!dev->context_base)
 		return -ENOMEM;
-	}
 
 	/* Allocate space for HW links */
 	dev->hw_link[0] = dmam_alloc_coherent(&pdev->dev,
 			SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
 			&dev->hw_phys_link[0], GFP_KERNEL);
-	if (!dev->hw_link[0]) {
-		dev_err(&pdev->dev, "Could not allocate hw links\n");
+	if (!dev->hw_link[0])
 		return -ENOMEM;
-	}
 	for (i = 1; i < SAHARA_MAX_HW_LINK; i++) {
 		dev->hw_phys_link[i] = dev->hw_phys_link[i - 1] +
 					sizeof(struct sahara_hw_link);
@@ -1431,8 +1422,8 @@ static int sahara_probe(struct platform_device *pdev)
 		version = (version >> 8) & 0xff;
 	}
 	if (err == -ENODEV) {
-		dev_err(&pdev->dev, "SAHARA version %d not supported\n",
-				version);
+		dev_err_probe(&pdev->dev, err,
+			      "SAHARA version %d not supported\n", version);
 		goto err_algs;
 	}
 
-- 
2.34.1

