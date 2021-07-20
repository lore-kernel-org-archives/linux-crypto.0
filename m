Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD7BC6377E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 15:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125F76124B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 15:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhGTPDx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:03:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48472 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240289AbhGTOZI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 10:25:08 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16KF2Ajn013562;
        Tue, 20 Jul 2021 15:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=XHmxsUl9g+d7dhLrYyAFS4aNyiQgF+jZz2NOvT7dDs4=;
 b=bvyyLFfNGsKod+QzS/Pg4c91w+wd+wbfH+kQLt6kLOehxXUjUiAkfnyVgE3DncH4Az+K
 ToayeLU9LcjYV57xe33RrwtsNWxJ+RnzjdYKTNwE4KuSlIeH0vcE/cq37LrtQh1E/rFQ
 rUzH1RtVVp/VGG9zB8+Lk7lYO/kG7r5wPqXmtoeagoz/Bo6cqRhOYNWpKsqpJjQB9s87
 j5OBE7KtKj6ILxktyma/luJJMkzLUaPqHeofEEvs0k4Cotij/T/59g+SuD6T+5O9IABF
 CGorXauKR8IT3eO+R1WoF3ErZuRBtWdgWwLLnaJnDX9e7AWrV/MNcG87aQ+XyBZhm9Uv hQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=XHmxsUl9g+d7dhLrYyAFS4aNyiQgF+jZz2NOvT7dDs4=;
 b=PVfKLftiUU4dUdoEAGSlzdi7zftSWHbleiqSN3sk/KYKWxiEfitbKGcKg+F+0smSobTh
 ZzpUyFnMxnwzlNgpJPQIxUNmhQh6VHPJP7FLpdg36O1FHokjrguyR9OdvUlIRLZE3zxl
 aWai/4MpiJZi1DS4FvoNwRDA4VHVLlt+/vCg7Csgdj2sDflZINtjWx3CZHG3mdusMcDQ
 dNGBJbQQ4E+vWuqonfWv+XdfHbDRlS7eemc1sGHUcZPiiUvCDmgulcGef9cHkBNcwSI1
 b55LtiEJ/ebtcCzA4PWWmn2E+dReg0/dQOzB9yT3y0bMBcAXTpZqtWXLXCW9i2O7aoE0 wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w9hftyf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 15:05:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16KEtKSE001151;
        Tue, 20 Jul 2021 15:05:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 39wunhudv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 15:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcY1v33n8FeOFd5UQqgDGQkkLSMI5K3B1aRvJf1c4sw6C40aCEMhgfePKHsjviTX0eK3/IiC7cuJHYro5YBCvDpumo1snPUNhHU0XajiMrjDXQoPWvxW5Q/SHviHiISy6jbuhiyrQfrtL+3Bc4HjjInZaOvxTumKenoFT1dkSSDyGyr7gs5TB4GmMnHLwf5HUfelGyPjsGETglXJ94piVT5S95SbZfocgDqq1mx/0TNqY0275GXMHHVjrSHau7EQXzqgkAoHz96Y126akElLEh6s1HG2Vj4I/E7xyHF1DBq8g5ZkdBjQA/3pS3Us0/7urgHFNLPCg7u8g0gbppi6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHmxsUl9g+d7dhLrYyAFS4aNyiQgF+jZz2NOvT7dDs4=;
 b=R/diZlQ9+wKU3NZAIwbfd+dnxdviaNpG4+3yvFKw9Bp4yfLAI8LzppmM4r9e8MQNVTs+SpsHCa4xZeA63nlRdgUNKdW2j2CT6a8rLHhhgqbtZvKtUQC8cWUVJq+FDVU+0r5xlaGwP7TARv8pUgpIgiu8VxjFtYYHYJkPdUqVZRkLO9PuYJNWCZLbycoPVcqRk+kmBjeMppBee1/HCguAN9URG+H+eL3sZ5yFIQ1Y5/ZNAB04rP8rEu29OW6rN5MLBovui+Y54NcWaQU9qyBvZ+5SsES4Hc2erQMHwY7OJAWLpDuIwZeg2cKeUQ2AX+TfWciHixkAzTt961s4BNSs0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHmxsUl9g+d7dhLrYyAFS4aNyiQgF+jZz2NOvT7dDs4=;
 b=mCTMWSjn8CAoRaPQuytzo9Ve4B32MpwY6vLIPpG0GH4aZBOC/1Myfn0AklqEnpm2BwmL/MFLrbLmrSk7r+YcNBSpO9l1SPS4eLLoLEFzQZZJCAWTYMCHnP0CeIeq2NUyEOwXxIIyn2KPo8VVwWccGJfl7NOR3BMwsIv34vMpyTI=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Tue, 20 Jul
 2021 15:05:25 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::9478:368e:93b4:6b48]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::9478:368e:93b4:6b48%4]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 15:05:25 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>, yuanxzhang@fudan.edu.cn,
        Xin Tan <tanxin.ctf@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] padata: Convert from atomic_t to refcount_t on parallel_data->refcnt
