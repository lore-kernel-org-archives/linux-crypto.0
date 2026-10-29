Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252308;
	b=JCq5qLkBTRPsKwAXyNv6Z72WHpCa/qdWedSUysty7MgMLOgbSaqFgDvF6o4q7dZuf5Jh
	 Z18kZeEJbPbl4VQknCRQ0w3SMLM4z44n7YtYNfUyL0d3IC3qoQ9IH3sz+HgxjC+VXvJBx
	 IBmwRpMvxwbs3RDPM6UoOpA2uOY59SCeWLbiYNwtUTRAEZpc59z/E4Uj0v/uDLzzJM5Mj
	 DdVuvEf/T8teK5yoHWJFMUoEPqYrzMuEMrthWPJ8JpdF9DrexBHUAN6dy9kvOUfy5io/Y
	 MvfNo3Fh1UM8Vry2lChbq4ZyFbPdZTYb7lDqFjMfNvbQF/yN4pSU5AH4FMIGDkuFs/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252308;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Dt06N7Moldm7Z/u/s5SX1+R6nTMYuYoZ3LKTzoi2+Uk=;
	b=Ru2DT8Hko+nAyDwjephEP9KEMI1idkCavD++NO8lqP0UR/F/vqdEjGULdL9IQfPjZclU
	 MPfmhxY2Ara0+51GQrPe965gdaTfCY7k3L080QdEAcLlSBJV0jLWCB3NoV5QHGy5nY3kA
	 d6mC/v/0BRQ2iRzA4Bt5FR1HkhEusOaCACBM1ZoF3OySBwCsdP8oJdVwsg+c4ZS5d+nhM
	 ElYFf4qccxqQT3Ob5zGm5ef29bC/3bRN5k0pcXVMU7MAAfwwG9xbd+99vnnFjGbmYguom
	 pp/XfsQPc5pMMXaCqGZrjISOWtepsIkSbpSR6yz974QfPBFBM8Tmlyz6ixg86Mp/GDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=S20clYYn;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB9606A31A;
	Thu, 29 Oct 2026 05:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FDB9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=S20clYYn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Dt06N7Moldm7Z/u/s5SX1+R6nTMYuYoZ3LKTzoi2+Uk=; 
	b=S20clYYn23JF1MoxXFuYgEJDrhKM7XJWQyQas8KM6Aglg8aWfuUuH/YEG/aXX6hcdoOUyV6zuL/
	WvPWJa9GWeAlELgnIcq0QBpWvlQXcovC3Vf7JE9PmXcmA24wdk3tTHVuhw2TfxMZSiZg4q45s0DKX
	kn7Dp8c12wq2KkN/D2UjFO4dWzuopOQoZCYBXYZuY/Xd20g+qmi1ezJgzaIrPNQFUaY/kgzP4eRDu
	kO8jAQi44eQVUckVTEkbEagQMExelEGv0H219yDmvQbUpUhYai6+98PwkElbIsH6RN5SMcmZ1ndjQ
	FQn0STARNDYXVRXPapygE/vhOjKHbnM2xseg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMIqA-00000008dbR-1Mqm;
	Thu, 29 Oct 2026 13:38:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Oct 2026 13:38:18 +0800
Date: Thu, 29 Oct 2026 13:38:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <auLbyon-KaV5Sw5_@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
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
In-Reply-To: <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>

On Wed, Oct 28, 2026 at 10:09:35PM -0700, Kanchana P. Sridhar wrote:
>
> Herbert, can you please take a look at this and suggest what changes
> need to be made here, since you are the original developer of this
> portion of the patch. Thanks.

I think we should get rid of the changes to state->flags in
acomp_save_req and keep it in acomp_virt_to_sg.
 
> Thanks for the catch! Yes, I will add (!acomp_is_async(tfm) &&
> !acomp_req_on_stack(req)) here.

Why do you need !acomp_req_on_stack if you know that the tfm is
synchronous? IOW, how about just testing !acomp_is_async(tfm)?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
