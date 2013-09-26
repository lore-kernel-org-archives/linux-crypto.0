From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V4 02/15] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
Date: Thu, 26 Sep 2013 15:08:30 +0800
Message-ID: <1380179310.32302.58.camel@linux-s257.site>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <1379206621-18639-3-git-send-email-jlee@suse.com>
	 <20130923164931.GD6772@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,  linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,  linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <mjg59-qBa9aAk2fb8@public.gmane.org>
To: Phil Carmody <phil.carmody-GrGkmOP51GdLN7c7dRTbYkEOCMrvLtNR@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5142-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20130923164931.GD6772-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

Hi Phil,=20

First! Thanks for your time to review my patch!

=E6=96=BC =E4=B8=80=EF=BC=8C2013-09-23 =E6=96=BC 19:49 +0300=EF=BC=8CPhil=
 Carmody =E6=8F=90=E5=88=B0=EF=BC=9A
> On Sun, Sep 15, 2013 at 08:56:48AM +0800, Lee, Chun-Yi wrote:
> > Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
> > first step of signature generation operation (RSASSA-PKCS1-v1_5-SIGN)=
.
> >=20
> > This patch is temporary set emLen to pks->k, and temporary set EM to
> > pks->S for debugging. We will replace the above values to real signat=
ure
> > after implement RSASP1.
> >=20
> > The naming of EMSA_PKCS1_v1_5_ENCODE and the variables used in this f=
unction
> > accord PKCS#1 spec but not follow kernel naming convention, it useful=
 when look
> > at them with spec.
> >=20
> > Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffinal=
.txt
> > Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1v2=
-2-rsa-cryptography-standard-wp.pdf
> >=20
> > V2:
>=20
> You're now at V4.

The V4 is for whole patchset, I didn't do any modify in this patch in
this version.
The version define maybe confuse between separate and whole patchset, I
will avoid it.

>=20
> > - Clean up naming of variable: replace _EM by EM, replace EM by EM_tm=
p.
> > - Add comment to EMSA_PKCS1-v1_5-ENCODE function.
> >=20
> > Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
> > Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  crypto/asymmetric_keys/rsa.c |  163 ++++++++++++++++++++++++++++++++=
+++++++++-
> >  include/crypto/public_key.h  |    2 +
> >  2 files changed, 164 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rs=
a.c
> > index 47f3be4..352ba45 100644
> > --- a/crypto/asymmetric_keys/rsa.c
> > +++ b/crypto/asymmetric_keys/rsa.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> >  #include <linux/slab.h>
> > +#include <crypto/hash.h>
> >  #include "public_key.h"
> >  #include "private_key.h"
> > =20
> > @@ -152,6 +153,132 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_=
X)
> >  }
> > =20
> >  /*
> > + * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
> > + * @M: message to be signed, an octet string
> > + * @emLen: intended length in octets of the encoded message
> > + * @hash_algo: hash function (option)
> > + * @hash: true means hash M, otherwise M is already a digest
> > + * @EM: encoded message, an octet string of length emLen
> > + *
> > + * This function is a implementation of the EMSA-PKCS1-v1_5 encoding=
 operation
> > + * in RSA PKCS#1 spec. It used by the signautre generation operation=
 of
> > + * RSASSA-PKCS1-v1_5 to encode message M to encoded message EM.
> > + *
> > + * The variables used in this function accord PKCS#1 spec but not fo=
llow kernel
> > + * naming convention, it useful when look at them with spec.
> > + */
> > +static int EMSA_PKCS1_v1_5_ENCODE(const u8 *M, size_t emLen,
> > +		enum pkey_hash_algo hash_algo, const bool hash,
> > +		u8 **EM, struct public_key_signature *pks)
> > +{
> > +	u8 *digest;
> > +	struct crypto_shash *tfm;
> > +	struct shash_desc *desc;
> > +	size_t digest_size, desc_size;
> > +	size_t tLen;
> > +	u8 *T, *PS, *EM_tmp;
> > +	int i, ret;
> > +
> > +	pr_info("EMSA_PKCS1_v1_5_ENCODE start\n");
> > +
> > +	if (!RSA_ASN1_templates[hash_algo].data)
> > +		ret =3D -ENOTSUPP;
>=20
> ...
>=20
> > +	else
> > +		pks->pkey_hash_algo =3D hash_algo;
> > +
> > +	/* 1) Apply the hash function to the message M to produce a hash va=
lue H */
> > +	tfm =3D crypto_alloc_shash(pkey_hash_algo[hash_algo], 0, 0);
> > +	if (IS_ERR(tfm))
> > +		return (PTR_ERR(tfm) =3D=3D -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
> > +
> > +	desc_size =3D crypto_shash_descsize(tfm) + sizeof(*desc);
> > +	digest_size =3D crypto_shash_digestsize(tfm);
> > +
> > +	ret =3D -ENOMEM;
>=20
> The earlier "ret =3D -ENOTSUPP;" is either unused because you return at=
 the IS_ERR,
> or unused because you overwrite it here. I'm a little disappointed that
> the compiler didn't recognise that something was assigned to a value th=
at=20
> is never used.
>=20
> Phil

Yes, Dmitry also pointed out this issue, I should not go on the hash
process if the hash algorithm didn't support.

I will change fix this problem in next version.=20


Thanks a lot!
Joey Lee

--=20
To unsubscribe, e-mail: opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org
To contact the owner, e-mail: opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org
