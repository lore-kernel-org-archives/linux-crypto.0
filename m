Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AEAC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B902E20B1F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="lbSxD0gK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfHEIrr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 04:47:47 -0400
Received: from mail-eopbgr720042.outbound.protection.outlook.com ([40.107.72.42]:61856
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfHEIrr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 04:47:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENC2jPjGldgBy3QnnBW9X0jD+i9kZAofbdUc6FZLHpbXtYUbLCRszzlZ1Kz2UQN7i0tOUkXgTNNZ+iMDqlkWV57nzrjPi6DyCZLdrDm5yy5rEgbekN/CUU3B/qaKW6uzWwUCVvPN6AInR7BD5oJ8YwashU8xgLRJgwmX2Y4bgsfQZrxwRb5YCa+Azsai/X73KUeFJ+EcvV42RUdsXXrLrfcCvP8QHbFdOo9NE4/Y/aZnQVyWgma2vVpMOczzCNxl3SU06b6TItub2m3C2CWnGNwNUEDcpU5WTGybcl/YLnUAfQBccAtBesleoFinEx2jRkLe9JS58FTZlKQWv2WBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rkky8AnFEXWnKPtvSV46P8iBby0A3qMlgP7hzJOBcI=;
 b=nU4qc8OcLRi/05Lu+HogjVArrYRoDFUvuV0CWCQD9baBCF+CV3hHl6RVHeRfRHSUVNXzJ75DfW4LnqVQCw3RJVKkOYuGadm/Dx8BUMoVOl777kxA0Qr+efMjvO5v5iaRHI5NIsFQxz7aORh/QOHY5iYbdG4BPvSJ9fs6t3NjC5Y8QWuTa/51NVhVnBeblylkxrckR6tKB+QjQ+/9QfeBNk3dHRoyMUntgrartXPkfVQDFtx4V1WhMhufp1sGc+TRNOmSKA19wBJEuXof6rglqtE6cIkeW0fBPGYfXtyw/EsvhcELIskclaJv82RyQwsUJFOfiUlb4aNQ3rwIXK957Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rkky8AnFEXWnKPtvSV46P8iBby0A3qMlgP7hzJOBcI=;
 b=lbSxD0gKrdecOBgP1MNTZiakdneN7p7XU32wFz5gMDqgH03wgyZ4d08ADYh5Kgz0xYbQvSNFTZjorssgiNk8d4PZAAlsrkZ9iu0e2J2EDGBf/zljhCFqhynNU+iaRaULr515EdxQx0xt2Ix9VcHnWa3043jOibDwPhjlPk5pNCw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2736.namprd20.prod.outlook.com (20.178.254.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 08:47:42 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 08:47:42 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 3/4] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv3 3/4] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVR711tx55pVdXREWH70DJWI7+XKbsQiUAgAACcwA=
Date:   Mon, 5 Aug 2019 08:47:42 +0000
Message-ID: <MN2PR20MB29735954E5670FE3476F18B6CADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-4-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805083602.GG14470@kwain>
In-Reply-To: <20190805083602.GG14470@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0c4889d-c145-4d68-56d2-08d719819470
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2736;
x-ms-traffictypediagnostic: MN2PR20MB2736:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB273652AE3827DA1CBD7F5D79CADA0@MN2PR20MB2736.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39850400004)(366004)(13464003)(189003)(199004)(51914003)(6116002)(3846002)(8936002)(229853002)(15974865002)(53936002)(66574012)(2906002)(81156014)(8676002)(486006)(446003)(86362001)(76176011)(81166006)(4326008)(476003)(71200400001)(7696005)(11346002)(74316002)(71190400001)(966005)(99286004)(110136005)(54906003)(25786009)(102836004)(14454004)(55016002)(6306002)(9686003)(186003)(53546011)(66946007)(256004)(14444005)(66556008)(26005)(64756008)(66476007)(66446008)(6506007)(33656002)(6246003)(5660300002)(66066001)(316002)(7736002)(478600001)(68736007)(6436002)(52536014)(305945005)(76116006)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2736;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uSs99Ad9AuDuG2KMQpHSzTDRp5tbT/B3q9ot83y7zE/DKl+vvHRU3XJAKvgIylFD95ezXbtQd6x/o8AUQnnG+DS5nfhT4hXzwqvGWYa3SYPpCi5Cay6ZPnm/D/hQKXybbDW5zPxIza/iFQFEfAkV7f736KHV6X7qKDuTuZc5lX2v+lWYQ2qMFd4Q6Tyuod8x8SUryjUALspEIGj48Nt+ZMhHf65Iy4502VGL+2hslbtHgMoXOHKA9VqcN0YWEFNfYkfP7C58kRJY0FiVXmWO4nVn0Ke5JbJjH61Xj/xAdUegc3xpiGByptAW2pSdyzticFKGGYjwtMvNojAcnL0Jjtvmjc06icBmz7+XRTgoMLbPxvYvAU/T1OHCUgm1+LPXZy/0/ftSWJGtyCvwnQxy6+4WutFZkOzlu9noy4PP25Q=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c4889d-c145-4d68-56d2-08d719819470
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 08:47:42.6641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2736
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Antoine,

