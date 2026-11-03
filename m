Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670574;
	b=g7rC3xiJHBW639ejn9tNr+xdmEiSPTnNIip5kg44dHzRh5EhIoNAuP9o34lgIzyI/CZq
	 fymZZr8imAfSyA5e1KZG8PJpz8h9bPzbjOirhNJS5syZulV5XJlshbR+FSLeD/mcHcP1f
	 zD+f0a+Zhy3DpH3NTNxmcxBDVdWAz3t6iOS5U+bBPQysX1htUrPixHqxi8UsfNSFz1/Ok
	 3S4xKJqQcZZ8GcoKQsc6TurPJFdPfsCMsbqE5sZNn2+y6K+pw6wGg3pbrFuR/wVH75OwT
	 aRqNqOAICf+4nNUlw0bgZ37OziKWG/UxMRjHYcwiixatYM3R3gCj6ohPF8mBnq/aMmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670574;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=oqD5KjVEUEOf5ZVgC/hbD2wTa3fhBUi4PPSMQExmXq4=;
	b=GHd3H63kRvNZ47wTvtdzRkJXgInSSgdNZY75Vn5f6vw97V1RFasH6QFA7ysnq3S5vDVR
	 5taiHI/72K5aE7IqHgwCEDS04Z0Pm2SFPhGuJky1Gw90qOeVI0mP0BPuPe5isVLUn8Sx8
	 iv2A+pMF5VBznT2NSfzLsL7dzaALFGNOzRCUuT5k/r9NanpURe/uNhlpZo6popG29x7rt
	 pQCL2C9HmawaI4k3dLeLQGiuMZ5ApgHXuULzn5cndhdDlZ2P8oqxqJ4u6VC1CqLFtw1/x
	 rgo+vXDwBs3+v+oVco0umZOXJYk5MBSbTAJJNDsu0H9tgu4PmVHyicHXkhDbqcb2nQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=HMnnSs23;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D06B606A326;
	Tue,  3 Nov 2026 01:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D06B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=HMnnSs23
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oqD5KjVEUEOf5ZVgC/hbD2wTa3fhBUi4PPSMQExmXq4=; b=HMnnSs23htRHeD+t1FXWi56qQU
	kPaJq1I5j/zgCvQGnhWnpQywJkuRkZqvwjGZsMKrWXHfl2qdKOx1DObFxKsDHRH1vFhhs7CgyiJ1z
	h6tspKBuh2NCHFUFtlbdZ1NDITMe8KcbwrD8rBm3MQfa2hC3aRsM2cDf1kDW8HK6HoJaFNBZxLeI8
	FPr8ahYhpC59zyt4ZozA+Z38N+HYlvdIaFUWJGkWVOP9XYNc1xgHtjKQFZ98Zr1lnwu3eEQnSFoPZ
	TJmLSL/MyBwVtYi84PRuIDAxZ4T2ehO+femW09MTceV3Iztu3PxigLwucGnoDjDotL1sTmlr5JJ2g
	Ni7SNwNg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO3eT-00000000p01-3FoP;
	Tue, 03 Nov 2026 01:49:29 +0000
Date: Mon, 2 Nov 2026 20:49:23 -0500
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Davidlohr Bueso <dave@stgolabs.net>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
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
In-Reply-To: <auaFhOa5EBz4gJwK@gondor.apana.org.au>

On 26/11/01 08:19AM, Herbert Xu wrote:
> On Fri, Oct 30, 2026 at 08:56:03PM -0400, Liam R. Howlett (Google) wrote:
> >
> > Hubert, I have another version of this patch set to send out, but this
> > particular patch remains the same.
> > 
> > Are you okay with keeping it the way it is for this release?
> > 
> > I don't want to force your hand but I also don't want to keep a valid
> > deadlock scenario in-tree.
> 
> Instead of your patch, please revert the original change that
> added kvmalloc to rhashtable:
> 
> commit 93f976b5190df32793908d49165f78e67fcb66cf
> Author: Davidlohr Bueso <dave@stgolabs.net>
> Date:   Tue Aug 21 22:01:45 2018 -0700
> 
>     lib/rhashtable: simplify bucket_table_alloc()
> 

I don't follow.  Reverting that patch gives the same functional flow as
the patch I already sent; kzalloc() for one branch and kvzalloc() for
the other. 

We will, however, restore the useless __GFP_NORETRY flag to one branch,
and a broken check.

-       if (gfp != GFP_KERNEL)
-               tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);

gfp != GFP_KERNEL is supposed to just send GFP_ATOMIC in here, but
instead you are sending GFP_KERNEL | __GFP_NOFAIL as well.
gfpflags_allow_blocking() should be used here, right?

The patch you are saying to revert was correct when it went in.

> The newly added alloc_hooks_tag call should go after the if statement.

You are saying to add it to both branches of the if statement, right?

> 
> This patch should also be split out of your series and posted to
> linux-crypto.

Sounds good.

The fixes tag should still point to c6307674ed82, since that's when the
issue became visible.

Thanks,
Liam

