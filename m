Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A180C2750FB;
	Mon, 13 Jul 2026 04:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783918541; cv=none; b=Qol3qBVGnlDoQZ6cBHhDSG2xCiwDWbr56yevKGfhQx9lyxlyJUByr/PoyichfZjKgUdiiMZFNSl46JsQjhyMvuRjx94Npou1aSsSovAP62fiAtodb2f+g25mf/pZnKDlwtYnE33TAUcM5TP8wzNTmjqHmCPpqcY+cZB+P5QtrZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783918541; c=relaxed/simple;
	bh=u1ZsFBXEMYa3pV70UjOsgy5j6OmJ8iZJQvdWpzgequc=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=csmzecBVLtXPwQ5O59NG3kL+uPg0COU64RI1BoCSOjNzCmL93b+ERSwPcNmwTkILpRAT8cvZj2rU3oDC8tb/x0xX54xS7OT11ha+hm3fO+tVA9evLAZL2HhszkL1NBk6FufBSPpW6PCbLrF1idwusgOMj8E9PJ7/vpmOrXwssPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=XDlnsJsJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dnBVxpwl; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="XDlnsJsJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dnBVxpwl"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id CED1DEC013A;
	Mon, 13 Jul 2026 00:55:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 13 Jul 2026 00:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1783918537; x=1784004937; bh=9cm2STz00F8mgRSpCNZ2V/tU+0L+TJSmgwB
	+5g0c5M8=; b=XDlnsJsJUShy2VUBhHZfplbw4J3ShLjnALPKLuU1LuEZAKte9Hm
	D7a5Ff3SzetNpS/S1cskQAHoCQMFxzJX4htccXvtbeq6Lvu6h6HU1U6U5aP+oy7G
	OeJVG7HUIIEJcPzVbXGfE7TwdjTYQpslA6MmsuU5BjDKxWAOww2BBcegOrW2Q3Ix
	oQC+ndniS/aoFD9wYLiTQ+z/V0ij0o0jDqblXyBuuCM5XGIvzyJ81vX0XUThR0dO
	Pt3brR9pQStcO11Lz2FDtb2+cAQ0L1qgSlfM7btquGtbr7vI0fDMdRVC+N10kVef
	unLpxcQfgR3YFHjr4EwjnW27jESTWlw0yYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783918537; x=
	1784004937; bh=9cm2STz00F8mgRSpCNZ2V/tU+0L+TJSmgwB+5g0c5M8=; b=d
	nBVxpwlZEQaRO/YPY4kdSg9fKajSoLeSrp1nyJXw294av97mXZzJNp9+E0rXQWsF
	3F7PPKycwvlqot4JaNKjCyASo86P/psmOalxWCczV2hs95/pcNQD+yAVv1/tsya7
	0zQxwH3GtYxS0FNXXqTGEZ0vNF8+scys2RJ95PMYdMRh8xlwEH5Gc2mT6YR6tTff
	PF2sznHR0kaR/8jqFUnN/DiVCMX4DAX+J0cbYElcn71Tc+Z+nrSaZiuj5tesPl+L
	k/1zRV0b8qCSX8eZ0Jreqq+uhanVLWaU5uBRso05BSkPq0BMXJE62GXI6sk23d0p
	1gRvw3C2PFqD1c7ByiWOg==
X-ME-Sender: <xms:yW9UapkGs5l7BYwTVJrr2K6s1HtgajytqJpDS420_HnFoGaqXV4J9A>
    <xme:yW9Uan5GqDwfT7VqIJl49qj6Jm5cw3grdVBWnVbtRb4jBj-AM7nQ84O61jvucqDdJ
    lL_6v9VFKbzpvkfzcWVkMYIOkY7H37pDmeQwU2VZDgZUJYotA>
