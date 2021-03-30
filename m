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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD80C433EC
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2456C619CF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhC3UaA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:30:00 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20614 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232455AbhC3U3g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I65mV+PIIl3VRquXzisMZaiDhjOgopTOPxB/0TnfXOs=;
        b=mqLKpWcn6aRQJxHbQfZOUvuJBXS7I+gKwQsmJdOvyge2vNeLTVEIxC9GUSXLGXHH6UUJ9q
        4V6K0rtTEcEfmseVD4Lst9FBVehIiTWU6+zcAIl5reCPauFQUIHcrAAstZ4mUGSD4iHFIU
        AUAAL2yUB4lveRpdAyR5D0nDD1ceS6k=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-VbAvbaQxPP2kqf-dsSqA5w-1; Tue, 30 Mar 2021 22:29:34 +0200
X-MC-Unique: VbAvbaQxPP2kqf-dsSqA5w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=On8gGmndxoUdHMFM7xU4y0x0s8d4NDMj1Gjc/+MSxMoas+kYOSTgM9CxURgdlu0RiVcIhaA2fuFypJwhI612AVY8H8sRu9QfKo96F1+gaMBV4j74BNEKs7zkRBzWDglu1PdQyjDl91xGFAcWPzlPLfADK9koDlD/k2ScpI3rQUCbW6mu1freHU8t4HN9MGPw3w52Qun/d6DjcDgxbRWin1TQvjZ4yVPR45qU1n/zV1YYINCOlMtsPswGN5iY0/x/o3+f5lfMIatoCnB9+Cx/T43IpPbit0e8ut58qy+Xaq11pFk4WtUQsrs+d5YOnd2ej7qWtPEwxvh4UDR9Ex6+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUbavBm2NRZ6YjYW77yaS1bS2GmZfFG7RJ2VzcSHI4A=;
 b=IWvEYQafUjnxR0xLG4AdSsDSOZY6NVUOxkV9dCpzYeckgn2xEvWyoHyCRoJE22nqhOy5LmBQhYoVmD5GvHS1eoSYzbkDhU4uBVhk8MnXXdCJ6P9NVZYvnTjq5gE71S6Qc4Tbrc63or6a38v2AbmHholHyvZvCIshW6JBEcLluOdP2ML8gDp+b1vU72UgjBg1d+zwrcLFMQm+f00iOIPPWrgE24TAZj0PhCyUhKdGigz+vUuB8jAKBrP7MLFaQ/9pwWR5MiW/DPty2sSMCl1YV7Q6RF9Q9HkVJ1NO1F3w/pFjrCWeXMzhDlMO+lNIsNMq4rHRGUrYwrwmWaQK8MYj/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:33 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:33 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/18] crypto: Extend akcipher API to pass signature parameters
