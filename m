Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29FC12E4C
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="himgR+OE"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNI1QFp023723;
	Sat, 23 Dec 2023 18:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=PPS06212021; bh=WHTWWF6fs3oGlO2xpI
	VhZtmOOTc6efUyQ676WhtCIo8=; b=himgR+OELYbRauPxa7UJFRNInQ7WIfmaKF
	3mMy/0zNjy3U92OemhFKNatnqUz6ilJ0KUmCsyzIDkNbykWZWLWV6Hucv3Ha4626
	ydeeyAAqwr/LHDfx6+IeHDVvsA65uUGKlw7dXr4afKlhEfYVaBifI4gIpcUfj7km
	6DxK4llM1xR6u4il9Uct10UuzlyO8gJKtZdtB6m7UuaqEaTPk1hR2OqpaqiBxKKM
	fRHMh0JSM/ctp8c77rK9a9sHEU7cU3jaqZS75w2VGkEfu4KLOPqZxsgGWImSZHQ/
	J5H06Skd/9uBIkI1smkbD2O3Iv65GgeIIAqc4V3dxEzKvB+W+HiA==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5mrxrfj4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8ltF92WSKLToOaaUXVgA0tvPxOgABbUbfCLogWcFsPg/LLCesz5EQq6Z8ODl8ZeKFhpQvvP7XuiohQFvJabpzQGq+mnYHi+6650TeXU3dSYKoGJxGcHCWONYF4hCpFgKLyHDdpJ6ArGXqKbJOyjceD6dGbcv6JUz/WCVT+g1xMlgXb6cGhgc2ozT2BvN+Cn912avb1DUHSpA0nUlri82CStn8p93gSAiA9ikAaC5mmTf+zuSZp79yqcux5kNAo1nlVcdV5lrVlJSZhGeklxh0lzLH2k35d4PtL/OCMpoNsi+5JFsFFSbcgLDNgxlyt+wmNuMplhNJNHzE6V75McVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHTWWF6fs3oGlO2xpIVhZtmOOTc6efUyQ676WhtCIo8=;
 b=hGtX9fcznEu49Tm5hWYIyc9jfRohe6OlFwn5gzvxUS9sMB4frDYga09HlS7VMFc7u1pKqAfdTXjWfXugNOk/zEx5ml376t+StuOW8XlRHsGO7yWgav2LDGuOlkiRTpiavRcbJsUT8xE3SC3YpjPH8hBbCJhw5L9OowwTPcLL1uYHeCLx1LvDyz2dGfbFWZCtWXMzf/QoKm3hrahO5qHtZuybl4GcxLTMp75Gaa390A2ELTv1o6V7CwIzq6t4LkrRpm23Qw9G/LUAjpe2jypI48F1Zjy0QKD364LslyqPnxtBSNWswA+vLhAwQ7XcjA5GZ/PC2upKrMDWHkq0kE2DuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:36 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:35 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 01/14] crypto: sahara - handle zero-length aes requests
