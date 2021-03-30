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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB3AC433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE1C619D1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhC3U34 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:56 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:29355 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232417AbhC3U3Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+6EJYkY3DJmRZ9LdDbt9vKS6AxHnkSLOenV+lguZU8=;
        b=NQl0cb0ToTHICp7bhp4IQuTQJTFPFgXEbox8YQ48Qg0K0XT7QQkt3hw3orWtPjH/VDX17H
        jQyYU9ZbgBw8Wxa5sAQBdWL3v/RnNq1AxLWYP2XYXgnSyMdxVQ+NPrba8RpIo9I61I2Y1M
        tjIThOiNVpMvcRrl9GTvpiNfBzxF4GM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-5KCAfHb_P7aq7e4kfaTKMA-1; Tue, 30 Mar 2021 22:29:22 +0200
X-MC-Unique: 5KCAfHb_P7aq7e4kfaTKMA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1oFpvZIqpFjSHQXqKqidjeS5cLp/o+Y+dsDD2pBa/22u8K7155yDEIZYjPGsZ87Z4hC6px8OSO8rD8UHuL4kXDr/PPkKDPJr1Z4BE9Ubu9FYhQtVGoHjNdIVRg6wOQi49CuzuaoJWPHK4dAnAg7pqQETM9PZhc7mf+iE1pZ9lMgqS13NPxnkdh4/ubxXmZLQPbyXCLEK8OanHSFnZ2fwmrLbsxCMAdbzqgzkXCNhXjGWmhm6+Q3g7EHGC/OXSkiC02aMDkyV7/8aRiUL4qMveSaypiU70Ccl7vv7QgKjAL17DzL2XY3SKKdIaSbJGu/nqwFxZlzwVPHon+8m2Q1Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Kv0YdnDPQSEZxBkUROBXfwJM6YFVXfQzy8db4DFyj4=;
 b=LjzQcDh5vbwfh3uukf1DoWQim/CccbZSv3KTl5t7QkZ+P2JCNy0+xqkFZxFLJBXP7Zipz0ls3AGMhCopLjzaFvqDJKbpocsrPWQ/wjVJ8sJz+5VK/U42dVYwKImvFIIza75KrShOxG1OpmBupEgf/NguyfH4rzzKguEm8Y/okc5K8RUQuinq9J23LirT3yhL4s7ZfOk/TY0tDjwvxSl3n5w8OWznfZBT6AhqTnYm14OnB8UI4hYSNHNatPwY1pRip8i8ytVC0HHfdbLnVTLReViqCdjVoZkAHgk7YcvmiRAjSnyzhI9TrhXRY5BEM1NggsBUEVaqxZwdyunbH0xovA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 20:29:21 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:21 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/18] crypto: rsa-pkcs1pad: Rename pkcs1pad_* structs to rsapad_*
