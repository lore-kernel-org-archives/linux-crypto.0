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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584E7C433EB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389DE619D4
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhC3UaB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 16:30:01 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:22513 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232473AbhC3U3m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 16:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617136181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HlpGHqaYeGXnEKo2JeaAX1TbpV/icWdFmQYpEgrU7CY=;
        b=E4fci5gtuYz2Pro90EkMjhsbVk+Dy2h858KzwSqslVBXgKvHQ6kLAuvYeDo2FGo2N5yoYI
        JQ3C/cPyKPzr7kRJKeYMLwGR7g/ZUm+PDZTvQiCDJ6o0bjGdP4uJF0lnknjWwfLP7GzTgf
        hqoLgAIdkom68QdCucwfmJJB+m1+XK0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-UnILBn2JOTCGHzFkL57xnA-1; Tue, 30 Mar 2021 22:29:40 +0200
X-MC-Unique: UnILBn2JOTCGHzFkL57xnA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oc9vlZIvSGpGOYurEYwr11YJn8vg618X8Xggf45a9D7ZJ6NEhU+cUk9bWO+O28z35dlywQxnBtWBNpThLTgLPpFOF1iH5B1tnLVKMGVK9NdcvFGOumXa9vZPrvyxKoh/p0QZ52O3jJ83kkgmkbCT1rUWnWyhtzLYy9aQUNje2dAOtqSP7VvppXk0vNFRGET4HC2761dRA9q4GPqkzRRVsJ48/FJtr9loAhNTIvWOQBxfAzVQzZ/HD/X/vizairLPj5zD/UiGdN9OxYUFnpi6mXVu7ZN1cxg0EkVxlJrt3g2J2AyQH6mdS0daeB9hJy8iMybLyJGJMWCVB/yytMe+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkIZGWYrV4FI7k0iCKZqGE6/9dagZjVP7jo5FoyG/8k=;
 b=ffbTLfNXJ05Ym5RJkA9SB1MFz2oajyvUil1kpPfqw1HXOQeoLTd8R2Ns8g6V+uDqdheEO94TvrPXzt+Z16fMF74yPxFNnil+jJtOLsCNUMQqqjET66w/YW5npe8CuIV+b5lE3vCaBbq2ApJ+3yWKDydOPKg07PTMt0Yp4HZsoX77gHw3zQOuPJ4TRKh1FCloERX346kpvFGSW/UlpX9is0+DSw2J3N73032qPgtdv3GzjKCu+jBdwf7b60Cod7wdfA7rwdwhks6QEXd/PT2LXCzJva9K3ve816VUy/Bg3NhjN5on9Ank+y0ovnxURitY9pC1QbrHpL8GY+YSKYkcsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 20:29:39 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::40bd:b7d7:74a7:5679%3]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 20:29:39 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-crypto@vger.kernel.org
