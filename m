Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EF6C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34CD619C5
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhC3UgS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:36:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20624 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232307AbhC3UgE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XUVg5BBgdFXsc2H1C8EIMxYoosMquJf90zH039YmSL4=;
        b=UVSRhyM7iFrka885EV/D6NVdroSwm68acAl2hXAI2TyaBIYavh3PvL7JckXthe1nFPN/8t
        yekvhwyLbCtg8FXBebHW4+1EiOjhn3E2qbOIMo2ICKK3Ddt0jAY2TEchUDr0FOTxRqe0mh
        /mWh09+7xotHyQ7asdUwC6XNRALqjTY=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-dByZhiZvOIO9GcOES9IQlQ-2;
 Tue, 30 Mar 2021 22:29:48 +0200
X-MC-Unique: dByZhiZvOIO9GcOES9IQlQ-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBfipcKiOvajlM9cZ14HGag7GkWzOrB3LjNThh41cpTcZCA5i1FvPXrFxXXPdEPcA6wo+uMhKIQR76vKkqZLXELfJuYoY9TL7T0z6zR/TsrmnaibY/oJ54X8kFk75c90RobVYzeaiWJRU2OikZyl+kugpWSYx8RRJbXNrjtsttFhV05E+UhQiRpjTlwozh1Wm6mJXmWFWfQNrrdm7fCiNSJyH/iUC3NEXAd3NI93zCquk4PNLNCKve+FuUMpATCUbHvSbakDYW1AGK1antlRotJRUdO1u6wIJs+K/73U3DVMTYqBgSmsyzIrcua9GOZGZ6z4PAqvM/wC0wszEGK9lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkjgOiWlI/jvnXQWz6NmvykeSG3dzDSdJyjEtGxExSo=;
 b=Bjk/GWq2mSfI5JZBsTvkpdM5UuPpfD0T0sTGIVc8Bt8CcWRhI0uUiSk/A+IPjCsIbL/DFPhweqXlQpKFQ39YMFP2rQvJaFBiz+P8cv2aMGdugywJXhuUI9GCWm89hXWyc3qimAUI3VmPonUDorcFiv1da341OtRijosyl9f37XSZbFu/5vhUgR0DtvE9UNkGfQlhw3zYgs2hOyzBpqjFd53FHM+YZazfE0VlMP/kVdeLPppdwKlLyeVs3WzubNEzpBvxlCpf2lR+tklWmGW0fFNXJ0DKIZiXFl3d70Pma2bae5ZNrnYopo00BgcY6GI5odfjWHsg577d0bU0VlI2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:46 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:46 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 15/18] crypto: rsa-psspad: Provide PSS signature verify operation
