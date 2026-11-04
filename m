Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793771893;
	b=axQtgLO8YUrxiYrwqOpQ/oSSwko4vU89paZaGtPcAS6EB9RxZQwI2uOpkYPj68rcP/Hv
	 dwm7mNj3lKX5ml6wFC6rgMrvBqleABNG3ZxL/EXi0/A/t6fUa04Y78uT2PkmS4TgaVIVV
	 1h2m5QfUPuDoTgvcJg1ViQhZ8S6dzpC3KvhRtTkmnHvf+sN6wtIjY2/Nv0bFEZ1TRzKDd
	 5yj/l3OIUlk2tDNbObxD1DtfqKVG/tjqe9NzTS7AWouTUUjm87WomEKYydocvyFG0wbRW
	 v/sfSekQnn8MpHhdqtyWiNKX2ChwjnlHT5nWCrFhLeN9SRNZPIN5hhAAcw9W5qmCJfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771893;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=GuMgcgXi2d8E9GAegF23L5yqInpKNepyztEiRzZzVFY=;
	b=LXFi7uljD7TW2q5DuSQifGEGblCXhir29e4N/ZmjyZrPKogzpJSXnUGJuxQ9ixdAq9bH
	 zqYKTIW2tgAD7Uhf9SVnVuUwNe43RezB2nzr57RTzCNVvzRM/Ysln45gaMLo52OYVOz7+
	 1RzaXfHpjKPbn9EF3RVxEeYEDHLfkkvt2pu1repyZlHe7tJtEyOLVsgNd8o+0r6EmbKcL
	 fBxb94yYwSjBinJVDqRsVJKK9Vdb+VP+dEW2FrNh0iuClt+B5zYgx4MgyzLIiKjz7BSOH
	 Ao78lqoq1y+fFU8SDpqSVWtBs62/+YfA/cHwtFSUK9UsvjFjcsUgOyUSaDUldqVRNnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=nKNhpjXt;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317F606A328;
	Wed,  4 Nov 2026 05:58:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B317F606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=nKNhpjXt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GuMgcgXi2d8E9GAegF23L5yqInpKNepyztEiRzZzVFY=; 
	b=nKNhpjXtNFPq3RPGi6Z3gnojYnP7E9wP8YpuIKrmvFVH9l758u0Z2rhJDSDgSCm6+owCN0gKm3Q
	wSMC9l9y9ZHRsw+HtyemNhMuTKV2aSYs8iccdsfHA4+09FuaAXGjPpmJtncoSiwlMorNl1NAO0Mol
	WDM04nQVzydHwNsEojj9PVyNGoPhm24p4i14e9NI3qQvnvvpMU0cyHWwhj6s8MIatcCvJDPZcM/5g
	fAqdX2giQB8BmTQoPALJXawvKupLSiQ51WcQZzIkEDNecXkW3yQ2Ob+kNh6lX73ziNnpXftTo8+NP
	9Ds7ZSeaaTHFcLIa6C+fEFpi2IQ+kFqTi/Pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOU0V-0000000AkBq-1V5g;
	Wed, 04 Nov 2026 13:58:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 13:57:59 +0800
Date: Wed, 4 Nov 2026 13:57:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <aurJZ81qnbiHH_P1@gondor.apana.org.au>
References: <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>

On Tue, Nov 03, 2026 at 09:39:03PM -0800, Linus Torvalds wrote:
>
> None of that says why.  It only repeats what I already said: it seems
> to be due to kmsan doing bad things.

Fair enough.

When I was told that folks needed vmalloc under GFP_ATOMIC I didn't
question it any further:

https://lore.kernel.org/all/aeiHkG7X_dieMdw5@milan/

Looking back, it does look like it was never explained who these
folks are.

Ulazislau, so who needs vmalloc GFP_ATOMIC support in the kernel?
Or is it only used by out-of-kernel code?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
