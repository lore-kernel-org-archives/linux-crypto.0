Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA21271277
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 21:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740692646; cv=none; b=tJddYcZZcvGcU0HhsJV4z9OhlHVXg4HAKvqJwo57guN/3GDDLuihHy4lIIXUyeBG958NjLbYuXLUkPmEQpgStJXOxFx9VmvzC/KCnm8nFjpt4ehiCFKN487u3a3fXPP45lBz9KNOezgII7FVwz9jlbw8Gx+2FSgdjsz6nY3hD4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740692646; c=relaxed/simple;
	bh=/5Y+LBE7DbFotVpy4NBgQuM8l1BqDrgKvNToULil20I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWo7YwpvVP8idScFgtaq5JgqWmhg7wjdSc4eHA5QatuuK3zu+sT4HZ82k/cO1guR+s3fW7IpJ1Q/uZmSQ2BDPcS26+YrijbDxbPXuGHF2kk/1XGC99rHWerwtCnIrkzhDOCcTIGtbwHLP1uX3D8XCRRPmPgL1eBkglxX9zwDJx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pF3jnskV; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pF3jnskV"
Date: Thu, 27 Feb 2025 21:43:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740692639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R3J/jMHXhUSZzVKv3voPrDtYcA94hPCQdrj69IWAc58=;
	b=pF3jnskVNlupMHwT1GaoMwwvwrdHsBCXLLiVSV7eohPN0OG6HXf07ruESq4ZkqQ3p8fhoi
	QQ3SLdMZRhU5RrTDEp578wvwt8XWUYSR20NqlMBRuN/3WesC1mxhHmfuZpUnxTN/2GsAR5
	rz2qe4/W5LxlXq/LOaEBPZA8DrNrhqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8DcmK4eECXp3aws@google.com>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227183847.GB1613@sol.localdomain>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 10:38:47AM -0800, Eric Biggers wrote:
> On Thu, Feb 27, 2025 at 06:11:04PM +0000, Yosry Ahmed wrote:
> > On Thu, Feb 27, 2025 at 06:15:09PM +0800, Herbert Xu wrote:
> > > Use the acomp virtual address interface.
> > > 
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > I can't speak to the rest of the series, but I like what this patch is
> > doing in zswap. Together with the recent zsmalloc changes, we should be
> > able to drop the alternative memcpy path completely, without needing to
> > use kmap_to_page() or removing the warning the highmem code.
> > 
> > Thanks for doing this!
> 
> Well, unfortunately this patchset still uses sg_init_one() on the virtual
> address, so AFAICS it doesn't work with arbitrary virtual addresses.

If we cannot pass in highmem addresses then the problem is not solved.
Thanks for pointing this out.
