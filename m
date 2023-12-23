Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D312B91
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="DtnsB+tU"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNIA1Jv027137;
	Sat, 23 Dec 2023 18:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=63lRtlaUPtX52MermXR5DP/x3uPHwy04X/QAvCirJFA=; b=
	DtnsB+tUs0C8gyJWBrPkqQNMcSPZpNXIWMfZYTOttGGTKFoPa2yUTd04TsSAMfSL
	yRdsn6/wlARz0bCbqXCsDIsGuVoa1JIeTePipP7Zr86otz9nDXCxIBoWpKrVjqRi
	c/ul+R5altpcnM8JOPK+t2KLHaqBlwdQAWmqeE3PcAWuDllbucU2eYQeurNBaSJC
	/6J1Ov6STCpFZR67+CQAJnsT0Iv04tZPZaaZqgZ0lqyDEB2dHlPkiKngOCq1fyoA
	Ho3fAMBXSAxQS980Jxsr50wqyYZd+Wlb8MfBb1OkB0ZkXmsb6YtKREMPCEEsXH/W
	lpKoFtPB1hLF3TTu+Y85nw==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60dq9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1Tf0X6Xm1ur15c6cMBm/45U+XFIhHALS5vArVI3arRngkTOrtd02cka2EDJNI8IezHjuwRNOE2Whz5yGCSldq/HKnK0yPoUr6suVCa/RJlO/J+9DcNSy48WMq3vKDsNvBrFS9T3sQp0XV/8vv3I32yWHcvdePvRY3bufIdyiQ8hdRc2iIJTpxChWcNnPEGLGvQUqhNoNJ+6kK40CcD3QcMYVF0tQp/dmtQw5MLFnczu2/mHF2roHEubrcGrh6kTxZGN1JYe12v/kPAsYeCWyYUNQPtljhXTxeeDzUK02JsLB3r3sh0dZhufQMzaFx86nCz8PLALNdj2NE/UQ0ds6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63lRtlaUPtX52MermXR5DP/x3uPHwy04X/QAvCirJFA=;
 b=a/jDulxlBJdQEa6Ak+uwDmrbT6ov4mLk6Umvvq/7yAhbKWlkPsMtR+c1DT+VLFWTYHJqCXerO3idp5cNzAxPs65owHK/yDUTcplL6kqPF3ltnYtiJfkiLKUYeAPEwykcEZTZ0lrpCUsT6cpGpvuK1pdfvE9vMvogDjcnepEX8zYm96TKAUlgE8dRwIJapl4l3c+omfrDLYrJKiyB//KaWK+1Y9l5jgMgDhV4t/+UDMLco7mBI08/zI+UKkg1SH3pV6hS+Sk16FJ1Kw6sPpb9l2jvLip3/sd8gu0CSnqEjQVF2ZwXkJr0D199Rjs41myRj8o4xHWhg9mCZp9dHOhm7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:39 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 04/14] crypto: sahara - improve error handling in sahara_sha_process()
