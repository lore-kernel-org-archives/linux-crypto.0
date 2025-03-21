Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A821F4199;
	Fri, 21 Mar 2025 11:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555241; cv=none; b=QyRJtnhMn+28Q5J41jD1rXcxLhbWWkobhs5yxIomiN1jxjbAzffWI9aVfKxdpzadKmqlXX7sUU0ccZHux1Wl1NADHQPkDc2ZEh4qTaLwmwsnv7O7g5hspn5OK6KeB/+JMVfNXJjZgKUu4lexsW4rje7HmYchT+4fBLbTuNdcpfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555241; c=relaxed/simple;
	bh=wxf09k4/rbSKwuSotUTjcngtLja4qk8gevWtD41hXKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pI/ytmnCsMY3IWzy+m3kARign0l6zSepPVS3LO1e1WDvIJB28WyO0TuJS1Ugp/0YrhyXe1HFAOCFmQtwl5VHyEZ8Rw2pFYne2ryf2TEEBPElzkZVbL6Eixx6NGH7qIp6eiqEQURrL4de2wI4LZYqz26aqrlx7yvzQXq/Ujd3wOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rnw9C+d6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rnw9C+d6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q7tKWh3FUTunCR4d+7oP/9DP5Xky/MKXC4hEZcANuJE=; b=rnw9C+d6fYJ+ORqwZMSRI+i2Ru
	R6jRDh0KmThQYCqh4wC2QDNOyo6W39MoptwMZlwjcz9W8H2vpQ46hF/pNBdakD2U13Tk6JOjgNcMx
	JafKSaPWdGX6UqAMe7oIyGZF7m7omCFexC1W+LOzohMnCc8JJ50KnJZ8HKRz53nkblNjZtRW6YFuO
	jFoHzEnOeHugNyr4td9x7EQgnD22iXTzVVxnM4ROtY10bTbls7HuXl9drI7B+oTYYY4VegjAgs5YN
	P5I+yjb/Vf4/lCoPOQsW9A8R0mTLiD4olb9e+M+qG2G1JX8JvOzAmoKx/Xx57tVTCyCDxr17Ohw/O
	th9qcrDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaDY-0090Gh-2o;
	Fri, 21 Mar 2025 19:07:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:07:12 +0800
Date: Fri, 21 Mar 2025 19:07:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: essiv - Replace memcpy() + NUL-termination with
 strscpy()
Message-ID: <Z91IYH0gAQutePsE@gondor.apana.org.au>
References: <20250316211504.39327-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316211504.39327-2-thorsten.blum@linux.dev>

On Sun, Mar 16, 2025 at 10:15:04PM +0100, Thorsten Blum wrote:
> Use strscpy() to copy the NUL-terminated string 'p' to the destination
> buffer instead of using memcpy() followed by a manual NUL-termination.
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/essiv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
