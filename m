Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B8D20E03A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280306; cv=none; b=jTb1dP1z5Cnqdch8cG5i7MAX7jF+jt1jjk3WYI3uiuFzsw7AM5IikstxfRkpA1bpG47190Y/D1ZfW/ru5K6OtOHyAPF6zJ/IM/g7qjYBqLdTH4SsjXANizXjUWV8E8u7oKu6dBZpjXZO0G3nJpaKtQi9md5YL3MIXjpOo0o8bSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280306; c=relaxed/simple;
	bh=/VqgkcWc9N77tKGl7VXnxYYnUBXDa6AG07pjSDlJapo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEvjb61WgP67DR2cavt94za4XwDmleJmO3pTMGaaSByGALUeMUUuF6d8XqPjFh5SIl/4/0r3qrL+QAIVuZd2oobg+xmkn2zMYX4auMmvPyXTtM9KZfMmU21+2VOlyU8RSCu53g8MHl1wZWu5ue+l4sfsVFqb9ylgkAQNMDKDnAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gm2vaxi5; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gm2vaxi5"
Date: Thu, 6 Mar 2025 16:58:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741280299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bxRazIvJEGNH5PVFbt7GI6DugbAZvTodK1oAlzbYoWo=;
	b=Gm2vaxi5nFtGcLmN1dR1DKbNBVnzkVUAwVh4n09///Xbch+KqF2Bh5qcFOvQtgcnghcB9j
	1Jtj/Sbwd0YAJse+6Et9XaO20QlLiDVOZ4+SYDeTKQUpFWIWS5ZKxaQEegYsiNlSCb5XT2
	GArUNBIyXntq8wE2X8xnf2hrd1Bjc4k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8nUJthcnw0KZpYB@google.com>
References: <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8fHyvF3GNKeVw0k@gondor.apana.org.au>
 <Z8fsXZNgEbVkZrJP@google.com>
 <Z8gBSgasXlu_0_s2@gondor.apana.org.au>
 <Z8hbZlCY-esYktJe@gondor.apana.org.au>
 <Z8h7CJYO6OxkVXhy@google.com>
 <Z8ju-_hOYV0wO1SF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8ju-_hOYV0wO1SF@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 06, 2025 at 08:40:27AM +0800, Herbert Xu wrote:
> On Wed, Mar 05, 2025 at 04:25:44PM +0000, Yosry Ahmed wrote:
> >
> > Zswap is already using an SG list when calling into the crypto API. The
> > problem is that SGs (i.e. sg_init_one()) does not support kmap highmem
> > addresses. Is there a fundamental reason this can't happen, or is it
> > just sg_set_bug() using virt_to_page().
> 
> The whole point of SG lists is so that you don't need to kmap it
> until the data is actually accessed.  Putting kmapped memory into
> the SG lists defeats the purpose.

I saw your patch in the other thread and I like just passing a SG list
from zsmalloc to zswap, and passing it as-is to the crypto API. The
problem of virt vs highmem addresses organically goes away with that.

Thanks.