Date:   Tue, 30 Mar 2021 22:28:16 +0200
Message-ID: <20210330202829.4825-6-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d25c2591-48d3-4b57-10c8-08d8f3ba7ff4
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB33934FC8B968266772E788D5E07D9@AM0PR0402MB3393.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CVjWlE5fWcDrDscCtZE31AiHuNiDzfPWMljEbrARjXYjay0MRk3G97LUwQEJ11Rd1yi/SrUzj/e40XVc8gPNRGNUuEHLSo38+unYLVIi+MweyYgfmbqAvPhroaSyiYAYuCTtWE/ty0wN3a8P2N3JVIPlQ4/lvkxjaHU7sveiKxZ5w56UC3IGH48gRTRkHBV2Xh52i+G8despPKJIAyPwSsLwm7Ix9n63rSQufgU8XU551bZ0XFsa5Wx3MlSALAbgW9xYSN+Rexs6z7iuaS2ybcs4Re60/muMdpwDIxeCBdfXSMujldisHYGJ+kGRpp55QS+0N2Rj7rxkBzZxAOCzIjJaBa/tbjs2jmBfa02hD16nGNL9ApFZZKde9gBFp6A7uhxmXIQsLLhi6wNtmtASe/Kit/93ewMOjrmCn9dRDhkaKFeao8AcQ7sj1FDzoUBqNkGYjHfmiSrjmGfdC9LhLFOCREGD7SbBORYKJW3a3Iv4ZckUIsoz4E7EW1zygD06ajumiZHYzD0XZgewOybjHEUrxpLfgAYO8McoFs+cytU8/fBZVq0T4xmHCYE1LpguscY8QkSyvwk+ywD1j7jkLXrPJDCVYgFLPjCgs1T50QMLHytvXQ3Xglwn0vKRWm4tKaw9CpRQlaadviQHis+heQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(66476007)(66556008)(54906003)(66946007)(6666004)(83380400001)(8936002)(316002)(6506007)(6486002)(1076003)(52116002)(478600001)(6512007)(5660300002)(38100700001)(36756003)(4326008)(86362001)(6916009)(8676002)(2906002)(16526019)(2616005)(956004)(186003)(26005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e/z7yu1K27nHIDnbEeNa2r5qDVqQU52gqQ0Kj7oZFVNx/oACK3n7pxBFQWIw?=
 =?us-ascii?Q?cU1fr0mpF5tucAgc7LetjbxWwcSa6+hmL3D9ldMvz3jNrUv3YvwIc1BnQ0Fk?=
 =?us-ascii?Q?SvAOKMZsgoHyj/VNOs/9qYuMmEDEWG7JRz2oRfrtnNEBk/ArBR2YES+Zt0Jn?=
 =?us-ascii?Q?1RzX3HYeZfzCuWcjGuW5JrdUkeCGP5uJH5+4D4qXsjkLs9o0dScKc5l2HKJi?=
 =?us-ascii?Q?sOYgXrFDBODshbURCq3ll9xCitem9R0ErHU05vlyWsTM1vSkmadMBpVPDd7X?=
 =?us-ascii?Q?0x9XCdZvIUV4DSrAUs3QZt3mnhllt3M5ODa+jM1tUG/sSG8Vz9B93fJUXAam?=
 =?us-ascii?Q?d9Rhud/iamznEfPxTC6ttXB1fzhLQ+NJuKELLcoJf0AL1nW5CNYmlDJ/o9gf?=
 =?us-ascii?Q?W0Y3r6OTnmH8yMT5AeLE1AdgEakJjCGce6fZtiuJqcyE7XMKmZV+1Pm4E+Ji?=
 =?us-ascii?Q?IXqGfaeLi4MIhV8uHLY1TKX6yGePGd2U5n7MFagjBv4uO2Mhwn9WRQKU8W2O?=
 =?us-ascii?Q?Gocfhn7an4ZDCQiyJ1/PEBB+uEJDAY88U0/FaU2iumKCmkm5H6y3h1kzKVZJ?=
 =?us-ascii?Q?8/GKmH0L/hcT/gdcsbSHbv1lLLN/x2yaoAD821a0nQVRm/qb1ILoKGDEkzHo?=
 =?us-ascii?Q?l3tWni2XWlAb/eoLKhhScbI9yHPfAA3XzN/yD3Y8SG+EkwfTxVwM2ZiuD9gI?=
 =?us-ascii?Q?zobssu4p/rq62V9ddc/Q8L/akJ/kCy8GVlDBT9j9YNga2+t2KBkCGHITlsOU?=
 =?us-ascii?Q?WFqzZQiWf9RSM/adwnx9t2U5ZPgXmG3JMCn37FoTOpcXikyTj5aa746sZco7?=
 =?us-ascii?Q?34Nyw0wPCd56pnqU8qf+xptKHQEUoFAbafC65zberLQ5AWQyTQVhEJf5zZC+?=
 =?us-ascii?Q?yYZraQnt6wRDAqGj1I9Ojl7lWypaRgmDyC8oG1I+DlS/Gjv/FsZTIBVBF6KW?=
 =?us-ascii?Q?ym+FQph7aZ18D71vCMEXJnne2wjXhdigzIMYVa2/+dNHtBWVa78mULB/UZoL?=
 =?us-ascii?Q?mMwagma0oyIUB/RXNAHvcnAjyKU/XEtJbyNZT69RkowVSrNK6EhWVhBPejB8?=
 =?us-ascii?Q?0IrKWC6f1jzT0i2rHB40tDixOxyFe3Wk6QeJ22OfnoSbgeKb7Ld5b8kNJQKb?=
 =?us-ascii?Q?qWr/Tm4x0lBdjuMEAXwbTtO0sQOwLQC8jTC4MUJxL4ixhdSWdUM8Azblocl9?=
 =?us-ascii?Q?3gUmBI7PEbnACh9+/VzGyCw/6dM767bo8wwtkYi9jYxA2ZHRul19gfy0f1dn?=
 =?us-ascii?Q?RAsmzpii2fxGFXQBlehSyLbE8D537jm+/82Qfb/Ma5NXD+GP1dmkiiLam9pS?=
 =?us-ascii?Q?If+WtQ26adUAkRWyNHO6xvCI?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25c2591-48d3-4b57-10c8-08d8f3ba7ff4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:21.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DDZZHnecR6yuoCtRdV+ZvvODgt4hr8BqJm9z6Np5pambYPtP18m40/Yjw2jTUms6xTnyBdnLUvAHIfm1nFLtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use generic naming to share with other padding scheme implementations.
These will be moved out of rsa-pkcs1pad.c.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-pkcs1pad.c | 62 +++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 6329c79316d2..e76fc98a537a 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -88,17 +88,17 @@ static const struct rsa_asn1_template *rsa_lookup_asn1(=
const char *name)
 	return NULL;
 }
