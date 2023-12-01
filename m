Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Ivf7DcdR"
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EAD103
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:36 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B1BuDX5005878;
	Fri, 1 Dec 2023 17:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=6bt2Th3bngJ+FIXOXX+bqCZ876eCmJ8WSuXXzQJW+Pw=; b=
	Ivf7DcdRICqTLs9IL9J1R4wQzR/LF5yrm4IMx+20Yyh4yuyR4uq6lSbxTRbv6Sle
	cU8cCybUEw3t4gRVovMvtnURaT4/b09RxvUueuBFZjnHZcs+/didpMAUBeiFRRiN
	SkNW6effmQahcO/3t/07cdsdXD8+/Hv97pOx5kGJJUS3nt9B9tVogE5zeavrdoFl
	sLFMhsygo4cZFJSAg6nAZP/y2W1z1bpjDPDgqTmFko+VQLKCBgJbelfKOLcNk3uK
	+Qgvg8SnEbIsbQpEQg4V861g5efOBlahzRSeG1oBSkY4LtIb/66E0lP0SYHo7J4Z
	t5Xkkpp0t/iN5j3kHKJO4Q==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph109x2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 17:05:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icEazFGz5gyesQWTsTe5u48yeyAd4iKix4x89p1vtfWNJU+swTjlP711/o9NACyzMLXE3uoWhdYDRCsEL9fe8ivOWZordNGQ3JZJI1NoMaXYlCtFRV/GmUR4pmSOazRIU4HlDFc8sT5ztTyGY2b5vytsN/Faiv2/JBIiXbDw2HpUWGhgA7BwDtCyf57IXAMhZ1bxMZMnxpVsE1azlV9ESkuwaRF8pnCdcWeiB2UXlrymVo7RRPmNIrzNIoOmah+JEjKcHI7EWir/+vnRIbM6OyoIbWto0YUpjwm0HJqbz0ACYFjkVx4FIafLxCIJ9CFJMch7psZZ9TIcYU69ou8wDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bt2Th3bngJ+FIXOXX+bqCZ876eCmJ8WSuXXzQJW+Pw=;
 b=ocNjELDatwAlWBnc9xnlyLFEt24j27IdMkjG9R259++n9kAgmcWhfpdfqjdNTVuqVqmvP5jIwY00irtPsYcZTFUMv+Y2RyYUlFko4b76DXf16lNzWF2I23clK8hAK1H0xn8ceEHcMtzdG/0zdeg76Xb3TAYrMD04hrK5Df0d+oO9mkfMANpMVlkYdu1w9r+yEF74luYHdrxqhyPoL+KrSy9LWOSUXJcb0+MsKWzGCM53OP+FRhnTTmFXTuCfzIxHHoUhrxxFF51Nh6SAOAK/SrYxA8kI4bZAkOEPfx+EXRN9JnJAb/N2Hfnx63UJFQ8LQtCFOXMvCRTUdOpK3aJeKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:31 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:31 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 5/7] crypto: sahara - fix error handling in sahara_hw_descriptor_create()
