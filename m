Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA338C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CDAC20874
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZqclGGUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732002AbfFLKeA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 06:34:00 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:23683
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727795AbfFLKeA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 06:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUEOU0Gw7n1cr26oWMaJDpbbQOQP0I/5ldyq/EuvTiQ=;
 b=ZqclGGUABCkRFJTsTJNGEDZc7WrLucvzQrst+CH67TYeUF7Rg37hAUUWkdC1eFNCE2rzfzbkCM12leV1RW4HzbEKR0qPj/qGRFum1MjxZguCi53REkg37M1AL+HIGR4raSyDJkAh+UuZePbyRCFEgU19iNfk+8aTyXxOWmE4vmk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2814.eurprd04.prod.outlook.com (10.172.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 10:33:56 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1987.012; Wed, 12 Jun 2019
 10:33:56 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     Fabio Estevam <festevam@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: ctr(aes) broken in CAAM driver
Thread-Topic: ctr(aes) broken in CAAM driver
Thread-Index: AQHVCx8ztYDI45kiAkWqyLHDh7QIDQ==
Date:   Wed, 12 Jun 2019 10:33:56 +0000
Message-ID: <VI1PR0402MB3485F22CE6052F7CC24AAC3E98EC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
 <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
 <20190515132225.oczgouglycuhqo4l@pengutronix.de>
 <VI1PR0402MB3485ED478A2A3E0087E81F7C98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190612094050.6esonhumzv2ywhdh@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cd9d81d-2cc5-4c27-c965-08d6ef21791a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2814;
x-ms-traffictypediagnostic: VI1PR0402MB2814:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB281476C2B8A348CA6497983498EC0@VI1PR0402MB2814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(346002)(366004)(376002)(199004)(189003)(99286004)(7696005)(76176011)(44832011)(73956011)(76116006)(486006)(53936002)(66476007)(66556008)(478600001)(316002)(9686003)(66946007)(64756008)(66446008)(54906003)(446003)(6306002)(476003)(6116002)(6436002)(3846002)(25786009)(966005)(4326008)(55016002)(14454004)(68736007)(53546011)(6506007)(5660300002)(2906002)(102836004)(26005)(86362001)(66066001)(52536014)(6916009)(229853002)(74316002)(6246003)(81156014)(256004)(8676002)(186003)(305945005)(7736002)(81166006)(71190400001)(33656002)(14444005)(4744005)(8936002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2814;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LVVTKzihArSrxHVln1U554T0QJ7uGy46xA6OyoCCBxVcg0QUjAlY3IhJQgpEMJjDuXtNPJwUPrejwijGmgSG7doXTnPQYCfZoANQb5j13SYZ3vskQScr5+ODZD53SPwisNoSEdabfuHHK4LtI9h8A3MrFly3I1XnRNhwNDz9xvVkk2r2Z11VF7y0txJkwBE8oI22YrbBJP73o7+ZHkm0x6OEs4bsblWRMVw17vJlidIaZu8M5BvwCOZR9sTAWQLAVg9yR8FCWD8t7/HaodUqWV9YZwa6MFRQ6oDX1AztyPl+gUojrPhrjAfVSNMqM5UuzYcXQ2ZsZnsYKHTyBahAlOHli9mkBf0A5Z3H1uAu2H0YbpTeW4DU2koZH/1vQbr23GUxK+lJ5TslHXyjd5YRrA4b97SWcAxrQYARXBsIbj0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd9d81d-2cc5-4c27-c965-08d6ef21791a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 10:33:56.2642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/12/2019 12:40 PM, Sascha Hauer wrote:=0A=
> Hi Horia,=0A=
> =0A=
> On Wed, May 15, 2019 at 01:35:16PM +0000, Horia Geanta wrote:=0A=
>> For talitos, the problem is the lack of IV update.=0A=
>>=0A=
>> For caam, the problem is incorrect IV update (output IV is equal to last=
=0A=
>> ciphertext block, which is correect for cbc, but not for ctr mode).=0A=
>>=0A=
>> I am working at a fix, but it takes longer since I would like to program=
 the=0A=
>> accelerator to the save the IV (and not do counter increment in SW, whic=
h=0A=
>> created problems for many other implementations).=0A=
> =0A=
> Any news here? With the fix Ard provided gcm(aes) now works again, but=0A=
> only as long as the crypto self tests are disabled.=0A=
> =0A=
I've recently submitted support for IV update done in HW (caam engine),=0A=
which fixes this issue:=0A=
https://patchwork.kernel.org/cover/10984927/=0A=
=0A=
Unfortunately it's probably too big to be sent to -stable.=0A=
We'll have to rely on Ard's workaround on previous kernels.=0A=
=0A=
Horia=0A=
