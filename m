Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38736382F1C;
	Fri, 22 May 2026 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453093; cv=none; b=RG/AjcGkbN99bC1T7DSo7D2LIinKx2I6fqjg+sTjDeDtLT9idQgufEZZaOL/g1K/QCV1jQ5b9UqgHdCdN91HgOynoRu4TmnYVMcSOK9zfRxqeTPBuO0qvbudOuIkxzawk04Di+fAiG5EmLQyJT8uyXYb/gT27bqU28TNh2glAUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453093; c=relaxed/simple;
	bh=vQX0Z2TX4kHBN0LP6zfk1mOqxVOZDzB+Dy0zFk/ylKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XArwFTW0bDLqRhPm+KTFZx5APXvJp5LP68CmPsFpBsMOY70a3Hiiwnpy5Et5sWRbC903d91ONvkSZbsxdAjeSOUYCoP6Dmv0zViIMOj5iSySVLeK0pvmgqPKSA6dN3aT3NwZt0sdUDsstwE0WCDSAx9MnMacaOLneiabskkoI1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lb4R/PxS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lb4R/PxS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=l74tzO3KJHUizv9WPRmAVf0vyTVxPTERjksbYexfXe8=; 
	b=lb4R/PxSZNO2q0S4oZFy9Qld714Ua6syCwv+MNBkXhC9qMnXivcPLFk3JF+LzxHz43jlKt4zxr9
	fqIyolHzcJ4Pt5gLSph8lJuuGnBgI9DWZakTnlqaxKZZB1gRh63KaI0+BAQ3lxLz0gRD5hLiOPbWr
	o54zg4hCAqv6Y5ySK9mmWuOCbTV/clrjxIH6/K2P0HGdjGTh/5wRttwGykJ19N3GZLKPZzl3SwX/D
	p7Lu/rwsUGMfJrB2LASB3lS+IQDJd7F1Qfdezf0f/3ZcxAV57FvKXlALPzOw2BVDxaVYhPxly56MQ
	smWcCrDar5Z2u6DdXjd1+I4Pj/h1tQB+LSKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP1o-00GSO9-33;
	Fri, 22 May 2026 20:31:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:31:00 +0800
Date: Fri, 22 May 2026 20:31:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: riscv - replace min_t with min in
 riscv64_aes_ctr_crypt
Message-ID: <ahBMhKb4YmeVf376@gondor.apana.org.au>
References: <20260514165509.527721-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514165509.527721-2-thorsten.blum@linux.dev>

On Thu, May 14, 2026 at 06:55:10PM +0200, Thorsten Blum wrote:
> Use the simpler min() macro since the values are unsigned and
> compatible.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/riscv/crypto/aes-riscv64-glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
