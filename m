From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v3] crypto: add virtio-crypto driver
Date: Tue, 29 Nov 2016 09:25:49 +0000
Message-ID: <20161129092549.GC5152@stefanha-x1.localdomain>
References: <1480334903-6672-1-git-send-email-arei.gonglei@huawei.com>
 <1480334903-6672-2-git-send-email-arei.gonglei@huawei.com>
 <20161128162055.GB11196@stefanha-x1.localdomain>
 <20161128185747-mutt-send-email-mst@kernel.org>
 <33183CC9F5247A488A2544077AF19020DA14A7A9@DGGEMA505-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana <Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com" <pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay.zhou@huawei
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <virtio-dev-return-1735-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA14A7A9@DGGEMA505-MBX.china.huawei.com>
List-Id: linux-crypto.vger.kernel.org

--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2016 at 08:22:58AM +0000, Gonglei (Arei) wrote:
> Hi,
>=20
> > > > > +source "drivers/crypto/virtio/Kconfig"
> > > > > +
> > > > >  endif # CRYPTO_HW
> > > > > diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> > > > > index ad7250f..bc53cb8 100644
> > > > > --- a/drivers/crypto/Makefile
> > > > > +++ b/drivers/crypto/Makefile
> > > > > @@ -32,3 +32,4 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) +=3D vmx/
> > > > >  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) +=3D sunxi-ss/
> > > > >  obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) +=3D rockchip/
> > > > >  obj-$(CONFIG_CRYPTO_DEV_CHELSIO) +=3D chelsio/
> > > > > +obj-$(CONFIG_CRYPTO_DEV_VIRTIO) +=3D virtio/
> > > > > diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virti=
o/Kconfig
> > > > > new file mode 100644
> > > > > index 0000000..ceae88c
> > > > > --- /dev/null
> > > > > +++ b/drivers/crypto/virtio/Kconfig
> > > > > @@ -0,0 +1,10 @@
> > > > > +config CRYPTO_DEV_VIRTIO
> > > > > +	tristate "VirtIO crypto driver"
> > > > > +	depends on VIRTIO
> > > > > +    select CRYPTO_AEAD
> > > > > +    select CRYPTO_AUTHENC
> > > > > +    select CRYPTO_BLKCIPHER
> > > >
> > > > Inconsistent tab vs space whitespace usage.
> > > >
> > Will fix.
> >=20
> > > > > +	default m
> > > > > +	help
> > > > > +	  This driver provides support for virtio crypto device. If you
> > > > > +	  choose 'M' here, this module will be called virtio-crypto.
> > > >
> > > > All the other virtio drivers use underscore ('_') instead of hyphen
> > > > ('-').
> > >
> > > Except virtio-rng.
> > >
> > > >  I suggest calling it virtio_crypto for consistency.
> > > >
> > OK, I will change the Makefile to fix it.
> >=20
>=20
> I tried to do this, but I failed. Because virtio_crypto.ko
> consists of more than one source file which include tree files currently,
> and virtio_crypto.ko matchs the name of virtio_crypto.c.
> That's different with all other virtio drivers.

Can you rename virtio_crypto.c to virtio_crypto_core.c?

I'm not very familiar with the kernel Makefile infrastructure so maybe
there's a better way of doing it.

Stefan

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJYPUmdAAoJEJykq7OBq3PINpkIALZJ1Cd5MP0FQGllnWiFlOHN
U77S9fDnvb/p6HE6G4RdygJMUDRbTIbR95S147WcTAQ1mB6OT5jAq4mN14TweGK7
NQ6NCq+hpFQfQo75h3I2jOFaf4hOBHNhn8TqXmD0OAVFXRm+8pGXO7Ehu62Kwkqw
dosS2yKmgyI5cNyHGmn5kGZUvm6fLQdR0ve31IMXJrXmBv/73qeyWHkGJEoXLRVJ
BReZrHLrsIHBnDkmprNysbNPpQr/NSZ1wUE2v3aayPu3OquUyaktZePDJVyrSKJI
YA0CdbdhLUxfCbc9WSmUjgBZ2SYtqQBo3J88ZSEYg8dlVdeeiBCVO8TdyXMZOWI=
=za4n
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
