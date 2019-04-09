Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F9AC10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E88F2084C
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="D9mCvQEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfDIPx0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:53:26 -0400
Received: from mail-eopbgr10113.outbound.protection.outlook.com ([40.107.1.113]:13542
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbfDIPxZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 11:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/3KsBq0XPIt4Gfyu0rnB9gdrgu5/35iGZQOG3A/c0U=;
 b=D9mCvQEOvzwV/6d6VKvPvlwqoK24zpq1jjqAXijWKTsSgw8lbpLuS4nVkjfH8BZ/Rf0sNBO18DimFaBvy0RD+LGswGQGD7vsqV5DnXqiaHbII3ULZorfljbytumCWV9rywgkOu3IyYPX3vthpSdqKqNCdpC2zsvKvcK/Ddbx9Ag=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2277.eurprd09.prod.outlook.com (20.177.113.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Tue, 9 Apr 2019 15:53:21 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 15:53:20 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Eric Biggers <ebiggers@kernel.org>,
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
Thread-Index: AQHU2t+fclaO8KhrhESirEuEC3Q5mqYsHxyQgAA+MoCABGuWgIAAZ0FggAC6V4CAAAzmIIAAJ3UAgAICEXA=
Date:   Tue, 9 Apr 2019 15:53:20 +0000
Message-ID: <AM6PR09MB3523A3BE7DE29F55520341C4D22D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
 <20190408090604.7v7s5xhfvwthknio@gondor.apana.org.au>
In-Reply-To: <20190408090604.7v7s5xhfvwthknio@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5354703-09d4-471b-e5da-08d6bd037da1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2277;
x-ms-traffictypediagnostic: AM6PR09MB2277:
x-microsoft-antispam-prvs: <AM6PR09MB227735BDBFBF79BAE3FF60AAD22D0@AM6PR09MB2277.eurprd09.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(376002)(39840400004)(396003)(189003)(199004)(256004)(14454004)(52536014)(7736002)(186003)(26005)(2906002)(6246003)(86362001)(68736007)(6116002)(53936002)(102836004)(316002)(305945005)(9686003)(55016002)(25786009)(6506007)(97736004)(5660300002)(7416002)(3846002)(99286004)(74316002)(486006)(54906003)(8936002)(71200400001)(6916009)(81166006)(71190400001)(7696005)(4744005)(105586002)(446003)(4326008)(106356001)(66066001)(476003)(11346002)(6436002)(8676002)(81156014)(33656002)(229853002)(93886005)(76176011)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2277;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wOJxXJ97r9L/UFs5xIWX2ObukztTURMKV9DMv2zKX7SyEnEaIj8Udwq8qL+tqI5MUHwoQ5ryT3FFdsYxWWRsVyJW7UpvhkgHaBDTbR5QOQ4pkZCIAt4qMhRG/6H8lWacO1jhEAGMDDOf5T8MFhbc59LxymLaBz5RCv8WiuRT3PyXsuUGw2JCKPXgUOKapz84KYZhkRrwWRRqWA/tXN0m3Jo9avh9L71WJDDotC+7giUmuRTsvwiFEzm/5nMjIC2fy1GvxdeNwOqVBmqU7fNuOAAXRJ1ygAFVZUtoejaTM3VHZW3gnFWqz7ruMnHyXwHCnJlODCS8PLF5Li4id9AnhTbbbsQqve4y7/4KQyNg6QyWCp3igLUbHXXi5+qQ9QvmRWjcROhiWIbJXwj6OUv1PqVDLxYCvCD8zxi2GCfuy1k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5354703-09d4-471b-e5da-08d6bd037da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 15:53:20.8796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2277
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>
> What we could do is have the user specify an explicit flag saying
> that they do not care about the output IV.  You could then skip the
> output IV step in your driver.
>
That would work for me, if the maintainers would be OK with adding
such flags.
Also, as a heads up - just to get other peoples opinion here - I
might prefer responding to such a flag by selecting the fallback
cipher instead of actually implementing a workaround for my hardware
in case such a workaround would be detrimental to the performance.

> But you'll have to code this up, including the bit on the user-side
> to actually set the flag.
>
Since that user side probably lives in the kernel tree too, I could
do that. This would then apply to testmgr as well though, as I need
to ensure it disables features for tests that don't require them.
(otherwise you'd be verifying only the fallback cipher)

Regards,
Pascal
