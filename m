Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C0EC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30FA8619CB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhC3U3y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:29:54 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:40154 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232401AbhC3U3V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Usa2anEQfD1HDNoVZzI1ENJWTQC0PIla+85ydFxgZs=;
        b=UFhQ+yanArlOTo1VAbire+K8G+je8SduNKJsK/SN4JimGoFUgepqtD3ZA82eY3c3xkKB3T
        jFnz+iRKLYPIRzlUjgymroQsH3W0GKPLuR3zdlEeNAT+vNzfGSBipXAG1Zaiy0c4P/tXMv
        H4vcY7sNExSf9UFhp6vt1OhyK2bx6hg=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-RH_giBZ7NbedMS3fnm1iYg-3; Tue, 30 Mar 2021 22:29:19 +0200
X-MC-Unique: RH_giBZ7NbedMS3fnm1iYg-3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jz5pnoIuUCGDEoUrZSdYEZXNfs31Ez1FMAXkA305H6kCf+500MbdZqXg4vpEgbMa+8znUa/oLi2Bn5MWovNE/D7KSWsIqxrPZ6ri43RbSkG9vs1l/wlvVJD0AN1KIph1bVh0bECKPIV19MeeXZcADooHQmDk7+fyfAETNzgDcAE/VQ+e8mIVVYC0QyltuWvxuYBWZ6hputFWPDn+qr4Z7Hx+xb2N/vMoMU3uECUdrCHQPZvMVr7HnsmPMsfnfswNjPnnRbusuIyQrloE+HBhuJmd9wjANeDl0upPDpNzZ+pB+xEgH44vMq2pkDLhWb+W7xRXCQvmTeskU6LHC0Av/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbSL2LwFQ69rW84cAtlFDOjNeTwax1Jt+e7+frs7VJw=;
 b=DrUxBQXde6ZHbe8U97npRfFua1TK0KS8aBUiW0kdctcts2tGpp4uunNjWF60scEzXlwMbagN5QFNEchirbFLjTqpEKGBITln4GGtdKH+YYkHOGv1impjNfnPCPt08zMaH0Z6uak48CFShsxJyb/RUcTS8+dkJQa3g05ndxzSNhgCb7dZ1tzkeuySHUYV5af2SwNnLMe9Iebt2ItDMjwCwuxrbt8me7P4GixxMgWct+uJjFTr6IOWoG+uSDy4bd1M1/hat5I34OkiPu93Oxyabm8xmePgozGofKqFAVvZMBaAb3BrtNsdqWK9VIlBrT92w/QfGGkYB2OZjIfY24n25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 20:29:18 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:18 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/18] crypto: rsa-pkcs1pad: Extract pkcs1pad_create into a generic helper