Date:   Tue, 20 Jul 2021 11:05:11 -0400
Message-Id: <20210720150511.877668-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719214649.w65ifdp2hriryrsc@oracle.com>
References: <20210719214649.w65ifdp2hriryrsc@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0403.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::18) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0403.namprd13.prod.outlook.com (2603:10b6:208:2c2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11 via Frontend Transport; Tue, 20 Jul 2021 15:05:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f77071e-77af-46fa-0e4f-08d94b8fcd66
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46535EEC477AAF5EEF5F6906D9E29@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BVk6xCMa3WUOOIXDelPIMad+N224aKM1HJq6RMaZBV2zlD81C0eB+uTtIy+KOIELMTkae7xoNkk9RwJRTdboOUKqa1qaz+l9Nd2XexhqZsSF1Lr0RGSWa9o37lca5cGhJ5JF+GmHhPxIR+Eqjg7h6z8yNCXcS4NsD+/Ip+/nD11IR/Hi83sE0JQnuGAGxF8xPlEZ/+0XaYeh1cCv/pj2khelVbhLYI5LJKeOyPla6InLMc4dpJWymJDSZH1hgHfEJSdBQO30oX/xVHbg6SPgeT/BvTVMrylaORKOy6NG72bx/CkEt/B4MUZEUZvJ4uw4SuJfSPUYFdT6Ivucv1lYKji68Bt0IqVA2J0YZHWPc7Es0lRlflAEzgiNbI1439La+2uJK8dbkrljKMut9eXfgkEzFivBJxhK2opU7pSt4OsIpm8TjbfA/iHkC9EFImTUJOjBGcbBueS4jy5MjHqNlsxDOhO0htA2rC35+cpHxNKJKeyk49RShO89j2f6zGADMlnxD/gLxRERWu5D8EVVW/oHxR1qv1J2H+Mrac752PO63iXUN4P6L/GFq1MvuBtl6dC8+BEZg0bOY63/FmRd1YG7xKhyuFKQKsqhK6rUsxHv69J9jguacUBLjo/htJJDy5MPoqi9SjO9kGqftulmBtdq7fkbbxO58KFNWuXtVpUqa4emyOM9fJhGJxP2qAL438nYo3PGfK1q4YVpwqcKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(54906003)(52116002)(6506007)(186003)(2616005)(38350700002)(6512007)(1076003)(38100700002)(2906002)(110136005)(316002)(86362001)(66556008)(66946007)(66476007)(26005)(508600001)(5660300002)(8936002)(6666004)(8676002)(4326008)(83380400001)(36756003)(7049001)(956004)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WQhbIkW3qayHM0pxG3bly4vU2X7Bh8/Bu0TPjctKNf173mB4a0u5hDjXIw49?=
 =?us-ascii?Q?UfwUTkDuLxRrqPlaQgdIKQG/xUOKW4WGz+Ap05YzJfzBRQxAl2JMheiG8bWv?=
 =?us-ascii?Q?EwYo940PUGzGKTgUSo3C5xoQt/x7UpNaSM42ouHzhLal1QqeW4msyGjVtyKB?=
 =?us-ascii?Q?BH5IX2VUwhMyVx3Z28QlMIej4KViNmJerxcTOaYo+lbi4cL0X+xR4XGNu8Ro?=
 =?us-ascii?Q?31ceQSIAPOqzAHDGQDkJd80LkbZI7wc0QSaFmBp944qWFoLCRX1PcVveWvIp?=
 =?us-ascii?Q?pdBPn2aPdUyxEF49H8+DzqaCzY812dVYudpXfOpOjZvXxiEXjcYVN2kZ1lTp?=
 =?us-ascii?Q?E/GvAkGCmFNCwU7T1qXTX/RAVY0IIWMOgE8M47yQdYZwgUxq9mu3pgC8Dqif?=
 =?us-ascii?Q?xnRUid8zRX4gek1UoJDVMGdUVfTOYv6hCwrCdK27437Iv/Z61hla1D7Qyght?=
 =?us-ascii?Q?inyy0PHg0nq8b4ZNnRammi8L6SmnJr78UFIPvgaaW/6PprEt9uswHm3nwOI6?=
 =?us-ascii?Q?5AAII6/Z1fAO68OwTdZK3l7bexpO5X7RNT0sUioiJ1bvN6UyotLXpoF9OfE8?=
 =?us-ascii?Q?nS5Q2lICvzzElQf7ZwKCsGivvIWxAIAT/0BI6UeRDAdCa6dtDKUBcm+lwN7f?=
 =?us-ascii?Q?Dg+jZ+hzU7ZFE3hDUVTy+yukgp7Ympq5Q5vAFYeqs0THwtRb/UHwyykqojjK?=
 =?us-ascii?Q?QESb63lqArB1baTBEfCp/I8Loev/VN7fdgRi6j/t9CVoBIgaAtli1vA3hGrA?=
 =?us-ascii?Q?DuVh+DSRfx9X9YPGfTTJOKudJIbMk8BDnBRON6Fc3K5fKJfQ3hjYepuCGAJP?=
 =?us-ascii?Q?/AQREmtxGH8TZ/0zzTGfYGI3PH7+FruZk5oRE/pwi8vcvjGXsBglxEtnm2Sq?=
 =?us-ascii?Q?Hf/4n6DevWUj5RW9zEciiwlz2VLcHt8crnPbovThmWxEAUFvx3vNbsLfNe71?=
 =?us-ascii?Q?OOAEihyb0VmkaEubS5p7AdzTWa2D7dAWOCtebhSGo1oOJwKDwt3057aQhkDV?=
 =?us-ascii?Q?jDVHub0Js383xCNrLh7kZ6JjEZU7143n9XuiwvK2XOrrHWpb/vWzoPHoauLt?=
 =?us-ascii?Q?9SN9odR9LkhJFWu8N06aVW2PeAxlaLyJr0hxyI/pvj40SO+gRL2oTILbMO0J?=
 =?us-ascii?Q?rmDbD61sKfoJh3QbWPLSZ9c6ICo55mE/2LOd9mbqxgNeH5COLMaQymsNWUvC?=
 =?us-ascii?Q?arERPlpRw5I6/ZMByrh+CbY/oH6kxc14YuP+KHrkyL1MRAX3CO3k96utwyWx?=
 =?us-ascii?Q?eOD86c4TXZ3Y69PwjGO+M4f2cscpfv+sg71B2ztxiZeAkQkIgD+IBg8hyu6U?=
 =?us-ascii?Q?gbqNuHrmb0w94R5G41XscF/F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f77071e-77af-46fa-0e4f-08d94b8fcd66
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 15:05:24.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlN9UAfEZDAsiUMnGuIZ0x/vaN2OUEYZQ9kPzy4I9tL6ldcjtZjvilXlbuETbAJWj6jByWzOMPLsNtqyBDsnWSirjmldUM6bFcqTy5XlPXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200094
X-Proofpoint-GUID: S65owtAH7k3jY1Js-usTE2VOSZusxDef
X-Proofpoint-ORIG-GUID: S65owtAH7k3jY1Js-usTE2VOSZusxDef
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

This seems not to have made it to the lists even though they were
originally cc'd.  Reposting.

 include/linux/padata.h | 3 ++-
 kernel/padata.c        | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index a433f13fc4bf..495b16b6b4d7 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -12,6 +12,7 @@
 #ifndef PADATA_H
 #define PADATA_H
 
+#include <linux/refcount.h>
 #include <linux/compiler_types.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
@@ -96,7 +97,7 @@ struct parallel_data {
 	struct padata_shell		*ps;
 	struct padata_list		__percpu *reorder_list;
 	struct padata_serial_queue	__percpu *squeue;
-	atomic_t			refcnt;
+	refcount_t			refcnt;
 	unsigned int			seq_nr;
 	unsigned int			processed;
 	int				cpu;
diff --git a/kernel/padata.c b/kernel/padata.c
index d4d3ba6e1728..378c36080781 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -211,7 +211,7 @@ int padata_do_parallel(struct padata_shell *ps,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	atomic_inc(&pd->refcnt);
+	refcount_inc(&pd->refcnt);
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
@@ -383,7 +383,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	}
 	local_bh_enable();
 
-	if (atomic_sub_and_test(cnt, &pd->refcnt))
+	if (refcount_sub_and_test(cnt, &pd->refcnt))
 		padata_free_pd(pd);
 }
 
@@ -593,7 +593,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	padata_init_reorder_list(pd);
 	padata_init_squeues(pd);
 	pd->seq_nr = -1;
-	atomic_set(&pd->refcnt, 1);
+	refcount_set(&pd->refcnt, 1);
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
@@ -667,7 +667,7 @@ static int padata_replace(struct padata_instance *pinst)
 	synchronize_rcu();
 
 	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		if (atomic_dec_and_test(&ps->opd->refcnt))
+		if (refcount_dec_and_test(&ps->opd->refcnt))
 			padata_free_pd(ps->opd);
 
 	pinst->flags &= ~PADATA_RESET;
-- 
2.32.0

