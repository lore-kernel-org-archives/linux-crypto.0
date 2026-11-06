Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976571;
	b=seBQRFOg3qW+2RzQHtayGfnLisbYj8mAXJU1jfopJ2Ax63cYe7JIFu1N7zYttla1L1je
	 QuV2NhL3W3pM2pO3lGbnChgfOdGF+/tOq07iYiFiYloFqUVCfDFzNCPOGuTOxET0K/pnG
	 Ezs3xAeDXbudw7cxObrlny8Ln1agcD1ACn2eRa6+cDAbX8Q7udTwDhQ/F+ngpV7PaMQZi
	 H/oRLCnX6h/FKzQovq4N3AO7PS9FT1pxEld0LNZlNyMlrb6e/4ltHanyZkjzJSre0TB92
	 E3CPEbX5NIUlyy8ya/fYIhzvTJT0zxZ+3I9BmVdEXltpDI4Zo77bZ0q7z1CAkEtNUVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976571;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9rMsM7/rehLui5qOsnKizKXUB9spqiPyM2vJCrOWMd8=;
	b=U98osYCobg0IlTemdaoSZ6MIMkjRq/4Eu8CAZ2Pfw7K1j2r77lFIgR6bcZ6hZu8F5Yc2
	 dJJEVOKuj/fv0n6fPNncGWXU4XS+BXnHFn32vxuZ6loAu0VngEQV58f5t6oIFt4en4/jj
	 AxSmFCWcs1CbH91EmvhzoQaJVUM3IMQAYtgUL3Wb60SNmA1SWOFhattwK2OPp4xNHKGO7
	 KNhcUUTPvD6Q1XXimRf7fyG8OKa0o54o1S4qt7+GWCjSzud4CPALiXIxWyhbuK2e1KHqy
	 28g5W8Cp3I9p9JYT40ikni4MQ744ulCCFb3LcJDQpl8r/ii7YqQeJJ8OKZT4amjLIXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Axvxdmjd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8E6606A330;
	Fri,  6 Nov 2026 14:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Axvxdmjd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469CE1F008A2;
	Fri,  6 Nov 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793976571;
	bh=9rMsM7/rehLui5qOsnKizKXUB9spqiPyM2vJCrOWMd8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AxvxdmjdFqsWTODx4R57MiWjOLFBcNBUOuEQqzgs6IxZ5BI8is+hgig/dZSklYZbj
	 WqiKo6GdsOjmPR7EZVzpoVaFGpkrkh//vy/9XtnkiOLLYRPmuoBxIcQl0YinAVDjgm
	 w5vaAAOkwXbGdRl4o2Ji7UpsYOZaHVlO8u35rqS9LrGQf2hRTGN8X/GDC1V1bBp5v5
	 MZS+pdPuxGk/Q+LxP6jdLYc9LQlFZIWmfE1zORSQMiZ428nLDqIJvDZB2nhNlCX/V/
	 dGixDZZQWn1vv9AHiPwTjoQgjnUstKCIZFSNgkAtC72ExxGQ1ODZmUfLW5HS8p6LjC
	 4POIJHcgOiEsA==
Message-ID: <sashiko-outbox-201613@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/15] zram: lz4hc: reset the dictionary stream once,
 not per page
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
In-Reply-To: <20261106-lz4-vendor-upstream-v2-3-ee04c3f0d7dc@samsung.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144252eucas1p272c9e37d66ad385db070f941879aecb1@eucas1p2.samsung.com>
 <20261106-lz4-vendor-upstream-v2-3-ee04c3f0d7dc@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 14:49:28 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] zram: high-order memory allocation using kzalloc in
  lz4hc_create() [1]
--

commit 2f51683dc7418bdcd0730283cb7003d8754fcd5f
Author: Michal Wilczynski <m.wilczynski@samsung.com>

zram: lz4hc: reset the dictionary stream once, not per page

This commit moves the LZ4_resetStreamHC() call for dictionary-backed
streams from lz4hc_compress() to lz4hc_create() so that the stream state is
only reset once at creation time rather than on every compressed page.

> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/back=
end_lz4hc.c
> index d8aa01bb258fe..06286c805cf7c 100644
> --- a/drivers/block/zram/backend_lz4hc.c
> +++ b/drivers/block/zram/backend_lz4hc.c
> @@ -72,6 +72,7 @@ static int lz4hc_create(struct zcomp_params *params, st=
ruct zcomp_ctx *ctx)
>  		zctx->cstrm =3D kzalloc_obj(*zctx->cstrm);
>  		if (!zctx->cstrm)
>  			goto error;
> +		LZ4_resetStreamHC(zctx->cstrm, params->level);
>  	}

[Severity: Medium]
This problem wasn't introduced by this patch, but should zctx->cstrm be
allocated with vmalloc() or kvzalloc() instead of kzalloc_obj() [1]?

LZ4_streamHC_t is 262,192 bytes (LZ4_STREAMHCSIZE), so kzalloc_obj()
requests an order-7 physically contiguous allocation.  Unlike the
non-dictionary path right above, which uses vmalloc(LZ4HC_MEM_COMPRESS),
this allocation can easily fail under normal memory fragmentation during
zram initialization or CPU hotplug.

[1] https://sashiko.dev/#/bug/linux-78ebc045-5e81-4f0b-985e-99483d454b25

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-lz4-vendor=
-upstream-v2-0-ee04c3f0d7dc@samsung.com?part=3D3
