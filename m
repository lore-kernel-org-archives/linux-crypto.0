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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC2AC433E8
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D952E619CF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhC3U36 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:58 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:46406 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231874AbhC3U3d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MdEzpNPIFGRSElLeCIs13BfjpXx99bN0wps1BgoGTaA=;
        b=MtMu/pS7R8A17nYbyRQ0TCmyHBWxXEJuMGkkQs2dYX5CFrePz6bZt9WRsbkb5yE6M6nd51
        wH+2qnbPLdMgmn8B4iRkH02pTH94Im1/p8q5Aok6x+vx2vDoJy+9YR2pNXcXACzkBmlAml
        zTH/+x5NXL3/c+uICF0SxEwkXyVdsgg=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-GiS8JwmANOSVBFCE2Xw5Vg-1; Tue, 30 Mar 2021 22:29:30 +0200
X-MC-Unique: GiS8JwmANOSVBFCE2Xw5Vg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REfPjbBXzbdeXOiXFjKpjSyLEbmlBZQYafwa49/R6VOE+DqRvAAijKEpE+moigTZ93kQ18udl1cDG/HAZUGPIgUEcLXnkNEJJOAb3/e7vTyu42Ap/r6d+F5OIsFLy3rQpNc8CMSDGXkaCbQi9evy4nmimywcwWGRMTyic5vEpzP6+brWu5XGSH4E4jqIbgCVn62sDJkah1s0fo1xAJoFwmcw2yZYCPemlnbNA3Qh5R5/CvZ+w/upQtI9mcDrd53Zvl0yLV9KagNg/iM2aoGJCfiTyAbU4G2aNj/fFiQuLVl2DVJVkgLqN1JjEMUK4zbEqAKOgfTDbMZ6wJy0d+0b8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGrabyS9mlV4qWytjiZD4Z6zIhm7yjqE/9Hfrt+WRwc=;
 b=dzChsgGOjvWDHPks+yIUfP0V7REwwA/gFmgEJNMoG/WOFLfSSMLW8PzKdtxNVj4d7+ZDApzEm6xQCuZiJJUqOy5KsJ1wt95P+xLH2MCvmHOsnK8O5ED/NFhWizhxDTlptpDjzhzi2Ezg/ZJm0A5jqRxGfUkIQd0qIi/3nB9mTfYG4fWSiHWRh9EgX2sCva9DHUrBkKLsUYrtyNwB0rHmSLlsU5aJowsNFd/v+5lEZfDq4R+qKF5j+TDkTI0KJZR/T1izgzGZXb4TS6LeU/XZjlHZyNZDlp8bFeTD07T6iRbXs7JpDJxzVJUeCFJyQhW0MhauhnvSFtIo31llZ3mQ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:28 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:28 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 07/18] crypto: rsa: Move more common code to rsa-common
