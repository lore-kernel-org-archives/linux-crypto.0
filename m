Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649DB8462;
	Mon, 27 Jul 2026 00:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112554; cv=none; b=AKaujpECQ+baOUXKHRrMR9u7cxCRyJZx7XDKgmnAST5LjBBcrnZh0s8U4gPbgMwpkcJRoVM7zHAq0PmPEnAsJDxJP/Tv4q3nAttgAyiWU7WMIbkUx49EWALGPMOpaHtluyViK7cVkW+0p734taWIl6/pt/EJ1CuGhNvkxj7suic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112554; c=relaxed/simple;
	bh=M1D83c0zxBQ5LDBRf1OC3lyGvj1uNCa+Xd5MT78uA8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAHbypYgRlanV7BiKtoAckEhsK20eWBblMqR7vATDnqC00g/kSW+U3JA3RLHC9wyGI1O/Jnhx3MJFpfqre/LIH+3Lw6oaZwHxmxPH20hQ1YNmwaCEmevE2BQH78929RKoI/GBbtMQy3SZg9H++brbJ0kfLBmm/Co1Zc9pzg1n1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PgFxEKxp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PgFxEKxp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pvqxKgQBh7ju6UTJ0dogmSgpM8R7WNSXnYjpcKy72+4=; 
	b=PgFxEKxpA8MA0BySy6LH4iNTIgO2UTWLoQ3lXZ4aQJIoJ3OILNva2FS2PiAgilkcre7IVtwyxmw
	M00T0U+Nq8uLW8U1W0fn4BGvc8kUdeFROLZGr9GAkHIJ1CAbVEAiGXoN2vmFd7sMUd/PyS/VMsPSs
	Jehx7DK6GusaG5Gbt96W0Lk+UUkyMQnNVr3lW/9sETnXpvrH4rL8+Uyu6jH7BXMwbn4AXvBaeF2PL
	uSTXOmB9eAkpmA9/hXm469dTFfbtpxJ/BEJ1vujh6PjbQHLmrAn2cQqfgDr506TdrOSDVHknnrr9P
	WXqnLzFLYYr6UQsHg6B9VR2tCER4HNuCFcZw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9Js-0000000Gz3F-3sSP;
	Mon, 27 Jul 2026 08:35:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:35:48 +1000
Date: Mon, 27 Jul 2026 10:35:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/2] crypto: hisilicon/sec2 - fix uninitialized
 type_supported and drop unused hlf_q_num
Message-ID: <aman5JigkqGGITvu@gondor.apana.org.au>
References: <20260718030513.3809002-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718030513.3809002-1-huangchenghai2@huawei.com>

On Sat, Jul 18, 2026 at 11:05:11AM +0800, Chenghai Huang wrote:
> This series fixes a use-before-init bug in the hisilicon/sec2 driver
> and removes an unused field exposed in the same path.
> 
> The first patch sets ctx->type_supported in sec_ctx_base_init(), before
> the sec_create_qp_ctx() loop consumes it; otherwise the value read to
> select the callback is uninitialized on the first queue. The alg init
> paths then just select req_op from it.
> 
> The second patch drops sec_ctx.hlf_q_num, which is assigned but never
> read.
> 
> Chenghai Huang (2):
>   crypto: hisilicon/sec2 - fix uninitialized type_supported in
>     sec_create_qp_ctx
>   crypto: hisilicon/sec2 - remove unused sec_ctx.hlf_q_num
> 
>  drivers/crypto/hisilicon/sec2/sec.h        |  3 ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 25 +++++++++++-----------
>  2 files changed, 12 insertions(+), 16 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
