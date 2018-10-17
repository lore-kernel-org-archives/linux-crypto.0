Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035F2ECDE32
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E502150D
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="RkvUlf0H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98E502150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbeJQUd0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:33:26 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:8163
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727040AbeJQUd0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOtXumwyVhaKcuTBfptpUjcNMx1eAnUZx6WucdreMEg=;
 b=RkvUlf0HAszck5ovTltOzpBXcb41QLUDQFbGbhIksOG2PuDhaSHH3yBDyX23Z0ZpoGFTfavB1dPxsn9dHCa3CdJ8epRgdKgMucSKodiN7aHdzXQJ6h+1E2wRMglCOGjVQ6tSkuHaqzgLzqUTaG09lbWv7aHJAWxuUMAdT4hhX24=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4212.eurprd04.prod.outlook.com (52.134.126.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Wed, 17 Oct 2018 12:37:50 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.032; Wed, 17 Oct 2018
 12:37:50 +0000
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
Subject: [PATCH v4 0/4] Port mxs-dcp to imx6ull and imx6sll
Thread-Topic: [PATCH v4 0/4] Port mxs-dcp to imx6ull and imx6sll
Thread-Index: AQHUZhY3Ifrjs6ztxEq885zu4dQD4g==
Date:   Wed, 17 Oct 2018 12:37:50 +0000
Message-ID: <cover.1539779579.git.leonard.crestez@nxp.com>
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
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4212;6:6xIgmiA89vVx32WMNCwV4tyu/8R3EmFw3hUKDBFSGoFf2sTdtyKgMTrfxNyfK6L2oUsQs6D10RO1EkVou5ixWqvApszeniJrkPYvrPVLNCoSII9zgBJc5cZ1kKrNfbR4mBMgbUygfINBGVWs1sf2PkK3upw52nmYk9K1/xB6K32mikgi/bjhqOad8OM2oQUxzwnVSwIoriWxIWYwRO6oTlGoKC4BiguBkIVdXV/u5GTotjdKulA0RjJU3xs5ReR8X1xMQCBtdMYP1FV7q/SKM1bMnbIZa45dj396A8yJY4qz0/ebnUTgS+snyh1kw7yKFryzoyYesWIJDfFn5ggM09yyLWDg8we+m2Wa56jDik5C7C4Y7Ict/0IlFHmaPoOjjThyVHyt0GAQ3ghpgAdxUNk4qasWYJdzy/T6DwDcvc0USAzU2eSPqxw2kQW+3q4AZN/z32hhKxA1VxzmTmaWbQ==;5:IpdR+oj3WqHQxhQW67KSFrqrYQzgNdLWVKIWYJQ3GzcyUrnh1jNEWqQlRqJei+mTzd+appxLuJfvcKVUTDG71hJUdWJ6Tj4eQ5/NZ0gC8X7shlpJbKWhKM9z7kUtIDnjBgOZ/ifT4+ticKmhWO8U2f+jaOZ2itCToMylGrq24Bw=;7:EM/TcCttgWscBduA/UXTGSx/n5GinF7MsKUGyCnw+A8M5nIcCXLzzePpWcR1KJ6ohY7qydKmLu7S/IkUvtz4G7sO4ZiFlLcc7VeipV7fvYQCJn34Njt7wAMdouzlssGM8ZEOXyFmeoet7h0rBDYLp/0bESfIqMlyY4Tam/jrEbw7SPgLq+tb3bUx3kwdETpd7dnJNkI4Qw8NJkcygrlLvpZ9sPjPrdFhn0rFsY3MeW9Q6jzAOIjurzvMpCiLuyKz
x-ms-office365-filtering-correlation-id: 00e46ef9-deb2-4710-5793-08d6342d59aa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4212;
x-ms-traffictypediagnostic: AM0PR04MB4212:
x-microsoft-antispam-prvs: <AM0PR04MB4212A0D7BC145BAE78378BA9EEFF0@AM0PR04MB4212.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4212;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4212;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(346002)(39860400002)(376002)(189003)(199004)(71200400001)(71190400001)(6636002)(54906003)(110136005)(52116002)(476003)(2616005)(81166006)(6486002)(81156014)(7736002)(8676002)(50226002)(316002)(256004)(14444005)(5660300001)(86362001)(305945005)(66066001)(68736007)(53936002)(4326008)(486006)(25786009)(478600001)(44832011)(39060400002)(14454004)(6436002)(6512007)(8936002)(386003)(26005)(6346003)(36756003)(97736004)(3846002)(6506007)(6116002)(102836004)(2900100001)(7416002)(6306002)(966005)(2906002)(99286004)(186003)(105586002)(106356001)(5250100002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4212;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-microsoft-antispam-message-info: 4mo4x0bGu/K23yD2g0oivPYmE8iCJ09bn+/0WblnZgYxpaHR7+Fk0KenfVQ5IvImCPXb037Gzej/uAKet1u1Ad7ZDjLLO3nsgCPMynXdlIr1KwiEdrd1/IDRwrFyCqMrxXtm1P893qu0po3JXi6ae3xJ2/OThun0+l4luU/ioJYp7MhFuN87gizO01SO6BS+KLY1Gq6EALTDCKL4j6wxahiGPSOKFEAJFXdytfwr2jfcs9ayhOqSh/aWAFYLPK2yNaAOxVxGBB0S/VmJT7AUYLPYtzzFQ4Ju/z6L9QyujD2RzUIJR/AlFbZNFfSdqleH18x0XhkeUG7RMNFrpf+t3fDW2N41uIwmvRJDkU/7/Jc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e46ef9-deb2-4710-5793-08d6342d59aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:37:50.7125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4212
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017123750.uzKszZkkpcU5hAvq1w2vXyny_5Jld5j08pS_c2ARi0o@z>

The DCP block is present on 6sll and 6ull but not enabled. The hardware is
mostly compatible with 6sl, the only important difference is that explicit
clock enabling is required.

There were several issues with the functionality of this driver (it didn't
even probe properly) but they are fixed in cryptodev/master by this series:
    https://lore.kernel.org/patchwork/cover/994874/

Leonard Crestez (4):
  dt-bindings: crypto: Mention clocks for mxs-dcp
  crypto: mxs-dcp - Add support for dcp clk
  ARM: dts: imx6ull: Add dcp node
  ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP

 .../devicetree/bindings/crypto/fsl-dcp.txt    |  2 ++
 arch/arm/boot/dts/imx6ull.dtsi                | 10 +++++++
 arch/arm/configs/imx_v6_v7_defconfig          |  1 +
 drivers/crypto/mxs-dcp.c                      | 28 +++++++++++++++++--
 4 files changed, 38 insertions(+), 3 deletions(-)

--=20
2.17.1

