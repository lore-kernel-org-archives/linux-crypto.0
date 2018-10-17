Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBDDECDE30
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBCD32150D
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZGcHJGw5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBCD32150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbeJQUd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:33:29 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:8163
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727292AbeJQUd2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cayjqDHYjc4k4b1bUW02qkPIPba81ZN7Mt60orDg984=;
 b=ZGcHJGw5/sL3FvZxalcNGQgjWNk+g0gN0Fo4oAy8LhywTuZcO2MqhJ+6AEnw57366Ry9/tUJJl4CUjY+JDj5sGPc6qAalth8WHyjyb3IFRl088Nw7OxKdPPOKou4UjgkpguxhRAPUJWJYNulp3zvfxT4+VSMsqNU2FTHGWqslKk=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4212.eurprd04.prod.outlook.com (52.134.126.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Wed, 17 Oct 2018 12:37:52 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.032; Wed, 17 Oct 2018
 12:37:52 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Thread-Topic: [PATCH v4 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Thread-Index: AQHUZhY4IVTqhgCkI0qTk0dC2eDS/Q==
Date:   Wed, 17 Oct 2018 12:37:51 +0000
Message-ID:
 <4536b5b5b101ab6a4197fb4891f775ddeb519847.1539779579.git.leonard.crestez@nxp.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1539779579.git.leonard.crestez@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.76.156.53]
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM6P191CA0098.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::39) To AM0PR04MB4290.eurprd04.prod.outlook.com
 (2603:10a6:208:67::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4212;6:pptVK0R7Foh92pURpOZYTcFrIwePjpk/peg0+vpY8OxWeHW3Q+MhkJ8ArKYRiA6U1vMQfNos4vJwARlp2GnVRwt1WZoOogkvLvaupYdQXuEepbT4T/gFrJ54erNxenqZNIzk10n7qruiluddcBQv1FiHQEsURo4kYpbkHghcZu696UMSAllSQW2zdW1AcvIZK1EQd8Cp4mRF3gZfImFTJaPQ666R8D//Bp6WHUEBLWsBFyZ/B67McAW0/7CdNzT7hj754D9gukRHuiqEOJt0himy8mn8h8mSrLKQTAygulrkYAQ3xvbkSG2nOUNcP67lojlJf0/LxGvtDKuBsJihwjDvjylX1JquWEDYMq3yhGvEpfUFqqvStuZ5Y8FOWJZkeF2VGx/R4g1r2FoAKtF31WfIr0Rj6TE1y0vHrsCa5U+sZ1g3w3RC95qYr2kqsfpEPVf6kJRIKa0MZD+Mn86ubA==;5:CFStuKHGOlcCJfLbEFEvRjNOHawly7LWPArAR2tN6wqKtgh4goAhkcs30Z8jCdP25fZnQy/fl4oBk68gQ/WGKyEZx2Oi5nY+/aJ936Feq4KqW/i8j1m+MrprmulGhWcxdYihpPmEhbsd6p8D2novjviNR2NHFVFObmvOvCYDwGs=;7:nVSvmvlRFHycPLcJUUuOuusfEH4YaQ75wAvuID/0PLCTt2sPspdcaFM36d0f+E5b6/UpymnIoweTiGPdkrvlnT8WOJXZZffu05cfGE+jr5DDJN4iKqaTMG++LkPnx5spL9kvbCWvz9BERHoTzZGBt2i/7pz8M6tbspY3y12jmV11K1Qez18+VyYbTl6M6IOmhrHMaCY0GeVZezUDwV/Td35Fn5ChxEJdlIXQD7qLUIyikyUtgq3d4nA+2KbAzdm+
x-ms-office365-filtering-correlation-id: f196bc2c-08a0-44f6-2553-08d6342d5a7c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4212;
x-ms-traffictypediagnostic: AM0PR04MB4212:
x-microsoft-antispam-prvs: <AM0PR04MB4212C6357A098695237B08E9EEFF0@AM0PR04MB4212.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197)(85827821059158);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4212;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4212;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(346002)(39860400002)(376002)(189003)(199004)(71200400001)(71190400001)(6636002)(446003)(118296001)(11346002)(54906003)(110136005)(52116002)(476003)(2616005)(81166006)(6486002)(81156014)(7736002)(8676002)(50226002)(316002)(256004)(5660300001)(86362001)(575784001)(305945005)(66066001)(68736007)(53936002)(4326008)(486006)(25786009)(478600001)(44832011)(39060400002)(14454004)(6436002)(6512007)(8936002)(386003)(26005)(76176011)(6346003)(36756003)(97736004)(3846002)(6506007)(6116002)(102836004)(2900100001)(7416002)(2906002)(99286004)(186003)(105586002)(106356001)(5250100002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4212;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-microsoft-antispam-message-info: LZYTPZRsNcLVQyDVjUy1Hed7aAGRTWymXJLfjen069MJtbNhN0HoVVl6f7n6tny0XGhPxzHZQFyOxPv+MW4Ab+dhfqydxC7MneFQFxVENDIgxl7TC6k7qDTQRc87/XI6L8vLOOOWCOnFFmM1/gx99RgapLNVKtIQrp3Y96NVqUBYSfI86UTKXMpkFHNpMDB8/PPan/SiPtsm4aj5R13PetwSCTeRwj4TYB0VTh0xYXk0l5ZUIzjUZ5zWSyJeHl/9WoOy4qCHDvxf+0r1sUNo2gPngMZJWeRyWvBbZUTG2aM4F6x2vkeUxSnvEHJR3JxmVmaUUiowKxsGMsZN9Wzirq0NidNeUoThtk7DW8qa2OQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f196bc2c-08a0-44f6-2553-08d6342d5a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:37:51.8984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4212
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017123751.VIMgur7QgTrIOpoU1OtUZh3msv_XKeYWuGXheP_y8Fg@z>

Explicit clock enabling is required on 6sll and 6ull so mention that
standard clock bindings are used.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
 Documentation/devicetree/bindings/crypto/fsl-dcp.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt b/Documen=
tation/devicetree/bindings/crypto/fsl-dcp.txt
index 76a0b4e80e83..4e4d387e38a5 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
@@ -4,10 +4,12 @@ Required properties:
 - compatible : Should be "fsl,<soc>-dcp"
 - reg : Should contain MXS DCP registers location and length
 - interrupts : Should contain MXS DCP interrupt numbers, VMI IRQ and DCP I=
RQ
                must be supplied, optionally Secure IRQ can be present, but
 	       is currently not implemented and not used.
+- clocks : Clock reference (only required on some SOCs: 6ull and 6sll).
+- clock-names : Must be "dcp".
=20
 Example:
=20
 dcp@80028000 {
 	compatible =3D "fsl,imx28-dcp", "fsl,imx23-dcp";
--=20
2.17.1