Date: Sat, 23 Dec 2023 20:10:58 +0200
Message-Id: <20231223181108.3819741-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0915cbf0-04c8-4845-9ecf-08dc03e2785b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	TGXcHwXyCMDZeJugPgARbhBZbz6fLWvRTtmAtjiAAlKKk2yyeG5NSi5u2Ce39PVZngq6MtvRtR5qd8JNmiykpAGmzi+CBJC0SX9/TyL/ALtQ9ZH4w166AwJaCcWAcoAH7sRevaJ+uPt/Mrnennn7oUHshIHQCpihdda2dYwZ3fi95OWskNSuNHsA+yRZ0fPObSPmDItWZpJ5DZNcx0ZPYTcFUfUcybzmD9I3dFhYR+FQrYXkCs7Di4/E8FOx0blfWwZbK70tI8gO+/bn/5SKS+Et6+oaRrHsdxDhTENPUkWXG2Z0IqPY9cdio0vKXNj6OtpT1lpIycU8Ab5J7w38k6QrIgsnyRgUemMYfYNz8OKXEj5qd4Lfw+fhAt51785XcIs3OdpSdbzklT7Ce6zPNitpIArHg2lSCcVGfgoaXuZqS5SAZtd7HxpVYieV5t22DN/bNxNWK+1feYdwrZYgnhYvyDXGWqmGqYIVzroXeVzGjkojKuizAEhRbbg96oJOV5YIZeW9WmHs/ilgpPMSCwOfN5RRaX1oyNdFO+0M+fD6zicKmq1SrsY1ZcxO4dYlWONpK696/mf7q+B+HO3Jhywwol2RjN69bwN+0ZD57DEJOdgLsTjBaw/ntXG3UXZp
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?bcFcLwLPo3chPqW7nC+0rURSM4UNZRRgl9mSHV0YODomeDYU9aLXhq5k3kqc?=
 =?us-ascii?Q?EBW7+vKL9XMyQNi1qyY88Erxlb0BCLd7Ei+wpG+Iu/eJbY+2zL3GR/4M9Mv+?=
 =?us-ascii?Q?6OPbRG0kyjV4ipqvPOR+dzcIkHrXMz6OjBujpnYf4FNtdIfLQAqbksgyRmKC?=
 =?us-ascii?Q?iJdF19wLKrM85qXjYrU06ZVJHGZTYbrdrFpkvAg+oK3V2QdvsCoiDTunJJ0C?=
 =?us-ascii?Q?N2+WGpDnX7RILrEnO4RIiMcrFwAhj1AB5zohajKyOZGvgFTOx71+lL3oq7mY?=
 =?us-ascii?Q?DsNdoIgLTJY3SExWPk6PCSLXukMz21hEQ+I7rKhYdQrFu8ryx5skF0vyO0J/?=
 =?us-ascii?Q?NgbQhDDkcDN/tQeL6mdPqgehKCAaaTx0QMTuvKoEyn2MWuNNHYrE23ycv1ML?=
 =?us-ascii?Q?rqgNWsLUq/n048Em63+VzDYCmCxRRQjR94kZGGn8pQ5awIP+Z3AG9qOy2OU3?=
 =?us-ascii?Q?w7U4ZA074FsyEg9atNgKRtsSwzyWvebsDHw4kz0vAz9FnM+h+Bg/ZcZ+HvHk?=
 =?us-ascii?Q?j93iEJNrTF9u+k8tNcz1/DIY632ZX4CGOjOYKpgWA499zNWMf52g0DzA5Kws?=
 =?us-ascii?Q?nQyGYJwaSySDP5HwdyHWmoX11G8X294Azc58+XKtt1Msr+p33jJIBbgiqYcj?=
 =?us-ascii?Q?DCTwKqdJCWos3ViTw3W3Y/j3luO20IsNwQRS+l8oAq6X7Scy+zb9HZggjJoO?=
 =?us-ascii?Q?tjqkpaIvpmtd2Xoi03juYTcyGWZxAPToz1XVxkkxVw0tieEVBOp6h38mxJbw?=
 =?us-ascii?Q?hL8aHijnD4a7kPxIfg7q2s6yZP/LpfDaAFZh8LEzzgRlshsqoWo+hscT6+/g?=
 =?us-ascii?Q?cleAsuFJSlQTjybq5ThtjfafhMRzj0VrNOri/jaf3XrqQcsLxYgGGIo2uEb8?=
 =?us-ascii?Q?RUiP4Mca14zh0stWfMTQEDlJ7IymU5PfID3jQ3uSADM6ifFrsupDfSwnhZfV?=
 =?us-ascii?Q?YTQ7x573oJVaQpuO0WJPFfLwJf1uHK2lfmwXoWkiwo5d3vBsMmftEMzUuC8D?=
 =?us-ascii?Q?iICrFf6S4ppydZ8aPovcsTNYxWwpVpjao5devuyBNCCBP0PJtFfSqJm3iu3u?=
 =?us-ascii?Q?EtxAjscFerY+iUViFg4YliIQbx1OdC1hmeIy+LmO4iZphGlWzz03/ir1OFVQ?=
 =?us-ascii?Q?EEke9kmLgeirYg6xMHrSP8qW3lNuvAK6PW8bQc+2mdgm5xGu7WXpus5IeaiN?=
 =?us-ascii?Q?bPXFFRcwm2MLSCBx4iOVLw1f2adcIP2P+NE32FL9T6e1E55pnIqwn8lDRr/W?=
 =?us-ascii?Q?zzACOEBM1yCgDGCeC8sq0XILiR8jYI89ZE9nYiJsBL5eyyzBQGLOG+/pEt/h?=
 =?us-ascii?Q?YaWSZkTZxf7Ne6gJtaqBDQUu2t9QGMSpJQ/punM8dic9XCFDkE8Wc5sOPjKv?=
 =?us-ascii?Q?Y6M3m9sQYONBQbwqR5Fiyf5G8hLpvO963JQqjjQXK65ySAFVe27+lhsV6U/c?=
 =?us-ascii?Q?JUHSKo14+fCi1biJHB5A1t9wyhOWWI6iGGJjy9YSql9UD3hTl9gurZ7IloOE?=
 =?us-ascii?Q?FvyHKXzlCW6RPglA8HirphZKvyzb/LNrz6iQuuseSoMN7ZI8vz3xmMGZXxML?=
 =?us-ascii?Q?ENgSZzSnOa370HfjrEE6UrepV7skw66zsymXXwW70jXbp+lWduWudJlEA9LN?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0915cbf0-04c8-4845-9ecf-08dc03e2785b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:39.9205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCS46hYSEI+A3vS9x7kNb3Iz7jgcWP2eMhdvQk4XJbPLfkRjVLmETGkAIRohqOIonskBM5hWeu8VVehl9jWiND9Qv+klQsBU4nfMScE5uR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: KOIwVzhtud_RQyV21NxDEkBX_zXclFP-
X-Proofpoint-GUID: KOIwVzhtud_RQyV21NxDEkBX_zXclFP-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

sahara_sha_hw_data_descriptor_create() returns negative error codes on
failure, so make sure the errors are correctly handled / propagated.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index a9abf6439c4b..d49659db6a48 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -985,7 +985,10 @@ static int sahara_sha_process(struct ahash_request *req)
 		return ret;
 
 	if (rctx->first) {
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[0]->next = 0;
 		rctx->first = 0;
 	} else {
@@ -993,7 +996,10 @@ static int sahara_sha_process(struct ahash_request *req)
 
 		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
 		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[1]->next = 0;
 	}
 
-- 
2.34.1

