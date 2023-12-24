Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E761866
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HRL+BsnK"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8L56l004794;
	Sun, 24 Dec 2023 00:21:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=63lRtlaUPtX52MermXR5DP/x3uPHwy04X/QAvCirJFA=; b=
	HRL+BsnKGd0sgktxRqSc9p6jALdpYTTfslkJ3+0CugIx2mN1gdrhLSYJIFlB4gYG
	GRpgCLiQdkEnyOn8yq5NsBcki0EzBY0rpBiEUKWcmnlDcoWcLFvsEnFegwCqqp1o
	vygVFPZUP+hh3cymYWpQiWFjwqOxH0dEXV9sDd1i2hocRsMAblulBgS92iaE4TzD
	Mgq4BUPZNl5yJ6lPW0uOAh1DLchSJ7dX3eTmOp8qzkFA2BaWjt168+0dzKItu2TF
	QJJriph+7yklxJE4HXy5vCyv1+fD0Uxz+WgltyY+TYjd65X3n+R8H5uk9sWJHiAm
	pY9oRc5TWBKnCVazGtbaeQ==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5yxm0f8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLQNsczK0+UhwjX88nLc4Bqq9/9e+o1o1pPu0Tglr1KbfRodwO9vtpa5sTluTLpqNUzE2a+apV+8fL4xRBw4joRdudovBqebj0wY5L3Zhkm8zmtD/jjHh8ra/YNpJPl6Sd86UOXxplmntpFB8p3WziVK5GkkwEszeqVJ3gvJLRGZJDJ3lq//yvpND4WQEnn4tIuxIEnujuwnl37L42+mYdM6rVbQAv97AKnGWZarkbhKz8eTFooi/qrabcvtttcLnE31r7thMbtEMD0TChri5qFMpJHTeR3zTP3HKM5LORUCuRk8dqaac1XkVNNEEuHF7B10e3ump70uu/I6A+NJ8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63lRtlaUPtX52MermXR5DP/x3uPHwy04X/QAvCirJFA=;
 b=euWwa6x7wkgXmDUFvSG7TnR6LudAXt/MLTfRv9BvrZHaQ8VzOWn9YjaJ/wvfcDl5JDaxITThQU1/xMgqcVXWL0/1mRqw3JNa63jwwhfQ3yPAlRTt75/rbMP16m6EV0dA375gwKTBPRf6CdbrQvMJujVZiyu7OBnu1HuxRH49nGlrv5sbTCnmoGZaOQAy5f1PRvtPAoF8sb/X4IXmc4XZ5m1+lhsZ/Eq3s21CApg3rwa7i+RtB3JwSlrUa6hRIBlBiwJfkWpJB1ZHRT+06ALEc9DqBM0N6GU1upE2INxPiKUJWEdciPtH5Yhl/eY+g5mpnBODJHQYcIN/gtKVrCgdAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:05 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 04/14] crypto: sahara - improve error handling in sahara_sha_process()
