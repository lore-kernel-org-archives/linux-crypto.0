Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D61115D5
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Jpmj18Ka"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8K2Nv026379;
	Sun, 24 Dec 2023 08:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=0rAUeiAqaYdpfPLlrzzDCDA2SPU31o8AUYxcDRcy5fI=; b=
	Jpmj18Ka164ULD9vHt1WddHVS0iA0LbjD0THLAsLfzPL22gWz1xb+/F8jjiwXBx0
	KhlHjMCDMW55kaFlK1N12/+t8fzsXIb812IUsnpa6UZXKDyLQAcFXk3Zltko8o/g
	MqrUMp0Kvf8usU+8UyV9Lw0ZxREcHIn+heYCFsGqSwTsRPntqbHGVvabSC2WExws
	PBpbxMAC9RSiwqZtWur8PkRvaxdK7QXzAKSuLSq6cS57DaW57RKfQzpjeqBKZYdQ
	W5CLircDZ07vFt+7yf31HBbp+e35Iw6DE6UZ82G2Hjh7X8dXi9rNPalKkeqgv2Vp
	h6BqmpczR0ApqJJStIj5+Q==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrtn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSOs30Koxlk4d6wQPcR2/hRKxExL4xPx2nmWvLVLUEChDtOI10xJwX26+MDE9M3JBDzeWxK1GGsUoIv4uJ+YLMo3/VLF94Do87IfX4OB0PDToODyXn7+33nKSLtO7KKHiVVDmtltRGPRceQ21STyuYffdYiSyN3anku3IFlRiVRQG6ZpFB9ukv/fF9CI0jlvDTJgAr4w/XRohrgeti21gdAtfnPIFy16YTMFCumkfuZ6q8nW5lrobp5n7ax6EHuZtq/zK7cIZR0pKn/476m8WV8XMVibWQkqPg+bhKDsikIWnzMP49QgCoUv4FxbnqYY5fDJzSX3pZv60QZURoh4Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rAUeiAqaYdpfPLlrzzDCDA2SPU31o8AUYxcDRcy5fI=;
 b=g+5BxEc7Kc7o9jrame675YCFCMdk/4W6aB4/I2i5adFS3S8txVXUzjOlEIzWlYzDNNpuEVwHd6vpd2nggwfjbQGfp386NjcWV6tLQJNkvgkjJhg/x/EKOuK5ioiUApZAUtCLb8igRRieRsYwGm/19pUFEbI2FHrL/dnyARxtEvzLxr7sZnE8B2RryVvgm5CXfAGTp8dYq5LGbLEpPrqJvU/3Y7Aqt69O/RbxA6hx++/0ghUJEhPZCRpwjzBvYOHJu7KLtRrrk8uyk7xRA1Lk1bWI1+nb/xZ3AAvb8Bj2yBpVr1Eh/N7fgSPW1X2x1H/PQiDRC9zBVGm1wQPSIICshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:02 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:02 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 02/14] crypto: sahara - fix ahash reqsize
