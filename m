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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB16DC433E5
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B043561989
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhC3U37 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:29412 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232463AbhC3U3e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4Ewybz6w4lMErRfH/jnufOCEmHJHtgwHitXjb47p9Q=;
        b=Tl414XZPzOrnTK0wD/eCarRlxKNGmeqj6cvB1S7zMOleSR2KargRoMpaoV50sQzjIDJiTC
        edpgcMnEsdm8uytfjHhMvg1R9Ir/Pmp3nV51DVb9PHTxaA6UnwSYk4SVzwNvSrJWdO4go9
        jJaqFQl3N/ooSpB8Bzswnzkeo4vsAq8=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-SLkxt6rgNHmwAer7UvmeAw-1; Tue, 30 Mar 2021 22:29:32 +0200
X-MC-Unique: SLkxt6rgNHmwAer7UvmeAw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MI5ZRmaqjtqJ9DTguIlX5fxe6iM2Pk7MeutD2Q4yjauz3488QgZiConSTUzrx44Le03JaKR9YPPLtQk3roSjMficNrMyX9+MHjgrfCV4VNNsXpLPgZG7r+dCCf4c4s6X/YGYbZI0u7sJPspozZdRpPP/gwK+NYkNYGxXWeZRdZMnURM5C04pXX5fy1Tv2ExB/xrrWkN8L/BSViyUEf52E2SRqoQQbdad/zYnmlMJHNc8px2ll7QCjJfR8a7Kh7EqlCdUFfivz+D/WMPzP0AG24CX6GtTTfG7H0dtDkdjCFthaOvOqEdNuTyzvdd/aLrvUlvdGUblaoOdKuFyjOWtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyZxX+2f+iKZH6W/fnwpcP/2p2RvxmgjA9KljJUpZRc=;
 b=WhWS2PJBsB0OdH4WxV+6LirRwYINfHG+qw314SLreoT3En+3zaNziYQuDcpMklN1XKF9hFOwTZYZHsFegEFzjyhGp+DAXO1HppSCK3p5YFKni+E41XyEyGFiFsnx02RtHq6sRyk3OxyouMQp91OBl24gThJoqW/iLk8B6kt1N2f1Um4Dyw17G2EbmhZ+EVwXMruh+EhnH/PYScYwGU5cTRfADbyS7n+ZdtTZb6A5JSWMNxtfAn7jLDqU9z4L5NRW1CccC4R5XeRFQqQQREnZ2fXjzeJ78igcZQzZKTjMCb/EY0+dKis57ubYdBJ+vGN21hVm23lT0zdqMPUWADR+6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:31 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:31 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/18] crypto: rsa: Move rsapad_akcipher_setup_child and callback to rsa-common
