Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9139546A0
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="McuvDJK2"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8L2fQ015315;
	Sun, 24 Dec 2023 08:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=DymI1x1+TfDEJEeaOFWgsyfb5euAu8Jv7FdVJPj7ys0=; b=
	McuvDJK2nX+IP0u3Mtjsvq3j3VzVAYUGI61a+fKn9bm/XF1znXD/BFfYtvRvgY1w
	SnrVXJPpKZcl53BjZpUgPDCB3S1zdot1hKjk3z9D/sne9sqZ/9apQZ/CWZSAaiKr
	L0b5vNEkn1hdFzZiV11iwqsxbSoSFgjs1KnE4PkJQmKXVICtBVSFCM61vxtf1q2Z
	9lL0/+SZ0xJ0RRJy9aFVGTB8T1IEcNn8pctENVSv75kmq9wP9HJKRQkXnP2enIFR
	YFpyp9fwqz43+IUkA7QSoFMeuPQv6dBC8XxGUE2VehpHV/hvPKyilWhOFjLwIWJL
	q4co2UodiukSxuPXYbn4JA==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60rsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 08:21:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q31o2hoPeXWW69JqB+lWRNC5/3FfQ3ifXaItIWa9+RMe82IHnZ33e2PWNJkNHeY99INCgXMhAGn9DFsGxWi8PQh8KJ7Gmdtx1fKGS6m59rv2mcHIJ6/Qd6qvSxH04LCm8q6OIOzQ/4TNRbPjVcCjG/rUNBB8iLeM4wkrA0cWpmc0EKcGQn2iPrMk8GF25+m4NYEgLQ5hEJPYPfCsO4Vnk6NQfqoJcEEyd7lqnVorsnV2VDH/9XyOc3m63sO0LVJh8t+MMmL8CBAMDMRl8uRrMdOzqcMQBWovjWA1vchRqad7dSWLx8HTJp/bSF1lB25EjEj0iUuJd0y8eLPQXtRAqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DymI1x1+TfDEJEeaOFWgsyfb5euAu8Jv7FdVJPj7ys0=;
 b=lMQZpg5u4k6alBC/GXdCySyKnxICND31h+R6cAYvD9R+Rc+cRbE8oJIHENIGdhQIoBwxB8hdpP7KvMKNEamKML7tHVew4TE1pQOvoYewftrXPF2WGX4aEO6rRo3U3OzZkVzDu4FCoZq8xPDQW8/aLnYd5QWER/SRygg2YcS/wcRrlJ1kZjmoTG6Y0Qc4gB35ShL9ZZlaPu+6x0lGsqjFRw+Kjj9qU+tf23hxKFSrMACI1V6Ne3sZN81BDrldOMzI2GuIrLYBybyd9KkoqEPGiEjdy3WC/HL1vi8SjeX+AgYZzyi9yBhq7X0hlJwIE0ni33vfotMiluk5l1ZJ9P5c4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:17 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:17 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 12/14] crypto: sahara - remove unnecessary NULL assignments
