Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9848C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Oct 2021 16:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B988960E98
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Oct 2021 16:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhJJQjH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Oct 2021 12:39:07 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:53910 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhJJQjG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Oct 2021 12:39:06 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19AGMiEN002619;
        Sun, 10 Oct 2021 16:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=fGXykHyoEJeae0CUUP73APNyKtPlxO7Uyb5p8bDUljA=;
 b=SHSSyzkc2Q8ljbVgKLxX/MPdGFZArXJ+1kb2wOaKd6Y+zcyWoVKnPFlocn8JCxKCrv8d
 IEob7AfhBwUpZo7dJtf7K0TuGgcwasr8nG7ag8/GZmXorOz0APQonrRlt8XZa1jmXMPi
 HV4MbipnMDYnm7MXx/MMJiABhAQKBsc/9iZXx2HxuYBz2h1af/29nR3mY7dObT+qI266
 OlwityrBdCoOQCT2XERKklebbToMi7DxDrrPLbZIapnpsEkFQe+v3/iWhsLaMxG1rpxa
 Ca/kngzjKIdoCGNaxMbpXrfTVx5OYxT+EM7tbUEjBG+T2Kd0FXsAyU6Tyi/pAlQOmGU6 2A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bm0n4r2wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 16:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzZ1/MWEQdwxlLCgBnHfbaTIhuCc7lxApe9dfJYn0cNdjgtv6u2Obko0zx2Gj1sJXxdcN+FpaXhrjp9pi9EXQ9I/w4w0TCVwgJi1eUQssT3RMpT+tzGPLiZRmBhHKpY0nS93G7+y4r7iR/4L+WUaasql44TDkju7r9AK8E3QNiFRa5jnOD3I8gdj+RwBd9NvaINB1dlWYqscBftIBfd0CJtM5uqXfMBOk7THufCfCkOR+z8EouYFl2Wrn74bLlSxOQ3RbNEsXt3oxnbirNSERt8TDeFUZ54JrfUWNaz2CtvMjDRfWPizV4YMqnATwqsz64tG2Z+skC4+bYErcFSPGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGXykHyoEJeae0CUUP73APNyKtPlxO7Uyb5p8bDUljA=;
 b=XtdrIxsvYkLX2ixegUIxrplpCQGQ0AxWoTNe0+JNGxXDRp/UqJOY7zWWA+7woXRP8EquQqvovSlX0ekcqggwK3IBsLZ0/TTL5wWQ1Rp0uk222prV2oFvaN2+30+rzwsgTMpDvGubvo4i673EVhDBVIyYPfbmgcT/Cq2Y7tr7YPVNTYbLyH1Il3//qwx0oCb9UQjp7aepOXFb80i4UxkOLgr89E+qKebk6Wql4dW01PZTdzB4/5HWrHu8LCbCWAaRWj48pW+K0qkjZr+Y28hA1DrMwf1mBL8EQFBx60MhfJqgvJWv6hK6tJoz6vjcVBL82qD7SlUOX1ukv4A/QlhdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4172.namprd11.prod.outlook.com (2603:10b6:5:19f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Sun, 10 Oct
 2021 16:37:00 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 16:37:00 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     linux-crypto@vger.kernel.org
