From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH 03/10] crypto: omap-sham: Add support for omap3 devices
Date: Mon, 18 May 2015 12:30:08 +0800
Message-ID: <20150518043008.GA13305@gondor.apana.org.au>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-4-git-send-email-pali.rohar@gmail.com>
 <20150228162502.GC4978@amd>
 <20150515091933.GA12078@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
	Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Paul Walmsley <paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Nishanth Menon <nm-l0cyMroinI0@public.gmane.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>,
	Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150515091933.GA12078@pali>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 15, 2015 at 11:19:33AM +0200, Pali Roh=E1r wrote:
> On Saturday 28 February 2015 17:25:02 Pavel Machek wrote:
> > On Thu 2015-02-26 14:49:53, Pali Roh=E1r wrote:
> > > omap3 support is same as omap2, just with different IO address (s=
pecified in DT)
> > >=20
> > > Signed-off-by: Pali Roh=E1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >=20
> > Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
> >=20
> > > @@ -1792,6 +1792,10 @@ static const struct of_device_id omap_sham=
_of_match[] =3D {
> > >  		.data		=3D &omap_sham_pdata_omap2,
> > >  	},
> > >  	{
> > > +		.compatible	=3D "ti,omap3-sham",
> > > +		.data		=3D &omap_sham_pdata_omap2,
> > > +	},
> > > +	{
> > >  		.compatible	=3D "ti,omap4-sham",
> > >  		.data		=3D &omap_sham_pdata_omap4,
> > >  	},
> >=20
>=20
> Herbert, this is second crypto patch in this series, can you apply it=
 too?

Applied.
--=20
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
