Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA35F18A6D2
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741191953; cv=none; b=cYvtusclnCE5MUbvxOJ1YbtG9WE0LM24z1mybShWN2eDe4+Kz0Aeh3Y9pUBQWJ7W/PCY4Nu+CMhnVN1jX/iip0GGlGI45gRU602QxiFzerGDGDyVgcHoM0HLWVE6Y7EKeRyJbhlvuTCKKDXv+qZZhTMJqZ1ch2GbqvN0OA0pdQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741191953; c=relaxed/simple;
	bh=fY2sA34oLrYjoyqVrb8CHTxjuhRSaZEbtm2ZWmy53oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/rVfE1k3XNSmVDqfQP/qYl7vgYSvMzy+3uOvwoIa9FURykPsbNj0oP0RTVCfDcoYSioM0GCQ1tTcU5Da8hKTFDDN0do4xiiTqwI5TDMYjTxyPTsCxOhd3dTpP6cY9NJchv0mnGW/lSfRsHChHmSJN1rlnDTc9cY7YCdvEXTZiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iZHQl6Vy; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iZHQl6Vy"
Date: Wed, 5 Mar 2025 16:25:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741191948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BvzCwylmaHDh0dH7GwicN8+TVMfSuvEGvsOBD/vsXco=;
	b=iZHQl6VySrCKvj/CpQVbXv35cw0/uaPgAFE8E9uNu4117Vwv3YHP/hHCo+NWQ6sUM5j6Y5
	pNd80Mv8L6Q9zNTvcJV9lpP9BYtTNLTcLkdlb44pDq76vhNVf5sueV9xkNTz1p8QAEWG8J
	tByHf2tlTOecQq+ZpnO9katFgT6Xw5Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8h7CJYO6OxkVXhy@google.com>
References: <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8fHyvF3GNKeVw0k@gondor.apana.org.au>
 <Z8fsXZNgEbVkZrJP@google.com>
 <Z8gBSgasXlu_0_s2@gondor.apana.org.au>
 <Z8hbZlCY-esYktJe@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8hbZlCY-esYktJe@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 05, 2025 at 10:10:46PM +0800, Herbert Xu wrote:
> On Wed, Mar 05, 2025 at 03:46:18PM +0800, Herbert Xu wrote:
> >
> > > Also, please take a look at patch 2 in this series for another reason, I
> > > want to make sure if your virtual address series can be used to remove
> > > the !virt_addr_valid() memcpy() case completely.
> > 
> > Yes it should work provided that you specify the memory as nondma.
> 
> Actually you can do better than that, specify the memory as nondma
> if IS_ENABLED(CONFIG_HIGHMEM), and otherwise as virt.
> 
> The idea is that we only have two hardware offload drivers, both
> from Intel and they're probably not going to be used on platforms
> with HIGHMEM.
> 
> So something like:
> 
> 	if (IS_ENABLED(CONFIG_HIGHMEM))
> 		acomp_request_set_nondma(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
> 	else
> 		acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);

Well, ideally it would be based on whether the address itself is a
highmem address or not, it may not be, even if CONFIG_HIGHMEM is
enabled.

> 
> Of course all this would disappear if we used SG lists properly.

Zswap is already using an SG list when calling into the crypto API. The
problem is that SGs (i.e. sg_init_one()) does not support kmap highmem
addresses. Is there a fundamental reason this can't happen, or is it
just sg_set_bug() using virt_to_page().

Also, since the crypto API is using SG lists internally as far as I can
tell, how does acomp_request_set_nondma() essentially deal with this? I
don't understand why we need to use a separate nondma API for highmem.