Cc:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com
Subject: [PATCH] crypto: octeontx2: set assoclen in aead_do_fallback()
Date:   Sun, 10 Oct 2021 19:36:42 +0300
Message-Id: <20211010163642.1383329-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0002.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::12) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0602CA0002.eurprd06.prod.outlook.com (2603:10a6:800:bc::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Sun, 10 Oct 2021 16:36:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb8a3581-d898-4c89-f3f4-08d98c0c2edc
X-MS-TrafficTypeDiagnostic: DM6PR11MB4172:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4172F370C21DE7830D687220FEB49@DM6PR11MB4172.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93CDSG3RShp4sOB4RVfVZ3aCDuf2zel578ThH3MHYv73i+wX+yAqFWNHpOAD66kk7lpJs2AcGOaHwQcn2wnYbygDeBc/a2x8abhR71ucKL5qz7gAcjtmzUsmCoSe1FYiFv4qH0xLbLdaM5bS1nk24P+6bBpS7lEtGHfOYDB2Co40ArEqovztRKGrm/UNo/q0svdIpZs+noH7Fj48fQKAEwFmCWYo9AGSQbKBIbzsLQ1slB8TKXUX9V7EhKjGifko8NqYH4y3J5svkX7tLzzQooXDY4eHjEDRIJy6L45eb4w1dW3qRfDvDIa7EUwK9Y2RyqfdhnR8mHiM6+93IWqSb5QCFlR64grqjc+Rz3Ezszk9LhFv8fqPu/1b1iDMNJz0/MWI0mZMJpnvzCrjw42cbvUErM/WPqw9ptANOzJ00uSaASG5BIGNDHMMKaiJSNC0kMG7T/LBko48I19SBvBCCQnj33y4K0AIeijfTOoUcZIrJpBrE3cCDKiCxRgi416UTJu+U/kcGlnHa8RbfWh+7W653oxP4id6PAe00HvygbfO/XmJ0ZRrPWuEVYaOwYfmNgBqPsCkvu61n4iwN8oBdTq9vq99CV9BTEMwiu7LMzDAXFFBVwGJLIRvxAh0f4zvJ9N+tlhJEt909e3/6CmexvK5TjzU2pvflThXI382tgWJDrOgMHWoTDEO/hQyXKM0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(2906002)(4326008)(1076003)(66946007)(6666004)(956004)(6486002)(2616005)(83380400001)(86362001)(8936002)(316002)(38350700002)(38100700002)(6512007)(66476007)(26005)(66556008)(6506007)(44832011)(36756003)(6916009)(5660300002)(52116002)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Zz45WXu81evgqRNn9iN6bvnJg5io1LlGjuvBBCRDEhUfZiEfdvlnaIZWiGt?=
 =?us-ascii?Q?rBOGx0ww1Rdu2m3aU6TA9PxyBx99uj9WFArs4yt+JacwJI7kmk2TxKT+DUFy?=
 =?us-ascii?Q?MrIQTejAQjhXdtVjSZpiP6E+0zqF+HkFkTooNGqPAnpFwEcQzFpF88nWh8IZ?=
 =?us-ascii?Q?tsCpUU/20itk+HGAIuPMKVzuLALDvYGxGfg8qIGCGTnjXwKAYnUHAXyntpL0?=
 =?us-ascii?Q?02560hZtvtGBy+O6vjJaZyaMmp9NbW8MD99rt/8zC4q8uBSynAH5F82hgARo?=
 =?us-ascii?Q?Eie/LR2O0Yw44JbKB4dM3jWTNS7Yd0TBt0XqtQIMVaYCJJ4rdWWPsXWcHVks?=
 =?us-ascii?Q?8DODwidCxFIBgA5dZeSYi+f5//wN/S+SKH02EHSTFzU1OMTGcSc1D9gtwyys?=
 =?us-ascii?Q?kWimnEwfve4f3WfXi9+oF1vu1qDF9yTuEwZWT7dhuMZLmnSI1PEqicyikqX+?=
 =?us-ascii?Q?4beHqm6N9jQdGz5kliYkzL7QDKP6+cksWoAIX6hHzFZnZcWqvh0b0IjNI4hn?=
 =?us-ascii?Q?+YudlZmHKMiv5iBFbsKhFHCRfn2i2BpPLIfl1wpYa+yVXsiyCCdhYoZex9S1?=
 =?us-ascii?Q?BCH7kEfvnX/H/W+SIUXF+cQsTvTdsQQmzUiLkHSzoz3cgiGUTjqBKwadmsPZ?=
 =?us-ascii?Q?++58POkhaAoNnVnNMVqvVnAtdjiLjY9jqFoUaSdL0oTpIMkY4052ombIhOKZ?=
 =?us-ascii?Q?mvSMadjg93AxTyybGZmr8cJqAo01Z/FqwopsU/GNECJHCR/PvpfdPm/RSums?=
 =?us-ascii?Q?DWaeK++tx/gk67GSnlw4HVaArbor0ztu/LaXtxMpOdhtMNTfuNFJKv62iN4b?=
 =?us-ascii?Q?aklo+6/5NjEtYS5o3yOWq7L+ALgPtEzJckQAZmqUxU3+ju3PpAqgPuc6FLu2?=
 =?us-ascii?Q?F3mDr4El0BtzAPNf2yPT5z41Y0EzfY0UgiJQF1hXNfaP50d1g33KYOIvHmDE?=
 =?us-ascii?Q?vumZoMpk1CKx3VbRX4L1bzwRpJKxgWu+ouFogh1242xv+ekhg2ip9lRNIyCy?=
 =?us-ascii?Q?EHBpxmxLONyMwnUsU+ca/tqPwDei8JmjX7eBUrPIegOim5IR2z8eXfyI+UHw?=
 =?us-ascii?Q?5JlWIYo5cSQulfvRVbyztRDfrmKFdK/nie5/A1NNgDBUtTcbdI2MBDg9K4/U?=
 =?us-ascii?Q?gBzRKy9Qm7IjXhZ2aT0TzQfAA8Cc95PFokrm4E3yEHF7KIsrEny+igmebCBe?=
 =?us-ascii?Q?XpRCyQOzuqMtX8rMxlZZVLsGqwlEF6xrIOUsAXVdSth8Xgvz0zfD8bXxOHq5?=
 =?us-ascii?Q?5u6h6OTsEyQaLSkf6B8kgWdY1dT5x6doiGuyZ0VuuWpQj97tQjvZlase8PBy?=
 =?us-ascii?Q?+bDwEwo5V4BM+cKe/mIwfsYp?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8a3581-d898-4c89-f3f4-08d98c0c2edc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2021 16:37:00.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0iWM1uaKDXlDUhEuidx7J2c3pEqB5QfsZVIjXRQMk9p2V2pP+nU35mEl+s5caOzazyHiKmoavpBcvlt0fHvFo4NGEt7JD/sDqzd+z+WOChQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4172
X-Proofpoint-GUID: d7mSzfQzYieclod19PvgjlOABDWW0AQP
X-Proofpoint-ORIG-GUID: d7mSzfQzYieclod19PvgjlOABDWW0AQP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-10_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 impostorscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=898 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110100114
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, in case of aead fallback, no associated data info is set in the
fallback request. To fix this, call aead_request_set_ad() to pass the assoclen.

Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index a72723455df7..877a948469bd 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1274,6 +1274,7 @@ static int aead_do_fallback(struct aead_request *req, bool is_enc)
 					  req->base.complete, req->base.data);
 		aead_request_set_crypt(&rctx->fbk_req, req->src,
 				       req->dst, req->cryptlen, req->iv);
+		aead_request_set_ad(&rctx->fbk_req, req->assoclen);
 		ret = is_enc ? crypto_aead_encrypt(&rctx->fbk_req) :
 			       crypto_aead_decrypt(&rctx->fbk_req);
 	} else {
-- 
2.25.1

