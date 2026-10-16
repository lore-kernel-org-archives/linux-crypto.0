Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8550195B1A;
	Fri, 16 Oct 2026 04:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792125526; cv=none; b=P7384NYFXxJu00+mMKSJ7lmO71XZom1Kt0zoVJboKQCMYxOQ3hFP84CQ3U09IEUZAdBV4Ed/WBsSTBn00eGKBqC7ceEVEhKyM95dWzQiHx8EYILdGa+I22lhktGAYJkb7Ied0gm+wKpJBzsP/5gn98mllvxKXVBWkDzm4/2BAXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792125526; c=relaxed/simple;
	bh=5bNfA1gnv1/WJjq5YUS8GWsvt3GvfFO+Jvdcq4WnsHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBUvr3f+HCot6iySW+fARm2WlEbSKonTi2hiMXS9SOZ7Z6SofmBAQY75vxUWbzgmvtQC0ix14rM5vdm/sIIYU3E3juyb4CA+XtYFwhuaxknFXdH33J1tSBEIXfGGO6EEthqKjU5jyXLaTPuq29wY60Oy+38XCOsAOGI0WsOYNig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cBFadL0t; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cBFadL0t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=akUKtCOOrlEpH/rN6LN5UUaba4wuzZss1jd/DErEyE0=; 
	b=cBFadL0t4yG1/WfEDOQ8wKVQA5t1kSkWJ6i8c/fYSi6+wTEDmU9DwCigIsKPEGwiXfxQUzXBhf5
	t2q1l8jhTKeBxdnxvKNIqyLKiG4iG1V0U5c/OtXIMST64/XMoV0VfS21DblRAuqaWehexRdx2ZMiO
	OGav94vPTkoU8lYH4yw4AR0qKpKvCXf79ZiXX7cIVr1fPgW54RMyZddGEasZ3Q2g4JasxGq2wfPpf
	e3hVUyEYtRHsfqmhCDqe5qoVOKWTp2DpBjMfJIfO28SCOhWEDm6bRGdXYKWdXWmSu3pioMDG1jpaP
	WRqh8ngI9o49wRgKMNSC+EFBH53QMGcNar/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHZi0-00000004QCB-1BxB;
	Fri, 16 Oct 2026 12:38:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Oct 2026 15:38:20 +1100
Date: Fri, 16 Oct 2026 15:38:20 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atGqPIpUfX0LDokV@gondor.apana.org.au>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com>
 <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>

On Thu, Oct 15, 2026 at 08:32:21PM -0700, Kanchana P. Sridhar wrote:
>
> If you are Ok with all this, we will need Herbert's Ok for this change
> in patch 3:
> 
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 192ea996e779..db8e4c82b900 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
>                 return -EAGAIN;
> 
>         if (likely(req->unit_size && acomp_request_issg(req))) {
> -               if (!crypto_acomp_req_seg(tfm))
> -                       return acomp_do_req_chain(req, true);
> +               if (likely(!crypto_acomp_req_seg(tfm))) {
> +                       int err = tfm->compress(req);
> +
> +                       req->dst->length = unlikely(err) ? err : req->dlen;
> +                       return err;
> +               }

What if you put this short-circuit into acomp_do_req_chain instead,
does it still give you the same performance boost?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
