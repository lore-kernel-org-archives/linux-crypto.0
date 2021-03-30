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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66FAC433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FA1461989
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhC3U3z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:55 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39391 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232416AbhC3U3X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0lVu0kNchvYW/X5Tf1wjeKmtDGbtUc56LRj2YTgqL/4=;
        b=Gl3a/C2wRj1w8+5C9+TwO26XoMLhj0bhQI06H1llRYPDKtY9vn5UiXyZevJ2p/flf3+MZX
        NY+WuiR9PIKtcx1b5EaKFl+82bO9WUaW2du8pHsVf/njFqFyLutXKc7TKIiJBDXa9ldWOq
        0BVcjdzKjDivRed6DirH+zzomcCfmDc=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-4wsP7MJpOj-Bt2tGbS0PSQ-1; Tue, 30 Mar 2021 22:29:20 +0200
X-MC-Unique: 4wsP7MJpOj-Bt2tGbS0PSQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QANK5DHrX3VqXZUFgIrEAM9gmNWRUnnO8j9jGOAasLyLwldEYy5RpRT3lGriwZCt4+ixcv7NNZg2FcO1eGP7q/Xg3bGn49EbalaSaHh9Q7LmEy0FhcrriwFCz2npZwk+sBX0kxO9fgLkTq8fBzWjHPn+/Vrs0cDO0FKxldIXvD/latSBqZPyaLHquAHlva3/JuVEaRGIYb69je71u2thwdbbOhp4rhvKZi1J8tIrRW+z2wRgJg51ZwbX1uduUvKsxXQ9yk9zQMSTlmW6fSPCR8VB68rXyFmv4/COjWMBXEKiNRLxvApUnVfzl+yNAtQlbsClkh0JSpVOvm7pLyzC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxXb7YdJtc7JgFY0x+ZjWZpHV3wSedJnwe7QRQoiKWs=;
 b=KVelIHL3NgUuyOi75T+gQoUhT8hUSEFgMF09t90QA5rlUluDx2C1pv6AkvgnNODZ07dWZd1oyLSMn/SHvv0EP9u0vAtO2SgSEUvjEJq4iAteTzBbA1tOmhWzJWD9s87mWcyBsIZ+HuhjjjmG9P34omhIAXGo+oYjudwYuTJ7RuN4IORt12goKPA5+jZuf28UbaZNzyDarjME0zc1bqxUWzu7wKA6ykWFEq6uH49jgMNRAH7ZZ4YvBX6Ik0GQUiFotv6gW5CsiTuW+ZlBuhSOrYqUz3HfeLIy9KtNMQ951VXJqGNJL2xP1ussbyOJgXaCBMbOCPUZcUTe8Of4kVBI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 20:29:19 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:19 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 04/18] crypto: rsa-pkcs1pad: Pull out child req processing code into helpers
