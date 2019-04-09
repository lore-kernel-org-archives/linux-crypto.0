Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE96C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F8C520850
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="o0BaFeAh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfDIQ6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:58:14 -0400
Received: from mail-eopbgr00097.outbound.protection.outlook.com ([40.107.0.97]:44509
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbfDIQ6O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 12:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btF5md+/xq8TQ0aaKeywPUA5J/Dlk1fXp1YwvbmKOBg=;
 b=o0BaFeAhV6UNmmcj9hAp+osiXqOaOJPsxI3gmsa8/5AMw0e/tVvzTnLlxbvXrD8GrUeZggcitUdGcLz5zBSXFGuFY0h/eP7LY2mSEruD2NhN9CufvCmFbpqhjl609Eg8R/4fp7bzLnKkLj1PORvalQAMlg+Rj83SU5v4KPXXzkM=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2664.eurprd09.prod.outlook.com (20.177.115.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.19; Tue, 9 Apr 2019 16:58:10 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 16:58:10 +0000
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
Thread-Index: AQHU2t+fclaO8KhrhESirEuEC3Q5mqYsHxyQgAA+MoCABGuWgIAAZ0FggAGLsACAAXZKUA==
Date:   Tue, 9 Apr 2019 16:58:10 +0000
Message-ID: <AM6PR09MB35234B24CF735E0FB481D6C8D22D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com>
 <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
 <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190408182757.GD9145@gmail.com>
In-Reply-To: <20190408182757.GD9145@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 572c916f-2f70-425d-b71f-08d6bd0c8bd9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB2664;
x-ms-traffictypediagnostic: AM6PR09MB2664:
x-microsoft-antispam-prvs: <AM6PR09MB2664DCF293D5DBE27780E69FD22D0@AM6PR09MB2664.eurprd09.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(346002)(366004)(376002)(396003)(199004)(189003)(7696005)(54906003)(2906002)(316002)(71200400001)(4326008)(8936002)(55016002)(71190400001)(5660300002)(76176011)(256004)(9686003)(6246003)(53936002)(14444005)(8676002)(81166006)(81156014)(68736007)(476003)(6116002)(446003)(6506007)(86362001)(99286004)(3846002)(186003)(486006)(52536014)(26005)(102836004)(25786009)(229853002)(6436002)(7416002)(93886005)(305945005)(11346002)(105586002)(14454004)(478600001)(33656002)(97736004)(106356001)(66066001)(74316002)(6916009)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2664;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3/GMIJLe69E9D8Hb4Hu5nfWnUwrtWvV9QlG/I3GaN1LjPo21wA76Aky7tPwhRrKRc0aZcG5sDCnir7McEuKgIzLXdN8EVEzE42RG9kyK143hBcLXxrO7WAz8b11IP680Ab3eiMTKJI6G3ma+E2DiiJv+M17B84PhDJ1I2ifpGVtOspX0U2nXM/K5IGvL80+rZfzxPYST+jsZKeMZ5tlrbedBFS1Vz9xJwDEz4x1zdCJu4SeVvhkRlEo2FRVllMLI+TgUVvv2g4N076LojHLoZ0YJ1Us5DZJbZucfBF1MY4HLdy74fxbIXGP348lf2y/z7NX8jazqjthW/1oihtqEJtAnDlXECr/ZWem+M+jiI9KpX2o+XvsjdjNCSbcA0ODFb5PR+lBrOTJzYA2r40EmkMyPeiA5FKgafUe8Wu2Znbw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572c916f-2f70-425d-b71f-08d6bd0c8bd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 16:58:10.1181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2664
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> I really shouldn't have to say this, but just because something hasn't
> been
> reported doesn't mean it's not a real problem.  Someone could easily be
> affected
> by one of these bugs where crypto drivers produce the wrong output, and
> never
> notice it because their use case doesn't involve checking the output
> against
> another implementation.  Or, perhaps they noticed but never reported it
> upstream.  Or perhaps they didn't have the time or skill to debug the
> problem so
> just they disabled the broken driver, or used No Crypto instead.
>
> That's why we have tests -- so bugs can be detected immediately rather
> than
> maybe years out in the field after causing critical security
> vulnerabilities.
>
I understand where you're coming from. My first assumption was that
perhaps this corner of the API was not used at all, in which case the
specification and testmgr could simply be updated to remove it.
I suppose that's not entirely the case. But the few (?) users relying
on this functionality could still be changed to use an alternative
approach such as extracting the output IV from the packet data so any
uses NOT needing this output IV are not bothered with it. That may
actually help the performance of software implementations as well.
Somehow, somewhere, that data must be duplicated, which takes time.

In any, we already came up with the alternative approach of having
some kind of "I_DONT_NEED_IVOUT" flag provided by the user.

Regards,
Pascal

