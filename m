Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBBAC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB44619AB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhC3U3x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:45998 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229940AbhC3U3U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTI+Kue4caL4NwIYjx80jF7t6Q4EfH64EyXFh3l/Lvw=;
        b=ErK/nnXKXuaEGenH9IfDtw39kl3XkfZhj2i7lol9EBRNLVWolvK0DpW27LXsA9SqkzGPFS
        b/S3YU651JtBuYwgbLmS4Zwcbf/naYMEA9eScisfzvrw3QZjTVEO9cWP6s0v8J1S8l3oP+
        ffID6b+x+rTYqSyXm88idmGagZOfQwM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-CsY5ySJYN_CoxbJYMRAhtw-2; Tue, 30 Mar 2021 22:29:18 +0200
X-MC-Unique: CsY5ySJYN_CoxbJYMRAhtw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5+3ocyum3VEL2k4PQ6vFxp07ASWcvTzne4NAjFBKSKsbHNFUBPvN0nwHFOxAFrRcPQkSWIQVV2TdZueJ3WdQDKWFUDQGWMeGJidLAv+KfAVA4GZmJ1NMRW3ZxbqCHxRlnxjTQIow1S886s09t2jG39fnnxoN0emfOcX09HmcQyBA1AJwsQMOEZil/Vmy0VrmmDO9ki/2l4bxTVMAC2RrTXeHUGSSISblXQxFDj8uj/NVvCvLsbiebwSY2FZ2Cb91GcD1OmkjGjNCO2SRrFe28oKMm/1EvYJAFHsLmmSyXVZlW21pCARfeZmDqdX1LCzpcRPSsWevTI1TZ0S0qyHtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go62RgvgZYRNmgvLBA+9pJgp4Ydme7PneOiUWJL3Grg=;
 b=ixbrgLESwA3Z1mfU8EZDQjhx8+YazYQwODe0eaam074gzjhKKIIU78XVH0v0atjj+aaA2XZX6RYIeTm7eMXEGUvEFHlCfGhdFVU2ZX7InDi4bdKZFXCpcgRRyFWRo06guMrR1YtMUmlRSvUwByF8Z9jeumgYYVP4UncxKYeR5CH3FEq1hk7klZ3C8ZTPQHCUiif8fy8/aup/s0S1R7v+EpXeIDO6d81JwWCV9tcl5D4jTlInagt09ly3QBcmKIuCyKCMUBT9qKM9lg+aLvNKhWOu/PN13hmj1mVTA1IedIf9bnTTaDK9MiY9BQEZMthxrk+pOo2/2BQUl23XMBXDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 20:29:17 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:17 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/18] crypto: rsa-pkcs1pad: Rename pkcs1pad-specific functions to rsapad
