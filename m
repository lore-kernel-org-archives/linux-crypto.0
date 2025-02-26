Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70931422AB
	for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2025 02:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535703; cv=none; b=AjXygpFldVwAnPEBSWFcjryAxE4fmpMLLjmQ5GaD564bQhKG7G6/2ZxwBrHgBWjrtR86Es79NVilTREyW/AQ9EZ0ypKEB78aTs1usw7vcnf/bZr/T7QJJYH7nsiwI+dLycD84iL9Q5/SzC1394Rzj8sQRTZss/0ulTf8sfCLhSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535703; c=relaxed/simple;
	bh=JFo1EJGPcALpe/vvoNil3q11DVP7EY8fvE+brBR7tjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNyjSilXxZBYREQSKcT+mI2XAIh1y4mtZoZFMkfm0JfpqDAgpZEIB8on72psDi49VVpV8pWVJadVN/5aZE/RiIiH/l303LxeIHB89C87KnAKCAQWjY6Tk9eItDu7yZAFpLJr/IrnkHWDIlCI0VC//7K4Nq/X3dN/m/g5hZXgg0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bW7DTZ3J; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bW7DTZ3J"
Date: Wed, 26 Feb 2025 02:08:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740535700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6OT2cF/ZPcycQso9hH5apzsVw/Q9q7yBIY5IL7+Yorg=;
	b=bW7DTZ3JfPodHoYu+uOpvnoXAigpeYV7HdjDSDy5E8J55jVfS+Q8dP41VEvwgSyrbA+FQD
	fgr0fGAlfoGD+EkvNbSCuZ7+eKN+qrPqN09/d/kKyzHq0vSM58Oa5Gb16L9hDafWpMWxMr
	GieMLLR3MTMg8SoX/OgqhLwGNCXlLEU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Message-ID: <Z753jsValuBdcvnv@google.com>
References: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
 <Z72FJnbA39zWh4zS@gondor.apana.org.au>
 <3482501981b13aedda3c1c6b54d83d496bd05922@linux.dev>
 <Z75tg3wXoDnGtLis@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z75tg3wXoDnGtLis@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 26, 2025 at 09:25:23AM +0800, Herbert Xu wrote:
> On Tue, Feb 25, 2025 at 01:43:41PM +0000, Yosry Ahmed wrote:
> >
> > Interesting, it's weird that crypto_free_acomp() allocates memory. Do you have the specific call path?
> 
> crypto_free_acomp does not allocate memory.  However, it takes
> the same mutex that is also taken on the allocation path.
> 
> The specific call path can be seen in the original report:
> 
> https://syzkaller.appspot.com/bug?extid=1a517ccfcbc6a7ab0f82

After staring at this for a while I think the following situation could
be the problem:

Task A running on CPU #1:
crypto_alloc_acomp_node()
  Holds scomp_lock
  Enters reclaim
  Reads per_cpu_ptr(pool->acomp_ctx, cpu)

Task A is descheduled

zswap_cpu_comp_dead(CPU #1) // CPU #1 going offline
  Holds per_cpu_ptr(pool->acomp_ctx, cpu))
  Calls crypto_free_acomp()
    Waits for scomp_lock

Task A running on CPU #2:
  Waits for per_cpu_ptr(pool->acomp_ctx, cpu)
  DEADLOCK
  
In this case I think the fix is correct, thanks for looking into it.

Could you please:

(1) Explain the exact scenario in the commit log, I did not understand
it at first, only after looking at the syzbot dashboard for a while (and
I am not sure how long this persists).

(2) Move all the freeing operations outside the mutex? Right now
crypto_free_acomp() was the problematic call but it could be 
acomp_request_free() next.

Something like:

static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
{
        struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
        struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
        struct struct acomp_req *req;
        struct crypto_acomp *acomp;
        u8 *buffer;

        if (IS_ERR_OR_NULL(acomp_ctx))
                return 0;

        mutex_lock(&acomp_ctx->mutex);
        req = acomp_ctx->req;
        acomp_ctx->req = NULL;
        acomp = acomp_ctx->acomp;
        acomp_ctx->acomp = NULL;
        buffer = acomp_ctx->buffer;
        acomp_ctx->buffer = NULL;
        mutex_unlock(&acomp_ctx->mutex);

        /*
         * Do the actual freeing after releasing the mutex to avoid subtle
         * locking dependencies causing deadlocks
         */
        if (!IS_ERR_OR_NULL(req))
                acomp_request_free(req);
        if (!IS_ERR_OR_NULL(acomp))
                crypto_free_acomp(acomp);
        kfree(acomp_ctx->buffer);

        return 0;
}
