Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B299C4151A
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F19A218A6
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:08:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ngyiYwQB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfBAFIj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:08:39 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:14318
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725681AbfBAFIj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 00:08:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2QKC9Ckkun/z7cXzXvMRadCEOyFE2uRpo6d8YRfvT4=;
 b=ngyiYwQB/FgX6j8BEetPyc5t1Z1GVmmDE1Y7QdqMDAVMnPriKR5eXjMd17LKL3zuMYMYZWpwHercrQdvSdFcQxhxrXoE1ds4WnTiHe5KsAa6brC/pTB7ki/nJX45Qod+PrBAxekTjOswtfEwMRyIwfV7oOkBzilySKicFkS6/HE=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (20.177.40.158) by
 AM0PR04MB6163.eurprd04.prod.outlook.com (20.179.34.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.17; Fri, 1 Feb 2019 05:08:36 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9%5]) with mapi id 15.20.1558.025; Fri, 1 Feb 2019
 05:08:36 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Arun Pathak <arun.pathak@nxp.com>
Subject: [PATCH] crypto: caam - fixed handling of sg list
Thread-Topic: [PATCH] crypto: caam - fixed handling of sg list
Thread-Index: AQHUuewvbqaSldjtUEekronYfU7I+g==
Date:   Fri, 1 Feb 2019 05:08:35 +0000
Message-ID: <20190201045643.69692-1-pankaj.gupta@nxp.com>
References: <36680>
In-Reply-To: <36680>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [92.120.1.69]
x-clientproxiedby: PN1PR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:d::28) To AM0PR04MB5089.eurprd04.prod.outlook.com
 (2603:10a6:208:c9::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.gupta@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB6163;6:s4oiVWby487ILVdfN7ddwQ8TJA18HqBJqhH1/JVdGKiHBT8K2N4PlaQvOoVeKvgIHpSb2QAcKWJSHHLPSrUS8PfbYrAtJ9vCBV2Zjy893MHVxzcRJttPbqk2uMemDHbfI7VYH3nLKugFKdsVqWqnuwipX6F7QeAvKy4UrPkpfTCD0/AGCXM/VARMQIUZUFWROBvpnXGCkDuXXXEpVdjFreqWNPFKCPYecBVnjzJWOkUEGwGng0QCl72jJcDCZw3oA6A1vX8Ie9ddS1sRjQBRsA1SvFnh243m9ykDqT/A9YbTnFskmc8v5+9tBFh6uf80KpnQpsIgbcJR8wEfOUhIN33xHIRgZuPMpySgN6Qdao3UPbDV7jn3v/4/K+emnsFnGyvWxyt72xnYZ7PYBmCzBNlj1JNIKkYAUsFMvNYMHUTHmDvsQKx7ha1fQMM3aUWwg+/LXO8TqXbIbRHgwa+OMA==;5:tasj6PplzoDMCo9gqqR5oN22hIwJ6fAQiL56CoWLoYOn6ENepKP1fSIed+8+w6n7o9JC19hLattOlrakhDUkikFKczzDw2P/0Qtlmmhjs/A7IfsrCyTjM+0E9NVeSL+1B3u06GDM5SPp0KwPJ8OUyR6RF155go94Y+tPfH5zDHR8h61ijdfpNwuMt6VvFNGIZLltMMSNZcII8hxwrecYVw==;7:L/YlvQQybwVMfYhyTGVOFIbvmuCLwO+4FfNYVvBZXLNX8hES1A5WlOO0MAOqi22y9cleg9MteLV1PwBbbmVi1yQvnbf/WLW+N1KO8fbGtAJN/qPTut4VWxtHW80pZxDTRjuwdo0T5U/wkrgjPcv/hw==
x-ms-office365-filtering-correlation-id: d1ea3eec-eb5d-4717-3f44-08d68803519a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB6163;
x-ms-traffictypediagnostic: AM0PR04MB6163:
x-microsoft-antispam-prvs: <AM0PR04MB6163F69CDA1EE21ED10751D495920@AM0PR04MB6163.eurprd04.prod.outlook.com>
x-forefront-prvs: 09352FD734
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(39860400002)(376002)(366004)(199004)(189003)(4326008)(386003)(476003)(53936002)(2616005)(316002)(102836004)(50226002)(7736002)(2501003)(5790100002)(110136005)(6506007)(305945005)(446003)(2201001)(26005)(11346002)(25786009)(8676002)(97736004)(54906003)(86362001)(186003)(4744005)(44832011)(11926002)(8936002)(486006)(81156014)(81166006)(6116002)(3846002)(106356001)(6436002)(36756003)(6486002)(52116002)(478600001)(68736007)(71190400001)(71200400001)(2906002)(66066001)(14444005)(6512007)(256004)(76176011)(1076003)(105586002)(14454004)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6163;H:AM0PR04MB5089.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: woCZDG7nF6/0TeGEhyHxku2V4mVZbmCSpiLuJ88Na3EsP4pkConChAzho8oSjfi7WU1diiuxKWc+JnvL+XeIPcNGP3nyaKCDvaWN+CSpLqDZJPsiRiUSE9Ma4uOmrBy6BvuVFPCpSnNVXpiTc6UP5CNNEIdoyYH1T24B4HOQzM7dIZFUmao5YzqoFZSFrIxHTyMNuZjnj7HASSpvWTjKE1p5t/8u45lFX8QIGtUH3SR7Dmp428TQfwWAypGrsHMO+jfl5mbCWr+L3IyAPc50cIsOE8dkkJyhHHmCnn0bj2HUZHMd1ukE8liBZ9Jrs71MUBdOc+UpapPI9seo7BNBkQ5l7xJhX+f/wfy7OPGz40aiDWXo2uuoLCYb5q4F4SyEVR+pcu/KWKOp7Gy/8d39dpLfKfIPi78YZqnXfi/W+vQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ea3eec-eb5d-4717-3f44-08d68803519a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2019 05:08:33.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6163
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

when the source sg contains more than 1 fragment and
destination sg contains 1 fragment, the caam driver
mishandle the buffers to be sent to caam.

Fixes: f2147b88b2b1 ("crypto: caam - Convert GCM to new AEAD interface")
Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Signed-off-by: Arun Pathak <arun.pathak@nxp.com>
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

