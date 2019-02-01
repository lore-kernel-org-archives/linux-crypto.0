Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F418C282DB
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F365720B1F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="J2ModgVQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfBAHSY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:18:24 -0500
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:26063
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfBAHSY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLYUtDgVu7fsGJw2kTC4dN9tXafrBNh9m7LacZz1pAA=;
 b=J2ModgVQ84d4Vk6EsWKGk/AshlcipeoyFw9qfnzs7jBsHLscxY7j89gqGUtrWdvee3V3sVjHlNEtqJ7rnnmEyuxqZZcjSquY23J5zYdxZbBJeY+96x1QbXk8aeET5NgKvaL8k+WVjq1/mFDcqwrmLKcEV3MJb+NWiB1QGlk4348=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (20.177.40.158) by
 AM0PR04MB5026.eurprd04.prod.outlook.com (20.177.40.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Fri, 1 Feb 2019 07:18:20 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9%5]) with mapi id 15.20.1558.025; Fri, 1 Feb 2019
 07:18:20 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arun Pathak <arun.pathak@nxp.com>
Subject: [PATCH v3] crypto: caam - fixed handling of sg list
Thread-Topic: [PATCH v3] crypto: caam - fixed handling of sg list
Thread-Index: AQHUuf5P+0KF1Z/2Sk+aVX6RArB4oA==
Date:   Fri, 1 Feb 2019 07:18:20 +0000
Message-ID: <20190201070642.71800-1-pankaj.gupta@nxp.com>
References: <20190131070556.44832-1-pankaj.gupta@nxp.com>
In-Reply-To: <20190131070556.44832-1-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [92.120.1.69]
x-clientproxiedby: BM1PR0101CA0064.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::26) To AM0PR04MB5089.eurprd04.prod.outlook.com
 (2603:10a6:208:c9::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.gupta@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB5026;6:H+Jsfae2JJ47J/tqH+m7ZhuiFcco6LTGXfLBFdBE9xTayPHHs0qAHtL7F1OZJaxVJA4pkRH5PjVIt5CFHv6AH0rqARUlcTO6AIVmMs5vUahSzTYkOGQMw+8x+7zYyaoh09I1yLex9s/M6b/o8Wk3JWmn0Ts6mlp/6ZN4FyXRijsy/TUx/nyZML3uGIghB+ep3oJoBodLMUvS7LRJvGnNPuJ8j8/TtyISRZvUzRQw63dbFFwjrNe4JgMP8QHFAm21OuGSNqbKjrRH8EIn1aqUmnIMXHheBUB4YG344GlljrD/ADMVINssuXvLZC+8v3wltd6CiJtqEYYGffcuOFBzp4RKHPxz0eDz0p2AjTQtxhD8SJEzYGpvhm47t9/gUXxJC1enzbcus5wX6xy2bdeXKUSN59B+YfyZpElvmvyR07U4BLk5UwuSlnQvs9Dn9iPCfq3XBO8srXSWzj9bYNm4aQ==;5:cw1NlbFuQxty1BMKwc3CxVr7qgs/FEaF1EjM1n5BvQ6R56uGLsOA5O6zjObS1OAmZkW+jFESliMj3/oxZRSDxSSAKgp6ULCLyMiJ0oQZm1R8d4B6HCVOy5B4zpI9t6miTQKFZUMofNRQuoUF2kDJVuW7sorZ78My5N5aq6mL0dNTclBawyG0xovtC899j4hQgoSHSgW4OTVnHyOJ2XY4pA==;7:BNqMySfFvRzO5TkX6RWSJcoB7Rfy0GDJr+LTrk+AUvY1bHcyrw2pYolKLXOhv0B/iv6Bh/WwX4EJXXCytok/l4hM68WqJU2aTdocEoUg0yQHDNUSaNTmjbntvykMQnmxISdhAHKPwiIEbKtkrm+zDA==
x-ms-office365-filtering-correlation-id: 5824a5de-9f8c-481a-0869-08d68815718c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB5026;
x-ms-traffictypediagnostic: AM0PR04MB5026:
x-microsoft-antispam-prvs: <AM0PR04MB5026AF55AFF944B5FBF6EC7595920@AM0PR04MB5026.eurprd04.prod.outlook.com>
x-forefront-prvs: 09352FD734
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(366004)(396003)(136003)(199004)(189003)(446003)(6436002)(11346002)(305945005)(486006)(53936002)(6486002)(86362001)(68736007)(2616005)(476003)(6512007)(7736002)(8676002)(2501003)(81166006)(478600001)(106356001)(1076003)(316002)(81156014)(186003)(105586002)(4744005)(52116002)(102836004)(26005)(50226002)(71190400001)(36756003)(76176011)(4326008)(6116002)(6506007)(66066001)(110136005)(54906003)(3846002)(97736004)(25786009)(2906002)(386003)(8936002)(44832011)(99286004)(14454004)(256004)(14444005)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5026;H:AM0PR04MB5089.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k9JP/7vid3qDSE9+Nc+dCupivY1xVzZLsDc/4tdx9jPO3m78tyQRDYX6LXG/OfOMLxz0NDQGz2Pg6HvIWepw/xjnkJL1sGeHc10yCvZTErl7/EXyp9AcipvUemDdBDQ4Vr5xffy2tFSnczx2LLfZtKrCtaH8G4s86xaNEecu8BqCVbZ/tz+uko1Uv0si9cDpUtnCvyPJx0C3FSxdOIIgzU9gB4zJiTIGFaum1WTr7TM6n67El/cRLnrmgay+ZKbw3owWi97yMD6JcBbGHZq8yN8ovoz+Q8wObPsm6+01G+DAfS/ygFXyz+FD1jq8HPLRYoptMuDQhPdRkEWxqE/5KAFIHS4rnOAP8Pjrc3wCYtp0j9WAAi+8ec8v2w9k0e0henCx1XbH3BM43dC07Wo+0sp9/kHt7bNpIGwwOTFWipA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5824a5de-9f8c-481a-0869-08d68815718c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2019 07:18:18.4325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5026
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

when the source sg contains more than 1 fragment and
destination sg contains 1 fragment, the caam driver
mishandle the buffers to be sent to caam.

Fixes: f2147b88b2b1 ("crypto: caam - Convert GCM to new AEAD interface")
Cc: <stable@vger.kernel.org> # 4.2+
Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Signed-off-by: Arun Pathak <arun.pathak@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2ec6e8cbf026..49f436230fb8 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1056,6 +1056,7 @@ static void init_aead_job(struct aead_request *req,
 	if (unlikely(req->src !=3D req->dst)) {
 		if (edesc->dst_nents =3D=3D 1) {
 			dst_dma =3D sg_dma_address(req->dst);
+			out_options =3D 0;
 		} else {
 			dst_dma =3D edesc->sec4_sg_dma +
 				  sec4_sg_index *
--=20
2.17.1

