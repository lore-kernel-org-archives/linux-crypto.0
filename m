Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=96.67.55.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411823;
	b=upaDMY+s1zOukxP/7HYWIIV6penxO8U8PuDicdkWwXfemTR+I9tXcGnPKGw5hQ13kagh
	 wZHXL3LsKJBd3Z93+bBosi6rTWAI2YQMXK9zubYG207McZBN909uCp+zZinH4TZft3UIw
	 hyTq+ueM2tMeOhKLrZan0YEgZd5TI0iKcKdODWeMyWi+m66UulGEYq++bSvZfmAt1KoM6
	 03aRZ+bRyoBsK+Oim8Nx8WW1b2XPEDyTLB+iTB5f03WuIGdV4eae6AX71eBZ2YdjqQdU2
	 RFD62iIREiifYwGzgEoRu8G2QrDyycZHzG7112s9vH9ySYhP5Xh5fFFFdIX1M0bStUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411823;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=/9VREGS4F/KCTU6r3pJe44nJmA9BMguSSiJq5/NaFng=;
	b=KiM8pyVvXTHLGf/tAO0TEi4YxCPIPxdaZZdwKfJTlw24ZX60Fe6pltb3//G4jpGBjcaO
	 FCwxT9E9MgidjUwCZlRRB+7RHS/3vvBHZwEH1lXmBE6Nlh06nycxGJ3pkP/weW8cjp55o
	 cPT3Bl969BJfKGzuUVTOQLjzmU6A9Dro9hBkhhHOt82Z4MQBi9hHyq7ibAHVAcQrwHDnF
	 fFQdYXnumo2nNSduo30ii+4DUORXSTCyyKcwBXuMuATprOxPxAh/miyZgIgPMcCVTqiMu
	 9VoSs9rGDwr0Bj7tY0vDeh8kuvZy6KUu6qJld2Vn3v4N+ouUzfonTwR598ko6oQInUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=surriel.com;
	spf=pass smtp.mailfrom=surriel.com;
	dkim=pass header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=nOH3v0Bg;
	arc=none smtp.remote-ip=96.67.55.147
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CB2606A326;
	Wed, 11 Nov 2026 15:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60CB2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=nOH3v0Bg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=/9VREGS4F/KCTU6r3pJe44nJmA9BMguSSiJq5/NaFng=; b=nOH3v0
	BgviyORkrv/kYgza8bS7DBqp+z6vvdhaL6MxCQAWNfCtloYDKLKiTixQodcP0Sv5jlvMdnsha054W
	U/qYAGfbfN9SwVkEb5vulZ1Qz9Foi1t5GZSl4aVD4TFGijBzZu0Nd0QJIhP6aCyTl4e0cbfYMogcM
	7qGghq1U7cyU4tQUSXmWgDwgOfmPU4LJhFTZi5tSwNPCwygqVsBby4hSMH3zGwzfVGzqWL6Nxv9ly
	WIwJsxy+52HXAyLJo1bkBtLeiqhbQ8jn1ZWAue8+vxVWlpKu/iYnu6bBfMrefDAHpIRedWi/fwloW
	ULCpubfTY4uMAZjRaxN7az8CXoCA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xRATp-00000003v0H-3ThD;
	Wed, 11 Nov 2026 15:43:21 +0000
Message-ID: <5cf37868cde9f220b5b6b60871864d8679454ac0.camel@surriel.com>
Subject: Re: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>, Herbert Xu
 <herbert@gondor.apana.org.au>, 	davem@davemloft.net, terrelln@fb.com,
 dsterba@suse.com, hannes@cmpxchg.org, 	yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, Andrew Morton	 <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Date: Wed, 11 Nov 2026 10:43:21 -0500
In-Reply-To: <20261111153532.1036709-2-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
	 <20261111153532.1036709-2-usama.arif@linux.dev>
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
> The zstd acomp streams retain their workspaces after the last
> transform
> has been freed. The first is allocated during transform
> initialization;
> additional per-CPU streams are allocated on demand. They are released
> when the algorithm is unregistered.
>=20
> In a 4 KiB-page x86-64 build, each stream requests 1,566,281 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-9 block
> (2 MiB). vmalloc() needs 383 backing pages (1,532 KiB), 516 KiB fewer
> per stream. Across 384 populated streams, that is 193.5 MiB less
>=20
Woah. Nice catch

> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.
