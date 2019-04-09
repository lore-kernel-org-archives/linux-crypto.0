Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725E9C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33CA42084C
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="x6gNvDo5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfDIQnN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:43:13 -0400
Received: from mail-eopbgr140097.outbound.protection.outlook.com ([40.107.14.97]:44698
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfDIQnM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 12:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FK7SMnlUejTV82BT0cG78gKEq457hb9w5/NjBjIGxqo=;
 b=x6gNvDo5QWe4JLmciCf/zVfq23H71TTAtFvNPdK632NK3A3ICZzgy7f177oxgcfOS1gOypVohUSrMZ345k9WBRqCGiUxF/tknkVKWtcWeTi94I2M+TZFPDXORQPF0d/7ITj8jeFe+FyCL/1s9m/1d0bc87yCe0DrkjRFh0nHiLQ=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2582.eurprd09.prod.outlook.com (20.177.115.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Tue, 9 Apr 2019 16:43:06 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 16:43:06 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
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
Thread-Index: AQHU2t+fclaO8KhrhESirEuEC3Q5mqYsHxyQgAA+MoCABGuWgIAAZ0FggAC6V4CAAAzmIIAAv2OAgAFz77A=
Date:   Tue, 9 Apr 2019 16:43:06 +0000
Message-ID: <AM6PR09MB3523E27600A51FA6AC0B2702D22D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com>
 <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
 <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190408055841.xa5dof4e5xqgaitv@gondor.apana.org.au>
 <AM6PR09MB35238739075B080390C11341D22C0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190408180948.GC9145@gmail.com>
In-Reply-To: <20190408180948.GC9145@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f629cdc9-e69a-4e68-8ca2-08d6bd0a711f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2582;
x-ms-traffictypediagnostic: AM6PR09MB2582:
x-microsoft-antispam-prvs: <AM6PR09MB2582AD7F4671D3FDC0811498D22D0@AM6PR09MB2582.eurprd09.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39850400004)(346002)(376002)(366004)(136003)(189003)(199004)(105586002)(186003)(6436002)(229853002)(106356001)(5660300002)(33656002)(74316002)(6116002)(2906002)(7736002)(305945005)(3846002)(68736007)(52536014)(14444005)(256004)(71200400001)(71190400001)(26005)(6916009)(53936002)(93886005)(81156014)(81166006)(476003)(25786009)(9686003)(14454004)(7416002)(478600001)(7696005)(4326008)(11346002)(316002)(86362001)(76176011)(6246003)(6506007)(99286004)(8936002)(66066001)(446003)(97736004)(54906003)(8676002)(102836004)(486006)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2582;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dpigncFrK+w2Wu3rEDAGRr4WNoREkVmdmMXq3MK1wrBYXUbt4t2rtOZPwepnidD49/3f2PYbaQ+hJQIDVmME05fhqE+PyI485nxsE0TxBWFKPqrgDwiDHkUEWlIQWPljVi9OQvYBj6aGKGqyqTLcLsYtcvi0HR9Ml77xyEwhZJOBa08JoikTVN0LWATCPmmggiIvokIbVb/0Nz5ih+KnLZcrSsTsnMpJaC+CdKdQYA8HqrBkcdSSkVQQnMskNqn6efTvL86ah3VqFOIsbDNo8iwtJ5CQaO09fJT9x5DkmtvSc0VGWhGFuRewAYjpU5EPt57oK498PjonRj7/mLiTsHXYbV4T2sElSHJ7+6zyQLmaKjcvFb4JUz9vtbWzw9oiThNygcYM+4O48oLLDI9Nk5qoYOpCAEcQkRh0EILfHx0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f629cdc9-e69a-4e68-8ca2-08d6bd0a711f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 16:43:06.3618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> One person's "corner case" is another person's "use case".  Once you
>
That argument works both ways though. Someone else's use case may be
getting decent performance from an accelerator for a specific
application, which has worked fine for years but is now broken to
comply with some (for them!) possibly irrelevant corner of the API.

> register
> your driver with the crypto API, you can't control how it's used.  If
> you
> provide "cbc(aes)", for example, anyone in the kernel may get your
> driver when
> they ask the crypto API to do "cbc(aes)" encryption or decryption.
>
I understand that's how it currently works. So maybe we need some
more control from the driver there, as you suggested below yourself.

> Correctness comes first, and there's no such thing as "testing the
> algorithm,
> not the API", since the API is means by which the algorithm is
> accessed.  So you
> *must* implement the API correctly.  If you don't, it's very much
> Working As
> Intended for the self-tests to disable your driver.
>
But, lacking a formal specification, who decides what is a "correct"
implementation of the API?

> If you aren't happy with the API, then please work with the community
> to improve
> the API instead.
>
That's exactly the plan :-) And I'm not unhappy, by the way ;-)

> E.g. perhaps we should annotate with a new request
> flag all
> users who may actually need the IV chaining behavior.  Then on all
> other
> requests, implementations wouldn't be required to provide the next IV.
> It would
> add complexity, but perhaps it would be worthwhile.
>
There was another suggestion along those lines, but then inverted,
like the user requesting that it does NOT need the IV chaining.
I like that better as it would be fully backward compatible and
you could change just the users that would actually benefit and
leave everything else untouched.

> Remember that in the case of unsupported lengths, keys, or data
> layouts, you
> also have the option of using a fallback algorithm to handle those
> cases.  Grep
> for CRYPTO_ALG_NEED_FALLBACK to see examples in other drivers.
>
Yes, except that I cannot fallback because of the output IV thing
if I don't know the user is going to need the output IV.
I surely don't want to fallback by default! So I need that flag.

Regards,
Pascal

