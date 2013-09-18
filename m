From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V4 02/15] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
Date: Wed, 18 Sep 2013 04:08:00 -0500
Message-ID: <1379495280.21947.311.camel__48632.0372125649$1379495268$gmane$org@linux-s257.site>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <1379206621-18639-3-git-send-email-jlee@suse.com>
	 <CACE9dm-7HKz4VFR1bNTTFd-YpYhnkNVwiW81iXSJZbqjUTBR_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACE9dm-7HKz4VFR1bNTTFd-YpYhnkNVwiW81iXSJZbqjUTBR_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Dmitry,=20

=46irst, thanks for your time to review my patches!

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-09-17 =E6=96=BC 16:51 -0500=EF=BC=8CDm=
itry Kasatkin =E6=8F=90=E5=88=B0=EF=BC=9A
> Hello,
>=20
>=20
> On Sat, Sep 14, 2013 at 7:56 PM, Lee, Chun-Yi <joeyli.kernel-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> > Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's t=
he
> > first step of signature generation operation (RSASSA-PKCS1-v1_5-SIG=
N).
> >
> > This patch is temporary set emLen to pks->k, and temporary set EM t=
o
> > pks->S for debugging. We will replace the above values to real sign=
ature
> > after implement RSASP1.
> >
> > The naming of EMSA_PKCS1_v1_5_ENCODE and the variables used in this=
 function
