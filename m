Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD8412E61
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="cbNg+Ddy"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNHpBRD015681;
	Sat, 23 Dec 2023 10:10:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=FXaS56t44zj/tkmmQKSjESH5fMIQsk5WTxpi0bi3nEI=; b=
	cbNg+DdycC2pJ5UTm5DIDKEHsVKk+hbi0P4OIC+3R6SHZrcB6OT9y2dFh1NhtBwK
	tQRy6P5CEkYQf3+sbMHSIrMx6e/63JsbfS5BfxioE9MawcQYRQRAL78CcYMwXzUx
	mh5MId6boujIMOnwxQfXEP0t2ZOY8xEuHHiAZgQZrTLbH7uLQCOpLDGu5xC96ted
	VU/ws6Cx/r0vNZeqKXI1J37k2//ZyIgwqLrn2FZdTxpRnFEKJ3XJsM9PSJqa+8XW
	A+bO5EfzvH3yMTjv227L4asz2t+AL9VHBNawzv+loyM0/5FHlLDaJK01xfuDP3Fe
	MK7qZ7yfSpYLaW7ctiHoBg==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5uq4g8cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 10:10:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5UMJXz41Y4gUihwH25IOyZYq+a+QoZwY7z/9CceKXTgGE+S8ztvVybmS9EoygzZgl9dvHaL3Veg4NyZUfQJUXhYCRzf4LZHo3HAqF709FI5KQ2tlKxswI2IHtTgVZFanMo20t+aBpvuvNtp0U/xcvs6BT3J49VUe5CzUj7ELiIl+mdr0iBa3eEiA1v0uDgz4by2L2GM+obAfc7rU1w4ID+Mp7jdIfIBWyhmeFzGVyBp3YDzh52P/FoILrmpEpJm68j6cTiBILxexOYZSMGrpUerP+AX5htZxjpoQJ23PWd3V3Dwa2CygMmXeCcNZCxlIOyd+Kb9Xe9a7rooJzi3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXaS56t44zj/tkmmQKSjESH5fMIQsk5WTxpi0bi3nEI=;
 b=EXoYk5XTik2UKwKCQXCe3pbcVzke+NMHOZsU5pxaB7BLJ2fxtDXqjZOX2jMWlwDE4q7hqeC5JKe45cCZ0xL2qqxuaPKGTeCo7QFFGSoreJ8NFRyv5+g7OTbYxgt1Y0bP6fqORmPV+R0Q/LJFtltIk1U7+BLQnP9uYHM1te6HoAlnFvOwYdz1yHCXOgdXj98A7I+hi7UAH8WMzlJgRhuz8K3nMTaXs6qPbtUR/qzRLJSgGVn4w/9iduJskapFKFvqjU8DGZRZEEdD3ic8LDXwfHTMk4XdG11MtvWuj/QVLn461AQC+syK6RcplCXpxBwEf+JU23AdDmizicnEVIUsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:42 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:42 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 06/14] crypto: sahara - do not resize req->src when doing hash operations
