Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66913C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 14:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDBDB214AF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 14:22:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.com header.i=@insidesecure.com header.b="ZeZ9mMws"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfFSOWa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:22:30 -0400
Received: from mail-eopbgr130115.outbound.protection.outlook.com ([40.107.13.115]:29883
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbfFSOWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 10:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=insidesecure.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FlJRQKJGSUbBl574hfn9pAnqlImuEnpM+9H9eyJ2t8=;
 b=ZeZ9mMws95wvgDluXBeZ8T3FiPjIYElNeLMepIEilINjsFBBZu7XVgTa71GquLeaSeopFahqoEGlSa3pbpS+RO6yaR+REcHUcBTNPpZH4lAzY/lsmb9y4o8YEdBZP35/jweItNe6UZOhPC0hzin3+nTnib9VtKCqfy2jhsrCbKU=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3171.eurprd09.prod.outlook.com (10.255.99.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 14:22:19 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 14:22:19 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVJaNOG3Z2vRtiFUmu6o9Hi+ureqai5fcAgAAGpiA=
Date:   Wed, 19 Jun 2019 14:22:19 +0000
Message-ID: <AM6PR09MB352354E57F4CB4C9FD6F39B4D2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619121502.GA3254@kwain>
In-Reply-To: <20190619121502.GA3254@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c10d39e-31ad-4fd2-7ea5-08d6f4c189eb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3171;
x-ms-traffictypediagnostic: AM6PR09MB3171:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB31717A9E0F0E0EEB9BCA58EAD2E50@AM6PR09MB3171.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(136003)(396003)(376002)(51914003)(13464003)(199004)(189003)(7736002)(14444005)(256004)(446003)(71200400001)(74316002)(476003)(966005)(6436002)(305945005)(15974865002)(66446008)(66556008)(9686003)(33656002)(229853002)(76116006)(186003)(73956011)(53936002)(55016002)(66946007)(66476007)(25786009)(64756008)(71190400001)(102836004)(486006)(11346002)(316002)(6506007)(53546011)(6246003)(2906002)(6306002)(4326008)(30864003)(86362001)(99286004)(14454004)(52536014)(478600001)(8936002)(6116002)(5660300002)(81156014)(3846002)(66574012)(8676002)(54906003)(76176011)(68736007)(110136005)(66066001)(81166006)(26005)(7696005)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3171;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Cxjiy4pvDOrM82vcP4+tkaTb7pTZQvriATH6p/IN4zWbRqVhrFFcu6pBXKPWnYDkyIK0SHZCqez2xalUT3wzHjwMGpOeBbPIZ+nICIYBdl1mnB16i079Vfl2QXDP+DckWXPlZFZqwmCprWa/JmYArBLI+skiPI6Q58dggqL61EypkzoQrS9FyuBTNwXuAXIR49M9dXukMcuuBm7yrL7VL2MpzDc9eJWEe5KOo4bp6KCrR+vJPY7RIlKsQHnydYY9GWi9e2M88pliZHCUSF+Wq4Y1AnWDoqtJ0PaTYM0wIwBBZn669dIRcowQs2nZ8uWscUjzWVpO1ZHKKgrz5ozrdqXjI7prs8xPOnwG3lvTkxlssNIwD+DTZ0oDBIHzKwaTQ64putUx9pZDalvCcLialB7xKCBcuC7w8HxSEx86Clc=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c10d39e-31ad-4fd2-7ea5-08d6f4c189eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 14:22:19.8072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3171
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Antoine,

Thanks for reviewing.

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, June 19, 2019 2:15 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Subject: Re: [PATCH 2/3] crypto: inside-secure - add support for PCI base=
d FPGA
> development board
>=20
> Hi Pascal,
>=20
> Thanks for the patch :)
>=20
> On Tue, Jun 18, 2019 at 07:56:23AM +0200, Pascal van Leeuwen wrote:
> >
> >  			/* Fallback to the old firmware location for the
> > @@ -294,6 +291,9 @@ static int safexcel_hw_init(struct safexcel_crypto_=
priv *priv)
> >
> > +	dev_info(priv->dev, "EIP(1)97 HW init: burst size %d beats, using %d =
pipe(s) and %d
> ring(s)",
> > +			16, priv->config.pes, priv->config.rings);
>=20
> Adding custom messages in the kernel log has to be done carefully.
> Although it's not considered stable it could be difficult to rework
> later on. Also, if all driver were to print custom messages the log
> would be very hard to read. But you can also argue that a single message
> when probing a driver is also done in other drivers.
>=20
Hmm ... don't know what the rules for logging are exactly, but from my
perspective, I'm dealing with a zillion different HW configurations so=20
some feedback whether the driver detected the *correct* HW parameters -=20
or actually, whether I stuffed the correct image into my FPGA :o) - is=20
very convenient to have. And not just for my local development, but also=20
to debug deployments in the field at customer sites.

Also, looking at my log, there's other drivers that are similarly=20
(or even more) verbose.

If it's a really considered a problem, I could make it dev_dbg?

Downside of that is I will need to educate my customers into=20
building debug kernels just to get some basic support feedback ...

> For this one particularly, the probe could fail later on. So if we were
> to add this output, it should be done at the very end of the probe.
>=20
I'm in doubt about this one. I understand that you want to reduce the
logging in that case, but at the same time that message can convey
information as to WHY the probing fails later on ...

i.e. if it detects, say, 4 pipes on a device that, in fact, only has
2, then that may be the very reason for the FW init to fail later on.

Note that you can only get this message if the EIP(1)97 hardware has
indeed been found. You won't get it if the hardware does not exist.

> > -	if (priv->version =3D=3D EIP197B || priv->version =3D=3D EIP197D) {
> > +	if ((priv->version & EIP197B) || (priv->version & EIP197D)) {
>=20
> You could also use "version & (EIP197B | EIP197D)" (there are other
> examples of this).
>=20
Yes, I will fix that. I just lazily changed the =3D=3D into & :-)

> > -static int safexcel_request_ring_irq(struct platform_device *pdev, con=
st char *name,
> > +static int safexcel_request_ring_irq(void *pdev, int irqid,
> > +				     int is_pci_dev,
>=20
> You could probably use the DEVICE_IS_PCI flag instead.
>=20
I'm not currently passing priv to that function, so I can't access
priv->version directly. I could pass a priv pointer instead and use
the flag, but passing a bool constant seemed to be more efficient?

> >  				     irq_handler_t handler,
> >  				     irq_handler_t threaded_handler,
> >  				     struct safexcel_ring_irq_data *ring_irq_priv)
> >  {
>=20
> > +			dev_err(dev, "unable to get IRQ '%s'\n (err %d)",
> > +				irq_name, irq);
>=20
> I think there's a typo here, the \n should be at the end of the string.
>=20
Yes, will fix, thanks.

> > +static int safexcel_probe_generic(void *pdev,
> > +				  struct safexcel_crypto_priv *priv,
> > +				  int is_pci_dev)
> >  {
>=20
> > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version & DEVICE_IS_PCI)) {
>=20
> DEVICE_IS_PCI should be set in ->flags, not ->version.
>=20
As far as I could tell from the existing code, "version" was
a highlevel indication of the device *type* (EIP97/EIP197B/D)
while flags was more about low-level *features*.
So in my humble opinion, version was the correct location, it
is just a confusing name. (i.e. you can have many *versions*
of an EIP197B, for instance ...)

> > +		/*
> > +		 * Request MSI vectors for global + 1 per ring -
> > +		 * or just 1 for older dev images
> > +		 */
> > +		struct pci_dev *pci_pdev =3D pdev;
> > +
> > +		ret =3D pci_alloc_irq_vectors(pci_pdev,
> > +					    priv->config.rings + 1,
> > +					    priv->config.rings + 1,
> > +					    PCI_IRQ_MSI|PCI_IRQ_MSIX);
>=20
> You need a space before and after the | here.
>=20
Ok, will add (checkpatch did not complain though)

> > +		if (ret < 0) {
> > +			dev_err(dev, "Failed to allocate PCI MSI interrupts");
>=20
> Do not forget the \n at the end of the string.
>=20
Actually, I removed all "\n"'s from my messages as I=20
understood they are not needed? If they are really needed,
I can add them to all log strings again ... anyone else?

> > +		if (ret) {
> > +			dev_err(dev, "Failed to initialize rings");
>=20
> Also here, and probably in other places :)
>=20
> > -		snprintf(irq_name, 6, "ring%d", i);
> > -		irq =3D safexcel_request_ring_irq(pdev, irq_name, safexcel_irq_ring,
> > +		irq =3D safexcel_request_ring_irq(pdev, i + is_pci_dev,
>=20
> This 'i + is_pci_dev' is hard to read and understand. I would suggest to
> use a define, or an helper to get the real irq given if a device is
> probed using PCI or not. Something like "safexcel_irq_number(i, priv)"
>=20
OK, I can do that.

> > +			dev_err(dev, "Failed to create work queue for ring %d",
> > +				i);
> > +			return -ENOMEM;
> >  		}
> > -
>=20
> Why removing this one blank line?
>=20
Don't know, I can add it back

> >  		priv->ring[i].requests =3D 0;
> >  		priv->ring[i].busy =3D false;
> > -
>=20
> Ditto.
>=20
Same

> > +		dev_err(dev, "EIP(1)97 h/w init failed (%d)", ret);
>=20
> Adding a version information in the log means all the outputs will have
> to be updated if we ever support an h/w with a different name.
>=20
Fair enough, then I'll remove all EIP references

> > +/*
> > + *
> > + * for Device Tree platform driver
> > + *
> > + */
>=20
> Please follow the comment styles (you can remove set in on a single line
> here, or at least remove the blank lines). (There are other examples).
>=20
Ok, I'll fix that


> > @@ -1189,13 +1249,12 @@ static int safexcel_remove(struct platform_devi=
ce *pdev)
> >  		.compatible =3D "inside-secure,safexcel-eip197d",
> >  		.data =3D (void *)EIP197D,
> >  	},
> > +	/* For backward compatibiliry and intended for generic use */
> >  	{
> > -		/* Deprecated. Kept for backward compatibility. */
> >  		.compatible =3D "inside-secure,safexcel-eip97",
> >  		.data =3D (void *)EIP97IES,
> >  	},
> >  	{
> > -		/* Deprecated. Kept for backward compatibility. */
> >  		.compatible =3D "inside-secure,safexcel-eip197",
> >  		.data =3D (void *)EIP197B,
> >  	},
>=20
> I'm not sure about this. The compatible should describe what the
> hardware is, and the driver can then decide if it has special things to
> do or not. It is not used to configure the driver to be used with a
> generic use or not.
>=20
> Do you have a practical reason to do this?
>
=09
I have to admit I don't fully understand how these compatible
strings work. All I wanted to achieve is provide some generic
device tree entry to point to this driver, to be used for=20
devices other than Marvell. No need to convey b/d that way
(or even eip97/197, for that matter) as that can all be probed.

>=20
> > +static int crypto_is_pci_probe(struct pci_dev *pdev,
> > +	 const struct pci_device_id *ent)
>=20
> The alignment is wrong here.
>=20
Will fix

> > +{
> > +	if (IS_ENABLED(CONFIG_PCI)) {
>=20
> Can this be called with CONFIG_PCI disabled?
>=20
I would expect not, but I suppose I was fearing it wouldn't compile
with CONFIG_PCI disabled. Since I only have PCI based systems, I
can't really try this.

> > +		dev_info(dev, "Probing PCIE device: vendor %04x, device %04x, subv %=
04x, subdev
> %04x, ctxt %lx",
> > +			 ent->vendor, ent->device, ent->subvendor,
> > +			 ent->subdevice, ent->driver_data);
>=20
> Please drop this new message. If the userspace needs it, I believe there
> are clean ways to get it.
>=20
It's not for userspace ...
This is just information to see whether the HW is correctly
detected. Very useful for debugging and providing support.
Again, I can make it a dev_dbg, but I really DO need this.

> > +		priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
> > +		if (!priv) {
> > +			dev_err(dev, "Failed to allocate memory");
> > +			return -ENOMEM;
>=20
> No need to have a debug message when returning ENOMEM.
>
OK, will remove

>=20
> > +		/* enable the device */
> > +		rc =3D pcim_enable_device(pdev);
> > +		if (rc) {
> > +			dev_err(dev, "pci_enable_device() failed");
>=20
> Please use error messages describing the issue rather than printing the
> function names. (There are other examples).
>=20
But ... that IS the issue, isn't it? Well, apart from the actual
return code. What message text would you suggest?

> > +		if (priv->version & XILINX_PCIE) {
> > +			dev_info(dev, "Device identified as FPGA based development board -
> applying HW reset");
> > +
> > +			rc =3D pcim_iomap_regions(pdev, 4, "crypto_safexcel");
> > +			if (rc) {
> > +				dev_err(dev, "pcim_iomap_regions() failed for BAR4");
> > +				return rc;
> > +			}
> > +
> > +			pciebase =3D pcim_iomap_table(pdev)[2];
> > +			val =3D readl(pciebase + XILINX_IRQ_BLOCK_ID);
> > +			if ((val >> 16) =3D=3D 0x1fc2) {
>=20
> Try not to use magic values, use defines with a meaningful name.
>=20
I can make it a define

> > +				dev_info(dev, "Detected Xilinx PCIE IRQ block version %d, multiple
> MSI support enabled",
> > +					 (val & 0xff));
>=20
> Same comments as the other dev_info().
>=20
And same response from my side. When working with lots of different
HW, some of which only half-functional, such logging is really crucial.

> > +
> > +				/* Setup MSI identity map mapping */
> > +				writel(0x03020100,
> > +				       pciebase + XILINX_USER_VECT_LUT0);
> > +				writel(0x07060504,
> > +				       pciebase + XILINX_USER_VECT_LUT1);
> > +				writel(0x0b0a0908,
> > +				       pciebase + XILINX_USER_VECT_LUT2);
> > +				writel(0x0f0e0d0c,
> > +				       pciebase + XILINX_USER_VECT_LUT3);
>=20
> Use defines here.
>=20
OK

> > +			/* HW reset FPGA dev board */
> > +			// assert reset
> > +			writel(1, priv->base + XILINX_GPIO_BASE);
> > +			wmb(); /* maintain strict ordering for accesses here */
> > +			// deassert reset
> > +			writel(0, priv->base + XILINX_GPIO_BASE);
> > +			wmb(); /* maintain strict ordering for accesses here */
>=20
> It seems the driver here access to a GPIO controller, to assert and
> de-assert reset, which is outside the crypto engine i/o range. If true,
> this is not acceptable in the upstream kernel: those GPIO or reset
> should be accessed through the dedicated in-kernel API and be
> implemented in separate drivers (maybe a reset driver here).
>=20
Hmmm ... this is some *local* GPIO controller *inside*
the FPGA device (i.e. doesn't even leave the silicon die).
It's inside the range of the (single!) PCIE device, it's not
a seperate device and thus cannot be managed as such ...

Effectively, it's just an MMIO mapped register no different
from any other slave accessible register.
If I had given it a less explicit name, nobody would've cared.

> > +void crypto_is_pci_remove(struct pci_dev *pdev)
> > +{
> > +	if (IS_ENABLED(CONFIG_PCI)) {
>=20
> Can this be accessed with CONFIG_PCI disabled?
>=20
Again, probably not, but will it compile without this?

> > +static const struct pci_device_id crypto_is_pci_ids[] =3D {
> > +	{
> > +		.vendor =3D 0x10ee,
> > +		.device =3D 0x9038,
> > +		.subvendor =3D 0x16ae,
> > +		.subdevice =3D 0xc522,
> > +		.class =3D 0x00000000,
> > +		.class_mask =3D 0x00000000,
>=20
> You should use proper defines here, and define the vendor ID in a
> generic way in the kernel. You can look for the use of PCI_DEVICE and
> PCI_DEVICE_DATA as a starting point.
>=20
Ok, I will look into that

> > +		// assume EIP197B for now
> > +		.driver_data =3D XILINX_PCIE | DEVICE_IS_PCI | EIP197B,
>=20
> We do use the data (here and for dt compatibles) to store a flag about
> the version. I think XILINX_PCIE and DEVICE_IS_PCI should be flags, and
> you should be able to set them using pci_dev->vendor_id (or other ids).
>=20
But why would I want to do that as this is more convenient?
Basically, the "version" (wrong name, if you ask me) field was used
to identify the device type, so I just extended that to more types.

> Also, you should prefix XILINX_PCIE and DEVICE_IS_PCI with an "unique"
> name, which should be driver-specific to avoid colliding with other
> possible global definitions. In this driver we do use EIP197_ and
> SAFEXCEL_ a lot for historical reasons, you can pick one :)
>=20
Ok, will do

> > +static struct pci_driver crypto_is_pci_driver =3D {
> > +	.name          =3D "crypto-safexcel",
> > +	.id_table      =3D crypto_is_pci_ids,
> > +	.probe         =3D crypto_is_pci_probe,
> > +	.remove        =3D crypto_is_pci_remove,
> > +};
>=20
> More generally, you should protect all the PCI specific functions and
> definitions between #ifdef.
>=20
I asked the mailing list and the answer was I should NOT use #ifdef,
but instead use IS_ENABLED to *only* remove relevant function bodies.
Which is exactly what I did (or tried to do, anyway).

> > +MODULE_AUTHOR("Pascal van Leeuwen <pvanleeuwen@insidesecure.com>");
>=20
> I think this is usually done in a separate patch, when one has made
> numerous contributions to a driver.
>=20
OK, I can remove that

> I tested it on my hardware and the boot tests passed nicely, so it seems
> there were no regressions (I'll make more tests though).
>=20
> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com
