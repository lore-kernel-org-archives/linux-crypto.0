From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 02/10] crypto: rsa_helper - add raw integer parser actions
Date: Mon, 21 Mar 2016 20:14 +0100
Message-ID: <2101032.u08j97mEB2@tauon.atsec.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com> <3040533.U92nQRUNV9@tauon.atsec.com> <AM3PR04MB13004732D24525234255CB72B88F0@AM3PR04MB1300.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33312 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342AbcCUTXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 15:23:03 -0400
In-Reply-To: <AM3PR04MB13004732D24525234255CB72B88F0@AM3PR04MB1300.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 21. M=E4rz 2016, 15:17:20 schrieb Tudor-Dan Ambarus:

Hi Tudor,

> Hi Stephan,
>=20
> > -----Original Message-----
> > From: Stephan Mueller [mailto:smueller@chronox.de]
> > Sent: Friday, March 18, 2016 9:47 PM
> > To: Tudor-Dan Ambarus
> > Cc: herbert@gondor.apana.org.au; tadeusz.struk@intel.com; linux-
> > crypto@vger.kernel.org; Horia Ioan Geanta Neag
> > Subject: Re: [PATCH 02/10] crypto: rsa_helper - add raw integer par=
ser
> > actions
> >=20
> > > +int rsa_check_key_length(unsigned int len)
> > > +{
> > > +	switch (len) {
> > > +	case 512:
> > > +	case 1024:
> > > +	case 1536:
> > > +	case 2048:
> > > +	case 3072:
> > > +	case 4096:
> > > +		return 0;
> > > +	}
> >=20
> > I know that you copied the code to a new location that was there al=
ready.
> > But
> > based on the discussion we had for DH, does it make sense that the =
kernel
> > adds
> > such (artificial) limits?
>=20
> [ta] This is not within the scope of this patch set, but we can remov=
e the
> restrictions in a subsequent patch. Marcel has suggested to not impos=
e
> limits on the minimum length of the key. What about the maximum?

Why any restrictions at all? There is no mathematical reason. There is =
only a=20
technical reason which depends on the implementation.

I am not sure how large the keys can be for the software fallback. But =
maybe=20
it would make sense to have a general cap like 32k where the software f=
allback=20
can handle all key sizes up to that point.

> > > +
> > > +	return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(rsa_check_key_length);
> > > +
> > > +int raw_rsa_get_n(void *context, size_t hdrlen, unsigned char ta=
g,
> > > +		  const void *value, size_t vlen)
> > > +{
> > > +	struct rsa_raw_ctx *ctx =3D context;
> > > +	struct rsa_raw_key *key =3D &ctx->key;
> > > +	const char *ptr =3D value;
> > > +	int ret =3D -EINVAL;
> > > +
> > > +	while (!*ptr && vlen) {
> > > +		ptr++;
> > > +		vlen--;
> > > +	}
> > > +
> > > +	key->n_sz =3D vlen;
> > > +	/* In FIPS mode only allow key size 2K & 3K */
> > > +	if (fips_enabled && (key->n_sz !=3D 256 && key->n_sz !=3D 384))=
 {
> >=20
> > Again, you copied that code that used to be there . But very very
> > recently,
> > NIST allowed 4k keys too. May I ask to allow it here?
>=20
> I suggest to do this in a separate patch. Can you send us a pointer t=
o the
> NIST specification?

Sure, just let us not forget about it.
>=20
> Thank you,
> ta


Ciao
Stephan