Date:   Tue, 30 Mar 2021 22:28:15 +0200
Message-ID: <20210330202829.4825-5-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6be7db8c-d37c-496c-1768-08d8f3ba7f17
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB339391CA2F3814AB79BB77A6E07D9@AM0PR0402MB3393.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pDxp6y3WH67HsXJQ3V30naVbl6HJlq9jaE1VR+Ypn4MbDvKpxN3hovYXeYEWIK0Vmg8IldkFUGRhPtD8NVwZzz7OmLrP3FyyYqut2mpSYkSxbXS3HSEkfmzJq6FIPHRtw8FmJ/aWgZMFYM24aybCvg3wVmpe0+6nAxJWfE0C8OPvL6S5cq0kxpU5X3P0tnOChW63/Xt9I0iHpSZ0fZ65YY7W7p9/zf68RyJE/v0FcT4n5Qvfwk5sefK1YwE3oqI00iVj+8bq7luvMmufCj0s9vJVceQXTTI4pZPxtxgDsmCPxQtHuaVmqtum8j/Uu3Qkw1LVcbQxe1ceBppsUPq4PaxHSq+WuKW3pjeDbh3ngPftaEOGrXUqrr+sb2iHkV+1v02S/Q0KuW514mefgNI5o1PWpqklDophqtZ5p46VshIv1m0+yHogVNw4d2tinP1VRAQIKG9cshiTjx/1kheCdxWYCjqMmbhTVWdCItRUFI6g1PyPHSV9G/AkQ1e5CGlRVAc+mAgcacMO9Q5NwKfdfOueK3l/dfTFRqXl0woGM0sqkYrQgYDWHLDEXbtn/r8acZ0pRvqVSXm//cUPlJwjpPFUIo/W+Y5xEmm3zXtvaxaW140br5WTv6N+nnLZYmbemMoLuxZluvETNYPq7IO858nHRSJlb7OJoJ8IlUfRBR/8kNJ7qu99l9P4o0nQo/hu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(66476007)(66556008)(54906003)(66946007)(6666004)(83380400001)(8936002)(316002)(6506007)(6486002)(1076003)(52116002)(478600001)(6512007)(5660300002)(38100700001)(36756003)(4326008)(86362001)(6916009)(8676002)(2906002)(16526019)(2616005)(956004)(186003)(26005)(44832011)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9kFxzxq0DcVMPsRCBCKlEqLY0CbEe3mNYob44lM19sRQYhbi30AGbSZ1wxLK?=
 =?us-ascii?Q?S71AQgT673xN7/SPAgUI5G5BvGlu281qJCDM5335XyftNmU8LlGqHMEC1mql?=
 =?us-ascii?Q?Wh2Tql/syi7b+OLf441GxA2iHHvgJu58K/oGSwf++hwBEoWHJx2ySQNRYHVG?=
 =?us-ascii?Q?t24awFt5K+ZlFY9IKb2EExgZi2re5aNAuotr5DDvPO1sq9ii3nNbpoMYW+fx?=
 =?us-ascii?Q?4Wss+PRZkjfWKBsJQPVbKTwgEjUkUDeHqyi3PBfwU57HHCZlhXZMvqqAbxCU?=
 =?us-ascii?Q?GLk61Ajv2s3REKWWX7nnMtWQLYb0qaRluLcdFD6G+c8B59dnvwlDRHyGDO4m?=
 =?us-ascii?Q?d70XUTi/OS9cuQp5Ul7fZoKkvYI6q0nawEMxTVoS6Iu1OBycgVpFK8HIk86p?=
 =?us-ascii?Q?jeGdKgzFH8vVp0NM/7oCYIfmgwHp7yWFv/3TZRZBT6eRiHvWUyEwz6in/bsM?=
 =?us-ascii?Q?vkqkBxUXGhMzsKhP9MJDft8eBechPbJrGq8ySpon69oZTyAP+ZmwP4Cxj2mF?=
 =?us-ascii?Q?oFQe55RNvBnNcySvZp1lG8Zos4zHy/6siJvuLej8/w7fK7tiNRwGD4EcTFVy?=
 =?us-ascii?Q?ZKNuxsF5tafLhl3rHGyEtbg4RfJpxm5Bc5asmHA9D2Aj9+WK5Rs8oxni3VQv?=
 =?us-ascii?Q?hwP7KpTS1MABZNRkdFBE5QpVcDSmHfD5aktsjQd1qY0p0UORmThJ5xAtuXzX?=
 =?us-ascii?Q?ILvrsdzR5SX3jUZg36D3q8sU5s+iFiQqnhNy79Lg6BClhEpDYcWOcG7pn58u?=
 =?us-ascii?Q?aFy4xkVfD7qHg+biQf9MMnH0gQYJ381mbSHDzTK58EVRYvM3H8+wdxPqOMO4?=
 =?us-ascii?Q?6QV8v0DSCH0nlCEHiX29692w9lMHPck8OmoSwks+cFuv5m1Ivh8l2AwTaDz3?=
 =?us-ascii?Q?O+1dw3qgnfxlwtW4l9pQDkSAm6hP6hvFopvIGeN70g1sw7TsYYt1K7vhzq17?=
 =?us-ascii?Q?CXAo7oU1+evbVVX5uvp1Z7tWNRtd6X/GX86lr7D0pIpRf6D2WdGBZDbUeI/Z?=
 =?us-ascii?Q?lh20ax3mJFdAaL5MH4d4N7M+OaNUU63zeo9QbaY7oKT1zraky1I4gbzc/qvE?=
 =?us-ascii?Q?Tfkt3pjzSK/FbiYrR8hOoLIsuw03Q7DU1/djkIKCjOSdVpOJeTP0H8wtu5A9?=
 =?us-ascii?Q?50uFAwQwsXWz+226iyRfO7+OZMsS+1j69xk7bw3P5Kfcn5hzp/pvJ2NudJrH?=
 =?us-ascii?Q?lIp/lLz3okCijuIKVMU27qRwnCxlIbPPil84ZJUyuGzD7F7dfFt5HzT1+qN1?=
 =?us-ascii?Q?4yOr5VRvuYjw4d4MwbO2Hm1YlT0CdMhVA85SXtzuZ6NCRp7qEzQlI94Y8UUz?=
 =?us-ascii?Q?/jwOIqrFBbNqRZwkY2dBW1rj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be7db8c-d37c-496c-1768-08d8f3ba7f17
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:19.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1zyh2J0dZJhysxkrgg+s/VAt6xBKsxaYbtbSmXyiMIrWLeU7bZs3Rt4TfjBso5s1CjaxcVTDtRI0FTCVF+OKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rsa-pkcs1pad operations that require using RSA primitives rely on
creating an akcipher child RSA transform and processing the results
in the operation-specific callback. Add helpers
rsapad_akcipher_setup_child and rsapad_akcipher_req_complete for req
setup and callback handling, and switch pkcs1pad operations to use
these.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-pkcs1pad.c | 106 +++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 849573f6b44b..6329c79316d2 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -171,6 +171,38 @@ static void rsapad_akcipher_sg_set_buf(struct scatterl=
ist *sg, void *buf,
 		sg_chain(sg, nsegs, next);
 }
