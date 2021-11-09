Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FBCC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 09:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D4CF611BD
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 09:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244225AbhKIJyx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 04:54:53 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:43483
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243350AbhKIJyn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 04:54:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKvWjHCi9w0yX0V9sM3V+J2LzpAQ9MRdFeu96pqaJ8xaea/KZ+cYQQHKObsnZVT/6VUKw+bySGB+w7mPMcdAHZMMxAbATNm4wJTFvWH4h9aItvGGCVBdIXty5g9gIPcTbM5lpMDYEECwcXj7JwKL66wq6BEh8WzPm70tST9tuOF5ZrLtzgidnN9QteBe/LzvxnncwRtW+v5PATxA8SmIFaIbBJXZk73VJXEgOMWXofNg67Js3Q8tQtD+bfrNt69KP9P+AEFFz/7VQo9nk/+fqTTqC5nL0S/HMxZI04wyJEcYqQPn2t7Kq+JQIMcpZI9NyrwOlSOLDXnp8ddjfZoQHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Zlbe9OqPAdw+67MfEdGneW2oznQiLU0ygGzxyfU0VA=;
 b=gvPXiof4hUX1xIhMX8ak5E6sMqSYInoG4uVDQ7CRAvLPAGTc3Jj9wiATVZKrBLOo0CbO4Fx1gt0Pixl5ni/s2y+65bsLCWU/an+m1FLIUr5LSVmTZJ8cuxRmxrV0FTZllx9oMaV2TKrbIhQYnvoiIzaxbFuHo8X16D/0OxVR+mWl9iusH9oxpVOcz7/7zVCmDo5BiGi09x0RqXG1l9ccSMIrATd4k7Bk44cUjRF38zhpU22wQCM6qY9asv2R89hQHYZZtcRb5iWiIRl2X5oS2sc6MdT/iQBJmSQIXqtlJ9Huv7gGGAHMRia66BCTMrJ4OmIUzT10aRiHnsOwm+YcGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Zlbe9OqPAdw+67MfEdGneW2oznQiLU0ygGzxyfU0VA=;
 b=YuLBctJW55SbFY5FFbpqp9YXBKzEW2Z6JrVepQCD1/aqTH1cCu7qF9P390m3R9E+9sxHRnxe8stEK0g+a4hKhP+5pPSY9UeDEuse8o/yBpMFKn63ftZOSAjPqoq5HZF73fRc25BFuYdOVur9212OMywSUcK188LWI9TNdgPmQhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Tue, 9 Nov
 2021 09:51:52 +0000
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::6d1d:3624:9588:6a99]) by VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::6d1d:3624:9588:6a99%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 09:51:52 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH] crypto: caam: fix descriptor error when create ext4 fs on the device-mapper device
Date:   Tue,  9 Nov 2021 15:21:05 +0530
Message-Id: <20211109095105.203960-1-gaurav.jain@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0050.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::19)
 To VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16)