Date:   Tue, 30 Mar 2021 22:28:19 +0200
Message-ID: <20210330202829.4825-9-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c17cc80a-f321-4947-9703-08d8f3ba8617
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB2321F3AB9655D10943A39E5DE07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:185;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwB29a/i5wy7EMkHN5+s9yo4GjPHFMC6e5XLqcDU9sPWhEE+E2Dr1J/hTC4aNN8xYDRqAVHZU4rEESwg7Tk/QXpScVHlXeUu924y3mUj6vXBGbhw3vOpeH+D9vtQW/AAuF/dytLNmDkmEFPbcpJmhM/ZshtrWEW+y7y4DQv2kziSHW0EKG2JhN6knL7aPs0s6WC02xL7ZZCY/jqU942Tk8wxJA7RCMKB2FnxlcQHcgf9pKxQNfBmsQqo+aCkoaFeN+dJxS2l9ny53bzFZ5rNSk8UMOHRgWePanJkJhD/tqb6RhI2Tvru1yiJtqfpSNXAdYMYx805degpNXDTNasH5QqFVXk3m6q1ZdnKJ4K/pwvKB0qz+k+mwikJztHsVj1ScQdONIVwMoVdSOPbmHkpkWqYmn/r7T5bRPkeNZNKJcyqOMdgTzsbeiM5FCNijIuWg1yAPDYgFVwo/hmMsNlruLh+xJ6qmJyHgVfGs4/twYGRbXksa6YCQQKlksB1gozEP/Mx741geUmSizN2d7NH3WSn1YKu1EQCspMKVgsC/P0k86rxuToJO67E9rO53XwDFmS5une3+62IGG4UISJ88Sey22mAx5t5Hx1Kh2DbyN/nDmeFSC+y+6jcT0spxyxp9w6YOQZZskbr9ICQE8+TPrm7u908aXXlKsdQ3UHzzhk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Nt4HunzG1EulApf78lhF1csOPA/FvKaoR40KDNBPmXJL2J+O0CfRlZbqrrP6?=
 =?us-ascii?Q?SdWbmmxHndrSO/aB46Z5W3DyT4of41O/H2BHDuFovmN1/lZheo2bCLpKGzTx?=
 =?us-ascii?Q?P3+kK85ZPo60BT3+l1IhW1B9WZT93QRFA3ci4WPTJvMi7DmsuyuG0CrvwWJy?=
 =?us-ascii?Q?cgfpXSAdMHqy1UC0CXHZeFKxMPCJCXg30F+S8oimQ2xrOaHkq7iT4wHSOJZ1?=
 =?us-ascii?Q?znUy0bbmTEytYjm4FlLfYgRVMvaPuI9mb6iPcMeNpgjmWlm7jrIZQS0+6CgO?=
 =?us-ascii?Q?HwLvFITHFHeb6iwt9OH1me9hmgrPjxkp1AjvQw27DXsQWPg7PAmM+yj5uUdF?=
 =?us-ascii?Q?VPZ7UqspQjypN4CaKOHRN5sIiNOZP7+KukyoN5mC2/8LJyvFiC4azGV57LRT?=
 =?us-ascii?Q?1x6wLb1+966dVudktHikhbCatDd33dr6O5+ejjETKwzHs3uCNTAMBmpm0Dq5?=
 =?us-ascii?Q?8Crfyx/qonj5cCImPiPpFHtZivSB4Zvk45mJeczgKloXrDgkG9R4qQTZFhLL?=
 =?us-ascii?Q?/HpwUvucGcbwz2zkDcgpgEynOFH+WPFsgTIvzXUsnh7oCcFYJrDjTvoKlOuF?=
 =?us-ascii?Q?0vz7LvkGKuLTTMsKieQ1gVb4RQP5fnN0JT4k+3FyLA64zXrR3T2AtgoIAwXB?=
 =?us-ascii?Q?QxpN/tQLyIFGdEcK/EoIKLIzfrE+ZF8uQ0DZMFPWKxuDMoVU1Y7kbJ+LG3+R?=
 =?us-ascii?Q?0kP+E3jmgccoUMyYC0uj/BokhIBiSCqk9gGbsM6UboTw57rzUYlWt7+PDjZn?=
 =?us-ascii?Q?JXgO7euBN9Wt4OI1s0dzznoGGFNQY92L2t3ifBkLcPPqgWb9pCT7EFAwZKwK?=
 =?us-ascii?Q?G7fSW4pucfrP6GgsJ0U+1dVLrJx3TRG4XR8JULeL140YB6pFu3HSt/bAaE7O?=
 =?us-ascii?Q?tEBaa+9QG6sj2b7B84tc7Z3tyUbFMayNDdXzO7bQeYmUe2uEktUpRnfq3gVU?=
 =?us-ascii?Q?8cJ4ftrTkTdYeNDUl0Wl5NhVb0y+ajnffJGC85EUfRjbiJv+m8rMkHDoe/mh?=
 =?us-ascii?Q?XKfxgcHN0Jgjh9ulGjXtKe+PVTd81YXFKF/G/iQBNiFNrexSj/ixzcWEDAoQ?=
 =?us-ascii?Q?SAc+ea2thh6AGq+NdMiI9XlrMQaay7ZH+iRkQCETC17X7ityxTMoaGPs+1iB?=
 =?us-ascii?Q?WW2JtyN9Dnw9ly5TG0dPwX8Bw1ohMOfWBpZmGYi9RBbm6wHGg1fHvsl3gYyB?=
 =?us-ascii?Q?B3G4yC/tGLMz4p7LiLQjrXE2y7GMfTxSIWr+d7Fye3SIBJJpH+ehsImk33oz?=
 =?us-ascii?Q?QlnLEJCseHLlfhy+51U8l6JaCEPzZOx9KzwVsusSgPm8OBC8KESo+W/Rl2WS?=
 =?us-ascii?Q?LMf0/NIu57+8WWchQ+6A/lDm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c17cc80a-f321-4947-9703-08d8f3ba8617
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:31.4183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECOv304d5zdH7XB+L6ZR69oCUh3LMO+j78gh0p6JscDj/lh949KjgHfjtx5+hapLkppsq6vL0+t6O6UKe0j8jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pull out more common code from rsa-pkcs1pad into rsa-common.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-common.c                  | 31 +++++++++++++++++++++++++++
 crypto/rsa-pkcs1pad.c                | 32 ----------------------------
 include/crypto/internal/rsa-common.h |  9 ++++++++
 3 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/crypto/rsa-common.c b/crypto/rsa-common.c
