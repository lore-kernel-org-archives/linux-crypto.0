Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408169;
	b=rC4GZFuhKN+iuR0LGzIapLHuojyUiaE7z1j3iSBdm0JHi/WKjt3uyvWZz2+XK22IQRgo
	 zGTbVuB9FaX3XoXBSP3Pv/leta87OCfNrM2ZZPp77zZ4J3QZ9GrOpIcX8bnOAYoBgcWsM
	 iDdxJOnK67FrG0gjsEJP8BBd/PjSmQiFByJrEpiYTDCzhGmTRzaqOlsY8m94iBKkGMw1P
	 iwD+4lRvNaJ0JF6mJzJ5xFFrY9Ivh0h0RfCDnLRN3CbdWxgSpRfvmiqMRKRHJsQ75h765
	 MUPRciQiR44NC58P6xiYU8HjJ5YQiJ0k9Pd1ogiVyHkETHSSibrETq8gplK5JUEUJ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408169;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=NNZ0jWpXyvTAI1fGB9HbbXYilWwVTrHzAZcnT/C24Ac=;
	b=aeaZIpZj9Dcnjf50Fgr7h9VETg3Kellr/V4p43lI8DgO998DTccrLfh4ocKow77aJjMr
	 VSLdEwFytwzUN4hqetK5dKOjfoCLE+CBVAHguxh3MAS66JiC0+1vOxHv6gwayvKDVXK7m
	 /JEsh6/uMkZ1y8sJAlxZUfxCPOrgFYuwFkjQZ50GfrnTF69p9zM7/dGJLSlzEJG04l/vX
	 46Z9EKi8WJ66noTsU4LktVslkCxZnsRVdmkFDjOqhXtptPCVinHwDnBLlOeAEYMVhrOUu
	 LwJu9O4e+oQ4aJ/IBmCVrT5h7CvTCaW2xwTyVIOUSIz5ct9Wz/fd4rNoRC0FBQJHzwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="RWB/ouch";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445EF606A31A;
	Sat, 31 Oct 2026 00:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 445EF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=RWB/ouch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NNZ0jWpXyvTAI1fGB9HbbXYilWwVTrHzAZcnT/C24Ac=; b=RWB/ouchWeYcNlfYevA/mj7l9N
	cXBd9jmS0mL/cCVzaorN/VcfjaeExVPwuO0LbceCUiGeqGCEij0CLT5Ovi8h501hFGB70Kh2Ggi3P
	aapHxvhOQ4B7J0PQn97CMaQwoJZgYWp8wBUwVrAmTxrE5Z9COzjOnpUNnV8NyWpBgpCTCOCnTr6bN
	6AZsN6OCZl32yis0lLPscYGyMJ5nm3vo+sKP+SvRto8LQam2FWXxXJeERxnAgMQL4AoooO1tIyQFF
	AXZAU8gYN4FMtVGGhRLtmvP+HZTHXiVAoY5Efs/iYK0KQXINtj/+co/ipfhw5exzZJKYAxdZkhpdy
	1OlossLw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMxOA-0000000CoBp-1cwP;
	Sat, 31 Oct 2026 00:56:06 +0000
Date: Fri, 30 Oct 2026 20:56:03 -0400
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
Message-ID: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
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
In-Reply-To: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>

On 26/10/29 10:54AM, Liam R. Howlett (Google) wrote:
> 
> Sorry for missing the ML in my initial email, I missed it from
> get_maintainers.  I should have really clued in with such a small cc
> list ;)
> 
> On 26/10/29 11:08AM, Uladzislau Rezki wrote:
> > On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> > > On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> > > >
> > > > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > > > while another CPU is inside vmalloc() or vfree():
> > > > 
> > > >     RTM_NEWNEIGH                      vmalloc() or vfree()
> > > >     ============                      ====================
> > > >     spin_lock_bh(&br->hash_lock)
> > > >                                       spin_lock(&vn->busy.lock)
> > > >     rhashtable_insert_rehash()
> > > >       kvmalloc(GFP_ATOMIC)
> > > >         vmalloc()
> > > >           spin_lock(&vn->busy.lock)
> > > >             waits for the other CPU
> > > >                                       softirq: a frame for the bridge
> > > >                                         spin_lock(&br->hash_lock)
> > > >                                           waits for RTM_NEWNEIGH
> > > 
> > > I think this is a fundamental bug in the kvmalloc non-blocking
> > > support patch.  How can it be used at all if it is susceptible
> > > to such dead-locks?
> > > 
> > > And if you can't use it safely why don't we just get rid of the
> > > broken kvmalloc non-block path and have it always go to kmalloc
> > > like it did before?
> > >  
> > If we have a look at this as we did not have vmalloc() here:
> > 
> > 
> >      RTM_NEWNEIGH                      foo() or ...
> >      ============                      ====================
> >      lock_bh(&br->hash_lock)
> >                                        foo()
> >                                         lock(B)
> >      rhashtable_insert_rehash()
> >          foo()
> >            lock(B)
> >              waits for the other CPU
> >                                        softirq: a frame for the bridge
> >                                          lock(&br->hash_lock)
> >                                            waits for RTM_NEWNEIGH
> > 
> > Same issue?
> 
> Looks like it to me.
> 
> > 
> > I have a question:
> > 
> > GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
> > not hitting ABBA dead-locks or they are not interrupted?
> 
> GFP_ATOMIC and GFP_NOWAIT can be interrupted.  It's more about not
> waiting for reclaim (kswapd might still run) and GFP_ATOMIC might dip
> into reserves.
> 
> The issue is that kvmalloc() now falls back to vmalloc() for
> non-blocking flags (I am restating this to make sure I'm not missing
> something here, please correct me).
> 
> So this changes what is called internal to rhastable so it doesn't reach
> vmalloc(), like before, if the caller cannot block - they go to
> kmalloc() with the old fall back.
> 
> I *think* the question is if the change should be here in the caller,
> internal to mm, or a new call to opt-in.
> 
> Considering this is the only kvmalloc() caller that forwards
> non-blocking gfp from BH lock + softirq context, I think that it makes
> sense to do it in the caller.
> 
> Given where we are in the release, this fixes a real issue that can
> happen so maybe we take this now and settle the general handling later?

Hubert, I have another version of this patch set to send out, but this
particular patch remains the same.

Are you okay with keeping it the way it is for this release?

I don't want to force your hand but I also don't want to keep a valid
deadlock scenario in-tree.

Thanks,
Liam