Date:   Tue, 30 Mar 2021 22:28:26 +0200
Message-ID: <20210330202829.4825-16-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a642207-e0ea-4b9a-906a-08d8f3ba8eca
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB232135237C254C112D5CB9FCE07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ke/abtQ5UB9ORSJKNVpF66WpGs/PBoFlspuGZ4HaOW6zoUFgiicNf89Nrd38ZPrii3nmKrxXZ+Ezmmn57aE960WH19Tk+QKhRo7DmJJYmByIN92oqFCOJE2ANGzZRRAhnQmuT7DBmbqk4/FblG9mFQOtmaFj+oT50JMUyrp04U4bQELTDSHwVvUBc3tQjn/+iQr4752eBajT/9xBCOVE61DNt/Bv1u469JghYAJ05aXuUREIfWJ6jDkauF2tHWaiNnPucFvJV6bTxW6Kp239oFS1rNpq3GPVHWhBOvTI99Zno2xA+FT0O+MS0GKDe0SNuyzWW64r+eLUQ/h+LllCLS10M86eoyVOueWIXpQrWNrgLEpIs2Z2dgVsNF54MNjv+vjiI0Mlw9SyFLb4eQ1YKHcvf+Se0d4BujO23bM48ZNZNf/gJMpfvvRQ1NVMNHVHLl7TR8daHVhuvZyl41iHs3I6HfaYXcu13bKLJ90BtOUiCviuRUHXzt93wad7Ybw9BOp2TowToop4dX+rY1j4bCpMgKJd3JshBPz8MH41HpskexUWBRIDMsf8Nsz5MCLUaBZ8vCBkj++Dlm3nTxgUYLwiKmfH6SZptGzkJ7e9nbm83mK6UReaqzvEd1JKCVxDF8uk2um4/yT+Brpw3dfbSB4f4CqpPH3xBJwxNgJI6ImVl7SytPYmCTP/B8EZF5X94IJImankdrmE0sAG1UkhXLdD25YOBWEQQs3FZDBUE54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(15650500001)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0q62wzYniON4Z6L6qOql/B0L8kb3LxudCo7ltuuUTUKHWkfrdS8IAOMdpP8b?=
 =?us-ascii?Q?2bbcjDQ119ExI8B5O3ou+0mZBeW+2n5WMQlP+oZMu4hMo4fs8pi5TGh5977O?=
 =?us-ascii?Q?FGM1/LRzegmv0RtENMh8VBdsYA0nfHJMxR7PPxXHB44cjXEtgawUGi7gDn5H?=
 =?us-ascii?Q?HbmD5ysAbuDqHhFQts4wbe/INkqR8y51Q90TZdm8IvEVlxg/4dC5mIEkAx6n?=
 =?us-ascii?Q?GKoieoP8H9KjB8+rBQDCppEAkHQv1ERe47arleuujq3IrEsHNBPG3fD5qJPx?=
 =?us-ascii?Q?ktMsnaOib0qA45tyWqvIqG0CfuFWISq1aXhuNkznGdC2Im4aPGC8NH+y2KoX?=
 =?us-ascii?Q?bbqlNRbebvPRkbhV38Am6YqS8YgNtkoAE7Z7fXBptduDhsIu133xsver6PuB?=
 =?us-ascii?Q?G1tcBljtP61uvRVfpg5OP/kziiGBeUEzTv1ZfRQeq0E8rE927Zh063Xj35b9?=
 =?us-ascii?Q?97MVbG2kGZKtMS8nDfDv4uyhS0qWthQwUsigMOXhoxFo6Pi4/IdgYzDgipOi?=
 =?us-ascii?Q?+k3Cu3smsiGwO4GbZV0p/zhfBew++THReIa2/JWF6e9HRYmh2hQVvqe4tyee?=
 =?us-ascii?Q?YY7XGUxjMH20XLPZilE7NJWp56e/gTs20/fXy2IYZIasup+LxdnP4CtKlDSm?=
 =?us-ascii?Q?v0AL3zEgfXBHoYjI8u/CaM3HJMEF9UvY4ROLiCqD1gIbgk7nKE0IJNThs7Cw?=
 =?us-ascii?Q?1t10xzy4vY5DF0MezdHRkWof7DChgeVk70l0DNqyxLmW1Jag0SNXscAjedJi?=
 =?us-ascii?Q?ZAhKC0h/9plUWaMzR8yetL3KfzJLaVuebTOAtVXTo/MvGP0fRP13Bq19HPjN?=
 =?us-ascii?Q?2ItseEmEeHKAloO+2WPnTN7OZnHlCdqV6Lix/MZurEC2w3bdXsdQSTU4c9Xb?=
 =?us-ascii?Q?vWRTwi/wucK1GnGWfqko3754BZrZEjSkvhscGVd0hUdr/1V/MbmrQKik6+I0?=
 =?us-ascii?Q?OkT56Z6A+q2X9jH7h/RtP+olfxaGI69kfJW1Hzz0WJ+hPVH+8ToK9r4Ei6lb?=
 =?us-ascii?Q?rGD3qyXqXPLjHruqR3pOV2ug5k0s8mAXV0sxo4aPAfmbGt9tHEtfFNfcGlIf?=
 =?us-ascii?Q?CgpciCMjgpfGxGnM6Z3WkeYfClrN7jsXe81QkvkSZawc0i8w1QNNO+ofmqsb?=
 =?us-ascii?Q?SVDtzpEjX3Dt0oTgXjr4rVaLLeA0jWeX2Q5JC04HXOtCwQSaTv6sOe0rrH2p?=
 =?us-ascii?Q?/Bmhe8bn2D9DJMmfOQN300ed6PRXhssuHtlXb1bRnASgvYhinGWiLKjIZuPP?=
 =?us-ascii?Q?Xf1HCGswF4N6eMBIsw9ifzyD9iOxY83TnobNV23HHVENz3+85ZDvIIQpBAMM?=
 =?us-ascii?Q?EvoDy5qbo998f2UcH5S4FwvS?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a642207-e0ea-4b9a-906a-08d8f3ba8eca
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:46.1479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1erxkLnA+dbb/FkUvxWaNyBBUHdTRDnb2ddK7yqeH9OqV1FRTJUbxboODWf++CL0Fy0nm6Ho9B5mQy4LgTIug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Trigger RSA transform on the signature being verified from
psspad_verify, to produce intermediary data which will be handled
in the psspad_verify_complete callback.