Date: Sun, 24 Dec 2023 10:21:42 +0200
Message-Id: <20231224082144.3894863-13-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6fb34f1d-aae9-445f-2eab-08dc04594d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GaZQtwDLAR9+md9Rkf8/cPfnxk6SMITxKoCfu//lDIbiR7eFbm/3OGk1Boz5NEDB+OgIn38yMlf0JjtExE0sEdZXTy1QUYxUfetYMusv/QrAfPYV8B54u5QkjvnkijzW6LfQfSxjIl2Y0dj+Qq99HS7UdtHPucxlxjWwM2ryfZK2kFy8Rdtp7a+sahlam9C1v2JgdZtrwOjH4dwq2ZAItyUITbjbWSAGAaoAOZbCw++QqwqoZbFHirAJPQn9b+PXDahWnpabs19JZVCA5OmW/yNFVjm2CYXUbzgjY3oylKWJKcKFZzFLgnuYMzkS4NBMV0/U9Hfn+xCdAvPRM5pOvXnpTkDFy9Qx9xSWTuYyE4h8wYsLSgFKd4NKVIUCv2uLV5vEg/+J2DE7zXOdfss0hldEZnpe+JUZPoWnig7rIeunOQTZ2iDyIShagtrg30n+C6QRLF0x2gr/em7E5nPd1RXheansaEUT0spMifhoL+mj4IMUhztlNBnve6vbEGXQU4ztslS4YfRPLRFsaX6mvJFSMEh8xHfkh5QhtP5g9sXApZuLqYIrlkxmutdIr/cZxlJHDcb2EpQQgWPeCqGTghFH4ohx4+W8R226nZLZNKm9vGSyltO7S/5Banzj4nwp
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(4744005)(2906002)(8936002)(5660300002)(36756003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?TLJOVMrSCC8jMKfg6ZlmCDZqAmJ4/bajc6n6psjcgV9TaHXiSMHxpi6nnF0K?=
 =?us-ascii?Q?mN+QDG/3pOKvm8crqZqX8bp1aFN82Y73ba1Q5qV/NaHMM8+Eg0Kvkknx3q+v?=
 =?us-ascii?Q?guyO6W9cYaL22RNTGl2mTtGhSpdUNQsbRGDNrHvqkxYvOtlD/OAp6v4O01/y?=
 =?us-ascii?Q?EqU7A7N9cCou4pSldPznx4fkexkBOAk10m5sl+IBl8CyKzxg6IyOFI0KwEbb?=
 =?us-ascii?Q?p8ZZIfcV+iKJOUvddOMSDtZTTocCOYf9cSpIgOFXgKjaYO+IvtsJIXERsGAJ?=
 =?us-ascii?Q?y4djd4GZYIp7TCElE2Y5OgHf/AxHkI6iYKeMAJ7hTlHGxN/MzYMMdtQDNpoM?=
 =?us-ascii?Q?ZkTbFlbLwZ8zSM7BY2XkmKCDCBqRAlp0VuGcMdrPwhec5sl7OC5wiL8HU+Rq?=
 =?us-ascii?Q?4/LcN4oUE28sYSvW0whOaf5CqpckSGc4NSh94cV8n8HjGUW68Rq6QYgnT0r2?=
 =?us-ascii?Q?SyEgoQ8dJvKpF0bZsoHDQs/RdN9tlNzHpRCVMlO5hNxfBrxGoKvx2GViq+5y?=
 =?us-ascii?Q?16knyRrBNmfSPlW0OY0RlelIK6Ko2UkIvHqpDAnOiq4sQGHwM6Hm0gYk5BFZ?=
 =?us-ascii?Q?QUbig1QO7mIHnakEomc51vq0mqb3r6ZHol06HeatWPGPplELVTarGHxpWYmo?=
 =?us-ascii?Q?46zQEFwiCVPaiMOcs8FLvMqsGy7CBjegWlWU1bOys11uziEWbCcgXTBWHoK1?=
 =?us-ascii?Q?rmPC9hBtQLqUY5iNj2rEemLSTFDZsGNA6aKl72tnShU/jhFTJWMh4gK4lbbX?=
 =?us-ascii?Q?Mm4sBMpoHqFiSm8DMoeTg4aNQx2WWar0s0sWGMVugul4Hy1BqOZTwl6+JVnA?=
 =?us-ascii?Q?dA3tfeFiaWMLc7ZeJy+LewKml97mjcH65liNEiDEF70JG7QuyYqeSHT+C5W1?=
 =?us-ascii?Q?GE0qYJqpxHD4Vnwcgcz+8hEDgwv8zwTQt2hN9XS/5K4qfJQ1kBlmAPGePapB?=
 =?us-ascii?Q?I5dkKKNDHlW3e3uV5chYaGjyYgyQ5Pl1DWrzgVIaPsnscEK0C2TNdCkpKn1I?=
 =?us-ascii?Q?iO9HDIpvwrmLWzE7Tr/Wzoh2DQvmLzgR4HBcfj1XelZhcxCnUwi3dd2H29uN?=
 =?us-ascii?Q?VuzV3JArj4fkZim9wzeLlDtPjnt53vQZgnEgRscikaugwXtVhR27kzNaOHyy?=
 =?us-ascii?Q?sUOZVjt3F2BDblmiv30ZETwc/2W7QPVWKZwAcv+H/xyhD6xqe119hG3n2I1K?=
 =?us-ascii?Q?C7oLVpUPjZwpzCrydw7gpylfD12yJy213LOAuZFye+HFDW42CGvpHr1vbqJS?=
 =?us-ascii?Q?JiS2o9/zZi4TWyGaGEhgJKhNNSmjSF+zP0hsztQwrLelcFnpeLRgZQyTqhTk?=
 =?us-ascii?Q?lLfI+7EXpwmEWWNwUpb0bsdn55v9HmLJRS4UYkgnKTNNpq462tyO1yAWmng+?=
 =?us-ascii?Q?YmUoI8bre2jsl1o6jJ/+NaPkj53NpORQUp0hCuJqXkviEo9WogfFm0YTCY/G?=
 =?us-ascii?Q?m57QBunJf/lQ4C5sPgjsAP40CGrlXC0AQjaZrk+ScAhQUo3nEDaJw44ba3Fo?=
 =?us-ascii?Q?DdGWPmtaNjEhrme4I5Y/l8ZoaePkVxgZDEOAeOvWZyCu/TiERro8yL9EG+4V?=
 =?us-ascii?Q?uzUIoLXnIlD0GWQMsPVQyai7Vx5GEQjLr+f/ZIs5OE+m2tAJiM1LrI5A4HoZ?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fb34f1d-aae9-445f-2eab-08dc04594d1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:17.4765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7PLSUBgHBkSFdzrh+9V48ZOZienwo5sPsYC7LDmkN4pcJC7XDvG5dx8k6smS5H/ChSI4Q/IcZIoB9v6TZEMoRk7AQ3ftH3OhHCElP6Y0gY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-ORIG-GUID: 5SYTFDqDEpZE3yxsmZ1a0I8LWsx4AG9z
X-Proofpoint-GUID: 5SYTFDqDEpZE3yxsmZ1a0I8LWsx4AG9z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=994 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Remove unnecessary 'dev_ptr' NULL assignments in sahara_remove() and
sahara_probe().

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cd14514a43bb..fdae8c7e7c78 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1440,7 +1440,6 @@ static int sahara_probe(struct platform_device *pdev)
 
 err_algs:
 	kthread_stop(dev->kthread);
-	dev_ptr = NULL;
 
 	return err;
 }
@@ -1452,8 +1451,6 @@ static void sahara_remove(struct platform_device *pdev)
 	kthread_stop(dev->kthread);
 
 	sahara_unregister_algs(dev);
-
-	dev_ptr = NULL;
 }
 
 static struct platform_driver sahara_driver = {
-- 
2.34.1