Date:   Tue, 30 Mar 2021 22:28:20 +0200
Message-ID: <20210330202829.4825-10-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0be63ca-b4d8-47c4-543a-08d8f3ba86ec
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB232150E3FD80859A754A8F6BE07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTPdW2/KDY0Jem7KAyFSJ6RPgxBQTnRtN87c9wU2lW5ba0ZBuLpgy+LqZHZpJF+C+D/TCiqHADzcPJ6bvEgZORNgGamxnV2UMfHw3Uzmjp+OJP4S8EZzUNGIzBJPw5ubm312jp7Yd2/NoFqX7OWHFSGbXEPRx6o1QBFHuaLopJQpN+T+aXFldcKm0CeIXWN358WoyYJ/22Y0b49LY1KZe2TpIPHoCr226TCQGGeRFbHQnr4Hb1M7SQclfgwHxh172BjLeLDwAg283rAVPt21xjtpunoNmOdGDNumiI862dAETFSmaWYzt7ddAn6JMiia1kytA72NmokzRLFQvLFq8c0Rq/rK2tQDQfSSePrX+y+YcDPupLoYUm+64dTEoKmTPz9EDy9SkaMCMszoblHm/11iHcHi6WYcb9qrVi9VscRlRLpQ2Zln3tlcnkcNZHEcHQm6AYd+yFFc9WrIZ9TMT81RQc/a7jRLGntd0SekhHMk0dzh7VBVTV9bjzbW0iskHAwzz40P/YjXBh35Xi3u0mHFsIJRxIclUSd5yHrEob69kjoqoV5H/9We7LZh/I086HSbbmlpZRoIEw02MQQ2aNvbepfV6n7Bs5csX3TPLoZfqs7G+lL0bKz2o3u7rnnHl10sXQD7Jkz6FYIpFxmIjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g5Jj2Bb4KVC+GqZ/bDBgeXvSjEyTqlS850Ttp41dI03fbDb7ZEuTLjkgKDCl?=
 =?us-ascii?Q?7BsPoFVfvKznWVU4y2W/FHL0W7NNJF8mbvnHx8Ws4pzSvv1xTEYvwSn3vJXC?=
 =?us-ascii?Q?WMfj3Ym1ojQKtIcNpZva9YLW/i0R0qlqOr+wNPHRlM/0VfEz3+H5pd4d+HKR?=
 =?us-ascii?Q?6mbz8kMPacSygiuNP9JwS79X5fmzHMOmA7XHxCl50pzmxiEyVVB8ovN4W2Dm?=
 =?us-ascii?Q?mfrdG4YWJiuqQWMbVSt6WuDUPNgtAMSeaRxRf4KLl92+B4+i1Q4QWJEO1Fch?=
 =?us-ascii?Q?14Am2yYzAiXS+diw/pOAx2ZHkhWnLOmG2Yb/rE31RTacND7z7ghv2qnNq4wa?=
 =?us-ascii?Q?eGHnMxaQFx3ny+UbYK2AeRZhJG/lYLvIfugRjoVQ3TC6X4mBcUL4c0gEMkny?=
 =?us-ascii?Q?W7TekufRDvdMB0zg9gtnSrUFkn41abr4439INrZmuFfwHrJVWy7QYpo9hjaa?=
 =?us-ascii?Q?Sw5d0H8GOI2Z5DO7prN7GXpBVlL9kD+hH2eZn36h3o80RUZot9yC/03YQQEI?=
 =?us-ascii?Q?f5x/4uBZ4uCAftKRVV7jbkCuZ0hkdxhOusIUdYEWDvlDtrm70qRrER6aWGSk?=
 =?us-ascii?Q?E9kKlRNEKiarmYEwmBNnqJ35OS0vYmUCkG8vGR20eGYR9DEKmfsJQL6zXC13?=
 =?us-ascii?Q?XgebnTbwmLbie4k+GYS+MZ2M3rf7VyspdCQ069VJDNiHh9YG+wcY1VpQ6a99?=
 =?us-ascii?Q?45lTTLZLKyHEPVk+hILxF+8HJxRaxmtSUSdtcVTMCO2KHmT5hKn1YTY3TNjo?=
 =?us-ascii?Q?AxqgdkVcfo7ijl8Q8wcUgcmDmPHbLnV8qST0qfWcLOzIFCXcvB5DBUQGl9LQ?=
 =?us-ascii?Q?Ikzq3DoDWzJzIQ/zqyQyF3CjJ/TIp1NEnmKazcxW7tbSLpZfmmMARVazWeSp?=
 =?us-ascii?Q?P681MFhSo8L0XglCEOBSHN7sQKZGHWOBFUG+vipEQyOE3ou0E2voGjQQLWpq?=
 =?us-ascii?Q?GiM67KAbEyyDwDoW0cDMjFdIJwiXz9XVsOSJWyYAyiBdOT8uSlVIZjd5F7h7?=
 =?us-ascii?Q?lNOMX85R654JQTi7awlww17keFY8lBLwgNkzFDpR5RWqnwtga/kYfoo6mFfL?=
 =?us-ascii?Q?877zIJ07tbgeauOmNDdZxjorZQkUxyK8khheMwUDC8kqYRghhtwwJeX9ZETH?=
 =?us-ascii?Q?fDXuFLAL1FjT94ZXnUhN0APRJtAwCvhaUSC3qwSLl16ERHqFilIr6O1MeQvJ?=
 =?us-ascii?Q?49I3jdTYq/xzo79TLj7RfPbTkJfbTHxdHxBMFklgVXzrhkmU7SoscXt75YLW?=
 =?us-ascii?Q?Cdqj2vGjae7BJPOhr51xPed8sFSISjChPqT3bG85Fd8gigZ19nkr12xqThxg?=
 =?us-ascii?Q?4en84lrDU+TBF67vWoKPKDaM?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0be63ca-b4d8-47c4-543a-08d8f3ba86ec
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:33.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NPkTy4m/tH6y44OHL3QVlBxwOb5KapcDo0F3onRbxjH/chqQQIAtXA59TQOT6E0MmBi1MyYfcdSxamxZk0DSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For certain signature encoding schemes (eg. RSASSA-PSS), the
verify/sign operation behavior depends on information contained in
the signature blob. Allow passing this down to the crypto_template by
introducing a crypto_akcipher_set_sig_params() call.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/rsa-common.c       |  1 +
 include/crypto/akcipher.h | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/crypto/rsa-common.c b/crypto/rsa-common.c
index 6ed258a78287..f80cdfcc1f9e 100644
--- a/crypto/rsa-common.c
+++ b/crypto/rsa-common.c
@@ -277,6 +277,7 @@ int rsapad_akcipher_create(struct crypto_template *tmpl=
, struct rtattr **tb,
 	inst->alg.set_pub_key =3D alg->set_pub_key;
 	inst->alg.set_priv_key =3D alg->set_priv_key;
 	inst->alg.max_size =3D alg->max_size;
+	inst->alg.set_sig_params =3D alg->set_sig_params;
 	inst->alg.reqsize =3D sizeof(struct rsapad_akciper_req_ctx) + rsa_alg->re=
qsize;
=20
 	inst->free =3D rsapad_akcipher_free;
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 1d3aa252caba..a0e872029429 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -101,6 +101,8 @@ struct akcipher_alg {
 	unsigned int (*max_size)(struct crypto_akcipher *tfm);
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
+	int (*set_sig_params)(struct crypto_akcipher *tfm, const void *sig,
+			      unsigned int sig_len);
=20
 	unsigned int reqsize;
 	struct crypto_alg base;
@@ -413,4 +415,28 @@ static inline int crypto_akcipher_set_priv_key(struct =
crypto_akcipher *tfm,
=20
 	return alg->set_priv_key(tfm, key, keylen);
 }
+
+/**
+ * crypto_akcipher_set_sig_params() - Invoke set sig params operation
+ *
+ * Use this if the verification/signing operation behavior depends on
+ * parameters contained in the signature.
+ *
+ * @tfm:	tfm handle
+ * @sig:	ptr to a struct public_key_signature to extract info from
+ * @siglen:	Length of sig - should be unnecessary if you pass the struct.
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_set_sig_params(struct crypto_akcipher *t=
fm,
+						 const void *sig,
+						 unsigned int siglen)
+{
+	struct akcipher_alg *alg =3D crypto_akcipher_alg(tfm);
+
+	if (alg->set_sig_params)
+		return alg->set_sig_params(tfm, sig, siglen);
+	else
+		return -EOPNOTSUPP;
+}
 #endif
--=20
2.30.2

