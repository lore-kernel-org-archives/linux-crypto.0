Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6204B3A9D8B;
	Fri, 27 Mar 2026 10:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606090; cv=none; b=NKd3gR2D9QNOnE+AnQVtqloqR+lrXy51p5Dg8vXknyGVW9Vfs15grZBjvF2mHCZFQF8aPtOZ4AcHLkFWvvMRBHswUneq6rQCCJQh7AIPuC5g2yqm1jTKx++aR9XfB5X5gV3FAcbHfwVSmZrFnZmVDNe7JS+GPHvuw00zA9HKRVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606090; c=relaxed/simple;
	bh=L+JgwnWLDN3uRDc+NgvfbQAm3PktQTCcAb0yx2MKqyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOwXDSnyJlA4ySP41kwFn9DuWqCO5Kmlec48DJnZjpuNtcDEp/+/hJWwI3lArTGhoh0GrjeHsopCaCIIodhFZl8fkRyFo0BG7cUaRIHfuvQaxEtPwCc9hGk2gAeCYowBQhPeIz95DKXjnSr7KbtEvZEE2JVr7RADQzynZp8LKzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hKZpKWU/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hKZpKWU/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cF1fSvUuR884LY7hLBJBWYXz4/12ZfhoA6VKeSLx2Eo=; 
	b=hKZpKWU/XYK6aAlEy5E08zL7lDoeGkNacn0ruINq/al0hj0eBiU02apvz9SccKprJOtthjkK0g9
	ei3uPQ2zwNBLVHkffY+sbPhNWnyl1pQeUs6ZTR36e+F1gEvm1BbXoeQjL9n3FFVHjWle/C2CDbPQ4
	TCe9NLv6kEou/t8M60ZVYLvjitbE61HMtGlzzywuDpdMmn4miu4840tSN27Y/6e6/MQ2N6WUOupjj
	TLqp142Nr0D0pfikbQ5PTCcuG0zi+uvj05BdUsYsHpMKmRVkpyrGa1avmZzz846FCG8AljPbu7sSZ
	+F0B65RSro2J0ylUsxnBIN0Ir0fP2HgGi4YA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63h0-001bne-2c;
	Fri, 27 Mar 2026 18:07:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:07:45 +0900
Date: Fri, 27 Mar 2026 19:07:45 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] printk: add print_hex_dump_devel()
Message-ID: <acZW8a32BRV_grUL@gondor.apana.org.au>
References: <20260319092932.208939-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319092932.208939-3-thorsten.blum@linux.dev>

On Thu, Mar 19, 2026 at 10:29:32AM +0100, Thorsten Blum wrote:
> Add print_hex_dump_devel() as the hex dump equivalent of pr_devel(),
> which emits output only when DEBUG is enabled, but keeps call sites
> compiled otherwise.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/linux/printk.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
