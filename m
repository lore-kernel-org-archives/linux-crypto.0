Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8BA3314DE;
	Fri,  6 Feb 2026 11:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375719; cv=none; b=SQ06PPVSw8aZQmOL01zR1d/YfhDX8XTt9p9ZnNZ5Z6LSbJc0nuN10ZBbIDhiTA7Zn/PYrqH8GkDfazA++Z4GSEuO1Eo6X0U9DdFaVhExi0qds72fIzGSPhXWoFJMj4PBIp6VV1YfWhpQlnRw/iic5aOXgENTk98CEvi8l/DGnK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375719; c=relaxed/simple;
	bh=jCCiHRoO1xeTWF7TDnxb5PIykzgoT5rd0zB4i4mNXR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cB0nBh09Zr5ujOLxl4wX81KMYmyxZdQa72D/AJwdJaGvgtIvkLsUC2N4fxiH5JFkdSx7EjHbz5EMyi/suqBpW66EPnTvI81WVD54HOu8rJ6SB1yvfEnMmFgHaOjhyzRs3y3SCr0pzJ5JAa/hOhxlPiwaOZctKEk/WOoKP7sHx8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cWlRz0UC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cWlRz0UC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7Qs+AwZ9zxauz8Rcv+n7jI5jaPGvqs7lG0yDaBw8ddk=; 
	b=cWlRz0UCbnwM1bppUsryC4j36u0/bqmCRGqKnRnEqfvzf0i0Zju35fq+4qbuI+u/coF9vHOtkML
	BFNtm5dtLWsUXGT6b6A/GmRsYABeRrf6jhJESDYSxqHHkfhoYBkG7+Q3BG1XPOALAy/eK0qYsIOco
	yP7a3ePZ2RIysxBswlE4Ok6CTKG0GN3z1nP9CYd5hhFjteYM6h257wsGNa/apDdueV964MqYfuEme
	SUpn986MWz/g6Ns/y8uFln/tppytdWHc5BmtShBLWggyZpHROKvl3LjPXPYlUXBA4JqTnDLbKP3YE
	Fp5e2YpnckVNYtj6TNndNEAhAjsQl/TKORpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJao-004zXC-2r;
	Fri, 06 Feb 2026 19:01:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 19:01:42 +0800
Date: Fri, 6 Feb 2026 19:01:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(des3_ede))
Message-ID: <aYXKFtmVJCCZpUVw@gondor.apana.org.au>
References: <20260201112834.3378-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260201112834.3378-1-olek2@wp.pl>

On Sun, Feb 01, 2026 at 12:27:08PM +0100, Aleksander Jan Bajkowski wrote:
> Test vector was generated using a software implementation and then double
> checked using a hardware implementation on NXP P2020 (talitos). The
> encryption part is identical to authenc(hmac(sha1),cbc(des3_ede)),
> only HMAC is different.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  crypto/testmgr.c |  7 ++++++
>  crypto/testmgr.h | 59 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
