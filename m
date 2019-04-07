Return-Path: <SRS0=OuJI=SJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBE9C10F0E
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Apr 2019 19:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7D720863
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Apr 2019 19:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="t1HRPR6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfDGTMs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Apr 2019 15:12:48 -0400
Received: from mail-eopbgr20106.outbound.protection.outlook.com ([40.107.2.106]:26087
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfDGTMs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Apr 2019 15:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIUENuY+4nRN0FFuFW40xP/C/dKRVjXUeihuEL1LnBg=;
 b=t1HRPR6ulyg0oE5qg0YLuQVvBErlz8tkLFmMLawDlnH9hZQD8g2JNqpKdMy6YhX7Fpk4P3IJS5joTWTVe4D9cncSLqCk5F5iiRYeNtzgBhp6hZcN8LovEWkEU5w8+Z1ZmUf3PLRG+tBH1IFWCqFPBSAnaHwoX7qziKilZrnIoRg=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3431.eurprd09.prod.outlook.com (20.179.246.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.13; Sun, 7 Apr 2019 19:12:43 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1771.011; Sun, 7 Apr 2019
 19:12:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Zhang Zhijie <zhangzj@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "ezequiel@collabora.com" <ezequiel@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Subject: RE: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Thread-Topic: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Thread-Index: AQHU2t+fclaO8KhrhESirEuEC3Q5mqYsHxyQgAA+MoCABGuWgIAAZ0Fg
Date:   Sun, 7 Apr 2019 19:12:43 +0000
Message-ID: <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com>
 <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
In-Reply-To: <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83c46822-acd6-4ab5-a5ef-08d6bb8d0310
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3431;
x-ms-traffictypediagnostic: AM6PR09MB3431:
x-microsoft-antispam-prvs: <AM6PR09MB3431279E93982D6A1B4AF728D2530@AM6PR09MB3431.eurprd09.prod.outlook.com>
x-forefront-prvs: 00003DBFE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(346002)(366004)(136003)(376002)(396003)(199004)(189003)(4326008)(66066001)(6436002)(25786009)(14454004)(478600001)(229853002)(486006)(446003)(11346002)(26005)(186003)(102836004)(6506007)(476003)(5660300002)(53936002)(6246003)(7696005)(8936002)(93886005)(99286004)(55016002)(8676002)(81166006)(9686003)(106356001)(52536014)(105586002)(33656002)(7416002)(2906002)(6116002)(68736007)(110136005)(86362001)(71190400001)(3846002)(71200400001)(256004)(14444005)(7736002)(54906003)(316002)(305945005)(74316002)(97736004)(76176011)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3431;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fqOxXZrirIchPftCMGTgOQTPifwyG8VnQP9O3gf47UGorHBXotNUF2whPG1f0c8hPgPu/bd1jy/DnGViiyLABFRkrSN3OTu9SDZM1HwIkALpMLHj9sXxvMQplHREtHYsh2Rkh3gqL7FGY8oXzitzSGFroxRJf4VEs4dEAryLQPyu45PhBL+rLmiO+nHzRuZWF1se+pFPmn+nja63Z4CrLQvtobYGBq4qP0XWfyEaYyf5mfBK8MiPAYFo3sH+c5l4QEN/mHc0TDTqyZCmbjw680spLAHzq6AGufU0PjiRzk/mVp17WlUfqp7DdAL3IgpVdGtRBcVC2vPk8iGVRa+caYS+VM5AibsO2BRsu3V2luFVOcGf3LiFfq3/UP0ISgb3VUR/Ej+XzP8+uXGE57jSgRyC/eVtIQtW9ySW2Hkd5ec=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c46822-acd6-4ab5-a5ef-08d6bb8d0310
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2019 19:12:43.4488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3431
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > Herbert, can you explain what users actually rely on the next IV being
> returned?
> > I don't know all the historical context behind this.
>
> Chaining by reusing the output IV has always been part of the API.
>
Then where is this specified? Because I read through all the Kernel Crypto
API documentation multiple times, but I have not been able to find ANY
reference to any output IV being stored anywhere.
Yes, I can infer from the source code that this is what the standard CBC
wrapper does, but that may just as well have been a side-effect of that
particular implementation.

Fact is, there are at least 2 hardware device drivers NOT doing this - and
I want to bet a nice sum of money there will be more - and that this has
not been noticed prior to adding these tests to testmgr, otherwise this
would have been fixed by now. Which seems to confirm that there is no
real use case for this functionality.

So why would we fail and disable crypto drivers that have been working
perfectly fine so far on their true use cases just because of some purely
theoretical "part of the API" that may just as well be personal opinion?

Or add some expensive work-around to the driver, for that matter.
Expensive, because the driver will have to compute the last crypto block
offset, walk the scatter chain, copy the last block data while taking into
account the corner case where this data is crossing scatter blocks.
That's a lot of overhead for something that has no real use case.

Regards,
Pascal
