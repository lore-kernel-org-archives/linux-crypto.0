Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C36348C5D;
	Mon, 28 Sep 2026 05:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790573604; cv=none; b=TGH6EKgMV2tA0OxX7wKZDnNJ0w/dk1pCRp1VQAz9fkylZjOE1X/mOIndSXoqNZljVDR6VE5YyM5ASy0Chdl8mVRjG2ibn5Mx5sztP7EUBCcxoI8GknfEJuSdpiigAPtKQ1g3TEA3IEuuiaPwiIiFKwV/ee4erJymfcX2Wgch7OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790573604; c=relaxed/simple;
	bh=7VffACvwrxgH44hyyh1YKeoQx6o+nO94kkYo3o7IfAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m0RTjbUdg/5NSi6AconFJfJsfLdUA0XekUnoVT07W+NxZ56QeV7yDqsaz1ESy8YS6oy/nIeyrhXSEhfvNDVyTAEwEddmFf+XCyWJL0wlX9OcYXaEXnxOzXM2ojM/ovX/jH2llU7hiMefFZ26rQQLjArAyBn4pmNeqUxScArnnM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jeETeVMT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jeETeVMT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iM47se4qfvuI4d4y75YdY6jAlSO3cXcJnXGy35GIXBU=; b=jeETeVMTo5e38w1vmCqZBxsLV/
	qJSP5a2ykdeo8IAJXs7+5Lk8xpBMhyy/1lDVdMOdG84ZHdelq4oaxniKIG6lJrjSE6dcnZjmeh9Ik
	XLM6fmCdLdxQXgcHfGmojB/Oud4npwzSgyQzHC1JRzUCYHyuNmsOh15JZEUDz8IrFJW0UjOZ6YrjW
	5cQc9Tp3wIdkZHXgKHWC2eD2Ts/D5aPwI3+GVWjRXmwpDXPy890Lbe/N60tNm/YKL0m1GW8SV22tl
	dRIlABnBS8Gm/B65EdX172jRa3gVZ5MM/Ld7NjyaXfheIz8JKah/CXiH3U0Jx5iJZSXEH6soFg1PR
	D9cFV21w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB3zO-0000000HMu2-41wT;
	Mon, 28 Sep 2026 05:33:22 +0000
Date: Sun, 27 Sep 2026 22:33:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leonid Ravich <lravich@amazon.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	ebiggers@kernel.org, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, bmarzins@redhat.com
Subject: Re: [PATCH v6 0/6] crypto: skcipher - multi-data-unit request
 splitting
Message-ID: <arn8IlMrTCEmdhy7@infradead.org>
References: <20260924075846.28203-1-lravich@amazon.com>
 <arY6lzQtvVzUGngU@infradead.org>
 <20260927071422.12143-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927071422.12143-1-lravich@amazon.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 27, 2026 at 07:14:14AM +0000, Leonid Ravich wrote:
> On Fri, Sep 25, 2026 at 02:10:47AM -0700, Christoph Hellwig wrote:
> > On Thu, Sep 24, 2026 at 07:58:40AM +0000, Leonid Ravich wrote:
> > > * No throughput *win* is claimed for software AES.  The win is for
> > >   accelerators that amortise setup across units; the software split
> > >   exists so the interface works on every existing skcipher today and
> > >   goes quiet as algorithms gain CRYPTO_ALG_REQ_SEG.
> >
> > So what is the use case?  So far all crypto driver we've seen have
> > shown to be slower than cpu.  Which one are you using that isn't?
> 
> The engine we use is out of tree, but it is not a special case.  It

It is.  Without you having an upstream stack this is a complete no-go
to start with.

> is an SoC-integrated, DMA-driven, asynchronous xts(aes) engine of the
> same class as caam, ccree, qce, hisilicon sec2, inside-secure and the
> Marvell CPT drivers already in the tree.

Pretty much all of them are broken as f***k everytime someone tried
to use them.

> For a DMA engine the scatterlist is not overhead: it is what the
> hardware consumes.  The per-sector cost it pays is the per-request
> cost, and unit_size is what removes it.

Yes, it is.  Take a look how the scatterlist duplicates information
already handled by the upper layers.  We've been through is a lot
and are moving to the dma_iova_ API because of that.

