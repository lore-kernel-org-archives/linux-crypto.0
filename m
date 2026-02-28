Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5EC2BFC7B;
	Sat, 28 Feb 2026 08:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268258; cv=none; b=dLZIODpUxsegz+PUg66tqW5KJqD9w/yD7p/QMYn6/+qaDmXzhn5ywO3MFg+O0IF6oB0ZGHOjHDSC0/Ar71UoOGRakf/hwpqXn+1s9rVlYOpPn8HBFGFsX81Za5B79ngvwBOsY+vgy+2gMQdOI2SoAi2GBm4Vk7d4mYv8XdQoF/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268258; c=relaxed/simple;
	bh=ZmOHgyWzcejG6bTAX9snR9pZw5QJ0TltSRKqH/uaNC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQA8I+9/RGD2nkQqok7hLmi7C/o/C/fwko9MCMssn1dJi/jjMmVcmhsc7VXwqDO7bQ4X0uYRIvQhWwvjr0x6RT7GdZ+G9IfuaNc/CjBOdEBr+CnVylnkJjpt31PfiewUoBjw6pr0343nZbgHg9j+JL0hzyTlIHDLQPR1fYLzVbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dAzoDquw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dAzoDquw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pTqvWza/irB2p48AMyM8TI8FgX/ar5aoAuTkXDx+WwI=; 
	b=dAzoDquwNFOlClc7vrwvg2aKvYm0gF7FzlanX2VtbM0GQW6nkWhymc9L9ZhK5WdjD3jU5ZkQVs5
	tSCnpe2L90vIBhJUwSTIq/hY0auEw/5orRq495AIqX9YOcK/Wo7IffU5SB95mbM/MeCI1x1LS47Ub
	TvwbTzTc1McrDHj+9jdGf/1YFeQ7qDUo2bA4Ufj7xN+hrsOyFR0uq7/Z++ED0rivJGx2p0sB9A1cA
	KUTjARLMVqkPC71DS6q6LXAxxp2x//kuqflsZInFJoGZNsyNU2fRyNPK6WvFS+8sQvANuzQCpu9H+
	21Y/3j8HywPX3wck5Y1tk2nH/nCSvjfrgHSg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFvm-00ADne-26;
	Sat, 28 Feb 2026 16:44:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:44:10 +0900
Date: Sat, 28 Feb 2026 17:44:10 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alper Ak <alperyasinak1@gmail.com>
Cc: davem@davemloft.net, ashish.kalra@amd.com, thomas.lendacky@amd.com,
	john.allen@amd.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto/ccp: Fix use-after-free on error path
Message-ID: <aaKq2mulU8rxqtQB@gondor.apana.org.au>
References: <20260209103042.13686-1-alperyasinak1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209103042.13686-1-alperyasinak1@gmail.com>

On Mon, Feb 09, 2026 at 01:30:42PM +0300, Alper Ak wrote:
> In the error path of sev_tsm_init_locked(), the code dereferences 't'
> after it has been freed with kfree(). The pr_err() statement attempts
> to access t->tio_en and t->tio_init_done after the memory has been
> released.
> 
> Move the pr_err() call before kfree(t) to access the fields while the
> memory is still valid.
> 
> This issue reported by Smatch static analyser
> 
> Fixes:4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
> ---
>  drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
