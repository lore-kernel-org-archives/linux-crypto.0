Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FB626281B
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716319; cv=none; b=AWCURMb6F2+T5ybw5YGV1jcFZvXLls4s6JikT4yzMZ0xTzcOzXAVzRUkVHyEbqTJ5KDjoS62dfZ9xigBGCe0K8gyqB8FY+Wt/AmvF2Qq2LIEuKz8Zd8D9+32XMmH+WZTljyGU9Bg4L5ZDf9KpI0TfaH7AkQ3JKv5xJUKiRE/49Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716319; c=relaxed/simple;
	bh=iP0slNn6/q6DDZfVg4VJ/+gJow4iWKv0672u5As9Tek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlV8s513MZNitwQFC9+cEvoLodYCR6IPVMS2KsdF/Hvt1IbFne03rWw7DDJ5d9bHR00VbR8LSdQBIBuqq1CDmuao8eozjRVtUWz7lET7r4GKtF8Vacwu+bBVIRcCcxw767y3eTFszeVi9rnOwWiksetMIrdiUaZgm3k9rBbihbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nA3mi6Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nA3mi6Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A87C4CEE9;
	Tue, 11 Mar 2025 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741716318;
	bh=iP0slNn6/q6DDZfVg4VJ/+gJow4iWKv0672u5As9Tek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nA3mi6AlSh6dq8AEqfsVu/jvEkGT1QBr+IVLHJDFaaV+22v23v9fTZkPkTxYfV0m3
	 2dAQXGOTqea3X7FsIf1pNEm69m8b3GCjrsyomRe6LTKCqCgImszUm7fxVEmfUFJRto
	 e56Lx/FYk52JUdZ5iWqoCtdRxXbBksJpUm+34M8ZWSBn1Kma3YQH4Y1dSS3z8iyejH
	 K/vwrd9wGUBrYQlvIDQ3IwuJkpj5GDgyKoeoZ6KZ8vMp4sDVKydG8Q8YRb3aMkg6GM
	 FIYe4av8SfWI4Xuqts5O/oVWfRh85jtLksJiUUmgmqYnQJNYTflC00t4Pe1XvmyETx
	 UBUMpBnS5chUg==
Date: Tue, 11 Mar 2025 18:05:16 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/3] crypto: hash - Use nth_page instead of doing it by
 hand
Message-ID: <20250311180516.GA356236@google.com>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
 <e858dadf36f7fc2c12545c648dda4645f48cab22.1741688305.git.herbert@gondor.apana.org.au>
 <20250311174431.GB1268@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311174431.GB1268@sol.localdomain>

On Tue, Mar 11, 2025 at 10:44:31AM -0700, Eric Biggers wrote:
> On Tue, Mar 11, 2025 at 06:20:31PM +0800, Herbert Xu wrote:
> > Use nth_page instead of adding n to the page pointer.
> > 
> > This also fixes a real bug in shash_ahash_digest where the the
> > check for continguous hash data may be incorrect in the presence
> > of highmem.  This could result in an incorrect hash or worse.
> > 
> > Fixes: 5f7082ed4f48 ("crypto: hash - Export shash through hash")
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> >  crypto/ahash.c | 38 +++++++++++++++++++++++++-------------
> >  1 file changed, 25 insertions(+), 13 deletions(-)
> > 
> > diff --git a/crypto/ahash.c b/crypto/ahash.c
> > index 9c26175c21a8..75d642897e36 100644
> > --- a/crypto/ahash.c
> > +++ b/crypto/ahash.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/cryptouser.h>
> >  #include <linux/err.h>
> >  #include <linux/kernel.h>
> > +#include <linux/mm.h>
> >  #include <linux/module.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> > @@ -79,7 +80,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
> >  
> >  	sg = walk->sg;
> >  	walk->offset = sg->offset;
> > -	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
> > +	walk->pg = nth_page(sg_page(walk->sg), walk->offset >> PAGE_SHIFT);
> >  	walk->offset = offset_in_page(walk->offset);
> >  	walk->entrylen = sg->length;
> >  
> > @@ -201,25 +202,36 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
> >  	unsigned int nbytes = req->nbytes;
> >  	struct scatterlist *sg;
> >  	unsigned int offset;
> > +	struct page *page;
> > +	void *data;
> >  	int err;
> >  
> > -	if (ahash_request_isvirt(req))
> > +	if (!nbytes || ahash_request_isvirt(req))
> >  		return crypto_shash_digest(desc, req->svirt, nbytes,
> >  					   req->result);
> >  
> > -	if (nbytes &&
> > -	    (sg = req->src, offset = sg->offset,
> > -	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
> > -		void *data;
> > +	sg = req->src;
> > +	if (nbytes > sg->length)
> > +		return crypto_shash_init(desc) ?:
> > +		       shash_ahash_finup(req, desc);
> >  
> > -		data = kmap_local_page(sg_page(sg));
> > -		err = crypto_shash_digest(desc, data + offset, nbytes,
> > -					  req->result);
> > -		kunmap_local(data);
> > -	} else
> > -		err = crypto_shash_init(desc) ?:
> > -		      shash_ahash_finup(req, desc);
> > +	page = sg_page(sg);
> > +	offset = sg->offset;
> > +	page = nth_page(page, offset >> PAGE_SHIFT);
> > +	offset = offset_in_page(offset);
> >  
> > +	if (!IS_ENABLED(CONFIG_HIGHMEM))
> > +		return crypto_shash_digest(desc, page_address(page) + offset,
> > +					   nbytes, req->result);
> > +
> > +	if (nbytes > (unsigned int)PAGE_SIZE - offset)
> > +		return crypto_shash_init(desc) ?:
> > +		       shash_ahash_finup(req, desc);
> > +
> > +	data = kmap_local_page(page);
> > +	err = crypto_shash_digest(desc, data + offset, nbytes,
> > +				  req->result);
> > +	kunmap_local(data);
> >  	return err;
> 
> I guess you think this is fixing a bug in the case where sg->offset > PAGE_SIZE?
> Is that case even supported?  It is supposed to be the offset into a page.
> 
> Even if so, a simpler fix (1 line) would be to use:
> 'sg->length >= nbytes && sg->offset + nbytes <= PAGE_SIZE'

Or just make this optimization specific to !HIGHMEM, and use
nbytes <= sg->length and sg_virt().

- Eric
