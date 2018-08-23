From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH v2] crypto: vmx - Fix sleep-in-atomic bugs
Date: Wed, 22 Aug 2018 21:04:46 -0300
Message-ID: <20180823000446.GA26297@gallifrey>
References: <CAAUqJDt_y04ts7Aq0U0fhXYRus2ckkEohBTkga0pjqfoQaBOCA@mail.gmail.com>
 <20180822062631.5664-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Leonidas S . Barbosa" <leo.barbosa@canonical.com>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180822062631.5664-1-omosnace@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

That looks good to me. Maybe Paulo can help testing it.

--=20
Regards,
Marcelo

On Wed, Aug 22, 2018 at 08:26:31AM +0200, Ondrej Mosnacek wrote:
> This patch fixes sleep-in-atomic bugs in AES-CBC and AES-XTS VMX
> implementations. The problem is that the blkcipher_* functions should
> not be called in atomic context.
>=20
> The bugs can be reproduced via the AF_ALG interface by trying to
> encrypt/decrypt sufficiently large buffers (at least 64 KiB) using the
> VMX implementations of 'cbc(aes)' or 'xts(aes)'. Such operations then
> trigger BUG in crypto_yield():
>=20
> [  891.863680] BUG: sleeping function called from invalid context at incl=
ude/crypto/algapi.h:424
> [  891.864622] in_atomic(): 1, irqs_disabled(): 0, pid: 12347, name: kcap=
i-enc
> [  891.864739] 1 lock held by kcapi-enc/12347:
> [  891.864811]  #0: 00000000f5d42c46 (sk_lock-AF_ALG){+.+.}, at: skcipher=
_recvmsg+0x50/0x530
> [  891.865076] CPU: 5 PID: 12347 Comm: kcapi-enc Not tainted 4.19.0-0.rc0=
=2Egit3.1.fc30.ppc64le #1
> [  891.865251] Call Trace:
> [  891.865340] [c0000003387578c0] [c000000000d67ea4] dump_stack+0xe8/0x16=
4 (unreliable)
> [  891.865511] [c000000338757910] [c000000000172a58] ___might_sleep+0x2f8=
/0x310
> [  891.865679] [c000000338757990] [c0000000006bff74] blkcipher_walk_done+=
0x374/0x4a0
> [  891.865825] [c0000003387579e0] [d000000007e73e70] p8_aes_cbc_encrypt+0=
x1c8/0x260 [vmx_crypto]
> [  891.865993] [c000000338757ad0] [c0000000006c0ee0] skcipher_encrypt_blk=
cipher+0x60/0x80
> [  891.866128] [c000000338757b10] [c0000000006ec504] skcipher_recvmsg+0x4=
24/0x530
> [  891.866283] [c000000338757bd0] [c000000000b00654] sock_recvmsg+0x74/0x=
a0
> [  891.866403] [c000000338757c10] [c000000000b00f64] ___sys_recvmsg+0xf4/=
0x2f0
> [  891.866515] [c000000338757d90] [c000000000b02bb8] __sys_recvmsg+0x68/0=
xe0
> [  891.866631] [c000000338757e30] [c00000000000bbe4] system_call+0x5c/0x70
>=20
> Fixes: 8c755ace357c ("crypto: vmx - Adding CBC routines for VMX module")
> Fixes: c07f5d3da643 ("crypto: vmx - Adding support for XTS")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
> Still untested, please test and review if possible.
>=20
> Changes in v2:
> - fix leaving preemtption, etc. disabled when leaving the function
>   (I switched to the more obvious and less efficient variant for the
>   sake of clarity.)
>=20
>  drivers/crypto/vmx/aes_cbc.c | 30 ++++++++++++++----------------
>  drivers/crypto/vmx/aes_xts.c | 21 ++++++++++++++-------
>  2 files changed, 28 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
> index 5285ece4f33a..b71895871be3 100644
> --- a/drivers/crypto/vmx/aes_cbc.c
> +++ b/drivers/crypto/vmx/aes_cbc.c
> @@ -107,24 +107,23 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc=
 *desc,
>  		ret =3D crypto_skcipher_encrypt(req);
>  		skcipher_request_zero(req);
>  	} else {
> -		preempt_disable();
> -		pagefault_disable();
> -		enable_kernel_vsx();
> -
>  		blkcipher_walk_init(&walk, dst, src, nbytes);
>  		ret =3D blkcipher_walk_virt(desc, &walk);
>  		while ((nbytes =3D walk.nbytes)) {
> +			preempt_disable();
> +			pagefault_disable();
> +			enable_kernel_vsx();
>  			aes_p8_cbc_encrypt(walk.src.virt.addr,
>  					   walk.dst.virt.addr,
>  					   nbytes & AES_BLOCK_MASK,
>  					   &ctx->enc_key, walk.iv, 1);
> +			disable_kernel_vsx();
> +			pagefault_enable();
> +			preempt_enable();
> +
>  			nbytes &=3D AES_BLOCK_SIZE - 1;
>  			ret =3D blkcipher_walk_done(desc, &walk, nbytes);
>  		}
> -
> -		disable_kernel_vsx();
> -		pagefault_enable();
> -		preempt_enable();
>  	}
> =20
>  	return ret;
> @@ -147,24 +146,23 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc=
 *desc,