CC:     Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 11/18] crypto: Scaffolding for RSA-PSS signature style
Date:   Tue, 30 Mar 2021 22:28:22 +0200
Message-ID: <20210330202829.4825-12-varad.gautam@suse.com>
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
Received: from xps13.suse.de (95.90.93.216) by AM3PR03CA0066.eurprd03.prod.outlook.com (2603:10a6:207:5::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 20:29:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4212ce2b-f677-4528-b8af-08d8f3ba8acd
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2321:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0401MB232123FC698AEB219743F537E07D9@AM4PR0401MB2321.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSLECcvJkMY9Lof38E6FggzBCrLuCDT3ycBYAlSAd5aL9YvbkoKbWQ1mghGdcVzgiQ6o5wkvN6AkW/zFY0y6Bs6m5iMGE8Z8rtGbGD1XVN/zaHHLIHfwjjNocevgf3UsczEYEqH0P77eQhtVk8Wc4P1JZj5tGKjO2l5ETvUux+mKhPywjCIhj3qFTdPGLpSbEBPi0ApTs0lF+Zhh5JYSjdA1aJTJrdwyEz8yZz3iJrCvckNUxGXYl9V0iUr10O9bcz5aos0B3KHFShX9kUhze8Y7Y5ldeXYwBD/GB9fQDmbZR6sJRtMqqgV+vut6dgxxbs7Mt+aABCEucQ7RBY+9vT/5n+IsfugOrPB40CKl1Na5fkbxRTf1ysv8aI5YRbZXCD7udkj25o0kzoIpF00hRqQpgkqwEuJmjX3lsX2Bm1M1VaJCJaOIB6iC8Dcq39oRALXQCoJpl2fNs4iF96Ys47n/4aEhTHW+0HGFgQAj1SEvlXH2fMwyTCkP+0QA8ppChR5Lt3wk/uv0bHfjMS8ibb2e+9pTialoBj9E4+HEmWcsBtjVn0+p4kNsZpdbnG/OQBPQNB6ea1TD8A2SOZ8Vpt5uiV68qxxuOQSkPxOmDFd3XCfbiKgczV/KDRx1Bg6eHboVrzOyaPG1CmRWOTYnzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39850400004)(478600001)(4326008)(8676002)(36756003)(186003)(6916009)(38100700001)(66476007)(26005)(66556008)(8936002)(6666004)(66946007)(5660300002)(86362001)(54906003)(316002)(6512007)(1076003)(16526019)(52116002)(83380400001)(44832011)(2906002)(956004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1J+vg2YQlgcNphbUcX046Cl7JkN0SaWKGrnhlgKCDX4a/pZJk/ClR6X93CVC?=
 =?us-ascii?Q?+tmYgWCcYvb/PK6ydIcSAEkRyYHzBCshx6kSkZTMHkaTu/VBsHjd6eLeJtPt?=
 =?us-ascii?Q?yEwIofNcxiVEwclOvqA2ca5dl56dyQF3rYi2NLK86leyIbjHeiGSPDi3QCZ4?=
 =?us-ascii?Q?8jffJts88TKGkOW4jYYSbtKNIx3UZF4XOGyId5Zg1GjdfTta9TSh2C3u5rO5?=
 =?us-ascii?Q?p+X7G4mwsbx80MsMDj6qrqRUd6cmOsgfdYU4EKtt8gAzdDXVhXtmex8l6/fB?=
 =?us-ascii?Q?nn6LxSk+xztEdVb19ODBRM69JY5yxKPLdPHhYhNAQlcr3xNvEOFua7sNma3k?=
 =?us-ascii?Q?gdDcEiT4L08er5WIljimO/zSzrVVUvvu7I+eh+Y8Hc4I+WruoNtH/b7ldVcD?=
 =?us-ascii?Q?zp/bZq5oH7JGc3NNbAYUyQJzHWl7VOX7k8UiZs3uZmgcLkxH0wk8dYVQO5AK?=
 =?us-ascii?Q?9BshFepho2euZ3k43MuVeRJz3kFxPeYWnEVTkPrKL08lZUdB94RwZ/P3uyRl?=
 =?us-ascii?Q?5k9KzlY0HsbyAgF2UOzyuLf8he2Vpe2ojlRVxpV5Qt0k2wkWY0+DjjHvsNad?=
 =?us-ascii?Q?D/KxkjP1CjtudUFfvyF+rUgf9x1UcxqDaFUbIjq1FrLhsNavBVhQDgDkwXMK?=
 =?us-ascii?Q?JKn4DHFW4BKHmuCHjI0DXvxT3VN2hpBCbjqQcyCF3YZra2Xt3CEso+TZSpws?=
 =?us-ascii?Q?RkLaoMoKpRmA9YHdRLEGVKroj8sXyMW2Dg6kPKoUi2FC1GECz+w+GiSpG+ur?=
 =?us-ascii?Q?/WH31LD1MZoHXhxKkQinGDH+8bRDMPpV+v6qjXwIoFaCTpBRLwM5+UCa7Y2l?=
 =?us-ascii?Q?H6XY9A46EdujEAN5AG0hoYxl0V3EGeQXGsoQMIb8KI8DOCwVejyCz3rfj0L/?=
 =?us-ascii?Q?UHQ42C7Ji/G6Rexrwd4TViD5HbSpw3/tTxdzdw89U/EXQAuIdj0l6Z9APtrF?=
 =?us-ascii?Q?lpEKvp/FEE2OQCAxlG9LpVxTUaDcPPUg5uhMZBxUzK65adkeJOJJasJq9NyI?=
 =?us-ascii?Q?1REqCBvdILPLTOMNqICveZpi6Tsf8GHle+YIM2f5Yid0tUp/byF6eVx53Ox4?=
 =?us-ascii?Q?ZBcyw9LrizDwlAT5vLWqwWydAN/mEHPYqrqHln09gJLvI5N2Ky4ufzBhD9qI?=
 =?us-ascii?Q?puAGOPuBrGH0rvNLsq4Z9X6TH1dPPNQgNHLYPv/IQK/FdLBfSim/+W1kYeTr?=
 =?us-ascii?Q?04u3RNnIAlcVCxovSkM+JMu1T1pNhNoVN2yxHngsypdmLrUf587KCPKE93MB?=
 =?us-ascii?Q?eu+vxExhmaZmPHwlP3sCaJ5AuHYmzhKz2auBX1/geX7MoYW9cTq3Fi3m6M3I?=
 =?us-ascii?Q?3DA57hvZSTeI6EcmTHEgv5YV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4212ce2b-f677-4528-b8af-08d8f3ba8acd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 20:29:39.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toKqAIUo1MRcDNfy5RCzxX99uysw3mMcUIJSEWrOq5YM1SQB45EKEVI3wWKWACOn0e6o6Ut16IJdNQeRfCizdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a crypto_template for rsa-psspad, hidden behind
CONFIG_CRYPTO_RSASSA_PSS. Set the sign/verify/encrypt/decrypt
operations to return -EOPNOTSUPP, to be implemented in the future

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 crypto/Kconfig                |  6 ++++++
 crypto/Makefile               |  1 +
 crypto/rsa-psspad.c           | 39 +++++++++++++++++++++++++++++++++++
 crypto/rsa.c                  | 20 +++++++++++++++---
 include/crypto/internal/rsa.h |  3 +++
 5 files changed, 66 insertions(+), 3 deletions(-)
 create mode 100644 crypto/rsa-psspad.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5809cc198fa7..3aedb40aa08f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -224,6 +224,12 @@ config CRYPTO_RSA
 	help
 	  Generic implementation of the RSA public key algorithm.
=20
+config CRYPTO_RSASSA_PSS
+	bool "RSASSA-PSS algorithm"
+	select CRYPTO_RSA
+	help
+	  RSASSA-PSS signature verification scheme.
+
 config CRYPTO_DH
 	tristate "Diffie-Hellman algorithm"
 	select CRYPTO_KPP
diff --git a/crypto/Makefile b/crypto/Makefile
index 57a85b2b3429..88be24b9bcb2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -42,6 +42,7 @@ rsa_generic-y +=3D rsa_helper.o
 rsa_generic-y +=3D rsa-common.o
 rsa_generic-y +=3D rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) +=3D rsa_generic.o