Thanks for the review and I agree with all of your comments below.
So I'm willing to fix those but I'm a bit unclear of the procedure now,
since you acked part of the patch set already.

Should I resend just the subpatches that need fixes or should I resend=20
the whole patchset? Please advise :-)

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Antoine Tenart
> Sent: Monday, August 5, 2019 10:36 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCHv3 3/4] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
> Hello Pascal,
>=20
> The patch looks mostly good, just a few comments below.
>=20
> On Wed, Jul 31, 2019 at 05:29:18PM +0200, Pascal van Leeuwen wrote:
> > @@ -381,10 +383,11 @@ static int safexcel_hw_init(struct safexcel_crypt=
o_priv *priv)
> >  		       EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
> >  		val |=3D EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
> >  		val |=3D EIP197_HIA_DSE_CFG_ALWAYS_BUFFERABLE;
> > -		/* FIXME: instability issues can occur for EIP97 but disabling it im=
pact
> > -		 * performances.
> > +		/*
> > +		 * FIXME: instability issues can occur for EIP97 but disabling
> > +		 * it impacts performance.
> >  		 */
>=20
> No need to change the comment style here.
>=20
> > @@ -514,7 +517,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *=
priv, int ring)
> >  	struct safexcel_context *ctx;
> >  	int ret, nreq =3D 0, cdesc =3D 0, rdesc =3D 0, commands, results;
> >
> > -	/* If a request wasn't properly dequeued because of a lack of resourc=
es,
> > +	/*
> > +	 * If a request wasn't properly dequeued because of a lack of resourc=
es,
> >  	 * proceeded it first,
> >  	 */
>=20
> Ditto.
>=20
> > @@ -543,7 +547,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *=
priv, int ring)
> >
> > -		/* In case the send() helper did not issue any command to push
> > +		/*
> > +		 * In case the send() helper did not issue any command to push
>=20
> Ditto.
>=20
> > -	/* Not enough resources to handle all the requests. Bail out and save
> > +	/*
> > +	 * Not enough resources to handle all the requests. Bail out and save
>=20
> Ditto.
>=20
> > @@ -731,7 +738,8 @@ static inline void safexcel_handle_result_descripto=
r(struct
> safexcel_crypto_priv
> >  		       EIP197_xDR_PROC_xD_COUNT(tot_descs * priv->config.rd_offset),
> >  		       EIP197_HIA_RDR(priv, ring) + EIP197_HIA_xDR_PROC_COUNT);
> >
> > -	/* If the number of requests overflowed the counter, try to proceed m=
ore
> > +	/*
> > +	 * If the number of requests overflowed the counter, try to proceed m=
ore
>=20
> Ditto.
>=20
> > +#if IS_ENABLED(CONFIG_OF)
> > +/*
> > + * for Device Tree platform driver
> > + */
>=20
> Single line comment should be:
>=20
> /* comment */
>=20
> > +#if IS_ENABLED(CONFIG_PCI)
> > +/*
> > + * PCIE devices - i.e. Inside Secure development boards
> > + */
>=20
> Here as well.
>=20
> > +static int crypto_is_pci_probe(struct pci_dev *pdev,
> > +			       const struct pci_device_id *ent)
>=20
> The whole driver uses the "safexcel_" prefix for functions. You should
> use it here as well for consistency.
>=20
> > +void crypto_is_pci_remove(struct pci_dev *pdev)
>=20
> Here as well.
>=20
> > +static const struct pci_device_id crypto_is_pci_ids[] =3D {
>=20
> Here as well.
>=20
> > +static struct pci_driver crypto_is_pci_driver =3D {
>=20
> Here as well.
>=20
> > +static int __init crypto_is_init(void)
>=20
> Here as well.
>=20
> > +static void __exit crypto_is_exit(void)
>=20
> Here as well.
>=20
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