Date: Sun, 24 Dec 2023 10:21:32 +0200
Message-Id: <20231224082144.3894863-3-ovidiu.panait@windriver.com>
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
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: e212d61b-290f-477f-a364-08dc04594457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	llqAP2rqNvVluP93Kfn/++HLtX6hWJk6hfxuIJyvzlbkBKbRFEfAMdZKJANwQdHFBPL2xoOyD53t/CpRVa+sDyN+YkhKIFnwKVPA3hOyJtFCtIInTjIYxDxjl8+j2iUlSVggM7/7HmybYl3MM4Lp0T6YJG1DLcHwOLnmwx1sYOi7zS4GNHg3SpPJFHhBPIOQ8/9nBY8CszSlclPNQEeXJM5p6v/z4+doV/kvDLxj3lvW7jVw4+j/9AzB4ixMJKMlVWyvVzIwLfhqEoXzbTYNlCwBz4GE+2RY5AOO7i9wtPUDmeGOxB7m0WCrXLVgq2U0H5XsYcrYjqixcUpcMNhlWGYlL2jbH3V2TtQj6YjEDizuMS3BhhgCimx42VEyGL2q9bnKRpIOmKkvEOA/36jRwi8arqTIC8OnLskClGbp0BEfsYbLJVA2eXzgDUX73FLK4TeR0YESOQHOAp7ix5f660bY9zKvP+iVpwnlFtZHapPSrZA4Tky+CxFPKLg8G/zacMESbOM6U8TiDF/pj9qGv/jTQsO7JHP0uGrcuAfRm+VXNmTKwA3kTGuRAbjDBwLKHe71uLECjL1q8azIol2nB2pU/eYngb/cdexx/CHtkmQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39840400004)(346002)(376002)(396003)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(1076003)(26005)(2616005)(52116002)(6512007)(9686003)(6506007)(83380400001)(6916009)(86362001)(8936002)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(6486002)(478600001)(38100700002)(38350700005)(4744005)(2906002)(41300700001)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cpEEUFY3bqRgvUlIZam75jNUfieqy97kSqexfnLBhEVvKVLJh/nUlTxJQ+lP?=
 =?us-ascii?Q?209SYYrj9TuGyraeeCbavw9MefITqMRfxDWM1po/+EwVup+PnWd5/RbOTMkf?=
 =?us-ascii?Q?gTWdfn7lYgQ1LgGaHyfC75cY6uTAhlnr5STqDqtcW9HGnsMYjuxIlV/gV5OG?=
 =?us-ascii?Q?lBowNVJ59llseMUI60p8l8qzQuK1gB/zphEwtamznUq3JxFpAIebFc81U+CL?=
 =?us-ascii?Q?ufz4UJGI7+CcCTWY16wcmCbuzqlwcBVCOfe4RkBELoboldaHpcpNGfNIk2Xo?=
 =?us-ascii?Q?OSP3jqCj5fNYue+liDVMP/MjK321qJFvu1ZbYiDLJyUHRNlnFZiXeOj31Exi?=
 =?us-ascii?Q?HKKGEqyhjUFOFwBi5ClI5zplFhDNZI9VtST8dFLuRM2FRyO3BiYBYNqtq951?=
 =?us-ascii?Q?4XNXGqnZ7yprCJJa1oDP2pcUnpbhFRAz7NwAKIFa7OgMUmWnaegHR2anPcwJ?=
 =?us-ascii?Q?MR9NQFZA7BVGrmYQOG2hPBbNcmc9ClowbvWq49MS9An0fUtMA2ATfj3rw7BW?=
 =?us-ascii?Q?Da19zoSpt3T1sFij1gdLEKKvT0Jc4uHgco7DIhO+F2+n4biaPvVxTbT3p3p6?=
 =?us-ascii?Q?ziNaJ/nmS65NpKg6LUE/nx7NA/sLrjpvnMOu/UnPGhS5lCUs7Ay7HdpUgLpV?=
 =?us-ascii?Q?VJiYOixDjIIhgFji8wBhasyXqJR32/bIY8LT+FIZAagAZXd/dYvq9GzNNae1?=
 =?us-ascii?Q?oPkfUxkzsPjdk7is2S+CyHChCy187MfM0U6V+6yy3JjBYZWSIuih3LYR+vEE?=
 =?us-ascii?Q?GRL73eccX6cjU0q9fu1oSpUjvWt+Xrtlk3mWQ8GE+cFGDbIiQ181o8zuy61v?=
 =?us-ascii?Q?UqqLZuAq3JlfgCY1Z9iUv7H2U8ehdcApavnYXgRkFun2qYFvLufMR6alXVIB?=
 =?us-ascii?Q?HFEJwCt21WG/lDkn8l9j0W5KwUsVffF+d5zo9cNe5llk/wejQrdfRYp2Ah8h?=
 =?us-ascii?Q?1/n8As2mSGF8NS6UQdCv3zmGiiWVLpRA7ejn7qo7clBpT1Pdxxz0KJSHc+Qe?=
 =?us-ascii?Q?nKnFtVHWgPQ/zjXxaeY/THswC0k+AxfFlEVWICY5QG07gAiPR0NFBKOfJ9Ko?=
 =?us-ascii?Q?2RfdmSDnNWrvYzmQ4Mfie2H8J662wxiTakkL8fi9B13litR5d+z1b6xam3dC?=
 =?us-ascii?Q?QkmDre0Jh5qQhxj3tkxks5PQrsCNjgtig7iEdbOIH2NXrNUMqfGQO5J6g8Aq?=
 =?us-ascii?Q?K/4YMHDQjsTMOnfDR4NSiRn2lnTcIo5tkOReqy4GZ9yykBgBVxL+G1pesd+F?=
 =?us-ascii?Q?oGVWkFBYCVag7msRP4r5b1gYyLp+A160s2bWB/afJMsB+1lESUdMcDy2Ulbp?=
 =?us-ascii?Q?UhdJSUcT2t7kfw9prupKpKYrr/NQlg4+mAZi+/FcnQMJUKOmKFbtyfR3imVJ?=
 =?us-ascii?Q?IYVB0ytZtp5RTlw3sHCmYfF6/WNHDD1X7ayZvtRM02Er5RzQbDu/v+f0zxeK?=
 =?us-ascii?Q?6gBoR4tI8rC6TEIsOhbARUt3ugt24XJUm64Vhr22wd6A/kY5IhH2C2RVGLsD?=
 =?us-ascii?Q?pya9UV1zPP8cadMifMVIImjnppnuOdzG626fZvnex0qDWkUGs/NA/cA7Ymng?=
 =?us-ascii?Q?QzjJeJ9jOS3uBWMfBFd8K3UPqpyTsQD8M89QxEZ1OeaqMnYiJvn5FKnuO1XP?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e212d61b-290f-477f-a364-08dc04594457
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:02.7976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bCYtzRIBULd2DUTGjlIOxrLFePj2SkkKjPfe2hsCerCXKK7y3e8KfI2/lEEakmBQj1F+H0goSdwmqJJUuy84YfdXW3u+xK5+48Mosl9bPRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-Proofpoint-ORIG-GUID: XwcS63CQvfVGWFCRMfUB--dzijSf7BVT
X-Proofpoint-GUID: XwcS63CQvfVGWFCRMfUB--dzijSf7BVT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Set the reqsize for sha algorithms to sizeof(struct sahara_sha_reqctx), the
extra space is not needed.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 1f78dfe84c51..82c3f41ea476 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1160,8 +1160,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
 static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct sahara_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+				 sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
-- 
2.34.1

