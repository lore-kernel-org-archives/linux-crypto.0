Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495E3C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Nov 2021 14:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhK0OQM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Nov 2021 09:16:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51398 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235734AbhK0OOM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Nov 2021 09:14:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AR8VETt003142;
        Sat, 27 Nov 2021 14:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=PWAP3zbq97CXj1b+aPIziA6CLMqQekXPJvF92lGCeu4=;
 b=fp8aqhr/CFqigPSXvL6bNXwLW15PrETr+p46s7fL2QPl4L3AggfioLZDgWP9bIvMwltE
 Ak/LWT/tPDkLpROm4HxxakJ/xmSogY0949+RXt7Z/Ewe1jjVsIz+4UqrvrtMLbY3e2eo
 ksU5BuISrtfTVcUFNLvC5sip8sbK/lOyzeMC09jryvkPgQ/pcxbUpNeKp7TJUYY7EMsX
 u5xZGJIHt1mbf4KEbb1ss2njwd9yYyHaWZnx3KxtuAZpdWMszUUy7knpAICcMByerSxr
 /0LFlddSgEsb09/WEjOAQ3EsCTQHSiJmmq25NXt1vTnEUzM8VLjE/HvoosvInHfbiATD IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ckcjb0xsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Nov 2021 14:10:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ARE5hAt001769;
        Sat, 27 Nov 2021 14:10:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3cke4had43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Nov 2021 14:10:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcXOB9On3VbiNSD9RAji5Lc9cbEUHX2J0B9orIAjGOGIRKcQ/HrropEKmcwk2VG4euF9Iy2Z24N5c4Zy+aJPKEuN6J/mNuhxmRsNnOcOO3OQ/UOjAQV/p496fWtw96avSTwOFWtAshFmodpX7l1DKQqYurKp07AcKfaqp/diKQeNGU8i53cevu4K+CdsoYn9j7T9S6YIv13NUAm2o1d1K0BXq3MGql3hiIqDG3pxTJTeU9eMKJhggQTzK1ypcAoUJHGMFkaeGaHUHeD479/oGDX5TfB7Sqh2s+36ZkIxAQcQ/oDo4p2KjTfamdNG7Pvalbw9GAQZT+NcJijzW7chgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWAP3zbq97CXj1b+aPIziA6CLMqQekXPJvF92lGCeu4=;
 b=A4HIEG2OAruA2ynhmMZ7ry3e4jhu/Ur/noaRWGTTzyUH8LO73GD9Da4U6D+QOJROvcebAht4KfRxyLU2ewJ1WJfGx6qc9OhXNv+QbIiJFQ2AgfF/VU2vBwcUkvDzn71Z23g6Vkz9hs2qm9ZEeHJpw9Q2cUErMcaQT4CTZavNaXuVHgzzA68oMDH6BrYMmOtftHYYHLyp7LcFzYXj0ATPxSRcV+xr5Dh+/BeEASjOOsUs5Tn/zllEieaNYRoRfdlvjRmoSQVLjveZnYO8ZjslGj6eCaiD3tf2FXQpkTPl1mwnIP10a53XkFFUUNIQ36wES6IqaJ/cP0A3Xfn/LDvIOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWAP3zbq97CXj1b+aPIziA6CLMqQekXPJvF92lGCeu4=;
 b=N/097muRp+qhoU7f6H7mrcjBUQ6V1Gnh+Zhw+dZLYPjGTOnmDnvb50/9EWUkOhCnTUKbld38/UxrHEzbk217ugnH0wXr/lQDRNg/YIkooOAdxWlV7xsG2J46UKU6nBDQpYyA2eT93KafTCo3zFGT4xZMFdSC7wpIK8NYsQ3zUu0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1824.namprd10.prod.outlook.com
 (2603:10b6:300:10a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 14:10:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 14:10:44 +0000
Date:   Sat, 27 Nov 2021 17:10:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - uninitialized variable in
 kvf_limits_store()
Message-ID: <20211127141027.GC24002@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0114.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0114.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Sat, 27 Nov 2021 14:10:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa153532-57c0-4134-e731-08d9b1afb395
X-MS-TrafficTypeDiagnostic: MWHPR10MB1824:
X-Microsoft-Antispam-PRVS: <MWHPR10MB18247F2406A2E97BE1AEB1A08E649@MWHPR10MB1824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1WkyF/mjE4/vxeblE0kmhlU7fuWUf38SDhdj7DaQMF0Wb0rZIY/0z7cQyf3UxufgMCn06bYZkrriVv00yqbQw6OoMDeFBPymrZ777XBtrOrHtrdYAg+LSZyl8WkjF0NMsTxf1iodugbqIB0s602dACuVT7xlS5fTQbPGIPjCmMcyDts7aK7HDzSyHrz9h7/VHp5HX/PQrg6VXbNaND3UFiJWUAEUNMgzTcKt2ayMsvF41ciUM9H19N9e9hYuu2AF37HAM1zHLKX/eLS1tyVtmM44BJ3xZzvtDq1Voj2J+cKBspPZzQ6sMqmFvFGl8jOBRUn5aQl+eWZEu+ruchBu+RyWxkZZgLXMQ1XXtBQngPh7uYbC1eBHtTcRlJpedzJYGVPPurExkxMFqhrJFlhIFLcZdnU0NXXb2DnZz/5jfxTalOwO5qL+PDRqIjPJg1XpmNbyhsrtgemozH+O0wWg6nhTpQnnmymysUBVIfghwAZv1HyGwU6rcvfufHkS6qqVW3BQeWo6HvlZhYgW1CZg3QWCGzCy4kXpYqxcWGRzFbp8vnKLPJLBUXcEF6BglzAu+8JG4ugJwLRBZxpXdsMS4IpzvGp7/9QzYm1O3M6vKwaX5uFK/5GHHc/7rJRoQBVV95nptqYuqxPZIqOeeLvbzMc6ZjGeA+2Q5bIcIeJsxuxEf0ZOcIRkCP5qeJNpHov9PluPMg27AW7cwd/7537vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(52116002)(38350700002)(38100700002)(33716001)(86362001)(2906002)(186003)(6496006)(54906003)(5660300002)(33656002)(508600001)(44832011)(9686003)(8676002)(9576002)(55016003)(110136005)(66946007)(26005)(1076003)(4326008)(6666004)(66556008)(83380400001)(316002)(66476007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+uMDtMIAQSwWe3Pk9so6fnJTUdtQHSI6q6SYQ7RfEnY50dQPFrj9XDz/oIMI?=
 =?us-ascii?Q?kwuYOJy0cQG6tpcaMjw4oQNwMQwWjmNK0ZyspultbsNlazLshfyAGqzVVT0g?=
 =?us-ascii?Q?hbqD8Ly18Bj+R40wzGvvM3Tahrik0tIr/PUx870oCb/UAtFmB+HpEFp4/yAd?=
 =?us-ascii?Q?WZtGbTUA7pk3rFWqFyLQ/TaoevvnAkCceyWUqS+PXBZ7QoUsTminR3zA3XYW?=
 =?us-ascii?Q?VhCpwdYGQY8cEbGG60MLJedhLBLSurHBnJ2fL8moD0ckqRoW6cgTB0GRitWo?=
 =?us-ascii?Q?FjpeXEUFzr+4szsEdjYMq8RHeyuyHZX7B3WinX8SCyLSxd2WXajH0ZHONZuG?=
 =?us-ascii?Q?KoWeIzA40IjV83O87LuEtO6oAs3SFdpElPZ8byL4knY56wCe/J7o5qNMAULF?=
 =?us-ascii?Q?wEqzMJnFHtebRhB6M2Sf5IHMn9OfhbrFDd5lXunmiDc7RMn2Ax5JScr5k1Qi?=
 =?us-ascii?Q?caSRXKNyt9Xh3BR4In+9kVZsBzNz1glUQNIyBVr05ddYI+RTE6ZbJV7XFe0R?=
 =?us-ascii?Q?BFvo9h0sAzRK5mLRzMqrtAPiRV6gHDNcxz2RQcvoir5XIfPYFfq9bjuqfhGr?=
 =?us-ascii?Q?7B0xS0JBhYXXs7uxVvHx3/zACWIyp4tlxruaIQKuSSeem+F038mae8fvjVkI?=
 =?us-ascii?Q?PCpXQ1JF/Nc8OkPzjPvYH5CjzHgQ0eZAM2tdwUO8t6HQA6U6G/K+TWwCmMwY?=
 =?us-ascii?Q?a1QUPDb83xlCCgaY/Xo08EtDFSFY2+zdg7uhNxar42gxfZWuJWedGBEgf/ZK?=
 =?us-ascii?Q?2KBxs3oAuSGOcA2UaWArdyh1jaykvSEWgl7XRwW/0kE7mq/xIjnxakDsepFZ?=
 =?us-ascii?Q?99LCERCL2x1KDcjDnJ+fsRa4DV6tVxpE+1558D4dP7ThjMzjdkwRtoulVraS?=
 =?us-ascii?Q?O5JXeQUe/JetSYSphlheaZPmv/2dTD+SOpR2FCid8kV9A/A/0Dt3p3ZU5mNO?=
 =?us-ascii?Q?1raLfhQ7qzb1rIyNkuHTnHtFo4YOYc48wssZy3XLbr0TiybQoDiDfLxFZg2e?=
 =?us-ascii?Q?e1geMOp0loPPReI5LxQx9rRp1iDwcby2bPJTnO+eTxYxH4ANJ4jGSAEF/lpD?=
 =?us-ascii?Q?kTOpcXTHdDfDuX7AbmfKOOxbvAG5sAAxWVscncSqimzlzqlL74nZiYCDsfXK?=
 =?us-ascii?Q?ooPEnUUQjW9lyQOVJRjXra2/SGGTfes/OFp3+K35irCMy9E0c1KZoUYbXsgW?=
 =?us-ascii?Q?Dd3Xh8NCWkhep8fWeToi50DC3QrffIZ8jE9m9ynghzBqHFJEdwh+roTtgtwB?=
 =?us-ascii?Q?5em5KCg5w8qWaewS4rmj/uZIglKseceK6i+FbbMRIc6CpD6FPnXa2Tg8VPdn?=
 =?us-ascii?Q?cj93mDGgzbRyq/gTF+Kf9+hMAmOOy8/Jd050xSWgzB1yS1hze445gOoNOBvH?=
 =?us-ascii?Q?QV1mA+mCEjTOQvyEQTl5H5kIjhBszho/XmcXS7pU5rpz8vHOZKazPrF1GLkJ?=
 =?us-ascii?Q?8eYQ+4fG442joGJG6Z4/r8aUoJArERceC9nqPbD34nAhPG/DPtoSZ7BM41ns?=
 =?us-ascii?Q?FWqO6HWnxVuFta28blgJRAmTsHyhktYD4yVsXQX8simwR+5TTJByung0IqNJ?=
 =?us-ascii?Q?6uFuRuwCd5PG19dhpBrmc31wTx28RzVLiYoK7PEhyF5gw3fjLWe4fwl1QBGK?=
 =?us-ascii?Q?ndymm/f/3KADktaDmG6WqMMZPgPOa8o4jGiAkLRaSygsdnciQ+7MQ0zBXNZT?=
 =?us-ascii?Q?2bf0G/nxvEMzYzzzzagtf/gDPyw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa153532-57c0-4134-e731-08d9b1afb395
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2021 14:10:44.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBQu9VplPCn4PJlyH0mUZBZX5VOYQxaYAM98jCS1UbEo4uhdHF1E7++vtLiky4suucb93bUexOIDu9+FbNErOOKrZGa6GolbEqCc0UgLDf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1824
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10180 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111270084
X-Proofpoint-GUID: 7F2dVcT0khVRSV46sy2cxW3daRPwdGc6
X-Proofpoint-ORIG-GUID: 7F2dVcT0khVRSV46sy2cxW3daRPwdGc6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If kstrtoint() fails then "lfs_num" is uninitialized and the warning
doesn't make any sense.  Just delete it.

Fixes: 8ec8015a3168 ("crypto: octeontx2 - add support to process the crypto request")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 146a55ac4b9b..be1ad55a208f 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -494,12 +494,11 @@ static ssize_t kvf_limits_store(struct device *dev,
 {
 	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
 	int lfs_num;
+	int ret;
 
-	if (kstrtoint(buf, 0, &lfs_num)) {
-		dev_err(dev, "lfs count %d must be in range [1 - %d]\n",
-			lfs_num, num_online_cpus());
-		return -EINVAL;
-	}
+	ret = kstrtoint(buf, 0, &lfs_num);
+	if (ret)
+		return ret;
 	if (lfs_num < 1 || lfs_num > num_online_cpus()) {
 		dev_err(dev, "lfs count %d must be in range [1 - %d]\n",
 			lfs_num, num_online_cpus());
-- 
2.20.1