Date: Sat, 23 Dec 2023 20:10:55 +0200
Message-Id: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 0369166f-7d6e-4643-81e0-08dc03e27597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	cZcpToBoX9w60ZJ92WknUdFGUwxG1XpvnfED00345Gs+skX8OUpR8QnS0qYkXDkfHMzJxcfU38Q3fbOcVms2fccnuhvvmzxa6UIdFX6vlIAoLzF6f8mueiIj/KIikpXxzDJm0tBYVg8WmW+aM3c279KkZ5imBkysyXGzvyO3dfaGbETVcZSm0gZsHD4P+uxiIOAa+BytvMkcYCnizKrICLfp9ZvGVWG+ib6DHUZwsbuX1HNNaJr9DNX8FQF5TNq49s6f/Ll69iujLt59FH4FDhJL2rjqMY/5VUtyDo+R/JYb2LpuiPWCaQJn6ayS0fj2B3AvktlX8GvoaO+dDbzPyNWktF8uEv46wdziDyFIW5bQZd6Z0P+NJS+iTBUGSX+qn9BJYMgPbRxAHFFdWSzVmFzJ7vzrRz4rzuZHa3Q/ZIvucccoU8dx3sL595ykYyqjtW1XgKpVrnEGYGXSXQ0zC0hewHst8dsW2bQA9oJV6+yyyJpELgfngRnQFRNeiVLB771bK3xYyVMbTQU1lAz7QZJewSNNtMjZEGBeUf5Ju2BvwFS55bfn8vsG1FVn2tAQd6KB4uqOkZp2RYPovJh/5CvsCUcsrYLgh8+myVKW0mksOHnouXS7QBwr/an9DuRs
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(4744005)(2906002)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Y///84fHegGJbmgZ2dRgMQDt1x+9PxDlvlGh1h9EGZv1Y9Uqr+Xzz2UOVRGA?=
 =?us-ascii?Q?ETroHfEux/M5ohN01zlMHCdKjgbeMyEY+qVBter0eXIQGUgmZ91H+9XJuHJM?=
 =?us-ascii?Q?Bi1sMrDAn4Qg/Sd9PGrgZTaGlKO/43G+3sigwH+P35DG2EdqbHUnKZVNVFsJ?=
 =?us-ascii?Q?9idQ2k73Y/O5SwVGrujPwfMajCMPXQ9TMzcqXzcXi51LMzLK8SX403yvivol?=
 =?us-ascii?Q?4gGTngGC4jBd/5moTWJX08K/zhJDBL2dfdnW6uQ2UyEbw1OB3M+YYESEaoTd?=
 =?us-ascii?Q?goF3/jAbLdmHYP92nZKdn3qROyoTJ/Sli/uPo3Ei4/EeY23p7TcK4fVenO76?=
 =?us-ascii?Q?MxRMWaLCfdBaRVG6aFOayaIkL4QStvomXcfyrrxEWiZstDPttFsBh0yyMev8?=
 =?us-ascii?Q?ghs11rIdrSYGXGLi3XRdla60CbUcQICkwUbxpX2bIu7VDM9PatRFLJdd7Ygy?=
 =?us-ascii?Q?7W4RCe0M/Etvt9EOe3Bdf7AnRiFDkKwNY6Gi05OF49f1OzVg39/SHlOGn9vy?=
 =?us-ascii?Q?KJBV2gKQKM0l4Oz2iyKydXVpnj6+EVp6VY8YbwHVOuRf3ShOxrYu6HsbKFFM?=
 =?us-ascii?Q?UFzPl05JVob6NSm8JNCEggG5h234bjXraRNwwpepCt4dgZMU09QrRdkB9zSL?=
 =?us-ascii?Q?W87Fpgs5p+nIB/grlLSK+M1r8nRx5xwkH6zhYOHJJNnuIMl/yFdaSjl3uxKt?=
 =?us-ascii?Q?FvhIv5MNID+JhLOLsEezqLMom8QRGGeHzD5drbr40GZ29RW8o7vp15eSUb8x?=
 =?us-ascii?Q?27BMNyQepBYScRo4RNTrM8p/haDdYEvc0CRr2b9I7Ae8VQJUY1C5qRGg3vJY?=
 =?us-ascii?Q?RewTJqhy454ogvGKb/Ooeh7iuQ6nkQiW36C7AhKa1sIrRyJEQP3Yg9hHv8HM?=
 =?us-ascii?Q?XDyyWWTIDjUf/TOfQibBnbh1D99/NOj7KDflzM7nqniuvP98sqFc7ak6vab1?=
 =?us-ascii?Q?wIs0QB+66c80o9RxOp0jbmsKDKVG9XIF5gQPLS7lTX+l+Yp3ECOfVm5POThK?=
 =?us-ascii?Q?PwoEEQxFhhys349osB0Rp9Oht/CIsGZ2px633axWU8RoqoHkfpdEVbhOzT8k?=
 =?us-ascii?Q?LzCQT+ZkVaUMNLJBcDlrX5Qe8fmJHUJVxdfsAcT/tnvJLMjXOYACLU+0jmDT?=
 =?us-ascii?Q?LrcZPYcmUjwdErw9wmL3p/knHIL6OpzCz6oRCuU46UJ9hjEY/wu4aB/I707Y?=
 =?us-ascii?Q?ygyklCONLxityBDLbZb5ILR5H8Q2NC+hvmWXzzxljOCbNNUeHIRt1ht1IKOO?=
 =?us-ascii?Q?CZQxGmMFhBFaYbv99fANPieNuAWyleb/EfVIXZ978CkHXB9pzqj9CwYkxGIm?=
 =?us-ascii?Q?KUggHtQsXTkZZ3sEyNoC6K/WMdQ3LvYLdBGy+22QaRKcuv1iAErU2jJ7w996?=
 =?us-ascii?Q?g9tNaTESmuo9L7pVXotP3ijIBoGZIeo1Pqzl9c2vGoeWOvV0Zr3ayJ6k/q5B?=
 =?us-ascii?Q?m0mjhEwqKcGSzLHQTZqyd9BIQaBzVJFdHMTtSJ7lMRbcY4WS4+TlODUYKCay?=
 =?us-ascii?Q?skzY+RT265h7mXQxARsXe6Lj6C4rLTDIqIgL+sw27z8ROCmtl/si94t9YqOf?=
 =?us-ascii?Q?pEYHVp8MhQa4C0ewjTtojWlrcPXF/mTprGhhqDFHn+HpxD9nFNAEXNYyVxBj?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0369166f-7d6e-4643-81e0-08dc03e27597
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:35.3075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWQIeuOGuDK/FXgv7JcikKz4PIPoalcAWN2X9Y4tkl2gBnZXdkJDeZxyLmelzo3Bf2TTgec07SM7wnloAak2DaQL6qtiTjXjjs9TqyMkB7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: hBad-j30tYn8VdfLEgLlHOnJNNaM1Fhd
X-Proofpoint-GUID: hBad-j30tYn8VdfLEgLlHOnJNNaM1Fhd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=660
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

In case of a zero-length input, exit gracefully from sahara_aes_crypt().

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 27ed66cb761f..1f78dfe84c51 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -674,6 +674,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.34.1

