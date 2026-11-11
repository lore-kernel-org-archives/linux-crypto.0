Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=96.67.55.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411873;
	b=RzAd/LH1+Hgfq6uEtOVMTq3APP8fXxpSq+kNHjfgPXwQ91NOIlPn9SPh0ZLnPxWnvBMH
	 TJ1uzBvryV6rPfabayG/1fbpyxxhNBP6gnuGOZz38fLzsHh79jMmZKdDxLyVWWl+sOsZW
	 A9onfBaQxqO7a1/zJSxGNKqi6etTIqgTdfCt9nSzlWoXqY39frPwksVcPUZcZYU1spW7A
	 i6mIoXpri4Kc90/FgSEtU8DZ2i/KFMVLt+nd8HoLsVs3s6g7Xv6D0fvRdzKP1ucrJVpIE
	 sml1kKDfpd9Li1ZnTZuY7YsH5PeYlzT/bm8iqGD6qSz1phu24wGhQ945kY+0bXHvIMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411873;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=0fjVRx5vsZkDMKGmhuNd7Yjfbs2A2AKB7RRC040th0Y=;
	b=aNB7QB6wk0RYD482TjthxSUILVbv3+HAR9CrLDhY3numisgewxfPhYGN60DYDlLa42OP
	 wL9kXAFKt6XLCYLo+7GFAsURFUaFcsQ6NaZuYFxsCAe30bSL+7t0UPwMXRhsW+jKxpPiZ
	 fQJZMGWd0UADmXG8RVSZTQF8XhM+zar9vFOpNPLq/COXPkvA4tgUaEAkuA7eSA8B6XAjb
	 DXJN2DXBW0MyGMIz6X+qFZbgbSjnYGAQnq1FWahDYA/Hs1aLVzxJvgADFsA1Sh8EdBbDS
	 HghEsC5AG3C3xmxJ7kHF9k11y+xQRMsJqVVi+Skn2EvjgZCS1M03voPZQxEkfWh2ziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=surriel.com;
	spf=pass smtp.mailfrom=surriel.com;
	dkim=pass header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=EoVBFv6o;
	arc=none smtp.remote-ip=96.67.55.147
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A06606A339;
	Wed, 11 Nov 2026 15:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19A06606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=EoVBFv6o
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=0fjVRx5vsZkDMKGmhuNd7Yjfbs2A2AKB7RRC040th0Y=; b=EoVBFv
	6oY8+IOL8Tyrj2uliK/+jDzxNnmJgURLiHpTSqGjVydHO/Ny7XVuOvp3vas+3W6+iABLVZMX9aMXt
	DDyJix35YA0TeyTJqMQgcVABnpmPL5yBSdnAI8j7at/Ax0Se3nS1Ufe8Zae+echT/5bsrF/Uce0iY
	hY4QkORTL6PDyXjWxwMU4LDNROEp2C3OPaDHupepWY5jNMq1oTujdKu2CjXzruuhYUxBJairvppjc
	uUeWrjpyQaFlQUX0dFpfIeg0h8SUsk0Zdqad+arogguxMf/qalnOKOscTdwzs7aSw0n/lYJf17iMg
	nJ4HjW2Mpg6FX6rObqinZdrp06PQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xRAUh-00000003v17-3enR;
	Wed, 11 Nov 2026 15:44:15 +0000
Message-ID: <6e62d5b36362a5dd174de68b5090794877ce499c.camel@surriel.com>
Subject: Re: [PATCH 2/2] crypto: deflate - use vmalloc() for stream
 workspaces
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>, Herbert Xu
 <herbert@gondor.apana.org.au>, 	davem@davemloft.net, terrelln@fb.com,
 dsterba@suse.com, hannes@cmpxchg.org, 	yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, Andrew Morton	 <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Date: Wed, 11 Nov 2026 10:44:15 -0500
In-Reply-To: <20261111153532.1036709-3-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
	 <20261111153532.1036709-3-usama.arif@linux.dev>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, 2026-11-11 at 07:07 -0800, Usama Arif wrote:
> The deflate acomp streams outlive the transforms that use them. One
> stream is allocated during transform initialization; additional
> per-CPU streams are allocated on demand. They are freed only when
> the algorithm is unregistered.
>=20
> In a 4 KiB-page x86-64 build, each stream requests 145,320 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-6 block
> (256 KiB). vmalloc() needs 36 backing pages (144 KiB), 112 KiB fewer
> per stream. Across 384 populated streams, that is 42 MiB less
> workspace backing if all would have used kmalloc(). There is no such
> gain when kvmalloc() already falls back to vmalloc().
>=20
> Use vmalloc() and vfree() directly, as the crypto lz4 implementations
> already do. This uses vmalloc address space, page tables and
> bookkeeping; the figures above compare workspace backing only.
>=20
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.
