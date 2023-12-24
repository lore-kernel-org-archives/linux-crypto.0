Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154304429
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="a9Ifq+yy"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8LHEX028291;
	Sun, 24 Dec 2023 08:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=S4AvnDJsA5WSbsqWXra5BK77ut4coblAyvpUguwHv7Y=; b=
	a9Ifq+yySqF7DPAZj+w6I7rEmGx/6uk4HOJM9YAbRzP5EujTEySJI9tD7Rfo8eEp
	BuhOJh/e+Sb+MIOnIsZQ6ziEVGfYpwvhq4x2MtWsrczyuRePLpFKmtW9sNAICo4o
	lkcglbFXTJ1r9DjBA2jKoo/WAh+56OroMMj8B1dNAETmgalE0DTyNBBoQsFzMJkC
	I69VTzcBabaBlLUQTbOXkpdRwlMuGLhyDbXDspdTPedRz96FER2qF5jO2VPhs3GD
	NqNXDy2NTDZ/yuiRMjTZVE5KW7GOnJGtq3ygk4HDC3nhtAci0gDWvvSv563QBDMr
	4xbCM3NzsxT8LJhN+BnKzQ==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrtnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Toaf6mKt6cZPTIP8mJhAQ0bjHHHNdqIuEzPaNqKuJicBIDe+D7Q0j+EqcUOi4O2pcQ8LctNNgZ+e6yuKAcQ9WJ+wZOBlNcnOfsgPNdqFeSEdxkfwMq8BRnHFEqG/K7eCp9sfh1nms8tL996gT3oD5HjU8LwmOJ49wAN4EcFWmMJLY5el+4mQpgQUpdHYWyIo7dA6Hby0VT1CNNfChMi7/qk4Eu3YfgANZAu8TuOQFWj1lm2L2Ig9GG//3ffyTwaDWI4y177xRpcdKvBQTYQQlnmyGSDmd53yaX2JCuBGXltN74BR1o7zJek/N0VJ6PkRtsGYr1pTlAs+Jqnt7R7noQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4AvnDJsA5WSbsqWXra5BK77ut4coblAyvpUguwHv7Y=;
 b=KLqHHMcvnkDg1cq6SqQcMFJ8PdeX5KGIt9HlwcQDTlsP+VVLnQ3Cjpca1m4Edx53aJsc3xIsLZAvoWaS2VKfiSWwCIM53m3hpM8cEGdEJPkM8aP/2s0ZHHxAU690ecNydMD1jIjfUD2gkpTkhlVjatwtBfKZPVcT3ge+mgyC6HbNJ4WXCVysAtTlznLacdpNq5gQZm5ln90d4XudI775U+E81jRMG4TF30UYcNaDyqNRPd8WyUVAknGxqSML7TLhhb9EBYniR2iH62NtDJsBZ++iL5HIzLZFJfv+Ffgj4Mjl4B9OaTme6WgoFoJWeB+q006/XSy7SrNb+Kpn7hfDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:16 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:16 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 11/14] crypto: sahara - remove 'active' flag from sahara_aes_reqctx struct
