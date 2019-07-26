Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D768FC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 14:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E3021850
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 14:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="VbdxGNj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfGZO3v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 10:29:51 -0400
Received: from mail-eopbgr790054.outbound.protection.outlook.com ([40.107.79.54]:55712
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbfGZO3v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 10:29:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqCbZWaMmOZnuZj8A+PR5Z9Cgdci0mAQeV6PvzCFW4wF86iGVTtxa1HvWQXSedWP7zy2NuO9LVMzu79jkbBWEWcjPrx8KsK7fZ+DpJpLcjemx1n1hjBahFSN2ZWHfOKwAlGMFJvDYK5KFRrcSLP2rPsAU4mUp5IyKeSo7bUGHYinkc196TeTRVIrA7TkpXK+zPV8GadyjlezedpsoSWr1A0rrLTrLAi7FuYRR8UJBMixKJAhknPS1g20cgZ70wCRBsO85jCpvwTSi+qxHTxoYeP/LiUspdWQz/rX3V5jNj1BQMkZtCawPbMF3SycHv6NumQJCloHp9erR0jwomEqvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkSho6RC8XsmihrWjqRdcZ/chsbIgBLDP9sWktp4B2E=;
 b=S16xOqck5VNpzZQP6c9BG1fDORtiRwrjuzHvKoCzasW/mOjrABak2t3IVkI+WnailDcJo5Wyb9D+r0Y4XAj5CVGD9nI40nhlg6COfARhcazAlFWD+c7Uw8flHLBsBRlfAdKJXEdmIJvwDT4jPhkf5y4uR2HUQKCznKZFLuNH32HeIYocw7yyj+Vq6WYT6sQlcVVD9F6Ge4sQinjWwaGBGHuLheIneXfJHhwSSFCOkCqzT+NJS3WPwg7LilMF9fj2LfW2CnYrSpsP65V4SoDaYwL5rJJDNP2FmZfXA3ftmlUzeie+Dw+0aRWLLC39ory6m3npL1knZCG8p8pLArDCDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkSho6RC8XsmihrWjqRdcZ/chsbIgBLDP9sWktp4B2E=;
 b=VbdxGNj4AVKDDZJ/mvRnYClPchzHja4pRQ9PPK4GKzpDVireXijBgri5rl3C5cXMUos0Loy86LIpDUIRsm0LxTM6w+PWaudmoka9HCReVWIS8kwJjkVk5xsl9dU0O+7QxQa4a6eJkwROfriTdVYaJKVAc3XtdFELPcM0xk9ut2U=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2670.namprd20.prod.outlook.com (20.178.251.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Fri, 26 Jul 2019 14:29:48 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 14:29:48 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Thread-Topic: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Thread-Index: AQHVMwaydQ+3aJIWekiqcp1KNvSggKbc9n6AgAAHURCAAA0+AIAAB9iQ
Date:   Fri, 26 Jul 2019 14:29:48 +0000
Message-ID: <MN2PR20MB2973EB161252E245878473B1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726123305.GD3235@kwain>
 <MN2PR20MB2973C6D05EED9B878D2EC4B9CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726134640.GD5031@kwain>
In-Reply-To: <20190726134640.GD5031@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4222b7d9-899b-44ba-3825-08d711d5b69b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2670;
x-ms-traffictypediagnostic: MN2PR20MB2670:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2670EDAAE2D3096E6D9F22F8CAC00@MN2PR20MB2670.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39840400004)(346002)(376002)(199004)(13464003)(189003)(8676002)(55016002)(6436002)(14454004)(6306002)(2906002)(81156014)(81166006)(8936002)(6116002)(966005)(54906003)(5660300002)(3846002)(68736007)(478600001)(66066001)(74316002)(15974865002)(66946007)(6916009)(486006)(7696005)(316002)(99286004)(186003)(26005)(76176011)(476003)(11346002)(102836004)(446003)(229853002)(6246003)(52536014)(86362001)(76116006)(71200400001)(66446008)(66574012)(256004)(14444005)(71190400001)(305945005)(4326008)(25786009)(66556008)(64756008)(53546011)(53936002)(66476007)(6506007)(7736002)(9686003)(33656002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2670;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YPkm1GIoxRwt/MRjIFpBALqGor3i1sajhw1UBlrvfgj1xwc3ACKIIJjzuwtvqZXR3ATYn2yE1DLCL86+9f3RL7W7cWcjbjAiDN5OxTfklmSWamiErJUd6/HfDzRuAdE8Xol3xM0SGDOTcPi2xcuCR/WtdxvyhG2wPfNm8liU0h5efQWTBsXSnvdWOByMdPLAB/SGPydZ3MBPpz6hhFeDmU7mc67Zqf4KMI4SApWKwmlWVLrG93tIXiFp6T26ZANLKkWGC4Hi7V0cNtern2N8ltXzRtrnad30fR7OQ3dpQWqxEHbeyABzfMjoL6yosNiMpi71WlW3xHulDxcm7ITf5lECiIedjGT4BMLabPmqtIW7Q27O4Cd8c6nUZylhpQXAjroP1zci3jnCl6I0THig/MQn64RE0G+liaqUYMotXCE=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4222b7d9-899b-44ba-3825-08d711d5b69b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 14:29:48.3677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2670
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Antoine,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Antoine Tenart
> Sent: Friday, July 26, 2019 3:47 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH 2/3] crypto: inside-secure - added support for rfc368=
6(ctr(aes))
>=20
> Hi Pascal,
>=20
> On Fri, Jul 26, 2019 at 01:28:13PM +0000, Pascal Van Leeuwen wrote:
> > > On Fri, Jul 05, 2019 at 08:49:23AM +0200, Pascal van Leeuwen wrote:
> >
> > > > @@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct safexc=
el_cipher_ctx *ctx, u8 *iv,
> > > >  				    u32 length)
> > > > -	if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> > > > +	if (ctx->mode !=3D CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
> > >
> > > I think it's better for maintenance and readability to have something
> > > like:
> > >
> > >   if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC ||
> > >       ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD)
> > >
> > Not really. I *really* want to execute that for any mode other than ECB=
,
> > ECB being the *only* mode that does not require an IV (which I know
> > for a fact, being the architect and all :-).
> > And I don't believe a long list of modes that *do* require an IV would
> > be  more readable or easy to maintain than this single compare ...
>=20
> That's where I disagree as you need extra knowledge to be aware of this.
> Being explicit removes any possible question one may ask. But that's a
> small point really :)
>=20
Well, while we're disagreeing ... I disagree with your assertion that you
would need more knowledge to know which modes do NOT need an IV
than to know which modes DO need an IV. There's really no fundamental
difference, it's two sides of the exact same coin ... you need that
knowledge either way.=20

That being said:

1) This code is executed for each individual cipher call, i.e. it's in the
critical path. Having just 1 compare-and-branch there is better for
performance than having many.

2) Generally, all else being equal, having less code is easier to maintain
than having more code.=20

3) Stuffing an IV in the token while you don't need it is harmless (apart
from wasting some cycles). NOT stuffing an IV in the token while you DO
need it is fatal. i.e. the single compare always errs on the safe side ...

4) If there is anything unclear about an otherwise fine code construct,
then you clarify it by adding a comment, not by rewriting it to be ineffici=
ent
and redundant ;-)

> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
