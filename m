Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="iYQa6ko2"
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CDBC1
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:38 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B1BxksI031433;
	Fri, 1 Dec 2023 09:05:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=D7UmrCIvcNMj8HXJGA5Fd6jNtukmSic7DgMTQFOrIiA=; b=
	iYQa6ko2HS0dLLKHxSLnkscTiWB5EunRU1R+xK5YfYjXwXntGzIZ5vT2LLJkN1PC
	6GX69ddmdFxRJvpG+yODv2sKLqdZmIYVbp0bmQ+qjRxQ8iqTarWKaGcQe+Q9KFk/
	hotO6RqQNawB8hfm0yVrwxKb9XOUSwYNdVd4e+LM9Jz0SC51/smdr8x3z0geo89S
	crxj7vRdXhKNk39cUbF82nt1CHyvsqecEKE9QweGX8aHJeYoi67R9lRjDTtYJTi2
	zhjK6QzjDao/2KDnx995e84EoBbWjjNQdCPHlrLYUF1047ftaWrDRerTPjIViqE4
	dYPpw/1YD9OoWdtXzXag8w==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph6dhynw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:05:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/yoCvtHIR/7hMluiLYjDpmgzllX2sx1+P/zmgEyUk97xDwfyI3pLDWH01ApwKqr5UATAPEzfJ0Zo2upMdPig85atuU3tEScPT38qQD9lKKFASmKNPt8UZh6XWDJkSH6O55kL7S+VklZlgQk8uofhejdhffOCNuh+ZCmUSfb296aAkA1lXc1aNs5nvYV1MP8cPgV3WpJdW1EWo9bvm6PptzkIs1HjwYLMV9cg/Cgoz1SlWsvU5JwF4qsCmPWtLIQmgABApaf6egEzhyHlUMBKOIdxEwv7EOrx+xfey3Xyi+Rr9dHqS/xAuS5Uor5bE7aues10aCet+N9B/XtyNNf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7UmrCIvcNMj8HXJGA5Fd6jNtukmSic7DgMTQFOrIiA=;
 b=RyPrUCvb2khsSmbV2wafZF3BzhI2gAlnXcoeKyl3JH19PMbsuzw3OIjP9A54Q2UYlErTyVyrpvJiWxnbUWjvwG05OBYAajGgnjc2uI4zNOpTKD47lw6PyyoUHzqZThHWF2TpB10rQHZtDaQnIr5m/+wX5ypqfyvk40tTRQdG0tGF6Ycct69M5hEks3yj7b2eD4cmT/rf+0KLolarDD9XWZzDaitde36H+3XoPvi4qSAVEKFgX/d44aHOY5Bz5P87ojhrX64+8VQ0WsaIjOof2HtxT83KYHiMR71LWjrI4bd+TLJOT95zApuXmsJb8ZBKI7QnqiELSriSXNZfVEyWJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:33 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:33 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 6/7] crypto: sahara - remove unused error field in sahara_dev
