Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8110DC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 14:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C7462084A
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 14:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.com header.i=@insidesecure.com header.b="HnRn6pMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFTOrh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 10:47:37 -0400
Received: from mail-eopbgr150131.outbound.protection.outlook.com ([40.107.15.131]:1270
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbfFTOrg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 10:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=insidesecure.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vx+Bdtnn0zEhgAgUZLZ+L5eiQUz9DA5sXJ5tAl3gWls=;
 b=HnRn6pMlElM0XWRPqZzvKANsdsMHVM/7hRk/ZWbUliGO/lK2u+hFPBnVLaomYMsZt7xclVPpp9UBFm5wkMAwmW+yt9rvxkelZAqxPHkm04+ARu3VS6Mup76YvCC4IzdO5J83v/LvG8DotZya64emOwIqu85khqVDbwfZWHg1Pqo=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2600.eurprd09.prod.outlook.com (20.177.115.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Thu, 20 Jun 2019 14:47:30 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb%7]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 14:47:30 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVJaNOG3Z2vRtiFUmu6o9Hi+ureqai5fcAgAAGpiCAAZn3gIAAFa7g
Date:   Thu, 20 Jun 2019 14:47:30 +0000
Message-ID: <AM6PR09MB352373E464F758B8D69C62B6D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619121502.GA3254@kwain>
 <AM6PR09MB352354E57F4CB4C9FD6F39B4D2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620130609.GA4642@kwain>
In-Reply-To: <20190620130609.GA4642@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bccb292-ea21-4d3e-5f1e-08d6f58e38a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2600;
x-ms-traffictypediagnostic: AM6PR09MB2600:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB260057FC62E0190AA3AB7364D2E40@AM6PR09MB2600.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39850400004)(366004)(136003)(396003)(199004)(189003)(51894002)(13464003)(52314003)(53546011)(76116006)(64756008)(11346002)(256004)(102836004)(99286004)(305945005)(66476007)(76176011)(7736002)(7696005)(52536014)(14454004)(316002)(6506007)(8936002)(446003)(14444005)(86362001)(486006)(6246003)(26005)(66446008)(66556008)(54906003)(66066001)(186003)(476003)(478600001)(71190400001)(3846002)(8676002)(71200400001)(6116002)(33656002)(30864003)(66946007)(9686003)(81166006)(5660300002)(73956011)(53936002)(68736007)(15974865002)(229853002)(74316002)(55016002)(6436002)(81156014)(4326008)(25786009)(6916009)(2906002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2600;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L0ri06l4AsuKaLNW50XH26Z2BkQVWkrToZdjxCrIc0X81CwqxtQTxfA5d0BnllZRVglALp3FqHq5JthLgxnW2bpL2US0KiYZBvskQ1Cqh6xZDskB9DoaSXMqxL37VY2zHwzReoBnwU+VKwsm+CUcnqp5O8dn10Iro0xOPVwVWpI2EmcbCzwDcpUC3GNiW/2ptJtZfZPfGar419GvPhrOiynoBmRCw575LRCvupRGd2dBxlp8JoTIPgQQ/vwXq9IhTrFDjojNWQlEFGzodu+Hbk6LhSSK+eKU/upzoU4nBMQsF+tyxjnJEUtrJkFmCEpgwWj7JzlQ/fqHB8vV0qsnLiXPHA98QSiSS120ovnvEyBrN7cZuZ3aKzAMa//5KfZdpGb1imkbq+sMTDdiW25L0oZDyoTIfhHIhWzr5RxgBA4=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bccb292-ea21-4d3e-5f1e-08d6f58e38a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 14:47:30.2762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2600
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Thursday, June 20, 2019 3:06 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH 2/3] crypto: inside-secure - add support for PCI base=
d FPGA development board
>=20
> Hi Pascal,
>=20
> On Wed, Jun 19, 2019 at 02:22:19PM +0000, Pascal Van Leeuwen wrote:
> > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > > On Tue, Jun 18, 2019 at 07:56:23AM +0200, Pascal van Leeuwen wrote:
> > > >
> > > >  			/* Fallback to the old firmware location for the
> > > > @@ -294,6 +291,9 @@ static int safexcel_hw_init(struct safexcel_cry=
pto_priv *priv)
> > > >
> > > > +	dev_info(priv->dev, "EIP(1)97 HW init: burst size %d beats, using=
 %d pipe(s) and %d
> > > ring(s)",
> > > > +			16, priv->config.pes, priv->config.rings);
> > >
> > > Adding custom messages in the kernel log has to be done carefully.
> > > Although it's not considered stable it could be difficult to rework
> > > later on. Also, if all driver were to print custom messages the log
> > > would be very hard to read. But you can also argue that a single mess=
age
> > > when probing a driver is also done in other drivers.
> > >
> > Hmm ... don't know what the rules for logging are exactly, but from my
> > perspective, I'm dealing with a zillion different HW configurations so
> > some feedback whether the driver detected the *correct* HW parameters -
> > or actually, whether I stuffed the correct image into my FPGA :o) - is
> > very convenient to have. And not just for my local development, but als=
o
> > to debug deployments in the field at customer sites.
>=20
> I understand it can be convenient, it's just a matter of having a
> logging message for you that will end up in many builds for many users.
> They do not necessarily have the same needs. So it's a matter of
> compromise, one or two messages at boot can be OK, more is likely to
> become an issue.
>=20
OK, got it. So I have to stuff all my logging into one or two very long lin=
es :-P
(just kidding)

> > Also, looking at my log, there's other drivers that are similarly
> > (or even more) verbose.
>=20
> There are *always* other examples in the kernel :)
>=20
> > If it's a really considered a problem, I could make it dev_dbg?
>=20
> Sure. I would say adding one message at boot like this one seems OK. But
> the others would need to be debugging messages.
>=20
OK, then that's what I'll really do.

> > > For this one particularly, the probe could fail later on. So if we we=
re
> > > to add this output, it should be done at the very end of the probe.
> > >
> > I'm in doubt about this one. I understand that you want to reduce the
> > logging in that case, but at the same time that message can convey
> > information as to WHY the probing fails later on ...
>=20
> If the drivers fails to probe, there will be other messages. In that
> case is this one really needed? I'm not sure.
>=20
> > i.e. if it detects, say, 4 pipes on a device that, in fact, only has
> > 2, then that may be the very reason for the FW init to fail later on.
>=20
> In case of failure you'll need anyway to debug and understand what's
> going on. By adding new prints, or enabling debugging messages.
>=20
If it fails for me locally, I can do that. If it somehow fails "in the fiel=
d",
I think most people won't be able to recompile their own Linux
kernel with debug messages let alone add their own debug messages.

Anyway, I'll just make everything dev_dbg to avoid further discussion.

> > > > -static int safexcel_request_ring_irq(struct platform_device *pdev,=
 const char *name,
> > > > +static int safexcel_request_ring_irq(void *pdev, int irqid,
> > > > +				     int is_pci_dev,
> > >
> > > You could probably use the DEVICE_IS_PCI flag instead.
> > >
> > I'm not currently passing priv to that function, so I can't access
> > priv->version directly. I could pass a priv pointer instead and use
> > the flag, but passing a bool constant seemed to be more efficient?
>=20
> That right, whatever you prefer then.
>=20
Ok, then I'll leave it as it is.

> > > > +static int safexcel_probe_generic(void *pdev,
> > > > +				  struct safexcel_crypto_priv *priv,
> > > > +				  int is_pci_dev)
> > > >  {
> > >
> > > > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version & DEVICE_IS_PCI)) {
> > >
> > > DEVICE_IS_PCI should be set in ->flags, not ->version.
> > >
> > As far as I could tell from the existing code, "version" was
> > a highlevel indication of the device *type* (EIP97/EIP197B/D)
> > while flags was more about low-level *features*.
>=20
> Using the same argument I would say the way the device is accessed is
> very run-time dependent, and it has nothing to do with the version of
> the h/w (the same engine could be accessed through different ways given
> the platform).
>=20
> Maybe the name 'feature' is too specific, I agree with you.
>=20
> > So in my humble opinion, version was the correct location, it
> > is just a confusing name. (i.e. you can have many *versions*
> > of an EIP197B, for instance ...)
>=20
> That would be an issue with the driver. We named the 'version' given the
> knowledge we had of the h/w, it might not be specific enough. Or maybe
> you can think of this as being a "family of engine versions". The idea
> is the version is what the h/w is capable of, not how it's being
> wired/accessed.
>=20

Well ... I want to avoid the whole discussion about the naming of the
variable (which can be trivially changed) and what the intention may
have been,  if you allow me.

Fact is ... this variable is what receives .data / .driver_data from the=20
OF or PCI match table. So it is a means of conveying a value that is=20
specific to the table entry that was matched. No more,  no less.
In "your" device tree case you want to distinguish between=20
Armada 39x, Armada 7K/8K and Armada 9K. In "my" PCI case I
want to potentially distinguish multiple FPGA boards/images.

It wouldn't make much sense to me to do the vendor/subvendor/
device/subdevice decoding all over again in my probe routine.
So what exactly is so very wrong with the way I'm doing this?

> > > > +		/*
> > > > +		 * Request MSI vectors for global + 1 per ring -
> > > > +		 * or just 1 for older dev images
> > > > +		 */
> > > > +		struct pci_dev *pci_pdev =3D pdev;
> > > > +
> > > > +		ret =3D pci_alloc_irq_vectors(pci_pdev,
> > > > +					    priv->config.rings + 1,
> > > > +					    priv->config.rings + 1,
> > > > +					    PCI_IRQ_MSI|PCI_IRQ_MSIX);
> > >
> > > You need a space before and after the | here.
> > >
> > Ok, will add (checkpatch did not complain though)
>=20
> It may complain with --strict on this one. (Well, I'm sure many --strict
> tests won't pass on the existing upstream code, no worries :)).
>=20
> > > > +		if (ret < 0) {
> > > > +			dev_err(dev, "Failed to allocate PCI MSI interrupts");
> > >
> > > Do not forget the \n at the end of the string.
> > >
> > Actually, I removed all "\n"'s from my messages as I
> > understood they are not needed? If they are really needed,
> > I can add them to all log strings again ... anyone else?
>=20
> The simple answer is: everybody set the \n, so at least for consistency
> we should have them.
>=20
I did a bit of side-investigation to conclude the same. So I already added =
them.

> > > > @@ -1189,13 +1249,12 @@ static int safexcel_remove(struct platform_=
device *pdev)
> > > >  		.compatible =3D "inside-secure,safexcel-eip197d",
> > > >  		.data =3D (void *)EIP197D,
> > > >  	},
> > > > +	/* For backward compatibiliry and intended for generic use */
> > > >  	{
> > > > -		/* Deprecated. Kept for backward compatibility. */
> > > >  		.compatible =3D "inside-secure,safexcel-eip97",
> > > >  		.data =3D (void *)EIP97IES,
> > > >  	},
> > > >  	{
> > > > -		/* Deprecated. Kept for backward compatibility. */
> > > >  		.compatible =3D "inside-secure,safexcel-eip197",
> > > >  		.data =3D (void *)EIP197B,
> > > >  	},
> > >
> > > I'm not sure about this. The compatible should describe what the
> > > hardware is, and the driver can then decide if it has special things =
to
> > > do or not. It is not used to configure the driver to be used with a
> > > generic use or not.
> > >
> > > Do you have a practical reason to do this?
> >
> > I have to admit I don't fully understand how these compatible
> > strings work. All I wanted to achieve is provide some generic
> > device tree entry to point to this driver, to be used for
> > devices other than Marvell. No need to convey b/d that way
> > (or even eip97/197, for that matter) as that can all be probed.
>=20
> Compatibles are used in device trees, which intend to be a description
> of the hardware (not the configuration of how the hardware should be
> used). So we can't have a compatible being a restricted configuration
> use of a given hardware. But I think here you're right, and there is
> room for a more generic eip197 compatible: the b/d versions only have
> few differences and are part of the same family, so we can have a very
> specific compatible plus a "family" one. Something like:
>=20
>   compatible =3D "inside-secure,safexcel-eip197d", "inside-secure,safexce=
l-eip197";
>=20
> This would need to be in a separated patch, and this should be
> documented in:
> Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
>=20
Ok, then I'll leave that part untouched for now.
(I only changed the comments anyway ...)

> > > > +		/* enable the device */
> > > > +		rc =3D pcim_enable_device(pdev);
> > > > +		if (rc) {
> > > > +			dev_err(dev, "pci_enable_device() failed");
> > >
> > > Please use error messages describing the issue rather than printing t=
he
> > > function names. (There are other examples).
> > >
> > But ... that IS the issue, isn't it? Well, apart from the actual
> > return code. What message text would you suggest?
>=20
> Yes, it is the issue. We generally use a sentence instead of function
> names (something alongside s/_/ / :)).
>=20
Fine, will do.

> > > > +			/* HW reset FPGA dev board */
> > > > +			// assert reset
> > > > +			writel(1, priv->base + XILINX_GPIO_BASE);
> > > > +			wmb(); /* maintain strict ordering for accesses here */
> > > > +			// deassert reset
> > > > +			writel(0, priv->base + XILINX_GPIO_BASE);
> > > > +			wmb(); /* maintain strict ordering for accesses here */
> > >
> > > It seems the driver here access to a GPIO controller, to assert and
> > > de-assert reset, which is outside the crypto engine i/o range. If tru=
e,
> > > this is not acceptable in the upstream kernel: those GPIO or reset
> > > should be accessed through the dedicated in-kernel API and be
> > > implemented in separate drivers (maybe a reset driver here).
> > >
> > Hmmm ... this is some *local* GPIO controller *inside*
> > the FPGA device (i.e. doesn't even leave the silicon die).
> > It's inside the range of the (single!) PCIE device, it's not
> > a seperate device and thus cannot be managed as such ...
> >
> > Effectively, it's just an MMIO mapped register no different
> > from any other slave accessible register.
> > If I had given it a less explicit name, nobody would've cared.
>=20
> OK, that makes sense. If the register accessed is within the register
> bank of the crypto engine you can keep this.
>=20
> > > > +static struct pci_driver crypto_is_pci_driver =3D {
> > > > +	.name          =3D "crypto-safexcel",
> > > > +	.id_table      =3D crypto_is_pci_ids,
> > > > +	.probe         =3D crypto_is_pci_probe,
> > > > +	.remove        =3D crypto_is_pci_remove,
> > > > +};
> > >
> > > More generally, you should protect all the PCI specific functions and
> > > definitions between #ifdef.
> > >
> > I asked the mailing list and the answer was I should NOT use #ifdef,
> > but instead use IS_ENABLED to *only* remove relevant function bodies.
> > Which is exactly what I did (or tried to do, anyway).
>=20
> My bad, I realise there's a mistake in my comment. That should have
> been: you should protect all the PCI specific functions and definitions
> with #if IS_ENABLED(...). When part of a function should be excluded
> you can use if(IS_ENABLED(...)), but if the entire function can be left
> out, #if is the way to go.
>=20
Ok  #if instead of if or #ifdef,that makes sense.
So can I just put all the PCI stuff into one big #if then?

Thanks,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com

