Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989812CDAE;
	Tue, 13 May 2025 08:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123648; cv=none; b=ekxsdcF6F3f0xcZxdddtaB41ezbcPsWEj17og9oqL16yX/9RXUyEbeMsCMWsjavLrmJqvM1Py8ojdhVfCXKxUbLF4+hW4KBqjxCXnP19iBFahMKhrP0ks9cZCyjMuYgwBJW9sHuTBnoPRqL/dUa6izg9O6RGloVzbTXrpY1m5S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123648; c=relaxed/simple;
	bh=vud7CUVgVr2JwbnoYvC6dIKqLE5UZ6qaK+fH767KXuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLbJwgU1bcUPXijoQDLGrVszYRkZYv+fU+lBRzUyD9QvuxlMGMeyMCx6M2Qu9ZB+pE2GkmmMbKUL6zKSLJha1dfahA8PgJw9EAtpjc0ct2tbf7DksmQs/Yum6gxOT6A3+zNCAlU+luo7PR+R58xcEaWUZiykllIrOaZcH09Nlag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rqq8c87Z; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rqq8c87Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Bwa5BnGhIKvbYBQdupkPabThUggiYmqnSYcORBHjVZw=; b=Rqq8c87ZhxLQLDUnilPn9Fs1pJ
	aTOroWzL9IT3k7j/lkhp9b2LgrdHgxhA5EKZXrB6UwpqwrQHz4rTRDuUYIXMBbRkQw836BvDm8i8i
	ywXywCgJkGwJSKoR/eLJJfZ9knuwVGCmT4C11Y5I4nanb4t14AxEf/Rf5RfZVDwDJt2R84NfVqHTA
	LGzjDEUPg3RlyiC6fbT91eytlcC1ZfxeRsNwEgt/40r4DPblGjYJeORr4gow5TLHw9tAQVn3pYIJ5
	TqeMtbTAUooyN0ox6MijBVgQA4WzYSljQP9wvmtgGBIREcejFRryrz9VYU9b4Wc9vXzvp/vZVtn+z
	LUsH2rSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEkfZ-005hTW-2K;
	Tue, 13 May 2025 16:07:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 16:07:21 +0800
Date: Tue, 13 May 2025 16:07:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 2/3] s390/crypto: Rework protected key AES for true
 asynch support
Message-ID: <aCL9uctC5tQSea3t@gondor.apana.org.au>
References: <20250509102402.27287-1-freude@linux.ibm.com>
 <20250509102402.27287-3-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509102402.27287-3-freude@linux.ibm.com>

On Fri, May 09, 2025 at 12:24:01PM +0200, Harald Freudenberger wrote:
> This is a complete rework of the protected key AES (PAES) implementation.
> The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
> in a real asynchronous fashion:
> - init(), exit() and setkey() are synchronous and don't allocate any memory.
> - the encrypt/decrypt functions first try to do the job in a synchronous
>   manner. If this fails, for example the protected key got invalid caused
>   by a guest suspend/resume or guest migration action, the encrypt/decrypt
>   is transferred to an instance of the crypto engine (see below) for
>   asynchronous processing.
>   These postponed requests are then handled by the crypto engine by
>   invoking the do_one_request() callback but may of course again run into
>   a still not converted key or the key is getting invalid. If the key is
>   still not converted, the first thread does the conversion and updates
>   the key status in the transformation context. The conversion is
>   invoked via pkey API with a new flag PKEY_XFLAG_NOMEMALLOC.
>   Note that once there is an active requests enqueued to get async
>   processed via crypto engine, further requests also need to go via
>   crypto engine to keep the request sequence.
> 
> This patch together with the pkey/zcrypt/AP extensions to support
> the new PKEY_XFLAG_NOMEMMALOC should toughen the paes crypto algorithms
> to truly meet the requirements for in-kernel skcipher implementations
> and the usage patterns for the dm-crypt and dm-integrity layers.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  arch/s390/crypto/paes_s390.c | 1812 ++++++++++++++++++++++++----------
>  1 file changed, 1270 insertions(+), 542 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
