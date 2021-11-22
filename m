Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46D2C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbhKVLgT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:36:19 -0500
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:29765
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237476AbhKVLgS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 06:36:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DptEv5Dh1Sd0rq4V2H4a9o3BgEQs4rfICmn5AMsl5oCWApTsmNj/pSbQT5d/85h88PD6eJqCXOj7GKdg4RFBouJKuovdS0tuxPL2OQBEUm8fut8sAewBoqcuucaT7sx8J1VzK66Lye5HPQclRvy4eqWmUBDReAIi8ixj1NtIh1bDnNyutlRM9mmOA1FfOYA5POBr6whaunle9xP84oc/s+9e3XLLosSOpozBYSyd9Ep+5RsBbaCNQ5rRRpiaiLhuCfknQoUpmCmfpe+zDTwjO17QnnPQGV0awBf8XSIR/pl8cio/KayY5CQUZqq1vrOwGm+38tF24SkqHVs7QLd94g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRUDTX+UDB/zv/LbERwPwEHYTzhENEC1bF11+aDDEvk=;
 b=h2y56oXfVfRmZzcJqKjJv5XthUYr3Q91b2XrTFHtX4xPHY6HJo0Vo/TO7Ghe35Q/VUOwy3+GshUTvr65Qk1mpmaHeIK5GzAiT1P0Nphq8iTpyY74JgG178tdmkQFU5d1kNbR3nd81a6DqKt1K6Z1sEy2hB9nx9WGS0lIxyx3OtMyc2YmR4EiYNe5WwAwnKfknQJsbBjrz77Wvunh6mqcHzY4pAM7Dsh2ANZuzWwfJJBle6bC7gOkKlrFCRzHYdhCLQ1KwshtxoIZFYCy6QEVk2rgHyk0MX8C+YR/6oGGYXIe5bvg+hKMaaTKdt+McLgDB+OX+lIKuwBLfyLT5j4DUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRUDTX+UDB/zv/LbERwPwEHYTzhENEC1bF11+aDDEvk=;
 b=op3sxGf9srbYjr88oFLmLFjpaa2LBdZck11NUTt8F5QiAa14RoUh3VKYuqhyxhr6tMPHmgLoRuzQ6u+ajBPZFUTYnwl+rmCBxphL9LjydYCk/pJnn8HFOUyzp2MC6ZFrSd7h7VEeF7fMDL7PQ7H/HvDHJKAayviJdOrn15D6vF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:33:08 +0000
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::9c7:29fc:3544:10fb]) by VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::9c7:29fc:3544:10fb%3]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 11:33:08 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH v2] crypto: caam: save caam memory to support crypto engine retry mechanism.
Date:   Mon, 22 Nov 2021 17:02:34 +0530
Message-Id: <20211122113234.851618-1-gaurav.jain@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR0302CA0006.apcprd03.prod.outlook.com
 (2603:1096:3:2::16) To VI1PR04MB5342.eurprd04.prod.outlook.com
 (2603:10a6:803:46::16)
