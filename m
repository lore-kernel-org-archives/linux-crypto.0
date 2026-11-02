Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793602174;
	b=azK5Q7e+pp/ngqw7gJx1pH0Jm4QJx/gXKUkdG82v+VFfp6s9uGKJ40f5A8/2YNpyb2LZ
	 wwBrGuHXpXLiqbPPnK4d58MOiuZ+WcUJk3ybJQs6S2TOY6lEPDT9+DhTlhNx4S6PpO4lI
	 JxnLv9Wrt5NtzC+geU61eJEXRkz37kKwFTcbErsI+rABlT6Th3YfyYZYpqcsINBzCNkba
	 BBUZ3Rzyg0qAJ/9Ewg8+XXZLMEVT5GdMevKd7cSTDAyvcPKsKvU4F8xlXbPnEEEwkLEZE
	 ugKQfeD9Li4Nhb4WwhPgfAEHQCXEFOk7sZ0GjDm0iiYS5TfoQsz1LRFy7Ckv+ZdeJrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793602174;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RM3QVbG0XSlDtbJbaPbVELsay6LhWm18nju9jF437RM=;
	b=HMFKiCLnsiFKLSMEozLCe8ekzKgwuIuapemInjVWwe/RWOsCtnBkWVYaJH8ejKNrDcJm
	 UkeUMIKtx9vdSMgc0Gzv/RoIszd8jMJXpM+tSE+GbjO0iGaE63zJPcSYtWZDLoMaQ8Bok
	 i8hqZUEsuh5X3fIyUs6Wd5bK6afiFPuHKDxH8sPphQGRPmLNj6/PvYwY1NF1cBgDvxPrn
	 V8o0B0gaNcwMpqrvWNUyWiarTmPlgMhTaa9fjMKwxRjAmvDX+aD47cq6t9SYYFmuqFeFT
	 ZQ4H92nJfri4yiX11SLyY/bgoAGkb8owxvwEfh0RLFB6b7b+v9uPhph+IdWud/SN4Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jcs2Rkst;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB45B606A326
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 06:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jcs2Rkst
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0551F000C1;
	Mon,  2 Nov 2026 06:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793602173;
	bh=RM3QVbG0XSlDtbJbaPbVELsay6LhWm18nju9jF437RM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jcs2RkstBPOHbZyhcIMHjzvRNEY03p5ff3/7cZnWuzzAYo71jXCZG3xidBVMFvVfE
	 YDPg9E68EAFCTsScFFqG/BluUu+h48OnGeASCwe8uxTFaiY4/WCQx5seSXVoyVuwJ/
	 kgUZ9gFjA5OPcq+5YoApLJCABikHKsQRAD+7WL3ZYwxBWtO1u5b62yMIwUTu533Zo6
	 QNEU5nbJjKgfybRlb2Qz3eglQsb8OoDPgZmqdq7WA1+YkwDIrvz/cxQkv2tzkoRv8k
	 J6lCgp+le03leGxjKC1fXJgBrH/tgd4MwZJS+WQlg6itokO/UEetaQLf1tq95vcsTt
	 voLUgYByNuuZw==
Message-ID: <sashiko-outbox-192966@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] lib/crypto/mpi: Fix heap OOB write in mpi_powm() when
 res aliases input
Reply-To: sashiko-reviews@lists.linux.dev
To: "Maholi Tumanggor" <maholitumanggor@gmail.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
In-Reply-To: <20261102064225.2271-1-maholitumanggor@gmail.com>
References: <20261102064225.2271-1-maholitumanggor@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:49:32 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] lib/crypto/mpi: use-after-free and leak in mpi_powm() when ass=
ign_rp is set
--

commit 85051cb2fd0529447a03f7f3bbc383a2addcb07d
Author: Maholi Tumanggor <maholitumanggor@gmail.com>

lib/crypto/mpi: Fix heap OOB write in mpi_powm() when res aliases input

This commit avoids writing the exponentiation result into an undersized
res->d buffer in mpi_powm() when assign_rp is set due to res->d aliasing
an input operand.

> diff --git a/lib/crypto/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
> index 9e695a3bda3a0..06038ac8f92ac 100644
> --- a/lib/crypto/mpi/mpi-pow.c
> +++ b/lib/crypto/mpi/mpi-pow.c
[ ... ]
> @@ -256,14 +256,16 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  		 * might be, see above).
>  		 */
>  		if (mod_shift_cnt) {
> -			carry_limb =3D
> -			    mpihelp_lshift(res->d, rp, rsize, mod_shift_cnt);
> +			mpi_ptr_t dst =3D assign_rp ? rp : res->d;
> +
> +			carry_limb =3D mpihelp_lshift(dst, rp, rsize, mod_shift_cnt);
> +			if (!assign_rp)
>  			rp =3D res->d;
>  			if (carry_limb) {
> -				rp[rsize] =3D carry_limb;
> -				rsize++;
> +			rp[rsize] =3D carry_limb;
> +			rsize++;
>  			}
> -		} else {
> +		} else if (!assign_rp) {
>  			MPN_COPY(res->d, rp, rsize);
>  			rp =3D res->d;
>  		}

[Severity: Critical]
When assign_rp is set in lib/crypto/mpi/mpi-pow.c:mpi_powm() because
res->alloced < size and rp aliases bp, ep, or mp, a new limb buffer is
allocated directly into rp without saving a marker pointer:

	if (res->alloced < size) {
		if (rp =3D=3D ep || rp =3D=3D mp || rp =3D=3D bp) {
			rp =3D mpi_alloc_limb_space(size);
			if (!rp)
				goto enomem;
			assign_rp =3D 1;

Later in the exponentiation loop, rp and xp are swapped after every
squaring step and after every multiplication step:

		xp =3D xp_marker =3D mpi_alloc_limb_space(2 * (msize + 1));
		...
		for (;;) {
			while (c) {
				...
				swap(rp, xp);
				rsize =3D xsize;

				if ((mpi_limb_signed_t) e < 0) {
					...
					swap(rp, xp);
					rsize =3D xsize;
				}

If the exponent causes an odd number of swap(rp, xp) operations (for
example when exp has an odd number of zero bits after the most significant
bit, such as exp =3D 2 or exp =3D 65537), the loop finishes with rp pointing
to xp_marker and the block-local xp pointing to the buffer allocated for
assign_rp.

With this change, when assign_rp is 1, rp is left pointing to xp_marker
while xp goes out of scope. At the end of mpi_powm():

	if (assign_rp)
		mpi_assign_limb_space(res, rp, size);
	...
	if (xp_marker)
		mpi_free_limb_space(xp_marker);

Wouldn't mpi_assign_limb_space() assign xp_marker to res->d and
mpi_free_limb_space(xp_marker) immediately zero and free it, leaving
res->d pointing to freed memory while leaking the limb buffer originally
allocated for rp?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102064225.2271=
-1-maholitumanggor@gmail.com?part=3D1
