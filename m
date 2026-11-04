Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793764719;
	b=kjQvXiewdSpRgKDs6w1FUim7zqF2nW7cpeWNPC800FRiZCTYCIaw4tvAltOXDaDoMabi
	 kLXqaldApv3hpQLY6XYyuz0fxVcM0cRoMnhF+davXkgFlw/+cKX3x5+4iGQUBTNTK5UJZ
	 rS4Qmir5thzS2V1Pm+kzBBOgztlRxaIO3DkF7RS5Md4M5rzPv3wrnx/MhPW272BQH9kd2
	 kb8fvVxVUVd35a7FgmKd844UrWesbsPSth/1FF4Vyf97PK4aqlZvd8ERn7o/mmpdYR8EM
	 iw7xCp5skTRdpAWd2vWwga+wfGfP8O9ddZTj3oDWsgt9FdWw7P9zsfSFKRM9s1+3VjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793764719;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jBo07fOEWVwUuN9u4WHUrXqePYbjYoVaNQovLhhi8es=;
	b=xZF5sACKjsPNgXVVgAJBkfVzH9eT2CIzWGPBtI1aHyhrUDAENM1wpGXTxxIEcznQint3
	 3qsh1h6Y+Qi9+8zQDHgXTqYGAkaOLt+VNonYBqo73NfACFCSmz44i8+/FOar2MSsCmGQR
	 iY+0Qw536dz0ije+K+TSky8dqpw2SCGcmfCsPAxhTqPiNWESyTIFvgXzqjqYAJQtfU5vj
	 7+bpABEV9/g68iORlP8kEVKLAUkNQibhTSi6DP0ST0pedZdvduo1U/iru7SD2GW8AwoOl
	 hNTyTsa6BEt0GeC189HvTEDp+SECiUcdn87M3feOUNGeUoCYUZAuzSiRfQ0XdcApuDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FLJt7xeV;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E51606A326;
	Wed,  4 Nov 2026 03:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50E51606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FLJt7xeV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jBo07fOEWVwUuN9u4WHUrXqePYbjYoVaNQovLhhi8es=; 
	b=FLJt7xeVbrruK9dl1EfStDNmT/eXoP41VWYc61uQoHO/NVsnVVfM8iUpSVku6SIYJ0zVWkNcdFV
	e9+dAoUBDUFeBcDrX2bX4/tjNRm646Rq5IDpJdNBn0f/yWoCJuTtsCSy7SdVWW8OSD3yyChilwtj4
	hJSO033W2f6d510VftXQzarE5VNkpNy6cGw7LthhGPe1CMESDEpWRQKbcb1pJUOE9GEOoOWvDdBfa
	8cJScxPAfIdpx4ZWnZlBsP9VsGfnRl2WfheGNks9e+aaMYszYHMYHTAsrCA1xveNoDP+MG0uNTuwz
	w5SczC3p/8LzmTqoIrPyFxNJFnXReRTeUf5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOS8U-0000000AisY-2lVq;
	Wed, 04 Nov 2026 11:58:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 11:58:06 +0800
Date: Wed, 4 Nov 2026 11:58:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
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
Message-ID: <auqtTjXhD8is-y9f@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
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
In-Reply-To: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>

On Mon, Nov 02, 2026 at 08:49:23PM -0500, Liam R. Howlett (Google) wrote:
>
> I don't follow.  Reverting that patch gives the same functional flow as
> the patch I already sent; kzalloc() for one branch and kvzalloc() for
> the other. 

I'm not talking about a literal revert.  But that patch is what
introduced the use of an unconditional kvzalloc for the !GFP_KERNEL
case which is what we are trying to undo.

So it should at least be mentioned prominently in the commit
description.

> We will, however, restore the useless __GFP_NORETRY flag to one branch,
> and a broken check.
> 
> -       if (gfp != GFP_KERNEL)
> -               tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
> 
> gfp != GFP_KERNEL is supposed to just send GFP_ATOMIC in here, but
> instead you are sending GFP_KERNEL | __GFP_NOFAIL as well.
> gfpflags_allow_blocking() should be used here, right?

That made me dig deeper into the original change and why it was
made.  It was actually Linus who suggested merging the two calls.
It's a shame that we have to bring this pattern back.

https://lore.kernel.org/all/CA+55aFxnrwFniJq6nCFn4pWRHLH-Wac9bVFKieBC-TixTsFg=Q@mail.gmail.com/

Let's add him to the discussion and see if he can offer any insights
on how we can avoid undoing this change.

To recap, kvmalloc was modified in 2025 such that it can use vmalloc
even when called with GFP_ATOMIC (commit c6307674ed82).  Unfortunately,
it does so in a way where it has to wait for other CPUs to do certain
work.  As a result, if you call kvmalloc with GFP_ATOMIC under an
external lock, this easily leads to a dead-lock when other CPUs end
up blocking on the same external lock.

Hence rhashtable is being asked to undo the change and reintroduce
this pattern to avoid the dead-lock:

	if (!gfpflags_allow_blocking(gfp))
		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
	else
		tbl = kvzalloc(size, gfp);

My feeling is that the new kvmalloc is simply broken but its author
disagrees.

> You are saying to add it to both branches of the if statement, right?

Nevermind, I didn't look at how alloc_hooks_tag was implemented.
This is simply disgusting.

But instead of

	if (gfpflags_allow_blocking(gfp))
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kvmalloc_node_align_noprof(
					struct_size(tbl, buckets, nbuckets),
					1, gfp | __GFP_ZERO, NUMA_NO_NODE));
	else
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kmalloc_noprof(
					struct_size(tbl, buckets, nbuckets),
					gfp | __GFP_ZERO));

, plesae do

	if (gfpflags_allow_blocking(gfp))
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kvmalloc_noprof(
				        struct_size(tbl, buckets, nbuckets),
				        gfp | __GFP_ZERO));
	else
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kzalloc_noprof(
				        struct_size(tbl, buckets, nbuckets),
				        gfp));

It would be even nicer if you could add a kvzalloc_noprof helper but
it's not a deal-breaker.

> The fixes tag should still point to c6307674ed82, since that's when the
> issue became visible.

Sure that sounds good.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