MIME-Version: 1.0
Received: from lsv03557.swis.in-blr01.nxp.com (14.142.151.118) by SG2P153CA0050.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.5 via Frontend Transport; Tue, 9 Nov 2021 09:51:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58eb13d9-8618-4185-6e5e-08d9a3668e69
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250935B5E6B2CA758BFD2412E7929@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvePfXQMhX33uWCEUKt/MxbXmLSSde3xbZrvpkMRroL/MpEqd7mVxZIxUw4udi8qs+U7BikfcmnjBg3cxapYe0AQttuR7lWBj2JIhBraRRJH/z+bAo7UMXJDCK4xa97zNTeytHWF6nqNdSgIzXysMn5YRMu691Q8m1DOayea5MqaK4PFY9L5sdEyJuOvPIaL6sYh/TDpP2EpwpQtJsR1oz26i3Ksp73lF6tNk/UEJ0TjjGt7qZw9cWioZaz+cbyBV5AYdKXh9OK4Pm2NSjElarXLAymgjj2gRSpPp3msShYLU87nIV7l0az3+dLTIze8NQsLdrDIL4XDfFBZNrR828Z/td3BD6DtQTcHPCVWUr7aWPlPN0KdHmbjlbFLSJrfBOogotwy7cS+Jxszf5CU+wk6b4pJjNeaDm5bjSFL+G6QkOFeeCrs/slWcxPW/hX/n7abSw17Pk+pGwhSoqbkQ7hwWsr2VPCTKUcgeUgNWZJXcd231gxc3X59dvZQOWoGt/RsImv1iAKTWQ6UMBDwj71FCZdWitG9i/OOiVpdyCydXVJq0dRK0OHywmoHzZSpOGAApiXd+DTl6NdWX1EAK+2o/o/+BrJCCcGNI6dho9Rhp1TMot17dydJ2GfrpcVJMQXhcfrVg83VCtO8sehAwgQW7+pvKyFL2iEyo0ZByfP5HtnQKoWiLrJ9oxRsc8+oE69CxKCcjLsizKNCRqIaK5HIAal+ZNnYbozfAj40WquMbyqq9au/7gM/4YhLJPD6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5342.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6666004)(2616005)(66946007)(44832011)(956004)(5660300002)(38350700002)(508600001)(1006002)(66476007)(6636002)(66556008)(36756003)(26005)(316002)(110136005)(186003)(83380400001)(38100700002)(2906002)(86362001)(6486002)(55236004)(8936002)(52116002)(7696005)(8676002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVJpeWcrZk5qUENWMHozajlKb1BpQ1BWbjNIUzhja2xtd2hZWFdHUXdka1VL?=
 =?utf-8?B?b0t2R2c3SHpWbVp6OW5XbThFb3M0UVppWE1wcFkxS2lsREVwcXFWZlVzYkdH?=
 =?utf-8?B?WUNwN2ZHd3VBcFhaWGMrUkpQZFVzN2VmZlF6UHo5T2haaDVHQVJ1eU1UVjZN?=
 =?utf-8?B?ZEt6SFpqMlRLOFlyTmQ3bm5nY25EMUFzZVpNRkpzWjV3M282ZGFHKzcxUmNS?=
 =?utf-8?B?OXpKN0IzTUxRbDkyYk1KK1JnOVBKNFFuRFI5UmVONUlsbTNvR2lzdHRVYTd1?=
 =?utf-8?B?NUg4U2d6NzRDUUQvdyt3RkFwRUtPM0VyeHFTS0ExYmp1NnY3RGo1clpHSFBm?=
 =?utf-8?B?SVZZNjhOaTBtamFpS1IzYkh3VklnNjkyRGEvZGFrcUllalVlcllnTlNLWDB2?=
 =?utf-8?B?YjY3TEE4UklWOE5WcFQ2OVpKWDFQRlh1WjM1ek5NL0wyc1RmL0E0ZE9aVXlU?=
 =?utf-8?B?ZTRyc3F3TFdwbXdZUTRLVUcxQW9hYm5tY3hIblZSeXFINGJMOGxQUys2QUI3?=
 =?utf-8?B?NmU3THp1alROZXJqaEVzK2tRazRtellpSmFjbGxxMjc4N0IwM2ZGWUk0TE1V?=
 =?utf-8?B?NEtuWVh5VFcrNDk4clkxMlBkMjVHMTJ4eGlVdnBWem9TWUs2L0RkeHZJZUky?=
 =?utf-8?B?UXVueDVaZDRidVhOSW1hSGw5UXZtWVZjOG1iU2NjSkNwSnJZcU5OSGhVSGQ3?=
 =?utf-8?B?c2wzN3ZqSGxtMVV6azB0cm9kb2FHMUZNSk9pVk5JOEhLRzZzSE94THdIL3NO?=
 =?utf-8?B?dEV3bm9oYWtZZXJXaEF6eXZLWjZ1cGVLNXM2QkZrczl5YnU3cyt2Q3BUaXpF?=
 =?utf-8?B?dUlhdjM1aHJEN2I2UktOTEUvZFpvR3BqWEx2VVdPai92cE5Va2crZjdzamRh?=
 =?utf-8?B?MnhIY1VWa0M4UmkwNCtrWlhqYUx6SWFWZ0d6TnhwNHQvVjFoOFFNQ1llakRR?=
 =?utf-8?B?bGkrc0VCQlZjR2JHb0pNcGorRFMwL1Z3SFYxQjVjUTQyUFNTaWo5MkJqMzh3?=
 =?utf-8?B?M3BKYm5GajVZQUNxNlRLaUpsdHVvQ215ejZiQ0s1RGNtMWxXdE5kam9pUnZs?=
 =?utf-8?B?QnAzUEQrZGpTeUl3Vjh4TmNtVkxxYVU0U2Zha2J2enNlTjlUSVFkVVJoMUtm?=
 =?utf-8?B?MnYvWHo2SG9yRGNxUjRvbXpaN2RFZzNSNE9FYTltdU16aEtGVzlra0pHakNQ?=
 =?utf-8?B?d0ZPTFBWTStObHREeHY3TjBsYWVYV0ViK01xdVBWM1NsaUpTNUdXendaN2Zv?=
 =?utf-8?B?Qk1ubVVRVG1KeE5GbmplMUZpRUs0MWlQaitYZTUwU0NaQVVXRDdMWkRqRHdu?=
 =?utf-8?B?U0R5M3dBaUI3aEYwMGp4VDBaalYrazI4ajY1Q2RqcjhJK3Vpem9DQ2NaK1JH?=
 =?utf-8?B?ZEZTaEZKVW05WXVBeEJFNTVXcHpvQWlubUFVZE1DbjQxdHJKOC9FMGFXWUg3?=
 =?utf-8?B?Z1NHM0txWW1WQWRaQ09FM2NpYW9qRUNrZTNsN2tHL25BNWpUdHlJTWZCS2E2?=
 =?utf-8?B?UnRNTW44SzBJR0MyVmVBclJ6cDBSdWtueEZhSldjN1V3dHJGaDNmSk1hWEU2?=
 =?utf-8?B?TU1oUk1wV01FdDh4UFUvMkFpdHVUSEpzS2Fzd0R4QUMwbUxxaGR3c3Yvc3RB?=
 =?utf-8?B?aTJuNzFCRzVIOHlJc1lTV0Z3bTVIWW5uZm9QTEpwUktGUTRzTTkrK1BlaS9r?=
 =?utf-8?B?eitoODlBeHFLbFNDcE5SbEJZd2Fvd3RUV0c2L1lxZm1qUWxMVmlEaVJSRUlx?=
 =?utf-8?B?UmlPNUZBMGo2RmZmdjdEdCt2VGFZT0ZIeEQ5ZmN5dlJTVmxyTk5POEtZTzJK?=
 =?utf-8?B?ZGpMQnVPaGQzZFZLUHcxTlF0UWFoRG45Y1hMdVkwci9FTmRDdC9iNjd2a3VU?=
 =?utf-8?B?Wnpnd1JxR2pCVU5mSmpaUzhMWGd4TVRNcjdBSkFoNnlTM2F6T0V2WnFiSlB3?=
 =?utf-8?B?ZlZtZ0NZMS9oNE81bDh5M3gyWDk5Uk5yQXMxN0oyYTNvL3B0UWNJU0RXVlYz?=
 =?utf-8?B?MnZJSG5QMFNIaEE3enJlTGRkbHNNS0lBRmRlbkpHci9tWFlBWlpYNkVXWm1Y?=
 =?utf-8?B?N3J0ZTFXVmNibUFQMjh3RXVFek1TTlJVV0NEZG1YYUp1UnVCUEVLT216QjRS?=
 =?utf-8?B?NVp6OGVaTWlRVVUvTmsrWmxxdEVBUmJUZFhOdFBLYjlJNWFnM3YxVHBRUG8x?=
 =?utf-8?Q?4pPOKIyoEyt+3QcaaHY073s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58eb13d9-8618-4185-6e5e-08d9a3668e69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5342.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 09:51:52.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATune+oEOzNkWygxVQfKSQ7z/mE8iYMjiyfq8PlTP7zsgav8lLM4uwX1xkP+AdwuqXV50l1gIfKfqJaN4dU7PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Root cause:
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

