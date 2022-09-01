Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673D4ECAAD1
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 15:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiIAPdT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 11:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiIAPdR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 11:33:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676492CDD3;
        Thu,  1 Sep 2022 08:33:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281FIngP018666;
        Thu, 1 Sep 2022 15:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=OPIz0G4sx+xlVLLqHia0MBAIXNW+hNHZk/P3N99MGOQ=;
 b=sci5cgB7wIMPHCgtU/+YEmlIyLL+DfAzJB03wL3Dd/fEKoIF1v3v3rPlL0mD6LVJeLMK
 SB8Tig15IcFRvx7N7joqMMhZ7TnX8a588wnh8g/yWiQAwOHU6q1XMELzQraEJa5ji/Pk
 kcA7zveKsBLE1m+3W0N5nQBHwGxwPrgSVkW8kMGaPCnwvvghDHx0VQfPJ+Q0PE8070PE
 CSttfZpBmou3w4prn5Mbz50v07AI+UbQHJl+4RQwlsUjSBm1InpKF6qQzFkYweShxruH
 lL/QT/YHjjpoYlNjsizgXzu6KR0UaARuuckO7/oc5zp/Wj6Jiry27+f3AGkijUZDRUFC DA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsmmqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 15:33:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 281E1Sph009142;
        Thu, 1 Sep 2022 15:33:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q6bpq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 15:33:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmRfYIBwPIN6njKkPvyJCSB7DOPXIZeIqEL42CWxhPk6GTh3gFnRRGUsPGNQdrVvfthpM3W7TovIGEqtp4j+09p3SbYltnWMgoJfuDf9UZ8XL0PcLoZv0cSEPaMKrrYLABgnvEL3zIVdwQ4APgNmkpXvTR+LCRTQGKWrSi6tGHeNawF++1DnRZaKsMVAmKNdCfM+DWiljRPrLIEGTV/nF9LBw5KX+fQxN1mQ9iEZdL5TRJDd9dphmTuqFjvrOm0qVUIAKPGHRCFhlzU3ldgT27hHm2d9Q1SMcHnkK9k5mazchbES971GO4b1CtJOiaUcpWN92y6rMbLhraCypiECTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPIz0G4sx+xlVLLqHia0MBAIXNW+hNHZk/P3N99MGOQ=;
 b=E25SF8c5tCGXLmIXHBUbx+WenHOSo0vS5wwiGMewzuuUV6OVCqDGLewIbjfMcddjqB1PUDcAf5xymVaMN18uzvgebfe9m4b+gRF98w9lpSSQ8ftZmBxj2zWjvGHvlHLe4KjFHq1BntC9L2CyVt3ADRyy0Xp4AOFDmwq4LTITWbtg8oESt5p3P7R8qB6XIXkPCfJ2ykK7YFu4z8C/LewMKq6mRp9/0n9ttbI52eJZyHmX1rfEKAQ9AMUYbdQ6TOGkhF5ue+2WVzxefkqfUcd0BNeSchU40MPFqX3g4cgjMm0iTJ4ylW3elRLGbpO0SclPpNotBzCSEafacyhORlcv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPIz0G4sx+xlVLLqHia0MBAIXNW+hNHZk/P3N99MGOQ=;
 b=T9O6+8mVUHUcFakFBq6hs9Mo4vf47ZH+SqTRrVzXy2QzE2Kc/ATNywHi6zTDAA/Y8ZuWBH+0tQAUIr3l3hOqSZQrvFAxZmzCZpLIUELBNKDJ5slrKLMEr5EL79Kd6PWyDltUxTD4BvkMr2OJ/GMb1vQczPNB5/bqvWyIl3kEIlE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB4144.namprd10.prod.outlook.com
 (2603:10b6:208:1d6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 15:33:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 15:33:04 +0000
Date:   Thu, 1 Sep 2022 18:32:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     George Cherian <gcherian@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: cavium - prevent integer overflow loading firmware
Message-ID: <YxDQpc9IINUuUhQr@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6202e45-2fa5-4294-5cdb-08da8c2f42d7
X-MS-TrafficTypeDiagnostic: MN2PR10MB4144:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BA/9vtL7wAYQqzcFzHeLPczMl6TfOy1GcMv/hxWT2UIbvkteNICLW/LWAcaUZHzotlPE94Ri5BNlMB6/74RIKxyaZuhJlm++QY9NUraPHeaI1DHidOvQ2lTcDeTGi70Nd2D6eRcsqVQwd1/2Dh2gCv+9Z9NzxMObd9mEdWz9BUoWrcjqB/wc16Fq1Om5hn0QlcXp3ZGsm+tgucmzZoNBnT5SyjwLnpX8PGlViNCFhuwp9igdYvtoMWBsJt0iYMoUxudaIzKLDFYMx+DnJvNKp7Er5ceLMMPCwgvdXMHYgKYvJ9v/v+Ub+6SSJhmmjZhXOkrvUKM8d5X0lAhGfJa8kg2JDbE4VlYwGUBbR6VZE/oS+iRHGILhxG5fBgWNpeVdb8DfCwJPm7wwWSozrTniyP59EmZVPKpHemrH/xz/Q9SeB3l5i0OEEa1cO9pqI9G0l/edXK6R0zchsRdBItUBl2Zh7Gkcr51ZIIE1Lqa6seaUhFfBZfOTm1IKf+pDufa+Ym2G263Y9aF4tHC0buubrLjdY9ACaIwUqdDYVhO+5rRoFpvKGktWXZxii9N2USZ9jPniDgDdXY32yIQxtBRTugW3vrbWeO7rPHYfQdvOUFg4P4Yp5Wo2avR3tq6LlsRVoLIrrhsnvy3/O3EAoGy1KiM6QwC/ExlPdsEY2FsF2yTWrUVY0OpXg8jZ/ZdQVfhrgBSnv95hxv6tuhSk6tGlnywAlxXQG6fwbpveBuEsUmXgg3u6TwvVeNi7isgBtJ7ItWtR2IowhdzNr7zCPxMTcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(346002)(376002)(366004)(39860400002)(136003)(478600001)(6916009)(66946007)(38100700002)(38350700002)(316002)(54906003)(66556008)(8676002)(66476007)(4326008)(6486002)(33716001)(41300700001)(8936002)(5660300002)(83380400001)(2906002)(44832011)(6512007)(52116002)(26005)(186003)(6666004)(6506007)(86362001)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rhN2ndU/DbipFg2mSWDpLyItZYtsOHuNL5UEmc3VPf/UIycbVpRL0vInndGe?=
 =?us-ascii?Q?hgfUpsSGUP09dZmegu/n7AF1k4xOP2k1c4BXG8cKLd1ZF0CErJ1Xlg7uyXAQ?=
 =?us-ascii?Q?5HMG9BXzkz+tFXui8ow1sxIV35cIj5d+7xkkaRR5Mj/qkeX+5zxhmrecjPv2?=
 =?us-ascii?Q?ZP4ryBZ6kJll+K+8QnQKVupEzvoO54Pv7ZWaeu2k/RBLAW6F9dNmolLU86+E?=
 =?us-ascii?Q?c8FaougYl2a9I6xcTT5zZZSQTqEVrfyjQ9/zaBBV/bwNoYCXd1ej0HXF/pXz?=
 =?us-ascii?Q?ga7ovKVjuWDTqpyh5+EEUsGcY8DJ0GBE18wg/FLykBUg/S9kYGKLQ2wKCUzC?=
 =?us-ascii?Q?4UoiaNWrAVQMPQzY9951fj/cyHgGiHjoK5kz5AviUGoHkXOlyeKWp2gcxngA?=
 =?us-ascii?Q?RUYNoU5XxLqOyXaQMXVRSZOphL4u+9WkaW3Wn+pYPJqsqJQHaedyQRjqTG4a?=
 =?us-ascii?Q?3ezPfw1L5YvjXylw4MBlST+HnIboRycTVdV4wF41ydQyoGPf0JmO9NPyob8O?=
 =?us-ascii?Q?aUxpw2QCWWrFoOLX1eZ+32PviEOEKC2O+EkzPWpV78X5Rt+JLQHqeQyJk9u+?=
 =?us-ascii?Q?Nt2wj7XcmwM3MYcPfJ7bqPOpyMUGXYid+c09wLbecWjL976EBWDjm2G5OULE?=
 =?us-ascii?Q?SfOLjXbMD1Pcx2RrlJtt+asJDhcOg9gubP8rFd489yCWnZCz8fEXdZ9cWnPT?=
 =?us-ascii?Q?pEfhGHgC0/937RkdADYwY2T2YdCtOd8eMcDJIG0eDFg5cYZXuEAkOp1xaK+l?=
 =?us-ascii?Q?MZ1ubGCA2RKy+U8p2E1XtJ4/MGRPznOsqBIkXZ9uqDwhycSNpdlhX+Ur995S?=
 =?us-ascii?Q?WUyUeADB4A3eiBuoGIdchZ6qD7sO3/56i2u+qK4waG3sGhjLzTTyXgM47e95?=
 =?us-ascii?Q?sr2EJDeiPJqObBoCeCXqxAofjqbMO0xtfEmBooc5KEKsriVZPuTh8g7K2LyL?=
 =?us-ascii?Q?l0BQLcpaDEF2I/rBvzKEbiP3iI+Xvz4dxfRCjlMN3HVKMj+p9nd+IdhxfrZ/?=
 =?us-ascii?Q?8rg9T18Rqh0SsI1Xr/qt6MqUdJS/FRr5tYuOSj7Y/Ugs2KGUP6ErUto5YlxP?=
 =?us-ascii?Q?E4ycNkEAS/MJEYFG69uj+MOCNR4WPn92wNSA/acKUwhk6ASjcNCIXBLINbzQ?=
 =?us-ascii?Q?52cIhKKTK1dNfgXQ6NABaYa00krIJ99esC9zeMuyAwq9Vh37qNl3NLIS9lZu?=
 =?us-ascii?Q?qPmGqaChIYePFlzCP9FqTSXzErGaDRAPkvc+D/1Z8/80Xux3UjJR083CAGvs?=
 =?us-ascii?Q?kKty2cNDiSRMUjbq8PeU+0VjZzANPwhO6t+dLp/DVJSV7iu14dIBRMtR8k9I?=
 =?us-ascii?Q?nGki/J24aMOSKUvn4DwHTk5Y7h6NN+YBzczUGTFi2psDwe9pZuSXiImv4QlB?=
 =?us-ascii?Q?SsXz3zGQrOTYkwpVN2/DNw+2UyAm2DEx2qjtvBlpfTGP0ZSY4B9F8GCvHtUL?=
 =?us-ascii?Q?LT2w9mEurZeGGOMrVBdi0BbnTHwW7Y/jQu960kDc1emTzD66w6+6B3aPjgYs?=
 =?us-ascii?Q?n0DDjFSin6379FM7ehsZCaBHh9QIosanNegBKJiXn3zJTY5SiyE3ZDJBkSj5?=
 =?us-ascii?Q?nOef7okmQcHInT8Dtbmb+5u6WNRZ+GXgzmZ+bY75Lwv98jsOWeGpwFb+Z8SY?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6202e45-2fa5-4294-5cdb-08da8c2f42d7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 15:33:04.0358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4k9heirNOzh0wx12jVMb5pCccSU544uixoNpoEJ9FdtmbsvIs/oQqRjUoQ8dezF0ndXLoQeLGWosfFOs5BN0A73tdVsjXdoid5Q6TAV+/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010070
X-Proofpoint-GUID: 0rUJ-G-mu05iGol99emaV5sAYkYxv3VJ
X-Proofpoint-ORIG-GUID: 0rUJ-G-mu05iGol99emaV5sAYkYxv3VJ
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "ntohl(ucode->code_length) * 2" multiplication can have an
integer overflow.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 8c32d0eb8fcf..b196579dcd98 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -253,6 +253,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	const struct firmware *fw_entry;
 	struct device *dev = &cpt->pdev->dev;
 	struct ucode_header *ucode;
+	unsigned int code_length;
 	struct microcode *mcode;
 	int j, ret = 0;
 
@@ -263,7 +264,13 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	ucode = (struct ucode_header *)fw_entry->data;
 	mcode = &cpt->mcode[cpt->next_mc_idx];
 	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
-	mcode->code_size = ntohl(ucode->code_length) * 2;
+
+	code_length = ntohl(ucode->code_length);
+	if (code_length >= INT_MAX / 2) {
+		ret = -EINVAL;
+		goto fw_release;
+	}
+	mcode->code_size = code_length;
 	if (!mcode->code_size) {
 		ret = -EINVAL;
 		goto fw_release;
-- 
2.35.1

