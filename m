Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5BBC4649B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F19120989
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Gs+2oHAC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfGEOnT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:43:19 -0400
Received: from mail-eopbgr680059.outbound.protection.outlook.com ([40.107.68.59]:5778
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbfGEOnT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 10:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxG7xWR9K32MloDRreqZm8PtJ5mB53lXF+9jUxpUrjQ=;
 b=Gs+2oHAC9SDcDhPyy+pf5O5uvVoR4wUGwRe1gK1uVJ+VKkA0Ms99jC4mprvu3Q98J2vwFDg+8AWwZcjRbc9CuunjFmgz9KNclTPXQXJZGyK7D/dSCJ7ijXOG00fR654fdOXg89WeKLyTZUNDdQpY6PBUBwb2L+DZoyWRMAGlzb0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2670.namprd20.prod.outlook.com (20.178.251.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Fri, 5 Jul 2019 14:43:16 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 14:43:16 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: RE: [PATCH 2/9] crypto: inside-secure - silently return -EINVAL for
 input error cases
Thread-Topic: [PATCH 2/9] crypto: inside-secure - silently return -EINVAL for
 input error cases
Thread-Index: AQHVMOzHSzNVN8M6I0yyxdJs/q73+Ka8HDAAgAABFPA=
Date:   Fri, 5 Jul 2019 14:43:16 +0000
Message-ID: <MN2PR20MB2973EA3AB4B166A95AA3DF6DCAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562078400-969-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190705143624.GF3926@kwain>
In-Reply-To: <20190705143624.GF3926@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19661b8b-7426-4534-6f70-08d701571da0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2670;
x-ms-traffictypediagnostic: MN2PR20MB2670:
x-ms-exchange-purlcount: 2
x-ld-processed: dcb260f9-022d-4495-8602-eae51035a0d0,ExtAddr
x-microsoft-antispam-prvs: <MN2PR20MB26707E83BD077697632685E8CAF50@MN2PR20MB2670.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(396003)(366004)(13464003)(189003)(199004)(71190400001)(33656002)(2906002)(71200400001)(316002)(110136005)(54906003)(6246003)(68736007)(76176011)(7696005)(256004)(52536014)(102836004)(53546011)(3846002)(6506007)(6116002)(5660300002)(66476007)(66946007)(64756008)(66446008)(66556008)(73956011)(99286004)(76116006)(26005)(186003)(25786009)(66066001)(53936002)(7736002)(14454004)(55016002)(486006)(15974865002)(6306002)(74316002)(6436002)(229853002)(9686003)(8936002)(966005)(476003)(11346002)(4326008)(86362001)(305945005)(81166006)(81156014)(446003)(478600001)(8676002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2670;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cBCnY3aRbEmUmgjnFLeQXIQ+z31iGTnmOJSP3u92MC68VgTatXDftCPh5uQly5nr4SEIE993XFc+A+nJCaWyJxYCMgmWT8SqEH56zytekmjptZ3YqfRfrNUWKV0xCrUHRhJxdfDCGUml/gTHIUJxoPQQipBKmV/OrIzTAinHVV5yahgB/WOfwzJI5ovbCYTQAhxlIs+9pgPIbVItZQxTfLAOTxEIvRXFNNkcejRQEoJgvosI7HvPTJFTyVhEkvEdZirWWY9V7qwV4dhP+Oqnp6ZV07hyIbork73Nf8vjX7dCLDzHH+gxk3I/R02JZrkt0aGoog1F6rSdSKsOZGaORsI8Mj64H6gIva8DwDA8AKenbiU2js1DfWajzSaAq9wJtenE1iEUMBrTGn0E1YKvPo/xaMsoNChxXh55Ep6+pu0=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19661b8b-7426-4534-6f70-08d701571da0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 14:43:16.4522
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


> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Friday, July 5, 2019 4:36 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au; davem@davemloft.net; Pascal Van
> Leeuwen <pvanleeuwen@insidesecure.com>; Pascal Van Leeuwen <pvanleeuwen@v=
erimatrix.com>
> Subject: Re: [PATCH 2/9] crypto: inside-secure - silently return -EINVAL =
for input error cases
>=20
> Hi Pascal,
>=20
> On Tue, Jul 02, 2019 at 04:39:53PM +0200, Pascal van Leeuwen wrote:
> > From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-secure/safexcel.c
> > index 503fef0..8e8c01d 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -694,16 +694,31 @@ void safexcel_dequeue(struct safexcel_crypto_priv=
 *priv, int ring)
> >  inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *pr=
iv,
> >  				       struct safexcel_result_desc *rdesc)
> >  {
> > -	if (likely(!rdesc->result_data.error_code))
> > +	if (likely((!rdesc->descriptor_overflow) &&
> > +		   (!rdesc->buffer_overflow) &&
> > +		   (!rdesc->result_data.error_code)))
>=20
> You don't need the extra () here.
>=20
> > +	if (rdesc->descriptor_overflow)
> > +		dev_err(priv->dev, "Descriptor overflow detected");
> > +
> > +	if (rdesc->buffer_overflow)
> > +		dev_err(priv->dev, "Buffer overflow detected");
>=20
> You're not returning an error here, is there a reason for that?
>=20
I guess the reason for that would be that it's a driver internal error, but=
 the
result may still be just fine ... so I do want testmgr to continue its chec=
ks.
These should really only fire during driver development, see answer below.

> I also remember having issues when adding those checks a while ago, Did
> you see any of those two error messages when using the crypto engine?
>=20
Only during development when I implemented things not fully correctly.

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
