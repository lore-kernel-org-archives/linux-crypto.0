Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F2A20E6;
	Sat, 17 Aug 2024 07:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878468; cv=none; b=qeJObDmZ+y2agOMsD3uNW2qVSdcHPukC3JVlA6UtZROAP9IG1yyRinqBVj6O+fBSckTgZ2wrMuu4sDXJz8sE/9fQScf/SUjylyBEnYs/Bj47HD6761C05880LV5xKZ9uyZ/aoDikCsLjDXc6aO8HcwD/qbNXmgp+ku7dkyZ/40A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878468; c=relaxed/simple;
	bh=e0zG4knXbURuHciSIhE0VY4dQyzqlKSPYHfzg3PFP3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCyI28Q3kbjxQ3FdpcNjTABL4sLSXCtZsPf/jIt4kVZF1rNBUt6Eo8WZEV96/yCoeum50dYA80B9tSw0/csIxO/bHYJsItpxTRVvyRo4OEyd+ph7GdwzJ37LB8oc34gwxA9uA2gVAsk+PDQzBpSyslnfPXMBx+h+PXJwLXeduF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDOn-005IJl-1x;
	Sat, 17 Aug 2024 15:07:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:07:38 +0800
Date: Sat, 17 Aug 2024 15:07:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: davem@davemloft.net, kees@kernel.org, gustavoars@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] crypto: chacha20poly1305 - Annotate struct
 chachapoly_ctx with __counted_by()
Message-ID: <ZsBMOjw4LosxwH9y@gondor.apana.org.au>
References: <20240805221129.2644-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805221129.2644-2-thorsten.blum@toblux.com>

On Tue, Aug 06, 2024 at 12:11:30AM +0200, Thorsten Blum wrote:
> Add the __counted_by compiler attribute to the flexible array member
> salt to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
> Changes in v2:
> - Drop using struct_size_t() as suggested by Eric Biggers and Kees Cook
> - Link to v1: https://lore.kernel.org/linux-kernel/20240805175237.63098-2-thorsten.blum@toblux.com/
> ---
>  crypto/chacha20poly1305.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