X-ME-Received: <xmr:yW9UaqQPQZ-qx3jWhjvhv22lAO2Qwm_i32NXcudLxZbTbNYuleOvJpwx_h-8P5W8eUSQzFdyg_wtowGTRjr9IO7kms6CvxU>
X-ME-Proxy-Cause: dmFkZTGTcYkkfixgXukOe5QU9KnrvyVO7D/qmM3J8s94+XmPVKLtbPzoXY9UknH5ozO5DT
    K0qC4XXR+6VSvw+u8RDBSilYcSJfp7Lvcvqeovgn758H/+eVfCGR16TmjkifGm9SGONztG
    zKU4+VUjwYs9IosHCpiw/Oy4wOqbzkBN01sbczDIEPpxt9ELSGBbgdwXi4AFheZJBiAwYI
    fKcaNMr41sig1sJhqpZURbJSBk6N3zUSOnEoQFgvAokbelO7qk3EbZczkj+Oc0cpMeb6hi
    xKRE1nblr1o+qpS/f20puSDoYTXJB4HbGiQmXBz+wwxZYtnJ+l+rRH6qGe7vTOym73aiQ7
    VTojtqT/7bbYmQPaTBfvSgqMuXIY+Hlh55b1QE0gPHzKfY9irUr9kQrj90tHy84d2Iha2k
    VwvrhD12wmdv+ME4blVOjVuM3c1zD4U8KJvsY8m3lFZDKH5F1y+1I21pnVVxnLYu0+xdC6
    lTklM5ikFQHotOQXFHyVxMOrET60qkTw4Ar6vJz3LViXIVAvFTKc5gXtXdGrw3BQ/DZCI+
    vLKAafcxY7Yzyr0BoWFzpJeBOmqtZ4Azb+SaeLuzjng+FafH3BLtJ9i0JYHAcKbAXATeNo
    4Fotyw744vS70TOV3k/FCTbjYclMneZT8xTj3k8XjdHqhDGuHk5TUNIoTn2A
X-ME-Proxy: <xmx:yW9Ualx4877aTQgAqfrQE_sQ7lm4h50GC7fv1i1CbEw6KxvOFcrD1g>
    <xmx:yW9UaipQXVzvSBJVmOd3sZWp31hufD6E6EULYBe_cfEMP3HWL_ODtg>
    <xmx:yW9Uao3u6j5a6xcIBF2W9zumAbmR77acdI-sRGZYze2mBXkG0wGc3Q>
    <xmx:yW9UaiwC0ZXWUs5rPZ2k8lqRSC8HSOIC-8k8YaFa40BsJwLxpqnQYQ>
    <xmx:yW9Uap9GZ-AXAMsrLi_71DYwxQX_EFBBjjC8Nk-3KsMMUppb8wyYqrbC>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 00:55:34 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>, tgraf@suug.ch,
 akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
 tgopinath@linux.microsoft.com, kys@microsoft.com
Subject: Re: [PATCH v3] lib/rhashtable: clear stale iter->p on table restart
In-reply-to: <alMDzpDrUzdB8e0r@gondor.apana.org.au>
References: <20260707164115.4979-1-blbllhy@gmail.com>
  <alMDzpDrUzdB8e0r@gondor.apana.org.au>
Date: Mon, 13 Jul 2026 14:55:31 +1000
Message-id: <178391853109.3371781.15191213695629915459@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sun, 12 Jul 2026, Herbert Xu wrote:
> On Tue, Jul 07, 2026 at 12:41:15PM -0400, Cen Zhang (Microsoft) wrote:
> > rhashtable_walk_start_check() has two restart paths when resuming a walk.
> > When iter->walker.tbl is valid, it re-validates iter->p against the table
> > and sets iter->p = NULL if the object is gone.  When iter->walker.tbl is
> > NULL (table was freed during resize), it resets slot and skip but forgets
> > to clear iter->p.
> > 
> > rhashtable_walk_next() then dereferences the stale iter->p, reading
> > freed memory.  This is a use-after-free.
> 
> Maybe I'm misreading the original patch (in the Fixes header).  But
> it seems the whole point of having it is to look for iter->p in the
> new table.  Even if the hash table remains the same iter->p could have
> been freed since we hold no reference to that object.

Certainly it could have been freed or removed etc, which is why we look
to see if it is still there.
It could even have been removed, freed, re-allocated, and reinserted in
the same chain.  In that case the behaviour is no worse than before the
patch.

Before the patch, "skip" was always used to find were we were up to.  If
something had been removed, skip would be too big and we could miss
something.  If something had been added, skip would be too small and we
could see some things twice.

After the patch we can fall-back to using skip, and if the pathological
remove/insert in same chain happens, we could see some elements twice,
which was already the case when something is added.

The key win from the patch, as described in the commit message, is that
the caller can provide a guarantee.  If it does something to ensure that
the last returned entry is *not* removed, then it can be certain that
walking is reliable with no dups or skips.  If does not make that
effort, then it gets the same guarantees as before - concurrent
add/remove and disturb the walk in unpredictable ways.

I think that patch is good and fixes a problem that needs fixing.

Reviewed-by: NeilBrown <neil@brown.name>

Thanks,
NeilBrown


> 
> If that is the case, then resetting iter->p on a resize doesn't
> fix this at all since the root cause is that iter->p is being
> held with no reference.
> 
> I think we should just revert the original patch since the whole
> concept doesn't seem to work (although it's salvageable for the
> non-rhlist case).
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
> 