Date:   Tue, 30 Mar 2021 22:28:18 +0200
Message-ID: <20210330202829.4825-8-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b7ca027-5b54-4173-f8ab-08d8f3ba8440
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB23210D4A206055044933E80BE07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:252;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q1w3m/p92oiGN6vubRUoWEefQzZ2IVZ+I50rX14qKU7+ZOwwCwb3dqehrf49utWB8B4RzoX+Et16LVzumYeGIWLnOnm2+J0/y6LvxvjSK8FzicaowFPgR5/re/XteyBwWrqA9IRjbojrS+Oq6FyPApvQXM7B8qP0moNpUDqDboc4VmpKWzyBs285ydICzVx/8JEyzBhIFY12CPfihfWiSirNxbpFA0/L0Q5SqEsfsbHeA6WTNiTPJJiqaCizgJCuz3YfKh4Hxx3efGcwgQ1BjDbkh7KnRVGyNXu76KeuKlk+vJEvOWnXLGo4Pft4yPnzKD/Tr0KAtStos8mkHXpxapMccSerEcOwn7HtBLOVC7YH5s6c9v2bpUISFOwUwfJPuz/NjywV+/E1CJrN0L/QBv72wSOirdFyGwMjonGzhmiSfLyHQyDu8BoGOb+4w7wnouxzUUuAK9sq3WvyH6oWbe7a0NYK/QsXaJ70zaHcQm9uGBWLA5fEC7GFQIDeBnE4+5ghnE224uNwu/g7EFdjj6HmcH3ya/oGVJiEx0aF3gXQ4fr3PaMlZlb3Ax7mKw7Sx4wy5C0YbYbftAlR/qlfB9ZA7+K85AgbKWAoDTXBHKfU+IsHCbvDWP3TP9cTMe+pblvAFvTw1ASa/E6w7frMoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(30864003)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hZkqmn+J9dKiAvOM3IEXxKbnnqvH0mLkPDQ9cXcRUROfP1n88uP8/yRMSwAm?=
 =?us-ascii?Q?FRMJwSrJAci4eV2f8a8XS64x/8h7cJVuUOovutQ6se71yg8Oa1VFqASmoc6b?=
 =?us-ascii?Q?NPVqbD+KtwH3jcc4cgbu8O8D+B/0a2E56iiOihysB1mlCpql2eqrkuebhCjf?=
 =?us-ascii?Q?brYDar06LTTN86SfB221Sim+2U7vFCOMMvpj8114S3eb0pUx9eJ3G49MkeJ4?=
 =?us-ascii?Q?NHzfTiC2kdDjkXEVu0tx1cSsKnW+Sl1tQXX4ZosBAKzfJi7iWtDiIb0V21QO?=
 =?us-ascii?Q?TonUB4Y0VBDNwIRrAoTnxItH15tzQxN80VTRvasFTbeqVoutGNwg9aWYDXnp?=
 =?us-ascii?Q?E7h4JMN8/dwSSg0clWLXBMuAeVPrSgT28kj7OFHcQUid1n+0YAbrriZXCsyr?=
 =?us-ascii?Q?f9iGhoqSJqn8T2VM/6UlupkIdiLwIewzFbV6m4oCJTLHuhXqyFOzAcR+GHG1?=
 =?us-ascii?Q?DCBxdK1BOQDYvRZkYqejAi6ccRB7fwbon5Cz3jtBs43W4HFkwA364vF8SSf9?=
 =?us-ascii?Q?820mBwX8wU9EZm7O7Fw8Nrm1XHscvFXbqZXc49OWC1J+SRFgBejv8EqvKedc?=
 =?us-ascii?Q?tKk/tJ/N6JbcwxI6FNVZy6MuV54qQDa1v/miRssRDXR/per0JBDfquzieuG+?=
 =?us-ascii?Q?HgXtJ7eKwofvmoGtpveSPGR26kyDjrpfWSJlEtFg8dD+QuSGrspZUUFHWTNC?=
 =?us-ascii?Q?W37Z5nMs321qx9KKbrasH6sw/r4OQKqN0pKKmz+bCU/MymrZ5/FZP9AsMOLW?=
 =?us-ascii?Q?CSipV8I/XVcO74G3Uo9Rh7Froi66DiXU6yOXKNTq9+EiO1nsR2IGUf3JIOtN?=
 =?us-ascii?Q?113690IDg0VH25uJVqsjjPbqUyZRfQYzFcqiHTNcogNyAqhVGboZyePt61VB?=
 =?us-ascii?Q?lGWeDhrHnsnd9eEDBtUEitZcFE6TWUXRcroX7Jottv8iZDWpNbaWZBKRNRjY?=
 =?us-ascii?Q?g0LAJS+X9j21krhOoLDQ/fhUaZUwimWvuCsWFag2WFSH6ZaBfT9FCG4lM1J1?=
 =?us-ascii?Q?Ek2xrRJssxFTxGFm6TFLrV9Cr/gvQxXfJU7d5QWf2IZBgxfwVyQFTcROBpgR?=
 =?us-ascii?Q?bUqnyWjB6moevoaa0yf8bcjHZH3ztFwNiKYWHwNKDHtTsYP/x6anjjOtN7w8?=
 =?us-ascii?Q?OtEiApHD9cG4UgVrlorJFakpLIadQoqplzhV9VS3Ip7+x1bIfgYsYabhlkhq?=
 =?us-ascii?Q?bOsvC5oSiZtjGuvesC0LGe9rPuoC6a5j2BVNFKrbGXUFaA8BZJhswjcyzTI6?=
 =?us-ascii?Q?/WB5DKjzIMU7rFphK0WDmSKQrPLDdqOnHTRCNCLcTiP+RA/SaC4WFewon4Q1?=
 =?us-ascii?Q?gdOSsSy4aNxtZrAQkbkBxzbs?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b7ca027-5b54-4173-f8ab-08d8f3ba8440
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:28.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7hB1encc38NsFHu8WF0tX5tdX0GxAZD4oo8Q7Pb0rsjtUi67W0IEhr1V9OZGZUIM2H8FPwatAWn1HbtRhBMdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move helpers for setting public/private keys, RSA akcipher
instance setup, keysize querying etc. to rsa-common.c.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-common.c                  | 183 +++++++++++++++++++++++++++
 crypto/rsa-pkcs1pad.c                | 183 ---------------------------
 include/crypto/internal/rsa-common.h |  13 ++
 3 files changed, 196 insertions(+), 183 deletions(-)