Date: Sun, 24 Dec 2023 10:21:41 +0200
Message-Id: <20231224082144.3894863-12-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: a69d7844-85c6-4b60-5f49-08dc04594c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8w6R4sbr1md0Hz/MehIdS/igYFLCSIJTqCDDss7F3+I79Oa+k4+B+fI08hK7cCwSyxLaQR9MfpeeUQ48fVYXSWvqR6lihZ8pph8tmWPBhM839negG79aR4SMfwMeLOZ7Yv2OtNnxSQSDUSK+pgtyHFogV0cOVtD9u31jJfmQH1Y++6hQEGGWyc9TqSES43p8PmzjIU3cS0JfQiH0rMWX4GiovYRUsajEPZbvxa6jiXTTv3zfBurc6+ZtUd6Jykq7Ar5EXrGJBF+/vaVc1bVFe/4OrTgxO97mqnxSXJcmw1by5k9SJWIIwfWrF5tefokHEIkMPr5QI4ZNUlCpWbdd1tcqfG7sYVr2XqNABhEtFUkf2DQc4O15SIWiNC5V9qGQtvSJyt47oNTMFTnXzeAADzrt6zIG3B3Ven9yHzvaSTA+Hxu1e7IGLwPmn4DT1b/HGoR5cUgImlAoyxauRY9/mDR8dxVzwr13bOKIa0l3F2bZB939a1goN++2ZkMTt4knUGCiMyJSUrkk6M/IES2ynPFXsHaETYBIYs/I2isCPhDJBLRZjmIfHcBs+Fx0GWU/EWkjRkTOzYirx+Sm7Yxf5C3WIoGjkKTNs5pzmdlLpEnM0pUlGcf1Bm8JLLX33x4a
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?m0GzdnrZItpn4YH7QhOfsdXcsaroxWnv0WWN9dj5pdQ55EXSzc1LggIm7dzX?=
 =?us-ascii?Q?tSGZekMUMYoeH5pKax0RjDTp+BCgEEwltyVqDUw2N1KFSfLkR3CZUrb+JlGt?=
 =?us-ascii?Q?t+WGQnONpCPywJnyITxMFAHWWEh8NhmySUnX4UMkQjQU3mxbjbXqv5he6EkV?=
 =?us-ascii?Q?uuFang9iCMaqZNR4U27zcHu1QmkeuUGwNAdqTFgjq6n6Uv28mdWfLh+pFdVH?=
 =?us-ascii?Q?Zbdc/ImOK8djfV8bWMjkpg/O1LZBOezQayCXvh+1uAjSSYg5gIOLtmXi8zuH?=
 =?us-ascii?Q?hYOFXtHZMKHm+s5XyVmh/GWehlKReYL9v0x+IpxxBsklghnQX41oUuMvyFQR?=
 =?us-ascii?Q?mYRlflmyiSrXZTSpmmZFBKbS7nVopzeOv5JIAaekMXuFXcSvoQPgG9CT2fLw?=
 =?us-ascii?Q?5G/BLl1rLRv8aFEz6JaoYT3XZks6ZW8zXd11qlNwJLy7YSLZabLE88cLqaq1?=
 =?us-ascii?Q?M5rQWJf+vYX7ky2L2qt4yIxCqkJZpVsIziMHm2a6Z1cucdKA2ucv+Oe1gDdF?=
 =?us-ascii?Q?AOUWEwhLY34ZEoBhvK1UIFZaGlrrs4iGCG+Uv1G3b+8+J63+hz+B74f0SlMI?=
 =?us-ascii?Q?9pkOvXpiDfzQs/iuMmbzGCgofqk+EkeYfUT5aO+v4FxXqyAdH/vYuHQEz4+1?=
 =?us-ascii?Q?PaVdCOccNwYKtiGGwXryYU+JkWIrc0PIiDGwZ5dMLqvWwytGpP1HZDwDBHbo?=
 =?us-ascii?Q?E/+MR9BTyDpykPt8ZxJj1bHE1+0Qr+vtrTO+/FFwLFD65Nr4uMksJjT15/qw?=
 =?us-ascii?Q?Kk8buqk2AvTe0w9XoECnRZEp6UL+2gEXWztKD3zMte+DZc4bfs9mr4dCvr/4?=
 =?us-ascii?Q?nIPnwxf4NutqdEvUxxaeZonr1K4W6m29KKVyLpiqUtfPw9/Vr/MZs3nepTek?=
 =?us-ascii?Q?f8vMmGxBcCrzWlFGjLAedY0I2PEifVlu1fjQZjnr3fj08nAvewk4ZiGbJwB9?=
 =?us-ascii?Q?OWxt3/mq7VnLphv+mw+lAJ0goTvT8I3pdF7t8euolcGsGCBeNBYgITYDAShT?=
 =?us-ascii?Q?IhYdeej8WCb4nUlB0utt7xAp1mRXHtUxTfVuP5jxX/JDNeOlKXvBtHhg19Am?=
 =?us-ascii?Q?FF6QR8evNawX7zT2xJg7nnBW++pp9gbzZ0KG5waTqygoGFfbr56AQJbjvG/q?=
 =?us-ascii?Q?lqAnpEREpFnRsFLONh+E4tX9/pS7r2hD9sDu09lE0snEGK5ZiXMqu+OfTCVB?=
 =?us-ascii?Q?LaAtKOO9Zv3WNkSt9IaCtWBzIno1zLkYBWIrqeRQtJxdfZU0dHcsTz8qAH9U?=
 =?us-ascii?Q?1lmbnBif2hvyUv45+LlJbuNWEvb4DTlBDKgCBdPK3qcJuiAJ+pOUWunvMXbD?=
 =?us-ascii?Q?aAGOP8VQD1oOXJ7Eaq0/EzWzlY+LDUE7xa8tm9CIXzxSoJnVl2UGeolEoTM2?=
 =?us-ascii?Q?Zq8rMFhpgTdEnQyQr69yqLmCySKnRhNCRkA3JHvsl5aGovCbpnmy5GSIty+2?=
 =?us-ascii?Q?poztnwjccOg8baaCeeHPrTB+uYEc3FXslC3pVRi5KFH6qq+SatrhX+AxoTwR?=
 =?us-ascii?Q?aekdtP1092Wk/e+lWQVgx9/I65ZF/ocq06QUXbrVz2OKw7PP4caQ7U0c+uHr?=
 =?us-ascii?Q?wTgFYlp6Dtp0hBx3R0spRxMN10RUueqQ0mIQSNFaTKMUGzumT+ioB73n5qae?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a69d7844-85c6-4b60-5f49-08dc04594c49
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:15.9689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +moH5z7lDNDhlzOVDRTUWkGu+hDBND2q4jdJCqcusSB3tLKcHSq2meWjebuODILHvm3lXtKQHtYIyJTappVC0eLc9Hme+BqeagKniyOa5D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-ORIG-GUID: gm4fdWSCEGwhsDImMgLJtp72vZ5hvVos
X-Proofpoint-GUID: gm4fdWSCEGwhsDImMgLJtp72vZ5hvVos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