Date:   Tue, 30 Mar 2021 22:28:13 +0200
Message-ID: <20210330202829.4825-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330202829.4825-1-varad.gautam@suse.com>
References: <20210330202829.4825-1-varad.gautam@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: AM3PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:207:5::24) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3663e654-c380-4554-a7f7-08d8f3ba7d8b
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB339324816A94FEF4F51DBD06E07D9@AM0PR0402MB3393.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dr5fCs0yoYWyXRmAPNNOumr0SHD1nw12dwP2pt2QzIxDOYt5/tE3Z7WUUl0vKu0N+cEnUvd0ypPBtBaaJ5ykIwZGlifSD3ZC/e1VxYGC5qtOZ7er/vWIW/dbTtRUTGdmWqqEwEbhxiN30W8jwGSMngDO2L7qlKHSzQ0ze9zUgHeRy+Es9vndGylj7MB4pGat0B+jMe8gbr/9mxmuxBqn6OT0Ru8S/wp+BGzffcAnhAJcP+NGRj+HgXjZqbcgRqwr44VGOfZRw79QmSmnU9ysTIhd0CxDPBmVMMQixdRh6PrW/jO2nUPjhNgrY0yzT/Bt5sBXaVPDI8SX1pPXivJKmgy0Y8TnG26MBuBiwckwbO8BCMQn/hAEGUVPGrrbjr2I0/cPxQy4T4jMFg44zZe1MrSxnqvTA1aZFx6+ORNkfYTyndyZsM7Vr1KvfwZGj8ddND811DqIvDNb30FRPp4AIsHMdQXnQaBRFE31Efxx5RJfKl8B0TD6fO4mzjsUwed06zppfzvpMSpHz/GgkrPnbIHevg+/mtsiPYf2B4NFbxi/nwezAqxxYank9AnmiC5wKbGB5lXp2x5AEFhf5V9chdmnC71ZRWIY9QAsWEAFA+MjNTeXBiGLcdaMKrpLPtjmEgI7tfecqE29gN2KezKjbpO1v9+6lyKqa5DtglCB+VciQvydnr0lYwTlAxXDdI3/4ditFO0mPWB+aVRGEyyMBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(66476007)(66556008)(54906003)(66946007)(6666004)(83380400001)(8936002)(316002)(6506007)(6486002)(1076003)(52116002)(478600001)(6512007)(5660300002)(38100700001)(36756003)(4326008)(86362001)(6916009)(8676002)(2906002)(16526019)(2616005)(956004)(186003)(26005)(44832011)(32563001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7ClfnlK/fVYDGsh06FEcAZlawtiuh2nR1YVy0jHsoQZe9NSDI4imhBB/PwcJ?=
 =?us-ascii?Q?k7DyAiE91aOKZ9opwpOP7L1d5HEn/XSwuB35/T86sk0vnVgTaUmtz0z+DVO5?=
 =?us-ascii?Q?G8Cerh7XGX8iHVSPPO8J2VVtQ7S6uKHU7AaLMzUP81Sdd28yb5tZ/+vTN92/?=
 =?us-ascii?Q?3I6CCAWUsMTXC58DqRz5BJx7VjHBgfM6IPTf7p/b4o4C8rezR9F/N65Xo0Xu?=
 =?us-ascii?Q?5e7wrvWBtb7qLSKS0hBBxZrBcCGjfyoCwXcvZwZSK4M4GlRNyabDOj0TtU34?=
 =?us-ascii?Q?YOBqAci8XMcbsuIVx4SchfyAYf4Sa3y9+iNCZDl9zJ4GmqZlEPsfzDKohMAg?=
 =?us-ascii?Q?xDmhscduMSgRMj/tPlpp6trJjLWBxHx5DNbPC539A5KpywvfEk7sjpw0d6Ue?=
 =?us-ascii?Q?uNi84W1B9b1pqNZBFDKHlGepHh2ZZjtTqV/rPEtyHAKl9VM6vrnHU6HQSSkc?=
 =?us-ascii?Q?Hic3xmx+bdJgDs+akYikbULS1x3l7Q9jyX02yDoouASscpoPOLfJ/kdVJGVM?=
 =?us-ascii?Q?Yl8pjZrHZnH6wngrRfv07NS7yHabfwZS6lYQxe2T9J4fEhQnl+4ZM2R/SZSf?=
 =?us-ascii?Q?Vp+b6YZQXogubNyOihYhRqqXpk2bja63aMbegMwWUKJcUPxnEA0nV/UE11la?=
 =?us-ascii?Q?VRVR+fBr7Qw7TttpMbBWGAxC32CIuYrVg3oDV7cFn4XO8VW5Smb99Fcejs9u?=
 =?us-ascii?Q?VgAtgCy3k/B8tpQ9PlHiLn6/3DySQlG1R2xVZupsrtZLJjkZt1/DdW3gZwKa?=
 =?us-ascii?Q?J/d/Gw8MfGe0eraR4tNzEikPplV2jQwgKc+Yo2f/4rFp0EM1di2RQDdb9Kro?=
 =?us-ascii?Q?yO+C0v5T5WfPuBka86m3PjT/DOAt06ZW1xBolahsuOuVSLq2OuFwCH6Q5xmU?=
 =?us-ascii?Q?U87cz+jb3R6y9SwhAO6JdQPbqcbdzZ712DzYNzD5J0lMrYUdlihcK607w3jB?=
 =?us-ascii?Q?IcGXTV0BbyME2IvrAPdbjX4ZB0Dz3xVFReKk2LSjobAd0dHm25ztfu7TGnCz?=
 =?us-ascii?Q?mvkwCdvZ0pNUQBXzPRD2aRShw9FiaYzWmELD3ZNkEotzpTwVhLWwV8ILWf61?=
 =?us-ascii?Q?+vbq2MU0a1kt1YTP28bYX453Gb6baXZr5RpURcaRBKXW8zSmUk0vBC1zPku8?=
 =?us-ascii?Q?26GDWcX/TBeWoMmPK5TQ9cbALXQicP0oiOUlqu7MxRPUBcydr+bNvTpM28QZ?=
 =?us-ascii?Q?ZtVTsnY91hsV03gfbWgxUuxDeQZ3dUkbUJlArFNODiL9N9SYorY9nnUpLehQ?=
 =?us-ascii?Q?GZOMC5Tc5hNUx9lwr24pPaxo8mpjVXihx4t4oR3rjLVVIpWIiBhVlKJQKFUh?=
 =?us-ascii?Q?33AoJwFS64rAjkH5yvo3ckEY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3663e654-c380-4554-a7f7-08d8f3ba7d8b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:17.0875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFpUpFJ/kC1tMzxGxfFoqJrpdOFjeLAesdbnZGMU0FIVQ1sSRO9i+hB/fRPqpE3Tlzk6hsI5jHvBzQvAbQUGgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The existing RSA implementation supports PKCSv1.5 style signature
paddings via rsa-pkcs1pad. A lot of the functionality implemented
for rsa-pkcs1pad can be reused across other RSA padding schemes.
Rename such functions as rsapad_* before moving them out of
rsa-pkcs1pad.c.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-pkcs1pad.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8ac3e73e8ea6..83ba7540a53a 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -104,7 +104,7 @@ struct pkcs1pad_request {
 	struct akcipher_request child_req;
 };
=20
-static int pkcs1pad_set_pub_key(struct crypto_akcipher *tfm, const void *k=
ey,
+static int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key=
,
 		unsigned int keylen)
 {
 	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
@@ -125,7 +125,7 @@ static int pkcs1pad_set_pub_key(struct crypto_akcipher =
*tfm, const void *key,
 	return 0;
 }
=20
-static int pkcs1pad_set_priv_key(struct crypto_akcipher *tfm, const void *=
key,
+static int rsapad_set_priv_key(struct crypto_akcipher *tfm, const void *ke=
y,
 		unsigned int keylen)
 {
 	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
@@ -146,7 +146,7 @@ static int pkcs1pad_set_priv_key(struct crypto_akcipher=
 *tfm, const void *key,
 	return 0;
 }
=20
-static unsigned int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
+static unsigned int rsapad_get_max_size(struct crypto_akcipher *tfm)
 {
 	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
=20
@@ -159,8 +159,8 @@ static unsigned int pkcs1pad_get_max_size(struct crypto=
_akcipher *tfm)
 	return ctx->key_size;
 }
=20
-static void pkcs1pad_sg_set_buf(struct scatterlist *sg, void *buf, size_t =
len,
-		struct scatterlist *next)
+static void rsapad_akcipher_sg_set_buf(struct scatterlist *sg, void *buf,
+				       size_t len, struct scatterlist *next)
 {
 	int nsegs =3D next ? 2 : 1;
=20
@@ -256,7 +256,7 @@ static int pkcs1pad_encrypt(struct akcipher_request *re=
q)
 		req_ctx->in_buf[i] =3D 1 + prandom_u32_max(255);
 	req_ctx->in_buf[ps_end] =3D 0x00;
=20
-	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
+	rsapad_akcipher_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
=20
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
@@ -357,7 +357,7 @@ static int pkcs1pad_decrypt(struct akcipher_request *re=
q)
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
=20
-	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+	rsapad_akcipher_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			    ctx->key_size, NULL);
=20
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
@@ -415,7 +415,7 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 		memcpy(req_ctx->in_buf + ps_end + 1, digest_info->data,
 		       digest_info->size);
=20
-	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
+	rsapad_akcipher_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
=20
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
@@ -545,7 +545,7 @@ static int pkcs1pad_verify(struct akcipher_request *req=
)
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
=20
-	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+	rsapad_akcipher_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			    ctx->key_size, NULL);
=20
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
@@ -564,7 +564,7 @@ static int pkcs1pad_verify(struct akcipher_request *req=
)
 	return err;
 }
=20
-static int pkcs1pad_init_tfm(struct crypto_akcipher *tfm)
+static int rsapad_akcipher_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
 	struct pkcs1pad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
@@ -579,14 +579,14 @@ static int pkcs1pad_init_tfm(struct crypto_akcipher *=
tfm)
 	return 0;
 }
=20
-static void pkcs1pad_exit_tfm(struct crypto_akcipher *tfm)
+static void rsapad_akcipher_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
=20
 	crypto_free_akcipher(ctx->child);
 }