diff --git a/crypto/rsa-common.c b/crypto/rsa-common.c
index 60073c56e374..d70d7d405165 100644
--- a/crypto/rsa-common.c
+++ b/crypto/rsa-common.c
@@ -74,3 +74,186 @@ const struct rsa_asn1_template *rsa_lookup_asn1(const c=
har *name)
 			return p;
 	return NULL;
 }
+
+int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+		       unsigned int keylen)
+{
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	int err;
+
+	ctx->key_size =3D 0;
+
+	err =3D crypto_akcipher_set_pub_key(ctx->child, key, keylen);
+	if (err)
+		return err;
+
+	/* Find out new modulus size from rsa implementation */
+	err =3D crypto_akcipher_maxsize(ctx->child);
+	if (err > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
+	ctx->key_size =3D err;
+	return 0;
+}
+
+int rsapad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+			unsigned int keylen)
+{
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	int err;
+
+	ctx->key_size =3D 0;
+
+	err =3D crypto_akcipher_set_priv_key(ctx->child, key, keylen);
+	if (err)
+		return err;
+
+	/* Find out new modulus size from rsa implementation */
+	err =3D crypto_akcipher_maxsize(ctx->child);
+	if (err > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
+	ctx->key_size =3D err;
+	return 0;
+}
+
+unsigned int rsapad_get_max_size(struct crypto_akcipher *tfm)
+{
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+
+	/*
+	 * The maximum destination buffer size for the encrypt/sign operations
+	 * will be the same as for RSA, even though it's smaller for
+	 * decrypt/verify.
+	 */
+
+	return ctx->key_size;
+}
+
+void rsapad_akcipher_sg_set_buf(struct scatterlist *sg, void *buf,
+				size_t len, struct scatterlist *next)
+{
+	int nsegs =3D next ? 2 : 1;
+
+	sg_init_table(sg, nsegs);
+	sg_set_buf(sg, buf, len);
+
+	if (next)
+		sg_chain(sg, nsegs, next);
+}
+
+int rsapad_akcipher_init_tfm(struct crypto_akcipher *tfm)
+{
+	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
+	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct crypto_akcipher *child_tfm;
+
+	child_tfm =3D crypto_spawn_akcipher(&ictx->spawn);
+	if (IS_ERR(child_tfm))
+		return PTR_ERR(child_tfm);
+
+	ctx->child =3D child_tfm;
+	return 0;
+}
+
+void rsapad_akcipher_exit_tfm(struct crypto_akcipher *tfm)
+{
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+
+	crypto_free_akcipher(ctx->child);
+}
+
+void rsapad_akcipher_free(struct akcipher_instance *inst)
+{
+	struct rsapad_inst_ctx *ctx =3D akcipher_instance_ctx(inst);
+	struct crypto_akcipher_spawn *spawn =3D &ctx->spawn;
+
+	crypto_drop_akcipher(spawn);
+	kfree(inst);
+}
+
+int rsapad_akcipher_create(struct crypto_template *tmpl, struct rtattr **t=
b,
+			   struct akcipher_alg *alg)
+{
+	u32 mask;
+	struct akcipher_instance *inst;
+	struct rsapad_inst_ctx *ctx;
+	struct akcipher_alg *rsa_alg;
+	const char *hash_name;
+	int err;
+
+	err =3D crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AKCIPHER, &mask);
+	if (err)
+		return err;
+
+	inst =3D kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	ctx =3D akcipher_instance_ctx(inst);
+
+	err =3D crypto_grab_akcipher(&ctx->spawn, akcipher_crypto_instance(inst),
+				   crypto_attr_alg_name(tb[1]), 0, mask);
+	if (err)
+		goto err_free_inst;
+
+	rsa_alg =3D crypto_spawn_akcipher_alg(&ctx->spawn);
+
+	err =3D -ENAMETOOLONG;
+	hash_name =3D crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(hash_name)) {
+		if (snprintf(inst->alg.base.cra_name,
+			     CRYPTO_MAX_ALG_NAME, "%s(%s)", tmpl->name,
+			     rsa_alg->base.cra_name) >=3D CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		if (snprintf(inst->alg.base.cra_driver_name,
+			     CRYPTO_MAX_ALG_NAME, "%s(%s)", tmpl->name,
+			     rsa_alg->base.cra_driver_name) >=3D
+			     CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+	} else {
+		ctx->digest_info =3D rsa_lookup_asn1(hash_name);
+		if (!ctx->digest_info) {
+			err =3D -EINVAL;
+			goto err_free_inst;
+		}
+
+		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s,%s)", tmpl->name, rsa_alg->base.cra_name,
+			     hash_name) >=3D CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+
+		if (snprintf(inst->alg.base.cra_driver_name,
+			     CRYPTO_MAX_ALG_NAME, "%s(%s,%s)",
+			     tmpl->name,
+			     rsa_alg->base.cra_driver_name,
+			     hash_name) >=3D CRYPTO_MAX_ALG_NAME)
+			goto err_free_inst;
+	}
+
+	inst->alg.base.cra_priority =3D rsa_alg->base.cra_priority;
+	inst->alg.base.cra_ctxsize =3D sizeof(struct rsapad_tfm_ctx);
+
+	inst->alg.init =3D alg->init;
+	inst->alg.exit =3D alg->exit;
+
+	inst->alg.encrypt =3D alg->encrypt;
+	inst->alg.decrypt =3D alg->decrypt;
+	inst->alg.sign =3D alg->sign;
+	inst->alg.verify =3D alg->verify;
+	inst->alg.set_pub_key =3D alg->set_pub_key;
+	inst->alg.set_priv_key =3D alg->set_priv_key;
+	inst->alg.max_size =3D alg->max_size;
+	inst->alg.reqsize =3D sizeof(struct rsapad_akciper_req_ctx) + rsa_alg->re=
qsize;
+
+	inst->free =3D rsapad_akcipher_free;
+
+	err =3D akcipher_register_instance(tmpl, inst);
+	if (err) {
+err_free_inst:
+		rsapad_akcipher_free(inst);
+	}
+	return err;
+}
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index ffb7220b3d10..30b0193b7352 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -9,73 +9,6 @@
 #include <linux/module.h>
 #include <linux/random.h>
