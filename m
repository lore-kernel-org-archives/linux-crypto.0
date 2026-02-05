Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DC2673B7;
	Thu,  5 Feb 2026 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770264892; cv=none; b=ntaZ9duXeDVI7N3n/4fU1FLj2hSFVQA5hZUAW1oJ/VxwzJc5rxs2qT1DD+ps3xpo+goVCQzmAQrKsHooyrQ+DQAY6xiris8jbMXzym0/wHfdLDPtgLMdbaWpApoROd91A/Oc1rLlxGm6a0KUq73HIC2ME8LEwHdGvEugXSyfiK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770264892; c=relaxed/simple;
	bh=0E+cSiIAc4iXxGCVLoXI33/qJEadsbjC11Anxw02gxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNaGIkNkLajELSiHAxI1Ms0o3NnsMEm8IJPqi2JbykGbhKiCc/oVbLJ7YmIOUt/+FDj4Ff79GYWCo2cAWfB/jPt948wekr0lNFUZl6BI01KbFXaRAGS4bfiEJcJ3lqaFD4Q/lqwjQme2qiq4nz5Wk5fd1+YiDD9CbDmKuQCLmE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MYC5lhn3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MYC5lhn3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DMx5++hqTDx6tKIwhTEaQVGCEoE7NSzZhFlhgtkzgJ8=; 
	b=MYC5lhn3Xb9VliRDwDDj+7mVQ5zc90uaoT96vzZ74Xj3RjBdPHqQDqwQJLzx3NLHA5xH2ZPVB4/
	1aMVBBHzcirjeqbe002SWDDEQGqXyeokqqLAVERFw3JixvBZC5UAU+pC+Z395lv4G77hGGh4ilqHo
	JSUdWrH2SpzoWJMhcurvVoefmU7Nms/5iWeWhrCLd4z8ObSmppUGBVfEoFpZ60qo0MkKunaaVuGzU
	tAExBWauvS3WjCB49Phe4G5EiSjtEpf/x2Q+5De4wV8o1HvXcVMG2bnc72YO7BFe0oodOMOx3DgIo
	QdzvHjn/7KXKyrh/yE60BAA4E0S9i328ea+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vnqkz-004dup-2F;
	Thu, 05 Feb 2026 12:14:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Feb 2026 12:14:17 +0800
Date: Thu, 5 Feb 2026 12:14:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 18/26] crypto: acomp, iaa - crypto_acomp integration
 of IAA Batching.
Message-ID: <aYQZGXue0F-S_Zqh@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-19-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-19-kanchana.p.sridhar@intel.com>

On Sat, Jan 24, 2026 at 07:35:29PM -0800, Kanchana P Sridhar wrote:
>
> @@ -291,6 +292,65 @@ static __always_inline int acomp_do_req_chain(struct acomp_req *req, bool comp)
>  	return acomp_reqchain_finish(req, err);
>  }
>  
> +static int acomp_do_req_batch_parallel(struct acomp_req *req, bool comp)
> +{
> +	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> +	unsigned long *bpwq_addr = acomp_request_ctx(req);
> +	wait_queue_head_t batch_parallel_wq;
> +	int ret;
> +
> +	init_waitqueue_head(&batch_parallel_wq);
> +	*bpwq_addr = (unsigned long)&batch_parallel_wq;
> +
> +	ret = comp ? tfm->compress(req) : tfm->decompress(req);
> +
> +	wait_event(batch_parallel_wq, tfm->batch_completed(req, comp));
> +
> +	if (req->slen < 0)
> +		ret |= -EINVAL;
> +
> +	return ret;
> +}

I don't think we should have this in acomp.  Just return EINPROGRESS
and let the user check each unit for the success/error.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