=20
-struct pkcs1pad_ctx {
+struct rsapad_tfm_ctx {
 	struct crypto_akcipher *child;
 	unsigned int key_size;
 };
=20
-struct pkcs1pad_inst_ctx {
+struct rsapad_inst_ctx {
 	struct crypto_akcipher_spawn spawn;
 	const struct rsa_asn1_template *digest_info;
 };
=20
-struct pkcs1pad_request {
+struct rsapad_akciper_req_ctx {
 	struct scatterlist in_sg[2], out_sg[1];
 	uint8_t *in_buf, *out_buf;
 	struct akcipher_request child_req;
@@ -107,7 +107,7 @@ struct pkcs1pad_request {
 static int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key=
,
 		unsigned int keylen)
 {
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
 	int err;
=20
 	ctx->key_size =3D 0;
@@ -128,7 +128,7 @@ static int rsapad_set_pub_key(struct crypto_akcipher *t=
fm, const void *key,
 static int rsapad_set_priv_key(struct crypto_akcipher *tfm, const void *ke=
y,
 		unsigned int keylen)
 {
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
 	int err;
=20
 	ctx->key_size =3D 0;
@@ -148,7 +148,7 @@ static int rsapad_set_priv_key(struct crypto_akcipher *=
tfm, const void *key,
=20
 static unsigned int rsapad_get_max_size(struct crypto_akcipher *tfm)
 {
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
=20
 	/*
 	 * The maximum destination buffer size for the encrypt/sign operations
@@ -195,8 +195,8 @@ static void rsapad_akcipher_setup_child(struct akcipher=
_request *req,
 					crypto_completion_t cb)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
=20
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags, cb, r=
eq);
@@ -206,8 +206,8 @@ static void rsapad_akcipher_setup_child(struct akcipher=
_request *req,
 static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, in=
t err)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	unsigned int pad_len;
 	unsigned int len;
 	u8 *out_buf;
@@ -252,8 +252,8 @@ static void pkcs1pad_encrypt_sign_complete_cb(
 static int pkcs1pad_encrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	int err;
 	unsigned int i, ps_end;
=20
@@ -297,8 +297,8 @@ static int pkcs1pad_encrypt(struct akcipher_request *re=
q)
 static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err=
)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	unsigned int dst_len;
 	unsigned int pos;
 	u8 *out_buf;
@@ -357,8 +357,8 @@ static void pkcs1pad_decrypt_complete_cb(
 static int pkcs1pad_decrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	int err;
=20
 	if (!ctx->key_size || req->src_len !=3D ctx->key_size)
@@ -386,10 +386,10 @@ static int pkcs1pad_decrypt(struct akcipher_request *=
req)
 static int pkcs1pad_sign(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
-	struct pkcs1pad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
+	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
 	const struct rsa_asn1_template *digest_info =3D ictx->digest_info;
 	int err;
 	unsigned int ps_end, digest_size =3D 0;
@@ -440,10 +440,10 @@ static int pkcs1pad_sign(struct akcipher_request *req=
)
 static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
-	struct pkcs1pad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
+	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
 	const struct rsa_asn1_template *digest_info =3D ictx->digest_info;
 	unsigned int dst_len;
 	unsigned int pos;
@@ -528,8 +528,8 @@ static void pkcs1pad_verify_complete_cb(
 static int pkcs1pad_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct pkcs1pad_request *req_ctx =3D akcipher_request_ctx(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
 	int err;
=20
 	if (WARN_ON(req->dst) ||
@@ -559,8 +559,8 @@ static int pkcs1pad_verify(struct akcipher_request *req=
)
 static int rsapad_akcipher_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
-	struct pkcs1pad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
 	struct crypto_akcipher *child_tfm;
=20
 	child_tfm =3D crypto_spawn_akcipher(&ictx->spawn);
@@ -573,14 +573,14 @@ static int rsapad_akcipher_init_tfm(struct crypto_akc=
ipher *tfm)
=20
 static void rsapad_akcipher_exit_tfm(struct crypto_akcipher *tfm)
 {
-	struct pkcs1pad_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
=20
 	crypto_free_akcipher(ctx->child);
 }
=20
 static void rsapad_akcipher_free(struct akcipher_instance *inst)
 {
-	struct pkcs1pad_inst_ctx *ctx =3D akcipher_instance_ctx(inst);
+	struct rsapad_inst_ctx *ctx =3D akcipher_instance_ctx(inst);
 	struct crypto_akcipher_spawn *spawn =3D &ctx->spawn;
=20
 	crypto_drop_akcipher(spawn);
@@ -605,7 +605,7 @@ static int rsapad_akcipher_create(struct crypto_templat=
e *tmpl, struct rtattr **
 {
 	u32 mask;
 	struct akcipher_instance *inst;
-	struct pkcs1pad_inst_ctx *ctx;
+	struct rsapad_inst_ctx *ctx;
 	struct akcipher_alg *rsa_alg;
 	const char *hash_name;
 	int err;
@@ -661,7 +661,7 @@ static int rsapad_akcipher_create(struct crypto_templat=
e *tmpl, struct rtattr **
 	}
=20
 	inst->alg.base.cra_priority =3D rsa_alg->base.cra_priority;
-	inst->alg.base.cra_ctxsize =3D sizeof(struct pkcs1pad_ctx);
+	inst->alg.base.cra_ctxsize =3D sizeof(struct rsapad_tfm_ctx);
=20
 	inst->alg.init =3D alg->init;
 	inst->alg.exit =3D alg->exit;
@@ -673,7 +673,7 @@ static int rsapad_akcipher_create(struct crypto_templat=
e *tmpl, struct rtattr **
 	inst->alg.set_pub_key =3D alg->set_pub_key;
 	inst->alg.set_priv_key =3D alg->set_priv_key;
 	inst->alg.max_size =3D alg->max_size;
-	inst->alg.reqsize =3D sizeof(struct pkcs1pad_request) + rsa_alg->reqsize;
+	inst->alg.reqsize =3D sizeof(struct rsapad_akciper_req_ctx) + rsa_alg->re=
qsize;
=20
 	inst->free =3D rsapad_akcipher_free;
=20
--=20
2.30.2

