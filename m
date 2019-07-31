Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554B6C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 14:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20CFF208E3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 14:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="oecUOI2s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfGaOXc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 10:23:32 -0400
Received: from mail-eopbgr800078.outbound.protection.outlook.com ([40.107.80.78]:63120
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727169AbfGaOXb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 10:23:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSfbL2fo4A6IUmW0NxdlSFk9WBtTP8kG8E8KjpIBQyOoKEnmkaGJJNr49K2ejtPLa8v5B+z2PFu9TEJ5JCY4j8lN4aHJV5ZUbOTxA2yIffWZWkrOi4QEzFyJhfMT3oygdHPshjtVQxsTkEbdyNz1ZtiSDXf/GKwr7jFbHQMT+vQCUf3b3pYn2fFib20oPLfEWKwtydoj7Qo/GAhDLQRCEBuAl5RUDH4ptbTE/jCrW3iCDuxR8CXSPl119n61bGNkgowVXe0pDWVHExtdkwItBw+qXBJxfKk0gLJO7+6OHGpAU1Ng6fs73OE08MTUFaIYUdGF9TnhLdl1PiNPJubmwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiUR1shoL8wbqdrC25zVaslM1uzRxOinX0Wk+vzF5No=;
 b=EJxPBr4WUjjSv3wexH1mLN7+x4bbPm4BRCZOE72dx1QvDW9T9b45gw08VWoQPGDt4J15wXnXhn1wAtiWCauUaQri3vaxpQiMJIsA9ai869RZfbtAUNoVETaQap51ShrwPbefKnsfbzyoqy1Ae3a/d2T9+hRhmSnvovJelmTIcE6MbqOhquUujqZYjWM81U4hyta1Z+dRTnmxSzn30PU27bkH+jDHnecL58hLpkstk/jnKJk2dlyf1jrm8yib3cRtYCp58zTYqVa8qdifmcgudTWYRZEIhtzX+0FRzkEIk8J5k2VY+hn+yyD64Z0gByk4/uQYBwlbH1hKsNNz7A0l0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiUR1shoL8wbqdrC25zVaslM1uzRxOinX0Wk+vzF5No=;
 b=oecUOI2sjHCH6i8s9rOrqiZAhxciwQnC7lDl4DW+wXFiJX7H+Z6zgKYJmAJAWG83S59bR6hj0fZccFkRGsZvf56bfywLZmCDJCXSN51QgZpP0MX38s8sE0fLqSlm17lOC3SL49RROdWWoDSuy8GZaQYMIG/EzahPt9o3yVSMOcI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2285.namprd20.prod.outlook.com (20.179.146.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 14:23:28 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 14:23:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 3/3] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Topic: [PATCHv2 3/3] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Index: AQHVQ7iGh/FCPWFvzEu8OjwaBoGczKbkruqAgAAcroA=
Date:   Wed, 31 Jul 2019 14:23:27 +0000
Message-ID: <MN2PR20MB297305FF43E83B4BBB5728B7CADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-4-git-send-email-pvanleeuwen@verimatrix.com>
 <20190731122629.GC3579@kwain>
In-Reply-To: <20190731122629.GC3579@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54cfdb37-2e02-462b-1841-08d715c2a7d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2285;
x-ms-traffictypediagnostic: MN2PR20MB2285:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2285F6FC218D3FC3FF85E626CADF0@MN2PR20MB2285.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39850400004)(366004)(376002)(13464003)(199004)(189003)(4326008)(305945005)(7736002)(6306002)(6506007)(229853002)(14454004)(71190400001)(99286004)(74316002)(54906003)(6246003)(110136005)(66476007)(33656002)(71200400001)(64756008)(102836004)(66946007)(53546011)(53936002)(7696005)(76116006)(9686003)(55016002)(6436002)(316002)(66446008)(66556008)(76176011)(966005)(66066001)(25786009)(2906002)(186003)(11346002)(14444005)(256004)(6116002)(26005)(5660300002)(8676002)(86362001)(8936002)(15974865002)(446003)(486006)(3846002)(66574012)(476003)(52536014)(81166006)(68736007)(478600001)(81156014)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2285;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q1+3Mqn6BuiPxO9lVbSMACy4g5DPkSHjv/tOWBINPpWWo8A9akmcG8UsFtaOsC174w5wxyt14EzK+GLUVLlw0Ztx6UmpQx0mAWGmNJIT14hEXKRPtIH3K9piuegUUEPCvCgO72HYpWZzc2jfBMzXS3G7kMR8hskAMLV9oIu/u2LFwpL5z3FDbLJ7IcxBH4Fr9Flituqw447tdKXMpAjEIQmPE8AieSrVds6Qy6q232+5AAWMtPVpErLnKI9zyCezJamiewYUBurFfw/CTa3b+52/XelxnObYTV+NPye52qMLcp5/I5r+PbaLr/5rTQBUJ96trT5d7YlGOzRjDpQj18rNJ5QZX73rgGbRkZPzHe9yTf9mR1d7b7OaEaTqH6hJURYRorexiD+Z39NnYusmIaOvgDlyt21cbwXlF4i/Knc=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cfdb37-2e02-462b-1841-08d715c2a7d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 14:23:27.8503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2285
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, July 31, 2019 2:26 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCHv2 3/3] crypto: inside-secure - add support for using =
the EIP197
> without vendor firmware
>=20
> Hi Pascal,
>=20
> Thanks for reworking this not to include the firmware blob, the patch
> looks good and I only have minor comments.
>=20
> On Fri, Jul 26, 2019 at 02:43:25PM +0200, Pascal van Leeuwen wrote:
> > +
> > +static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
> > +				  const struct firmware *fw)
> > +{
> > +	const u32 *data =3D (const u32 *)fw->data;
> > +	int i;
> >
> >  	/* Write the firmware */
> >  	for (i =3D 0; i < fw->size / sizeof(u32); i++)
> >  		writel(be32_to_cpu(data[i]),
> >  		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
> >
> > -	/* Disable access to the program memory */
> > -	writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
> > +	return i - 2;
>=20
> Could you add a comment (or if applicable, a define) for this '- 2'?
>
Of course

> What happens if i < 2 ?
>=20
Ok, I did not consider that as it can't happen for any kind of legal FW. Bu=
t it
wouldn't be pretty (neither would 2 itself, BTW). I could throw an error fo=
r it
but it wouldn't make that much sense as we don't do any checks on the firm-
ware *contents* either ... So either way, if your firmware file is no good,=
 you
have a problem ...

> > +	for (pe =3D 0; pe < priv->config.pes; pe++) {
> > +		base =3D EIP197_PE_ICE_SCRATCH_RAM(pe);
> > +		pollcnt =3D EIP197_FW_START_POLLCNT;
> > +		while (pollcnt &&
> > +		       (readl(EIP197_PE(priv) + base +
> > +			      pollofs) !=3D 1)) {
> > +			pollcnt--;
> > +			cpu_relax();
>=20
> You can probably use readl_relaxed() here.
>=20
Ok, will do

> > +		}
> > +		if (!pollcnt) {
> > +			dev_err(priv->dev, "FW(%d) for PE %d failed to start",
> > +				fpp, pe);
>=20
> A \n is missing at the end of the string.
>=20
Well spotted, will fix

> > +static bool eip197_start_firmware(struct safexcel_crypto_priv *priv,
> > +				  int ipuesz, int ifppsz, int minifw)
> > +{
> > +	int pe;
> > +	u32 val;
> > +
> > +	for (pe =3D 0; pe < priv->config.pes; pe++) {
> > +		/* Disable access to all program memory */
> > +		writel(0, EIP197_PE(priv) + EIP197_PE_ICE_RAM_CTRL(pe));
> > +
> > +		/* Start IFPP microengines */
> > +		if (minifw)
> > +			val =3D 0;
> > +		else
> > +			val =3D (((ifppsz - 1) & 0x7ff0) << 16) | BIT(3);
>=20
> Could you define the mask and the 'BIT(3)'?
>
i.e. add a define. Sure.

> > +		writel(val, EIP197_PE(priv) + EIP197_PE_ICE_FPP_CTRL(pe));
> > +
> > +		/* Start IPUE microengines */
> > +		if (minifw)
> > +			val =3D 0;
> > +		else
> > +			val =3D ((ipuesz - 1) & 0x7ff0) << 16 | BIT(3);
>=20
> Ditto.
>=20
> >
> > +	if (!minifw) {
> > +		/* Retry with minifw path */
> > +		dev_dbg(priv->dev, "Firmware set not (fully) present or init failed,=
 falling
> back to BCLA mode");
>=20
> A \n is missing here.
>=20
Yes, thanks

> > +		dir =3D "eip197_minifw";
> > +		minifw =3D 1;
> > +		goto retry_fw;
> > +	}
> > +
> > +	dev_dbg(priv->dev, "Firmware load failed.");
>=20
> Ditto.
>=20
Ack

> Thanks,
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

