From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 03/10] crypto: omap-sham: Add support for omap3 devices
Date: Fri, 15 May 2015 11:19:33 +0200
Message-ID: <20150515091933.GA12078@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-4-git-send-email-pali.rohar@gmail.com>
 <20150228162502.GC4978@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150228162502.GC4978@amd>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Saturday 28 February 2015 17:25:02 Pavel Machek wrote:
> On Thu 2015-02-26 14:49:53, Pali Roh=C3=A1r wrote:
> > omap3 support is same as omap2, just with different IO address (spe=
cified in DT)
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Acked-by: Pavel Machek <pavel@ucw.cz>
>=20
> > @@ -1792,6 +1792,10 @@ static const struct of_device_id omap_sham_o=
f_match[] =3D {
> >  		.data		=3D &omap_sham_pdata_omap2,
> >  	},
> >  	{
> > +		.compatible	=3D "ti,omap3-sham",
> > +		.data		=3D &omap_sham_pdata_omap2,
> > +	},
> > +	{
> >  		.compatible	=3D "ti,omap4-sham",
> >  		.data		=3D &omap_sham_pdata_omap4,
> >  	},
>=20

Herbert, this is second crypto patch in this series, can you apply it t=
oo?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