=20
-static void pkcs1pad_free(struct akcipher_instance *inst)
+static void rsapad_akcipher_free(struct akcipher_instance *inst)
 {
 	struct pkcs1pad_inst_ctx *ctx =3D akcipher_instance_ctx(inst);
 	struct crypto_akcipher_spawn *spawn =3D &ctx->spawn;
@@ -656,24 +656,24 @@ static int pkcs1pad_create(struct crypto_template *tm=
pl, struct rtattr **tb)
 	inst->alg.base.cra_priority =3D rsa_alg->base.cra_priority;
 	inst->alg.base.cra_ctxsize =3D sizeof(struct pkcs1pad_ctx);
=20
-	inst->alg.init =3D pkcs1pad_init_tfm;
-	inst->alg.exit =3D pkcs1pad_exit_tfm;
+	inst->alg.init =3D rsapad_akcipher_init_tfm;
+	inst->alg.exit =3D rsapad_akcipher_exit_tfm;
=20
 	inst->alg.encrypt =3D pkcs1pad_encrypt;
 	inst->alg.decrypt =3D pkcs1pad_decrypt;
 	inst->alg.sign =3D pkcs1pad_sign;
 	inst->alg.verify =3D pkcs1pad_verify;
-	inst->alg.set_pub_key =3D pkcs1pad_set_pub_key;
-	inst->alg.set_priv_key =3D pkcs1pad_set_priv_key;
-	inst->alg.max_size =3D pkcs1pad_get_max_size;
+	inst->alg.set_pub_key =3D rsapad_set_pub_key;
+	inst->alg.set_priv_key =3D rsapad_set_priv_key;
+	inst->alg.max_size =3D rsapad_get_max_size;
 	inst->alg.reqsize =3D sizeof(struct pkcs1pad_request) + rsa_alg->reqsize;
=20
-	inst->free =3D pkcs1pad_free;
+	inst->free =3D rsapad_akcipher_free;
=20
 	err =3D akcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
-		pkcs1pad_free(inst);
+		rsapad_akcipher_free(inst);
 	}
 	return err;
 }
--=20
2.30.2