The 'active' flag is only used to indirectly set the 'first' flag.
Drop the 'active' flag and set 'first' directly in sahara_sha_init().

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 253a3dafdff1..cd14514a43bb 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -168,7 +168,6 @@ struct sahara_aes_reqctx {
  * @total: total number of bytes for transfer
  * @last: is this the last block
  * @first: is this the first block
- * @active: inside a transfer
  */
 struct sahara_sha_reqctx {
 	u8			buf[SAHARA_MAX_SHA_BLOCK_SIZE];
@@ -184,7 +183,6 @@ struct sahara_sha_reqctx {
 	size_t			total;
 	unsigned int		last;
 	unsigned int		first;
-	unsigned int		active;
 };
 
 struct sahara_dev {
@@ -1053,11 +1051,6 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 
 	rctx->last = last;
 
-	if (!rctx->active) {
-		rctx->active = 1;
-		rctx->first = 1;
-	}
-
 	spin_lock_bh(&dev->queue_spinlock);
 	ret = crypto_enqueue_request(&dev->queue, &req->base);
 	spin_unlock_bh(&dev->queue_spinlock);
@@ -1088,7 +1081,7 @@ static int sahara_sha_init(struct ahash_request *req)
 	}
 
 	rctx->context_size = rctx->digest_size + 4;
-	rctx->active = 0;
+	rctx->first = 1;
 
 	return 0;
 }
-- 
2.34.1

