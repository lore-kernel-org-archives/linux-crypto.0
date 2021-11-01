Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F32C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 03:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA4460240
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 03:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhKADRE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Oct 2021 23:17:04 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:50726 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230233AbhKADRD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Oct 2021 23:17:03 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A12ioIB027298;
        Sun, 31 Oct 2021 20:14:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=hTSkVpsON1Z6qZwZQDleh6cfN1vH9QMviG+IfJ/tuYw=;
 b=buSv4UePk71uylB1BWeUuEvFFKwz7+KsHmTRqvsE1QTNHYH4mr8dXXBehXI7NS8m2SCy
 cwv2AO57NH4h281ZpExa6YxmjEpuOwUGguuP2P03ux+nbf773tPy2kc1zq2T0w+cOAyk
 bF/63l7ZeJV9BrYs4lTmHGUf87SNuWtWm8JWtuEEqC67IhBGQjyliOI6/t7hcx4lgfZQ
 dq4H6nXQlRQ9b3DBzWSc7Dnm+A3lR61oO/JzWVoZbiBAkN7pGvv7/w6enunX3kA5+3ag
 PBxqxtAUbTU0frhKDl/MbfJDf3T6F5adf3rOtFBo3Zvr0noFZUvZ6rhl5RVzIwE/QK3z lg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3c1rgx0g2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 20:14:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATkRFSjF4PZ5Potjms+H0D556/96TC4tRT823Joeimg6+2qbJUKIA0zxgJFZ8awuWhokdI9z7h3ANNTRry8/57UvNNGtB9WQAIzvriJze4NzFtbaS6FIzIDFSMO3t5Xurs5aRyyAKVN3cwQuZpG09hQ9wwNgl4hLDCAqffvmHRCCfOEtAkhjCwcxMAK81uIEDc63c60SPEzVN6dKQGBvhEvd7ZyM7+LmoNqjN28HZkaP/tBASsDIqolWTa2xXgN+HtvK2kq7fBqHh4WF/+WRRWtzFfqAOpfH+zvTeVqPd6DLZi3D7DXESXv1kNM8B50JNr6bhAysisnZOwhAq0QRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTSkVpsON1Z6qZwZQDleh6cfN1vH9QMviG+IfJ/tuYw=;
 b=kDIZYqwoTPKoK04QEmz3dHiNjeN5LTaLKkpdXUU6HNsD/NTFpTnF86erREfigB279tVvmGR0R4YJUo5HAgMVptjXDvbGvFQ4oW8gOk3wJ/sxMha4Lc5jzCZvgo2jK0dafgAIsYmdiwOfiCrr2gzyexxUkim/qJ2BgVEEwWHE97N6Lysi0ub6PRbDd6w31ooZZAWEEjbLz1/FlC3VasyjqZhewIIba0URH3mjXxbgnSaI+yCymvpu5QUE/wNGeLUtP3W4H2LuJ0F02cOvuPPCqH+Jq0/7M7lItUocm+UhodWz2/9VfRKg6KVNINS1LJ2AbrMVWO8PJVw+AxGnkZnKDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH7PR11MB5885.namprd11.prod.outlook.com (2603:10b6:510:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 03:14:15 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 03:14:15 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH v2] driver: crypto: caam: replace this_cpu_ptr with raw_cpu_ptr
