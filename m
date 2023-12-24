Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274AD23A8
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="n/wCi1q6"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8B60p023677;
	Sun, 24 Dec 2023 00:21:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=2/bBsHOnsse5CzDHR3+pI+UvwBS47SrmGuAP512pr+Q=; b=
	n/wCi1q6//9w9pKZPpSONwHNOXBO08qW6kD6BKSFBaKU53lm66Of2Ju8HzrOVhP3
	fvRZ2xGqqbvc2jz1laFSeUQ+hqmNqjpPDcBQ+PRR8DuhMHsyalpjToHXtsCiHYtv
	0A322n8aMurj6EyWSbLd2OE3RBI/O1FUdSj0bIweGPvxTPYwHY472XNjs2TUPeuA
	P8sfPkbtDdFHaUiSA55d3s8z57o78dyzEscEhJzwdnLFQq8cW+jbW/FwMIhNIoG3
	6MEa51h78cuv4ev0qRSkbw2d9aVSNxRRDRvZz1OHzhYCk3lkS973ubMx8mqP24yL
	+vj4awD8B/LsickjnFZINg==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0f8w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/BO+Xx7RuknIerS5Dq52WTel5rxL0gQYYEy81bJT4GPwOV15b3wrHi2qmNrb5Oo7lrCrylX7TUbO7pnrBmWJEgW6EgIGBiLz+zEw2y0Y/EWyMoBlg0RPfu/cD2pTG3HAkLmO8AKVNFq1lkD1TLKhK16vmj5JXu79rfYrGws+lYRVme+ZchbW/Macx0SMB7uQWcbLWqKr+6vUZrHInQ0hYUajYP2jiNXRgryI4qTWtQfOuFfqmzsw0WBdxjxX1ZEQWkFpdXLgp0uipg0zi6kFTmvV8fVAjWK6utu7xTahEykb1oEatkiVzcXQPL13Xxrv+zoc5XMcduVfvPAipb+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/bBsHOnsse5CzDHR3+pI+UvwBS47SrmGuAP512pr+Q=;
 b=VU4RihxTYx5mIaxaJ8Mmp6mYenw87KxErHR4sWJFE8JDw3vXfSvq1dpx0ZDM4HNbit07zIQj+yZZKCfGYsgiJ3D7XnkSwv/G02EMfLjHRRgq5iKK8KztZvyMMRGIWwq25YroUDzPmkd0l3pMo4HpqoL2AjnTu9gxYx1cLSDS+OnRPoUBuaEzu8qgZy+vAYg0gf3uqoTLk9rKHtkWoMDFYfrQ1pEcKmIMGW3Y5vnfIPAEYELI1nU48tGUWd4oLotInQTE6hI7Ixkia6eEBtbceXIffs3JhNykCZpepRH/dFaAc4tZAvTjW9x9DV9GXZHcO543OCn5qNFZtQUu926jdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:07 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 05/14] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Sun, 24 Dec 2023 10:21:35 +0200
