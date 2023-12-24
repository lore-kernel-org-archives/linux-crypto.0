Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31956211A
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="f5Y+d9qw"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8B60o023677;
	Sun, 24 Dec 2023 00:21:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=FXaS56t44zj/tkmmQKSjESH5fMIQsk5WTxpi0bi3nEI=; b=
	f5Y+d9qwIDJcOhFatZroYASAH6OWaWwAFiQozWouJJpnxrFNSzv8/lbeCBzKS7EZ
	FaMQ6zMhTs/nC0lnKcdhKf+kppbJ2cKl42NFBpyW4GcFLT1vIb8uuDrBMHkdeW6b
	IDQkXHmyLjWxdN4V01halURqLZ4nCpnZlmvhfHRqjye8TEUs9vx0Sga77n1pt5pp
	ucvRlG8ZE3ST8cmHFfdc1k/kihLzLD1IBrfb+blEVRP61itez53h1SsfN/ON9o1h
	WuxvRaxpSWmZnjLRPzTn+Xzi3atA9PxyMsA8hQXCFSVj5oGu4hjyI5hyd506p5Fn
	mqb2QLCVO6pzmYp2LyvEFA==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0f8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9blGF1AXZdZ9+F3ufUS+N1PuBZoCf5Lr4N07CSix83h8+LCdxOyE1qMczdHCNmcBSOH8ExMmPhV0EWp+Mm0aqIjgODzBF9DTyOcrfRYmmbKF05W2puv+PPW4O66ymNjmFxxcB694USNVD5U/6o9uZo1+DRQEO2D7NYAX7eRoWDmqJMBn+9jhOKDbt2zGunbmG+01e2LA4Qtb7tX8sgbxb7bfQCrOLkz9BhpC5xBrHaZi+RyWaCGswk2S9L0I2xsZXAKrKPEPBT4o7WL4Z5pnQj/l5ZQfiC2ZmPcqh+JssGk8JXkqPUlOorH+lK+14X2wvLwQxwISe+WpRow4GeWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXaS56t44zj/tkmmQKSjESH5fMIQsk5WTxpi0bi3nEI=;
 b=AjPGnrJPjQC9R9rUky9HVzIulqci7x1gd+dEy5E/6XnSYbcvhZiuokhLslYL6oDRSXIueY3rkBeCWCORbP3eRMsXwCDQajea0RCqfq3MTepc+zkvu3gfTGjJisUheiQ4YmLBmrp3WhcLTpFW2RQuTWOZzosSEp9UdEQ8QP2rLS5NEThKWHrcZ6aGIupUZvUESYYKIi3lUYmfIlGFCYLCANoTThu+HQEQmGsAZDvT6eN+Nu2fxIlHkoDoMUlkR38/jqvlPTFkgR9xk1epR41vgUfYLX7FkJWHouQGbhcPqnpcf5Ix0fRerezllEhP9L8ew8oQIr1A0NhoUjEVduO/tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:09 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 06/14] crypto: sahara - do not resize req->src when doing hash operations