Date: Fri,  1 Dec 2023 19:06:23 +0200
Message-Id: <20231201170625.713368-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8bfa03e0-89dc-41a4-badc-08dbf28fb997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZMEIBH9zlw0XAVg0tE7oYcbcHRTglxRIhMGidzk6vU7hIgNQyP1ZM3BalDlUDGPblQE3+x2ptSpWHCW3RvxF/AJChvCTiIhPXyLiYiSNky+vJ1vHUAp3HN2i8tPNaBKWFpPtw1CS67zTDeKJTSetR8SCccXJWcxSUUg46MLKYNfWvZhCPegxDM0zaZnCKhm7OdQqrmFnyXuPhk0K0k+O/sQttdfEvDQciBw9ELkzaJtlEKQ4etcyduToYzLchbeJWrvhzjtUitacs8qEodEvHwVX1AY1ER0SCGnFGrHJ/Va/JtLiB7EDhrPWUn0Rmy3u7qNGYUHhivC9kKk3W4n3iWFxjtGdLFRMPwj+OKME5MMbLRUd+iDdXDeq1x15m2WJdh329QVIVKnpzdiVXGZhF3+40YHWenoZVSgGMJLQxH4cu4pYb/5vknAhKZ80S2vBmwyH3xppL//fkY6IAf8a7L+c2obOZOvs4OX/nKE11kpW3Zcg+U0JvZjyWWiff1RjWQgRMJDbhBxuc2zMBF1o9oimAafj4Sc9lR3VutWRuYQak15VP+BiNtIfOi57Nq8P0rLCHEsz4pjXsa3grtV6+sE5CKLrZhKz4yUlXxyrTWHSAcxnZtgdfrsYZ/FPuNyu
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FMnrZyN/nhKevoVzKJQKbKTdzCpJxBk7rIre6pDmmNAn7zzMXUZh9X4bsTIn?=
 =?us-ascii?Q?rr8chHErULh3D24Kk4U9z07rMnwKUGBOSOYUNMEa/pMy45qma5H78XYLjUHD?=
 =?us-ascii?Q?i6B+we4jjygHHrt8RnjrODIp0qhrfrwlb9G2dBPGPm/ARfHsD8DYhpnta6AG?=
 =?us-ascii?Q?cGz5MPtTjkAieddm9REaH6BQPMdVKXB8MowVzoXHF/KbelNOWLEcz6S6b+/F?=
 =?us-ascii?Q?onB697HzlkVxHfqOI9gPwPi8+vVittJK29a8P2kbNiouQ0WxwLeMmZDAWnN8?=
 =?us-ascii?Q?nI0j+UrQdtAF+KlVQj+TYFXycfXj++DB3ecDSShXu6gaZ/NZKdfZ1a0PkoXE?=
 =?us-ascii?Q?Jw5bAOAZv2UpLbBAUtwZyxg0V/c+c5M6rnQwGycqFYObnaiecXuKPAhpojHQ?=
 =?us-ascii?Q?BkOcV1ZVzsqi6mgkE1nmAZLVYf+R0z8QkClA6wzuylTpFry6ygjf+ifbFWqo?=
 =?us-ascii?Q?IHs7zHEvyKJQp6KfIk53nqg+I4hGr5A8GiS6+uaBcXdNPMNVCXWrq9KS0Euj?=
 =?us-ascii?Q?WoimiFms7ywILTrhmyhzWkPC8TQIkbZ+gPELBPCDC4UdedQH6sVXKg6AgfD+?=
 =?us-ascii?Q?6EBAEtzfPKptJRXJ/lMLkLjdHH6LrPYfh3LPEAu8WAXaBOC5PxVATFJyzN9P?=
 =?us-ascii?Q?4NOK4nC7hSxuT1KWFEXMMgnLIG53DXoMQQ96VLDqM5lFBK5JI3iBRp5fEztR?=
 =?us-ascii?Q?fP1LP7HqdDZzie8wEUSHLiqj/az8xijug5CpaNZ+2hoszHTkFACHYEnAZNls?=
 =?us-ascii?Q?W6fdi5bi91dH2jjRnt3N8X6DA2kHEGWpvZXvPqfCedJUfKDsbU0pAPpOt9xB?=
 =?us-ascii?Q?igBWSlhawN4BUKM1eDYztnOVl5LqoQUQHBvhIprAiGoRKdyNOySZoZ24bk4y?=
 =?us-ascii?Q?+Teo0cYNDvIkEKEAbxtvbQBaHg8RUBzHZDFd1vHdvzFVyNOfm8KPWdNY3WRe?=
 =?us-ascii?Q?5xO3xiSyuLLYexZJeGZ5iC3mtLpDlWqbQJeCx5p0G5ZdV6dI8OvoB/9HaVlr?=
 =?us-ascii?Q?vP3ubjfn6s33btiAivnYYBPMDPYzS1BeESHvvuSoWrnnkbLDDDq1Nw2FV0aQ?=
 =?us-ascii?Q?PLacaP+W8kvfD5LWoqmVAL3PJpxQJlHdIzSN+3PCLPwfZJEufX44H3zhfSpV?=
 =?us-ascii?Q?f87wlJtDLBsUKsOR35bL+LTl4aXRCGfm712fFgFUwHPPb7apQq+Z6wlC/Lgt?=
 =?us-ascii?Q?NlZ+qNVOJ1gIWZPOV25JQpxKa4Xs+vsy33WfvVXJ8ejg6HyE6ASliJLgCHIs?=
 =?us-ascii?Q?7w1pvzKXtESeXJL++2Cd8tErUoMNQoO2GAym3vanyYN1oWDxZAy7MGS9AHgG?=
 =?us-ascii?Q?+rFyfveKniDEEYn2hr9PTlQPHbiOJrp3cG9QE5Mg+RosnsInUg+hQGCkqo68?=
 =?us-ascii?Q?qfcljKv1Jf4ozvwC7UUcpL34d/h2SdlZfld1oJM4qgVkyco0R2XGf736iCYW?=
 =?us-ascii?Q?VBzgj3paZiSnsTAwW4DGNSWMK5v7IcFOhQU4Ce9fiEDTsYt2nkzqUycWKKgt?=
 =?us-ascii?Q?NXs8qPM9SHrY6h/JQV9Pc+rZ2tcI2CMEz3uO8gcVN+fqMAl4s0GLmWTtCdvu?=
 =?us-ascii?Q?bqOKxTKrzcC7AeWUE6guXlTfQ5E7616N3hhx5ZJYV/YAdbMft4D9yOeB7ZHZ?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bfa03e0-89dc-41a4-badc-08dbf28fb997
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:31.3962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brW94UhFwvhfzuk4rNYBgvX+Qg1pHoE2M6mBpMJozxMdAT+8BCBRzG8t5wnZ37yZrdNEHJktbaOzbrENbnh0zU0f152mvShF5enUxzXKgIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-ORIG-GUID: nmaumHVsulRMC6l2kKD5XHPC-KTBYyK2
X-Proofpoint-GUID: nmaumHVsulRMC6l2kKD5XHPC-KTBYyK2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=773 malwarescore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Do not call dma_unmap_sg() for scatterlists that were not mapped
successfully.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index cbb7153e4162..c4eb66d2e08d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -483,13 +483,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 			 DMA_TO_DEVICE);
 	if (!ret) {
 		dev_err(dev->device, "couldn't map in sg\n");
-		goto unmap_in;
+		return -EINVAL;
 	}
+
 	ret = dma_map_sg(dev->device, dev->out_sg, dev->nb_out_sg,
 			 DMA_FROM_DEVICE);
 	if (!ret) {
 		dev_err(dev->device, "couldn't map out sg\n");
-		goto unmap_out;
+		goto unmap_in;
 	}
 
 	/* Create input links */
@@ -537,9 +538,6 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 
 	return 0;
 
-unmap_out:
-	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_FROM_DEVICE);
 unmap_in:
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_TO_DEVICE);
-- 
2.34.1

