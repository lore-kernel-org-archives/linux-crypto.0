Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71154C04EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EC302086E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ru1nn1b2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EC302086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbeJPXs4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:48:56 -0400
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:20233
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbeJPXsz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:48:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VM3ywRqKvTKgTxhPKNbCHK8ntkEetMyHsExB/wayoeA=;
 b=ru1nn1b2q9amHs51ED7WVgi5XFkxUKkr63Nx0fyACnoBm7QUGQTVnNP0xn8iIRd5gYEtS1PDYV/eHxJSS0Ivc61u8V3yY56bx/0NvWtzC2RmBTQr1l1w1+Y7FukdNAtD/5al0p6+D9cDb1UMbeWXl/8v4CS3wxBdHTM5ip0NIQM=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4628.eurprd04.prod.outlook.com (52.135.149.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.21; Tue, 16 Oct 2018 15:57:45 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 15:57:45 +0000
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
Subject: [PATCH v3 4/4] ARM: imx_v6_v7_defconfig: Enable CRYPTO_DEV_MXS_DCP
Thread-Topic: [PATCH v3 4/4] ARM: imx_v6_v7_defconfig: Enable
 CRYPTO_DEV_MXS_DCP
Thread-Index: AQHUZWj657IRCPurqEacfyJOzrQ5eg==
Date:   Tue, 16 Oct 2018 15:57:45 +0000
Message-ID:
 <95c59b59a6fb39e623c8e6d3b08f876670a61a58.1539705286.git.leonard.crestez@nxp.com>
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
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4628;6:QRzOiEoS9g+e01nu6CbzRySdN6/z7ztDd5a2umbhbrejhEJxJWq7Mh3S80Bxwtk5ymBq+oCKHzFNLj+JhUquAQ6Ys3p6L934Mpbjjw8rx1wVyQ3D3SfEVOCdEqf4X6kNsJ/TV0+vW5vCMEFENquHwMxWqIRQdcKwMLyYybW2gNhSk9H0peoASttyCtX3LsHdo5m2JvxBV9cvbasoRLFHXidr3a0k+DEFzequ3bzwxXjGqHQzlZmQLX1yv4Ycr1OJwEuucPHno+pDo0PQ2dU42dwQSKVabREIjnfYrpM+kpWY2kpwlm3wWZuNboXIrS1g9OoV4D/SYLhBQlssxRrP/55iSKfdBc3+wFrk5WpXCaSSFnlOj32p77HUTeCSfASpTs4Srhij6pdW5h+hf+8sm1Fcng6T0TpC84KXWKvONveLyGzwxPVCfbxlPaavm9ah2l/ALcgcxyFwooT1Yw1rQA==;5:3OzfuhdTz/K7WgAYIRTzQESfeLp4yOeLouFSsw5ZZT36An6RLRsMjCDOp6N/HgqOcr1gGtB7YRWB8bs9ubn9sofARaVWtdzeK084ASMX8xEAbnHQ10Cy94+TEnxNgqgOawxE6Ls4TZ0XCZKDQ6JM0FR9IvSjr2mbYQJWwRscigI=;7:fWosN77Owsgn0lz34xaDVNGG8+TZQDfxjrY8pAnvfAa0Tj/iRSlVCS8EqEgbPHKQ0yAFoe0P6tiE3r+HBl1gCd9o5qjQqEJZUpjMpYRfmiXGFdO86+5juQB0sLiNs0GYueaBhAL4ooy8Jw66aJaSHqGqSHkXZw3X+4sFWajBau/H9RtrB0VAsg8iTTJfdFHfMbcftHPs6wzLbZJC84nscUVJiE+v0P39a+S03WD+Oc81vxBWyckDkLuD1aX3Y29u
x-ms-office365-filtering-correlation-id: 88217c67-c7e9-4c41-aa24-08d633801cbd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4628;
x-ms-traffictypediagnostic: AM0PR04MB4628:
x-microsoft-antispam-prvs: <AM0PR04MB462809FA0AF1B740656E207BEEFE0@AM0PR04MB4628.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197)(85827821059158);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991067);SRVR:AM0PR04MB4628;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4628;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(186003)(256004)(66066001)(53936002)(6486002)(118296001)(2900100001)(8936002)(36756003)(5250100002)(68736007)(305945005)(81166006)(86362001)(39060400002)(8676002)(81156014)(7416002)(71200400001)(71190400001)(4326008)(25786009)(316002)(7736002)(97736004)(6116002)(3846002)(2616005)(478600001)(110136005)(6636002)(2906002)(14454004)(11346002)(26005)(44832011)(52116002)(476003)(446003)(50226002)(6436002)(6512007)(5660300001)(102836004)(99286004)(386003)(76176011)(106356001)(54906003)(15760500003)(105586002)(486006)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4628;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: lnV3NMNQGPSnuKpEpGRlE71rRmEfNQSFwYEm/+5o1g7ca1ltQlRTiGZNRvjZZPtgaZO6tC0X196t+aYjUO0xIzQwucj67zdom9VAHxbDP/3oTrOO1fATvOktqhJoMqOSHp1aLWskbHzciAu7LXWYrwyaKHviVK51PKHI5g5W6f6kaEbkZT/bSaGuEUUqkEWuoifUPzpr1e3xzBbyFdIbwjxp3+WWpX6FqgRlsoQUGUR9gaV6BhlYZLy/sGt/R2LNPyE8pyG82K9aeZx5srunh86tm37Mtni5ZjsszW0ydYF5hMEHxnvDLIHILijMFaSvyupwVLBHa0O9qRC568ttEhQVOkQKwl18HLc3ymOFHfQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88217c67-c7e9-4c41-aa24-08d633801cbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 15:57:45.3168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4628
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016155745.Qv2cU7X3gWmkBXyDUYDesSxh8PnVPGYSOMTMkyNKpts@z>

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

