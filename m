Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7762ECDE30
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DC72150D
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Vo7O9Fxq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66DC72150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbeJQUd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:33:29 -0400
Received: from mail-ve1eur01on0040.outbound.protection.outlook.com ([104.47.1.40]:42912
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727040AbeJQUd2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAAYPuXDPOSu3aPz78kn0hA1A94Sb4d91a3aZRQvqjg=;
 b=Vo7O9FxqyHFmX70Wj4vAgH07Y/u+rblU5merD0qOa6UaJU7k/QQlB1gtWDJ6pz2DKIUeOBv/eHEPC4NaPYpWq9469O3p0h5HWaWP0mtk+lwp5kpZN7QK79GcNFtrqbR8l1XZ2o89WYYliVx9hcJ429yg7e0X0IEdU6J2CKdHe60=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4754.eurprd04.prod.outlook.com (20.176.215.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Wed, 17 Oct 2018 12:37:54 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.032; Wed, 17 Oct 2018
 12:37:54 +0000
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
Subject: [PATCH v4 3/4] ARM: dts: imx6ull: Add dcp node
Thread-Topic: [PATCH v4 3/4] ARM: dts: imx6ull: Add dcp node
Thread-Index: AQHUZhY5woJo4/tT9EuGY7z4RiZhHQ==
Date:   Wed, 17 Oct 2018 12:37:54 +0000
Message-ID:
 <f503eea6c702aeff091f4c03d4059b67ec17b2b4.1539779579.git.leonard.crestez@nxp.com>
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
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4754;6:f2PZ855v8Z4F60G2hGVVDMwFZGT7lrLNMpFOaeVfpqqPXWaI/zwC7ITk0srHio2aFSosP+i5QLd9PzvHSTrJNBcqj88uHxJ1mkJzp/g+TLyRc0Mzd1prOnlZxdDZp4ZV1HoBDfUYqad1Ja2lhGhrEn0EQQ5DrXiguX+IMAlj8wJ5os9hqTQEaUrg+53NgqnPBuvslRkFZlqNh7uOrM7/zH8EVk4TXl0nt5Bk1lCAyJEu87/7E/4HC/Qo40oLXxP7GCihYguoao2pRgdjFOD/ilX8E30dSD7il1n6qK6C5SdC8AiCkB55iBqfSiKs835f/oqu7lqtlju4/24MNpNQ6d0Pa4YzO3DzW1AJ3hubOfwELVqsXNSNSooaWsUtbJUQHcZuHge3ijvWyU1XBZVhzZKa977AGmNK9opC+a3SFyokuFTKQD1U7pje4mxIAVW0x1bipGP3pICVIXLdYDod+Q==;5:0rvhaHgEX63u7Ex1jiSuPNNELP02JQ0Ju5DxniywPwWdH47GJXAgUwNVQ+ARVPs3PYouwYiDvlLEz75XYRJ9ghjSe5TyZOzAX2BBai67soxaHTnNM/6Ic0UKVlvMX5zSBjducc5MNmJhfAxc9aaKTg508y9bdY7WBNphn3EatmI=;7:jN/M1dAu1wIas1IVR45wRGGIdSJXjNCYA0qftLar63TB1eqmjgRajrL9znRzmF7vk5MKB03JEEqt5cM+m3y5BZHWjVj4E4DXCGUAa5JX7oT15klhv6AqmneWIezP8t5kfmSQ7aEEWP/RU/oWkvmMn5YqvFmy6Lxh+5hHGD3SOY30/LSgH9Ag4lBpb0RaCXYWtXF1fCxejL0G6rMpjSYoUxkFxVJQ8I9C9kjNNCuObuCRch0eOG7Fs8FTdl91KFL8
x-ms-office365-filtering-correlation-id: fc8c0c5c-78a0-4068-8994-08d6342d5be0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4754;
x-ms-traffictypediagnostic: AM0PR04MB4754:
x-microsoft-antispam-prvs: <AM0PR04MB47543C235018F57522DA6690EEFF0@AM0PR04MB4754.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197)(85827821059158);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4754;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4754;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(2900100001)(6486002)(71200400001)(66066001)(8936002)(5250100002)(36756003)(53936002)(118296001)(68736007)(8676002)(305945005)(97736004)(81156014)(86362001)(81166006)(7736002)(39060400002)(7416002)(71190400001)(25786009)(4326008)(316002)(14454004)(2616005)(6116002)(76176011)(256004)(6636002)(3846002)(2906002)(478600001)(6436002)(5660300001)(44832011)(54906003)(446003)(106356001)(50226002)(26005)(6512007)(52116002)(105586002)(11346002)(110136005)(476003)(99286004)(102836004)(6506007)(486006)(186003)(386003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4754;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: CKnqrJWI2YPVbGaoSBtkDoyXEFHKHjN4wLnP3jN82+anoDimwaOPaP9x6DCQpOd820piyMoxjcUqfaTKU7JbdY4wg4oPVLdXEfN7joDjjpgq5bqOlHwkGivO2B4Teo3KzxDe5wBIHu67gskBxcFlmLbiBQ4FicDN5lTJLJr8HUEzf0jyxgakaGKiSJ2/OyDmp/X1qTtiBHrO2n5kcaiMxff+7wLhCJwxof6aMLmwziWLvEZ+ITvao05aueqhFCc8Iytm3Vytu2SAJsD26Mn8YjFB2brkYtZE/Cs9fGJmVqNfCvn606GzfjwkVT6I3Ss53W7KwiG6rQEn1STP4MHpbW9mMuXYJobWStl8gBPtU2A=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8c0c5c-78a0-4068-8994-08d6342d5be0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:37:54.1960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4754
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017123754.Crfxoec0OdSKBnSq13jLuMBh7ZjmMUUNMWs131rXsC8@z>

The DCP block on 6ull has no major differences other than requiring
explicit clock enabling.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/boot/dts/imx6ull.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dts=
i
index 796ed35d4ac9..f3668fe69eac 100644
--- a/arch/arm/boot/dts/imx6ull.dtsi
+++ b/arch/arm/boot/dts/imx6ull.dtsi
@@ -37,10 +37,20 @@
 			#address-cells =3D <1>;
 			#size-cells =3D <1>;
 			reg =3D <0x02200000 0x100000>;
 			ranges;
=20
+			dcp: crypto@2280000 {
+				compatible =3D "fsl,imx6ull-dcp", "fsl,imx28-dcp";
+				reg =3D <0x02280000 0x4000>;
+				interrupts =3D <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+				clocks =3D <&clks IMX6ULL_CLK_DCP_CLK>;
+				clock-names =3D "dcp";
+			};
+
 			iomuxc_snvs: iomuxc-snvs@2290000 {
 				compatible =3D "fsl,imx6ull-iomuxc-snvs";
 				reg =3D <0x02290000 0x4000>;
 			};
=20
--=20
2.17.1