MIME-Version: 1.0
Received: from lsv03557.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0006.apcprd03.prod.outlook.com (2603:1096:3:2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.17 via Frontend Transport; Mon, 22 Nov 2021 11:33:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea3588df-12cf-4a2f-3b6c-08d9adabdb7f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5502EF5598A246C5524DBFE9E79F9@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3JAje0aX4yClBbSC0TpiwWKq+goevtDWdit3sT74bZ548ZZHtgXtNMXu2GA6yc9J1QdAE0wD7FMdCMGWSgf+1/CivKmELJO/QjU92XMD8Ik9sum8s7fJvOY1y0aMyRTXe/r2udK2Edvdr93YgW0EKA3jbo1jJIa+UmuKrkDW1RCNR0O59g7LgzSApjhsouTHiT9Bg257hM++7AbHKG0CZIAmkMsyjZOhT+FZZ1Psu9BD75YRis8XrBkfHHKAt7ZeEJZXMlKUoW/cfT2j83W/RByKuSXoKQvBee+SuUjHnmbdVaGCSBV+pfk8DLmUG9BR8VFdjgPB4oCEOmsT0dh20kLf2hKCS6NoTX9j+HMd5tDG8aIKWd+zBRGIwWDTtAJN7/wYEiqgbWWQwGKathO+CFQgd7UujDg0X+9y2rNwnDI7kvKitzFaxXuvBuA5p1D5naq4sfFmrb1aCEqjpF1gIZE/VXkPVv6Q535zUnUISEYA4vbjyBaFs4OM0t5+0xWIanidK7rbYWKI/dpJxze/dYLS65PpMVp+VrCOaCS472g9FqJG3Glf5+Us2E3ay38EljF90UMQn9ghJ8iO9tRBxs8IV9L05MzDoSAWyBqHHEnt0MIaX+/4bvNWhdDcNcxroi1/xnmg3y/3xTyWkZSQZQwl1vnh8KUrdXovuitIgCstg/ZV/+m78Zr/egGHpBOLhhp5srT7Bw42gH90EG9FvcL+fs4c5OczYhwYKRg+gE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5342.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(5660300002)(36756003)(8936002)(4326008)(26005)(186003)(8676002)(1006002)(6486002)(38350700002)(956004)(52116002)(2906002)(7696005)(110136005)(1076003)(66946007)(6636002)(508600001)(66556008)(86362001)(44832011)(2616005)(55236004)(66476007)(38100700002)(6666004)(316002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDZLbFo5NGpYWTFnRHdBbHFUdmh5S3lHK2EwV1RpQTVYcU5veFQ3R2pUK0dv?=
 =?utf-8?B?Vmh1b3dic1FZKzlPZkIrSEhPMCtxV04wMHp6N25pL3pHTzVIVTJubWUyNzkv?=
 =?utf-8?B?RU1na1BZSTVVVHNaRmNrTHpZOGYxZWIwMjQzN3I2cFJmRFVDMGJaZURmcVdr?=
 =?utf-8?B?OHBGV3UwYnJZZXVDbjZOOUxRV015dnBRQkY0VzFla2xEWnh0TFFhSlNOSHJM?=
 =?utf-8?B?cXoydnNkWmN4U2NaQmZCcFVTQmFHVTVaaDlDcDdsRFZmZVAxV0RuVWV3QmJQ?=
 =?utf-8?B?a1R3NTBTZmdsMjJZY1Z6MVh5U1FwQzBNYUN1YVdGZVpGenVJN0VjTldJTkxy?=
 =?utf-8?B?RDMyTC9qZ0RDeDRYSFZ5Y0dSTVBvRmRLL3hnamlKSG1JLzhvemZTdzJsOWph?=
 =?utf-8?B?TWE4Z0dtekQ3YTByb3NqTzFMNmlVWmFjWjRoems0cS9ScmtiT2RQZWpnOUE0?=
 =?utf-8?B?b1AvSlJxbFVuakdNM3Jzb2V2bW9XVXNhT1FJekhCeFFVYS9MYUxWNnVUVzVC?=
 =?utf-8?B?eko3QUZ1YjFnNnhoaEpzNk56T2V6M2U4eXJxdW8vRTJHWWFvZUdzQXlBL2RZ?=
 =?utf-8?B?S1U4Zk9KY1lveHd6RmF0ZElVYXRNb1k3QXJscStXV29wOHVaMzUxVmhQVVJV?=
 =?utf-8?B?WWZ5M01Od2NqT3JaeHVDMDVHbERmamJxNWUwcHJ2d0U5bU1jN1dTY0ZyZXBu?=
 =?utf-8?B?L09nY05VbGZOSmltdjN3UWNjdHhYMFlWbkZ2U0FweG5zN2pBTXdveWpVYk9Z?=
 =?utf-8?B?L0pxMlVLSzIzRU5TcmZQc0pkdE14TGIzMCtEMXg3WXZuZHpUaUtIRkh1QnE2?=
 =?utf-8?B?TkR3bjg3V1JNTVpoaWxMeEU3TVF5TGUxdytVdmhLS2RyY29RNzZsR0ViYjl4?=
 =?utf-8?B?OUtUT0VnTUZRWXZ5YzQvVjRzSnZ5a1FPVUdkak9nRXF4ZUxnTEtXTjFFZ2N1?=
 =?utf-8?B?amswMm5YajkvbWYrVEMzRjJJUnBTNFpjdm8xcXlxeDhIcFFpeWo2THlROFVU?=
 =?utf-8?B?Yk1sKytsd0FqZzNvRkVUNThHSDMxZHl3dk9KTENMUVozaGxMYjMxYTgwMDYx?=
 =?utf-8?B?NThRZ2V0R2ZUUGx1eFFjcmdIcG1ZQi9OeVFTak1UMzdUS0FiZDZaNnhid3Bz?=
 =?utf-8?B?NTJHZjBiV0sxRWZxeVJsb3p2MDlodWhpSi9SUUVpM3l3eC9xejB5ZXBIbGVm?=
 =?utf-8?B?UXp3cVR1YUsva0xIN001RW9PL3MveHdaV0hsMWlEaEErWnROenlxQ2FhMUNh?=
 =?utf-8?B?OUp2dGQwSlZ5dERCY0d4L0F3bVU0aEFSOGhoVngzcGJSVXlIQTd5ZkhHT2hh?=
 =?utf-8?B?aHQ0bHJSbERPb0VMMzdXbG1xNjI3SkJ3bzVhQjJPZTBYSHVhcExWU3FPU2Vj?=
 =?utf-8?B?RXhWUThMdTVvMFA2ekN0QlBHL3lRT2tmWk5reEFTbnkybFk5QWU2WExuV2c0?=
 =?utf-8?B?eHk2a29NYVNMWjNyNlFTaEYya2JpcnlnRXZuemNVd2FrMmFhWEhsVGFJNW5L?=
 =?utf-8?B?S0dNTzByZElSdmNVVnVZSS9Gb2VkbXlNdHBBd3FsMkMzWUhxOVRqdFJxZTFB?=
 =?utf-8?B?ak9sYXJpY1NUc0U4YUdhNWNaTkcrRjU3b1gyNkd6c3lBM1V1aVphaFlSTk9k?=
 =?utf-8?B?VlVWSDBsY09CN3RxZVpISmI4M3ExVUQ3K1BSd0ZnSFB5cnR5MzZQaXNGVFN1?=
 =?utf-8?B?elZBNWxOOVhSTmpPc1F1NDd3N0JjYjZtaXJra0dnTHV0b3ozaHZhZWk0Zzhy?=
 =?utf-8?B?WVErbUtCVUZhMGlxSTJSQVpIcUpibnpSZ096YWtUeDJCVTljVFFUdEgwMzVG?=
 =?utf-8?B?ZE9XS1NWdEF3N2l0bTh5T2g5N0FkQVdOUWZJd1hBSFFYZGhHajQ0VFZsSFFC?=
 =?utf-8?B?a0ZUQXozdkkvOXpiNFlsWmRmOS91b0c1Y1Rmai9QcnErNVJ5Zi93YWJza2M0?=
 =?utf-8?B?QXRWWkFOTmxWRGRvcG5tajhycEd1YnNJcHJjQk0wK3BJWGdvY2licEd2MXQv?=
 =?utf-8?B?VUxSUkltOVdVT3ljcTJueE5nb1U2d0h3K3BEWnVvNUV3SUpRcmN0SkQ4SVFZ?=
 =?utf-8?B?Zk5hcmF6aTNZdXBRWFpTNDYzRWJaRHI4UzhDR2Y0OU9vRlhydmZCTy9HdFB1?=
 =?utf-8?B?aDF1eHdrMkVDd0hGT2dNS0xvazFoNlJ2SlBGWHV2RDJUWkp4U1VlS2VzdHJ6?=
 =?utf-8?Q?qOGhiQXuSXcGz+cJ85X8c+o=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3588df-12cf-4a2f-3b6c-08d9adabdb7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5342.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:33:08.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HH5+MFC3Bzj+WGXjbDa1MfQL9ExhwawSNuQPDXid4agx92wfrl4CQNONTxHJiFLao5X2WeaPs3wECM6jTMIeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When caam queue is full (-ENOSPC), caam frees descriptor memory.
crypto-engine checks if retry support is true and h/w queue
is full(-ENOSPC), then requeue the crypto request.
During processing the requested descriptor again, caam gives below error.
(caam_jr 30902000.jr: 40000006: DECO: desc idx 0: Invalid KEY Command).

This patch adds a check to return when caam input ring is full
and retry support is true. so descriptor memory is not freed
and requeued request can be processed again.

Fixes: 2d653936eb2cf ("crypto: caam - enable crypto-engine retry mechanism")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c  | 6 ++++++
 drivers/crypto/caam/caamhash.c | 3 +++
 drivers/crypto/caam/caampkc.c  | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8697ae53b063..d3d8bb0a6990 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1533,6 +1533,9 @@ static int aead_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(ctx->jrdev, desc, aead_crypt_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		aead_unmap(ctx->jrdev, rctx->edesc, req);
 		kfree(rctx->edesc);
@@ -1762,6 +1765,9 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(ctx->jrdev, desc, skcipher_crypt_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		skcipher_unmap(ctx->jrdev, rctx->edesc, req);
 		kfree(rctx->edesc);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e8a6d8bc43b5..36ef738e4a18 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -765,6 +765,9 @@ static int ahash_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(jrdev, desc, state->ahash_op_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		ahash_unmap(jrdev, state->edesc, req, 0);
 		kfree(state->edesc);
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index bf6275ffc4aa..886727576710 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -380,6 +380,9 @@ static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = caam_jr_enqueue(jrdev, desc, req_ctx->akcipher_op_done, req);
 
+	if (ret == -ENOSPC && engine->retry_support)
+		return ret;
+
 	if (ret != -EINPROGRESS) {
 		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
 		rsa_io_unmap(jrdev, req_ctx->edesc, req);
-- 
2.25.1