Date: Sun, 24 Dec 2023 10:21:34 +0200
Message-Id: <20231224082144.3894863-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 766fd93a-c782-447d-ef53-08dc0459462a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nzV5dALnyAZtGDI/mf/Ej1FGiV0HEGydPc+O4GTFVKDCS0TLBeSacrkIF8fTuwXI8405wDR7qBO8DCwQXhJsdkziuqO/OIUHJk8XBTssb5290JcXVLVXQHbKcKiwOzsFGmKyIjMofqPtIMc9jC/3lLATqzJdgBvv5At/aKXZMRqxMXeBi7ytNvh5xMbTig2pUacZ6AcUdAPdDDGbruni56oQKrUMwUUtIC0Tg+fj+gUaSPX6E/53Ai69XCEF43NqSU9Y3dkiPYFtLzwnO1z+Y8SKcq7D0XgjbaVdUHEiXs3wkcIl9e+GNR1ZMU9PBJLAOKQt5i8LswQ/CqQI02unQ6FHhyJIcMr16Rji7yUtibzDdP9bwdNPWTYhFBSGRwW5g5JWe/WeOL3hBQUZttELlC9EtcjnYTn7rATiNrgzPcecJzYauLACWV2jSlOwkCAh5ruWJnVqCgOpS/TxXldpBrvQ9c2wqVDsetDgooIuAmForC90nzh7Y/A3gd8RNMTXwkvhkftVJvMT+TwLsDuLdiy21TBqBVF3srmHjR2Euz/aZr+97FXpiOZ7tsLlc9kML2QVeLyh7nEppXB3P58/ZAzKEDObgkhBOEoKAyhprjBiNzO3z5Ktejd4OhnqRKxU
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39840400004)(346002)(376002)(396003)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(1076003)(26005)(2616005)(52116002)(6512007)(9686003)(6506007)(83380400001)(6916009)(86362001)(8936002)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(6486002)(478600001)(38100700002)(38350700005)(2906002)(41300700001)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FgGhfa6sCL6QCXskiU+Yw2BwQceDhHkchziLaIudr4+ggd1pbfjIDeenCz+j?=
 =?us-ascii?Q?dR1vn+aRm8bZdBkhUnYdA/PVZz2M+ENt4T+iUIm1Q5o+SEKy/MJW2SOeosBT?=
 =?us-ascii?Q?Yis3tiuyCOuTBFQCrWect+PCwqsyxUkvINOEgIXkWhbxAfJJOy3khmyCCd07?=
 =?us-ascii?Q?OZSBUNj/y4gjEqt5WHZcmnBuyKWPFjolEC8OumKk8pO0DP8J8KvaRNS2+zeW?=
 =?us-ascii?Q?D8QHZDsnB+rZjoYUBgkX9imWM/IdmNqgEd34EmP9840UjkdkqjXzrEReGmmE?=
 =?us-ascii?Q?/Z90U/O0c75Di/ur6/c6KJPG67NBj7nszLljGmpbJnCSJl4Q2qWUZ5FfEtFT?=
 =?us-ascii?Q?kMVhreXnZpWtfNCNHNFJpe8dSEIeilNlRaoKWLPr9AnsKWTsWnWYA2cv+FFF?=
 =?us-ascii?Q?nO5ldBM/1Evx+zwM8JXr+EsH3s/rGKtZVppUAbUpuWhUpKudymy94iWOjt67?=
 =?us-ascii?Q?VsWkR57jkNPaPNUrFbiBEGuduNAknUJjaSZdYbuionJuEr7wHEuTEip+x1ku?=
 =?us-ascii?Q?nNEb73+mWrQnP32bKv1PX0OYdGM1jK0WfungmRFFOktp8C+KbpjzuR3Lu7r3?=
 =?us-ascii?Q?iMtjN+n0zple8Nvq2qJCAocF4D6uaAYfbM1xFMRdRigRVo1t44uSTTusllNI?=
 =?us-ascii?Q?2axT2SC9z0gtDe2Xna/hpO0VeVWzQKM44SZOrZDObtnzCKvHKpj0ff6NNgtc?=
 =?us-ascii?Q?pdU//b9U4l6tWkli9urQLOvqtwdYtYB9eVQnNLzKoLQUJeT8zNRPFa5+ud/q?=
 =?us-ascii?Q?nXRIMwRti0rTliDN4u1ianuGu1+DdWj5q7qXggvtyvhbO7MD/pAPZCo5ib8I?=
 =?us-ascii?Q?OJ0bJjLP+2tM0Kmm5b3NyADbQ2vsLkTM3qH0InlumXxav9OXOpWObvEMeneX?=
 =?us-ascii?Q?77bzbu/GCcOn3CRkT3GfSpiRn8268ZnEwigY9nTDnHC9WbgdUWSyHZGt+184?=
 =?us-ascii?Q?HCTFQCXgGrDeaOHRMGoFzG82UAS3vvwbsQM5eVEqghGBJxgU1I0FhbTgtlI7?=
 =?us-ascii?Q?jiRcj6N7xkmuZygmvNKOerhk2LuPy8pEEvPm33lnimkxEVGndGiXIf/JIOuf?=
 =?us-ascii?Q?CKF8CIhM/OxtObpiqyiAabeOd0gi+q6Abp4BQl7x8RTqkenRdeMnImi8kIpi?=
 =?us-ascii?Q?zv+JP2zBu5IzxleVqr7lfpPKGrSGr1JZxbtKEkuLgeuxw0IHFelbm2tXlc+n?=
 =?us-ascii?Q?wbmcYFeGqZ8n9w4saC2GAhP3D46wddV7jynkx7IwsM3UuJM3OFMjEKSl7K38?=
 =?us-ascii?Q?8kxxZj2KkL3xt2kX+Q/TINLSqPGbNmHu6lTCEtirCpZkjiFfdXgff/wZFnEi?=
 =?us-ascii?Q?l1J5Vs6PDyuw8Yans+y7w3UQSUkj8os2pBhEQNaEG8CHhpDLbbvTMa9ueqB0?=
 =?us-ascii?Q?D6nvHnrHNKewCDdYAGyVlz7kKKK0S75c5n68E8LbDjQNgVcCTrLHIdJeyX0h?=
 =?us-ascii?Q?PtWDghQB+zv1E6zhc+jGmRaDsXg3j9W2dxJq3ZqPx8oFFmEp6TT5TjPxbLo9?=
 =?us-ascii?Q?My6clwlCI63bWpVeOf53mvm1HmPY+1iLcxEvYUUORaYdGceigXWHUI2rut1p?=
 =?us-ascii?Q?tIrLK74HkX6jstK5F/ijI7HxWbykK2oAAqW+MOSz1uK4H1ctVI6zNSU0BCML?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766fd93a-c782-447d-ef53-08dc0459462a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:05.8061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GYGMuzEG8pRmrx1vjg65as3SfuAIq/CGSWkDHqLQINUGAt9aTcF6mOJVuJVt9WcdZmSNAI1UBv7a1es95qR3+YD4KpBm8u0yXuW1zyTyqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-Proofpoint-GUID: SLQ79RyHF2ytDDclGJqJdc6js1hd7VXQ
X-Proofpoint-ORIG-GUID: SLQ79RyHF2ytDDclGJqJdc6js1hd7VXQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

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

