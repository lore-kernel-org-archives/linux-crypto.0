Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F632C5ACC6
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE0F2086E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="sbL09WAh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FE0F2086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbeJPXtO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:49:14 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:19693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbeJPXtO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJt5Y4AeDAC6j7VOrqQxrsJCbLBmDFSkz85V2uN4JJ0=;
 b=sbL09WAh3e/3hvC1O1G3+iN/O/Ku9/XX/GgdruzNksAF81ssKqqikCSahpvnyNSm2uliAHx5muuTEZgPZa2QhlG08zIfXyvle6iW0gdNpgrg1uWXNqDmlTpx8GIMSygU/t7TLidhB5g8mo+UQIIg6KeH4N53kcGfTeBhgQhMDJc=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4019.eurprd04.prod.outlook.com (52.134.90.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.23; Tue, 16 Oct 2018 15:57:44 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 15:57:44 +0000
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
Subject: [PATCH v3 3/4] ARM: dts: imx6ull: Add dcp node
Thread-Topic: [PATCH v3 3/4] ARM: dts: imx6ull: Add dcp node
Thread-Index: AQHUZWj5FXT1wH237k+tdVpC0fBbAQ==
Date:   Tue, 16 Oct 2018 15:57:44 +0000
Message-ID:
 <ef03e230d0bb76d830c123bc47e6bd6e7bf17826.1539705286.git.leonard.crestez@nxp.com>
References: <cover.1539705285.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1539705285.git.leonard.crestez@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.76.156.53]
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM6P193CA0008.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:3e::21) To AM0PR04MB4290.eurprd04.prod.outlook.com
 (2603:10a6:208:67::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4019;6:ZL0eVCNj6fN6eya4IkU+JCFKSzSlOqMh98G1R6cqOuCvYiYNSmaJbEE/FjTHTwtRKTFY8HZN4OpMu8kWwl+SrdDMLU8rqtbkl2smZVvR1gv3OrtJQbAs8v5b37tu5YfT+xnaMz+2U9kZ6iV3rB2smM6si3+q/0fxMOiVcyNHS4zMYKdFAcLurx6mRhFCL1UHC46Or1uVqkCnZz6lfi1jZ4WuDdc2Sbkpks48UVx/pz/6Q1sLEmjFjbORnT/e6ZkYpJVQSccHoiSkgS2u17155XrfwtWXq7BJqv1sBCg3/bblBeEo77+TFlUNdCmPIwUnBNyuGUK3gdS/rFU0O7Nd3d2e1q2ak0fhIk8WuCLSTIXJ6T3CLfvYF4IyXgoyQ6vVUSFpcFGDhym3MOFoS3gPB1DR8RTf/7/Q/HJGAA60Df0isljlcYpWOyzXKQjv6uJRqkCjRJRtXHwkP+NazINbrg==;5:StEhfgaMEQO1KbxzWqA0SB3ywbd+xSR7oegMlFgEKDL3CsryqmpCiqpqKWM/glDMIMhHRzyw9FLvyOe5XMZqS8EkHO5AwHEdNawbr6TBtBPdHD3h4/eH2vI/GvpWXmHyXXb3aJB8GE7ny6+GO3siQQKsY20lAp2VrlXNumEB0bc=;7:eXu/+cI69aZuoTRDj9PfN5uViNjrjcFFXrspNkUKqF1eNaS7kfBsEWHSmeXK/S1QxDhZC82BJ5A5TpOwN4KfjozKqceBxGnpg6IgtxptelTZfdAue+touspaCFQ4s/1Dt2Hm+O/5aHn1QqycEityKZuCm9eZwW4SVQCC7kRDkWRtU0N7UqrmOIAeEAMLWe7qKftNT/9fXAQYeWE8JV0KaI7PIpixlgaj1ttymBVT7F90EpJkgMDnABiv116p0mA7
x-ms-office365-filtering-correlation-id: 9a250cdd-bb98-46e9-dddb-08d633801c13
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4019;
x-ms-traffictypediagnostic: AM0PR04MB4019:
x-microsoft-antispam-prvs: <AM0PR04MB4019D7652DF079C899FD1003EEFE0@AM0PR04MB4019.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991067);SRVR:AM0PR04MB4019;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4019;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(366004)(396003)(199004)(189003)(2616005)(14454004)(118296001)(68736007)(39060400002)(110136005)(54906003)(316002)(52116002)(81166006)(81156014)(71190400001)(71200400001)(99286004)(6636002)(2906002)(36756003)(2900100001)(7736002)(5250100002)(5660300001)(7416002)(186003)(97736004)(256004)(26005)(305945005)(106356001)(105586002)(6486002)(386003)(76176011)(6506007)(25786009)(486006)(50226002)(44832011)(478600001)(66066001)(86362001)(8936002)(6116002)(6436002)(446003)(3846002)(102836004)(8676002)(476003)(53936002)(11346002)(6512007)(4326008)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4019;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: pLKpMtxCA9L2TY8j0/IXdG/RDb4JTuKzTbgKJGW46CBOmC8vNxa5P20gGi1dYeBPf4azr3qbqTnRl33I2DjVbja35pQmd1zjzpUKYmstudxYWpmmu69hjJh3TgTA5/bRHxZaQAjScFYDZ8FlzXIap9w4uR7avbKLGJGddItgqfihEdUT9mXnqgaL8EbLLJ28t8JGECOkszRv6IAgCRhKvsrQBxNE+7X+QQqfpmmRM8tUnb+WH/bB1ZYqcHjMwB11JfpOBUjfIrpe9Ckg7/2ZEiANcKPYyTI+tARY3q02Q7gv5gCDE6vURCNFf5pQGzx1XJkbf1ns/Ne28baB7Eqj8aubPBOgUMOP5EVKkd9+omU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a250cdd-bb98-46e9-dddb-08d633801c13
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 15:57:44.2380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4019
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016155744.AXfWGwp9yE9Y8-EWn4d2K7D3yxgebTeVdU-Zx9EHqFg@z>

The DCP block on 6ull has no major differences other than requiring
explicit clock enabling.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
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

