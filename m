Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F61E7F470
	for <linux-crypto@vger.kernel.org>; Mon,  8 Apr 2024 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712589515; cv=none; b=KMsbxQwRiiDhyyTDFHcDeJkiq6/6r6RkPqNdO/P6w4+eZ1uLy/DmJ+eev9mNgrnQ+e/jyMi74zSn+4km7l1YDkzk/7jBLgKqGvBD8R//YoJjxKcUwONnmx9hGGEesuU/shVdehjbIEAWp/wzg8Ip6XskjMdDpkk841ze/ZuvhlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712589515; c=relaxed/simple;
	bh=nSc9poOuGHd7JNNiLJZut3JVa3pVm9j6mYo7Ppbr/gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFkXDYlDDfA6bc7nyeo14UJ6AL8F1nrvxTL8Gq/biXCJuVHUHDBpRe+TOw/TJCdpNLVVUWRvTY6jAAH/3TtKE/xxWKG0OW2v5W2WPreFjzRsHNiREnZ5puQ/Y2iOvXxEJhrmRXVjJbJcIWYN0K0XknJefr2BAObJAW0sonBLja8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTl5kRV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTl5kRV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0356C433C7;
	Mon,  8 Apr 2024 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712589514;
	bh=nSc9poOuGHd7JNNiLJZut3JVa3pVm9j6mYo7Ppbr/gk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RTl5kRV8AJuMNp6vj3ozzA3FiqESTjfeLe3Q6lhCdQvLfV5/eERzikw+5Yofb+4cX
	 Ql1DIU0vV7kVMg6+RRPMSKVehfpynAEbk1Wu6I6yO79itIk9uItU6VhNnyZIciIAHt
	 ubAEEntXGqMpWHG5z71bxjce9zNK+jRkg5GK7i1QPpVhGPC1jewPMhVOAqpaaBTqti
	 GdDwg/tlkG1ITwnPD42eHxizfr2+8fQ+A1f+RsXK0PTf7zXdLJ3078fD1GQ9uM3knn
	 bTd3jOp7o2psx0iqBwUU1kiYMhHpXKldVZIZ6zAQruC+im2oFGK2bK1xtaGM+H1/Bo
	 KcnCMLE8ELQQQ==
Date: Mon, 8 Apr 2024 11:18:32 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Stefan Kanthak <stefan.kanthak@nexgo.de>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: s(h)aving 40+ bytes off
 arch/x86/crypto/sha256_ni_asm.S
Message-ID: <20240408151832.GE732@quark.localdomain>
References: <5EEE09A9021540A5AAD8BFEEE915512D@H270>
 <20240408123734.GB732@quark.localdomain>
 <9088939CC5454139901CEDD97DAFB004@H270>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9088939CC5454139901CEDD97DAFB004@H270>

[+Cc linux-crypto]

Please use reply-all so that the list gets included.

On Mon, Apr 08, 2024 at 04:15:32PM +0200, Stefan Kanthak wrote:
> Hi Eric,
> 
> > On Mon, Apr 08, 2024 at 11:26:52AM +0200, Stefan Kanthak wrote:
> >> Use shorter SSE2 instructions instead of some SSE4.1
> >> use short displacements into K256
> >> 
> >> --- -/arch/x86/crypto/sha256_ni_asm.S
> >> +++ +/arch/x86/crypto/sha256_ni_asm.S
> > 
> > Thanks!  I'd like to benchmark this to see how it affects performance,
> 
> Performance is NOT affected: if CPUs weren't superscalar, the patch might
> save 2 to 4 processor cycles as it replaces palignr/pblendw (slow) with
> punpck*qdq (fast and shorter)
> 
> > but unfortunately this patch doesn't apply.  It looks your email client
> > corrupted your patch by replacing tabs with spaces.  Can you please use
> > 'git send-email' to send patches?
> 
> I don't use git at all; I'll use cURL instead.
> Since the information on vger.kernel.org states "text/plain", no multipart,
> I assume that attachments are also not accepted?

Please read Documentation/process/submitting-patches.rst, which explains how to
submit Linux kernel patches.

> >> +        pshufd          $0xB1, STATE0,  STATE0          /* HGFE */
> >> +        pshufd          $0x1B, STATE1,  STATE1          /* DCBA */
> >>  
> >>          movdqu          STATE0, 0*16(DIGEST_PTR)
> >>          movdqu          STATE1, 1*16(DIGEST_PTR)
> >
> > Please make sure to run the crypto self-tests too.
> 
> I can't, I don't use Linux at all; I just noticed that this function uses
> 4-byte displacements and palignr/pblendw instead of punpck?qdq after pshufd 
> 
> > The above is storing the two halves of the state in the wrong order.
> 
> ARGH, you are right; I recognized it too, wanted to correct it, but was
> interrupted and forgot it after returning to the patch. Sorry.

I'm afraid that if you don't submit a probably formatted and tested patch, your
patch can't be accepted.  We can treat it as a suggestion, though since you're
sending actual code it would really help if it had your Signed-off-by.

- Eric
