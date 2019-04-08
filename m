Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F95FC282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 08:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 313FB20870
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 08:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="cmg/wNnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfDHI7H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:59:07 -0400
Received: from mail-eopbgr150107.outbound.protection.outlook.com ([40.107.15.107]:17825
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbfDHI7H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 04:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4WoI/2OMIZGFpiA0iXCMbswvWPJjr9qHwxBd1+5K0E=;
 b=cmg/wNncn4a2f6QJ712PIlfQiJ99O+PFRT7mKJkfhuD3x/dFwF+fb2es5l+EYRQz2Emkr1UIGEIcdK4Fyu+VhZJ+cNVJL+E60TK5gHJ+abVJOLB2CmYsvo92p5KPrvBczCiwZMgER0gOi/wMtCBZH+PI14rvFOU6MJi2z1wIrak=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3554.eurprd09.prod.outlook.com (10.255.99.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.13; Mon, 8 Apr 2019 08:59:03 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1771.011; Mon, 8 Apr 2019
 08:59:03 +0000
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
Thread-Index: AQHU2t+fclaO8KhrhESirEuEC3Q5mqYsHxyQgAA+MoCABGuWgIAAZ0FggAC6V4CAAAzmIA==
Date:   Mon, 8 Apr 2019 08:59:02 +0000
Message-ID: <AM6PR09MB35238739075B080390C11341D22C0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com>
 <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
 <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190408055841.xa5dof4e5xqgaitv@gondor.apana.org.au>
In-Reply-To: <20190408055841.xa5dof4e5xqgaitv@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fc44c28-70f7-4753-adc6-08d6bc0072c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3554;
x-ms-traffictypediagnostic: AM6PR09MB3554:
x-microsoft-antispam-prvs: <AM6PR09MB35542F4DE6399B5DA1B6DBF7D22C0@AM6PR09MB3554.eurprd09.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39840400004)(136003)(376002)(366004)(189003)(199004)(446003)(478600001)(11346002)(6246003)(25786009)(6116002)(229853002)(71190400001)(81166006)(52536014)(68736007)(2906002)(5660300002)(3846002)(6506007)(81156014)(14444005)(76176011)(486006)(6436002)(8676002)(14454004)(86362001)(71200400001)(256004)(6916009)(102836004)(54906003)(7736002)(55016002)(316002)(8936002)(7416002)(26005)(4326008)(53936002)(476003)(99286004)(7696005)(33656002)(186003)(74316002)(105586002)(97736004)(66066001)(9686003)(93886005)(305945005)(106356001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3554;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NBHir5ifqJDttHLQVRIpLlcgjsZdgM3ka1wP+E49vttULIdgZOnYfAeAZI+XqxuCcsxmWr1qTVo/2Z1MnXjmDpNTMigqSL/2fcdyZWeLdFD9cLkjbvXvXbk2u/xmo34OiiOz3Tg7yL3MLTwj9D4LCPAH+anomVLOVS8qUBByKFBlJlDIOtfXiu3w56DZs17T9YLwFJx/caNP6bOscHJLfPBZa+RkNdMtVRUoe5J0R2X3JyRblZjmdykL0A6w3NLtt4+Qur3HywLWC9Qe7P9R7SbUDRbj7jc3O6YKLlZwOZ996c9hq4iS/ayT4G94aM4ihWiyOGLaQrmWh9w5sRCjgxKZUasfhOd6GB/hD87zP3Kjqoy+wuj/Ngezz++wUfQhadwf5rXPinWNUmtQwTcOpBxQk728zj4jv7TsflUzPfI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc44c28-70f7-4753-adc6-08d6bc0072c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 08:59:03.0053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3554
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > Then where is this specified? Because I read through all the Kernel
> > Crypto API documentation multiple times, but I have not been able to
> > find ANY reference to any output IV being stored anywhere.
> > Yes, I can infer from the source code that this is what the standard
> > CBC wrapper does, but that may just as well have been a side-effect of
> > that particular implementation.
>
> Patches to improve the documentation are welcome.
>
How should someone who did not architect the API himself know the
documentation is wrong in this regard?  The documentation is the only thing
I have available to go by ...

> Any drivers not obeying this API rule will be broken when used in conjunc=
tion
> with algif_skcipher as well as templates such as cts.
>
Ok, so  removing it breaks some existing functionality, that might  be a va=
lid
reason to keep it in ... BUT these may still not be relevant use cases for =
a
certain hardware accelerator. Which was NOT a problem until the testmgr
started actually *failing* and *disabling* implementations on these feature=
s.
(the iv output is just the tip of the iceberg here, really ...)

So now implementors of hw crypto acceleration have 2 options:
1) tell their customers to keep the run-time self-tests disabled, which mak=
es
them look bad
-or-
2) implement some convoluted work-around in the driver that will slow
down their actual main use cases to the point where the HW becomes useless

It would be nice to have some option in testmgr to just test the core algor=
ithm
itself and not all the nitty gritty corners of the API that may not be rele=
vant
i.e. split off the core algorithm cases (e.g. proper straightforward encryp=
tion
of a single block of data with a certain key) from the API cases.
Perhaps a driver could advertise this through some flag: "I'm not fully API
compliant, so just test the algorithm and not any API corner cases". Or eve=
n
"please don't test me, I will test myself".

An alternative approach would be capability flags to advertise specific API
features, but I can see how you can quickly go overboard with that.

But please do keep in mind that:
a) These crypto accelerators were NOT designed specifically for the Kernel
Crypto API, in fact, the majority of them predate it by quite some margin.
They may have very specific target use cases, like IPsec acceleration or
disk encryption and not be able to (efficiently) support other API features=
.
b) Some features are simply NOT suitable for HW acceleration. A HW centric
API would not advertise those, but we are where we are now ...
c) Working around a) or b) in the driver is sometimes possible, but you don=
't
want to do that for exception cases as it slows down the common case.

Regards,
Pascal



