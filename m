Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795671687;
	b=pQ3TQSFdR0xV0I7uAfjZ9ZLYXjIrbUlczAMN/jcFAAXDMFXrJMlODGqZ+5QjvwXzR48R
	 za/bee1uUK7spNHNPZb7x9waRjgNcJoModTxBeQM/WTnAvAuWR3ix0ybD0SfKsFmxhEBq
	 9ZqGweRlCYGaxixQlqf4vu97m5GaGG/48UOUt6F4kq2EiwMNCv1+oxjwyE0dXPXEb/76X
	 CKFKGGYXrcFIbkhZATRH92HTkJstxt/wRXyojlJQK8y7sbux68es0MpBtNoksgEfpk/XS
	 RfyEL+eikfTGLfXIeIsFJRQADnaK3eL/lN6z4i3ef5ndQcv5VE2m2s1wttnAhR3Mlag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795671687;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=lB5Z2jAXM1MCahZXaWDYMLFa+FaZwYx21kct5EFKyxs=;
	b=UjIM+1dNa0hw8eFQNU4w4EimRbgFlwV03SeM3GxCvWtGv3RFEMgrGoYN8RR4w/67UrT/
	 /Vg63goTyBc1SPfwt/GsBGxXqIyYd4b1gxS8uPTEiGq55jzjOmvDFauU3nMiorEAbrQbK
	 /CQ0okw4TjrGJ+Df2FZqxwIsR4LpkSsiIbHCiIH0FZ3M3EfYNv0g6A8BUw1F06tfKs1zw
	 pwE3CG2ALOQtyROhvq2ZL58IiHCBr4glhOcnn+jVFZfijwkmQmaWgd8WiYwpjZXLVqQLn
	 kmQnTo7dcAfFFIeh61oahhDj8KyBOfwiFl34zDgHtxUeOFuZ769CmCqpq2+jkP+DmdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=IG6kP8Z7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137D606A323;
	Thu, 26 Nov 2026 05:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A137D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=IG6kP8Z7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lB5Z2jAXM1MCahZXaWDYMLFa+FaZwYx21kct5EFKyxs=; 
	b=IG6kP8Z78B1+GAs3HdVj0OF7xN4BFXwTmMwOoZcez01WeFEZrA/tC5S6hHti9gLbezGKIBVG3rh
	cjAjMgwZ6UQi+6LcVu54fAAj5TOVTlN0TaeHvc3HaSFPFCSEHcU8DxsBne9pH6bVJBnVpLi5Q7EG7
	XosjJVl6tpkFHAR3DWL6yMSzrWQYZlf6Wa9YWeeoJluJNuck52OmcXzm/gee0+69R8qo5C2n2YlRE
	WyHtFm5yaTaEl+EMM1LI98g6wpdjLWBLcWQiUQkOOpIyVvh6qREeXna87cgGs+O3b4saRMJoso9cB
	somkNjo75RQeIyP7bTDkZY85jL2HTOh07+7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWSEQ-000000029BE-1eI1;
	Thu, 26 Nov 2026 13:41:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Nov 2026 13:41:18 +0800
Date: Thu, 26 Nov 2026 13:41:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <awfGfqMK8FfrMNvz@gondor.apana.org.au>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
 <awQCFZSSng2LLGnX@gondor.apana.org.au>
 <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
 <awafBxDtUoIQW9iR@gondor.apana.org.au>
 <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>

On Wed, Nov 25, 2026 at 11:08:20AM -0800, Kanchana P. Sridhar wrote:
>
> -       if (unlikely(req->unit_size && req->slen > req->unit_size))
> +       if (unlikely(req->unit_size && acomp_request_dst_isvirt(req)))
> +               return -EINVAL;

This looks good.

> +       if (unlikely(req->unit_size &&
> +                       ((comp && req->slen > req->unit_size) ||
> +                        (!comp && req->dlen > req->unit_size))))

For decompression, shouldn't it just fail unconditionally since
we do not support batching for it?

Also how about moving these API guards into the top-level compression
and decompression functions instead of in the shared path.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
