Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769689;
	b=kq+8OKnj/Dx2dJ2Bpr9XSJV3X7YOKkhoDjZBGe3/tBOXx2yr+/aRJf01yPDco8VyOizD
	 8H5LVkv6ND9cChJUkVPmBXGpKVsPsOLCSwlklHDQ3aaIKtvFWdTmJFb+99XEhRXcRidkx
	 gxZHJZjnC5vOwC7TepmCDl1iXpDdmtwUJrQQAKlRny2p5keKjIqIf5U39ILsCeZaeLD/2
	 7K9cvsEwMNfIMhaDcLIu9P7wqX8JIxLMPELxek1RGp3IUsVOHmQLWp1eNF4myLA0WBkNS
	 CG/mSmuEX7RKqD2x+iXTafCfW/rxvbZQ2V7US4iScKrqK7fzg/9SU4KNAR0iVIcdBLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769689;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=S3sZXHpAcPchFFTmYmyd75A+OImYl038QKcmLNpDQcM=;
	b=jdl1uq1a2z2JrUle2T9OC9Oyc9Wn8m/5mj70eWFYazixGGbxCztf3prBdUM2J/B6iQai
	 cBsBYBFuiuMTVkMqtMr/K1cLG6j2cGcBvqOjC0U5JGESY4LOLsLWxe/uVrURb0bRbIRe3
	 w8UGVlXe39hDTc2aRllARZ/Nf/msjbx1v5l/tA3Ck70PPrMEX+ALoSvYgFzx/wiyy6r14
	 wQwv4Qp2t87gEUfTyFZuwbk9mjItb6mzGHLYqj9VBcBxRlCXO1yu/HuwKnnYyXkXY4adK
	 yeKCkOIO+Mrdtc8qDTtbTRxvmMiUtCL0eNGDG52FlhCNtFUrUcpZ7jBa8dsB4QmueuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=YzLPmqXY;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEE4606A31B;
	Wed,  4 Nov 2026 05:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDEE4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=YzLPmqXY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=S3sZXHpAcPchFFTmYmyd75A+OImYl038QKcmLNpDQcM=; 
	b=YzLPmqXY0MxXcC9TMOXwtUj7onQ5u6uagUGMGvdjIpVkTP0Dv23rLhmSumxfZZn9cA6gKZRTLLB
	zUUP6RRaHjDRbnuMAMqEcuo7nQHB9PsSZBPM0FnxE9Q98mO389RY3/dWKz1C958KgOmh16HLIOKtc
	x8cUnVMgGtq+BggapJkv2Bn36/SFC076gxdVbV5Jq6XjHbUfxzsEdgrOXRaPt+v+zCSF5MuA7lv1C
	rmHeiyTOMCaynQwEazXm1jotf54Q72+cISoQelnRNRnE5jqXHmklBVLsl7GiCJ8J9VmVwxH5IB5KO
	iBPhK7SfwtoU/iY7fhPYXRvyuSnkjDLm697A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOTQr-0000000Ajf4-0KeO;
	Wed, 04 Nov 2026 13:21:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 13:21:09 +0800
Date: Wed, 4 Nov 2026 13:21:09 +0800
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
Message-ID: <aurAxRpCwzeyXeVj@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
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
In-Reply-To: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>

On Tue, Nov 03, 2026 at 08:28:36PM -0800, Linus Torvalds wrote:
>
> Sadly, the commit you point to doesn't talk about *why* that
> braindamage was done. Looking at the original thread it seems like it
> was for kmsan.

Here is the link to the whole series that was applied (v4):

https://lore.kernel.org/all/20251007122035.56347-11-urezki@gmail.com/T/#m50cf87c3f12015a56abe5a6359525019851f1b97

This is the original RFC:

https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
