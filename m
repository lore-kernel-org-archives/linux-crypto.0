Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285642;
	b=tzC5GzVbL6yP9iLsZPBb5DkW9wvl+QVwy8U8RI9SlKq1ZUXE+Epj2vGB0hFQ5OG7rCtg
	 e2oJw7OAVCGsK5mobGMi+ef9w3gvUn7839sxE2SUiTgsfmEWmdnHrwN9itV66xmLjpTTW
	 mwfdymVcNCnfwNVcBipgPYEMGYdSjYVIt0ZEgpOV8rDIdGBhKKTfKm+PwHr0W1Ha5/7BL
	 uyF7fF2fvEFaeo/SB7YkhGdPPLZ37A3Kb/Y1uEx9sdBzhOZ/cw+uueae6g2Av6Ok5ipHl
	 u9khImVqb6e+HITom80iZ0FpLMcVA32s2Cer00y+yLQsQ8deiT/6+TLA3OoGcBNC7ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285642;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=afj3acdy9ojv0BvYV/YH41RH6XpHTpffhj1u2wt7WSU=;
	b=PhdTPomFX9bBd6nhR+XDDIAapUs0p0vjVZm5Q24/r1he7I3KcWqW6oVxb89yRTX+ebO4
	 Ln1xXcv9KnwSyq+X0YyZ+uvojyTzKGJ8+BcVHEMkYoQSRXESUtt4mWKxG0mhuGdR5Mr9M
	 gTm9TGVbVxZmSrQ/S2zCgHvgJ9mQPGXelhnNbwGD5DjZVJs7WTc1d25c1+8zejgDM7Lj5
	 bZBY3XFCGj4oXWucLVZos448NL+xrBE09nsPrf6lr/CPtYrXLcRZ7T+4E2FdLYvvCCfH6
	 zxHXvQBw02pO/Hkl5JtnEK8JyXuUzo6kNBj9+JckxL02ghQrBVOE4ePbUM4jJS/I02Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TEsYbTdz;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65349606A31D;
	Thu, 29 Oct 2026 14:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65349606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TEsYbTdz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=afj3acdy9ojv0BvYV/YH41RH6XpHTpffhj1u2wt7WSU=; b=TEsYbTdzMT+SODeK6nJ0Sxuj5k
	PYnCvw0cBUzpaPNfDihLevB+g+jDrtTZRPMr5dWfnLMh6Hw47nevYTLPyUTLFZmGEtyYJBi1E5oCu
	ij987NgFINqINwETRxDEjgnHHuDd227mpUm0O03tCEXEfQU2dx/EnS9xZyUlt3+CtutsZXazz1ulV
	nZORVAxWbmRgkjZYUBmzYODyvZbQ5fkHSbmdR2C8bAzSs/NxV+YZZUyuMICYg729sZrZT4euaIEsb
	PuoIBBwhMRy9jWMyu7Zn37u01Otx0SGFTR+sNWLDWCHqCFcy2FAQPi/80X7xfX1nrvS+iPWCLZDnk
	h8Q8hPgQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMRVw-00000009aWz-0hmY;
	Thu, 29 Oct 2026 14:54:00 +0000
Date: Thu, 29 Oct 2026 10:53:56 -0400
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
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
In-Reply-To: <auMbCuecFeRmBFSK@pc636>


Sorry for missing the ML in my initial email, I missed it from
get_maintainers.  I should have really clued in with such a small cc
list ;)

On 26/10/29 11:08AM, Uladzislau Rezki wrote:
> On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> > On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> > >
> > > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > > while another CPU is inside vmalloc() or vfree():
> > > 
> > >     RTM_NEWNEIGH                      vmalloc() or vfree()
> > >     ============                      ====================
> > >     spin_lock_bh(&br->hash_lock)
> > >                                       spin_lock(&vn->busy.lock)
> > >     rhashtable_insert_rehash()
> > >       kvmalloc(GFP_ATOMIC)
> > >         vmalloc()
> > >           spin_lock(&vn->busy.lock)
> > >             waits for the other CPU
> > >                                       softirq: a frame for the bridge
> > >                                         spin_lock(&br->hash_lock)
> > >                                           waits for RTM_NEWNEIGH
> > 
> > I think this is a fundamental bug in the kvmalloc non-blocking
> > support patch.  How can it be used at all if it is susceptible
> > to such dead-locks?
> > 
> > And if you can't use it safely why don't we just get rid of the
> > broken kvmalloc non-block path and have it always go to kmalloc
> > like it did before?
> >  
> If we have a look at this as we did not have vmalloc() here:
> 
> 
>      RTM_NEWNEIGH                      foo() or ...
>      ============                      ====================
>      lock_bh(&br->hash_lock)
>                                        foo()
>                                         lock(B)
>      rhashtable_insert_rehash()
>          foo()
>            lock(B)
>              waits for the other CPU
>                                        softirq: a frame for the bridge
>                                          lock(&br->hash_lock)
>                                            waits for RTM_NEWNEIGH
> 
> Same issue?

Looks like it to me.

> 
> I have a question:
> 
> GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
> not hitting ABBA dead-locks or they are not interrupted?

GFP_ATOMIC and GFP_NOWAIT can be interrupted.  It's more about not
waiting for reclaim (kswapd might still run) and GFP_ATOMIC might dip
into reserves.

The issue is that kvmalloc() now falls back to vmalloc() for
non-blocking flags (I am restating this to make sure I'm not missing
something here, please correct me).

So this changes what is called internal to rhastable so it doesn't reach
vmalloc(), like before, if the caller cannot block - they go to
kmalloc() with the old fall back.

I *think* the question is if the change should be here in the caller,
internal to mm, or a new call to opt-in.

Considering this is the only kvmalloc() caller that forwards
non-blocking gfp from BH lock + softirq context, I think that it makes
sense to do it in the caller.

Given where we are in the release, this fixes a real issue that can
happen so maybe we take this now and settle the general handling later?

Thanks,
Liam