Date: Sat, 23 Dec 2023 20:11:00 +0200
Message-Id: <20231223181108.3819741-6-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2afd8916-fe44-4939-9f53-08dc03e27a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rC1p3VLw1/g+FWRG1qMd65WcZSoEDkF/j00E2ecd3HI3nKgRLK/LPT0p2Ld+BkVRwRnc3LKhLMpjBBdLP86TerC3+TKDBWHCuhOQc/dlefk9HlekPVdaVEVqQRCYKSGsLpf4ONJDUQr8Ufak15M4EsGyXaPWuX5jrf+0dDBnhpDwJg2aWH0j0fPmh14lR60Esxh5w5wb21mDqRog4NVogwxI5koXnYKsVvzt2kXWmeV4q6cG29t/jA+zaJX87osS6qom8KpFtjskRV1UDYHYaoE4f60DGF2tvqoEflnoCIdT5X/VUAAlqu5KqDS43mgM8j1l1mqoN/7pqNjwctLOBhWAAiixfad3XAfOPe0EGnBwoON+0GdS2r0Zw4Y+zZqxUZBvRT8zz/DLWc4aL/OeKpQtm16XuOdR/XxqvxeC9VkK7hFx0rx8QjDGHEKw5wANYNd0hCUtpvjT/ykQtuN4boEXKJ5V7bQ3G00KHn560l62hioKBFddGoe6CLKG8TOV9jtKPE8eF1uFGCqlNqyDmakKgypunJkfnV1zuhSMeiFOTJZIH45DD5pDLzjz2dCen+Aa59WTnB/sCIrS8X6zlvZPIsVhEbZmlaqXGQEXcwpBnkhnE1hIf794gaBG41NS
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4LeXAx8PEb1K+VbMp8poMabC/8P7nEqFlkxXXK2Wv4ArTRoizfnnWXubdXFM?=
 =?us-ascii?Q?BwSU93PbJ/kDa3X3Vd7igRwPlluouhzNJOoNueDy51q+CZKcRQqAmlVdAykq?=
 =?us-ascii?Q?BKNVsjaxmwBMuRFmSWjSxpEfQ8niIT1B2rEzE1VaUQCBSQgEEL0pljntsHm5?=
 =?us-ascii?Q?lEb9/eofa6ZoxstmxoM/k1DicaKSvJKS9qWa2Duuby6M39HRR8a9YATHkUn/?=
 =?us-ascii?Q?BnetBVRyM6CwgmM4rpMNK3FEM0seJGHjZE7QkopBiiaEhVKcDSW0MasHBkDX?=
 =?us-ascii?Q?rdwxOgXYOnpylChgjzwpte1VdYjZdfHtBa9BZK8oyBLeX+pwJBGmmsF5MBoA?=
 =?us-ascii?Q?Md4lzMowiOlpl75PNNRvmvMGvLNDP8lMQuHzZGJtD2PyA69r/N0ghruTXYgK?=
 =?us-ascii?Q?TxmOQWjq5mvdLyJzSj7sGIv2ZOnTSwpg02Oydk5JrJenEylXmXkC4pUAXKLD?=
 =?us-ascii?Q?HCUripI2vNGGGeVYUQVSt1FNxhcoxFCYf/+390jGAfHaekN4NEiyAwjDDJJY?=
 =?us-ascii?Q?tEE3bN4uwxUMOs/fTLpNTS8vx3RFgybTJOV8QDKoI2Sx80AouwSo7vvB6vNX?=
 =?us-ascii?Q?sdi2IOM+djvCgbVf3v244HjhgKWKeFgBelZ6yG9Iy6493KzHvsLMbVDegFcc?=
 =?us-ascii?Q?bvabrMAz+ZFQMMfu510NcSaZIITbUVL4k/fr4jWfqYtTFETKw5CWiRXN0o34?=
 =?us-ascii?Q?VQ82maTuU/o/r01AH6+G0tHU7UwcEqClTuMhE5x5B36wILDaOVwF+4N1gxlw?=
 =?us-ascii?Q?c3UkfX9OX7DVNFGXrSesIro7iFqUFeGdyv0+Pj1LwfD8MshFim/KD4KxyNXq?=
 =?us-ascii?Q?XdS/eTP7wic5ZTq8Kb8wAeC1Ozae1OGGupHtStR/ICb+oT2SS6HWS83ylUD8?=
 =?us-ascii?Q?eueV8xPADjK33cvDtqHp9SDsZPYpgEBzKUV7Io7txFmwLH6hhZtEDxqERINX?=
 =?us-ascii?Q?EE4JcDupeThv/lRXmcHD/yK4Sgon1os4oSQyzdAwv7JBq8iywUp4eJAIu9he?=
 =?us-ascii?Q?GrgQ+yI0kwzAsCDOS6ypvYdcgxr/0SjpMp4khHI0nEwAvwopkzeRM0lkqZUV?=
 =?us-ascii?Q?N/shnL2ID/9XJHXesJpIhzNt46l9arglNZgkoF56WDG8EUQ20IMZ7IOay3gD?=
 =?us-ascii?Q?oIyJF+p35yGG/ehlhSdMV2YUdZDnVGHkeHHpLMKI0ZJU5NZXY1TVq2UGJ0AP?=
 =?us-ascii?Q?NRjwod7Kj+V38AZ0tOHmcsldNHZVIIYTjV4cEJmgGEvK9gdn4A8RI/hcRSy1?=
 =?us-ascii?Q?tF1NjenR4ptTz+mni748J2iIzjgsWOXtBlM1gP23ZddUsWp5BM5uTwADpl2i?=
 =?us-ascii?Q?QC7G7xZVOST1rLdsV2Jjj15CkvWrfSx+fo/wZYzgQL7qK3p18DWItTVzrrak?=
 =?us-ascii?Q?S7syWFWk4ZQp14ETLDorQyXGpMhqJzTo1Z5PLypaTOclOJz9AkcMQy9sYSWt?=
 =?us-ascii?Q?bv+0sz+36Rhu2U6GqG4qgVClUoEDSfQdSkI/xH+yYjFwYGoly/H8SZ5abN9B?=
 =?us-ascii?Q?hqhgZ/pVEUqRdr9fnXmfOLEw44kRrrJzUmuxefSOuEuDm2vtB0zbK8dws+Ad?=
 =?us-ascii?Q?O4cV4o72fqAMLiH1ySrrikHH8Z9AMb7EB+LwdsnubSROetohSkpzVroOOxQq?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afd8916-fe44-4939-9f53-08dc03e27a20
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:42.7493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQIblDUbmMxPvXBu/pi2aP5UolwP9Oe3i6xlDCskKZv9Bb6DM+7hasg1jU6kZS6YDFAs6IZJxszqWqgikXdvcNlYuESUyctrXCdkO6TPMbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-GUID: eT7Cb6izEvHHoEQqZi7WPwDkBo7lZRX-
X-Proofpoint-ORIG-GUID: eT7Cb6izEvHHoEQqZi7WPwDkBo7lZRX-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

