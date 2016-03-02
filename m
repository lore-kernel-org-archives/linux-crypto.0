From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 2 Mar 2016 09:53:51 +0000
Message-ID: <20160302095351.GB2384@sbenedet-virtual-machine>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
 <2214574.VuIVa0pDBJ@positron.chronox.de>
 <20160301110834.GA2383@sbenedet-virtual-machine>
 <4569151.ySIvlNFRgX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:23174 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbcCBJxx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 04:53:53 -0500
Content-Disposition: inline
In-Reply-To: <4569151.ySIvlNFRgX@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 01, 2016 at 12:17:15PM +0100, Stephan Mueller wrote:

Hi Stephan,

> Am Dienstag, 1. M=E4rz 2016, 11:08:34 schrieb Salvatore Benedetto:
>=20
> Hi Salvatore,
>=20
> > > > +static int dh_check_params_length(unsigned int p_len)
> > > > +{
> > > > +	switch (p_len) {
> > > > +	case 768:
> > > > +	case 1024:
> > > > +	case 1536:
> > > > +	case 2048:
> > > > +	case 3072:
> > > > +	case 4096:
> > > > +		return 0;
> > > > +	}
> > > > +	return -EINVAL;
> > > > +}
> > >=20
> > > What is the reason for restricting the size to 4096?
> >=20
> > Honestly no reason.
> > Could not find restrictions in the spec about the params length.
>=20
> I am just wondering because other DH impls allow longer sizes.
>=20
> And besides, I would like to disallow all < 2048 right from the start=
=2E
>

Hmm.. What range would you suggest?

I just thought that having the same range we support with RSA would be =
OK for now.

> > > > +
> > > > +static int dh_no_op(struct akcipher_request *req)
> > > > +{
> > > > +	return -ENOPROTOOPT;
> > > > +}
> > > > +
> > > > +static int dh_set_priv_key(struct crypto_akcipher *tfm, const =
void
> > > > *key,
> > > > +			   unsigned int keylen)
> > > > +{
> > > > +	struct dh_params *params =3D akcipher_tfm_ctx(tfm);
> > >=20
> > > dh_get_params?
> >=20
> > You mean adding a helper function? OK.
>=20
> Not adding, but using your helper function -- why do you have it ther=
e in the=20
> first place? :-)
>

True. I actually use it in dh_generate_public_key and
dh_compute_shared_secret. I'll fix that, thanks.

Regards,
Salvatore
