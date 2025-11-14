Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586953112C0;
	Fri, 14 Nov 2025 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115877; cv=none; b=nCggL9L0ngAJfgTJMk28m4T6HFGCbte+rAG7WQ8kUhOWu5wBovZ7eIuaPncfxRw+a/oHaC3rsLzEzb5Ua97l5cXFdnN2sEJXA4uyXQWcNru7WodECD9xHAQN4UG85wzVK0RBlravk/pHneNQJTlLHGzESD7D1wwwAVzTkRVpyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115877; c=relaxed/simple;
	bh=HarAnT/JgGZIWrovuGfKnGkXZ9ld2RWbLEllCumIxP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thLCQtLzliESB+oeZyjhGyQ59Hx1GrnKb4qxMwNNW1DlooyP8k8jA4N8JoUZXUVgkXIKR4oBKkZxatmC/MBdmC6OwhhtoPoUhTXqjIpO85wn5njzuGmQx11C8Vg9XbnRGZZ0ykBp5NofCaSZ8W736cw6LhNR/W4WWJP/x8CnPBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Gsuu68Hn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Gsuu68Hn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hIAkDKvcEiMM7v57vmJikYmHE9Naf3G9F24VuTNYT4Y=; 
	b=Gsuu68HndGdZqpLe1dvHrFpbtvbvivPV4X2WG1tc/qe3u2fi4yqJ+jYKoni6S8cfQ5NDJi//sOK
	tv3OpYQXF7EDrVXWVKhiWN8jLl2dCDTTj53W/TsBQkxhbs+f4glBmy6NbmQ5dtMluK9ThOVnHs05y
	jgOdpAP00kRgpEZJnhtosBudnsIIu76SoyW5FvhXFuwNykq/ZrrXFmumuue3MH6Uo45aT6+3+xD6S
	aH6xpcBa8JyWykohdbPFrOBfZAvDzG0QRk4huGqW8qZ7Ayk9BI0ppTuYCJCDVpvaYC0dJwZpD1vVo
	LZJLu3mxXLczj19RbML/NJc0HLqoOu0cEVCw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqyj-002yUU-0n;
	Fri, 14 Nov 2025 18:24:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:24:29 +0800
Date: Fri, 14 Nov 2025 18:24:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: kristen.c.accardi@intel.com, vinicius.gomes@intel.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] crypto: iaa - Fix incorrect return value in save_iaa_wq()
Message-ID: <aRcDXZ3dgtGvofYe@gondor.apana.org.au>
References: <20251109145648.3678596-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109145648.3678596-1-zilin@seu.edu.cn>

On Sun, Nov 09, 2025 at 02:56:48PM +0000, Zilin Guan wrote:
> The save_iaa_wq() function unconditionally returns 0, even when an error
> is encountered. This prevents the error code from being propagated to the
> caller.
> 
> Fix this by returning the 'ret' variable, which holds the actual status
> of the operations within the function.
> 
> Fixes: ea7a5cbb43696 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
