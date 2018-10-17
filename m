Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29A7ECDE32
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CBA12150D
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="P9MjgvKL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CBA12150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbeJQUdc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:33:32 -0400
Received: from mail-ve1eur01on0040.outbound.protection.outlook.com ([104.47.1.40]:42912
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbeJQUdb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VM3ywRqKvTKgTxhPKNbCHK8ntkEetMyHsExB/wayoeA=;
 b=P9MjgvKLnvW/7AOKmRYrlynFDlLAClulSw3UjTwRdtEWEX9cnUdn0UHt0bXivnig3PwiXCEj9oFGKWcZ9fbQ1n8mhoUKnsq7GqrmS4JCgQ3fhomALuei3t2igb33qggaYOOiHxy5YYlHl+FpZ2G92/6t+Xv2CZCJSmc28TetOEY=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4754.eurprd04.prod.outlook.com (20.176.215.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Wed, 17 Oct 2018 12:37:55 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.032; Wed, 17 Oct 2018
 12:37:55 +0000
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
Subject: [PATCH v4 4/4] ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP
Thread-Topic: [PATCH v4 4/4] ARM: imx_v6_v7_defconfig: Enable
 CRYPTO_DEV_MXS_DCP
Thread-Index: AQHUZhY6VjuQPLXJG0uz+NLrZrnmaw==
Date:   Wed, 17 Oct 2018 12:37:55 +0000
Message-ID:
 <5ba9a89b881f6ce816262ce52f431e32e7fb85a7.1539779579.git.leonard.crestez@nxp.com>
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
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4754;6:Y3TNbW/EZEg3LyAkiDJBzwVW6gVzLMd7hIqjXZhu2XnEIR/Ifzl8ldfJeNgh0YIFGLxTlsAb+AeXmXprE3J/qxI7emytwSwtqHjg8/oEBJ4YudhZ2BwkfWrr0qByqKw0t5At93Z9rDAWP0qkXXbIbKMhsFuppeh3N9sR9uif+zXH8Bi6MxD1256EXI3ESF4QRbtAuUG5FI2z+KO86jUXSUMXDjdMIiedS0O2VDtfKPFKhcHiFtK/KyxBFkTLlmrIHPlGtjTqEjngxy9tOQu495CjbP72gXkj+aEd2SEyIv8BEl4Uxay2X2+f+Zg/npg9k/UnYEgDt6MKN/fwg2uHhdZSYwZy2pIiyiaQ+YekiTqLJ+qcOvvtx0OJ/KOxHy+QXmYPafrZTLl7aMtIONNkTT/DRLUBkwPw6SqenjIwXqP9X0/kn3PdFRZyPoFLxTZSTCcdEAzbkSoXBNti6VUJtg==;5:0qfnmLa+GeHqumTizKSzZMPQC2flKs3CFVYHIQ/nFcI5lBIOed6azS9jbdmH6HPQIleYSHB5OeCi/7BhUUwelYea9kh35sGKDFqCse/FKA0qGo1tbccnhs6Ne+5thlcTik5F8QrzFpxL++oiE00Yy4yhbiWsTy73wzsdwhM+iNY=;7:bYM7YrKbFxW0L3BdS8u+2fPL/v0h9x4Ee54wOzSFKHGFGR93GGNC4znl+dMg7j1kparXx60lZLhGR32SB/kx9GWc0F4/F6m+ImJpyJLFcjvYnRG8LZKc4YHGjoVbRaq3ZxZSUhPRPhSx3N8WJ+xyrZE0McDqQrM65LYX5jJlJBJkOPZC7BD3a/xhS6ic1USRLIoRXKcbPHwF7bUYzgNJg+aIXkSCHCl9IBoBg2t/VOV3AJIaWgaIjJlBvOwLhi+Y
x-ms-office365-filtering-correlation-id: 58db18ba-6c40-4a48-a7b6-08d6342d5c88
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4754;
x-ms-traffictypediagnostic: AM0PR04MB4754:
x-microsoft-antispam-prvs: <AM0PR04MB475442E8D5C99F9042FFD310EEFF0@AM0PR04MB4754.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197)(85827821059158);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4754;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4754;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(2900100001)(6486002)(71200400001)(66066001)(8936002)(5250100002)(36756003)(53936002)(118296001)(68736007)(8676002)(305945005)(97736004)(81156014)(86362001)(81166006)(7736002)(39060400002)(7416002)(71190400001)(25786009)(4326008)(316002)(14454004)(2616005)(6116002)(76176011)(256004)(6636002)(3846002)(2906002)(478600001)(6436002)(5660300001)(44832011)(54906003)(446003)(106356001)(50226002)(26005)(6512007)(52116002)(105586002)(11346002)(110136005)(476003)(99286004)(102836004)(6506007)(486006)(186003)(15760500003)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4754;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: anylA7F6iHLTrHMFEwLAIgKXWC1atl5cmkb8df3s+Gug3pc+p/0xhPpB4SDJHE4qaC2cnNmbZuu1JVs1snq2JTHvsIRMYbL+Z5zT4Qz1mpo957OmgnahHpjek8qqfXCHRFTdhYGexXNhIhDx4/v3bNSvhofdsVKJuQdZXvx18EM9+7qlAyfC8sZl45LY8DC52rTHWa3BihtlDZ8ZJPkYqyRX6ITDkmiDP0WCY5D3pfuBzfsAnbYdW1Clm/TzR40I2UcKoWH2R3Q7OxclG1u1vrHLJL2PQ+mxKZKMX/4hR4t5XlOiLSTggThSVXnHjTsc+gIuGmcYFP7vUCrAV0pLkatvY2H8euPp865c239arAI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58db18ba-6c40-4a48-a7b6-08d6342d5c88
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:37:55.3288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4754
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017123755.zPxpyyItRsd7Kaj9SPPi4zU1qV9624-M3jfDgP5iaMI@z>

This block is present in 6sl, 6sll and 6ull so it should be enabled in
the default imx kernel config.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6=
_v7_defconfig
index 1ad5736c8fa6..57928dff9bce 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -428,10 +428,11 @@ CONFIG_NLS_ISO8859_1=3Dy
 CONFIG_NLS_ISO8859_15=3Dm
 CONFIG_NLS_UTF8=3Dy
 CONFIG_SECURITYFS=3Dy
 CONFIG_CRYPTO_DEV_FSL_CAAM=3Dy
 CONFIG_CRYPTO_DEV_SAHARA=3Dy
+CONFIG_CRYPTO_DEV_MXS_DCP=3Dy
 CONFIG_CRC_CCITT=3Dm
 CONFIG_CRC_T10DIF=3Dy
 CONFIG_CRC7=3Dm
 CONFIG_LIBCRC32C=3Dm
 CONFIG_FONTS=3Dy
--=20
2.17.1

