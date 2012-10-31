From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 2/2] Remove VLAIS usage from crypto/testmgr.c
Date: Wed, 31 Oct 2012 10:45:20 +0200
Message-ID: <20121031104520.45391yrgl3tgaza8@www.dalek.fi>
References: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
 <1351622249-18084-3-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan-Simon =?iso-8859-1?b?TfZsbGVy?= <dl9pf@gmx.de>,
	pageexec@freemail.hu
To: Behan Webster <behanw@converseincode.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37523 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028Ab2JaIpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Oct 2012 04:45:24 -0400
In-Reply-To: <1351622249-18084-3-git-send-email-behanw@converseincode.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Behan Webster <behanw@converseincode.com>:

> From: Jan-Simon M=F6ller <dl9pf@gmx.de>
>
> The use of variable length arrays in structs (VLAIS) in the Linux Ker=
nel code
> precludes the use of compilers which don't implement VLAIS (for insta=
nce the
> Clang compiler). This patch instead allocates the appropriate amount =
=20
> of memory
> using an char array.
>
> Patch from series at
> http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/=
142707.html
> by PaX Team.
>
> Signed-off-by: Jan-Simon M=F6ller <dl9pf@gmx.de>
> Cc: pageexec@freemail.hu
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  crypto/testmgr.c |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 941d75c..5b7b3a6 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1578,16 +1578,19 @@ static int alg_test_crc32c(const struct =20
> alg_test_desc *desc,
>  	}
>
>  	do {
> -		struct {
> -			struct shash_desc shash;
> -			char ctx[crypto_shash_descsize(tfm)];
> -		} sdesc;
> -
> -		sdesc.shash.tfm =3D tfm;
> -		sdesc.shash.flags =3D 0;
> -
> -		*(u32 *)sdesc.ctx =3D le32_to_cpu(420553207);
> -		err =3D crypto_shash_final(&sdesc.shash, (u8 *)&val);
> +		char sdesc[sizeof(struct shash_desc)
> +			+ crypto_shash_descsize(tfm)
> +			+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
> +		struct shash_desc *shash =3D (struct shash_desc *)sdesc;
> +		u32 *ctx =3D (u32 *)((unsigned long)(sdesc
> +			+ sizeof(struct shash_desc) + CRYPTO_MINALIGN - 1)
> +			& ~(CRYPTO_MINALIGN - 1));

I think you should use '(u32 *)shash_desc_ctx(shash)' instead of =20
getting ctx pointer manually.

> +
> +		shash->tfm =3D tfm;
> +		shash->flags =3D 0;
> +
> +		*ctx =3D le32_to_cpu(420553207);
> +		err =3D crypto_shash_final(shash, (u8 *)&val);
>  		if (err) {
>  			printk(KERN_ERR "alg: crc32c: Operation failed for "
>  			       "%s: %d\n", driver, err);
