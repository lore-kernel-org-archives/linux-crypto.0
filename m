Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D5722FF22;
	Fri,  3 Apr 2026 01:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178467; cv=none; b=MYdieShsVk8A5VdyX+aR2GLmw2XNF11TeFZxGsi/JH2tMlDaSYm7ms0mTX22vfKNiaxPDnasWN3ChRHcXbXqvYe2gltfUYqDV/x9n20ZowlgakCFRwbF875eUWTytg00rTwvAYFg1ub26jRzORhj5lFv3kORUiIBL5egv1ahEjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178467; c=relaxed/simple;
	bh=k5C6gkgiXA/NqaObl8ZDaVJKXaLqajdyhBGn2dYY0nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAm6FhD1W5CWb5HrDNkfoV5eNqVVLgSxzHur9CklK4gF1lUNCNBRcrwOQtJ9CN/p0Fdz6DcROMpUoRb6SyE+QuCWrY5Wr9PfNPJV5tl2BmqJ9g06gIzy66xZun8z0grs1ptGBpj9mEp2RiDa8EYcTKhrVPIcXnoLAwMwTA0SNEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lepwGg7g; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lepwGg7g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ctXhGbNa+e4/eyfqo6kJTXzrkgv1KbKT2pXNmgf3Hbo=; 
	b=lepwGg7gqwvAltb4R7R1FmGjWbbAI1OzE2Xb0YefMeUmQiwTXgDIjLlmh1ye/XEv51C1NfZnRMb
	iDr8FTGGPwhruDs1Mkq/1L0ONlgm5S/Jm78l66LxbnyT25785SKrXsxf1vd8Ys7lrFpSLvoSTt6pK
	ZPaq6/SaCp/4aCEbYTxFUNW2WsO37yUJq+0tL/FmqwR/bQeSnRnSi+Lj0yQqkxIJgUdguxi6h5h2e
	/igIwl2dyS/sxvxNrXpXs+99bDTiiN+m9f76JdDr3iQCQ1nqqC+l8STeZyC0EhfnYieTSA/RB0kVD
	15yfXAna+7RiM2Vu5aCv+O68BQWUlTFqr+tw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SbB-003R2e-1Z;
	Fri, 03 Apr 2026 09:07:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:07:40 +0800
Date: Fri, 3 Apr 2026 09:07:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: kconfig - fix typos in atmel-ecc and
 atmel-sha204a help
Message-ID: <ac8S3CTB009wEG8v@gondor.apana.org.au>
References: <20260327001725.2301-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327001725.2301-3-thorsten.blum@linux.dev>

On Fri, Mar 27, 2026 at 01:17:27AM +0100, Thorsten Blum wrote:
> s/Microhip/Microchip/
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