Message-Id: <20231224082144.3894863-6-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1b6187af-c075-430a-330f-08dc04594731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zinVP8kj6GH3+W7L6Xcw+tMl7JDXTHC03GylMrkSikmlhiUlBSKk92GQQRoHBsUHNtBeKNiGRRb+xIjs0dfVP0s1QdqXK9K+wzBfINefJ4zDSyZlQb21PCSQSEg7BukV/1rbYf6Rj0PQ5/R7l9k3h5k1nLEWZ8qqahulX0fb+rVcXHK417KkJ8AogolyXyI879Ont9v41T6ihcQoVvlPiZz/HwoWH40MxuhfzLC5BP99Zp6VJ4hpLaCndJwl/4Q9kI+mPmp+G/6/WCYdyfSVTNg97QQqgiUULaFhvW8bQTwSkRuJV8nOZQsCaqDVmwXtkrYaabwnmLz44D4gkUO3OZ6e72lWBqAnF95ZQn6Ksp/FitdKfTauXvgs0UQCTl6PePpLzyWivOhphJhthak5y/zjtBpREtYiyRkBdN6MTqptND6AEfYKessipB0jlikmYlqQM4PCexK78zL+dol+uYP4UGBOZCpuFVIQFb/HYRjos48b6DCJP/h0wb5qL3L733WenuqQIiL3Krry0d2u9rMOAsx79HLvvodX/WAzsscvQnlet2HZr7TeTqCs43PwTWtSVGFj9NxnPh3qaBvUtkx6JhQZp0lQheYzbyeUVkzT3wT+3ac2eeC1/VRPUHVn
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ZEd3YTg/B9aA8yjyHF1vOsFK4bMAD/T93Y3BthD7aUbQf3wpf6g6FEs9tfd8?=
 =?us-ascii?Q?VfXXhN7CAsEUJphmuYM7uaY7YyqqczhrtE8EdI46lSPWl81quznLUY2L4rCS?=
 =?us-ascii?Q?S/0Z757KijXxr/Rs1Byvf2rU+Iy7ujpyeps3mU0sIb4IW1a6fyMjBGJzjfBJ?=
 =?us-ascii?Q?s50GcKd7xxzVSbNXp1wjN2l0eauA2b/K4cMRc6YGK951G6ycgcq6SgcsC9+z?=
 =?us-ascii?Q?Spy5xyl7OWvr3Rahw1b+2AaKtyqRaHoqJAulBueT1WPQvYcNvSXdp0bdGs1b?=
 =?us-ascii?Q?f/stGG8C/stVkEDEhQCW4uH9tT7OOCKf67WN7zRP1YM8mnRu14NO7+b71xYJ?=
 =?us-ascii?Q?ypT/Yq6ARc/EMHp/D1Egq5TwTcLgViMqSGw5ooBVrrBmDRWX+VL4lTdaI9KV?=
 =?us-ascii?Q?E/0aXJXszL44lqcHeAc95djTXHKxRdnZsgmSG5TLe6kzCgiSXqcnlXmjCIBA?=
 =?us-ascii?Q?3+JocAGYV4Jm5biSPrKn5CWAHg688DAJ5nOPqWsdjbTxUQ/7D9VH19cTsJNV?=
 =?us-ascii?Q?IJCfDNLLWsa0R4B+LzaohxCP7rLk3Sg4zv64/Hh63t8kp5vZU1QQZLpkqrim?=
 =?us-ascii?Q?DvYnEgb0E1osV6tEkpDPfFGyaHDym6eIR9L4TZfXNJPQBOsSBW/ims0EiqHR?=
 =?us-ascii?Q?pKVJ6F40NSh5/uOPcyFEC8WfNY3iIu1Otq2WIHq7vrgT2xSeSHAaGf9cLR/o?=
 =?us-ascii?Q?UgMIgHzq+zLmiUEQllEhzASHw5WHYw2YMr9GfypwTOw4/IJMcwhnoidzJT1R?=
 =?us-ascii?Q?EOyA8YEtrVHH8kldxT9nIGm5gqadl+GwxQtDRazX2Uq3ckQHE5zMBqOGod5p?=
 =?us-ascii?Q?P82MkxYlYBuyL8aa2+hzkE4Ih9MzbFBopTLyFTRZJz9SCi8ViN5wKQsYVCcH?=
 =?us-ascii?Q?yNIFH5ay4WRDJlwfDla36t8s4FVMlqbixr/r1O3BIaPvxnimf/37c+DkIcXO?=
 =?us-ascii?Q?kVRmBUDHTASNzxdIbLImIdfHngUIq/lQc0p4BF4bB8dX1/5IRt1LRTjAYPXR?=
 =?us-ascii?Q?3wI5nMVIYsJ+eGY3OSFs1Bi3kZjfPHwJAmikkc9iU3OGy0OT5f0p6oRYFXzZ?=
 =?us-ascii?Q?6lAi8HvJ0LgVlaoVipbBNqHlIKQqIFHenl0iPlnIAX5MFWW8T1NlyVBkfGpV?=
 =?us-ascii?Q?nDp3/AkO8BMI1Avc5yNKyq4MiwYyjK9MY1GAyJ9olU34bm755l/u9kUSLX3x?=
 =?us-ascii?Q?uKNn4RB8pJFZn2uq60pOR0aYilALSS/9oSC5rKnOSOqYJsqnNk8QqLWhSxAB?=
 =?us-ascii?Q?WZ0pV1zNH7S4kwHig1iGAyAplJmgJ2bgyP1uqaRk+GJgF2iATSpvwvqfn8SY?=
 =?us-ascii?Q?WbVF1lAw7Lr1HjZbk0ztkSRgBdzJQVLmopQQETgqGQzrqNUbOOMxE/KucGME?=
 =?us-ascii?Q?IBWWmSQXAiORVMfluyvvRbnh7bwSSXv5+a6RACsrIZIA08aCE9Ky7wsfPDZH?=
 =?us-ascii?Q?gMxD6HBQDsp+oxuRbXEvlxCz0OjlrCy8xf3XZ+Kd1zA7j59AGBUDgUrdT5Pf?=
 =?us-ascii?Q?7/CFEqInQf4oSBv2uOBUMxd9M/mw3QoD38yiJJnfXbEpNy4kBcAP3ffX7Wy3?=
 =?us-ascii?Q?Hi0wInOibww3cm9fuk4OQsm4uIlxpH5SaVbiPMJYgi627QcOQVcnAUmvhjdI?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6187af-c075-430a-330f-08dc04594731
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:07.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mq+ed4QMsca6v3B+qCCP2jEujYGfQd+RWjaR2gIP6F+VMJcRzHWNQFg78YBOVBo10G6B6t6iWnqKhHBNtwTGgvpqaKNCY+71squon3X6aAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-GUID: byZQmAb84IuqYwKb62KhYVvmSa0lZiqU
X-Proofpoint-ORIG-GUID: byZQmAb84IuqYwKb62KhYVvmSa0lZiqU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=920
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

It's not always the case that the entire sg entry needs to be processed.
Currently, when nbytes is less than sg->length, "Descriptor length" errors
are encountered.

To fix this, take the actual request size into account when populating the
hw links.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d49659db6a48..321c11050457 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -774,6 +774,7 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 				       int start)
 {
 	struct scatterlist *sg;
+	unsigned int len;
 	unsigned int i;
 	int ret;
 
@@ -795,12 +796,14 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 	if (!ret)
 		return -EFAULT;
 
+	len = rctx->total;
 	for (i = start; i < dev->nb_in_sg + start; i++) {
-		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->len = min(len, sg->length);
 		dev->hw_link[i]->p = sg->dma_address;
 		if (i == (dev->nb_in_sg + start - 1)) {
 			dev->hw_link[i]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
 			sg = sg_next(sg);
 		}
-- 
2.34.1