Date:   Mon,  1 Nov 2021 11:13:53 +0800
Message-Id: <20211101031353.2119-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0055.apcprd04.prod.outlook.com
 (2603:1096:202:14::23) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR04CA0055.apcprd04.prod.outlook.com (2603:1096:202:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Mon, 1 Nov 2021 03:14:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f01614ae-d98f-420e-cf04-08d99ce5af1e
X-MS-TrafficTypeDiagnostic: PH7PR11MB5885:
X-Microsoft-Antispam-PRVS: <PH7PR11MB5885B61B4C5FA3B184695BE0F18A9@PH7PR11MB5885.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HdIoXXQl4AAM5PA4K2mzeqVRDDuseBnqtG25fBCwt6W5Uibs/E0C7XUEWKNa+2z7EMIdDIG07g9+Q1gCoVhs+9klS4Hkq+gm1LuxF70I2VEejjcRDFkmH4K5TsAwUf+iGe/KmGOmMsBQr7wbHKu8ZWpev6VtWsgApcl+aJPNm+LUSUxru80gMLfG+1WwZSe5UHYZ8Uk23tLJ1g6B7cD55uo3kvirvgtKoNRso0A+nNmODrrgZgeSDUL9lZx2vGoLE2jvU5+p23RCSorgVN8CZ9VpBL+A4V818AHZxqHY8/fYYT6U/OjGsJnT/vqv5IG4+RlePTUCDXlOvcPVDApnp0bWrZsEQ+8+1xXvZJnRoR1EcgsaJDVZpgMitX2+F+TIJ5heVADAYenZ5qBBTU34MM+k6nnhqq/2ksvM+APqnhiURnKnKf82gTzz0GqrxIwMOBC3xIru2/FwfWu6Rlc0XiZkpe6MUTih6/MEsSHISzXeoDQ/1CNT/A9ZPxX0FoVdoympnKlLzv1iKckmNV3YZSmGJAFIl0kq305Ku1YcJmsk0I0A3SqnmVV10/UOuJL4FvLi1TATf95MyZiGhC93Qyi8eA6viq/nvfEXyIW02G/WPXSdaZrplOlekRWOcdywSQVrFhdTl7x/Q4nie3XRBwlBWgLB137BAaciQ/ikPN5OgCQU8bDxBzxaMblDcbBmJDDtcn2Z3jd6oCqUYdynSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(8936002)(38350700002)(508600001)(316002)(6666004)(36756003)(1076003)(86362001)(6512007)(4326008)(6486002)(26005)(5660300002)(186003)(2616005)(2906002)(107886003)(6506007)(52116002)(956004)(66476007)(66556008)(66946007)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rVytjFLAPxXRmUTw/ZKMycWciqVFtTPDUNX4mlSSF4DPPaJw2KRlw9Da78Ne?=
 =?us-ascii?Q?Y90DMEbOCt6c5Kxd6gVsDnys5/RgSVl24N+CSII+W7R11JWP6cqFAJXUcREO?=
 =?us-ascii?Q?cy5iqoL0Lh2OxnYGpURdbYwZ8R84huVTVRw0DjL9+wCQIWox8i0/t4WTEqb0?=
 =?us-ascii?Q?dSMKn69hhel0xgTSX5NYYQpSdzegZZ7kdBqWHlPGBKd2x4ufjh/iI7G9kAW3?=
 =?us-ascii?Q?KmxW3KUZZ8kF++Ilh5/AtTBGSZbpPZterA9hUPhCV74G6KycG5tr6QKYmKwQ?=
 =?us-ascii?Q?s1L2DST40wLJ/9vnSMsr/LiAgTZFhm2PlitYeRodrkkX+E15KzmNrCD1MyhL?=
 =?us-ascii?Q?I6+QEIvXLbFc+GR7H8Fldecdr1sm9uEJ2+w3OJ6LJaE17Ry6gV3ZAqrbU85P?=
 =?us-ascii?Q?l1I47qhWRWVtyjaEITz5AiPYXZxOYJYlEWgCQYL7VhO39IT/NC2kxZqmWzxF?=
 =?us-ascii?Q?YrGr8N1FaJrP8h/LdDpCFtQqFbqPBOm3TRmPL+GsgvPttkZ4Bnzrc/rz5r2F?=
 =?us-ascii?Q?yO7YoBrarhzZz/hC/3m/vRbD7+ekVJKSPtf9xpxt/iEkve1TJ770Mvl5jQBD?=
 =?us-ascii?Q?B2n3IC4peaYmAKLjJQzyW3LsrnsbqdKvFgML/ShV+BZx34QqrtBzEEy2kFvl?=
 =?us-ascii?Q?XaKjf+OnDaJeNcXNb4MQjvVPJ6mzjsmSuzLnOdSOUFgjP0PZ9dNpNFy/tyT8?=
 =?us-ascii?Q?WW0uvfSyrur9ZyieCfS2p1R3hB8FJCZABWHa+VWKzAwtsFpPD9EzeDZjIg3S?=
 =?us-ascii?Q?zmFSjxX2EdYA+e5D3o+j/i/PtWcLKdDJ4E5pPI5RPkaubBM511fAB2l4R2Mz?=
 =?us-ascii?Q?avoU9rKDrJ97IzrScOp3TD/lqyWBMQstc68lpuQZfgYFdhBDf6mFaC6P3XWl?=
 =?us-ascii?Q?Z8T+b+wXKoyn+rFFS6AQRt4YXnON1DqDvydAHv2VoHtVQ7onoweEuagvaA3A?=
 =?us-ascii?Q?jmnokCtf+c+pyB0e1HUHfPOpGrfx/3GZaIKmeoxLLJtR7Z4H723vS1lV3j/Z?=
 =?us-ascii?Q?fiW/9FE01Fniz96oVS4VvwvjLmjJwRNhNfnOWi5rS5xtQMMS2ZKS7qFB9uPq?=
 =?us-ascii?Q?MytgjcZbSfubBanqIysCgAg0uI4QzTwpmNjatZy3gs00d3wUJqby1HlgjMiP?=
 =?us-ascii?Q?xac85DkfwHq+qDztgKe2iVUkOlnNRdTXjmApS+QjDpnR9eAqIP3WOZmQaH6N?=
 =?us-ascii?Q?bhYBXXwY7xLTH+EcqmYoN5o4E7QLNfKWCwQ3GV40X3pwE3UQotkPJJqcgBj1?=
 =?us-ascii?Q?+fdnRH5/wMC8TaVV5BYD4TA1HOmUtTqgFijAn1Usv4BRMqPAHnqs8KHiwdaf?=
 =?us-ascii?Q?AeAyL6jRPpQT/VOk7s/6X1TGbrBOhZdPYQ7JVVc5Ti5LtR13qAFc9eQYlGFn?=
 =?us-ascii?Q?1fW5fhVPSXNt+TnJKDyb6qC5mn6q3o3o3sgVBssz6IrMQDFkCFs1CUjvzuIm?=
 =?us-ascii?Q?vRJ48oFex97+Lht1UNXyF2tXcfNb4kwy1CGVUrNn6nABH0omWeJQ81lcdpd9?=
 =?us-ascii?Q?2iNSS1ZxxVLadotvpfqt+mTGoHTuG1yssw3MpOIPpwLR9o4DYoVxwupS3YL1?=
 =?us-ascii?Q?54mckukQ4DGcZV8WB421W9fj4JTnRosoWYo14dIFUcmbW3PBixA7hg0kk6d4?=
 =?us-ascii?Q?jcF0wHla+LuCx/Ne6/85KgQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01614ae-d98f-420e-cf04-08d99ce5af1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 03:14:15.0993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csrYJwjM54EKJtRUepDrOBypcIOg5fy7i0ZPacBMbxpDPAJVBj4FvyFE5oPiB7mBqtSWdc+Np3NUlvtWwwFlQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5885
X-Proofpoint-GUID: yTu88RdFAYC0KV2pEJf2BStMR9lmFfGX
X-Proofpoint-ORIG-GUID: yTu88RdFAYC0KV2pEJf2BStMR9lmFfGX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_08,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxlogscore=879 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111010017
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When enable the kernel debug config, there is below calltrace detected:
BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/339
caller is debug_smp_processor_id+0x20/0x30
CPU: 9 PID: 339 Comm: cryptomgr_test Not tainted 5.10.63-yocto-standard #1
Hardware name: NXP Layerscape LX2160ARDB (DT)
Call trace:
 dump_backtrace+0x0/0x1a0
 show_stack+0x24/0x30
 dump_stack+0xf0/0x13c
 check_preemption_disabled+0x100/0x110
 debug_smp_processor_id+0x20/0x30
 dpaa2_caam_enqueue+0x10c/0x25c
 ......
 cryptomgr_test+0x38/0x60
 kthread+0x158/0x164
 ret_from_fork+0x10/0x38
According to the comment in commit ac5d15b4519f("crypto: caam/qi2
 - use affine DPIOs "), because preemption is no longer disabled
while trying to enqueue an FQID, it might be possible to run the
enqueue on a different CPU(due to migration, when in process context),
however this wouldn't be a functionality issue. But there will be
above calltrace when enable kernel debug config. So, replace this_cpu_ptr
with raw_cpu_ptr to avoid above call trace.

Fixes: ac5d15b4519f ("crypto: caam/qi2 - use affine DPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
v2:

Add comment to describe why the raw_cpu_ptr is safe.
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 8b8ed77d8715..6753f0e6e55d 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5470,7 +5470,7 @@ int dpaa2_caam_enqueue(struct device *dev, struct caam_request *req)
 	dpaa2_fd_set_len(&fd, dpaa2_fl_get_len(&req->fd_flt[1]));
 	dpaa2_fd_set_flc(&fd, req->flc_dma);
 
-	ppriv = this_cpu_ptr(priv->ppriv);
+	ppriv = raw_cpu_ptr(priv->ppriv);
 	for (i = 0; i < (priv->dpseci_attr.num_tx_queues << 1); i++) {
 		err = dpaa2_io_service_enqueue_fq(ppriv->dpio, ppriv->req_fqid,
 						  &fd);
-- 
2.17.1

