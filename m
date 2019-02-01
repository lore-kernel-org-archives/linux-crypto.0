Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED56C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC73C20857
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WtaTvdMH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfBAFuM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:50:12 -0500
Received: from mail-eopbgr20088.outbound.protection.outlook.com ([40.107.2.88]:22558
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfBAFuL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 00:50:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hzhot44oRoAEpoXaUORAy77kiO4FD/SZnNMGFO2pGpU=;
 b=WtaTvdMHxgsF3y3l8CyfGcT2vsBqQP5xiBq+bIeLL3WI8H1jMf5Ec586nyL6zVctTRVYUpL2/iWo6Fs2YJmud8ddUpYmyc/KZ58uzL2C5X/kTt0ugQMxVG32Pe4Frm9yEXLLs5Eupsep7otBistxMkcyswJd6AuWKv5s5XTA4lQ=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (20.177.40.158) by
 AM0PR04MB5235.eurprd04.prod.outlook.com (20.177.42.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Fri, 1 Feb 2019 05:50:06 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9%5]) with mapi id 15.20.1558.025; Fri, 1 Feb 2019
 05:50:06 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arun Pathak <arun.pathak@nxp.com>
Subject: [PATCHv2] crypto: caam - fixed handling of sg list
Thread-Topic: [PATCHv2] crypto: caam - fixed handling of sg list
Thread-Index: AQHUufH7IpBU7uXwwU+BEvDMkRqpoA==
Date:   Fri, 1 Feb 2019 05:50:06 +0000
Message-ID: <20190201053812.71275-1-pankaj.gupta@nxp.com>
References: <20190131070556.44832-1-pankaj.gupta@nxp.com>
In-Reply-To: <20190131070556.44832-1-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [92.120.1.69]
x-clientproxiedby: BM1PR0101CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::24) To AM0PR04MB5089.eurprd04.prod.outlook.com
 (2603:10a6:208:c9::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.gupta@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB5235;6:GsQoEJuPmYhARVfpvffT+sBOfeEz1I0jaudQrgsQFolJwvynqPBwdDD1BJh0cN+HudxTyW1A1n+AtXEu7ZAiG5kXODy9nybe7YTu7sCYFlpTKqhHV1qhPpOfDU1fsVWIL7sHjxoqGt6BJ0klF/xZLZTOy2fu7VUQ9wHZ/thEvAfgVXTx43wMY6mT448zolpAnqVHmqyuvOsLsm4bQ7uK7HvRgdaiw5add4wYl4g0lt9cO0MBEJLSQkGx4246bwJaUoikfZFPQsSlZzlSug7q0obQjrg/dB5Y4B7Y7VApFoti2tG2BbXAvDUAjgSjDl85Xbj8h2hY+mGkFPdTYXjclKbZuGSNrrHi2mcTiy16T60ONSxVGkTyWQFcR3dEvMvtOoI7wwchOIvu7Kf6bp/gY3S5hGVNwWmPc2MN+5dMH3MxzViXm3+BAGpCcK1lMoGUICBVlaO4meZueoWiWIdYFQ==;5:zWVMen2GEi2rdoW5BQAVaWiaGJ3/9NpqM/q9K3+8aJikQOVShjv+rQyEwsDoc7jCPnllJa1uwGKS0YxMDC7ud65qEIPa72J5bXOyHwqIv7/jOFoKxb0B68EIrPVYgNWbDBWEcb+9M56kBjKFCFJMuyrzNVEOWd/J9cwH6Ae/s62CN5/xcJgTNZdlUk5KDzyIy2pl9+oTGR6CTUSTqbCQGA==;7:AHPWwAbYrTUNVG532pzaFQqevV1Gwe9sqMyWPAkQ3J7lINT95ulxtXT3ltUo9fHwAUTvNatwfJxyZwDthAWahYMxBxI+aWTv3TauX8yxj2TbwH1z9GXltqCltDGtQYkbaCW0JjLjNgEBydkSIMIOiw==
x-ms-office365-filtering-correlation-id: 1bc9ac0d-ea57-4bc3-b3dc-08d688091deb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB5235;
x-ms-traffictypediagnostic: AM0PR04MB5235:
x-microsoft-antispam-prvs: <AM0PR04MB5235D8CEE75E0BF4881DA44D95920@AM0PR04MB5235.eurprd04.prod.outlook.com>
x-forefront-prvs: 09352FD734
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(199004)(189003)(6512007)(68736007)(6436002)(25786009)(4326008)(8936002)(50226002)(53936002)(81166006)(305945005)(81156014)(8676002)(7736002)(6486002)(66066001)(36756003)(2501003)(14454004)(478600001)(106356001)(105586002)(2906002)(6116002)(3846002)(97736004)(26005)(110136005)(186003)(11346002)(54906003)(2616005)(44832011)(386003)(6506007)(14444005)(102836004)(71200400001)(476003)(71190400001)(256004)(86362001)(52116002)(1076003)(4744005)(486006)(446003)(99286004)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5235;H:AM0PR04MB5089.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P0w29KVkkXdG/7QxhqcVdg7r/iIxPdvHNInHrhJsOGThGxZNKiKVH4hFu3JqPk9QSuJaDiHsqbTXnTB+84uPu32KPg2NqJmROr8bsFUxZkx9je2IwHKM3ibYba6SJgyKkyqx5VFfslfhdtOAOoOFvwlvbqhWAp4U32/nk8/94x6OsiyJ2n+7uNNhOL1u5Rh/CkwKvwDXTr+kUAFjM4aSonaxJ7OzJ8PZEq7xa6NCxU67+3XkcAyS6DpFHFOONDRGIEm5PpUhZCQhmTf/yaNiXDqg3YOBdciUW+TfZtipCxw+0BtgKRdv4zuj9li7/VTvdQNg/qL4KZsZpt4lXvIXUTDsJi8l7rXhH1kalcKAL33kBIio/s8FiKi9tYlDfyvfvzCAAOgYQIoZWV6cdvPdgcfmU0wct+tyPZoQv02WnDw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc9ac0d-ea57-4bc3-b3dc-08d688091deb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2019 05:50:04.2322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5235
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

