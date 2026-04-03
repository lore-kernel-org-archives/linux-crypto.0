Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27BE22E3F0;
	Fri,  3 Apr 2026 01:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178232; cv=none; b=sWdx+P/lVvytTqBF/tOIWaUyCT0U/st2ZkGSRJgcwwBrDbqR4386XVqYr927rvJaP2/hwfFlF6iGQYNYJf+H24w9mAJmmZtPhgfAfWKIB+snvSeuJVKHcLNMLD9KFnCLYNAcpVpZ0mDG34v95Y8iP6mD13eV8b3tKoRsaSlqkrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178232; c=relaxed/simple;
	bh=juDqqI/tcSchsRsRKWuIiSPyebogzll4B5r/ygYN94Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjYjAhs6KYj3g//WldT+0p0uEZUJTJ76vJSeMoDOfogzJeFrwxZ49fUPNeyq1oEL7WbFu3vekDWigcLgOKV3aCmMWqvhpMyoZC/guR7TXsAwct7Vlho2F5wbdfkKfGIDYb3Jr9UwkvT7010epdO0ZumqSXYtLyOjs+X+yggUNGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ANPaFtA9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ANPaFtA9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=u1LMph3iUgeFDboHxMu24NMcQVpKNmrhpyS2C0FxKgA=; 
	b=ANPaFtA9zaT2gZBv4N5OlN5pTnSVibGLtiqE+uXqaKbq82mlO7eUQ3fO0byclb5M6NlfNbLUIXK
	EBP0MtUO/EunXKOK9EvWxDxqU69oOF8Ctaem2boWhHffkw5sdB1o0Xy27eVzHOZ9zdMz+p6Ezh4sU
	HgZmI+aAG7trP79Qd8bWsj4azal5nMVEC2rj6AL+bnhM+4yasa8+vGLLVwVcoemnGdl6dO21IvLxO
	sGiYKt8AYG/ioZ/x876XMPgbZLECUHhdfw6gy1nJLTc5CmhH3vEjZ3z8Wh8ziQCVFVZ61z0hUaE0d
	RbT9WvkfAn+eTTFL0nohJd98vdH5cb6UUewA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SXN-003QxU-1a;
	Fri, 03 Apr 2026 09:03:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:03:44 +0800
Date: Fri, 3 Apr 2026 09:03:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hifn_795x - Replace snprintf("%s") with strscpy
Message-ID: <ac8R8NMI5557UlXj@gondor.apana.org.au>
References: <20260324112703.94917-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324112703.94917-3-thorsten.blum@linux.dev>

On Tue, Mar 24, 2026 at 12:27:05PM +0100, Thorsten Blum wrote:
> Replace snprintf("%s", ...) with the faster and more direct strscpy().
> Check if the return value is less than 0 to detect string truncation.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/hifn_795x.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
