From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Wed, 14 Jan 2009 16:01:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <20090114031613.GA7429@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35910 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751114AbZANPBg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 10:01:36 -0500
In-Reply-To: <20090114031613.GA7429@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Hi Herbert,

On Wed, 14 Jan 2009, Herbert Xu wrote:
> On Tue, Jan 13, 2009 at 04:59:40PM +0100, Geert Uytterhoeven wrote:
> > The current "comp" crypto interface supports one-shot (de)compressi=
on only,
> > i.e. the whole data buffer to be (de)compressed must be passed at o=
nce, and
> > the whole (de)compressed data buffer will be received at once.
> > In several use-cases (e.g. compressed file systems that store files=
 in big
> > compressed blocks), this workflow is not suitable.
> > Furthermore, the "comp" type doesn't provide for the configuration =
of
> > (de)compression parameters, and always allocates workspace memory f=
or both
> > compression and decompression, which may waste memory.
>=20
> Thanks for the patch-set!
>=20
> > diff --git a/crypto/pcompress.c b/crypto/pcompress.c
> > new file mode 100644
> > index 0000000..b9e3724
> > --- /dev/null
> > +++ b/crypto/pcompress.c
> > @@ -0,0 +1,94 @@
> > +/*
> > + * Cryptographic API.
> > + *
> > + * Partial compression operations.
> > + *
> > + * Copyright 2008 Sony Corporation
> > + *
> > + * This program is free software; you can redistribute it and/or m=
odify
> > + * it under the terms of the GNU General Public License as publish=
ed by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public Licen=
se
> > + * along with this program; if not, write to the Free Software Fou=
ndation,
> > + * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, U=
SA
> > + */
> > +
> > +#define pr_fmt(fmt)	"%s: " fmt, __func__
>=20
> This appears to be unused?

It's used by the pr_*() macros in <linux/kernel.h>.

Since commit d091c2f58ba32029495a933b721e8e02fbd12caa ("Add 'pr_fmt()' =
format
modifier to pr_xyz macros."), this is the new way to have a common pref=
ix in
all printed output.

> > +static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm,
> > +				 const struct crypto_type *frontend)
> > +{
> > +	if (frontend->type !=3D CRYPTO_ALG_TYPE_PCOMPRESS)
> > +		return -EINVAL;
>=20
> This is my fault.  The check is redundant so you can remove it.
> I'll kill it in shash too.

Ok, removed.

> > +struct pcomp_alg {
> > +	int (*setup)(struct crypto_tfm *tfm, const void *params);
>=20
> Actually I was thinking of separate alloc functions for compress
> and decompress so that

=46or compatibility with crypto_comp, we also need an alloc function fo=
r both
compress and decompress, so that makes 3 alloc functions.

That would also solve the issue where there's hardware support for e.g.
decompression, but not for compression.

> 1) We know what the user wants to do without every algorithm
> reinventing their own signalling for it;

I guess you want to use the flags to indicate compress/decompress/both?
Unfortunately I'm still struggling to fully understand the type/mask ha=
ndling,
so I would appreciate it if you could give me a hint how to handle that=
=2E

> 2) The parameters can be separated.

OK.

> Also, this is something that we'll potentially export to user-space,
> so we need to ensure that it is invariant to word length.
>=20
> So something like this would be good
>=20
> 	int (*setup_comp)(struct crypto_pcomp *tfm, const void *params,
> 			  unsigned int length);
> 	int (*setup_decomp)(struct crypto_pcomp *tfm, const void *params,
> 			    unsigned int length);

I assume "length" is the size of the passed params, so the algorithms c=
an
return -EINVAL if they're passed the wrong size?

> The actual parameters should be formatted using the netlink helpers
> (nla_*).  So each parameter that you want to set should show up as
> a netlink attribute.  If a paramter is absent then you'd just use
> the default, etc.

I'll look into the netlink formatting...

> > +	int (*compress_init)(struct crypto_tfm *tfm);
>=20
> That should be struct crypto_pcomp.

OK, I updated all pcomp_alg operations to take crypto_pcomp pointers in=
stead of
crypto_tfm pointers.

> > +static inline struct crypto_pcomp *crypto_alloc_pcomp(const char *=
alg_name,
> > +						      u32 type, u32 mask)
> > +{
> > +	type &=3D ~CRYPTO_ALG_TYPE_MASK;
> > +	type |=3D CRYPTO_ALG_TYPE_PCOMPRESS;
> > +	mask |=3D CRYPTO_ALG_TYPE_MASK;
> > +
> > +	return __crypto_pcomp_cast(crypto_alloc_base(alg_name, type, mask=
));
> > +}
>=20
> That's the old way to allocate tfm's which won't work since pcomp
> is using the new type API.  You should do it the way that shash
> does it.

I tried to do this, but stumbled across a dependency problem: as
crypto_alloc_tfm() needs a pointer to crypto_pcomp_type(), crypto_alloc=
_pcomp()
can no longer be static inline, and must be moved to crypto/pcompress.c=
=2E

However, pcompress can be a module, while testmgr (which uses
crypto_alloc_pcomp()) seems to be always builtin.

Ah, CRYPTO_MANAGER2 has to select CRYPTO_PCOMP. OK.

Thanks for your review!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
