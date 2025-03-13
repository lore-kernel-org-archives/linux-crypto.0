Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CDC27468
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 03:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741835637; cv=none; b=RSkYf83+eE5CaDOeiCUAVf4l/DXrI8fHyY8rcCmH8QlD0jlloqey+76/wHrMdbwiUobrKf5Idw65/WsMcMJPhvBng1D1LOX5sTD7F9S1TWqqEamH5GzvGCHKLCpX1TXA2teC2lXxrECvSaBictwpqKgU+5E4OoM/I0Y+Acf3COw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741835637; c=relaxed/simple;
	bh=TnnUwTAhbr3Nyv8ZJKs5YrrV2eFEnoL7N96jApUT9A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k373SApXJ9QrwH7F9nUYqCXkpTLHMWoPNshcC8c2aIy8CsOWtwCh1VD+P52RePhdQeHN0q4B3SBO0g9MEyapsiRzeRKIR1e8WLxIEwgxMat6eiaayKd4dx/AUkvGWLKTHeKMAvN+CrHacbLVNd8zMowfnymg0n0c4dnZOckbWYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uax6DT+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uax6DT+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB461C4CEDD;
	Thu, 13 Mar 2025 03:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741835636;
	bh=TnnUwTAhbr3Nyv8ZJKs5YrrV2eFEnoL7N96jApUT9A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uax6DT+gKco4kMCeN5BOBnV6ewST908ztC+F7+uS6Wbu1bg/DZRFaKzo1+QM26o+N
	 NDO2AbZ2FIOuj+G7GyhxJGPhfuxTs2wy7c93j6kD3Ao3E80zmjLUjaHObd1lkzZ/cd
	 AEel7RxOlgzjz+zf+UOQCW+G6PbEoIlaVjK0IVvu72ewxoFVuIqCEvPeFnhJhzzEfq
	 o4gCFmd1IGwbuU5/60mEsRS6dqbkDwtCt9k7QiToXIHElbWRZxROl+Zcsj+HxhII5f
	 HTxU3x13j6Xz5xftip4a3h5WkuyW1ZRdp94Q1PiedkWNO1Olq8m8U7Cfj8+Xy9y6pj
	 1xvh78TbMr7Sg==
Date: Thu, 13 Mar 2025 03:13:55 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of
 doing it by hand
Message-ID: <20250313031355.GB2806970@google.com>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <03f40ecd970de816686b233bd79406768dc66bbc.1741753576.git.herbert@gondor.apana.org.au>
 <20250312195622.GA1621@sol.localdomain>
 <Z9I4VBZ4hTWJYFw2@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9I4VBZ4hTWJYFw2@gondor.apana.org.au>

On Thu, Mar 13, 2025 at 09:43:48AM +0800, Herbert Xu wrote:
> On Wed, Mar 12, 2025 at 12:56:22PM -0700, Eric Biggers wrote:
> >
> > This change is unrelated and seems incorrect.  lowmem_page_address() is a mm
> > implementation detail.  page_address() is the right one to use.
> 
> lowmem_page_address is obviously linear, while page_address is not.
> For example, arch/loongarch does something funky with kfence and
> page->virtual so that page_address is non-linear even on 64-bit
> without HIGHMEM.
> 
> Sigh, it seems that they've overridden page_to_virt too so even
> lowmem_page_address is non-linear.  But that's probably just a
> result of people abusing page_to_virt.

Well, it looks like the intention of !HIGHMEM && WANT_PAGE_VIRTUAL was for
page->virtual to contain the linear address, as an optimization for
architectures where multiplication and division are slow and sizeof(struct page)
is not a power of 2.  So the resulting address would be the same, just gotten in
a different way.  __init_single_page() in mm/mm_init.c indeed sets page->virtual
that way.  But if there are now cases where it does not actually contain the
linear address as expected, then such configurations need to be excluded from
the linear sg entry optimization...

- Eric
