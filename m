Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793977166;
	b=Vt23v5EiFnRfv+T9EGDtJvbWiJ3TUiq37VHJGyb68y2DBGhQGgiXzviswKZfmeVuiyfk
	 dC1IMAXA7F0MEpfbtjd3MXSAmG4y7VqrhcA3qf9aP35iaUCoFJ6vkjaW38inPDU1/joVo
	 yJ9FUTk9pDbW2/dqIkuyv4ICmqNT4fObeKiDee+GVseCfzHUd99x/4KuMe1PzktbUEoQ1
	 DcHBM91grz+5RBEORmWKS1nYbl2l8U/AFRy6NF/enpziDXKE7U/vM50T0+PI6Q+RDVhck
	 inaerPXjo3tsTLN/33SCYWPQiwqMifxArZKK7/FRjQI6NYoDrIGt2DgY9Lx2daLpOtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793977166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xG7o7rly+kfqWE7XteccTBBS+YPOrk+ymPlbhGa13X4=;
	b=1EzsAcAXBUKGmWpVYs1QDHTR8QygptpW6XDRH0VgvDw2XN0Qnq6yRZ8nQ8XFKZBIrOIm
	 sBV/tet2LY7hTyRdczZcasUS4yQvieUtn/fB9Upwiq2d8hwfTNExAUsnq5miog69ei5c5
	 geBLPvw74hzlQHgbOIL6msgy1PfWSEP0L6ZkzDbIgBuhlo3CTYExgaPGd57BKi07hCHJx
	 PRHvPbaRxP+n3W2UhREyq6sc1YNS2wp+edny1ud1D1bMUgRoCJkVNEKsJbaUTs34mz+Qx
	 78RaSIFJW7JaP8fLpz2TnN68ESb4my49n6ErGWqKR/ZAP1yFLm/z9G/SDZAiVsF0/Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="R/auBihr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FEC606A329;
	Fri,  6 Nov 2026 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R/auBihr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A9D1F0089F;
	Fri,  6 Nov 2026 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793977165;
	bh=xG7o7rly+kfqWE7XteccTBBS+YPOrk+ymPlbhGa13X4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R/auBihrwcG/odmjAIH7VHzt7dcQmFZEllC3wmhuoQQx5mhHNyXkZe4fGRUdF0v0W
	 mTBEW+Cf4K4G4GaZ0WyJ2OknOEGXYxpmOxJI0tzjUovd7rzf/cN9YbprxP7/LxgZOl
	 OpiDt3zNVOBrN6RGKd93FejmtOtwJWf2YXMepS4cdZBNY3VW/rGgP8Air9ivAYfPOT
	 yoycdmHubXcVz4gjnwVB3TbFrL0VAnGK5V/Saa7FBtmRDsuWO+wG9Fx1M5NbF+lCRW
	 hS1TSx8v+SE/ml26nnNmsgwpztXxpqua1pTzA0MYgsGYCEONGEu4ZAST3oNcqNGJoj
	 dzQ+4fGJAhaig==
Message-ID: <sashiko-outbox-201633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/15] lib/decompress_unlz4: use
 LZ4_decompress_safe_partial() before boot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michal Wilczynski" <m.wilczynski@samsung.com>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Bill Wendling" <morbo@google.com>, "Justin
 Stitt" <justinstitt@google.com>, "Russell King" <linux@armlinux.org.uk>, "Thomas
 Bogendoerfer" <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Helge
 Deller" <deller@gmx.de>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H.
 Peter Anvin" <hpa@zytor.com>, "Minchan Kim" <minchan@kernel.org>, "Sergey
 Senozhatsky" <senozhatsky@chromium.org>, "Jens Axboe" <axboe@kernel.dk>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, "Yann Collet" <yann.collet.73@gmail.com>, "Nick
 Terrell" <terrelln@meta.com>, "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David Laight" <david.laight.linux@gmail.com>, Sungguk <sungguk.na@samsung.com>, "Jaehoon
 Chung" <jh80.chung@samsung.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261106-lz4-vendor-upstream-v2-1-ee04c3f0d7dc@samsung.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144249eucas1p1ca5f03b764c6305120da3e8b65f76ed1@eucas1p1.samsung.com>
 <20261106-lz4-vendor-upstream-v2-1-ee04c3f0d7dc@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 14:59:23 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] lib/decompress_unlz4: unvalidated chunksize passed to decoder
  in unlz4()