> > accord PKCS#1 spec but not follow kernel naming convention, it usef=
ul when look
> > at them with spec.
> >
> > Reference: ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-1v2/pkcs1ietffin=
al.txt
> > Reference: http://www.emc.com/collateral/white-papers/h11300-pkcs-1=
v2-2-rsa-cryptography-standard-wp.pdf
> >
> > V2:
> > - Clean up naming of variable: replace _EM by EM, replace EM by EM_=
tmp.
> > - Add comment to EMSA_PKCS1-v1_5-ENCODE function.
> >
> > Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
> > Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  crypto/asymmetric_keys/rsa.c |  163 ++++++++++++++++++++++++++++++=
+++++++++++-
> >  include/crypto/public_key.h  |    2 +
> >  2 files changed, 164 insertions(+), 1 deletions(-)
> >
> > diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/=
rsa.c
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
> >
> > @@ -152,6 +153,132 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 *=
*_X)
> >  }
> >
> >  /*
> > + * EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2]
> > + * @M: message to be signed, an octet string
> > + * @emLen: intended length in octets of the encoded message
> > + * @hash_algo: hash function (option)
> > + * @hash: true means hash M, otherwise M is already a digest
> > + * @EM: encoded message, an octet string of length emLen
> > + *
> > + * This function is a implementation of the EMSA-PKCS1-v1_5 encodi=
ng operation
> > + * in RSA PKCS#1 spec. It used by the signautre generation operati=
on of
> > + * RSASSA-PKCS1-v1_5 to encode message M to encoded message EM.
> > + *
> > + * The variables used in this function accord PKCS#1 spec but not =
follow kernel
> > + * naming convention, it useful when look at them with spec.
> > + */
> > +static int EMSA_PKCS1_v1_5_ENCODE(const u8 *M, size_t emLen,
> > +               enum pkey_hash_algo hash_algo, const bool hash,
> > +               u8 **EM, struct public_key_signature *pks)
> > +{
> > +       u8 *digest;
> > +       struct crypto_shash *tfm;
> > +       struct shash_desc *desc;
> > +       size_t digest_size, desc_size;
> > +       size_t tLen;
> > +       u8 *T, *PS, *EM_tmp;
> > +       int i, ret;
> > +
> > +       pr_info("EMSA_PKCS1_v1_5_ENCODE start\n");
> > +
> > +       if (!RSA_ASN1_templates[hash_algo].data)
>=20
> What about checking hash_algo against PKEY_HASH__LAST, or it relies o=
n
> the caller?
>=20

Yes, check PKEY_HASH__LAST is more easy and clear, I will change it.
Thanks!

>=20
> > +               ret =3D -ENOTSUPP;
> > +       else
> > +               pks->pkey_hash_algo =3D hash_algo;
> > +
> > +       /* 1) Apply the hash function to the message M to produce a=
 hash value H */
> > +       tfm =3D crypto_alloc_shash(pkey_hash_algo[hash_algo], 0, 0)=
;
> > +       if (IS_ERR(tfm))
> > +               return (PTR_ERR(tfm) =3D=3D -ENOENT) ? -ENOPKG : PT=
R_ERR(tfm);
> > +
> > +       desc_size =3D crypto_shash_descsize(tfm) + sizeof(*desc);
> > +       digest_size =3D crypto_shash_digestsize(tfm);
> > +
> > +       ret =3D -ENOMEM;
> > +
> > +       digest =3D kzalloc(digest_size + desc_size, GFP_KERNEL);
> > +       if (!digest)
> > +               goto error_digest;
> > +       pks->digest =3D digest;
> > +       pks->digest_size =3D digest_size;
> > +
>=20
> Ok. You allocated tfm to get hash size, right?
>=20
> But why do you allocate descriptor even it might not be needed?
>=20

You are right, I should skip the code of allocate descriptor when the
hash is supported. I will modified it.
Thanks!

> > +       if (hash) {
> > +               desc =3D (void *) digest + digest_size;
> > +               desc->tfm =3D tfm;
> > +               desc->flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
> > +
> > +               ret =3D crypto_shash_init(desc);
> > +               if (ret < 0)
> > +                       goto error_shash;
> > +               ret =3D crypto_shash_finup(desc, M, sizeof(M), pks-=
>digest);
>=20
> This is I completely fail to understand... You expect sizeof(M) to be
> the message length?????
> Have you ever tested it?
>=20

Sigh!
I just checked my test program for this code path, this stupid problem
causes by my test program doesn't feed the right hash result that shoul=
d
used to verify signature. So, I didn't capture this bug.

And, the hibernate signature check mechanism doesn't run into this code
path because the hash generation is done by hibernate code but not in
here. So, I also didn't find this problem when running hibernate check.

Appreciate for your point out! I just fix it in next patch version.

> > +               if (ret < 0)
> > +                       goto error_shash;
> > +       } else {
> > +               memcpy(pks->digest, M, pks->digest_size);
> > +               pks->digest_size =3D digest_size;
> > +       }
>=20
> Does caller use pks->digest and pks->digest_size after return?
> I think it needs encoded value, not the hash...
> So why do you pass pks?
>=20

I put the signature MPI to pks->rsa.s, and put the encoded signature to
pks->S. So caller can grab encoded signature.

I also pass the pks->digest and pks->digest_size to caller for
reference. Then caller can simply feed this pks to
RSA_verify_signature() for verify the signature result, don't need
generate hash again.

>=20
>=20
> > +       crypto_free_shash(tfm);
> > +
> > +       /* 2) Encode the algorithm ID for the hash function and the=
 hash value into
> > +        * an ASN.1 value of type DigestInfo with the DER. Let T be=
 the DER encoding of
> > +        * the DigestInfo value and let tLen be the length in octet=
s of T.
> > +        */
> > +       tLen =3D RSA_ASN1_templates[hash_algo].size + pks->digest_s=
ize;
> > +       T =3D kmalloc(tLen, GFP_KERNEL);
> > +       if (!T)
> > +               goto error_T;
> > +
>=20
> Why do you need T and PS memory allocations at all?
> You need only EM_tmp allocation and copy directly to the destination.=
=2E.
>=20

OK, I will change the code to allocate T and PS size in EM_tmp.

>=20
> > +       memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_temp=
lates[hash_algo].size);
> > +       memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest,=
 pks->digest_size);
> > +
> > +       /* 3) check If emLen < tLen + 11, output "intended encoded =
message length too short" */
> > +       if (emLen < tLen + 11) {
> > +               ret =3D -EINVAL;
> > +               goto error_emLen;
> > +       }
> > +
> > +       /* 4) Generate an octet string PS consisting of emLen - tLe=
n - 3 octets with 0xff. */
> > +       PS =3D kmalloc(emLen - tLen - 3, GFP_KERNEL);
> > +       if (!PS)
> > +               goto error_P;
> > +
>=20
> ditto

OK, I will allocate PS with EM_tmp.
Thanks!

