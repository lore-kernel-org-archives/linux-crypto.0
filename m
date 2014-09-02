From: John Johansen <john.johansen@canonical.com>
Subject: Re: [PATCH RFC 5/6] apparmor: LLVMLinux: Remove VLAIS
Date: Tue, 02 Sep 2014 16:16:33 -0700
Message-ID: <54064FD1.6060900@canonical.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com> <1409697153-7006-6-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com,
	linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org, neilb@suse.de,
	serge@hallyn.com, torvalds@linux-foundation.org,
	=?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
	=?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
	Mark Charlebois <charlebm@gmail.com>
To: behanw@converseincode.com, agk@redhat.com, clm@fb.com,
	davem@davemloft.net, dm-devel@redhat.com, fabf@skynet.be,
	herbert@gondor.apana.org.au, jbacik@fb.com, snitzer@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409697153-7006-6-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/02/2014 03:32 PM, behanw@converseincode.com wrote:
> From: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>
>=20
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a =
C99
> compliant equivalent. This is the original VLAIS struct.
>=20
> struct {
> 	struct shash_desc shash;
> 	char ctx[crypto_shash_descsize(apparmor_tfm)];
> } desc;
>=20
> This patch instead allocates the appropriate amount of memory using a=
n
> char array.
>=20
> The new code can be compiled with both gcc and clang.
>=20
> struct shash_desc contains a flexible array member member ctx declare=
d with
> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginni=
ng
> of the array declared after struct shash_desc with long long.
>=20
> No trailing padding is required because it is not a struct type that =
can
> be used in an array.
>=20
> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with lon=
g long
> as would be the case for a struct containing a member with
> CRYPTO_MINALIGN_ATTR.
>=20
> Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>

I'm fine with this, do you want me to pull it into my tree for our next=
 push
or do you want this all to go together as a set?

Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/crypto.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>=20
> diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
> index 532471d..62b32e7 100644
> --- a/security/apparmor/crypto.c
> +++ b/security/apparmor/crypto.c
> @@ -32,10 +32,9 @@ unsigned int aa_hash_size(void)
>  int aa_calc_profile_hash(struct aa_profile *profile, u32 version, vo=
id *start,
>  			 size_t len)
>  {
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(apparmor_tfm)];
> -	} desc;
> +	char desc[sizeof(struct shash_desc)
> +		+ crypto_shash_descsize(apparmor_tfm)] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *shash =3D (struct shash_desc *)desc;
>  	int error =3D -ENOMEM;
>  	u32 le32_version =3D cpu_to_le32(version);
> =20
> @@ -46,19 +45,19 @@ int aa_calc_profile_hash(struct aa_profile *profi=
le, u32 version, void *start,
>  	if (!profile->hash)
>  		goto fail;
> =20
> -	desc.shash.tfm =3D apparmor_tfm;
> -	desc.shash.flags =3D 0;
> +	shash->tfm =3D apparmor_tfm;
> +	shash->flags =3D 0;
> =20
> -	error =3D crypto_shash_init(&desc.shash);
> +	error =3D crypto_shash_init(shash);
>  	if (error)
>  		goto fail;
> -	error =3D crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4)=
;
> +	error =3D crypto_shash_update(shash, (u8 *) &le32_version, 4);
>  	if (error)
>  		goto fail;
> -	error =3D crypto_shash_update(&desc.shash, (u8 *) start, len);
> +	error =3D crypto_shash_update(shash, (u8 *) start, len);
>  	if (error)
>  		goto fail;
> -	error =3D crypto_shash_final(&desc.shash, profile->hash);
> +	error =3D crypto_shash_final(shash, profile->hash);
>  	if (error)
>  		goto fail;
> =20
>=20
