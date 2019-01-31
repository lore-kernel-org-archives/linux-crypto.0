Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D23C169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 07:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1473A2087F
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 07:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="niyzPyj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfAaHSH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 02:18:07 -0500
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:46880
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726013AbfAaHSH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 02:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8vPt5y9bpAWabVlEPzpf4JAeZ/WOoIi1Qp69VgGU7M=;
 b=niyzPyj4p+2KBQS6nnY0C0kAf93/Yoj5OnWgwh63jLldys/A9TBKlIlVUZdILztz2lS322WFhFutfwrpebBIx1Db39lUoKiirsFirj8iGmncWir7Hpl3Tl2+4PZY6wdcfOYbk9Aixs/dmUksNDK0kYKFudFlEgQ3/fIuK7n9oaE=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (20.177.40.158) by
 AM0PR04MB4242.eurprd04.prod.outlook.com (52.134.126.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Thu, 31 Jan 2019 07:18:04 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::2412:2afc:ffcb:85d9%5]) with mapi id 15.20.1558.025; Thu, 31 Jan 2019
 07:18:04 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Arun Pathak <arun.pathak@nxp.com>
Subject: [PATCH] fixed caam driver handling of sg list.
Thread-Topic: [PATCH] fixed caam driver handling of sg list.
Thread-Index: AQHUuTUbLrzB8lCy0EaMPxLEvzKAKQ==
Date:   Thu, 31 Jan 2019 07:18:04 +0000
Message-ID: <20190131070556.44832-1-pankaj.gupta@nxp.com>
References: <Pankaj Gupta <pankaj.gupta@nxp.com>
In-Reply-To: <Pankaj Gupta <pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [92.120.1.69]
x-clientproxiedby: TYAPR01CA0102.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::18) To AM0PR04MB5089.eurprd04.prod.outlook.com
 (2603:10a6:208:c9::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.gupta@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4242;6:oV6gX3y3l2DXzgFzAM46/xugbK86Hg0uJiDyd9uQPLuh8/xUinnjXWKpCeigiIFAvpETY+kSputN3OnbrNwMgZdhPLXrKOoUKyIytZwzRDoF7oafcoNxoopBuUM3K9WqnXN2odgKi31Ntru0jLgYlVFpsXtw2erINLQ1a5qBhoD28FTYrX85XuzugJBE97COu4f4cakcL8lrAG8p04oRXK4mCdeSxfWdyNeW6s4UJa27CI+sCdKGVo9xrLF0Tmg7d+Gs8vd8nWhqSvxyyfJX/YKQKXuXZrwz6r5hVn/1CdQhxCJX6bqlPtdfJFXA4lNpeJS3VwHAdiSwj03sMM0QJhg0Oy8bKi+B3gred2dc46SXIoq2ZwoDZpJGqsdYUSNcYbvJAL7vO+vqog47Om7XIW1hf6kXLhCOQ+Exvl1277hIE6B/AHCfud2BH8WNJ6G8cZIWXOVC2damtrcz5qFzDg==;5:t+LWJGZwgElG70/8dfPPSlX4hsMoDu5j/JDRllSX+I6RckdiIraVO8+W5rwXv+9aD6/X2tx+HfcD5a9PKQQ1yg7FrbwPgAir/zq6dGZNXZcZ+RE7rifUBFuesUnll0Fyq9wfhuY53IqR3ddwf8YRYsDkurSxPc/rzE/8SGgvW/8Zh2kWCYX5RJAI9Nt6Vc92LpnTfKjSmhREKsFUMqzQvQ==;7:S4oiZegJnpmoWshtj2o29WUUxZClILUSJ5S+m4gDWYQX+7jzPSzSiHgWPnoZPDvyDEvUKLvZU2nsGdptRjGnv0hKcMUiAsGDM0uiQWn5osGMZBq7WrG0NB9Eifz4P3yTW5v2vFPvDquFMuaew5u7vA==
x-ms-office365-filtering-correlation-id: 407718cc-7350-4b71-ddb2-08d6874c3dad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4242;
x-ms-traffictypediagnostic: AM0PR04MB4242:
x-microsoft-antispam-prvs: <AM0PR04MB42421E08D62CACF5B6E3C12B95910@AM0PR04MB4242.eurprd04.prod.outlook.com>
x-forefront-prvs: 09347618C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(346002)(376002)(199004)(189003)(26005)(186003)(105586002)(4744005)(106356001)(2906002)(68736007)(6512007)(6436002)(478600001)(6506007)(3846002)(86362001)(53936002)(50226002)(8936002)(386003)(6116002)(102836004)(4326008)(2501003)(25786009)(97736004)(1076003)(7736002)(76176011)(36756003)(71200400001)(71190400001)(11346002)(2616005)(446003)(486006)(305945005)(476003)(44832011)(66066001)(8676002)(14444005)(256004)(14454004)(81166006)(81156014)(6486002)(110136005)(54906003)(52116002)(316002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4242;H:AM0PR04MB5089.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y5D2QRNZcS7AOylBmueanrrbud5MMXn1FLdxV+2TQISRxnKcv12+WIbAA/lwq9RC5OjA0gWKXoBA8l2K4fTrU97e6GKx7R6b7zSFydGiGZLbFqtQXRa+1pUh8nZt2AwZAYU2IQHtOJFsNacD8eFlygHS+yQG8z8gG9IjozrRWVlS9QNv0eZGdcI0mfZi4Cvp+GRJVmxTOcuGs/pLxF1JEHllJHP8mBqOMISMZ6IKngNvbIOft29h5Qd84csi5xKGJTVLioFb3oFbuzzByE2wGRMcDVy6Kpyhd377QpHkwEfeXWG1tiPhsqNdx3e0fAt0xBrFbsaMkMghGBWlUhhTgNMzLLODwjILMZ0483DlMJ3CHRT2cjHMuJU8LsZBtKxLstU+3OxuHlPppWIpIB3TsevTRkRmFLd8je9aNSIprkM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407718cc-7350-4b71-ddb2-08d6874c3dad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2019 07:18:01.4343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4242
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

when the source sg contains more than 1 fragment and
destination sg contains 1 fragment, the caam driver
mishandle the buffers to be sent to caam.

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

