From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Fri, 31 Oct 2014 09:13:23 +0100
Message-ID: <20141031081323.GS21251@lukather>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="owPIoVL9FiqC4k42"
Cc: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org,
	mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRBB4KZWRAKGQEPAGPJDQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141031072030.GA7563-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org


--owPIoVL9FiqC4k42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 03:20:30PM +0800, Herbert Xu wrote:
> On Thu, Oct 30, 2014 at 06:19:33PM +0100, Maxime Ripard wrote:
> >
> > > With AF_ALG and cryptodev, the SG is in highmem. Verified with some
> > > PageHighMem().
> >=20
> > Then fix AF_ALG and cryptodev, because all of the other drivers might
> > be affected.
>=20
> No it's the driver that needs to be fixed.  Of course if there
> are enough drivers it may be worthwhile adding either copying or
> a software fallback for highmem requests.

I don't understand here. Why would other drivers *not* being affected?

If the scatter list passed by AF_ALG can be in highmem, I guess it's
the case for every driver out there. Almost every kernel code I've
seen so far makes the assumption that the memory it has is mapped and
accessible.

Somehow, it's the driver's fault now, and not the part of kernel that
actually does the allocation?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--owPIoVL9FiqC4k42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU0SjAAoJEBx+YmzsjxAgc0oP/Akx+HiU2vyi+QPmjZdlLPb0
o/iaSamNfISpdhFlFa6yYebY/r6g2IOhMkXuAB9h8SBHCLkgR8PnUw9P1F/Xj3rW
RlLAH9T8uC9ldl2paP2YOGzhQCDAkkxHJdmkakcyKu8CnQ2bfFOqtuayDl3otC3h
mq+kYiSB/i5bQsGG8gwMlys0TO61xFhvoElOVWr0IhuhQ3oAL8taCGvs5XHCxew+
Okfm/E1mJ1/3rfIZ5NyTQU8SrwRfppoS9FtK0D08dCpxez+d5313USyw26HwySRR
LYSSpMbFWfuz95ZbXE1hpZbbCW8fjYezzG6EzIfXScvWRC9NRTfHlBWqfgyfC5fg
zvW9XwshH0sx59uQ6q8c5nZNugPmqymbwhX6ARqk9EEbEUGUg0CbdAHegxaC+dt3
sq3xymGRl7lek/BD3R5Xoumc4JP9fSuyEzlaNlEMJ7BmpXe46+hv8/BCYx7dpbUT
oCdsLTw7Ob/8np28d1V6MTZ987gjnIhtzctWJqsnRBK0TnnF+Awe9JwnRqhO3VW8
H0CnLUVPbZO9dsLp6QiXSnXhKLS91B8cJj2deO1pChoajU89zU5KdO/9JYb4+7GU
qae9b587nHwaPJumAv/rtM185y3inqJphf9BmYFK/tHdhiWk61z89NC+zTfv1M6+
JNPb0/Mqbiy4KzzTyNR4
=NRk6
-----END PGP SIGNATURE-----

--owPIoVL9FiqC4k42--
