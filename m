Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5B30EF9A;
	Fri, 17 Apr 2026 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776415875; cv=none; b=fIoKHONgk/QQYfoioYjTdQiUAGR5hcfqgeGNOJcOMwpporwFvb5ZXoPiihif1idcj5HgHU8FYHBni2WeXcUjAqI/9TK46DFdHCa6Cz2nsN/3lKZUIJ+DCSuiQF/OjslA6jIKq2SRQ+vkAuTWGCcTtlNNQSx6t/taPUS4W43ikf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776415875; c=relaxed/simple;
	bh=ap+iXnWzakfIDboCoMGop07jDR538iwW3lzR/z/Ukto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gi9lrJ5dncVWD4rAT0erR5kI13pTZp2s2vMBgGSaNz5Ywik+9ucP2JM6F2idQ5jW2hN7bIYqm1Dsj9q4YXvEvA44l1WDmXgabIMQepOpyjxAvDHiFOwN683Fk+8Dq7GcpXGvZsMhAcq56ntmlYh/rDkbPdn+XFm8wxbXAGGlH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NLbl3szX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NLbl3szX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bcgvDmk0eRSEBtf4w4nfStWl+xXgTzkVjH73x7l3Iho=; 
	b=NLbl3szXYigwajWBMBk1IMeSwXSzaEdbiSwQ9105jBZ9fAJRVytgo5cQ5qymE4LhHOsEBsCEf9P
	G3o3aSO6/xvwaFln4OIyw0TbBQZAGeLGH5Ohlgq0ES3TyPtngfaD/Efg/HfRCVedkcsUy9IvVLk1v
	t67vlff3MndPh5bY+HN9BwPRZCeygnV3tf7amRPjDEK+MWKqs1bCuj+BXzdGU9a6c6XIeqKFlmN21
	MFO1WZ2zcjOaLQm4aD70k5+Lo4bp166kUU89C6zvQ7NJcHc3qTZOBpvhbFEqR2Q+FnLarCsuCSajp
	28Ry/kgp9/aodpJBcTgtNGWeWkTVeAKmdSWg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDeuk-006lSW-1D;
	Fri, 17 Apr 2026 16:51:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Apr 2026 16:51:02 +0800
Date: Fri, 17 Apr 2026 16:51:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Wojciech Drewek <wojciech.drewek@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: acomp - fix wrong pointer stored by
 acomp_save_req()
Message-ID: <aeH0djDrciHmaySt@gondor.apana.org.au>
References: <20260324180721.120175-1-giovanni.cabiddu@intel.com>
 <ac8NYE0XsniCvNSk@gondor.apana.org.au>
 <aeEXNL2CH8njXY0Q@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeEXNL2CH8njXY0Q@gcabiddu-mobl.ger.corp.intel.com>

On Thu, Apr 16, 2026 at 06:07:00PM +0100, Giovanni Cabiddu wrote:
>
> acomp_save_req() stores &req->chain in req->base.data. When
> acomp_reqchain_done() is invoked on asynchronous completion, it receives
> &req->chain as the data argument but casts it directly to struct
> acomp_req. Since data points to the chain member, all subsequent field
> accesses are at a wrong offset, resulting in memory corruption.
> 
> The issue occurs when an asynchronous hardware implementation, such as
> the QAT driver, completes a request that uses the DMA virtual address
> interface (e.g. acomp_request_set_src_dma()). This combination causes
> crypto_acomp_compress() to enter the acomp_do_req_chain() path, which
> sets acomp_reqchain_done() as the completion callback via
> acomp_save_req().
> 
> With KASAN enabled, this manifests as a general protection fault in
> acomp_reqchain_done():
> 
>   general protection fault, probably for non-canonical address 0xe000040000000000
>   KASAN: probably user-memory-access in range [0x0000400000000000-0x0000400000000007]
>   RIP: 0010:acomp_reqchain_done+0x15b/0x4e0
>   Call Trace:
>    <IRQ>
>    qat_comp_alg_callback+0x5d/0xa0 [intel_qat]
>    adf_ring_response_handler+0x376/0x8b0 [intel_qat]
>    adf_response_handler+0x60/0x170 [intel_qat]
>    tasklet_action_common+0x223/0x820
>    handle_softirqs+0x1ab/0x640
>    </IRQ>
> 
> Fix this by storing the request itself in req->base.data instead of
> &req->chain, so that acomp_reqchain_done() receives the correct pointer.
> Simplify acomp_restore_req() accordingly to access req->chain directly.
> 
> Fixes: 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  crypto/acompress.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