=20
-static int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key=
,
-		unsigned int keylen)
-{
-	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	int err;
-
-	ctx->key_size =3D 0;
-
-	err =3D crypto_akcipher_set_pub_key(ctx->child, key, keylen);
-	if (err)
-		return err;
-
-	/* Find out new modulus size from rsa implementation */
-	err =3D crypto_akcipher_maxsize(ctx->child);
-	if (err > PAGE_SIZE)
-		return -ENOTSUPP;
-
-	ctx->key_size =3D err;
-	return 0;
-}
-
-static int rsapad_set_priv_key(struct crypto_akcipher *tfm, const void *ke=
y,
-		unsigned int keylen)
-{
-	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	int err;
-
-	ctx->key_size =3D 0;
-
-	err =3D crypto_akcipher_set_priv_key(ctx->child, key, keylen);
-	if (err)
-		return err;
-
-	/* Find out new modulus size from rsa implementation */
-	err =3D crypto_akcipher_maxsize(ctx->child);
-	if (err > PAGE_SIZE)
-		return -ENOTSUPP;
-
-	ctx->key_size =3D err;
-	return 0;
-}
-
-static unsigned int rsapad_get_max_size(struct crypto_akcipher *tfm)
-{
-	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-
-	/*
-	 * The maximum destination buffer size for the encrypt/sign operations
-	 * will be the same as for RSA, even though it's smaller for
-	 * decrypt/verify.
-	 */
-
-	return ctx->key_size;
-}
-
-static void rsapad_akcipher_sg_set_buf(struct scatterlist *sg, void *buf,
-				       size_t len, struct scatterlist *next)
-{
-	int nsegs =3D next ? 2 : 1;
-
-	sg_init_table(sg, nsegs);
-	sg_set_buf(sg, buf, len);
-
-	if (next)
-		sg_chain(sg, nsegs, next);
-}
-
 typedef int (*rsa_akcipher_complete_cb)(struct akcipher_request *, int);
 static void rsapad_akcipher_req_complete(struct crypto_async_request *chil=
d_async_req,
 					 int err, rsa_akcipher_complete_cb cb)