>=20
> > +       for (i =3D 0; i < (emLen - tLen - 3); i++)
> > +               PS[i] =3D 0xff;
> > +
> > +       /* 5) Concatenate PS, the DER encoding T, and other padding=
 to form the encoded
> > +        * message EM as EM =3D 0x00 || 0x01 || PS || 0x00 || T
> > +        */
> > +       EM_tmp =3D kmalloc(3 + emLen - tLen - 3 + tLen, GFP_KERNEL)=
;
> > +       if (!EM_tmp)
> > +               goto error_EM;
> > +
> > +       EM_tmp[0] =3D 0x00;
> > +       EM_tmp[1] =3D 0x01;
> > +       memcpy(EM_tmp + 2, PS, emLen - tLen - 3);
> > +       EM_tmp[2 + emLen - tLen - 3] =3D 0x00;
> > +       memcpy(EM_tmp + 2 + emLen - tLen - 3 + 1, T, tLen);
> > +
> > +       *EM =3D EM_tmp;
> > +
> > +       kfree(PS);
> > +       kfree(T);
>=20
> get rid of it...
>=20

OK!

>=20
> - Dmitry
>=20
> > +
> > +       return 0;
> > +
> > +error_EM:
> > +       kfree(PS);
> > +error_P:
> > +error_emLen:
> > +       kfree(T);
> > +error_T:
> > +error_shash:
> > +       kfree(digest);
> > +error_digest:
> > +       crypto_free_shash(tfm);
> > +       return ret;
> > +}
> > +
> > +/*
> >   * Perform the RSA signature verification.
> >   * @H: Value of hash of data and metadata
> >   * @EM: The computed signature value
> > @@ -275,9 +402,43 @@ static struct public_key_signature *RSA_genera=
te_signature(
> >                 const struct private_key *key, u8 *M,
> >                 enum pkey_hash_algo hash_algo, const bool hash)
> >  {
> > +       struct public_key_signature *pks;
> > +       u8 *EM =3D NULL;
> > +       size_t emLen;
> > +       int ret;
> > +
> >         pr_info("RSA_generate_signature start\n");
> >
> > -       return 0;
> > +       ret =3D -ENOMEM;
> > +       pks =3D kzalloc(sizeof(*pks), GFP_KERNEL);
> > +       if (!pks)
> > +               goto error_no_pks;
> > +
> > +       /* 1): EMSA-PKCS1-v1_5 encoding: */
> > +       /* Use the private key modulus size to be EM length */
> > +       emLen =3D mpi_get_nbits(key->rsa.n);
> > +       emLen =3D (emLen + 7) / 8;
> > +
> > +       ret =3D EMSA_PKCS1_v1_5_ENCODE(M, emLen, hash_algo, hash, &=
EM, pks);
> > +       if (ret < 0)
> > +               goto error_v1_5_encode;
> > +
> > +       /* TODO 2): m =3D OS2IP (EM) */
> > +
> > +       /* TODO 3): s =3D RSASP1 (K, m) */
> > +
> > +       /* TODO 4): S =3D I2OSP (s, k) */
> > +
> > +       /* TODO: signature S to a u8* S or set to sig->rsa.s? */
> > +       pks->S =3D EM;            /* TODO: temporary set S to EM */
> > +
> > +       return pks;
> > +
> > +error_v1_5_encode:
> > +       kfree(pks);
> > +error_no_pks:
> > +       pr_info("<=3D=3D%s() =3D %d\n", __func__, ret);
> > +       return ERR_PTR(ret);
> >  }
> >
> >  const struct public_key_algorithm RSA_public_key_algorithm =3D {
> > diff --git a/include/crypto/public_key.h b/include/crypto/public_ke=
y.h
> > index d44b29f..1cdf457 100644
> > --- a/include/crypto/public_key.h
> > +++ b/include/crypto/public_key.h
> > @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
> >  struct public_key_signature {
> >         u8 *digest;
> >         u8 digest_size;                 /* Number of bytes in diges=
t */
> > +       u8 *S;                          /* signature S of length k =
octets */
> > +       size_t k;                       /* length k of signature S =
*/
> >         u8 nr_mpi;                      /* Occupancy of mpi[] */
> >         enum pkey_hash_algo pkey_hash_algo : 8;
> >         union {
> > --
> > 1.6.0.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cry=
pto" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20

Thanks a lot!
Joey Lee