Date: Fri,  1 Dec 2023 19:06:24 +0200
Message-Id: <20231201170625.713368-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231201170625.713368-1-ovidiu.panait@windriver.com>
References: <20231201170625.713368-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0244.eurprd07.prod.outlook.com
 (2603:10a6:802:58::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CY5PR11MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 53948754-0a00-4a42-efed-08dbf28fba6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AZijcnum8uS+Qfi+WmzWdhwGLAVp08guHTrcLGNDYPkrQTRArS/YkW7c/WDdYLkLtB+HKA8l6Vb66EtE4alTMOhU/jFrdEALaVl8lW+WOze3xfrHSBX+4k04dyzrSrIv2F/FMEhffhsLQ4H0Q8lCRUmBgQxwp97Hg0+joACfoAZ99L86QKmm3+IaMBQ3Lpwsg2DUsqCUn//eEPFom3aNpB75brsL3c0AdTJEQSpnDdUNtoL/G50pqDr3Jd6eIAs+8qmCdgAAwLdUQc6J7bI6iLTArA5RDMfB4TCUbag399EkEXHo9KAncNYCbSHgxxjiT+6gN2EhpETlWFRDgHmG1nslnyn9X5+vLtPyqsag9OqtIwyuRHncYhaV9QU+cI22FJvBJJydpOc86iuuiq3ByYgfGrtFmaupUDwQ0a6Y++15ClTCQu3V0ju9Q+xAVtDy05EdCfDRUObbnE8jt04vTr8q2THXm9pwj3lTs5q336NWGj1gjC+Bm8h7mHYOk/ou6x1HG28AwjVQJYENqtoBrsbP98eheGr63BSOetQmANNwOGfrGAyfiHHKYkTluYizV/zBHU04NPFji9X0aMTCZhO9+8klPwqGTrsY5uUP/nqHWGD+iy+MezCh3VWaGlMK
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?agIJBritzzsH+Zb/Dy4cfNROTS9eKhe6ijn71yT7TIuWwSTxo2lI4HqcqxQN?=
 =?us-ascii?Q?O8asQJTzz3DmkCqfS0X1XzVZJsDSGeUvebQZJWrxRZqOUV/on9ToJu8q0auN?=
 =?us-ascii?Q?sCytFNZyFXBXUK6Th0hraGTKqOtx+blYiHSGZkFEimiUsb4bXG2ShDcfKqou?=
 =?us-ascii?Q?QtQ4J3T5OJqTa/HpivKxptiYZIRuhbvzYBVSBBidTt08nWPQbEtiCH6rxOAT?=
 =?us-ascii?Q?wYAsKSqrSowK3qf8IuQf09u6N07xR2jcomQsA0060wJIZvcADAz7SE3pP0Zy?=
 =?us-ascii?Q?VJz9tU6ZXUAR837HqGlRy9F7gw1YkGgbocKhEmqB+IAFojCYv37QewyParJg?=
 =?us-ascii?Q?HdmflQdoZvY7S21BxzQzP/Dyg+dO1BaSng5Ea7s8Cjk9+qBlbYyFPPKHfg/A?=
 =?us-ascii?Q?YpQWDz1+DmqA7x9EwYu80MqtsEqNyPNBe6UtAdoSQC3nDpsH0VrXTRiwm9Zc?=
 =?us-ascii?Q?qxPz6/CRJYEyjgsQgTd6TnhkCJ+ZzC9p5cUMGx/eMLwq32IjqD7zGbaMyDvi?=
 =?us-ascii?Q?r8l9Wr8fkJpwuep06uTxVy7/M5tbEPTl4Crrx6VPlsZjvr6K1pyJR/EdJDhU?=
 =?us-ascii?Q?Mzjle4LFOWkEHMqEYymVbqJByU9DNiipC8XJFUPQ8uX7avQgkAMQ6KkHKrPj?=
 =?us-ascii?Q?Z3lWpcmAjKSPROtwpRHLLHTlHv/SO3dAXcBM3oFtPEOy1NI6YDu8VhBhsWvM?=
 =?us-ascii?Q?I3kqLOQewZiQHl1T0sSODhaNrC2ZMJdoJiI9tOuYOpGydUMsEnpXcmgiLF/C?=
 =?us-ascii?Q?fcbpAmdy4Wk7IPxQtf1T2AOA9y8/5FVNtCyIJUAVCryAR5niH2kM6U7pWNWr?=
 =?us-ascii?Q?UH2ANkxXZP8blk5EYOWxkSSLkB0wyayzTYxstpDTDODQGzXw+H4ElIs25Jlp?=
 =?us-ascii?Q?ZsN8qD2RSTsz2YA5pciuu+9niFEAyCyiIaKtC8y6JPnXWoJY137cGalEQRuT?=
 =?us-ascii?Q?CxfLLxQxkpjwjPVz6yyB3F8qI5Ff9nhX51SOFQ2mOkcizpW0vhJI0Cz7QuQW?=
 =?us-ascii?Q?fKAZ+vUfjy6DURveSiebdhnJSOopkJRWbpyCicguqSME7EXB1d/r7at2vTX7?=
 =?us-ascii?Q?yd4DzRGKdxXvbR0GMwsB7I7KyGroiCsOpqxg6SJzWud2euodJS6TiFjCCo7D?=
 =?us-ascii?Q?LThQj4XtIxJKPscsZGdm5bI33j6Fs6BqGPMUvgtdV87IheytcQO5E+EmUro9?=
 =?us-ascii?Q?KKN+exGdgaiqF0wMoDYZCLSqTv53dVi3lTeq/np2OHNRGtHYUA0l2dn9/IC4?=
 =?us-ascii?Q?JXXuonXY2Z9rn7P1+QjCtMxvo6DZ5tTH9F1PZ7L55UhEjqUntLDDIVZSR3mM?=
 =?us-ascii?Q?fkh9F3spjH8isBJShO/+YNHk0Qn0sIBUKUNkXdYZQ6dWrFODGDkuIpcvhPHJ?=
 =?us-ascii?Q?gbS1600mxgMQTkbje1ry1lrdMPZti0u5llqmwM/Cpv1ca27BpeOZt3NdVmZ2?=
 =?us-ascii?Q?qxhqv71sHugCcHp8WYvOT6fxT99HDfGP5bX3oY0lWebuwKpBOUQoIWYSnqcb?=
 =?us-ascii?Q?qQSW+0frI2xprqikiNuqXVvr7CzMJGGUA02SYLUNwplZJIcDhYv+U48KiSQm?=
 =?us-ascii?Q?NZAFcd/4u8Rq/2+eHlyCF4LjtgZ3X8Rw0EgkjucP8IN5MpPiQ5r/WPxGkwxa?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53948754-0a00-4a42-efed-08dbf28fba6b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:32.9433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWFrmc99NY2S9GoVWNII7hSfn+inhEquDwai/xtXVISebL2OSrJnnFAJ4Hc0il5j3xQsANpfVd63h/dwLwaoBvnNycafFhR6lNgmxrPT01A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-GUID: ZgohnbFnbRFVN17gNxT7FnLc3PcA_u2z
X-Proofpoint-ORIG-GUID: ZgohnbFnbRFVN17gNxT7FnLc3PcA_u2z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=964 adultscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

The "error" field in sahara_dev struct hasn't been needed/used since commit
c0c3c89ae347 ("crypto: sahara - replace tasklets with kthread"), so remove
the remaining references.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c4eb66d2e08d..2f09c098742d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -221,8 +221,6 @@ struct sahara_dev {
 	int		nb_in_sg;
 	struct scatterlist	*out_sg;
 	int		nb_out_sg;
-
-	u32			error;
 };
 
 static struct sahara_dev *dev_ptr;
@@ -1302,14 +1300,11 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 
 	sahara_decode_status(dev, stat);
 
-	if (SAHARA_STATUS_GET_STATE(stat) == SAHARA_STATE_BUSY) {
+	if (SAHARA_STATUS_GET_STATE(stat) == SAHARA_STATE_BUSY)
 		return IRQ_NONE;
-	} else if (SAHARA_STATUS_GET_STATE(stat) == SAHARA_STATE_COMPLETE) {
-		dev->error = 0;
-	} else {
+
+	if (SAHARA_STATUS_GET_STATE(stat) != SAHARA_STATE_COMPLETE)
 		sahara_decode_error(dev, err);
-		dev->error = -EINVAL;
-	}
 
 	complete(&dev->dma_completion);
 
-- 
2.34.1