@@ -461,37 +394,6 @@ static int pkcs1pad_verify(struct akcipher_request *re=
q)
 	return err;
 }
=20
-static int rsapad_akcipher_init_tfm(struct crypto_akcipher *tfm)
-{
-	struct akcipher_instance *inst =3D akcipher_alg_instance(tfm);
-	struct rsapad_inst_ctx *ictx =3D akcipher_instance_ctx(inst);
-	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-	struct crypto_akcipher *child_tfm;
-
-	child_tfm =3D crypto_spawn_akcipher(&ictx->spawn);
-	if (IS_ERR(child_tfm))
-		return PTR_ERR(child_tfm);
-
-	ctx->child =3D child_tfm;
-	return 0;
-}
-
-static void rsapad_akcipher_exit_tfm(struct crypto_akcipher *tfm)
-{
-	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
-
-	crypto_free_akcipher(ctx->child);
-}
-
-static void rsapad_akcipher_free(struct akcipher_instance *inst)
-{
-	struct rsapad_inst_ctx *ctx =3D akcipher_instance_ctx(inst);
-	struct crypto_akcipher_spawn *spawn =3D &ctx->spawn;
-
-	crypto_drop_akcipher(spawn);
-	kfree(inst);
-}
-
 static struct akcipher_alg pkcs1pad_alg =3D {
 	.init =3D rsapad_akcipher_init_tfm,
 	.exit =3D rsapad_akcipher_exit_tfm,
@@ -505,91 +407,6 @@ static struct akcipher_alg pkcs1pad_alg =3D {
 	.max_size =3D rsapad_get_max_size
 };
=20
-static int rsapad_akcipher_create(struct crypto_template *tmpl, struct rta=
ttr **tb,
-				  struct akcipher_alg *alg)
-{
-	u32 mask;
-	struct akcipher_instance *inst;
-	struct rsapad_inst_ctx *ctx;
-	struct akcipher_alg *rsa_alg;
-	const char *hash_name;
-	int err;
-
-	err =3D crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AKCIPHER, &mask);
-	if (err)
-		return err;
-
-	inst =3D kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (!inst)
-		return -ENOMEM;
-
-	ctx =3D akcipher_instance_ctx(inst);
-
-	err =3D crypto_grab_akcipher(&ctx->spawn, akcipher_crypto_instance(inst),
-				   crypto_attr_alg_name(tb[1]), 0, mask);
-	if (err)
-		goto err_free_inst;
-
-	rsa_alg =3D crypto_spawn_akcipher_alg(&ctx->spawn);
-
-	err =3D -ENAMETOOLONG;
-	hash_name =3D crypto_attr_alg_name(tb[2]);
-	if (IS_ERR(hash_name)) {
-		if (snprintf(inst->alg.base.cra_name,
-			     CRYPTO_MAX_ALG_NAME, "%s(%s)", tmpl->name,
-			     rsa_alg->base.cra_name) >=3D CRYPTO_MAX_ALG_NAME)
-			goto err_free_inst;
-
-		if (snprintf(inst->alg.base.cra_driver_name,
-			     CRYPTO_MAX_ALG_NAME, "%s(%s)", tmpl->name,
-			     rsa_alg->base.cra_driver_name) >=3D
-			     CRYPTO_MAX_ALG_NAME)
-			goto err_free_inst;
-	} else {
-		ctx->digest_info =3D rsa_lookup_asn1(hash_name);
-		if (!ctx->digest_info) {
-			err =3D -EINVAL;
-			goto err_free_inst;
-		}
-
-		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "%s(%s,%s)", tmpl->name, rsa_alg->base.cra_name,
-			     hash_name) >=3D CRYPTO_MAX_ALG_NAME)
-			goto err_free_inst;
-
-		if (snprintf(inst->alg.base.cra_driver_name,
-			     CRYPTO_MAX_ALG_NAME, "%s(%s,%s)",
-			     tmpl->name,
-			     rsa_alg->base.cra_driver_name,
-			     hash_name) >=3D CRYPTO_MAX_ALG_NAME)
-			goto err_free_inst;
-	}
-
-	inst->alg.base.cra_priority =3D rsa_alg->base.cra_priority;
-	inst->alg.base.cra_ctxsize =3D sizeof(struct rsapad_tfm_ctx);
-
-	inst->alg.init =3D alg->init;
-	inst->alg.exit =3D alg->exit;
-
-	inst->alg.encrypt =3D alg->encrypt;
-	inst->alg.decrypt =3D alg->decrypt;
-	inst->alg.sign =3D alg->sign;
-	inst->alg.verify =3D alg->verify;
-	inst->alg.set_pub_key =3D alg->set_pub_key;
-	inst->alg.set_priv_key =3D alg->set_priv_key;
-	inst->alg.max_size =3D alg->max_size;
-	inst->alg.reqsize =3D sizeof(struct rsapad_akciper_req_ctx) + rsa_alg->re=
qsize;
-
-	inst->free =3D rsapad_akcipher_free;
-
-	err =3D akcipher_register_instance(tmpl, inst);
-	if (err) {
-err_free_inst:
-		rsapad_akcipher_free(inst);
-	}
-	return err;
-}
-
 static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **t=
b)
 {
 	return rsapad_akcipher_create(tmpl, tb, &pkcs1pad_alg);
diff --git a/include/crypto/internal/rsa-common.h b/include/crypto/internal=
/rsa-common.h
index ecdce0cdafaa..a6f20cce610a 100644
--- a/include/crypto/internal/rsa-common.h
+++ b/include/crypto/internal/rsa-common.h
@@ -34,4 +34,17 @@ struct rsapad_akciper_req_ctx {
 	struct akcipher_request child_req;
 };
=20
+int rsapad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+		       unsigned int keylen);
+int rsapad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+			unsigned int keylen);
+unsigned int rsapad_get_max_size(struct crypto_akcipher *tfm);
+void rsapad_akcipher_sg_set_buf(struct scatterlist *sg, void *buf,
+				size_t len, struct scatterlist *next);
+int rsapad_akcipher_init_tfm(struct crypto_akcipher *tfm);
+void rsapad_akcipher_exit_tfm(struct crypto_akcipher *tfm);
+void rsapad_akcipher_free(struct akcipher_instance *inst);
+int rsapad_akcipher_create(struct crypto_template *tmpl, struct rtattr **t=
b,
+			   struct akcipher_alg *alg);
+
 #endif
--=20
2.30.2

