Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C296A125C7
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="nDty9swy"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNIA1Ju027137;
	Sat, 23 Dec 2023 18:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=iJgRXmmxOfYAkMqG+thW/aEG8gwvOTFkiKsTubRQdWI=; b=
	nDty9swy94zP5+oaMi0MwduIl+3Y5uQZZpdJ0JbPF3AZ9sleqfUZm3J8WJZD9l1X
	aA+UrdMB/uD4E11F1a8cMSXaWojccHz7zWO8kG2/G7vGpj2P9AC4wvkKnORWugsT
	Dun8GE9yD9HZPR0GT11L/b4+shjtDhivlXWsc6R0hAhHhVB+s4eIffIKisHHeUtr
	eNYU3b4PpNm8YbtuQThKX/9DDQXniOJkvLcqWkwrL2E9CXsoEzpLOfUazEyLJLZk
	F3D4fxpJwgkIb9PsOm0PbUGc4Vmz/16PLs6po8V9RJp2u+XukVAl12eONgyUuww7
	HBubXdZKv+faKi1Z3ebalA==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60dq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrnYaFutDKrcOCILEJSUG1ww2mXkDP/JigfrIrO89V6j5jm9KQb7rk5LkpoGITKgELC9oD+nR30ru/AmorW7cFv1dhDkXrADV3Y6KIFG6/dyxrydtbV59P9AGw2ARv7tOIPT5DisiypRtDcKYCDlAsS/z9FFSYUcxn0uSFS07LhcZmTTG1Aav6DdhsuFEhLdqH/W2D2tq5ZKQWoH8TuMIlzCooLlgzCl2ntjMKDHP3WnYPij2Gjw6kfUM9ETcoy83qLwkMQpfuedyJznOCejDzYJQkbr0KkNisq27PP17lTjcIjL8BFkCP4D/VWDRMBKMXlPeCyQicysiRTLmXsABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJgRXmmxOfYAkMqG+thW/aEG8gwvOTFkiKsTubRQdWI=;
 b=mvblLQpIXy8rMaUOhwa8qfvnSYBYydoJoU2EqHRsDiCAB0HkbxNBwceuYfKbl7EyPLdiqlOdLuLKuowgZIOZC0ee4SjHloVzRFkof963Vn15dPVWJ+vuQqQn5dtUqNAvlrdcUVN45nVFO1/DFAJRaUyNbPq27JS5IcQQzIkVuSvpzK/OJ9LU1oQO+Ei85lHOdLlPzWv3RD9SpR0zZNOPX+ACT3keH2lKWEU6PhRr6T8cKm2kO292DY70NznjlGZpSe9tl0BC8cckV+JMIFkCY0alsuki6wjdCTBoNJ7VQQlwoWmLGFszrsUI91FuggNEsL+hT3i+Gi/tNmUEyNN94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:39 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:38 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 03/14] crypto: sahara - fix wait_for_completion_timeout() error handling
