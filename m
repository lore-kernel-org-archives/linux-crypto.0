Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23463C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 07:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhLQHS4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 02:18:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44960 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhLQHS4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 02:18:56 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2X43K004122;
        Fri, 17 Dec 2021 07:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=hMDOrY6ttr+jr78eFzgLgDgzkaSmCJkE9+Zy7qGpeqw=;
 b=qJTbyToO8fP1T7syWfiSFuGOuXFGUWP3gi7y7pV+vDYVDjYCqaHmVgc+OzwfE8Qf6JCp
 eTFvjL7zjqBoHcmk6amA44FlSpPcoj0QFpgrDIPg8AdSoOBuZMZ+2qEXQIxiU9IZIZ8n
 N9eUxgxGqLLny/jOVjiluH+xWPdE8UTpAWZp3URqTLcqoYDaJml9/lCy6vqUuFjHo7sP
 67NWfFtvwoBpoGItDGKu7L21rXfftDv7XwSxd+/1rKx16c4YfvX6YIBGKggMfXX6b5Ln
 cpGYCyerXtT8i6s4owH/XyOjqEB87bLfEHIzyuffVqLEWrzMhxqA7HXf8wEMhemGOqRX rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykmcmv74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:13:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH7AD39090985;
        Fri, 17 Dec 2021 07:13:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3cyjub38xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:13:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNAbPhD41bwmiHczKEquazeEz6YJqcPmuNZG31gonI2I9jEnOq4uV3YTDS7yqVtdk4BFrfOgQRB1QjSeO7inBW4w23TIfBbzOSYri4uMqSxNx1qCh402YUgobFG1u8q3ERc6ZwxWBzin0gSRv+70SaSphK9RB3k5y8Dt7UYyGHoN2PL7iXgFrKF7p8HaaRsss1llumPA5srRPu8ivE3YsGO3CATkeOxs/hZfTVFGV7TabzzBJTr2YS8Nwzhpr4/4e2HqWDObp4CEOEn891BKJ46fleSDvS5xi5sdXawf1Bzh+KBsui6xbrN7x3WGenJNSdkhpG3N1aDpXHvXPhp5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMDOrY6ttr+jr78eFzgLgDgzkaSmCJkE9+Zy7qGpeqw=;
 b=gYnaqKMkyOzs++RzmIjeknht+Ko3twT/WAWOk3GUCLV/j3JQPqI3XctvJiwYBMb1sPN5orxS9D9kNz7no+/wC2s+GAfVWtWjHfukGhUU59ujnXSQvD81wGF8HWBUcky4Q68IYHYjRwl7Tj1yko8gT6iy8rHWXPtlm57kJy3HoDl3sV6kujVOxNMZXn8cg+PzSv6IfMS8hJY++4JxqNo1uWE0Cbs6Os49KX1xzRSQUyPrYEv5bA5u5snpwFUvSUFWoJmbOKlJBn2MCYtiCNr01drQCcgG4KYFd56RaKlAiJhCM2iLD9lFqQjsj6NQmDXeSXnmt4eZVCBq47OGw3Oazw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMDOrY6ttr+jr78eFzgLgDgzkaSmCJkE9+Zy7qGpeqw=;
 b=FKjr28KUGnQP4dZ6zJX68ZjlgS+jh7C5Waz/dgIf1ttO3FlszPIwiXPxfv5WYbtSn+iYJegQhr437/tXWRln9Yonvs3Ki3xP5Tage7XEaTLwUsB9JCIVYVrJui3HgdtROszwT6b2Lyc68qhed33OMg5zrPgAvd8xxaOdBmEO+NE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5863.namprd10.prod.outlook.com
 (2603:10b6:303:18e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 17 Dec
 2021 07:13:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.016; Fri, 17 Dec 2021
 07:13:44 +0000
Date:   Fri, 17 Dec 2021 10:13:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Suheil Chandran <schandran@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] crypto: octeontx2 - prevent underflow in get_cores_bmap()
Message-ID: <20211217071332.GH26548@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217071232.GG26548@kili>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0057.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 147b8fa3-2fbe-48ec-8f0d-08d9c12cc32d
X-MS-TrafficTypeDiagnostic: MW4PR10MB5863:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5863F7CCAF409E213EF7F35C8E789@MW4PR10MB5863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGe7Ya4zIFR7I9AHqFc7ZuYhK5bnCj34QucwtsSQezMsSYaUPST3eoCSQD/kVBYQXsYslHsksiYWKnCvqsmqF/w3Q9Atr5q9bgW2Ahz8Px+leW40wUBJVH2pVt/OowH9ArkQpeJLiqvKEe1HqU8eAre417MP4j6VytbE5n0/ZwGvbIq82Sel6tweOxEx2Z8ACQYobZ3igUzJYCQogVQTXi9OJck8z+7Y91RUGpWLZ9vP7OTQbATm+iLa1S+mS+k51RzIdmhJxDuFAsa2zxv6KU3aXpafWWzQFNLsGkJ3zsBk+G0qrXIVxUYfGFYfTkzL4X1/DihKNMQ92H7u06JCO//bRbbvcbYrHf2juyvViAKshu3D7yVV29HAlcSGiEXwgJCJPRmu1kPDKbZwRniPirL6I0d0aIo5ajsPCSYfKweL/X88g5o58Ike8Ez2FF8qVK8ShikIlqz5vZVMEscBfv22ddeINpCV4Tqx8Y9WSsnQbfZNyIQ7EAVFDMnlKV7WYNfPvELUSpAgSYb0Hk2lpOxo0GMYsaAKil/psfRtd1lWplUE0SnuXtPRb6tFPay2u4NCVLV5esyGdWhc8mzwy4JvvPuR+9DbecjBcetVP8sQllBTXFPb1+4r78Cc43qJOPoi/3m+CsYmtX++Lw01XzRe+awTbiXIhrvUdOFABGMCr/XbZXtGXh8TIr12Y2cOye0zb8Kppxhxs8cnt7Q9Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(33656002)(6506007)(186003)(6486002)(86362001)(66556008)(83380400001)(6512007)(316002)(4744005)(66946007)(5660300002)(54906003)(66476007)(8676002)(33716001)(9686003)(44832011)(38350700002)(6666004)(2906002)(1076003)(110136005)(38100700002)(26005)(508600001)(4326008)(52116002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ym7JiW9zd4P0d2U1rqZTi6UY95Ufpx8x7izI+zryoxJ2pWuBO0NE0tWCojsd?=
 =?us-ascii?Q?N8UGCxvQFHTD+m6hf8lm1yu0i2cFZXYizaFkXzbl0tJHtcoVTXMqakWhITFa?=
 =?us-ascii?Q?bRjl9oimmuYGC+Ts3wp/20IE0dBI5ZzNbVHKUwCsD+3iktAycaTc26AzCIzk?=
 =?us-ascii?Q?iPGqVdofYdA+kxK1ypmztCO0qgIjUcG5wRsRvX1WklYy2+iTS9QOI6Zivudj?=
 =?us-ascii?Q?7t5JarzfxWiscyR107n9FSzRGxA485KzgFfAXmZslNJpXNAg94ljMwcHEISW?=
 =?us-ascii?Q?l1TR5Qh14dQLQwDWV5EoW2tjKd0L4roydQ84W5h+ltuR4meXm/t07U/dyZEx?=
 =?us-ascii?Q?G6bUK56/H/mURYH3GuHoMEsAIUfi4SIG1oLJZnbyG1JJTiDGAh5NQnGZbcMw?=
 =?us-ascii?Q?EBVmHLTpO6rPBXUK5/mzF9HcUPdNfS8Oohb0zct12li2gFV6GuORt2+8RV3V?=
 =?us-ascii?Q?sQIRxYS8vGUbovDwX+//nB9762fNdnljPGwi72ENDNX/YSjBQeS6Qqua2z7T?=
 =?us-ascii?Q?ZXNNbo0TTsn0WqZS8HjtsVjx/z7BmCR6ONdhWSihQrRT/J5+mbMtxhkNHs+4?=
 =?us-ascii?Q?DQuwLGM4rliAJK9SYJWBrpg414amhS44b1dBbhHqKA/Mu2D45CwjrFXdAzke?=
 =?us-ascii?Q?7dqds77CP0cQVXA6ntlkxeec9Zwkze0m3GVlPvU73fMmZY6POzXycGKVkpSK?=
 =?us-ascii?Q?9Idud9keu11WWDFuoaJ6IMl9zgjLyDxFPzD2LjWArtCDL5xDYAwjNaoTF96a?=
 =?us-ascii?Q?hmBx4jdWDQDzn1xbnULl3FM4A82K3lkX478B/KAFhRGS7w2kIpTdbhT14YFt?=
 =?us-ascii?Q?7XvkKQJ9n9wDj5YiVc7S6do9urUP4v80kVaPxBmxdQFmJOquaFXevgUVDUNL?=
 =?us-ascii?Q?bwy2PVYEoYTS8IJLQNIb2Ty2fxd/bwO+xquxfhZikWP16kE+Jrve7DU3X103?=
 =?us-ascii?Q?gIH2fZuaxFKPvHCvQN5JQnoaWg2ZIqk7MAA22Tx73W1CpMIWCNR/U3rDwahU?=
 =?us-ascii?Q?LBI7P8oPvdJXs0rzEX24N2QRMbvCwp2Vwza/UYUBX+ApOCCDeJ6QoLyoAXjL?=
 =?us-ascii?Q?9dpwdiPE37fSjJHh5BiV+EpLOzsPQlhtf4WuCFiHVUW/vn3mql+D6Kpf/vmH?=
 =?us-ascii?Q?g/d+/BGiL4C6pP4XCWZn1a2egaiHrDgf6wFiulbwJfox/SjSnj1lh/CHE26f?=
 =?us-ascii?Q?Yw4iSxxpUlWgNBKpfBvEXaUrqPCj/T32NBmkNRaQjYzfZgkBG2K8PukjY9am?=
 =?us-ascii?Q?Y+1eci6iXzUZBO0qsiqFKfvMGjDJcA8PLlNHn2TXwQVGf3ZcaVx5rtl744fa?=
 =?us-ascii?Q?X5Yx0dHWFOGeYju3xpObo9aIvre8pwMskJlnRY6XCmK7bfYjjVkaclpUsfgp?=
 =?us-ascii?Q?srBj++zY3691w+QdlXIAx6rEDalelfjVBS9tUfCe0k/daZ0uCll/SVl+ViuL?=
 =?us-ascii?Q?grn0df3gOKfxgUnnKufYQsCw5smsuKj2MXPXsJLfLQxx8eluxTOuWFGBGDcA?=
 =?us-ascii?Q?4mLlBz0/Us7XrhlGFaTYxwWZDC+UGMgtjiQph1UPBiY7Ssgxm5YeLacHxjwH?=
 =?us-ascii?Q?qh/v/Uh32RKlHj0VVC4O5JXBVBIYhaaoZnoLnS3RbVHzNUguFZQ0zV6afdsk?=
 =?us-ascii?Q?9IBfTsPYlkTKoLxpgJLTq6BgPn2uGtnwlP8exZg1x58FZHUaE1+bdqAf5Bi6?=
 =?us-ascii?Q?UQ0kyE53cxXyjGf0yl7MPHrQkjM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147b8fa3-2fbe-48ec-8f0d-08d9c12cc32d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:13:44.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rDt8xBGax0Pa5AcwVby5aelISKr94CGH+iiWKwzFIuPE4pVQRX8Ftv8hqPQ+e40ZL6M+LiYE//ddmk2unvigwdPTGINP8XStrX7qBxbvBjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170040
X-Proofpoint-ORIG-GUID: cHsONfaSkOigltmVRLNNmzHKtqQpsMnj
X-Proofpoint-GUID: cHsONfaSkOigltmVRLNNmzHKtqQpsMnj
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If we're going to cap "eng_grp->g->engs_num" upper bounds then we should
cap the lower bounds as well.

Fixes: 43ac0b824f1c ("crypto: octeontx2 - load microcode and create engine groups")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 07f28d887c2c..392a78298398 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -29,7 +29,8 @@ static struct otx2_cpt_bitmap get_cores_bmap(struct device *dev,
 	bool found = false;
 	int i;
 
-	if (eng_grp->g->engs_num > OTX2_CPT_MAX_ENGINES) {
+	if (eng_grp->g->engs_num < 0 ||
+	    eng_grp->g->engs_num > OTX2_CPT_MAX_ENGINES) {
 		dev_err(dev, "unsupported number of engines %d on octeontx2\n",
 			eng_grp->g->engs_num);
 		return bmap;
-- 
2.20.1