=20
+typedef int (*rsa_akcipher_complete_cb)(struct akcipher_request *, int);
+static void rsapad_akcipher_req_complete(struct crypto_async_request *chil=
d_async_req,
+					 int err, rsa_akcipher_complete_cb cb)
+{
+	struct akcipher_request *req =3D child_async_req->data;
+	struct crypto_async_request async_req;
+
+	if (err =3D=3D -EINPROGRESS)
+		return;
+
+	async_req.data =3D req->base.data;
+	async_req.tfm =3D crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
+	async_req.flags =3D child_async_req->flags;
+	req->base.complete(&async_req, cb(req, err));
+}
+
+static void rsapad_akcipher_setup_child(struct akcipher_request *req,
+					struct scatterlist *src_sg,
+					struct scatterlist *dst_sg,
+					unsigned int src_len,
+					unsigned int dst_len,
+					crypto_completion_t cb)
+{
+	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+
+	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags, cb, r=
eq);
+	akcipher_request_set_crypt(&req_ctx->child_req, src_sg, dst_sg, src_len, =
dst_len);
+}
+
 static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, in=
t err)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
@@ -213,17 +245,8 @@ static int pkcs1pad_encrypt_sign_complete(struct akcip=
her_request *req, int err)
 static void pkcs1pad_encrypt_sign_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
-	struct akcipher_request *req =3D child_async_req->data;
-	struct crypto_async_request async_req;
-
-	if (err =3D=3D -EINPROGRESS)
-		return;
-
-	async_req.data =3D req->base.data;
-	async_req.tfm =3D crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags =3D child_async_req->flags;
-	req->base.complete(&async_req,
-			pkcs1pad_encrypt_sign_complete(req, err));
+	rsapad_akcipher_req_complete(child_async_req, err,
+				     pkcs1pad_encrypt_sign_complete);
 }
=20
 static int pkcs1pad_encrypt(struct akcipher_request *req)
@@ -259,13 +282,10 @@ static int pkcs1pad_encrypt(struct akcipher_request *=
req)
 	rsapad_akcipher_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
