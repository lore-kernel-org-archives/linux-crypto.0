Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9621C3BE9;
	Sun,  2 Mar 2025 21:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740951471; cv=none; b=ZVftbys9YEMbndzTFWzCLSOgfsSaYNiKO8+NDUY9JRn/xCyV2rWINnbF4XjsCAOOJLqoocK6oARPvSwLWN2/rZWbJH8i1nLqBjsQef0Isnp2O+Ge4Z11Ol+MIu4u53KM5EfhCe486DRCJvybmL+KapymtcNpVLchvErOM3907gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740951471; c=relaxed/simple;
	bh=Wgxf63Ipcv8UPfI/p8lBtWriq28T9EuTCBgsysSB/ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+tbg9e7n2ENZAdX5D8pJUlUhBMqpqAqo39IYl5xS8cudLBFLVQK2gjlME/wcj7RC1jSMgdfM46d29lfVXyUvWGTRjQcwUqM8c+3LRJmYbXK5/IoaKLffO5N6dfdbp029uLJj9lsWG84EwDKSsfaIaNP8jImmQorlwyPDRQ7Jv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2cSkjb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2cSkjb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14005C4CED6;
	Sun,  2 Mar 2025 21:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740951471;
	bh=Wgxf63Ipcv8UPfI/p8lBtWriq28T9EuTCBgsysSB/ZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W2cSkjb26U0ynFm1Gh9VzneNWevOT3h/eUGeEaXwPyA0aLkp1e+iH31VGJ2zS2f4p
	 jj0EiThvfqTBzUIFGvgOVkn1LW6fzzbjEps5F8hNOBp10gvPCTdvjp+4eKFA7amN40
	 oNbwaasmDgxWW91XAZLyDljn1d/nzu1D3inRXjhACzPyP0jxnjxLb9z8+vM9Ypf3EG
	 sHdiCaWo1U+ZPei4AUitjTt65u0B/EKu74QZkEGr376e189FygCFQ5w24+IoQXDbRU
	 1JlIcAqQrG2NUKkdc6ubVItxKLYsSkr3Vepn5P8ZAyHnjrs+Bcvp7cxejztuhddKuU
	 eEavQscjhnPuQ==
Date: Sun, 2 Mar 2025 13:37:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 04/19] crypto: scatterwalk - add new functions for
 copying data
Message-ID: <20250302213742.GB2079@quark.localdomain>
References: <20250219182341.43961-5-ebiggers@kernel.org>
 <Z8P9eIGDlT3fs1gS@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8P9eIGDlT3fs1gS@gondor.apana.org.au>

On Sun, Mar 02, 2025 at 02:40:56PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > +void memcpy_from_sglist(void *buf, struct scatterlist *sg,
> > +                       unsigned int start, unsigned int nbytes)
> > {
> >        struct scatter_walk walk;
> > -       struct scatterlist tmp[2];
> > 
> > -       if (!nbytes)
> > +       if (unlikely(nbytes == 0)) /* in case sg == NULL */
> >                return;
> > 
> > -       sg = scatterwalk_ffwd(tmp, sg, start);
> > +       scatterwalk_start_at_pos(&walk, sg, start);
> > +       memcpy_from_scatterwalk(buf, &walk, nbytes);
> > +}
> > +EXPORT_SYMBOL_GPL(memcpy_from_sglist);
> > +
> > +void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
> > +                     const void *buf, unsigned int nbytes)
> 
> These functions duplicate sg_copy_buffer.  Of course scatterwalk
> in general duplicates SG miter which came later IIRC.
> 
> What's your plan for eliminating this duplication?
> 
> Thanks,

The new functions are much better than the lib/scatterlist.c ones: they have a
much better implementation that is faster and doesn't use atomic kmaps, and
(like scatterwalk_map_and_copy() which they are replacing first) they don't
require the unhelpful 'nents' parameter.  My tentative plan is to move them into
lib/scatterlist.c, reimplement sg_copy_buffer() et al on top of them, then
eventually update the callers to use the new functions directly.

However, the 'nents' parameter that sg_copy_buffer() et al take will make the
unification a bit difficult.  Currently those functions copy the minimum of
'buflen' bytes and the first 'nents' scatterlist elements.  I'd like to remove
the 'nents' parameter and just have 'buflen' (or rather 'nbytes'), like the
crypto/scatterwalk.c functions.  I suspect that nearly all callers are passing
in enough 'nents' to cover their 'buflen'.  But there may be some exceptions,
which we'll need to check for.

- Eric