When testing sahara sha256 speed performance with tcrypt (mode=404) on
imx53-qsrb board, multiple "Invalid numbers of src SG." errors are
reported. This was traced to sahara_walk_and_recalc() resizing req->src
and causing the subsequent dma_map_sg() call to fail.

Now that the previous commit fixed sahara_sha_hw_links_create() to take
into account the actual request size, rather than relying on sg->length
values, the resize operation is no longer necessary.

Therefore, remove sahara_walk_and_recalc() and simplify associated logic.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 321c11050457..f045591e8889 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -884,24 +884,6 @@ static int sahara_sha_hw_context_descriptor_create(struct sahara_dev *dev,
 	return 0;
 }
 
-static int sahara_walk_and_recalc(struct scatterlist *sg, unsigned int nbytes)
-{
-	if (!sg || !sg->length)
-		return nbytes;
-
-	while (nbytes && sg) {
-		if (nbytes <= sg->length) {
-			sg->length = nbytes;
-			sg_mark_end(sg);
-			break;
-		}
-		nbytes -= sg->length;
-		sg = sg_next(sg);
-	}
-
-	return nbytes;
-}
-
 static int sahara_sha_prepare_request(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -938,36 +920,20 @@ static int sahara_sha_prepare_request(struct ahash_request *req)
 					hash_later, 0);
 	}
 
-	/* nbytes should now be multiple of blocksize */
-	req->nbytes = req->nbytes - hash_later;
-
-	sahara_walk_and_recalc(req->src, req->nbytes);
-
+	rctx->total = len - hash_later;
 	/* have data from previous operation and current */
 	if (rctx->buf_cnt && req->nbytes) {
 		sg_init_table(rctx->in_sg_chain, 2);
 		sg_set_buf(rctx->in_sg_chain, rctx->rembuf, rctx->buf_cnt);
-
 		sg_chain(rctx->in_sg_chain, 2, req->src);
-
-		rctx->total = req->nbytes + rctx->buf_cnt;
 		rctx->in_sg = rctx->in_sg_chain;
-
-		req->src = rctx->in_sg_chain;
 	/* only data from previous operation */
 	} else if (rctx->buf_cnt) {
-		if (req->src)
-			rctx->in_sg = req->src;
-		else
-			rctx->in_sg = rctx->in_sg_chain;
-		/* buf was copied into rembuf above */
+		rctx->in_sg = rctx->in_sg_chain;
 		sg_init_one(rctx->in_sg, rctx->rembuf, rctx->buf_cnt);
-		rctx->total = rctx->buf_cnt;
 	/* no data from previous operation */
 	} else {
 		rctx->in_sg = req->src;
-		rctx->total = req->nbytes;
-		req->src = rctx->in_sg;
 	}
 
 	/* on next call, we only have the remaining data in the buffer */
-- 
2.34.1

