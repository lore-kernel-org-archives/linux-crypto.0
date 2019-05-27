Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F934C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 21:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F8A20859
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 21:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="QvBJfL0Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfE0VGw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 17:06:52 -0400
Received: from mail-eopbgr40137.outbound.protection.outlook.com ([40.107.4.137]:26862
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbfE0VGw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 17:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ffbn4txAt7FdNoqfeYbaQ+TkIuqTMwP9ch3CuaxKgA=;
 b=QvBJfL0QRZMfIG66SIg402nfpIvLplcuz22rQmKQaXpH9a2O7jqgDyXJ5Ng/9iCu9N0sFXB6T6lRPGqxxOiyA4uKHvWsmUmAr60Q3c7F0PFBMCGiN51SbO+IdsaXcyMQc9zTOlcZoNv3GfYIuOSIl3z5btM6jVqy7cyeY9M2PDA=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2231.eurprd09.prod.outlook.com (20.177.113.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.21; Mon, 27 May 2019 21:06:48 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 21:06:48 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
CC:     Riku Voipio <riku.voipio@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: crypto: inside_secure - call for volunteers
Thread-Topic: crypto: inside_secure - call for volunteers
Thread-Index: AdT/U6NOlHK52506RKGw2EuTDrqaWQABLx+AAAA8mJAAAMUMAALn8IMwAmg1TgAADGhXgA==
Date:   Mon, 27 May 2019 21:06:48 +0000
Message-ID: <AM6PR09MB35237977C0E5FFB566CE3F33D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <DBBPR09MB352627DA3C425CECC763B99FD23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430132653.GB3508@kwain>
 <DBBPR09MB352652D305657569DCA6E436D23A0@DBBPR09MB3526.eurprd09.prod.outlook.com>
 <20190430135542.GC3508@kwain>
 <AM6PR09MB3523E393D4EA082FDDBC9251D2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190527150057.GD8900@kwain>
In-Reply-To: <20190527150057.GD8900@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 874b8a3a-78ac-4f68-3f80-08d6e2e73ba4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB2231;
x-ms-traffictypediagnostic: AM6PR09MB2231:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2231B2A5A02D7AD3162E4403D21D0@AM6PR09MB2231.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39850400004)(396003)(366004)(199004)(189003)(13464003)(6916009)(71190400001)(71200400001)(6506007)(86362001)(53546011)(256004)(76176011)(5640700003)(74316002)(54906003)(2501003)(7736002)(55016002)(26005)(316002)(9686003)(6436002)(68736007)(305945005)(102836004)(7696005)(229853002)(2351001)(6116002)(3846002)(186003)(66066001)(53936002)(446003)(11346002)(33656002)(15974865002)(2906002)(486006)(476003)(73956011)(66946007)(66476007)(66556008)(64756008)(66446008)(81156014)(81166006)(8676002)(8936002)(99286004)(25786009)(52536014)(5660300002)(6246003)(14454004)(76116006)(4326008)(478600001)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2231;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nv58xHTsrO6WirwiXeFUXSPU2jJi0O6BnTjXhkTgu1UQSkSGUnyumdsuakvMH6XMkT7peQc+jGIurrpf3lgk/qSFIQ0fJChj81gxGVCEhaSfJdFK+blt1aS6VVLHjYfhNYbbdYMYEIyvNf5uqGfyWBvTCeuiWA1Ox/l05X+GoHDyZFMbgRMW93O9jBzY7mps0sWuAy0sgA56M1uhXX0Ps7KxOEzqRlTJgse3rYOPZdhu/WYHvd6uXO/SYcdwj8wA3FxzCXuBuVQjD4gLGPy2c9ut/tWls/onEHWCpYEYkbnbJEzWo+0JqpkTDY1nXCBJ1+vcnRp7Wrytv+k34lxrmR98c9m7xiVFXfbwEmPjNKJgYwqeGpWlJu9KJYqaBzH0rVDdjHCKrHsw5L+sxngGoxc5Ib5rpsjKl6ghE9mlIlc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874b8a3a-78ac-4f68-3f80-08d6e2e73ba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 21:06:48.5076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2231
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: antoine.tenart@bootlin.com [mailto:antoine.tenart@bootlin.com]
> Sent: Monday, May 27, 2019 5:01 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: antoine.tenart@bootlin.com; Riku Voipio <riku.voipio@linaro.org>; lin=
ux-
> crypto@vger.kernel.org
> Subject: Re: crypto: inside_secure - call for volunteers
>
<snip>
> Sorry about the looong delay. I did make a quick test of your series and
> had some issues:
> - You added use of PCI helpers, but this new dependency wasn't described
>   in Kconfig (leading to have build issues).
>
Ah OK, to be honest, I don't know a whole lot (or much of anything, actuall=
y)
about Kconfig, so I just hacked it a bit to be able to select the driver :-=
)
But it makes sense - the PCIE subsystem is obviously always present on an
x86 PC, so I'm getting that for free. I guess some Marvell board configs
don't include the PCIE stuff?

I guess the best approach would to config out the PCIE code if the
PCIE subsystem is not configured in (instead of adding the dependency).

> - Using an EIP197 and a MacchiatoBin many of the boot tests did not
>   pass (but I haven't look into it).
>
Actually, if you use driver code from before yesterday with Herbert's
crypto2.6 git tree, then the fuzzing tests would have failed.
I originally developed directly against Linus' 5.1 tree, which apparently
did not contain those fuzzing tests yet.

> I'll perform the test again to at least give you a trace :)
>
Please sync with my Git tree before trying, that should help a lot.

> Btw, I'm available on IRC (atenart on Freenode), that might be easier to
> have a discussion when debugging things.
>
I'll see if I can get some IRC client installed over here.
Haven't used IRC in over a decade, didn't know it still existed ...

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