Date: Sun, 24 Dec 2023 10:21:36 +0200
Message-Id: <20231224082144.3894863-7-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: c223f1d4-58e6-4a8e-c7a2-08dc04594807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	URAZtF8FjYOZANodqSK79pIIoO4Rb8OQ9yIrfmEJPUFqjAMdQ3vDgCRN4UUlcAUrb1wxzg9DjuOcpYGMct4tik5le2HHYv80oZ37BZGDPezHm3lQYQN1b4I82SeiH9dO4D65ga/QDlSge1v5e3dgfnHdCjmVrspIpHU4qPrSGHXjVpAmQ78/8GyFyVdH/W66vwSvqZ/ZN7euWGscGKxvWp2Fznq5UmQaXpBup5BXfVyCm6cQAyw1q1jvK5m+7dJzueyPMyQ0mbsvlOKJdypF5/fiueGBJ0KLK+jmegzSnRu8Ktm6vYkBGJxRWgMOIAdkXJfsERJTyrntGv9x1eeKSVvTlvzhf3VrBj29LFgU0M9n7w020yH/HUSC3SoCEFl/2P/7g9EeK90KBsg1Hnngt3fIZsLgVrHKF/sTMNXYJaoAGTnJmu0s0HswcUZTTVO95iW096ROfXSFztOGbdKetTBaJmXTm4dq/kfTmPb2hm+pA7nuiys2Qco9nMEWihf8PNUWhts2Ptel4NcRIMzm13IOGzFn+UvKaYoFfAiJ15ddVa1dZgtfDiald9KWf+jJ2YvX0dCsgZeibwZ3ddM0h14XHLJ7J3EAbBTUa/n97o9q0NFb1qHV76djFV0Q+CIq
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?eirs+2jOB5T2zqBBtrypKJXeIiV/Ca4tS81ueKBH+sPZDR8fvlVuw515p6fZ?=
 =?us-ascii?Q?8QuNqBfn5UeDcU34+D7YgFUFHo3VOfwGfCLphpSCzFsqsvGUNAjlx0Un/plJ?=
 =?us-ascii?Q?pRX+aT9iLHgI4ylP80FD0RvVwESx7Gm3Y60WMFLUagmg0fRfotvoeiFja3j5?=
 =?us-ascii?Q?AR+9m0XBl6uNZ63VzIugaq0fWztabugLnGO+xr7iEpg6rnfl7TStfH4EeWa9?=
 =?us-ascii?Q?+75XbaSc6j3i4ruYdzd+vtcWcia/yos7KQuEPhZzQeySkoCYojDZFb03vKVA?=
 =?us-ascii?Q?iydQ6aCONUGa/C/eIxC1EJD1TCNLnNHnLBeQLahhLmjEoYsBz8P4kV4LqGL8?=
 =?us-ascii?Q?geJLAELLLQ6B++jBjJlnssZpOFJm8r6gTqaWv1upiweYMnAsCWjEDPBza3/l?=
 =?us-ascii?Q?5mxn/m5lwsUhC7Gy5qoDohx1kRv4hEi/q5MzBuBJ1C5akgsz/w+Y9VWPHDJ/?=
 =?us-ascii?Q?QtNcvnFVCHXqPTYFLEajS/X4OeewCfw2UBne3OCfPm49cFW9CjLXYSUc6jrD?=
 =?us-ascii?Q?E61pt0YjMiatTeAO/ESUTHKyim+jpv4m6ha9Nk14l/kUqPEm1qAMxe/BwQ17?=
 =?us-ascii?Q?HqU3hJH8rXC5U4PsajTzNvAgUZJtJq1SynUJ1kMDvXieRNuuFe05e3FuZdHM?=
 =?us-ascii?Q?7df3SIU3v4ly2pHW+e1Y0wOwHIjsY/MbeDks1y7u0zPmYmBatHid0lYLKq1t?=
 =?us-ascii?Q?8PBbRiITwnop20JpfoCbc0SNowFPHUlWhdGzMcu3pZuauv2uaxHwHBFmiDrn?=
 =?us-ascii?Q?fygytMweR0wDucFfHiPlo0RsZlmAvvJIHiCCwTxvr3cYxAEbNGB8PiUEUf2w?=
 =?us-ascii?Q?KWry8DexVkoR9XnD+29gWbVUtJy1lgvtc6VTuTVbIE1R+6iYDIwqGiwMFiBj?=
 =?us-ascii?Q?dP/q6O1h1U8o3ZbspIv0K41povcCt2Ik7ClmPx+k8N5Q9Dih6pUzb+qlXlaH?=
 =?us-ascii?Q?5AcWJB847feX+Gg7VAbMgJQObRZ5Bqw18mFfBfJ1JAmVnjlY7YnOS+oXr0CC?=
 =?us-ascii?Q?JKtgMhAEEqF6nUSIex4e+Mqbj0Fss+eqPFiaEvAd6JS0rf7k3n2J6KrOn4Qj?=
 =?us-ascii?Q?l4rmu0rpogxchHTUHa6RxuRWdMDrQgjtwqY7SmX+UUYf3aaam6hjezWSNgcA?=
 =?us-ascii?Q?u2mJ+Bi7NFmCwwfMllZZiDBGikf0TXHcK+TipvHVHW6t3IGusWTf/yLyI026?=
 =?us-ascii?Q?7unIvXxsVt4wk4OvzX8q+7WMAY6lcqQrqMjTjZ4pYaIXd5SbcYav0xYi1WWY?=
 =?us-ascii?Q?B/UpSs3/4N/Gm2R6wy5nMs0vXEApjVEdLwh5T4DLE1lP2Xo7DRN00Bh15qQU?=
 =?us-ascii?Q?reUrGtDjyg68B+1oMPSEnD8UcuwTYxcw6HYBKPy1GQCvYJECKRqKvu3Hd0Qf?=
 =?us-ascii?Q?Ms1mWZyrWzggef5XXh5eEPFcnpEoh24Wd4TE1CIM4OxmEuycBi04RhMNuwz3?=
 =?us-ascii?Q?5/IuXZlveKH2BChksXpXDDGX15zockfAXd7/WhM/TNmH76kK6KhKh+eAKk3m?=
 =?us-ascii?Q?LgxgWL2jEEJqPL5QyADDIzJPn3njVZTcxGqdGw0hVmNUexCfRj5+D7NgOLtv?=
 =?us-ascii?Q?A+WySBwWDYQsHAE2gLtODtEE0PBKEbVpcYWWWAW97VXdEUdxn54cN+q6EY0N?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c223f1d4-58e6-4a8e-c7a2-08dc04594807
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:09.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6/Obhm7bl+ZbdgZ2WexIGDpYBX/oGlj9lbd26iKS2fjGecZsCuHjmNFQmHwI5xvOvHuZPflRILCMxR8Vu5JqbPosexAGBnhfwxaWrndQ7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-GUID: xJlya6tRiEuaqHac_14nIV_cE3McTKSe
X-Proofpoint-ORIG-GUID: xJlya6tRiEuaqHac_14nIV_cE3McTKSe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

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

