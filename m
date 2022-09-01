Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B51ECAAD8
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 15:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiIAPcr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 11:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiIAPcq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 11:32:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6882CDD3;
        Thu,  1 Sep 2022 08:32:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281FInoh018661;
        Thu, 1 Sep 2022 15:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=tlREKlln1W+T+y0g0UCop5Tif2imPjMjwza0ap6qQ7Q=;
 b=ju+6sDAtCP7qD4kDZ/QzzK0MSsIQi7DC5MUqBUmrjGvNDl//4w0ENhHjuZ6wo6Qvnq3E
 MBfF82+J6P5V/FgGcz6octlg6ghPPOqtV7//GiA22+gy1aBA9EQALCTrSZRNOpsH3wVZ
 K5/Xh0NUD85QAuRyvuIoDtcMhocI2mCeO44ZHpzqJn1n3Lr+8igLzpE//KSzO8hI7ijN
 QMrXW8GbZ9q8Io6gkWvIKbcVZ8T25D7D+FHf+1aA3n55m8kJGk8In2lcMwkXImKsg/DW
 J9nrRGlv4lAFsayMgSG1VaTx2Gtvw4tw/LWOOUK6rpJhAisInFVyGQJtM2xt+hQjWSkK iA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsmmnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 15:32:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 281E1TP4001865;
        Thu, 1 Sep 2022 15:32:23 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jarqjx9bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 15:32:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epknvFfSPiXA3oV0gAXh6Vw4F8zwxnqAk8b8O2ltaegpoqClz/h4nvbut9Gvr7GQO/qQ9r4H8RbhQL80AP7IUSjUc51Uah79LjTbq66/hfZv9zAbaOYqqRwLRChBFlyBvmzUyap4kdwDjJzuScmtpA7PeKg/fvBIZdTj8597AzVh3v8R/kKO4SIOUPBvB3epAp0x7zQ9HRTqCCrHKPLabm3o6Z/BkfQtC3uYeIQ6nz4JWDAqfDchzP9zvd2ydazMWzBR+Px0aGVOF3UbhE0Hq+W45AtLKuQGw/Uhy+nxZ3nTRVy47JtiCDY6INd8zvAmTsA+bFCb+EpyXExI7vvV4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlREKlln1W+T+y0g0UCop5Tif2imPjMjwza0ap6qQ7Q=;
 b=oIAVUV+r6LHzYVzdpG2sT/qchU0mEd5BNm5ASpfx5RXykRYRSA5c2QIrwZvX6rKt4as89SX45kWmlDKNH59Zzy7ytluUcU26PA6HgISER+xaAlC8PcYXxOLRW8QjszBdod0NSFmlzLYM8MZZIM9kbnHV0TK3zCfeGa0UWlYIgKan3rk/ZzI7UyPW4jwnPbZJEOqo+XLYoXyfk447XLMTO0ht0FnD8rl6O3A1e3Vbdqhc1H841kptV0aF4jvUsc6vqEGqap4UqsQdT4IWwBCWGLQ/EhVjsyPrZ700Qnwf40G/f1yglqnCH3HAet/m7VWZVMR1dpatC+g31hejV3AR2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlREKlln1W+T+y0g0UCop5Tif2imPjMjwza0ap6qQ7Q=;
 b=Rg5LYXj60XTj1FO9/ROTpD6ErYgl7MvwGVslcEA2fWKBsBb2NVTQKdOzimV9Onpy3jgzAXBwXACARCvQHgFw5en+bY5oyfwXSd+RCKNIx0gbkBVmQZAMCt8XmOE93Y32OXhyke7HB+czXipIQVWcDMZC15CRzM+m+MCppaYtwsg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB4205.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 15:32:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 15:32:20 +0000
