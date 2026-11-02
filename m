Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624596;
	b=OtNKICwRVyWISwKuryfumZIrpq/qr1UPdeI6W5Y9piWru2S67AYAmd8UWTkW2trk7sgi
	 Z4j8UdTSPGFTGoz6Xw1Zmh9qUGQugKK7tT0qB1TKwB2iPDNwx8C9w+6KWFPz0L45t/u8n
	 mry1QhC0W2+i6QYwV1ZbqgC7p5wz6/Xaiwb7dF5LAaBBdrZYjyM1Ke+C+Mv1nArwEJyyy
	 xVTZrOG5M8QO5Vfq2h4C128nYCcxNFinEz3BULOHxIIjKjHSZBEKo9mHDyGs/xkhmMCeU
	 e8cFGcOdriYo/RMJwuTNwmMGRSavSebrXxLJABcq9HoCF+TH84jUv6IA+5/+tsmDQBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624596;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r76KRZ+B+n8dvai9DG3BdAG29jIspd/hhsym9DapORI=;
	b=BrArExIyNQuC6XeGs0v1wYH5ddh654v0kkAwCz6Txpb4SubL0wSrTcsmNGCDJacXxjue
	 Tiwloex5LgcL+XTW4Cy8OpTKqVCRM1W/630udpWB4xzQ5C6AgvKHERiZS5J0u8JMKy+nx
	 qDFHDdCJgMTvB0OZG6A+8i3JLtvyA0QGm8Unvz4ZNprEryQwLloBgzSYZSuLuDLJvNPNs
	 Pw/2fQEoMK35gLYXrvC8cbPBhP7bwTG3wKXWKZdygAqYn2ySgm/LjfYFLxay8/FWsVqv5
	 1aCzzCyJxmbl9LqB27CYeSTUSpUdRHtkUkAXuXpRwvU6zDRjUlVAyDanbnScmNZzjqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GDx5Hzhv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E498D60A5BC2
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 13:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GDx5Hzhv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBB91F00A1B;
	Mon,  2 Nov 2026 13:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793624595;
	bh=r76KRZ+B+n8dvai9DG3BdAG29jIspd/hhsym9DapORI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GDx5Hzhvrr31uCafVaYw5WtOCqs+sySkCSxyBRwqrMk5cOhzt462bQH5OdU3RVHNw
	 pKOma/LBrt0Ti38HW2EtdZRAxPLmnq/jkmYSXTbue9IVzFfuoVVDGAfV4cpeAJP2CN
	 eOkZl5dj9Y+nuSDOTMjPqcTjNnuf7uigyYmtAM6B3E04ISnb3G7ZCMI3m7TfBraezN
	 gWxtisRznIyCVBqgH4bUF1xjxkPkQ6tX5fc6svcZMwIjs74pCtxNFwpHiH54Zxopya
	 HL75BY3yeFZomg6HklKDKFAcCL+0cVIpHX5IE/t4YNc/2vcqlR72trKtr8YpVozzok
	 5q3rKEUqREMyw==
Message-ID: <sashiko-outbox-193454@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] lib/crypto/mpi: Fix heap OOB write in mpi_powm()
 when res aliases input
Reply-To: sashiko-reviews@lists.linux.dev
To: "Maholi Tumanggor" <maholitumanggor@gmail.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
In-Reply-To: <20261102092550.2633-1-maholitumanggor@gmail.com>
References: <20261102064225.2271-1-maholitumanggor@gmail.com>
 <20261102092550.2633-1-maholitumanggor@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 13:03:14 +0000
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
- [Critical] lib/crypto/mpi: NULL dereference in mpi_powm() due to unassign=
ed rp_alloc
--

commit eb877144fed936eb853d022502854e67c6b7e317
Author: Maholi Tumanggor <maholitumanggor@gmail.com>

lib/crypto/mpi: Fix heap OOB write in mpi_powm() when res aliases input

This commit attempts to fix an out-of-bounds write in mpi_powm() when res
aliases an input operand and requires reallocation by introducing rp_alloc
as the write-back destination buffer when assign_rp is set.

> diff --git a/lib/crypto/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
> index 9e695a3bda3a0..f4df9fbcbc2c4 100644
> --- a/lib/crypto/mpi/mpi-pow.c
> +++ b/lib/crypto/mpi/mpi-pow.c
> @@ -28,6 +28,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  	mpi_ptr_t mp_marker =3D NULL, bp_marker =3D NULL, ep_marker =3D NULL;
>  	struct karatsuba_ctx karactx =3D {};
>  	mpi_ptr_t xp_marker =3D NULL;
> +	mpi_ptr_t rp_alloc =3D NULL;
>  	mpi_ptr_t tspace =3D NULL;
>  	mpi_ptr_t rp, ep, mp, bp;
>  	mpi_size_t esize, msize, bsize, rsize;
> @@ -256,16 +257,23 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  		 * might be, see above).
>  		 */
>  		if (mod_shift_cnt) {
> -			carry_limb =3D
> -			    mpihelp_lshift(res->d, rp, rsize, mod_shift_cnt);
> -			rp =3D res->d;
> +			mpi_ptr_t dst =3D assign_rp ? rp_alloc : res->d;
> +
> +			carry_limb =3D mpihelp_lshift(dst, rp, rsize, mod_shift_cnt);
> +			rp =3D dst;
>  			if (carry_limb) {
>  				rp[rsize] =3D carry_limb;
>  				rsize++;
>  			}
>  		} else {
> -			MPN_COPY(res->d, rp, rsize);
> -			rp =3D res->d;
> +			if (assign_rp) {
> +				if (rp !=3D rp_alloc)
> +					MPN_COPY(rp_alloc, rp, rsize);
> +				rp =3D rp_alloc;
> +			} else {
> +				MPN_COPY(res->d, rp, rsize);
> +				rp =3D res->d;
> +			}
>  		}

[Severity: Critical]
As reported by Sashiko on v1 [1], rp_alloc is initialized to NULL in
mpi_powm(), but is it ever assigned when the new limb buffer is allocated?

In lib/crypto/mpi/mpi-pow.c:mpi_powm(), when res->alloced < size and rp
aliases an input operand:

	if (res->alloced < size) {
		if (rp =3D=3D ep || rp =3D=3D mp || rp =3D=3D bp) {
			rp =3D mpi_alloc_limb_space(size);
			if (!rp)
				goto enomem;
			assign_rp =3D 1;
		}

rp_alloc is not updated here and remains NULL.

When execution reaches the write-back block with assign_rp set to 1, won't
mpihelp_lshift() (when mod_shift_cnt is non-zero) or MPN_COPY() (when
mod_shift_cnt is zero) dereference a NULL rp_alloc pointer, and overwrite
rp with NULL so the limb buffer allocated via mpi_alloc_limb_space() is
also leaked?

[1] https://lore.kernel.org/r/20261102064225.2271-1-maholitumanggor@gmail.c=
om

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102092550.2633=
-1-maholitumanggor@gmail.com?part=3D1
