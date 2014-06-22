From: Marek Vasut <marex-ynQEQJNshbs@public.gmane.org>
Subject: Re: [PATCH v3 2/4] crypto: Update makefile and Kconfig
 for Security System
Date: Sun, 22 Jun 2014 14:25:36 +0200
Message-ID: <201406221425.36171.marex@denx.de>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <201406142101.30546.marex@denx.de> <53A6C4EE.2020400@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 pawel.moll-5wv7dgnIgG8@public.gmane.org,
 mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
 linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBDIOBYPK6QDRBQMWTOOQKGQEYFGJRAQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <53A6C4EE.2020400-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Sunday, June 22, 2014 at 01:58:38 PM, Corentin LABBE wrote:
> Le 14/06/2014 21:01, Marek Vasut a =E9crit :
> > On Tuesday, June 10, 2014 at 02:43:15 PM, LABBE Corentin wrote:
> >> Add necessary changes for configuring and compiling the Security Syste=
m
> >> driver.
> >>=20
> >> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>=20
> >>  drivers/crypto/Kconfig  | 91
> >>=20
> >> +++++++++++++++++++++++++++++++++++++++++++++++++
> >> drivers/crypto/Makefile
> >>=20
> >> |  1 +
> >> =20
> >>  2 files changed, 92 insertions(+)
> >=20
> > This should be part of 1/4, otherwise 1/4 just adds dead code.
>=20
> If I do that 1/4 add to the makefile a path that do not exists.
>=20
> But as you like I will change that.

Well, the point is to add stuff which is logically coupled together (code,=
=20
Makefile entry, Kconfig entry) in a single patch if possible.

Best regards,
Marek Vasut

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
