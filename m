Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2D6C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 17:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240883AbiERRe3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 13:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240893AbiERRe1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 13:34:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACF16161D;
        Wed, 18 May 2022 10:34:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IH9eto028355;
        Wed, 18 May 2022 17:34:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=R/3w+ni85q5LHFghof79I4XBzVDJrVyZ4K02mhL0eXM=;
 b=FvpFYeZhivptOSn8jguFXqJQMBhOfneUPD+EjBNetNR28JvNOOzmIET2VgH7l//dKnjB
 x6/4lyhkM0JbP++1/FTfNY8T0G6Yt3ioPq3nDhICa3/bsfmrtjV+SPO0duq749xzvIZx
 gUHi9G49b+saUPMnuc4rhkeZghtabI+kJgKXTK4DdzjgpxROW4ZjPnkI1sFlQlt820p8
 erhx9j2iosK9ZQ1WpvSOQJoxEjFGL+dgRH6DI1QRyOf+EdQd9pke3Y1P73sTREq9PE/5
 3xqc+ShaXKFjhzsTFsGUOLxHSCJeDZjiXG/o194M9epyWbrgs5/oTiFnBDmxuTAOtly/ rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc9sbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 17:34:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24IHQ3mb008300;
        Wed, 18 May 2022 17:34:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v4gh41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 17:34:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaPbc6TrZj8t44+PWYCnk6sjdzN6iHVvDt2EQdRHmCG94doNC2iblw6IBLzfniMlo4invegd/rZoVY61qP7NvlzJ8n3vzKOqid9mElZqYX7fdiznEr4Ey6pE+ErURAnVSG5qGJsZW1rv2KydWpDuX1v/tb5iOfR1S0Ij0HoaJGwCh6JPtnf63M6AMgWGas09SyIZDDxBYaKJb1gndb2ILhBL/Fp2iimpx7NjhASsr6XCsNGSPQXW88sVi664exhZWA38GTEpOoI8HPnKAlWmPN5P9uuZNVkxfs//nQ/1G+VU/Upnkt+rCSBBOT373eu1KGD4VbM3dqzLE7pNvwuBcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/3w+ni85q5LHFghof79I4XBzVDJrVyZ4K02mhL0eXM=;
 b=UxKPb2CCJUrqdMJUA84Rp4WjXghIsQKVMFztPW5jFRgEj2zg66vqtVC6p13bsq22ZhGt1NRiU6k5NzLfzmSWacdXr6aFHW3GnL05BsK4FKE9n6lfMttI0vhj0uifkISFop9IIzpry3MQ0Kx7NDzVkCGUJRCDHZRPBnQ7VsngUy5o9IlWNZF3sOccobGZ6dwOX+0XBs5cGRVBXh/wB/zx0fY8Y1CKj2SoiPzRVYysDwnDqOhWS4XFHZnwIMzrApDDG8Cw+onnp5gIpORGOU2ZGdqc6AphmTNk5LLMDXTa8rtrCV4eEJfH3vfr7/TL7RXfP0HDhBN3gcd7IqlC6g3wCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/3w+ni85q5LHFghof79I4XBzVDJrVyZ4K02mhL0eXM=;
 b=alm2N9p5jzkZE0ecYVBzxVECtr5NEKdd4GbEfUF1b8xf16yoCxgUfGiiDY9VATdzbX6xci+kyZA8kUw8/8A4qGAq2cyNwJGZXBxtPgmN6jLZ47Rme0re6pgiJ7riO6IvbuvI3Squ121NzCcezvbNdNEi3B39ft8wg/x16Mzk0GQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1927.namprd10.prod.outlook.com
 (2603:10b6:903:122::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 17:34:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 17:34:05 +0000
Date:   Wed, 18 May 2022 20:33:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: sun8i-ss - Fix error codes for dma_mapping_error()
Message-ID: <YoUuAsJndw7aLn+S@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::26) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 606474a8-3964-44ab-daa7-08da38f49b00
X-MS-TrafficTypeDiagnostic: CY4PR10MB1927:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1927ED07606846C07554CC968ED19@CY4PR10MB1927.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75GI3Q4CjPYzaTVW4C7g6sw9EZ6MZhO7h8BufKO5sQRd4hW0mUz9Vl4Vmj3wdVUI8enJt1SXe8kv/0H1EyiMVxNHOMIr0pwCsDI9p9HizxxG/QgbkHBPmDfUY8CO4wvLxCD2TSgBX7rkwkDLJTsS9CDITu5He/MiTtiICqYeVO2yUM+FFWVQj+t40DK1BLHFAxev/8rF8xRwEKvNAEgJAbWGONYrG6+qDnPX5fYgmoGWPB57YQmcgfLC3orK7nQHvr3sWxFT/N4hRCY/4JeXA0UhfujSDT40PDwWh8BLZjfHYBAOogXX+clnjg7KK1CrFevIgGYcqtC8Uk/FcO/DFFzYTb1oxvS57qSxDgRcV7ah8+XigGQsdhH2bzGXPdBvFqcfhsk3dXO/IZMc3ocIKY/JZG261EOvw3mQ5h0Qsk4p6NkNaQ0gf4nu+XhxKUE3XRSc2Ujgnxl8mgHHNXexg5ZhdVAXRXO5wRNhOgjINCA747/RCCuG1u7C5qQIGbJyZWfqBEFmDIqn5/dNDTP50ziAO/XC3SYRPy5Jmte1SHM5ih2IbOrLZWQDivZyv//aZStWtnZaJ2u0VygdEQPFDiw1Ov3qFGH3LAyDfp0pnWbbFJsWc39wRLLiKsWhhl6h9UxnzWH892z+pl1zzkekuoc3ETkbzk7Je42fccKM9LQMOc64zy/u6YHDBOUKNpsMhGAK7zQN/BlYfA5eJPA9B2Y+sCtXocya+JRWKIGbCRKQ+LRfQfgugqd3WfNAnxF+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(52116002)(86362001)(44832011)(2906002)(508600001)(4326008)(186003)(6666004)(66946007)(6512007)(66476007)(38350700002)(316002)(83380400001)(6916009)(66556008)(6506007)(8676002)(54906003)(9686003)(5660300002)(38100700002)(8936002)(33716001)(26005)(32563001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?drVtAOG5va9cTJyOZjQng6/zU8r0YvFrlq/QIyU3d/M2uYePlFXxVpvyFNc/?=
 =?us-ascii?Q?GmX+YNwQtQSoDVp4jBV4qf0H6nmu4wJ9iekzF02FWbtpD58z56wA7LurMZnG?=
 =?us-ascii?Q?xl51154SaVLRrMx83vi74JK4uTAr9agbwpmUs5IK6yHWFA+YbpMoFQz5SiJd?=
 =?us-ascii?Q?J90wkTpzhIGCqAc8O3JKrUNsiMKpDwK9icqskIktxc97Rbp57i/5uiPmMLmz?=
 =?us-ascii?Q?TgAVZPXFDYEuExtxlaZr4r2oChsq/RJ1pesW795WVjX5MzX92AnRzj5+SQA7?=
 =?us-ascii?Q?85B00aA9ovCG3QF9lzdAEKAZhSSg+fWc/OUvsVd39rBCdkFIPbR+en1e2igB?=
 =?us-ascii?Q?X9MGHcH9RFE30PWraQvckxoflsUZQwAx6hnt+y2KkvNmGhQyJgI+X7PlZM7/?=
 =?us-ascii?Q?0z7ogac2/YKFMfRiAk0Duyrtno10/W6Ak5pglYwWYu8BSmNAkDMYU2yiFKlJ?=
 =?us-ascii?Q?L8FoDWXELvnJJx2yAokKr66mqlSFLlMOD74d0VGRdiEjUtty8AxlMArY4orW?=
 =?us-ascii?Q?rYV2yRW0v4ZqbEINTn10S66sLCzv0suSlKzokZ5l5jW9J8YxDI4KKqvpsfdH?=
 =?us-ascii?Q?yVeSR0wBfJVabBkHh9bC1iTf6WCLAkH0/4uoybdW6WUfJqMtAjJI+zM5XqnV?=
 =?us-ascii?Q?G9nVUvpgmg2xsxE/NSHgbgvsi0NJIsBx9AG4AWfAJ7RbXoxLj5QPmbY6+FtR?=
 =?us-ascii?Q?AYBeMGXPj5YEB3DpzM6smi/m7O+yhRi7mkBgzdbpp7oM4KUONFpoNEJK/JaL?=
 =?us-ascii?Q?YGVoJ2AEj/Y/NHpIYTLwq9dDc9qVw8GttHVR8EDMJXOTTrww4StFPVjZuDc+?=
 =?us-ascii?Q?aGMluVKlYGVKg6hDTtl+oePAaOpQVncl8WhMVuqe9jfW81FzigBUQj45rKOD?=
 =?us-ascii?Q?X6ZnfbYd0AY4atofC7lGFkANJijxZOVf/Wtk3QGPldJudx006ZVaZYji3JHn?=
 =?us-ascii?Q?xAVDx2BxBltVbZH7G1PU4zEG6t3Mj5wngsthfjh26fNdA4Tkem7tD3eAjJy4?=
 =?us-ascii?Q?yJCogANIhBFWYYFyUxp9sZL518pHXxsYBSH97rrm1GLGnr8XT53eZsUdYco/?=
 =?us-ascii?Q?n/SkQCAhXXDLYLI4MFIHpB7wsHyO+EutuKtVBNKOh1MVxOfnK0ddU2eER4fF?=
 =?us-ascii?Q?kgS2yueI/BfXsdATlR3KH56YkBCYDEnafxkbrW67G4uPMEbgsh+KZIV0nLGW?=
 =?us-ascii?Q?lT+HpZFZgw/QDxXL2qOrFVvpMUfYI0Fg7sl611DTCch7o8zIS210WjkWbb5A?=
 =?us-ascii?Q?zf6BkNNuqcsQdkTIvfR5MglEDx+umJrc4I5c5IbK2Hbct7Yz4PhWany4+lsz?=
 =?us-ascii?Q?6ytQfCFRXC4lqcB2y/Yu5Bi+EbQ1Q1aElbnlOPLWUKnjupMqvS7fm3V4f4s+?=
 =?us-ascii?Q?DdQn+SgGRg6gq+f6F1crQ7qOTA5WuzG0MZI8DsyGZJUl8t8zPYf7nIVRAT8J?=
 =?us-ascii?Q?Z4d0tXNCtFallew1CStlW4HOwSoAJUXkX5mKqp1SzxtimLBHZ+wswKgxNvc0?=
 =?us-ascii?Q?FG7dQ3zMPUW4D7uTRf+D8zZWpnt34fA/Xtyu9NWDYhH4fIWkFYhWqx3MT/6d?=
 =?us-ascii?Q?N0WAGqeOcKzB91fHZUif/oIIyUc95f2g0QtKoz+83Vj28jTAUPl63fN5Ppa+?=
 =?us-ascii?Q?yr+4D1nL/BRqtZOw7hZiwQRulNIjOAWIQn7DJXpNMbcH3h0CqvHTk9EKC4d3?=
 =?us-ascii?Q?gAVSJPsphFoKIa7fCwoNOjJ4QBlaiQrxe8RXTGU5kuUgdGVz0h6UlTvGy6SC?=
 =?us-ascii?Q?4AdMSLEeUCNQgQB0QGhlVe8kHf3ZJxY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 606474a8-3964-44ab-daa7-08da38f49b00
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 17:34:05.3015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k/l/47LR9mhIh7EW5K1hqVE+WzkKBY0Onx+GLiTF9U7zlmlD6xZBykEo/fa+UhJ56WN/9+BDfUPua0cQNVXfQNAT3MtkQPBwD97zsnPMZ6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1927
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180104
X-Proofpoint-GUID: nNkzaciqEsbBejLAJvU6bVesmYQLTRXY
X-Proofpoint-ORIG-GUID: nNkzaciqEsbBejLAJvU6bVesmYQLTRXY
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If there is a dma_mapping_error() then return negative error codes.
Currently this code returns success.

Fixes: 801b7d572c0a ("crypto: sun8i-ss - add hmac(sha1)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index ac417a6b39e5..845019bd9591 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -586,7 +586,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 			rctx->t_dst[k + 1].len = rctx->t_dst[k].len;
 		}
 		addr_xpad = dma_map_single(ss->dev, tfmctx->ipad, bs, DMA_TO_DEVICE);
-		if (dma_mapping_error(ss->dev, addr_xpad)) {
+		err = dma_mapping_error(ss->dev, addr_xpad);
+		if (err) {
 			dev_err(ss->dev, "Fail to create DMA mapping of ipad\n");
 			goto err_dma_xpad;
 		}
@@ -612,7 +613,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 			goto err_dma_result;
 		}
 		addr_xpad = dma_map_single(ss->dev, tfmctx->opad, bs, DMA_TO_DEVICE);
-		if (dma_mapping_error(ss->dev, addr_xpad)) {
+		err = dma_mapping_error(ss->dev, addr_xpad);
+		if (err) {
 			dev_err(ss->dev, "Fail to create DMA mapping of opad\n");
 			goto err_dma_xpad;
 		}
-- 
2.35.1