Date:   Tue, 30 Mar 2021 22:28:14 +0200
Message-ID: <20210330202829.4825-4-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28fec1f7-e4c6-4ea4-2a39-08d8f3ba7e46
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3393668383C766A7929AA864E07D9@AM0PR0402MB3393.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:98;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JZ/C/+R/wp8Rh1FWgRJ/4SBP10YY85ikOa5GMuGYiUAvPmTmvytMiG3Uha7b/JE/+JK/oLANNOiWf/h6y/3EEGhfLQYlxgFHQXPQmzf1zjDiuQleOqHJvbpoAnI/YFlOaedxJiWI7HlxAHMw3GkfhPOSx0zwGyyyURPfk2j5NbKPiiQYfS0lIoV5DYIWljbCE2dfOaby7Vqox5h4RMoN3xl1MURZIjiPD74otFnVYjICj9nJ98hLYJMob83y9dtzy1Ont1EOU/tTT68HX9KeZjXn6N2zzpNyIpTuYaTt2ApH2ZPnaDkQnewX/Xwn7+sH5bhdGL5a9RzZPtKJGiBM9mCHbJbr/2hQYdEL4R2Pxq0IgEDeWx3ofwXub+OnV6IwIDfRt4xBLUKlRUoY2jMNFMPrbHlrxEFOT7HtOKi5/e+U4AS+wUJJJnp1Z33RSWEMlyQMo78AshtR/dqk/HSkDFBJebGG/udTu5L3gCOpGSaStR+wDZjnt+xcjFBEg05uZgDXB41mFXaOzKwYUSfY4EHj4MzzrTX+KglNOaAXeyZKpUJP/Hv81A0iLjEHx8mWdCL1HRG8vT5Psv+m5ETq/102clocE7xh003OnNiVs08ZVb1mcBWAdHADxpgJT1oxYP2BbWJvQC9MhKwS9NYFUwx19vEBaY63XFQtaiBiem4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(66476007)(66556008)(54906003)(66946007)(6666004)(83380400001)(8936002)(316002)(6506007)(6486002)(1076003)(52116002)(478600001)(6512007)(5660300002)(38100700001)(36756003)(4326008)(86362001)(6916009)(8676002)(2906002)(16526019)(2616005)(956004)(186003)(26005)(44832011)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Xm5MVY2LW6ARPnpERD+0E7jIFNjwyp+ZnD7UGAl+eh6ACd0QZNDkbw/PspBO?=
 =?us-ascii?Q?M1cBnGbydwYa5J1yI8yLmKxIXo3TBxcfY/2iOdA8V9mNeYMH802vlaucnpZV?=
 =?us-ascii?Q?PwB41wd5miX09Wn/+cOOo/dtVIGyt/gMMldYaNebLBFbOvTd32bAzN5EL7kU?=
 =?us-ascii?Q?1yTjLFFosoDo1zxOoKjvINF6mQvrcGWIEUXm0es6+/nQX/cV3yN6B0lqV1Nq?=
 =?us-ascii?Q?ise/ngNmjNXQRLtsMAfvfIIrA9gjDtAAgfNO///72eMnWnP6DPV0E/RO3TZM?=
 =?us-ascii?Q?h/4ChlYbUEWx/y89r+CEvP6tG8TrimjuTTnfCl4l3YDG1v61ozo4sK/Trj/J?=
 =?us-ascii?Q?OOtPu3UnbQkqm8T01jQOCMPqe5sEN8hzx6PLXrDB8IChWzpXK1USx9oU5sx+?=
 =?us-ascii?Q?a6hNX+PPrQaaIKZaSWfE9IHyREC7QXaOP63HGZmzuAA2RyMXK7PAOGEidn/K?=
 =?us-ascii?Q?topevxyvzVVbgviddXYAC6vLjVdLDZsVto1jODDPzJW5G6+JB3PfmXsQ1K3F?=
 =?us-ascii?Q?4ChbqPy/WzFJoM4KUYsbrlJTncb5IPDUoIfgMLFIYrmlClh+necq9ZGo+9Us?=
 =?us-ascii?Q?U26kKxj7/n/cB4foSfoeQVsm3mod96CNTzu1/c1mG03OF9eyOfgSgzJCn6EN?=
 =?us-ascii?Q?PIEvJFdFqEUZR8zmjDeEjxyVe/rNjxj4M5pUX+VtTFweNrJserbOQNey0qeT?=
 =?us-ascii?Q?Lko1n3GIhOX6fIvwYJGYKT3DOQvf5rvUd7ndlyUtemgWpNo/zOgEfd2Dl+Q0?=
 =?us-ascii?Q?/1YkPjYyIxUOcWwCfyv58WBkud3BJ8okkPdQTMLMtpa5ogJ9BMTXjkPFjp+q?=
 =?us-ascii?Q?BQ1AhC0KzRNM2rbHPZgl81EYChNAuD/lNXonXSJGvFCbE3Eyt+lfjVpp5si3?=
 =?us-ascii?Q?kKtfiZSIj7Pe7X7246XjISzET6QstaLY02bM8zmmN89iUFNS76er1Jwgh3ML?=
 =?us-ascii?Q?qXfe4XQzyNlP9uv7+s3vAIyadQmErafJoZ6MEZOWtpU4Y9JKO1KdTQv5jrbf?=
 =?us-ascii?Q?qaTjRBWmRrP+woTSNp0F1t0GEPG8Q3HxIu0HBpfROPNPP6Wn858Npm4zz02s?=
 =?us-ascii?Q?UKcapkL3Zdc8QqpiIV/niK+n/vNIzrWtV9F6wAe0rj0NYPyq1Hnr3LxTzZ+S?=
 =?us-ascii?Q?mSjkpeo0rJBHMtL5xQzh08na0gD71gUACOw+DwBttFFAY5NRhC3iZ8LHFcoR?=
 =?us-ascii?Q?+O3NPk1hXuXRe9V2lkwoyxeBBKdu10d3v5WYUJXVrNT3W5YGUaN53+eUNaH2?=
 =?us-ascii?Q?t7uu8sEjswWlOic7zj/udSHO2xl5XdRPaQ5i98gy5mWyJM6bNmlcpnjoEeS9?=
 =?us-ascii?Q?HEpij+dVqZ23lEiFHmDbSf3m?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fec1f7-e4c6-4ea4-2a39-08d8f3ba7e46
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:18.2958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJUQZnCrJmD7ny5E95PpNo6Jol4N2qS5i3U7pnHQk2q+oAQ0rhum0KIvGo+uT4Kvl6ZGGd/m27GjdE6EcRlp/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