Reference: https://tools.ietf.org/html/rfc8017#section-8.1.2
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-psspad.c | 53 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/crypto/rsa-psspad.c b/crypto/rsa-psspad.c
index 46578b8b14b1..1ca17b8b93f2 100644
--- a/crypto/rsa-psspad.c
+++ b/crypto/rsa-psspad.c
@@ -104,7 +104,50 @@ static int pkcs1_mgf1(u8 *seed, unsigned int seed_len,
 	return ret;
 }
=20
-static int psspad_s_v_e_d(struct akcipher_request *req)
+static int psspad_verify_complete(struct akcipher_request *req, int err)
+{
+	return -EOPNOTSUPP;
+}
+
+static void psspad_verify_complete_cb(struct crypto_async_request *child_a=
sync_req,
+				      int err)
+{
+	rsapad_akcipher_req_complete(child_async_req, err,
+				     psspad_verify_complete);
+}
+
+static int psspad_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
+	struct rsapad_tfm_ctx *ctx =3D akcipher_tfm_ctx(tfm);
+	struct rsapad_akciper_req_ctx *req_ctx =3D akcipher_request_ctx(req);
+	int err;
+
+	if (WARN_ON(req->dst) ||
+	    WARN_ON(!req->dst_len) ||
+	    !ctx->key_size || req->src_len < ctx->key_size)
+		return -EINVAL;
+
+	req_ctx->out_buf =3D kmalloc(ctx->key_size + req->dst_len, GFP_KERNEL);
+	if (!req_ctx->out_buf)
+		return -ENOMEM;
+
+	rsapad_akcipher_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+			    ctx->key_size, NULL);
+
+	/* Reuse input buffer, output to a new buffer */
+	rsapad_akcipher_setup_child(req, req->src, req_ctx->out_sg,
+				    req->src_len, ctx->key_size,
+				    psspad_verify_complete_cb);
+
+	err =3D crypto_akcipher_encrypt(&req_ctx->child_req);
+	if (err !=3D -EINPROGRESS && err !=3D -EBUSY)
+		return psspad_verify_complete(req, err);
+
+	return err;
+}
+
+static int psspad_s_e_d(struct akcipher_request *req)
 {
 	return -EOPNOTSUPP;
 }
@@ -113,10 +156,10 @@ static struct akcipher_alg psspad_alg =3D {
 	.init =3D rsapad_akcipher_init_tfm,
 	.exit =3D rsapad_akcipher_exit_tfm,
=20
-	.encrypt =3D psspad_s_v_e_d,
-	.decrypt =3D psspad_s_v_e_d,
-	.sign =3D psspad_s_v_e_d,
-	.verify =3D psspad_s_v_e_d,
+	.encrypt =3D psspad_s_e_d,
+	.decrypt =3D psspad_s_e_d,
+	.sign =3D psspad_s_e_d,
+	.verify =3D psspad_verify,
 	.set_pub_key =3D rsapad_set_pub_key,
 	.set_priv_key =3D rsapad_set_priv_key,
 	.max_size =3D rsapad_get_max_size,
--=20
2.30.2