Date: Sat, 23 Dec 2023 20:10:57 +0200
Message-Id: <20231223181108.3819741-3-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 24e653b2-df4d-433c-1e9c-08dc03e27779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GN5+mpr/3uxIH77K/I+y4xM2Dtf+g7vOASOfiYRBjnrBL1eZuoztGLlpSAmRsnOSwJboWClum8zihReLPsfkWFrjqaeELAuBiu8G42tNUjMWkoTExRTCO9TihyRzCDMJL6WaOZirytlxDJEW5kd58kDQ5DiNA8JDFL6tDyc3xA1+SpXkWDGmHFzw1FbwXwcP1dOkBdPIY8U0g/R3OVzgytSikDNgRMkWPEpkFq5tocUKlR4YP4HPV/RR3aJBbvurC6Kqb3BJEa+Ak24aouVT7eTu7xTLadr1DFDoBejaRcLtcBnAAfH2ubDgAPS1lxco93jV7n4eQx3hm9pNN0nb/Oo+VGc31b0FPUfzyFatT4+Wz1wq9kZhtIyo77Cjzsu1z/tXMwtE5FKv5lWIwXh1H2SXOyGbJiUaOsWhNjdUczBVzH++VKQr1xb/13knLEB3Q14vxSOEtjPubAc6QhtGKKr94JkP55wc8S/ZPMXWHT9+sGS9KOZ9oiEIYWmGIg0Mu9RdzgPodkLbYAG7drZ6qBAFHbpuwBFlvm3gGngwxwkLgw7XaLnM34TCzyMwWVknf80myPCvqurTzOBdU/XrD2Gsue/tihkJB1OG2Ypi/+dKHBeXclTwXNwZp9JSqDrV
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VkvDe6de+bQVDcvkBatYZ9D3c47qyor4g5j5zVbZc8hUsiGFvybO4P7m1c8N?=
 =?us-ascii?Q?AkPRgG1qaGxzGqgms7MazyJIHFtldlQ1ScTODZCZSgk1oTx9+XxfhJvBLfEu?=
 =?us-ascii?Q?kAjk+O2hMdEZFh4afWo6Wxz98Yrgukprgkpjn0CqFFJzx6RTey+BKj25mDEq?=
 =?us-ascii?Q?847LH1QfgMD+AiQpRnIan1so0fS3zex6AckXc6/tyggmrUxEVelZUsONP1XQ?=
 =?us-ascii?Q?DaTyaEiSJX1yRdbE6yoaixEdjVtti04L1HPxhqNJ9ezahUsPOBGuphRJEOao?=
 =?us-ascii?Q?dcGcrP9MgN7GxH/4SUgLOWbOEbO+AVC+qO0fVJsYWpoaooFWyelH/Z43gGwM?=
 =?us-ascii?Q?KD2MLRxW/WDdQ8mp4knH18pHa8F/PcuzRfgfs6bKx0oLRulAW34e1i8RKzWG?=
 =?us-ascii?Q?vo/o52x4FPhMBEOeHQY/trdoFLiG+vOTzN3mZE3MaJzaNleA/uc/xAkkSWSq?=
 =?us-ascii?Q?Zg7f6yNeRHVEARjqM2+GkNYcTzf9I3OWxv6+FYGXfviVOgX8JNNVxhZ8lcix?=
 =?us-ascii?Q?VGttHpembMIujjgklBsdA8T1OofQAWW/jHR5s5moyELonBlj0LIydT0nFlZm?=
 =?us-ascii?Q?duaF7fIXNj0ej4ECTgTCNBbNUIR102TbJDALKu5JxcjnfDzn3heo372jrEov?=
 =?us-ascii?Q?yz3dWxwvO7BtEmQTJpIlh8j7G+R+tB7YirT5TVF/EqUwFi33HSD3T3SjcKaq?=
 =?us-ascii?Q?fO5OjOoKRSiZkTGFswLwEFgkcrAlVXISJwYNZPjFnkoUONAk3ujNv8wtkb/R?=
 =?us-ascii?Q?/O/sb+778j/evNFbSI1FfwZr9GaZmilhISG8CWUfkxNYbf3kdWiddGO5Arhr?=
 =?us-ascii?Q?LZRi+wNbKZZenVo+mKhRq0KB/BP3xaJUIjsPlX4icP9wyQ2UajpnJbd9rtHT?=
 =?us-ascii?Q?O5pCr72xSQBwkd9aIXbQgoLNQC56DkRKqe81kG42y5O5GsCt1jSzTpHR7kRb?=
 =?us-ascii?Q?J7iR2u7RyWb8bLBDEgGxoX3WPZKR44butb1bV3ZFeAdtr1S98atux4Dn9mEh?=
 =?us-ascii?Q?Sp7/LFdco/QGw2UNYUK2VLqiDHKGNHTC8ZUXeBlHGRjjBkBrH3EbCFK86X8z?=
 =?us-ascii?Q?TBvGSx039E2L4X5o0wnL0XKMHPYJLc9qY7Q5Pgipwx9tFiM4YZ8J+J/LOylC?=
 =?us-ascii?Q?S4aAnVRb5EkVhuZqLhtLXnTkJzOnGGBIaDqB1tafmL/6VYH17PexIPzdHR+Y?=
 =?us-ascii?Q?1AdkAfL1cih4ruknv3qDGCW80dy+qBHi01T+wg7x20LHHUsz+8+cq7jESU0V?=
 =?us-ascii?Q?fMjOrvaM76MYtv6x0CsfqHJSr9P35qsMNXOjxHBLipLRRmqnqDGSePmYt4IB?=
 =?us-ascii?Q?fhwTvA/DaBU9SzTv5tb+38vCiAkyeXzCYWbwF8xbOs/sy0GheOg+Z60EWWE8?=
 =?us-ascii?Q?PyYTEKjRjB4xB/y5yN8762BM6DStRxd6TnssBcVFudviBpG7Z3pjupgzI+Hr?=
 =?us-ascii?Q?htanl7XippYBE8xBtTWXtqBcUMsQLYYG5+TVMcSr8SbUCl9KI1kr0YM/QDwh?=
 =?us-ascii?Q?+VY7zEQJOI+GuOWEI6cZIEeTmAsN1bGv088d/7XH0j1tFJSsjaJYY05RRZ7+?=
 =?us-ascii?Q?qgW6EcncbLqYK4pajgvmu/gVi7p1bo1JvDasZNA97DvcMuHx1JiT1V0u9pE/?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e653b2-df4d-433c-1e9c-08dc03e27779
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:38.3859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkZadR2LLJepda/xiLrdCkOay0V3e7wy04cjYh12USXxS+H3PTrSnekek+Wtjo8W1ULIXml9hxrtW5X6npMiUYNNqvh6Visu/3WqC342kKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: s6nqBE0jKamy-gpNdCiPnU05qu84V5Gm
X-Proofpoint-GUID: s6nqBE0jKamy-gpNdCiPnU05qu84V5Gm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

The sg lists are not unmapped in case of timeout errors. Fix this.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 82c3f41ea476..a9abf6439c4b 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -605,16 +605,17 @@ static int sahara_aes_process(struct skcipher_request *req)
 
 	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-	if (!timeout) {
-		dev_err(dev->device, "AES timeout\n");
-		return -ETIMEDOUT;
-	}
 
 	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 		DMA_FROM_DEVICE);
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
 
+	if (!timeout) {
+		dev_err(dev->device, "AES timeout\n");
+		return -ETIMEDOUT;
+	}
+
 	if ((dev->flags & FLAGS_CBC) && req->iv)
 		sahara_aes_cbc_update_iv(req);
 
@@ -1005,15 +1006,16 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	timeout = wait_for_completion_timeout(&dev->dma_completion,
 				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
-	if (!timeout) {
-		dev_err(dev->device, "SHA timeout\n");
-		return -ETIMEDOUT;
-	}
 
 	if (rctx->sg_in_idx)
 		dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 			     DMA_TO_DEVICE);
 
+	if (!timeout) {
+		dev_err(dev->device, "SHA timeout\n");
+		return -ETIMEDOUT;
+	}
+
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
 	if (req->result && rctx->last)
-- 
2.34.1