Date:   Thu, 1 Sep 2022 18:32:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: marvell/octeontx - prevent integer overflows
Message-ID: <YxDQeeqY6u5EBn5H@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0110.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::7) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 551864da-04f6-449b-73df-08da8c2f28fd
X-MS-TrafficTypeDiagnostic: MN2PR10MB4205:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NlPl5TocIiSS9WP7dbjU+LOPXvIuSAr8OWL57NMwCRTy7CUQRX2RX9U1VzHQM5P3qco3DMZgiUZCwtUG8SHqOmCC9cKAdlgRM6tePOK699swgD1Khvz7QbJvtAOdOXnqKiq97l11Ifnm9LHLYWJXFu0/V59cFh5WVsF/QFXPoLFKoMGDrvb4YxlKdwFAeLG6t/VUyjpVlMHsKnYxD+wNRo4YOSq/ciAqLxUohrISTkKjfCfATWmaOVogkOV4x1f/4rklbX3M0RXZcy6RTlYspgNmAMZj2ml4MAPqEIerbeGN2IIk6gmo7gT9mIvv+CUCaPl3kasaFIbg2hQe8GnXl74f1ZrFIuQgo81i1FuXP4DBa942IknFNjyV0OJIaWAPEkB3AuOtu4E0w83Fabp40Rw3AHztqJiKHsaNy2gd24hZYvqgPFH+xi4lnTJ5s6VgfQEc987Wf/ZdWwtvx/p6HqwFsdr/mdO87nO8nqkdiXGpsB2Jfsn3LxH3Uf94btg54Ljinq4ynFdngF0/DMKr7Oalb8AF268jJd5vMjZ1z3B8OlfyjzyggJGjPLL5WQ0hlwlSrrJtqC06c0LTfvyXEYbn4zfEtY9YwaMfgii4z/gXaiyTVVwzBkJnX2TwhXvTYkKlG8oIqx+iYDtelmox8cdAwfJBrIkVRBLXYga8CBoEJakZtJvGv4RY8vulYJuvLsW8CBYZIfzV4Mqhfo1wBgshNszE24qfJigwqL4/rww5FvPUmZgrlCEUZV/T78NpvQQNYfaDKPJ6bP/jlPyBbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(376002)(346002)(136003)(396003)(366004)(6666004)(8936002)(5660300002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(44832011)(41300700001)(186003)(6506007)(52116002)(7416002)(6512007)(2906002)(9686003)(26005)(83380400001)(38100700002)(86362001)(6486002)(316002)(54906003)(6916009)(38350700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MjGFRdvvRIaXCbVtwBrw6DDcwR6ADK7ansr8hoSH60ZyVrt2Rb3DAGwa1Xcz?=
 =?us-ascii?Q?X7Fxq93oflgH96jVIomE6To5EFO0lTvmTzzUV+0/+YTdq0iGiXhgXaGH7VaY?=
 =?us-ascii?Q?GVcsZbj2nlutNB101QJlid965cJ9uqSiGDniv9LYwj3zqn0RJAGlYsPL2+wd?=
 =?us-ascii?Q?Wg1NEqs7v0YFPaJ2R+poB7104rQyc5BCsmNrR+Ig6HmxvIKGv5D5BoyzgkOr?=
 =?us-ascii?Q?Ehs9Yv5sWXkQY5UI1ExTutiv8TOTs7r2vD/iXKBRSxZV++4L051i/7x0p8Uq?=
 =?us-ascii?Q?CG71x2GELHlAb70BQF1j9uFYhXyVR9a63CeH0dpCcBYvkhNcq+8GkNLbGvTe?=
 =?us-ascii?Q?2EpR2jpEZ8dsxmlqipbbfiQKrabUdx3JA5Zi5Hp1nadiKK+7ORkEqoO/x6rf?=
 =?us-ascii?Q?1l6USDmloTwVUejtbaxbl20SxDWADaxvCNd8w0+PnD8nWqaadvBksReLzbkK?=
 =?us-ascii?Q?qn0gaoZBot326X2mVnnzC3dV3o8FBRT/Zc2KxS0hjXfy98xlHjlkEe2wCej8?=
 =?us-ascii?Q?vXINcxbeG+xKjZcT9Qvvg8HAU5twv34YSdw/aHPWVw3ueudwu+4Goe0tR28D?=
 =?us-ascii?Q?6839/9sTdX9hqltFc6qo9NAW2QVZWWM7Vdc5STKSMa3d06OoTwHr3jPPzA/o?=
 =?us-ascii?Q?rfkPHyUjcjyhF+LQi0PGRsE1Ui/XsZJ8Fav7wOAiHvKVSd6Kb22rw40tEG9q?=
 =?us-ascii?Q?GT/bmuk9kOJUJ5DRQ7Ueji+stp7IEvEvwSD3xqL5rihgSP1XnP3OnN1W7I8E?=
 =?us-ascii?Q?QsBtA9W8FK9jFJVBjBsNZxrv+NTNIydLRRON73U5wtpUvtvJv3bB+2cZOx8O?=
 =?us-ascii?Q?qz9ZUHpx2SmIKILCSUdevmzKHQ+qbLC47/vISM0yQmDEkdmz2NXPJvLd3lkp?=
 =?us-ascii?Q?ItLGULJba9cUqZbEJYH8PZN02jov4sfI5Gc5coWvLOjkhegez69oPwCdsJBM?=
 =?us-ascii?Q?AefKMsmH5xVig9eMaxKjIGcDPzAC2Sogy/sk5ucvsxHUPOcHJ0UcrnYhvhca?=
 =?us-ascii?Q?MSLoadxNSBDEi0QgJFbHz4btlz5EYAZFI1bLg9XvxESdnOj1p3ccpK6WX9si?=
 =?us-ascii?Q?c9yRRX50B5nXqdtgeqAuRQKCcwTILNL6UG+q3ge8WstGLGpKOJzdUimItmwP?=
 =?us-ascii?Q?y2NxZH7zCpn7+WrHYWEK1NecGcd+ITr7ml2pxteiCz6fDgurjc9kJ0sMl1Yr?=
 =?us-ascii?Q?/D/ebW/xnOrKJHqCjsgkplGN8t/laHOpwIOlIBZskjqAahSbEdCPLbQSk/19?=
 =?us-ascii?Q?Z+kfR3kE1t0GTN2BAF/ehSYCwQ7ypjg9y3f0XqVy9fFTURVvzm23KCcV0Ej2?=
 =?us-ascii?Q?We+dETdGxDGYjX9G0VJSNvPqVQXZsb1K/Is8oedIkHXmi0lOq3wnNoMNG9Zr?=
 =?us-ascii?Q?RJtPJBY355zxpnq5VVg16QHdDrbYKcmoXxgqKje0nmfHNPJ6EmyWjt/PDncY?=
 =?us-ascii?Q?Zl98ilN+L029/g/CiUR4opIqjWRTaluVyUW6Aezi40ALGrqw+djEWQFty14d?=
 =?us-ascii?Q?r4RtdNUpX3KLfkjRfc/ZBxjbPaPrBvc470bW1ZoITZLGGjIx3o0nNoToLd1D?=
 =?us-ascii?Q?MQTytjAcQiVOiTZxFLfZUe2/qczkpQ0VBZWi8Kh0rF3FtDaqoEQ63VWgovjF?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551864da-04f6-449b-73df-08da8c2f28fd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 15:32:20.7271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jwk1mg0UIez5ChqEmsBEa0oxpOSQ/tSad6hftcZIsSjdqaMsr4HBATcgsykTQ2ISbxb6ryaMCSW1zTSyB/dLvdoiIQQ+XDXETxTH4XbJCaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010070
X-Proofpoint-GUID: bDj3pmDFWmrAaKUdoStnhS3pgF8gzzOt
X-Proofpoint-ORIG-GUID: bDj3pmDFWmrAaKUdoStnhS3pgF8gzzOt
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "code_length * 2" can overflow.  The round_up(ucode_size, 16) +
sizeof() expression can overflow too.  Prevent these overflows.

Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I chose INT_MAX because it's way higher than what kmalloc() can allocate
and it makes the code simpler.  I think there is a static checker which
tells people to change these to UINT_MAX.  Don't do that, or at least
CC me if you do.

 .../crypto/marvell/octeontx/otx_cptpf_ucode.c | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 23c6edc70914..1be85820d677 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -286,6 +286,7 @@ static int process_tar_file(struct device *dev,
 	struct tar_ucode_info_t *tar_info;
 	struct otx_cpt_ucode_hdr *ucode_hdr;
 	int ucode_type, ucode_size;
+	unsigned int code_length;
 
 	/*
 	 * If size is less than microcode header size then don't report
@@ -303,7 +304,13 @@ static int process_tar_file(struct device *dev,
 	if (get_ucode_type(ucode_hdr, &ucode_type))
 		return 0;
 
-	ucode_size = ntohl(ucode_hdr->code_length) * 2;
+	code_length = ntohl(ucode_hdr->code_length);
+	if (code_length >= INT_MAX / 2) {
+		dev_err(dev, "Invalid code_length %u\n", code_length);
+		return -EINVAL;
+	}
+
+	ucode_size = code_length * 2;
 	if (!ucode_size || (size < round_up(ucode_size, 16) +
 	    sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
 		dev_err(dev, "Ucode %s invalid size\n", filename);
@@ -886,6 +893,7 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 {
 	struct otx_cpt_ucode_hdr *ucode_hdr;
 	const struct firmware *fw;
+	unsigned int code_length;
 	int ret;
 
 	set_ucode_filename(ucode, ucode_filename);
@@ -896,9 +904,16 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 	ucode_hdr = (struct otx_cpt_ucode_hdr *) fw->data;
 	memcpy(ucode->ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
 	ucode->ver_num = ucode_hdr->ver_num;
-	ucode->size = ntohl(ucode_hdr->code_length) * 2;
-	if (!ucode->size || (fw->size < round_up(ucode->size, 16)
-	    + sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
+	code_length = ntohl(ucode_hdr->code_length);
+	if (code_length >= INT_MAX / 2) {
+		ret = -EINVAL;
+		goto release_fw;
+	}
+	ucode->size = code_length * 2;
+	if (!ucode->size ||
+	    ucode->size > fw->size ||
+	    (fw->size < round_up(ucode->size, 16) +
+	     sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
 		dev_err(dev, "Ucode %s invalid size\n", ucode_filename);
 		ret = -EINVAL;
 		goto release_fw;
-- 
2.35.1