>  		ret =3D crypto_skcipher_decrypt(req);
>  		skcipher_request_zero(req);
>  	} else {
> -		preempt_disable();
> -		pagefault_disable();
> -		enable_kernel_vsx();
> -
>  		blkcipher_walk_init(&walk, dst, src, nbytes);
>  		ret =3D blkcipher_walk_virt(desc, &walk);
>  		while ((nbytes =3D walk.nbytes)) {
> +			preempt_disable();
> +			pagefault_disable();
> +			enable_kernel_vsx();
>  			aes_p8_cbc_encrypt(walk.src.virt.addr,
>  					   walk.dst.virt.addr,
>  					   nbytes & AES_BLOCK_MASK,
>  					   &ctx->dec_key, walk.iv, 0);
> +			disable_kernel_vsx();
> +			pagefault_enable();
> +			preempt_enable();
> +
>  			nbytes &=3D AES_BLOCK_SIZE - 1;
>  			ret =3D blkcipher_walk_done(desc, &walk, nbytes);
>  		}
> -
> -		disable_kernel_vsx();
> -		pagefault_enable();
> -		preempt_enable();
>  	}
> =20
>  	return ret;
> diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
> index 8bd9aff0f55f..e9954a7d4694 100644
> --- a/drivers/crypto/vmx/aes_xts.c
> +++ b/drivers/crypto/vmx/aes_xts.c
> @@ -116,32 +116,39 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *=
desc,
>  		ret =3D enc? crypto_skcipher_encrypt(req) : crypto_skcipher_decrypt(re=
q);
>  		skcipher_request_zero(req);
>  	} else {
> +		blkcipher_walk_init(&walk, dst, src, nbytes);
> +
> +		ret =3D blkcipher_walk_virt(desc, &walk);
> +
>  		preempt_disable();
>  		pagefault_disable();
>  		enable_kernel_vsx();
> =20
> -		blkcipher_walk_init(&walk, dst, src, nbytes);
> -
> -		ret =3D blkcipher_walk_virt(desc, &walk);
>  		iv =3D walk.iv;
>  		memset(tweak, 0, AES_BLOCK_SIZE);
>  		aes_p8_encrypt(iv, tweak, &ctx->tweak_key);
> =20
> +		disable_kernel_vsx();
> +		pagefault_enable();
> +		preempt_enable();
> +
>  		while ((nbytes =3D walk.nbytes)) {
> +			preempt_disable();
> +			pagefault_disable();
> +			enable_kernel_vsx();
>  			if (enc)
>  				aes_p8_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
>  						nbytes & AES_BLOCK_MASK, &ctx->enc_key, NULL, tweak);
>  			else
>  				aes_p8_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
>  						nbytes & AES_BLOCK_MASK, &ctx->dec_key, NULL, tweak);
> +			disable_kernel_vsx();
> +			pagefault_enable();
> +			preempt_enable();
> =20
>  			nbytes &=3D AES_BLOCK_SIZE - 1;
>  			ret =3D blkcipher_walk_done(desc, &walk, nbytes);
>  		}
> -
> -		disable_kernel_vsx();
> -		pagefault_enable();
> -		preempt_enable();
>  	}
>  	return ret;
>  }
> --=20
> 2.17.1
>=20

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDWI6S4SUeUOX/xHQzxpLxzTV7UcFAlt9+h4ACgkQzxpLxzTV
7UdUaQf/Su/5vTekGE+scHrkMHwxx5mTeNaEb8MPjVfuo+SoLrMZc4CaOb3xkKtd
k3WbXSvrQYQljQnnl8JUcRj8PffLS2V74MO7xemcw324NUvG9uwWZh3DkXfEaWiF
87z2fUPWyOjI0FlP/8X10EoTjKGHH7gKBR3zeR3NggzrbBN8orPpMooBavvQpD6Z
+qMfVz+j5CM95Fm/Uv46QN8QRzX700BNmn9Xt3rtm+l7AdLbWDFYAddsDV2dWmeM
JTSW9cehrHzMJ3nzcMHOx6sAjECzdCwD207bOw2DNmgntCaDpRmnLDmFYmZUKOYy
DnavE8MeB0lW7VcJaqezdm+sZBWXdA==
=rp+2
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
