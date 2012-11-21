From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 4/5] ARM: OMAP: Move plat-omap/dma-omap.h to
 include/linux/omap-dma.h
Date: Wed, 21 Nov 2012 19:45:54 +0200
Message-ID: <20121121174554.GC13262@arwen.pp.htv.fi>
References: <20121121174201.25576.61961.stgit@muffinssi.local>
 <20121121174233.25576.58781.stgit@muffinssi.local>
Reply-To: balbi@ti.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3772240714778947941=="
Cc: linux-fbdev@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
 Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
 linux-mtd@lists.infradead.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Kevin Hilman <khilman@ti.com>, Russell King <linux@arm.linux.org.uk>,
 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
 Vinod Koul <vinod.koul@intel.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
 Tomi Valkeinen <tomi.valkeinen@ti.com>, Hans Verkuil <hans.verkuil@cisco.com>,
 linux-media@vger.kernel.org, Afzal Mohammed <afzal@ti.com>,
 Rusty Russell <rusty@rustcorp.com.au>,
 Mauro Carvalho Chehab <mchehab@infradead.org>, linux-omap@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Felipe Balbi <balbi@ti.com>, Guennadi Liakhovetski <g.liakhovets
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20121121174233.25576.58781.stgit@muffinssi.local>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

--===============3772240714778947941==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Content-Disposition: inline

--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 21, 2012 at 09:42:33AM -0800, Tony Lindgren wrote:
> Based on earlier discussions[1] we attempted to find a suitable
> location for the omap DMA header in commit 2b6c4e73 (ARM: OMAP:
> DMA: Move plat/dma.h to plat-omap/dma-omap.h) until the conversion
> to dmaengine is complete.
>=20
> Unfortunately that was before I was able to try to test compile
> of the ARM multiplatform builds for omap2+, and the end result
> was not very good.
>=20
> So I'm creating yet another all over the place patch to cut the
> last dependency for building omap2+ for ARM multiplatform. After
> this, we have finally removed the driver dependencies to the
> arch/arm code, except for few drivers that are being worked on.
>=20
> The other option was to make the <plat-omap/dma-omap.h> path
> to work, but we'd have to add some new header directory to for
> multiplatform builds.
>=20
> Or we would have to manually include arch/arm/plat-omap/include
> again from arch/arm/Makefile for omap2+.
>=20
> Neither of these alternatives sound appealing as they will
> likely lead addition of various other headers exposed to the
> drivers, which we want to avoid for the multiplatform kernels.
>=20
> Since we already have a minimal include/linux/omap-dma.h,
> let's just use that instead and add a note to it to not
> use the custom omap DMA functions any longer where possible.
>=20
> Note that converting omap DMA to dmaengine depends on
> dmaengine supporting automatically incrementing the FIFO
> address at the device end, and converting all the remaining
> legacy drivers. So it's going to be few more merge windows.
>=20
> [1] https://patchwork.kernel.org/patch/1519591/#
>=20
> cc: Russell King <linux@arm.linux.org.uk>
> cc: Kevin Hilman <khilman@ti.com>
> cc: "Beno=EEt Cousson" <b-cousson@ti.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Vinod Koul <vinod.koul@intel.com>
> cc: Dan Williams <djbw@fb.com>
> cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> cc: David Woodhouse <dwmw2@infradead.org>
> cc: Kyungmin Park <kyungmin.park@samsung.com>
> cc: Felipe Balbi <balbi@ti.com>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> cc: Hans Verkuil <hans.verkuil@cisco.com>
> cc: Vaibhav Hiremath <hvaibhav@ti.com>
> cc: Lokesh Vutla <lokeshvutla@ti.com>
> cc: Rusty Russell <rusty@rustcorp.com.au>
> cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> cc: Afzal Mohammed <afzal@ti.com>
> cc: linux-crypto@vger.kernel.org
> cc: linux-media@vger.kernel.org
> cc: linux-mtd@lists.infradead.org
> cc: linux-usb@vger.kernel.org
> cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>

=2E..

>  drivers/usb/gadget/omap_udc.c                      |    2=20
>  drivers/usb/musb/tusb6010_omap.c                   |    2=20

for omap_udc and musb:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrRNSAAoJEIaOsuA1yqRE+5gP/0880MUsBsYtdW3jT0VLytVA
P8rgqv7dOo3Z7yNw8CKIx/OnHTLOH3dRBCk10A2962718ZABaDP0hO46jgSX3n+t
DuF1JGQPSatwIuJwyPBmrq6nuOgl/hC1PcoMRy5ZMQG6i1NhMQZvkoJtWO5glu+X
WtBqFZlMe8vwc4fQF51s2IAYfZY3ylgvtOVviq7lGk4ec6KMNwBQAEoXdpO1SYlN
6hjXhXoLe3ejbmU4h2EphYdYzaoyQ0b6Hp3AJF/hupKm8eKgIv76YyI1OhELyHko
rlZZGQBXdEthj9cXEHgUdW4Bv7+GYmOSC1disQp9/eD/c5hS+khX06POVVVpTaXE
LgpQESD47HoOnhZN8SvtU2DkUlPa43RGCgXq3aUdWHpGDthoat89pwrcYj1eXByS
iGw33qfKTD0Cp8J8tLdG584i/gTNvp0SEmaBNU5zmHvFfP3ltzGAlJbFeJKIdQIq
rlKScahigB8Kn4ZJkcqPUsbKX9P/v9JFuSUq7o6nzFBP/xT5Ayq5a0/KUiIRlBIr
QAnoFRjedQSP5H92u26dhJ8k0XCdjVSSTGVCN8qyRXhsiBTSShFG7v5IG3R3mWGI
cA7+GkUfBXsU0uYNcPEY9Tcc3ugJM4Ti2Z54K1TWB4DkDmVJG1AvDs2CuOKzRXQO
iEsgS/epNF00zwH6+sOL
=7WD8
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--


--===============3772240714778947941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============3772240714778947941==--