index d70d7d405165..6ed258a78287 100644
--- a/crypto/rsa-common.c
+++ b/crypto/rsa-common.c
@@ -75,6 +75,37 @@ const struct rsa_asn1_template *rsa_lookup_asn1(const ch=
ar *name)
 	return NULL;
 }
=20
+void rsapad_akcipher_req_complete(struct crypto_async_request *child_async=
_req,
+				  int err, rsa_akcipher_complete_cb cb)
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
+void rsapad_akcipher_setup_child(struct akcipher_request *req,
+				 struct scatterlist *src_sg,
+				 struct scatterlist *dst_sg,
+				 unsigned int src_len,
+				 unsigned int dst_len,
+				 crypto_completion_t cb)
+{
+	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
+
+	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags, cb, r=
eq);
+	akcipher_request_set_crypt(&req_ctx->child_req, src_sg, dst_sg, src_len, =
dst_len);
+}
+
 int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 		       unsigned int keylen)
 {
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 30b0193b7352..6fa207732fcb 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -9,38 +9,6 @@
 #include <linux/module.h>
 #include <linux/random.h>
=20
-typedef int (*rsa_akcipher_complete_cb)(struct akcipher_request *, int);
-static void rsapad_akcipher_req_complete(struct crypto_async_request *chil=
d_async_req,
-					 int err, rsa_akcipher_complete_cb cb)
-{
-	struct akcipher_request *req =3D child_async_req->data;
-	struct crypto_async_request async_req;
-
-	if (err =3D=3D -EINPROGRESS)
-		return;
-
-	async_req.data =3D req->base.data;
-	async_req.tfm =3D crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags =3D child_async_req->flags;
-	req->base.complete(&async_req, cb(req, err));
-}
-
-static void rsapad_akcipher_setup_child(struct akcipher_request *req,
-					struct scatterlist *src_sg,
-					struct scatterlist *dst_sg,
-					unsigned int src_len,
-					unsigned int dst_len,
-					crypto_completion_t cb)
-{
-	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
-	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
-
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags, cb, r=
eq);
-	akcipher_request_set_crypt(&req_ctx->child_req, src_sg, dst_sg, src_len, =
dst_len);
-}
-
 static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, in=
t err)
 {
 	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
diff --git a/include/crypto/internal/rsa-common.h b/include/crypto/internal=
/rsa-common.h
index a6f20cce610a..4fa3cf5a989c 100644
--- a/include/crypto/internal/rsa-common.h
+++ b/include/crypto/internal/rsa-common.h
@@ -34,6 +34,15 @@ struct rsapad_akciper_req_ctx {
 	struct akcipher_request child_req;
 };
=20
+typedef int (*rsa_akcipher_complete_cb)(struct akcipher_request *, int);
+void rsapad_akcipher_req_complete(struct crypto_async_request *child_async=
_req,
+				  int err, rsa_akcipher_complete_cb cb);
+void rsapad_akcipher_setup_child(struct akcipher_request *req,
+				 struct scatterlist *src_sg,
+				 struct scatterlist *dst_sg,
+				 unsigned int src_len,
+				 unsigned int dst_len,
+				 crypto_completion_t cb);
 int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 		       unsigned int keylen);
 int rsapad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
--=20
2.30.2