+obj-$(CONFIG_CRYPTO_RSASSA_PSS) +=3D rsa-psspad.o
=20
 $(obj)/sm2signature.asn1.o: $(obj)/sm2signature.asn1.c $(obj)/sm2signature=
.asn1.h
 $(obj)/sm2.o: $(obj)/sm2signature.asn1.h
diff --git a/crypto/rsa-psspad.c b/crypto/rsa-psspad.c
new file mode 100644
index 000000000000..0e5422b05c08
--- /dev/null
+++ b/crypto/rsa-psspad.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSASSA-PSS signature scheme.
+ *
+ * Copyright (C) 2021, SUSE
+ * Authors: Varad Gautam <varad.gautam@suse.com>
+ */
+
+#include <crypto/internal/akcipher.h>
+#include <crypto/internal/rsa-common.h>
+
+static int psspad_s_v_e_d(struct akcipher_request *req)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct akcipher_alg psspad_alg =3D {
+	.init =3D rsapad_akcipher_init_tfm,
+	.exit =3D rsapad_akcipher_exit_tfm,
+
+	.encrypt =3D psspad_s_v_e_d,
+	.decrypt =3D psspad_s_v_e_d,
+	.sign =3D psspad_s_v_e_d,
+	.verify =3D psspad_s_v_e_d,
+	.set_pub_key =3D rsapad_set_pub_key,
+	.set_priv_key =3D rsapad_set_priv_key,
+	.max_size =3D rsapad_get_max_size
+};
+
+static int psspad_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	return rsapad_akcipher_create(tmpl, tb, &psspad_alg);
+}
+
+struct crypto_template rsa_psspad_tmpl =3D {
+	.name =3D "psspad",
+	.create =3D psspad_create,
+	.module =3D THIS_MODULE,
+};
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 5c4eece5b802..de4ad34f9cd9 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -258,17 +258,31 @@ static int rsa_init(void)
 		return err;
=20
 	err =3D crypto_register_template(&rsa_pkcs1pad_tmpl);
+	if (err)
+		goto out_err;
+
+#ifdef CONFIG_CRYPTO_RSASSA_PSS
+	err =3D crypto_register_template(&rsa_psspad_tmpl);
 	if (err) {
-		crypto_unregister_akcipher(&rsa);
-		return err;
+		crypto_unregister_template(&rsa_pkcs1pad_tmpl);
+		goto out_err;
 	}
+#endif
=20
-	return 0;
+	goto out;
+
+out_err:
+	crypto_unregister_akcipher(&rsa);
+out:
+	return err;
 }
=20
 static void rsa_exit(void)
 {
 	crypto_unregister_template(&rsa_pkcs1pad_tmpl);
+#ifdef CONFIG_CRYPTO_RSASSA_PSS
+	crypto_unregister_template(&rsa_psspad_tmpl);
+#endif
 	crypto_unregister_akcipher(&rsa);
 }
=20
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index e73c61f788e6..4c168ea2f050 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -61,4 +61,7 @@ struct rsa_mpi_key {
 };
=20
 extern struct crypto_template rsa_pkcs1pad_tmpl;
+#ifdef CONFIG_CRYPTO_RSASSA_PSS
+extern struct crypto_template rsa_psspad_tmpl;
+#endif /* CONFIG_CRYPTO_RSASSA_PSS */
 #endif
--=20
2.30.2