=20
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
-			pkcs1pad_encrypt_sign_complete_cb, req);
-
 	/* Reuse output buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
-				   req->dst, ctx->key_size - 1, req->dst_len);
+	rsapad_akcipher_setup_child(req, req_ctx->in_sg, req->dst,
+				    ctx->key_size - 1, req->dst_len,
+				    pkcs1pad_encrypt_sign_complete_cb);
=20
 	err =3D crypto_akcipher_encrypt(&req_ctx->child_req);
 	if (err !=3D -EINPROGRESS && err !=3D -EBUSY)
@@ -331,16 +351,7 @@ static int pkcs1pad_decrypt_complete(struct akcipher_r=
equest *req, int err)
 static void pkcs1pad_decrypt_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
-	struct akcipher_request *req =3D child_async_req->data;
-	struct crypto_async_request async_req;
-
-	if (err =3D=3D -EINPROGRESS)
-		return;
-
-	async_req.data =3D req->base.data;
-	async_req.tfm =3D crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags =3D child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_decrypt_complete(req, err));
+	rsapad_akcipher_req_complete(child_async_req, err, pkcs1pad_decrypt_compl=
ete);
 }
=20
 static int pkcs1pad_decrypt(struct akcipher_request *req)
@@ -360,14 +371,10 @@ static int pkcs1pad_decrypt(struct akcipher_request *=
req)
 	rsapad_akcipher_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			    ctx->key_size, NULL);
=20
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
-			pkcs1pad_decrypt_complete_cb, req);
-
 	/* Reuse input buffer, output to a new buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
-				   req_ctx->out_sg, req->src_len,
-				   ctx->key_size);
+	rsapad_akcipher_setup_child(req, req->src, req_ctx->out_sg,
+				    req->src_len, ctx->key_size,
+				    pkcs1pad_decrypt_complete_cb);
=20
 	err =3D crypto_akcipher_decrypt(&req_ctx->child_req);
 	if (err !=3D -EINPROGRESS && err !=3D -EBUSY)
@@ -418,13 +425,10 @@ static int pkcs1pad_sign(struct akcipher_request *req=
)
 	rsapad_akcipher_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
=20
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
-			pkcs1pad_encrypt_sign_complete_cb, req);
-
 	/* Reuse output buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
-				   req->dst, ctx->key_size - 1, req->dst_len);
+	rsapad_akcipher_setup_child(req, req_ctx->in_sg, req->dst,
+				    ctx->key_size - 1, req->dst_len,
+				    pkcs1pad_encrypt_sign_complete_cb);
=20
 	err =3D crypto_akcipher_decrypt(&req_ctx->child_req);
 	if (err !=3D -EINPROGRESS && err !=3D -EBUSY)
@@ -509,16 +513,8 @@ static int pkcs1pad_verify_complete(struct akcipher_re=
quest *req, int err)
 static void pkcs1pad_verify_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
-	struct akcipher_request *req =3D child_async_req->data;
-	struct crypto_async_request async_req;
-
-	if (err =3D=3D -EINPROGRESS)
-		return;
-
-	async_req.data =3D req->base.data;
-	async_req.tfm =3D crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags =3D child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_verify_complete(req, err));
+	rsapad_akcipher_req_complete(child_async_req, err,
+				     pkcs1pad_verify_complete);
 }
=20
 /*
@@ -548,14 +544,10 @@ static int pkcs1pad_verify(struct akcipher_request *r=
eq)
 	rsapad_akcipher_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			    ctx->key_size, NULL);
=20
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
-			pkcs1pad_verify_complete_cb, req);
-
 	/* Reuse input buffer, output to a new buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
-				   req_ctx->out_sg, req->src_len,
-				   ctx->key_size);
+	rsapad_akcipher_setup_child(req, req->src, req_ctx->out_sg,
+				    req->src_len, ctx->key_size,
+				    pkcs1pad_verify_complete_cb);
=20
 	err =3D crypto_akcipher_encrypt(&req_ctx->child_req);
 	if (err !=3D -EINPROGRESS && err !=3D -EBUSY)
--=20
2.30.2