which can be reused by other signature padding schemes as
rsapad_akcipher_create. This will be moved out of rsa-pkcs1pad.c to
be used across rsa-*pad implementations.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-pkcs1pad.c | 48 ++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 83ba7540a53a..849573f6b44b 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -595,7 +595,21 @@ static void rsapad_akcipher_free(struct akcipher_insta=
nce *inst)
 	kfree(inst);
 }
=20
-static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **t=
b)
+static struct akcipher_alg pkcs1pad_alg =3D {
+	.init =3D rsapad_akcipher_init_tfm,
+	.exit =3D rsapad_akcipher_exit_tfm,
+
+	.encrypt =3D pkcs1pad_encrypt,
+	.decrypt =3D pkcs1pad_decrypt,
+	.sign =3D pkcs1pad_sign,
+	.verify =3D pkcs1pad_verify,
+	.set_pub_key =3D rsapad_set_pub_key,
+	.set_priv_key =3D rsapad_set_priv_key,
+	.max_size =3D rsapad_get_max_size
+};
+
+static int rsapad_akcipher_create(struct crypto_template *tmpl, struct rta=
ttr **tb,
+				  struct akcipher_alg *alg)
 {
 	u32 mask;
 	struct akcipher_instance *inst;
@@ -625,12 +639,12 @@ static int pkcs1pad_create(struct crypto_template *tm=
pl, struct rtattr **tb)
 	hash_name =3D crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(hash_name)) {
 		if (snprintf(inst->alg.base.cra_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
+			     CRYPTO_MAX_ALG_NAME, "%s(%s)", tmpl->name,
 			     rsa_alg->base.cra_name) >=3D CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
=20
 		if (snprintf(inst->alg.base.cra_driver_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
+			     CRYPTO_MAX_ALG_NAME, "%s(%s)", tmpl->name,
 			     rsa_alg->base.cra_driver_name) >=3D
 			     CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
@@ -642,12 +656,13 @@ static int pkcs1pad_create(struct crypto_template *tm=
pl, struct rtattr **tb)
 		}
=20
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "pkcs1pad(%s,%s)", rsa_alg->base.cra_name,
+			     "%s(%s,%s)", tmpl->name, rsa_alg->base.cra_name,
 			     hash_name) >=3D CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
=20
 		if (snprintf(inst->alg.base.cra_driver_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
+			     CRYPTO_MAX_ALG_NAME, "%s(%s,%s)",
+			     tmpl->name,
 			     rsa_alg->base.cra_driver_name,
 			     hash_name) >=3D CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
@@ -656,16 +671,16 @@ static int pkcs1pad_create(struct crypto_template *tm=
pl, struct rtattr **tb)
 	inst->alg.base.cra_priority =3D rsa_alg->base.cra_priority;
 	inst->alg.base.cra_ctxsize =3D sizeof(struct pkcs1pad_ctx);
=20
-	inst->alg.init =3D rsapad_akcipher_init_tfm;
-	inst->alg.exit =3D rsapad_akcipher_exit_tfm;
+	inst->alg.init =3D alg->init;
+	inst->alg.exit =3D alg->exit;
=20
-	inst->alg.encrypt =3D pkcs1pad_encrypt;
-	inst->alg.decrypt =3D pkcs1pad_decrypt;
-	inst->alg.sign =3D pkcs1pad_sign;
-	inst->alg.verify =3D pkcs1pad_verify;
-	inst->alg.set_pub_key =3D rsapad_set_pub_key;
-	inst->alg.set_priv_key =3D rsapad_set_priv_key;
-	inst->alg.max_size =3D rsapad_get_max_size;
+	inst->alg.encrypt =3D alg->encrypt;
+	inst->alg.decrypt =3D alg->decrypt;
+	inst->alg.sign =3D alg->sign;
+	inst->alg.verify =3D alg->verify;
+	inst->alg.set_pub_key =3D alg->set_pub_key;
+	inst->alg.set_priv_key =3D alg->set_priv_key;
+	inst->alg.max_size =3D alg->max_size;
 	inst->alg.reqsize =3D sizeof(struct pkcs1pad_request) + rsa_alg->reqsize;
=20
 	inst->free =3D rsapad_akcipher_free;
@@ -678,6 +693,11 @@ static int pkcs1pad_create(struct crypto_template *tmp=
l, struct rtattr **tb)
 	return err;
 }
=20
+static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **t=
b)
+{
+	return rsapad_akcipher_create(tmpl, tb, &pkcs1pad_alg);
+}
+
 struct crypto_template rsa_pkcs1pad_tmpl =3D {
 	.name =3D "pkcs1pad",
 	.create =3D pkcs1pad_create,
--=20
2.30.2

