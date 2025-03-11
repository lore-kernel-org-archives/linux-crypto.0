Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FBC2620D8
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 17:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741715073; cv=none; b=uwFRu0e81V0+IeA1pSOQVsUhl0Aqk+0rPPVO/oCg4zqyNCljC7bNgoQsDpj2yXn0LD3B3suxh74+jk7onl9mepSDUNCHMNAVO4e1uW/RJoj1WG72QKMxi1n6B39xh1ZzgXrczZ8WGPzq/eQbsrJxesWtJcOqEhuy/WOUtjzkCNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741715073; c=relaxed/simple;
	bh=w+XSLu7Aww2EMxWYOeo1RBovIOx/t1Ze5bP67/wox94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/+S1k9rYT3SjuPL+ibisRfvGECpCQPC9MxYrwA7USC5ALvihIVp/oSDBUt8ygNf/XQZ0wuJDn7Ga31l18K8Jwjfqi0JAi5a7Nqy53kIku4rsaCGn7Niylwh01IylxIyXBHkZkaiJZJWQZZ/f+sDNXxMaN1MvZOdmPiGDSzz/QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0RjyyqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0RjyyqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C487C4CEE9;
	Tue, 11 Mar 2025 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741715073;
	bh=w+XSLu7Aww2EMxWYOeo1RBovIOx/t1Ze5bP67/wox94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0RjyyqTEVUmsuLWws/HFebX+JvB+XM1Bro/5hHukrTeK8D1hd9elObvOhJgBLbyk
	 ZISDXGDx3x8tGXxeeyrS+FHR5jkb5LdFPIA51CdY4E/TvN8XoirxIiAMXJW8iQW8Dx
	 FqlHVws9QaGY7c2JBWt2NNcoQ0lmKNv9MUS21Wx1yqs21wkUGP2Xip2eYzPeg3jNjl
	 RMsPDHeRMiFDbDf+7Sr+G90IPEUUZV4sdYN83UgVT5iNK99ydoXCtAfMtBplP28b5+
	 x22SvZ8CQY2rjEcesBrhTFAygrULJOEZw9Gy+HLmMIuiE7KGRMMzcQeZ25ysKj5HWi
	 QFAoDmGbOVBOA==
Date: Tue, 11 Mar 2025 10:44:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/3] crypto: hash - Use nth_page instead of doing it by
 hand
Message-ID: <20250311174431.GB1268@sol.localdomain>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
 <e858dadf36f7fc2c12545c648dda4645f48cab22.1741688305.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e858dadf36f7fc2c12545c648dda4645f48cab22.1741688305.git.herbert@gondor.apana.org.au>

On Tue, Mar 11, 2025 at 06:20:31PM +0800, Herbert Xu wrote:
> Use nth_page instead of adding n to the page pointer.
> 
> This also fixes a real bug in shash_ahash_digest where the the
> check for continguous hash data may be incorrect in the presence
> of highmem.  This could result in an incorrect hash or worse.
> 
> Fixes: 5f7082ed4f48 ("crypto: hash - Export shash through hash")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/ahash.c | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 9c26175c21a8..75d642897e36 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -16,6 +16,7 @@
>  #include <linux/cryptouser.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
> +#include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -79,7 +80,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
>  
>  	sg = walk->sg;
>  	walk->offset = sg->offset;
> -	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
> +	walk->pg = nth_page(sg_page(walk->sg), walk->offset >> PAGE_SHIFT);
>  	walk->offset = offset_in_page(walk->offset);
>  	walk->entrylen = sg->length;
>  
> @@ -201,25 +202,36 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
>  	unsigned int nbytes = req->nbytes;
>  	struct scatterlist *sg;
>  	unsigned int offset;
> +	struct page *page;
> +	void *data;
>  	int err;
>  
> -	if (ahash_request_isvirt(req))
> +	if (!nbytes || ahash_request_isvirt(req))
>  		return crypto_shash_digest(desc, req->svirt, nbytes,
>  					   req->result);
>  
> -	if (nbytes &&
> -	    (sg = req->src, offset = sg->offset,
> -	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
> -		void *data;
> +	sg = req->src;
> +	if (nbytes > sg->length)
> +		return crypto_shash_init(desc) ?:
> +		       shash_ahash_finup(req, desc);
>  
> -		data = kmap_local_page(sg_page(sg));
> -		err = crypto_shash_digest(desc, data + offset, nbytes,
> -					  req->result);
> -		kunmap_local(data);
> -	} else
> -		err = crypto_shash_init(desc) ?:
> -		      shash_ahash_finup(req, desc);
> +	page = sg_page(sg);
> +	offset = sg->offset;
> +	page = nth_page(page, offset >> PAGE_SHIFT);
> +	offset = offset_in_page(offset);
>  
> +	if (!IS_ENABLED(CONFIG_HIGHMEM))
> +		return crypto_shash_digest(desc, page_address(page) + offset,
> +					   nbytes, req->result);
> +
> +	if (nbytes > (unsigned int)PAGE_SIZE - offset)
> +		return crypto_shash_init(desc) ?:
> +		       shash_ahash_finup(req, desc);
> +
> +	data = kmap_local_page(page);
> +	err = crypto_shash_digest(desc, data + offset, nbytes,
> +				  req->result);
> +	kunmap_local(data);
>  	return err;

I guess you think this is fixing a bug in the case where sg->offset > PAGE_SIZE?
Is that case even supported?  It is supposed to be the offset into a page.

Even if so, a simpler fix (1 line) would be to use:
'sg->length >= nbytes && sg->offset + nbytes <= PAGE_SIZE'

- Eric