- [Low] lib/decompress_unlz4: partial decode skips full-block checks in
  unlz4()
- [Low] lib/decompress_unlz4: unlz4() does not check out_len =3D=3D 0 at
  stream end
--

commit 8a11d492456e8edabb6dad4a7ecb828134c99572
Author: Michal Wilczynski <m.wilczynski@samsung.com>

lib/decompress_unlz4: use LZ4_decompress_safe_partial() before boot

This commit replaces LZ4_decompress_fast() with
LZ4_decompress_safe_partial() in the pre-boot unlz4() path and checks that
each chunk produces the expected output size.

> diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
> index c0dbb3cea915e..dc20c22e08790 100644
> --- a/lib/decompress_unlz4.c
> +++ b/lib/decompress_unlz4.c
> @@ -151,14 +151,17 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
>  			}
>  		}
>  #ifdef PREBOOT
> -		if (out_len >=3D uncomp_chunksize) {
> +		if (out_len >=3D uncomp_chunksize)
>  			dest_len =3D uncomp_chunksize;
> -			out_len -=3D dest_len;
> -		} else
> +		else
>  			dest_len =3D out_len;
> +		out_len -=3D dest_len;
> =20
> -		ret =3D LZ4_decompress_fast(inp, outp, dest_len);
> -		chunksize =3D ret;
> +		ret =3D LZ4_decompress_safe_partial(inp, outp, chunksize,
> +						  dest_len, dest_len);

[Severity: Medium]
Can a truncated or corrupted chunk header cause LZ4_decompress_safe_partial=
()
to read past the end of the input buffer?

Previously, LZ4_decompress_fast() ignored chunksize and overwrote it with t=
he
consumed byte count before the !fill path checked size -=3D chunksize at the
bottom of the loop:

lib/decompress_unlz4.c:unlz4() {
	...
		if (!fill) {
			inp +=3D 4;
			size -=3D 4;
		} else {
	...
		if (!fill) {
			size -=3D chunksize;

			if (size =3D=3D 0)
				break;
			else if (size < 0) {
				error("data corrupted");
				goto exit_2;
			}
			inp +=3D chunksize;
		}
}

Passing chunksize from get_unaligned_le32(inp) directly to
LZ4_decompress_safe_partial() before checking it against size lets the
decoder read past input + in_len when chunksize > size, or pass a negative
compressedSize when chunksize >=3D 0x80000000.

> +		/* A chunk once the image's stated size is reached is corrupt. */
> +		if (!dest_len || ret !=3D (int)dest_len)
> +			ret =3D -1;

[Severity: Low]
Should this call LZ4_decompress_safe(inp, outp, chunksize, dest_len) instead
of LZ4_decompress_safe_partial()?

In LZ4_decompress_generic(), partial_decode mode clamps literal runs and
matches that would exceed dest_len and stops as soon as dest_len bytes are
written without verifying that all chunksize input bytes were consumed.  A
corrupted chunk that expands beyond dest_len or leaves trailing bytes inside
chunksize will still return dest_len and pass this check.

[Severity: Low]
Can a truncated image that ends on a chunk boundary still return success wh=
en
out_len has not reached zero?

This check rejects chunks that decode short or arrive after out_len reaches
zero, but if the input stream ends early between chunks (or has chunksize =
=3D=3D
0), the loop jumps to exit_3 and returns 0 with out_len > 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-lz4-vendor=
-upstream-v2-0-ee04c3f0d7dc@samsung.com?part=3D1
