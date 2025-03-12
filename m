Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B2165F13
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 02:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741747797; cv=none; b=M6Em6syS/xd80kiFf4NlSuPjrWMS0cRRQ2uRGxHXQfibAEtLkGQIXZDAYetYhu3xX8pAycQSozUyFK5ZLcJVNZXw0/9CmXyu8+2kcbcoB95bb+X8WcWztDFJHqgdFBXE/4ilETPqfMPsrv5XUWQFBLzQE4AWg5tQUeyWr9XigKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741747797; c=relaxed/simple;
	bh=CxadmD+9jLhWFUCZzTvhntZZExSfov4A/9pv849BJmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWNizWWJ3qcF1pOBIw9hxpgBLRVqKF0Oh8OFEOGvD4YKfks5g9a5aMSBKH+NMcaCZqVcor8XYZDdXNrPLCZVqzYNGa9IrvUtJHnx0XBEIxuwZHJ7EoUVoOVHePEEDzBmt36jwuXyMJHYhYzUfsQcmFLf3xR1ZCRy7kkQfDs4mAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsNeZ6PF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsNeZ6PF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B3BC4CEE9;
	Wed, 12 Mar 2025 02:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741747797;
	bh=CxadmD+9jLhWFUCZzTvhntZZExSfov4A/9pv849BJmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hsNeZ6PFoUEWBgKDB3a2HeKiMpJWWHAZw6dwRhsHqyS/jNPCahyuM9mLB78RHid3I
	 YRcV5MtQjcsKPIdhtNh6kVpEuE2sRVUNFKiJDKk4EB7/apzzJR8pwmqVDUxCQGwMf2
	 hePCjb+jLXd+lipRBgJsJUfuqjcC7xRU6+Z2zIEb6clOUaLfs7NoSnBRPFXYvrkP1y
	 zBNNa9oLN2QCbMzwON6btMlT4nux33CtEAfag4NkRMVsHpBInJ5/xq3EKuBUb038tq
	 fEQ/QCG1XGk8iuHwi5ORumPzlRkHFewVbL7irpGeOl4Sa1sIEb6ppWgEgngVtm3RpU
	 AZ+U3meI6nZOg==
Date: Tue, 11 Mar 2025 19:49:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/3] crypto: hash - Use nth_page instead of doing it by
 hand
Message-ID: <20250312024955.GA96961@sol.localdomain>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
 <e858dadf36f7fc2c12545c648dda4645f48cab22.1741688305.git.herbert@gondor.apana.org.au>
 <20250311174431.GB1268@sol.localdomain>
 <Z9DxroRzYKSu2u6j@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9DxroRzYKSu2u6j@gondor.apana.org.au>

On Wed, Mar 12, 2025 at 10:30:06AM +0800, Herbert Xu wrote:
> On Tue, Mar 11, 2025 at 10:44:31AM -0700, Eric Biggers wrote:
> >
> > I guess you think this is fixing a bug in the case where sg->offset > PAGE_SIZE?
> > Is that case even supported?  It is supposed to be the offset into a page.
> 
> Supported? Obviously not since this bug has been there since the
> very start :)
> 
> But is it conceivable to create such a scatterlist, it certainly
> seems to be.  If we were to create a scatterlist from a single
> order-n folio, then it's quite reasonable for the offset to be
> greater than PAGE_SIZE.

If it needs to work, then it needs to be tested.  Currently the self-tests
always use sg_set_buf(), and thus scatterlist::offset always gets set to a value
less than PAGE_SIZE.

And this is yet more evidence that scatterlist based APIs are just a really bad
idea.  Even 20 years later, there is still no precise definition of what a
scatterlist even is...

> > Even if so, a simpler fix (1 line) would be to use:
> > 'sg->length >= nbytes && sg->offset + nbytes <= PAGE_SIZE'
> 
> That would just mean more use of the fallback code path.  Not
> a big deal but I was feeling generous.

My second suggestion, making it conditional on !HIGHMEM and using nbytes <=
sg->length, would also be simple and would reduce the overhead for !HIGHMEM
(rather than increasing it as your patch does, just like patch 1 which had the
same problem).  !HIGHMEM is the common case (by far) these days, of course.

- Eric
