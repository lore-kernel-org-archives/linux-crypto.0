Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F02CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 17:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbiERRe2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 13:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiERRe1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 13:34:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB042BB3B;
        Wed, 18 May 2022 10:34:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IH9etm028355;
        Wed, 18 May 2022 17:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=c/+JQuvfI4ezXbROUu6fiRMuC+uKyKGVgaxR7BIDwlc=;
 b=LQYWyLXZ1kogQvsFdAx2l8QStv7Le+bd6no/6wVEYFny0KukYKLCHIA7D0zeZk0XxFkV
 t6GZQ6IL5EJysM17DCb+iGHlgHtaPPx7KJpRTxYtbI0oiKIbVb/TvW2G4UfMKRudKwZA
 t1XPrhdsobsRlySoXYhqBTIYsAi4AhMKI7qc6jh7OxJCYJDxARtCBH1QQzNUfrJ4r+kx
 7zCODjaMvSAWxg6WNo0raqUKiqcOshgf3HO3ChWAP/K4vbgXNbDXMvCgNnsz1LrjQ7eg
 QdiP+i3nU3HP2qoqgzw6M/SpuB/Dlr7vUmvwkwRGRIzCLIglfOgE862m7UhwPgFHeI4E 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc9saq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 17:34:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24IHP3W6019947;
        Wed, 18 May 2022 17:33:57 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4g3mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 17:33:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZmtk7/2bW34sloKOPDPyh5X+rNYsRXkmYJnkwDayGFQtiV6FSB4iomJS6f0XuU3XPJoyr8je4d7dh0UHY8NXwi6FGgviYzThDXU6L6WNgpwaRUDmSeOImg3kcXojFc6ANuTwZrDt85c+6W/agd+43nBy/e0ne3QCTdUKLfh4HEsOFp4ZZQ523unAsoFZc5Ip7AnonDqQBQL0qDss9t3ShF/iFG/RcoTvVIrEelZyP0KmFmWM6oO3tUfiIdL+Hec08LQzZ7745j+bCT8FJ+C/w+HrYd5S5M5mgT+KC1Ph58Iky7gKF+NHFcRE39hcAc0SMHWPzXwhm3TcZDYdShRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/+JQuvfI4ezXbROUu6fiRMuC+uKyKGVgaxR7BIDwlc=;
 b=VQs0kTHdwbrbgJB9C0+f7wi8D/8moenXPDIonAV0oa7VkHGAIkubKK3SD1t6CbBsEibjsAnZGzPkoknNKgRUO/fNvZNoZ24SudcH1c+o3bdr/eaMQ8oSuxp2KIawcvWQ0K+JiHC4WtcBEYG1wSRpn5QkNmHQ8RxJ4+E0eMGpO1wbCrVZs0XMIm4ymH6CHYsNrceVdR7CLHuXVTtjCYu+b0EvxVprhLXwsvtqJ8dgk0k6Q9vExmC9DrEQkQ/qy7lt6ONpXE+KACXTQmhm+hsdJF+jiTir9cHGVck5f14aSqdJuqEcGMi1LooBEodOOrxkiDlSWuHY9FJuuCDPI0A7jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/+JQuvfI4ezXbROUu6fiRMuC+uKyKGVgaxR7BIDwlc=;
 b=HQVEBQnLTMOaVGYfQ0qOVBD25/lkCyeiFes3Cw6NRjaubYnB68pa6ZhE8qQEZ1mu+VM8tKpSqgIQt5y9FlpS4tKpEwMwkWad9/LSH/7F9tPoVboWJEHCVaPi9Qv6xr3dv15tQ+4ydyVL3lvlCE92yz0VN0jJr2ONJiwx/ehQnrU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5642.namprd10.prod.outlook.com
 (2603:10b6:510:f9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 17:33:56 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 17:33:55 +0000
Date:   Wed, 18 May 2022 20:33:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: sun8i-ss - fix error codes in allocate_flows()
Message-ID: <YoUt+LNsM8qFZYgL@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0088.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3f5ad2e-0f1a-41ad-da4a-08da38f4952e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5642:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5642D36E607FADC18F6FD20B8ED19@PH0PR10MB5642.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tymUb/WevjCV0ba1K/YDq33k0zDuUDXDOVHnvg67fvY4TxsbhFYnpeslRdRDZQMtCHX3bmHO0EykNeXPgd3Wa9PI/I7U/8T8UPcoHHl9FsVhJcpIcimOZjyv0SOy3amy6p3u8M0AjrJpuyfghIsDDa3tKCN+OjhvChlVG52in3GxL8ESfLHwBJBV1LEEz9U02e4zm2ZHVBplzT8bzRBX8NgkqgOmc0fFUAgocUZ/URucrjuAK235rUT1eAowj4exvwzBkZkJuw+L/Mvtg9BV7ubMpED/ijA7eBmQAi9KDSN5SyhzPDWbYiWJPidYHGD2OFBQYNpkYIgkR3uEAYSmlJ6XuIrTXeuU92r0SmUo7bm/+EjGsLmu+OOOvYrmJb6aL9/POHMVNqN6CYquWEeWHlevX8Pzt7q6NdGjJXJYzRQi/MtLHaF02O6Ml0nbnCvMVzMinP22C3defjxGG6lJ+iEeDPqcHXhxPsc2U9AqMWIe2ijr46yBzBZoZu5qyJhda7m5QD4Cobi8Pm+qT2r9DBoOXQ2/l9sSohsuHIsaKuUQ4iYJO723QHnOZb9P4rp10WJFMeSxlg5Cx8nxc+B2t1mirva2YgpgbmGVJVUw6i6NZI13Sfam+xmiqHwS2pq6cfPWPir2LIALUTusSbdDv2YLMNOBbgg4BOqm8TUmjnY+kg18sS/dZNWsFcIOHthrnnIDnJlrClv0dNJ18Y/7Fj4By4CsG8nUf79DbmaidGMOWkuPIHOS78o2sar0crw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(508600001)(54906003)(52116002)(38100700002)(86362001)(38350700002)(186003)(5660300002)(6506007)(6666004)(6916009)(44832011)(8936002)(6486002)(66476007)(4326008)(8676002)(83380400001)(66556008)(66946007)(316002)(9686003)(6512007)(26005)(33716001)(32563001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CwVFrQab4O5OSZCo26SNYS+a1C8nK6DzDPQO8JZr2C7NkvH3PjHbLXl/1y4x?=
 =?us-ascii?Q?Q1S7VRW9IoB2mI/UZ87mT+ayAVehIsRNSsPgwuDopBQ4BjxA3KoqR4+wFr3b?=
 =?us-ascii?Q?0o3Sbv+sTH3HAaMPRzGKwGlEktR/C9aouodR8Myf5FnrjHpbMNsW/+gL4FKg?=
 =?us-ascii?Q?YL/qVEkmT4LPdRkivxwSGEP0/x6+HgEYqNmnqhQ8+82jE6WQSUvRhQMjXTsw?=
 =?us-ascii?Q?aDNppGEqTjea9gWn4TWC1w3OQSXVZUo1VPdpyCEfPAcwGGQE7C/1NYL4OJZE?=
 =?us-ascii?Q?x8QPOyZE7QUjNWrvrVfEtYICnyPP+3I6Ap4zYvY9SscjS+34pb8kTV6v4+jZ?=
 =?us-ascii?Q?J32kRX5rFaB4y6BN15DyHmLKlb0zq066YNAtAM2nvoB4wddsS6Xcvns/wP8O?=
 =?us-ascii?Q?9LAiFKf42vRuXbTF4UB4ae859ez611c6HDfrBGRQ83NZk23TreJAwa1aYbNq?=
 =?us-ascii?Q?usvBBXkV088QnyFVMkeUJmQUA6kJIa7oKjl/2osNBCtZdhhW6qz1dB+yK8Qt?=
 =?us-ascii?Q?2Ds5hQHatoq1rBEp/gtHzblpFpOSfOdYmf+CjUiS7TmyBvhfoznqstzGiIMD?=
 =?us-ascii?Q?8A8mTwcbC0BvDQc1eqrKlgQ8Ph/J+YgBhj/DTvlMRhJeCyI04Av+ss4OP4ci?=
 =?us-ascii?Q?iCADw6/o6J+JoC5k26kJvRT6+FKyCrqWZ+U/dsA2nbSkqCiXm4F762WgmQvH?=
 =?us-ascii?Q?HM62EaZ+DP6/nX9YkXmp66CtIylwrv4aTMbWjJVDutXYo8v0kaI8F8/ElwM9?=
 =?us-ascii?Q?XooNjMWgS2qbg4BL8w8i8Jrh92PnZVwa+Cflsh8H88IBELKPb5uyRYav573k?=
 =?us-ascii?Q?AhMINdrF9BVl2NEM50gSXqVKFAiZnoHctiXcX0oHNjZmZxeGKB3HZYtCTLD4?=
 =?us-ascii?Q?6fYWhSqLJFFEm+d4+1JZSACDbzqSoLJ4HgoQDDh3ebVfVMvBnUcIfuF9PGdO?=
 =?us-ascii?Q?gdDnfZRNCA4urBzvmGT/ZRGhGSIrE5qDDvBdHiFvbw0Zk4cFuwO8vP4iy6/v?=
 =?us-ascii?Q?ESrSqHi4vUJZrUj57P8O9XppxMBXVKzggPo+2ANXDqWu1nUnKX93SSfGOMft?=
 =?us-ascii?Q?1+2LZiC7JDYNyzAfLQ3HNZd+TrRWnFzykBfgJ48wO5BeSSOamkkKJRGsq+ot?=
 =?us-ascii?Q?VNnASA21DLZfhqe/CuKAfOF6zFUKQUrMPu4jMxvICrKufd6Eb9M1A9OYl5fm?=
 =?us-ascii?Q?bX70qQVN2nEOgK4AtTRJ6RWn5K9lJSKYE2npY2+PaFcPCCZh6qHxC2xM5pQ6?=
 =?us-ascii?Q?ryQqn6yHtkiHhyUNA5dFtBdazw0vZFEzmjegk9pICL5tTKuQvLBBCxqjt23c?=
 =?us-ascii?Q?H0Ienec0nj+VywbmhHt2dC10hRf8REPhf9SXGIYjL4brgjtRznk8oINpaTQM?=
 =?us-ascii?Q?QXemUjVpJS9leCtbb9rM+uygQCadVRBiJ3Hn4CocxNa1VuC5D2FDOz6v0enF?=
 =?us-ascii?Q?DZ1RQIVl+cAeugz0HeLmLlZavYk7Mbf+V6CjNbe0NKSPQkcK+NzEBrs7pblm?=
 =?us-ascii?Q?R9kDjrLhNFemH4aA99FNJ7DPxSB4HybI9TfGktPKiyerHQF6Ss5stM30nEt0?=
 =?us-ascii?Q?h4UoyZwWtuuNG4A0qXV/di7JmecCA/Ptg3OCicSKaDBKoa4cXMmKcjS8g+g2?=
 =?us-ascii?Q?HV1bJEwo558lOQ/aVRbOXYsNqdAPbDJuRmSQCkWpeN4nbHbTcavb6D2UQB2i?=
 =?us-ascii?Q?7xRZmIZjxuoIYybij8DdDLCCdaC9eNV1Ffk5BZVTjgP8YKCyhZIHECRKqo8p?=
 =?us-ascii?Q?XjR3T6Hc2ZenR+xHYE2ppfdnyhwhP5w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f5ad2e-0f1a-41ad-da4a-08da38f4952e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 17:33:55.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RfoZMw/1/LQLBrk6Q9VtnV/sx//AuY3kSydxeXm3mVifYWXrUvW/eTkFMM5so3wcDniYgyCxDQhCz/wtuAoz7mC9IDHo2edfk7IE+dh07Oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5642
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180104
X-Proofpoint-GUID: IqyTXUp8Wg0TgqwikoqwQGeE0ap8ZakT
X-Proofpoint-ORIG-GUID: IqyTXUp8Wg0TgqwikoqwQGeE0ap8ZakT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These failure paths should return -ENOMEM.  Currently they return
success.

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Fixes: 8eec4563f152 ("crypto: sun8i-ss - do not allocate memory when handling hash requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c    | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 98593a0cff69..ac2329e2b0e5 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -528,25 +528,33 @@ static int allocate_flows(struct sun8i_ss_dev *ss)
 
 		ss->flows[i].biv = devm_kmalloc(ss->dev, AES_BLOCK_SIZE,
 						GFP_KERNEL | GFP_DMA);
-		if (!ss->flows[i].biv)
+		if (!ss->flows[i].biv) {
+			err = -ENOMEM;
 			goto error_engine;
+		}
 
 		for (j = 0; j < MAX_SG; j++) {
 			ss->flows[i].iv[j] = devm_kmalloc(ss->dev, AES_BLOCK_SIZE,
 							  GFP_KERNEL | GFP_DMA);
-			if (!ss->flows[i].iv[j])
+			if (!ss->flows[i].iv[j]) {
+				err = -ENOMEM;
 				goto error_engine;
+			}
 		}
 
 		/* the padding could be up to two block. */
 		ss->flows[i].pad = devm_kmalloc(ss->dev, MAX_PAD_SIZE,
 						GFP_KERNEL | GFP_DMA);
-		if (!ss->flows[i].pad)
+		if (!ss->flows[i].pad) {
+			err = -ENOMEM;
 			goto error_engine;
+		}
 		ss->flows[i].result = devm_kmalloc(ss->dev, SHA256_DIGEST_SIZE,
 						   GFP_KERNEL | GFP_DMA);
-		if (!ss->flows[i].result)
+		if (!ss->flows[i].result) {
+			err = -ENOMEM;
 			goto error_engine;
+		}
 
 		ss->flows[i].engine = crypto_engine_alloc_init(ss->dev, true);
 		if (!ss->flows[i].engine) {
-- 
2.35.1

