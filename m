Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FCCC282DA
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17ABB21473
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 16:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="tyD4Cexw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbfDIQOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:14:15 -0400
Received: from mail-eopbgr80133.outbound.protection.outlook.com ([40.107.8.133]:63711
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbfDIQOP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 12:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6pX0q9rqDn8KC70hMkqJAoif8SKrsMOziDjqp8xBWc=;
 b=tyD4CexwT/S63f5zgKlcJ6SpEm7M7e9s9MpWcciuk5UjKX1rCgInFcFOgVJu+x9qLeVD1I50q8zSWjcV885jLXf2lZqIqMuDApgqSCf8pVLNxaQZmW9sWq+aTTnTKzGsQjZcoOKRii0vCkG3PwI5IKHycaBXq1xKKCQ8MSKRL3E=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3336.eurprd09.prod.outlook.com (20.179.245.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.14; Tue, 9 Apr 2019 16:14:10 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 16:14:10 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Riku Voipio <riku.voipio@iki.fi>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/17] Add zinc using existing algorithm implementations
Thread-Topic: [PATCH 0/17] Add zinc using existing algorithm implementations
Thread-Index: AQHU4HhqZ0R+rbz2UECo8a5sYsqDyKYXSJ6AgAClUACABAkE8IABuZCAgBZqocA=
Date:   Tue, 9 Apr 2019 16:14:10 +0000
Message-ID: <AM6PR09MB352310B03190FD2454DA259FD22D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au>
 <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
 <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com>
 <AM5PR0901MB1155FD05113D6DC79A6274CED25E0@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190326094603.nyfi2dsnt6a6u57f@08efd375aeba>
In-Reply-To: <20190326094603.nyfi2dsnt6a6u57f@08efd375aeba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a98d13bc-3bd0-4588-bd56-08d6bd06664e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3336;
x-ms-traffictypediagnostic: AM6PR09MB3336:
x-microsoft-antispam-prvs: <AM6PR09MB3336088A3705629BCD0D2214D22D0@AM6PR09MB3336.eurprd09.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(136003)(39850400004)(346002)(189003)(199004)(55016002)(74316002)(86362001)(8936002)(6246003)(6916009)(53936002)(9686003)(76176011)(7696005)(54906003)(25786009)(229853002)(7416002)(81166006)(186003)(102836004)(14454004)(6506007)(478600001)(4326008)(7736002)(81156014)(305945005)(68736007)(26005)(106356001)(6436002)(316002)(33656002)(8676002)(105586002)(93886005)(486006)(2906002)(71190400001)(71200400001)(66066001)(476003)(97736004)(446003)(11346002)(99286004)(6116002)(3846002)(256004)(14444005)(52536014)(558084003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3336;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PhlPfZYBUwnDCuI5nnlYr166HpZ4MRq0fXPSneYltAccIUwM4EeVfbtzCWzDbV3Uup0jGWsB4xx3aYOLz/XifHO/nwKdMvP+PRlPDjTlxsg+qwQ4JAEHZS2WdYs2bVXoVfvmUgO2r066uNzhlwB3Z91y1Q5zjW44MXX8+pcejfE5nG8H+lwTeg7RChW2JNFODMaxOA9WUOQb65Xdslt5NlCbHc31JScKz5JGXuTPcE9UHP5K7A2dRi+AxUuJbSA1iUhW75HBW1muD6GXlBtLnsWkb5Y6l9moAQCJ1VasDvTog4BBDgKYPNLIYbpSLTsPCaRYCOScqa5z285nwfOu4gZ9g6h2jh6o/lCMFcvEftrZ4lof0Jndiq8JvGhxADpY3OgrsdIKK1r2Yij2DdsEKf/Zkw4valvp693KyOqiLPs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98d13bc-3bd0-4588-bd56-08d6bd06664e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 16:14:10.2312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3336
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> The firmware files for eip197(?) crypto accelerator are secrets we are
> not
> allowed download anywhere from.
>
Riku,

The driver update I'm working on will fix that issue for you ;-)
I'm planning to upstream my changes but I still need to find the right
approach for doing so.

Regards,
Pascal
