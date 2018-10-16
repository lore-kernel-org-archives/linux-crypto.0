Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243D1C5ACC6
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBCEB2086E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="XPN+ovdy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBCEB2086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbeJPXsy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:48:54 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:19693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726978AbeJPXsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cayjqDHYjc4k4b1bUW02qkPIPba81ZN7Mt60orDg984=;
 b=XPN+ovdyQ/v2YrChlJwFvP5ChllkXITvX8wrqQv1qhXAFy045QZG84bWAopYPQDe/05rJvHS42j/KGgIbq13oJYOSgx1OJJcIdtUFvqmmvt9T+AVZAnwvTe8CgbkWSt8AnoAn/9LyVot/B6Hhz3kiyO6S/A6Nb+zgPv1kaZufxw=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4019.eurprd04.prod.outlook.com (52.134.90.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.23; Tue, 16 Oct 2018 15:57:42 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 15:57:42 +0000
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
Subject: [PATCH v3 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Thread-Topic: [PATCH v3 1/4] dt-bindings: crypto: Mention clocks for mxs-dcp
Thread-Index: AQHUZWj4s/V2RkIUakasV64CzI8Mzg==
Date:   Tue, 16 Oct 2018 15:57:42 +0000
Message-ID:
 <1861b16b6e760000ef42b0642c946a14f1fba95f.1539705285.git.leonard.crestez@nxp.com>
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
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4019;6:Vb9/OA4gTvqqIa+p+EroSuHR0Oi0kpjZ9/IVLHjAMQ9Aj6EO6ITGXZLIffiKRH+A2EppKR9DkJaRhzvoDpaEQSCLDpgaUIRJlTE4mLnygKnHxinCrLFB4F/G9fTJarU61SM9dH8VOrIsU9dWMxi1rkWEkbyqVY+kgCxCjhGiqQC6X/INeAqaLnjQ/3F5sJ66Zdq97MlaLbAs+MAd6zSMP4fvyOVInG/quaaA8Tw538y+oJsoG1lnX1QkOq5ZoW193H8WqaAUzBL4StYWkj77EUoVE0Nr2bzwq6nmoDRIbj+D1sj3sub/JlKOe03ogoQlFqQishtvMnXc37c5dLJhwAQgVFnMrjOOs+tC1/RFka/CyJb7uoehADHb6dEIxTvCwhdqgOjw3FqifU7AmPgAPo5cBtGiFU1Vt0/afFW+NMjmEFoaVWPnfYJJnxKqvTB2EpbkfDDZScn+dHe3puOq0g==;5:CzOmj3zutwu2O3WmqFNHvvanRARfLoFVYjU3PjqQG/1T933WlQDxxDe6ENFs/scjWxpa59O/4PFYp8zfDrFeFqQnzHm8/R3lQxLA+v9jcLKOTxfs9X3tkTtMcfbf8mleSVJU6y+VcpKRMPYzH+AeBHNuBn+gw/TizYEeAHWiNY8=;7:EXBs7MiXbnMvvfiCsIafEksJO/22yil5wxju6uUZ1qVVztQqufxgI8zx9w8ijYh6shfISDXMihzFuDq139uYa9FA0yrs70k2u9fJF6dER03QcUYXHmTMO5ouCRChgq8Y2/e/kysFm4jUtzhKY8UoelW6oNutfMm5Sy0N5tzliFxepascTJ0e9dD8LIPinpSpGlVMq+zJ3riA+dzKVj/NpNnm2zGw7oZO+fYMUyCsK8o/h17qaUNtBbOvP9htTSYk
x-ms-office365-filtering-correlation-id: 74ec893f-684b-4863-325f-08d633801aca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4019;
x-ms-traffictypediagnostic: AM0PR04MB4019:
x-microsoft-antispam-prvs: <AM0PR04MB4019858E67F9E618F455B007EEFE0@AM0PR04MB4019.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197)(85827821059158);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991067);SRVR:AM0PR04MB4019;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4019;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(366004)(396003)(199004)(189003)(2616005)(14454004)(118296001)(575784001)(68736007)(39060400002)(110136005)(54906003)(316002)(52116002)(81166006)(81156014)(71190400001)(71200400001)(99286004)(6636002)(2906002)(36756003)(2900100001)(7736002)(5250100002)(5660300001)(7416002)(186003)(97736004)(256004)(26005)(305945005)(106356001)(105586002)(6486002)(386003)(76176011)(6506007)(25786009)(486006)(50226002)(44832011)(478600001)(66066001)(86362001)(8936002)(6116002)(6436002)(446003)(3846002)(102836004)(8676002)(476003)(53936002)(11346002)(6512007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4019;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: JelYyWhKoQya65Y8FzBSt5Bv4RKySRK+oVhJ0FhL9pYruHQRecZQsuBeUkWRdG8Ym/8UppbF6Ea267zkkrH1AfySEyVNETyH3YSOohL+k0USGkH/7BBFL8yPw5EgnD3QtyLueR/FLyq6+cP732AfEkODVRie4q8CfEEMDLcPpRU8wCuMYYTQmt5ZLj7AjmgwzZWuCqIYEmQeGqQlG0MA20t0lVN5D9yeNHmRYRRUKHXgSzg0lf+n2qDLm7UlJFq36nfKAXL/1L5DnUr4zFLNPZ9sjwSsYwTdoy04vH8/t8ud6xuUi7ZlRd8cE1Vg6EYjxJuyzq6dMqEI9LaoiZMItH7v8mEqKd4gHVGOga1tmlI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ec893f-684b-4863-325f-08d633801aca
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 15:57:42.0284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4019
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016155742.SwEgsTl8Owk3zSVBD732RwjBpsqht56HgoxSA3t1g6M@z>

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

