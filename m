Return-Path: <SRS0=nKf/=NL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9128CC0044C
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Oct 2018 10:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E03C205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Oct 2018 10:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Op7j43lB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E03C205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbeJaTob (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Oct 2018 15:44:31 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:53248
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727980AbeJaToa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Oct 2018 15:44:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQnRHBOMmKChGV++xKHokvPvBVQMI4ZJnkAyEUzA5/8=;
 b=Op7j43lBPabe6+UwNREMWCRKtj4cf/tp8RxdSPuV9echpsAQWw+EmRRZPqyBOoeJlKyFBhDhFfPTShOxgcbBGMfOOt0PhTNstqQqITufUQ6bsIWzZbGUgvY9r8ZEdfioWSxvS3J4lXkVPsagFUecUupyNecf3C/gxODf/n5XJVI=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4241.eurprd04.prod.outlook.com (52.134.126.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.24; Wed, 31 Oct 2018 10:46:52 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::989c:6296:ecdc:89ff]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::989c:6296:ecdc:89ff%2]) with mapi id 15.20.1273.027; Wed, 31 Oct 2018
 10:46:52 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Marek Vasut <marek.vasut@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Topic: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Index: AQHUZhY4HefM3c9m50qn78KSFJ8+NA==
Date:   Wed, 31 Oct 2018 10:46:52 +0000
Message-ID:
 <AM0PR04MB4290A361A92B782DC5A9F8BDEECD0@AM0PR04MB4290.eurprd04.prod.outlook.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
 <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
 <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com>
 <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
 <CAOMZO5DCzM_NnqD4tHTAn4pAaUdQGo38Ami1h3pu9SzgyQ7GnQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4241;6:luT7ro8bLtr7MXY1Ro1RKs2wQa2H7DljrrtfCJL1Bdv8gcNiMU/kqch3+RcSPvpSc6SiPT5Y0CBaoefR/OV5s9lcp53Tp+vigiDAYzbAij9+Dt+AqowAjfbhPeBp8+1FlElpJvZOQ8Xu80UaLdTI8vEXaYnXSSTMfMzPtyeqBAZQuOTp/ZmZuofoLYQz8If5I1t+uTNEcdOqS9LGfMqqHVdl58iBnDp3qgjhveNnceFfzhiWY9D1B91YYxm1eQ5mUHBXdH5y0MqPSavGB6SX62czxYK6U+lsR+2AeiXdBf8g+FFKmRlVYVnT4yNKs5ckcqxOCEo147b9Fp0oNHOivDS3EwCB02OH+ZpE+/AYNgk9/avlpU72ARfz5sBZCm7TcTtfZsxxm8wiGgR0LFwc4sziwW2xXU7OH6pPsof7Bbjpc/nPdbrq09sfOwWKerWpNc2kM+nEv54KRMcIr5p/7A==;5:IDarvoy5jqrcDNRZpZkULGSczBoBc6zZSowP+fZD/XavkhoKH4JfBnU8xMX/a8ulf1BDEjwIe5K8TBRQNBw4rvYIacu2sd75X6Z7evcmqwaW68E7AExOFNBgY+BeuSL1QDOPRdKNnz1tNFMu8F4R0k5RuwlluMWRBs4xeNc6v3M=;7:NELqfxX3gkvQklZZPG7X1GeRPrgxCqUzk44fyj0zU2usNlgXmo+NRSvy3RoN56hFx5fUh51BaOZA8fu6S2eCi4SqFiSUVcu11NSoj8HEgqNl6uxGUs6Le9vA03W2NqVfDfx59iU3+ygYPAPI2LyuCw==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 1555476a-4b3d-45ba-0bc2-08d63f1e2b2e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4241;
x-ms-traffictypediagnostic: AM0PR04MB4241:
x-microsoft-antispam-prvs: <AM0PR04MB4241D0FE1B310780856D95D9EECD0@AM0PR04MB4241.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197)(85827821059158);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4241;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4241;
x-forefront-prvs: 084285FC5C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(396003)(366004)(39860400002)(54534003)(189003)(199004)(102836004)(2906002)(446003)(7696005)(476003)(74316002)(6116002)(486006)(53546011)(81166006)(14454004)(8676002)(81156014)(76176011)(68736007)(6436002)(6506007)(186003)(55016002)(99286004)(26005)(6246003)(229853002)(7416002)(3846002)(6306002)(305945005)(44832011)(53936002)(86362001)(5660300001)(9686003)(7736002)(4326008)(66066001)(71190400001)(93886005)(316002)(54906003)(110136005)(33656002)(25786009)(39060400002)(71200400001)(2900100001)(256004)(14444005)(8936002)(106356001)(105586002)(966005)(478600001)(97736004)(5250100002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4241;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: yJIHXqWFqmko3sXmW8lW124soh2wl78hFzjwRVhkeKuiRNJXYy0uMnDCQI0PTH/pYMVSn57F1f6wtXZYS2fOTpvitV7hM3HW/6CZAN7Ml7MU3OaQhG9TBtihWMa5vsvqH0S3yYdPzMZeGnwdGXY0qany+hW5f0psU38y45j8QxZy7Cx1Zi2anUrq64izwLFqUi45Eorhv6bapG9GuVj6VBEsvNO1tifB6XwqhO66Kxcq2LMi9Jypghni8wrm56qwIewTm64AR/ExkKseqEXj9FT5nYr12lS+cA3vyEp+oSFmNdWFh9tki7yAlinj2umHq8TjDPfTnJczE12wwieaOXONdOI8uud0pJJ82VOyP8A=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1555476a-4b3d-45ba-0bc2-08d63f1e2b2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2018 10:46:52.4573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4241
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181031104652.lpLq8TqETPSAA54BpeBU2y4IveMO4vyMccagzEcTK0I@z>

On 10/17/2018 4:02 PM, Fabio Estevam wrote:=0A=
> On Wed, Oct 17, 2018 at 9:59 AM Leonard Crestez <leonard.crestez@nxp.com>=
 wrote:=0A=
> =0A=
>> There is a changelog in the cover letter.=0A=
> =0A=
> It did not show up:=0A=
> https://lkml.org/lkml/2018/10/17/673=0A=
=0A=
Sorry, I forgot to copy the changelog for v4. The only change is the one =
=0A=
we discussed earlier in this thread.=0A=
=0A=
>> This only looks slightly odd in git diff but it's not unrelated.=0A=
>>=0A=
>> I placed clk get/prepare/enable just before stmp_reset_block and made=0A=
>> stmp_reset_block print a message and goto err_disable_unprepare_clk on=
=0A=
>> failure instead of just "if (ret) return ret;"=0A=
> =0A=
> Got it! Then it looks fine, thanks:=0A=
> =0A=
> Reviewed-by: Fabio Estevam <festevam@gmail.com>=0A=
=0A=
Thanks for looking at this series.=0A=
=0A=
Shawn already applied patches 3/4, I guess parts 1/2 should go through =0A=
the crypto tree? I don't know how crypto treats patches in the merge =0A=
window, I can resend with all the ack/review tags after rc1 is out.=0A=
