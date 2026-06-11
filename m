Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AFE2DF144;
	Thu, 11 Jun 2026 05:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781156279; cv=none; b=CBCD+EsMCPZ2jbJ9nOEk+TE4COjBh8pTU1ms2q3rw9/GfaNhWLV8Ov2tUr6xw5k0QTmAGefCq4wNCjkECGN/bJgNQzJkUFT7JOVcb+HY/12j/NJFdwxHYW9Dod7KOrNIygdXW50gLOfjaPwYegIIEe5PSHNuukX3ECeP5tA8+wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781156279; c=relaxed/simple;
	bh=JvtTlhA22zr7CMpFpp9VoXOIuRajXbVgPXTJi9C6he8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQxnHP8Ii/cT/xfeGK975ICM5sIR3KBj5Zlx+OnGELM3xmARKDxhvFFwAw6bebesisNxJ0P4+mIe+rRunBCkEGHvjrVTXZHblhzPOSo1hRJKzqivd+Ja21/PK828D5muIeE1OvKmxUCl0dko/3ambzpm3tJd2xwuM0PN5mdwPec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=c4eeGaJh; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="c4eeGaJh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bjrwTRXUJkUzAen+TJe9vUZ83P6S8v0PcW2OfwzccUk=; 
	b=c4eeGaJhwSAO9wou1Y0OXAhvrSFS8xa4vj09NeCCX4spk93f+uuJQJKD/umnI5dkoMTmQRWfRPK
	PmsDyTaf1Uc+LQUzhnwYF7lNGtdOlilpxTucv/oyPY6moM13FE5XNzuu660CTE6HupEK8fwmwioW5
	fVtzujnlsnRL+14NKvJ0qraUH1dinGOU5iSNjYAYvkN41Tl7WYpL8YtZznNUuad9MnXhwYMsKKa9T
	bKz+0OvVGe74W4Bpnssrx8PFkcKh/Cu8htXE9wirpUMktjROpAqE+Wzj1V0Duh78nbOf3SvTI+Q5z
	kFUNUQ3j2npoDzoT9LXSu4XpQc+csvLZE8jA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXY6z-00000004UKE-0OJf;
	Thu, 11 Jun 2026 13:37:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:37:53 +0800
Date: Thu, 11 Jun 2026 13:37:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: omap - use min3 to simplify omap_crypto_copy_data
Message-ID: <aipJsbxHH9eGE9aD@gondor.apana.org.au>
References: <20260604001035.1256238-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604001035.1256238-3-thorsten.blum@linux.dev>

On Thu, Jun 04, 2026 at 02:10:36AM +0200, Thorsten Blum wrote:
> Replace two consecutive min() calls with min3() to simplify the code.
> 
> Change the function parameters and local variables from int to size_t
> since these represent unsigned values and to prevent a signedness error.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/omap-crypto.c | 12 ++++++------
>  drivers/crypto/omap-crypto.h |  2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)

Please stop these min3 patches.  It makes the code harder to read
for humans.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
