From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Tue, 01 Mar 2016 12:17:15 +0100
Message-ID: <4569151.ySIvlNFRgX@positron.chronox.de>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com> <2214574.VuIVa0pDBJ@positron.chronox.de> <20160301110834.GA2383@sbenedet-virtual-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60442 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbcCALRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 06:17:19 -0500
In-Reply-To: <20160301110834.GA2383@sbenedet-virtual-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 1. M=E4rz 2016, 11:08:34 schrieb Salvatore Benedetto:

Hi Salvatore,

> > > +static int dh_check_params_length(unsigned int p_len)
> > > +{
> > > +	switch (p_len) {
> > > +	case 768:
> > > +	case 1024:
> > > +	case 1536:
> > > +	case 2048:
> > > +	case 3072:
> > > +	case 4096:
> > > +		return 0;
> > > +	}
> > > +	return -EINVAL;
> > > +}
> >=20
> > What is the reason for restricting the size to 4096?
>=20
> Honestly no reason.
> Could not find restrictions in the spec about the params length.

I am just wondering because other DH impls allow longer sizes.

And besides, I would like to disallow all < 2048 right from the start.
>=20
> > > +
> > > +static int dh_no_op(struct akcipher_request *req)
> > > +{
> > > +	return -ENOPROTOOPT;
> > > +}
> > > +
> > > +static int dh_set_priv_key(struct crypto_akcipher *tfm, const vo=
id
> > > *key,
> > > +			   unsigned int keylen)
> > > +{
> > > +	struct dh_params *params =3D akcipher_tfm_ctx(tfm);
> >=20
> > dh_get_params?
>=20
> You mean adding a helper function? OK.

Not adding, but using your helper function -- why do you have it there =
in the=20
first place? :-)

Ciao
Stephan
