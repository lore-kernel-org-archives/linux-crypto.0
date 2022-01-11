Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B26CC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 07:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348467AbiAKHSc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 02:18:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42808 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233066AbiAKHSc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 02:18:32 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B3TEPX030793;
        Tue, 11 Jan 2022 07:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Tp5lznwToRaWm9yjY19cgp35mL/oiHKHyE4ljwvedis=;
 b=PyLWuQkVPsFLjuAhz3FsuXtIE3i5n1QXZ+uIcn9QCdBirWNL8jNOGeQq0v2FixLXIgEO
 Bz+sUveOVMwP7+qFh8jyjO8CUtdtS7vNkSOp0X4RCpogP4suMgcC2WB3wB2jRT2PVBD/
 JsUwNyRak9dT16XGEqSzzLjHdkLmjxCbzRtB0xqRUt9Cvpyza78DWUHJwmyhA/UZTjcQ
 yVx3lUn+NIly0he7zYese9trT1UJ76HtM9qfLIhkroDjskEHFclpcIO+3JCYml9LSRNX
 3oxE0tO2jaX7YjI29+sFtYD8NRMwl2V0SjEq/vMNll62xOxMljliqHjqNIPoIhuyBQZZ Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx2d44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 07:18:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B7G6QA081599;
        Tue, 11 Jan 2022 07:18:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 3deyqwp2w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 07:18:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy8RKRrT90kiupiYCxYHs93FXFggCT82vPlexTmPJySPoVVzq42xaaIRuJxpJGW5Edz+G0BzDsVnCrK6gnzYGmTiS3jVWPsEO/Z+YK506orRv8qp79KZ3kK6869071dgTjqdOQ18QhJlJWrAPW+AMCMo8paOErvjYYxNgSsFJ8Fd5SKdmk0LTBGLSIFMa4TjdWDXHKPIMYPeIMpKjrdDE7rSp6rln8MPxlhLkME3tYsdKMCrX1rC0kstziZze7gx8N59E7r1YPC1SpLoVPHRPQGM6nwDIrloKblA5+OtzsL6Al9bgT7k4S4/CAVT550l3G8bLwjzkKBhXal3SUTJjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp5lznwToRaWm9yjY19cgp35mL/oiHKHyE4ljwvedis=;
 b=Bprn8J34Nu5eAhbSSLKgpGomwj3iKdBcb+ZNP8bzJ1ShngTGjuMS1YIKPk1hoOmU4UVmPZVEdvn3PTYq4u76pusrwp80px9JHP9A9Taj+Qg8F5lHxLA7Y4uqBHeL+ykQjMuNZDDJoBI5vabJ5fv7oLW/aIqZC3mgAGKRDceUlDr+TZclcu1iCYhu2V1Ads6U9id3SH37s5mIC3BJEPIWO9p0JGdjuwKxVd6WYfQ1JfWiDg9FT78n0gx/0u87SKHA/cm3XJwa4Z7gaDDgIiAFH4/5bcRBH8TBvSRGbqWZy7BBFe8hhTV6Guv+u9gXOmzZ8ODkSDEjDMTdgiWYPxHgcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tp5lznwToRaWm9yjY19cgp35mL/oiHKHyE4ljwvedis=;
 b=icJcnoqEPDwlxaJ1kR7dMSN9P7/6wU9fA/PDrPpPhMTxsGQvlZuIhyXBebNzQ8UrxC01YH14CdaJQCeSnxh2wpYacCdYqFhlxotm35hzG3KuD0uhpvtDQKhsDvkxOdlEa1oZcyyaCkpM/G0kh/breQcOUQzdNen5DOgiKVh/mPY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1421.namprd10.prod.outlook.com
 (2603:10b6:300:24::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 07:18:18 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 07:18:18 +0000
Date:   Tue, 11 Jan 2022 10:18:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tomasz Kowalik <tomaszx.kowalik@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Mateuszx Potrola <mateuszx.potrola@intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: qat - fix a signedness bug in get_service_enabled()
Message-ID: <20220111071806.GD11243@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::26) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 229bb8a7-a2fd-4386-eee9-08d9d4d28a6a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1421:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1421184086687FF979346A928E519@MWHPR10MB1421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jv7FVOaWZGNKCwWXga/7epTOJuZE6XnMkOI1dCP8eKw0mSJ/e2utK9K6owaOvc/FWRZXiy01XwjslqI40z4KqTfM0brFouR5zcSisTssgUkGfGG9KFHc10yjUubaerSjDaCV6OYT7H/KcWROGSbYA6gVne8F1WLlKNR5wvCcVqV6mKY2dv54Z3qf1lhW23uHimrswsl/os6fPuYDgjAwQ667OAt2fUd80LsH3xdKG73pnsZZfmUS2dPO6Ye8+ECTiw+5KPmFhKZIB6IRTTzEvhbA5WLJtpIjiijcJC9oLwbYw6bSSc2IugJ3ljjQkegyQESIVnGPJLJ6Grh7cCXD6wdfYgouFiClyY3ZJF/mMFzJvR5vCHr/opH9K0fk8qYbXG55ePLorXqZZ9CrDpzgBbOmcX42iNP02OFrV7ichTwVScuB3hkvH2QfEtAI7AbcUd/LRIhUChiz4XpstlZ9gNmDWtAlfXKakqnWJSGHJ6KxT+RFITGwEdu7QC7OXslacUPF/wOi0CCeRBuIilS0rswqCgOjiSX6DR32ETC7Y5ZR/TIV1zvanPDa48xDMEOlmZ4IUreYy4/wucnwXZt5lVvlAMmNSfGSG5bDMT8qWscEVOVhQWGmFxYjenDZgK+xrd/A5WgK6zAyJoY/Z82LobBvWTDXBrk1Zlje8NsQrVj4WqwK2uFWmZdq1lwsUoUyfalGmKibP2Ouz7L3jw+F3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(508600001)(4744005)(44832011)(4326008)(52116002)(86362001)(2906002)(186003)(8936002)(54906003)(8676002)(6506007)(66946007)(66556008)(316002)(6486002)(26005)(66476007)(7416002)(6666004)(9686003)(110136005)(1076003)(6512007)(38350700002)(5660300002)(33656002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x5GVrPxFD3UlP1of9H0ymCZOsaLgXJU1v+gE/sOOoaoVMqzuDPlXCuRTLXNB?=
 =?us-ascii?Q?24ue8lnAQE0cG4Tsh4iNjqmlIneTM2bZ/uONbJ5VbTum156XBcqAQzW1BxrV?=
 =?us-ascii?Q?OijNREcyxP8uzt04xTJ9N7DD0mts0wrZNO0nK0DBw8FZ3QH2mywgWgfwBzas?=
 =?us-ascii?Q?dLV/NS5Fs7o/LCiGherQx6BD8tdhTkwkwj/tIACZTE1ulBytaWJ5P+H1mbks?=
 =?us-ascii?Q?btP8ZwT49U8yj/EFzE/O7gkltDocim184UxZTuO/FLDOQX7gC0ju+j2l5DnE?=
 =?us-ascii?Q?vpi95SJadfZkSFWvrFR4jYAC7haYCRwleZrA4MJiTLwJg0u3TMoKMxznsrMz?=
 =?us-ascii?Q?/9x/zGzvozAlmUYuD/WXltsMh96Yb702iECOxeo4E9fY2TwhvrZ6PPC2TsjY?=
 =?us-ascii?Q?5RltSKIVlFYCS9oZNpb+Fnp1lZ3yvLd9ul5Ujg+k/r2IEh8VTxU6wZIhmTl3?=
 =?us-ascii?Q?xc08ZYgubO5GGZhXmDrP7fmWIOMi3zs4lQzjn8ULJoUMR9OkhR3pTBh1zt5S?=
 =?us-ascii?Q?CrYqUJE3o6HYL/WrpiPJfh6HA0d+uzwX6yDHBHZLJ6r40ZFtrokr8MtRWWD9?=
 =?us-ascii?Q?FczTEXzosyDDDnUWXuy+A9Xs0czHEzZlRgKDc05bnTFM1GpQ6yfM1STpx+Cd?=
 =?us-ascii?Q?ybLjzpZaHzLXeYCaysP9H2M39iTrtIjQ+TfXO3yRZNK3SQiYnqHzIxf+O3d4?=
 =?us-ascii?Q?PMKq+cKw6f2Mu3zI+LJkvSuhijz/qdYic4/75eBBJwzJEHVLBnkMtUABwGAB?=
 =?us-ascii?Q?3rHoOI2eQ/4UFdwpKrfFJ2WG+tPl4LkitwUiAw5QzBeiO0F96AfuFytPtYG0?=
 =?us-ascii?Q?oEBQ423aTpd9aujANYIppGfcfULJ+LhTb8X8XjgSM5gUFTJkfEvsBFu9mqrA?=
 =?us-ascii?Q?4EEbeBywy/0FsXedc1M4c4Zt7nkv2b4geqA8BkysV0H3iT6U11uc3OZHFDMO?=
 =?us-ascii?Q?7paHe5oc+yiS5/Z68QnGX3vG8dKEA1cMEVEexO+0r5TiCyt1ne+HKanytVl6?=
 =?us-ascii?Q?xueb65lqrS3nCduDXQJDCINnm7stOT1go2wMpRN9nYyQTKH9Ekf2TZful94v?=
 =?us-ascii?Q?42l1xIHEIXD5B388R735cqFjMhWz0LSLSgW+o8CGbPj3vNrYSEftZozFU6se?=
 =?us-ascii?Q?jOGuTSEYYjaNWuaTH8Yml2VsR6ny+5C7wraJkKvIMjQD+ClfxzFf3nuLG5aO?=
 =?us-ascii?Q?AkvzlhNvEzRpG0zivEl8fYL42GX5+keSWyVYXDmiKslGeX3+o/l43zHXeJiC?=
 =?us-ascii?Q?75nhVgdIDt+X+YXBo8ZFdf9YggdyRXnmWn8XetqnC5PGMMEZb+kNlgCh8Weu?=
 =?us-ascii?Q?HtY41DPU3xX8UX+g+CvnTaGlrpLRKVBTzUs5vmLo4TVM52PaMCo9cT4Ab3zD?=
 =?us-ascii?Q?f6DHFeblYnBUPlx8+tBIdSpbeHeAN8KEKsuww7OYh+blYmMhhfCUgfOCvg41?=
 =?us-ascii?Q?+LwijEbEpgFrJc1P2C19MqncTXeIGJ2pYRGIr9ZvztQwyvkNcODuexaxxHZ0?=
 =?us-ascii?Q?aCmDHfCg/VB377qzlKbLsMVHCN3VDh68hhSvs9qs1I8351c9ymT9Az8BwJQ8?=
 =?us-ascii?Q?QBxXsDFc9e84SEd7r7KiV7PKY9L07nNFYzdFUqcQNUqqYRksQm47dNzY9zLC?=
 =?us-ascii?Q?O6oNYORXBUuMHsMjKwoxaaJVA4SuvAopq3uL13jsryfi2ygBC9f+JXMTantJ?=
 =?us-ascii?Q?NeurgkpoI7R4DPPpkVR1xLmOJv8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 229bb8a7-a2fd-4386-eee9-08d9d4d28a6a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 07:18:18.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1+vT5mn12ThyfDEHvS+/CjxuyCUkDgnRd9W0YMYKEmDBlABfiOWHeBr+B61eryGu3o1E8yq1q7hGH23YtmSX+PnKm6GTjFKq1N7sonRTc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1421
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110039
X-Proofpoint-GUID: _gBgsTjbaTbjYC3QIiE465sFOz8b24FC
X-Proofpoint-ORIG-GUID: _gBgsTjbaTbjYC3QIiE465sFOz8b24FC
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "ret" variable needs to be signed or there is an error message which
will not be printed correctly.

Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 6d10edc40aca..68d39c833332 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -52,7 +52,7 @@ static const char *const dev_cfg_services[] = {
 static int get_service_enabled(struct adf_accel_dev *accel_dev)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-	u32 ret;
+	int ret;
 
 	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
 				      ADF_SERVICES_ENABLED, services);
-- 
2.20.1

