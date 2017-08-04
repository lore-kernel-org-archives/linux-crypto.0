From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v6 1/7] drm/tilcdc: ensure nonatomic iowrite64 is not used
Date: Fri, 4 Aug 2017 16:03:12 +0300
Message-ID: <2b41b02c-07e3-b927-f276-a29480f94285@ti.com>
References: <20170803183018.5889-1-logang@deltatee.com>
 <20170803183018.5889-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="Spb6H6ES3NmNPePXmfAm7upDjVkdPe9QM"
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        David Airlie <airlied@linux.ie>
To: Logan Gunthorpe <logang@deltatee.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-ntb@googlegroups.com>, <linux-crypto@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170803183018.5889-2-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--Spb6H6ES3NmNPePXmfAm7upDjVkdPe9QM
Content-Type: multipart/mixed; boundary="LEoF2bXkUPPNRk16ANmfpjIOMtEqioS6n";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-ntb@googlegroups.com,
 linux-crypto@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andy Shevchenko <andy.shevchenko@gmail.com>,
 =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
 Stephen Bates <sbates@raithlin.com>, David Airlie <airlied@linux.ie>
Message-ID: <2b41b02c-07e3-b927-f276-a29480f94285@ti.com>
Subject: Re: [PATCH v6 1/7] drm/tilcdc: ensure nonatomic iowrite64 is not used
References: <20170803183018.5889-1-logang@deltatee.com>
 <20170803183018.5889-2-logang@deltatee.com>
In-Reply-To: <20170803183018.5889-2-logang@deltatee.com>

--LEoF2bXkUPPNRk16ANmfpjIOMtEqioS6n
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 03/08/17 21:30, Logan Gunthorpe wrote:
> Add a check to ensure iowrite64 is only used if it is atomic.
>=20
> It was decided in [1] that the tilcdc driver should not be using an
> atomic operation (so it was left out of this patchset). However, it tur=
ns
> out that through the drm code, a nonatomic header is actually included:=

>=20
> include/linux/io-64-nonatomic-lo-hi.h
> is included from include/drm/drm_os_linux.h:9:0,
>             from include/drm/drmP.h:74,
>             from include/drm/drm_modeset_helper.h:26,
>             from include/drm/drm_atomic_helper.h:33,
>             from drivers/gpu/drm/tilcdc/tilcdc_crtc.c:19:
>=20
> And thus, without this change, this patchset would inadvertantly
> change the behaviour of the tilcdc driver.

I haven't really followed the discussion on this, but if the tilcdc's
use of iowrite64 causes (real) problems/complications elsewhere, I think
we could drop it.

The problem is that the HW has a race issue, and the two registers in
question should be written as close to each other as possible. We
thought a single 64bit write, writing to both registers in one go, would
improve that slightly, compared to two 32 bit writes.

Jyri, correct me if I'm wrong, but we have no proof that it actually
helps, and it might be that even if it helps, the difference is
theoretical. Probably if we ensure the irqs are off when we do two 32
bit writes, we're already close enough to the optimal case.

 Tomi


--LEoF2bXkUPPNRk16ANmfpjIOMtEqioS6n--

--Spb6H6ES3NmNPePXmfAm7upDjVkdPe9QM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZhHCQAAoJEPo9qoy8lh71MkwQAJ4dK01uGso+/a5bUI3W7cmo
CXaseZacKsbVQ83FX5jWmF8u7voIDQ1mID6JQZr9WHnunHP6C1W5s+6Q7TYFGKAn
5JcK/TcpKpmQb8Pz7XiTXNKRcwvm2prXNho2w/QhZn8CQrpA4WA5ROGVENLT5H4l
5N5ioMylGvaEVKIib83DvVMFbLRqonsn2QedvovsehzY93GftslNjaPs8Up8N3od
Gbe/t0jwReAshW5eUDJ80OHa1WjDUHsEZcAh7IpaDyvNVid7lXATQlw8twUp0BDr
ijWUhVwVbcUqzyfMat1IcfYVDozPuFoEbXpGaFijXYMMNLE2ebMMib1JBDkIW6VK
W83Ij4DQGY0ZiP47xdgsDBxol5G58+RKsbITJKGQ5FYlQI2E4X1A/bAOCcyhrO6W
l1zGz60j0E9EsswRiiFgl1656aAYtyQArj8O8156w5WLATG/FsVFvif8wG40xaMP
yDD2zvndtIMFlkn9wNjM9DStudueReRwS2w3J30wymMfO/w6jq3B2x4Gd+UUKJ4T
6UJ2AAByqwz9U3O61UVsKgBEciNGOq3RclbQX/gUhnOBbCRB0L8mH2GfYH8gwHJJ
7UpUSje2AUg/LC1/j+NKNQX/ZAvXQZ/Zj+NGEPIhPBS1LGnVkJ8d9oPjvWEFn/Sh
OUwYWpboyOXN3zOy88Jl
=U21y
-----END PGP SIGNATURE-----

--Spb6H6ES3NmNPePXmfAm7upDjVkdPe9QM--
