Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E569C2E3390
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 03:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741835264; cv=none; b=G1lik7mm6AzmK8cWAaH9p2HMdtBy4YtdjWeBPd7SAS0h/8UmvY+tWOa4heVQHE6mOBJxD1Dkbrtxa6xtrT7/mnyFYwblkARX516B6kWDfqdOhVohRzjI0YDALHrHbc9w6+Tt/lseQR49HeDDxpa80iAkHQbJVIWwL/ljFuaXeGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741835264; c=relaxed/simple;
	bh=1DJsKTzJ4JJeYLJcg2jc70RlSM72Zti0mCoKFD1/sSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LMDZiVXsEdBOE4wSj/Ew2TOUZLnkGtVr8W44Q48UGpfOmWIAgNoCbfYmGHHpHGSMbp+0KjgEMQ7ATeEfbgXR1yhYQtzBodjIdGuUXg9GCQOSokVJRxvJcLMXaFb7uhDkkin9Tehja7VafUhPpdAUnXlgZvQj4iJNGFlZHILOEfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1eaHv9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1eaHv9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DE0C4CEDD;
	Thu, 13 Mar 2025 03:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741835263;
	bh=1DJsKTzJ4JJeYLJcg2jc70RlSM72Zti0mCoKFD1/sSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q1eaHv9WDJqpNMwnWFComFJ8QgslvfaeXejXJNN+B+Vhd6rHM+6Wb9bPymoLB0PV0
	 Pmovlz7qg5QVA7gaYhlU5TKoseCiR82DzyKWkAijLFj59zPJ0glnhDzAYcFthP3ClG
	 t9rV4GyYzEufdDgFMBvwuFla2J1WUZZIJJRXiW19kzIclWHX7n9dXBl76SgGtolAtC
	 Jjjc9pk7UWnwPqkz8FKrOKIidGPplJcknX9HmTgygjoQNb27fWKdRrIQicY19fa1f6
	 t70qhPd9DetFncu8ZSk2zBDFXRKXeU0LTA4JamclcQ9SS5vg1Tg6gNshYDXRnYqDys
	 9Y4J2QI7miThg==
Date: Thu, 13 Mar 2025 03:07:41 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/2] crypto: hash - Use nth_page instead of doing it
 by hand
Message-ID: <20250313030741.GA2806970@google.com>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <a68366725ab6130fea3a5e3257e92c8109b7f86a.1741753576.git.herbert@gondor.apana.org.au>
 <20250312200908.GB1621@sol.localdomain>
 <Z9JEvCT-3Q6BUnOt@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9JEvCT-3Q6BUnOt@gondor.apana.org.au>

On Thu, Mar 13, 2025 at 10:36:44AM +0800, Herbert Xu wrote:
> On Wed, Mar 12, 2025 at 01:09:08PM -0700, Eric Biggers wrote:
> >
> > It seems that the "real bug" mentioned above is the case of
> > scatterlist::offset > PAGE_SIZE.  That's unrelated to the nth_page() fix, which
> > seems to be for scatterlist elements that span physical memory sections.  Also,
> 
> Alright I'll try to split it up.
> 
> > Note that there is also page arithmetic being done in scatterwalk_done_dst() and
> > scomp_acomp_comp_decomp().  Those presumably need the nth_page() fix too.
> 
> Thanks, I had missed the flushing code in scatterwalk.
> 
> As for scomp yes that's already fixed in my acomp series which I
> will repost soon.
> 
> > scomp_acomp_comp_decomp() also assumes that if the first page in a given
> > scatterlist element is lowmem, then any additional pages are lowmem too.  That
> 
> Yes I've fixed that by changing it to test the last page rather than
> the first, assuming that highmem indeed comes after lowmem.
> 
> > sounds like another potentially wrong assumption.  Can scatterlist elements span
> > memory zones?  Or just physical memory sections?
> 
> Theoretically it can cross anything.  Check out the block merging
> code in __blk_rq_map_sg, it tries to merge any physically contiguous
> page.

Actually the block layer avoids this edge case.  See the comment above struct
bio_vec, and the corresponding code in bvec_try_merge_page():

        if (bv->bv_page + bv_end / PAGE_SIZE != page + off / PAGE_SIZE)
                return false;

- Eric
