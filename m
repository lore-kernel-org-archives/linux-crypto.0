Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B30C04EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4079F2086E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="T585hy/D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4079F2086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbeJPXsu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:48:50 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:19693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbeJPXsu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/p+17s6uCA+1kOCaRh3ajqmwBgCKEoQ406oC6TZKJw=;
 b=T585hy/DiO6mpqbXQPwBiWT2pPnCvHWJ5rkSSGuYvScpcQL5/z5XfP7urnecciHoEHHGu/xqx/bKjfdYB5oGXQwBr45Wyy05WQ553Rt2Ec1NAxZtpBDA3f+j9RfQY8bmQ4lGdMEgTi7MQb+E3v7zzkOMiraEXwGvp1enhbtSkbM=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4019.eurprd04.prod.outlook.com (52.134.90.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.23; Tue, 16 Oct 2018 15:57:41 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 15:57:41 +0000
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
Subject: [PATCH v3 0/4] Port mxs-dcp to imx6ull and imx6sll
Thread-Topic: [PATCH v3 0/4] Port mxs-dcp to imx6ull and imx6sll
Thread-Index: AQHUZWj37H5hymh+5UWaTMF7nnI6eQ==
Date:   Tue, 16 Oct 2018 15:57:40 +0000
Message-ID: <cover.1539705285.git.leonard.crestez@nxp.com>
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
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4019;6:uQBfeNYW5AGTtOULFNmxv1AMIK0c2yjv4uk0OL1YWuutq8DU2WgrabXJfm5DtcR2egXpmgtqgePI+yOgSyRbQjZQkiha3ZpX5BMSa8hPFXzNkVb1f67n3/1mH6Y0lWhgRTooFuaawDhT0JjXQZZoiciB7PrQz9KScM/NLm+h9aLU1kq3KqaO2HGwcSxb2TDfw188GWjiDQAhHr5G6q+pDFxqvEGFWQqMjIJFF8CNU4sVj9r9AJrjiSSUIs3FujMXdLrGhYUiDaFZljpXU52oET9Y3k+uEWYcwYU6gtI5KooQnDiCUaMPkYC5mQ7MdhmIF94H5l6OLcXS9rxHlhODHvKIxPN71kPzKIXf3oBhC7F7ICREMezr0/gj8WXUv2JkegiQaUS1Q9+VJnTsoXm905OfHkSpA4h3tW88tFzYaQwTNchT3kFqh+VitqKw8vAeVNE2gSviY3J+1ol1HTukbA==;5:DvFW4EoTKSVdRhFNKXzB712awFSabbE5A30+JFIL8C6XzJNGQL7k2eGrfaC7Cv/IJtH2Hv+AYvg5WZZg2UA0ziznQhd63Q2cQvbYOhN50PPhMAgz7g7N9W1yUagLVW9J1AOTo+syAacuwg8Ck7HVUb6/EXl9ANuhi5m8LMM2pnc=;7:owJ+BCxCJ/eTrKv3NwJT6e7DAP09Q8yCsU0nuk7nCoFtvUutp1F0raAhHn/DfSgJkwRGdFQIjQthOIeL+it/bQQFsgcHgxXx0tLiTZg6NmBpPVskgp4JCjksS+6HmQOQfZFfPLTeCVt+5n19lXs92yAgw+dWvMomF7LVJLLPjtOku2+qfL4lY02FYHVSQaujMfnY5UlTp/FgfmTcHs5qS3AVxzBszIgEi11PiQV9Led+naDDdFvLeZQ8NJs6NDyv
x-ms-office365-filtering-correlation-id: 5427ae1e-46b2-45c1-48dd-08d633801a25
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4019;
x-ms-traffictypediagnostic: AM0PR04MB4019:
x-microsoft-antispam-prvs: <AM0PR04MB401999F3D3452A875FA1BB06EEFE0@AM0PR04MB4019.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991067);SRVR:AM0PR04MB4019;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4019;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(366004)(396003)(199004)(189003)(2616005)(14454004)(68736007)(39060400002)(110136005)(54906003)(316002)(52116002)(81166006)(14444005)(81156014)(71190400001)(71200400001)(99286004)(6636002)(2906002)(36756003)(2900100001)(7736002)(5250100002)(5660300001)(7416002)(186003)(97736004)(256004)(26005)(305945005)(106356001)(105586002)(6486002)(386003)(6506007)(25786009)(486006)(966005)(50226002)(44832011)(478600001)(66066001)(86362001)(8936002)(6116002)(6436002)(3846002)(102836004)(8676002)(476003)(6306002)(53936002)(6512007)(4326008)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4019;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: QUfH83gm6eNMS18dEbRC5geAjZvFaP0FEZLDEwq6oACHjtR9rEWhkqvagLVUTXqdrKUfWcBXrfgJEd6LMIJbnrHjRGrMJJwz9Pad67yv3IpDMD412D942CmD7nh1Snyun4qAMt+QjSq9DQhsvQpSwtng2VBN5J9QNCi1EVBK7Sh4RJs76riII5b7A8PPMfo+VEOxcgABPJe7PVWuNnFEZwEierMSL9XynLjmGLQBmq+dxS3vGGo7L4MZ5zkcwGFBdy51V8daQ4c5HCxjzNwTo4ItpKy6OneitQuBnI1FZC3UuZ0ygqacVJuphct6sFkSi2nhnbdQ2NJeJ359pesIwN592Wq1LO3JcOoT/G+L4v0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5427ae1e-46b2-45c1-48dd-08d633801a25
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 15:57:40.9557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4019
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016155740.X0koki3w6Mz3JA-SvzG4yfUem_GLZZukXGw3scQ2Zl0@z>

The DCP block is present on 6sll and 6ull but not enabled. The hardware is
mostly compatible with 6sl, the only important difference is that explicit
clock enabling is required.

There were several issues with the functionality of this driver (it didn't
even probe properly) but they are fixed in cryptodev/master by this series:
    https://lore.kernel.org/patchwork/cover/994874/

---
Changes since v2:
 * Rename 6ull dcp node to crypto@*
 * Use clk_prepare_enable on probe
 * Fix not unpreparing on remove
 * Realign dcp_clk struct member with rest of attributes (using tabs)
 * Link to v2: https://lore.kernel.org/patchwork/cover/999795/

Changes since v1:
 * Add devicetree maintainers for dt-bindings
 * Add a patch enabling in imx_v6_v7_defconfig. Since tcrypt now passes thi=
s
shouldn't cause any issues
 * Link to v1: https://lore.kernel.org/patchwork/cover/994893/

Leonard Crestez (4):
  dt-bindings: crypto: Mention clocks for mxs-dcp
  crypto: mxs-dcp - Add support for dcp clk
  ARM: dts: imx6ull: Add dcp node
  ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP

 .../devicetree/bindings/crypto/fsl-dcp.txt        |  2 ++
 arch/arm/boot/dts/imx6ull.dtsi                    | 10 ++++++++++
 arch/arm/configs/imx_v6_v7_defconfig              |  1 +
 drivers/crypto/mxs-dcp.c                          | 15 +++++++++++++++
 4 files changed, 28 insertions(+)

--=20
2.17.1

