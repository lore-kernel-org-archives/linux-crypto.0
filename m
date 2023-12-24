Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A71717E3
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="I+VjHk0N"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8BCGb023794;
	Sun, 24 Dec 2023 00:21:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=iJgRXmmxOfYAkMqG+thW/aEG8gwvOTFkiKsTubRQdWI=; b=
	I+VjHk0Nv6J/JV5GyJtJA+XSAKG4zulugwvE7LktifIcfB9HQJ6Qb6OdZGg7KF5j
	6t1H3IWsfPwrgyQvuiNgLT7vx6E84ecXiWqC7q7AeSZXGJaOtxaf7b7RQtBMjFI/
	bhPeViQEQKjGIG7wOgmhXeFQ9RIDK8UIxQGinBbpHDampIy43lC2a3anRiHxYeyV
	oHJwYMSzGLdoTTJ2BFVZxrMciNLhY771R4WCoJA85F1lVYtacvS6MagmwpGhJ4cm
	kpmr8sjGZSazIMRenwbwKRBfr2LoC2Bvp4pfmfnCba5Qtat9jmPV0COzp9GHjbk3
	MwI9pl65ci9HXQ018ERMLg==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0f8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AB190pwi1c7GOcJrs78MeFU+TItbvhSDD2Cxw8HSU5g7Mvt8Vvxqm3u9tOCR9HDGXEddLNN5TuTBrNbShnPPqUx9zZm8ZQ7ze6dfB1Z1ah7uD0UrPIJV/BBPayyP7R2M9fq56qRISJWSd4rZY2FR0goGmO1s1GUp/tQpEIgzKAriYoDY1dYVU+29vkifEIxLr+Kkvz1p7uzRszSKNcJc98xatDPIRt+mAVtKT+DCzL4/TxxCqux2Okufhe6fLcZ/4eu2LAGnEw9WK2nFAwcb0NDsDFSg8eXCS7u5tmzptmhXaRejaVz+8OaFE9fx0CIZqQunxJ4DdDNiIux0QyGuvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJgRXmmxOfYAkMqG+thW/aEG8gwvOTFkiKsTubRQdWI=;
 b=bCLSUKOkbRGg34dM5FDz3KvZNEsePrMnao9APshyd72TpO4U0ewVEUyRyvNxUzbgTYHHQgdidnWaDpydC4dFbClhPf+girRqB9p1HguNtJB+PFgAeHNQFZErOW3IdYLLQ0tPt5dTpR7N7nHywi/bf0htv1McUMRU7VINXtS+Ilbf3kqvDCqTbo4rpcTwlm5qBpQBdLiXaKAUl9TowQodSz7lz2SHhJ99HIAJZPmAqrhhwg1biOhLvMjBdotOTe+33Gqm6zZPP28+Wlh3Hr5Bes5IMheknWMo37C9ZxodrQz7xNuSzIXX7chWmM2pUlqAvBfuCg9Ahi1osqrzLNBSsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:04 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:04 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 03/14] crypto: sahara - fix wait_for_completion_timeout() error handling
