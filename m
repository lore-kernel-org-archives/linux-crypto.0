Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04014C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 07:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiB1Hu1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 02:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiB1Hu0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 02:50:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ED43D1CE;
        Sun, 27 Feb 2022 23:49:48 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21S6C2no008247;
        Mon, 28 Feb 2022 07:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=5Y7BWQlzXkyqJCNivl0BRFT02jmw6dJt+Z9LLF6vOe0=;
 b=iaOynXP9O2KE8Ri2rDtyWBoAep4Hm7n9dnoZSLhEBgNJqtWi4txipCdgOdfNz69fTMw5
 1ZUlYdO8/mYYZesBM3Fz+HWkxCYQBT2g0FWJ5HVQWWHlnwTiVsZGsEGcI77mlp3UfhIy
 gIr0apvn6YpEUUW9TeTjw9/61d6doysPm+k+Mz7uAGorFwJ6Zz51WczBI6ij1xfcgnF1
 36I6A6vBVA1kEMC+2YE10o09GPEbAA/tIWxtgmjoZ0e/gLWHdAWVC4NKarqxUm8bfukC
 tskjZP2cXlmXMgd14v7bsP9ZYfN7c9ot8Xjgd/uaSJfHl42Oash4yB2klh1ZBa345s5R kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02ke3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 07:49:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S7kmgq151333;
        Mon, 28 Feb 2022 07:49:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3efc12mqyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 07:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dw8brOxwWc1zP9wYGKVoSNyMd/CSD0M7TQETntj6X9/s+YpVZ2eWnVoYflTZzPovIh8GrxDW2i57CJA18KI9yJMbfOh2RtNWOXQxh+RO3QBn0RcKKbau3eQeeX58T9njPt+udS6N6LXJp1RuI8/bCZBfQgyPIESIxZgHZ8OxN4wR+y6zDl6ysADXx0vnMgDOn0vlKa2UNcv4UY8w6zlWkN4ND6HQRnv3niZy5YV3grob4lDeHgdsAlPSpIrE1/XWEOhiAW7dfFkUuEKX4YLXSluOjTtjegPmh4MPXWBFVtxr7qe9kDvc6Am++O5SJth24cHc5p8aiemltuQs5ubtRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Y7BWQlzXkyqJCNivl0BRFT02jmw6dJt+Z9LLF6vOe0=;
 b=W6TbJsJP3MqDMnfIsR5HG1VkgaCWouyXxmMDRnEi+8ZOBeTdwAm8dbTZgq8GJ4gpFDBdHYLDbzvECyBNIl6Z+C3Z+PgodU46fD+YM83B3OBr/6kpmc5PZ1nMq9ZhD3h3Q0UFYiiRC7Lxr4oXo+/4sNAvAEGIrQ+2jzYEsks8g5Q5BlyuSBFo01s4lM+2rzKFh5czERDqTgtMhr/Z/97ZUOHCDwzL9659cYApdKuWdicMwgHAogv+9mbPJeK1rnxTFft7Waj8a5dOsu+fRUqWmllBZ4Nbx6o+42t8qZsnkZALkaJFlLAgZh5r6u7CYLwecUIG7FqphfuPCfssBeQfXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Y7BWQlzXkyqJCNivl0BRFT02jmw6dJt+Z9LLF6vOe0=;
 b=Zfz1Ts/3d6ObPRQxDL0xr40JHBGfS2RekYbzpqngzhQewxpHxApjVXP0HQngDw3FdJWqNJnpPqFH4813vTsr0PhUh+p5Qk+bGoCp1SNiEzd3GvTAboQIoG7yIablyZgdsHZZolOHMlrkdb84i48ITSCJ3PliYpl1JMf1SJODoqI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN6PR10MB2429.namprd10.prod.outlook.com
 (2603:10b6:805:50::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 07:49:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 07:49:27 +0000
Date:   Mon, 28 Feb 2022 10:49:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Harman Kalra <hkalra@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Harman Kalra <hkalra@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - unlock on allocation error
Message-ID: <20220228074914.GC13685@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0172.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abdfe054-9054-4c75-05d4-08d9fa8ed86a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2429:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB242989C14B08BF690688B60F8E019@SN6PR10MB2429.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNy7azSXUtqa9CP8R6XhtdTpF4R6T1bcStZsWRbAEhWWBmjayVl2E8AQFO8KdkQ+5UGbuOJjPthcNu+zRrwdCGDb+Aj5dl0AYq2AsDPd5lkcWC2FTYW5L3VOqj489U9HgdK6MPp8O2VWbcc6nWDlBSPHHQGiHP+ysIgFH3onPDrucl7s+MXIKBDFbuxnE5FT+J+44xXeMTs+BtRBbDr9lulEK6BUdnexAWJNoPA9r2KyQANdffb5lTAjbl0yJlReKjK6ZfdvS61D/5zKaHWJ7agUFXdy0nOlwgsFOuZIvyZvdbzJGwrpEnCHSEOw1P9rHYH5MzMZqdCpaLnFwkn9CX2GxJ925gF3raiMEDO9DlqiYbPe5+z70q3a2kkgzZ++j7miSiUnryd+q2+WWl9KgFjlGptEiVkCSQVl1K8ZkZXGHWscr33eLSV75yjbnekvNMeQPYArbqJZTf7n5VLAsAkB4K7jI2IBycXaKojXj4ZLHsl/76cKZZAvCq5RCp3vVTHK3LJffF8HuqUW7XWTHYKllRhP8r+6f//pmGuwR3lC7d+o7L3KIS64I27uHByICbjW97plLznkY7ZfBSiFCMI83DpXHh2BS64T4VBFSqdzbT1wb3woMHr0K48Fj/sbRXDq7kaBc+1Kimuy8ffEggC4XI9w142Co+FAdSfxcE6Jcg5YqAuIh3neOi6t+WUgiAqXDL1nh/+T8zGS2RWZ4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(8936002)(6486002)(508600001)(2906002)(86362001)(5660300002)(38100700002)(38350700002)(66946007)(186003)(44832011)(66476007)(4326008)(83380400001)(8676002)(66556008)(26005)(316002)(52116002)(54906003)(9686003)(6512007)(1076003)(110136005)(6506007)(6666004)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YD728q9xQnj1BSYs6ksK1x8Irmyp3+9iqHDcJYb76RXafXHMWIPqwd5lyNuh?=
 =?us-ascii?Q?zQ7ScwWahgMafmaKgODL5B5G/6CKi5vB3O4hoWY1bOKzz69GbGsNv2Qbffrp?=
 =?us-ascii?Q?uHRXOZPQ39pVjGWM8ZmfhpY+D5exBNhHGK8w23FHMp8yS9eyG359uUzwaP6f?=
 =?us-ascii?Q?d7hlmww0rlNgo2ktxfyjxF9zPmnOloqyBfkScZp6UsxTSBXFORz6NTpA/7xR?=
 =?us-ascii?Q?2TBcn3KrlYgl7rgXDKUci3n4v1NBMQJopAi/CzLv4LBzrndVYOb0IPlyA5UQ?=
 =?us-ascii?Q?sJ83cwM3UkpAOZZxjIsk6C+YtDQIh6axhgDkfq0PLkt4fE2Afs4Xpf6hfMo9?=
 =?us-ascii?Q?C+mGq+CazclpHJP9r+n/a1077l0kmaLSLwfwtJRKMkKnislpmAqRkyg7n3lZ?=
 =?us-ascii?Q?kZdRBsB1DiQ7tnlFg/NYQ2C5hFAJfGyjuPFuXT/94yN6HNFs/Y3zpdWVU7HV?=
 =?us-ascii?Q?tFCZLSKFOtYSFaIVDSXbGOZCFAEYdPE3OJaHjnkVkev4BHZSM4Tji5Gjp2W4?=
 =?us-ascii?Q?DQ8B2TxkPOglkzdgBQkt224tAAcFSYn3sdx2I+NU3bvviCukzvVu8FezJIu/?=
 =?us-ascii?Q?g7EbF7GfsFURiUizYEHaQ1BLyoNX12tUbZ11oQszQunjh7Lng5XT5M877IxG?=
 =?us-ascii?Q?S1ynfFydDnwKLBBUOErmmThui1WG/hx2IjQbCbOai4uW1TP5docwQvpbsccC?=
 =?us-ascii?Q?m5i1XtV4RbHyCIB/aX/Y5Zy4Sv3FQCkbmoNmK9O4YnR5jgFmlVrk/0SUzmc9?=
 =?us-ascii?Q?LsXEpTYsqk2QexbELuAv9Y4SkTiDI8nWgth+2GOqKkwy6XxVnSrW5rKY16eS?=
 =?us-ascii?Q?BPjiDvL0TJ4acwPXhmaNNwY/wYzwldluVt6KrgQPBRV4D7XXvtyQ4aaFaxEO?=
 =?us-ascii?Q?BMmu/d3ckUsRdmmRY14J9KKuG7Grr6S3UohxWAqkpXNnf+DxLuX8vT9APAw9?=
 =?us-ascii?Q?5i86U7/pgiud0cnOWoIoumn9epQ9BfqJwxItDAHT1v8JSOgXZAtM3z5+nVin?=
 =?us-ascii?Q?9KXuRTaDsnZp5KigR7/EmW9z/ydy0QDyQvA9SFh499L9tzngn9UWGPz/xJmz?=
 =?us-ascii?Q?sayuA+WV5JYZWnTwL44nud1oa3GOGsl7Gwwn87Yuq2mgFOUpq6n8nrxDEeHF?=
 =?us-ascii?Q?Nre5VlHCMfPQQdQRhc9i1KqqMTLL1cXHplXOtuZMBIqTv4D6loGYtDFAhq+n?=
 =?us-ascii?Q?UCed1zB+lsvH0CORu1MUc9YmDEHtxUEp5JQJnziFIjc+QsNmbuq6CvbxwJUi?=
 =?us-ascii?Q?8dKwNdInppg3q0GO4IhzycFXKqbrhxuJVyW4VERXKEXsd3W75sZaY5HC/WHX?=
 =?us-ascii?Q?i9DyEPVa1VsLyCbmnIB8OudAS8vNyz+nD30gh9LfSfV4H3SFEnyFNYNqy8Sk?=
 =?us-ascii?Q?59iw72O5uGahu6TKsubGS1oFAf2IjRLVoYHAZUGbOyVD1+pjUkzFhYqe3Wff?=
 =?us-ascii?Q?a2DvLiNjChhnaOIbBtYTrf1oE+9+guv7KAXAWi9nvD3UjF0Pg9u3EUzWPshX?=
 =?us-ascii?Q?FzHGsLkZf5ivpYBeAXFdS/0Rg8isDNhgsNYFQ0qyaKEpt7qMtGWDeRpEd8iJ?=
 =?us-ascii?Q?qNtkqJHViN7RJeVtBEOZLrZDRqN7ouZsAf0rH7pXkf7Qf9RUDNcCEUYPcSTH?=
 =?us-ascii?Q?BIJTgwPuFMT1qPm+X0p7zZ6bo8ABq2OqWyp6KSBHvLYFMs7uWKdpuqBAw3ty?=
 =?us-ascii?Q?Rfe1YA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abdfe054-9054-4c75-05d4-08d9fa8ed86a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 07:49:27.5731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylcHyKvZ6RL2UCpuqHArkJJ/P61Dc7xhiOnj/M7PCkfS1BmMaveqsP5R3VgV8fvIr3v+5NLIiIxW1vaZbs4dnG6xUuxW82qmUoiGx90r4ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2429
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280044
X-Proofpoint-GUID: 3TvLQpB5St7OekXPoagaENoDAGHItcRL
X-Proofpoint-ORIG-GUID: 3TvLQpB5St7OekXPoagaENoDAGHItcRL
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Unlock before returning if these allocations fail.

Fixes: 4363f3d3ce8f ("crypto: octeontx2 - add synchronization between mailbox accesses")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 3 ++-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 17a9dd20c8c3..15a9cff4beba 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -144,7 +144,7 @@ static void cptpf_flr_wq_handler(struct work_struct *work)
 	req = otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
 				      sizeof(struct msg_rsp));
 	if (!req)
-		return;
+		goto out_unlock;
 
 	req->sig = OTX2_MBOX_REQ_SIG;
 	req->id = MBOX_MSG_VF_FLR;
@@ -164,6 +164,7 @@ static void cptpf_flr_wq_handler(struct work_struct *work)
 		otx2_cpt_write64(pf->reg_base, BLKADDR_RVUM, 0,
 				 RVU_PF_VFFLR_INT_ENA_W1SX(reg), BIT_ULL(vf));
 	}
+out_unlock:
 	mutex_unlock(&pf->lock);
 }
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index fee758b86d29..dee0aa60b698 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -20,8 +20,10 @@ static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 
 	mutex_lock(&cptpf->lock);
 	msg = otx2_mbox_alloc_msg(&cptpf->afpf_mbox, 0, size);
-	if (msg == NULL)
+	if (msg == NULL) {
+		mutex_unlock(&cptpf->lock);
 		return -ENOMEM;
+	}
 
 	memcpy((uint8_t *)msg + sizeof(struct mbox_msghdr),
 	       (uint8_t *)req + sizeof(struct mbox_msghdr), size);
-- 
2.20.1