Date: Sun, 24 Dec 2023 10:21:33 +0200
Message-Id: <20231224082144.3894863-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8d72bc50-4c21-4765-3394-08dc0459454d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	voH20TcP3718cb2UhfglDGpVh7AC054Eq4khwbmridtzuTO9IQ32HHXACuC/MNqqwMvegnMxOAsq395C0cZJCHXdnzhB70j9KKGqF2ZasVnbwWdz+jFQXlG2WXJSxbhc7eXh+yfDltHaNQddfA2UPScLj+u+CbSuZRTOASSyMloEg1yzSeVJMO1v8uzGh6XrMcutHFKhVQYpIw2ZmBoSEna/wgndxLWS48C755gE2jVK2I9l6HCOxP2JyphmgYkMiQCfGsdDT0kiw451JxKkVns6CDT5YfBI9Epr5WasBRfWb9kBxYreDV+DnNWRPruM6h5mGUixdefCqkUIRCy5GmLsItmXtPTa4ppRshyMkzvYFFCueXogL6iHLd2Sk6IYOW97N73oewrSrOxkChPhzFYsqDBvzpVJ8aRC75vcgDwr98bdWZSCbyDeURdfdFijeo8HmXfMuOSRuevnuUhqmEn8qNm/13VWF365JNssc9f7H9X4dIdRHF39L19RE8ZdyobwpGVHgwqAVZ0yX5KA2yiiiiug+njFCCm5Om16yK5PJiFy9qB5UNMzni+MPxxUVX6YcYwxyd340wU04+04k2zhKc3JCPVscRoi+hJ/VaXjUskVgkfIt9gRt5pByR0P
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39840400004)(346002)(376002)(396003)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(1076003)(26005)(2616005)(52116002)(6512007)(9686003)(6506007)(83380400001)(6916009)(86362001)(8936002)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(6486002)(478600001)(38100700002)(38350700005)(2906002)(41300700001)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FaPogGgOGdVCAWBUad2/pKE8RJ2ZM/1gOSaVOwHC1OR80k7SRsEQavrPPQBu?=
 =?us-ascii?Q?eH3dFmAM7TRy7NFf8jee1pdFTzhmoA1sCQ5d3jwblAPQSKw1iNsYj5R5C3GO?=
 =?us-ascii?Q?lUCvyPWUqKWtbfnqezN7NhC2bB8Fu5ub6VWr5nPFIkQCkKXDue3LTYTscvGn?=
 =?us-ascii?Q?kq1Q3vyq3deSwRkJVzubrh0LFcBcbLDbSCMPZaw1DoNIITzMFAdxq9TQaamD?=
 =?us-ascii?Q?krrtTLJIR7NlDGvATzuuzJis2TPplbpf+n6NbKXLYNkrvoJEakyaqco6B1uv?=
 =?us-ascii?Q?ca4zX9atCwp1nzd+rCHHJt+rhrEKUzQNPVR6JKIsrvBeFWDdBdPrTYUfjm5A?=
 =?us-ascii?Q?Y2adsuInZtfrcblbtH7hUDiKvF9yh10xZ1TocFInDdF3kai3/d8Wl9RdYzam?=
 =?us-ascii?Q?106fjGghQx1OBy6zXL+PBTbpiW+FucLN5wstq3P7xmYmFlfH5mICi/7wbswl?=
 =?us-ascii?Q?Nh877r8Sjhth8TFU1YUhdrPMnnY5Tm2J9VKC7XZynAVdRu+OUuzLB+AjJR81?=
 =?us-ascii?Q?DXJvdRfvqsCi49a/4UbIDFAbm+Ju+fugTxWRNq3Yms4R4Vv5MrwgNPdP+7sV?=
 =?us-ascii?Q?678O783ThO/pt7qV6AQmq7lXM1uB+FpfAErxHfAOEuM0KCUPTszUiMTgLx6J?=
 =?us-ascii?Q?mHMifkDJFfBEpSQeNUNsNwbKRCNTkYIrhbdg1SI5VMqYngOnd6urvWtDyZuA?=
 =?us-ascii?Q?ZGP5ZuCUOpLbpVtvZSYiSEKuv/wc6terW7vxXpvj4EXvmNUk+8ahTEWjd6c+?=
 =?us-ascii?Q?jsdEFDLm/8GH1NahsSPVscq5Xer4uV7uJ9C3tyDK3TudzCiRh/WxazdkCV35?=
 =?us-ascii?Q?13zKW7yVYj+xwK0VsY1mPscgY48LtUh5FTXeDKCXhkQMeve6BAgH4x2INDfI?=
 =?us-ascii?Q?9nAAJ3xD2Ho9tHk/DaYRfqG4H+Y7QemYvWq7TEOsL6FT/1yQNGPLunxpKc/H?=
 =?us-ascii?Q?s51yEuT4fL8GHmF9ZQFnuK4T8dGh+/Qia4D/7HFYJf1k8rOcoR7lpcRUxeAQ?=
 =?us-ascii?Q?CI3t4LjUBnMYK1gEY7mmjtOcVRYTtzXClLxIrc0rg09oaJgQjKYgQZXwrqNx?=
 =?us-ascii?Q?+BppfAHH8uPM1eZs8kr8Y8uuMOMzKKIXbImAx5WS8Qra0gKeHD6V/6S9ZUhU?=
 =?us-ascii?Q?B8OQA+2EAYOBPJUgGZdBeDjH39XxWcU61z6eTOLAPnE0eCljTSlp/awB/LA5?=
 =?us-ascii?Q?UvSFyvbRpidqSQDR4mJP0Q51zYp+5vAY8RTSihtSVMmRjQVEOz4S9FN0g9Zw?=
 =?us-ascii?Q?AGcx9A+5DQJyI12J2wCwG0rue2eIUyeOb+C0WCkG0hIk43n5NLwoVc4zc/oP?=
 =?us-ascii?Q?YPWhxzwOov9GD6A5dH0GqlFkt8D5NhlJ7YhZ5cZQGZVjRiRGf5WgBZ6NTX7J?=
 =?us-ascii?Q?bZnUBtcEuSdj5I88+IRNvPPgU2bSmdy6NB0aRe1XbN3r/1w7Q5pq0PCjlCtu?=
 =?us-ascii?Q?6pPhl0UVoOF4bX5HB6gbvfE15BTwLnkM/cr0b+xZTSsKxsNKZ67X3P3CEXM1?=
 =?us-ascii?Q?HN+7tKN4lYf86yBuD3+kyRTEErE4QRD+oeduZC7EKEd6g8nZOJW7rGH9n8Lt?=
 =?us-ascii?Q?JPzxOsOwjNWsLM+FzJ9p5CEbFbXI03YJ4kGYUmPpMOVFbMqSswXmEX9AsCtH?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d72bc50-4c21-4765-3394-08dc0459454d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:04.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUoeF11tZBzurVAnHhfj+2bHG+FO6terqh+swwLXTpv0oL2c+QMyiQJK3S3UYv7BtgUbjsU+NgF39Yf5DKMvhHEf8VN9B8y+gFzahSnZ2P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-Proofpoint-GUID: HB9_DN1xZeNnYTzPNvssNzmxo33qVCRH
X-Proofpoint-ORIG-GUID: HB9_DN1xZeNnYTzPNvssNzmxo33qVCRH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

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

