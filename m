Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C514457A9;
	Fri,  4 Sep 2026 09:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515696; cv=none; b=AwQ4kwA8yYCo/0DYvLdJCA7hpVGLAzuJpj/dqXxKFAMr0E6Qpaito0HoZ7f2McmUMaERJBTmYh2R3hJfFza+cZ2HxfrtfdnT7qXEWqWNLefLyW8XkQ+wNNz9DSdEE6kSdElhhq6DFVO87ht7UmOTvHLDUO+PTP8/4sWoGZvmJ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515696; c=relaxed/simple;
	bh=R0oCLhhCS7BUY/r6tc8/OezJmRuFq14k+ZsxCYhrXo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBwUFopcXILFi2zQvA+le/MnqbT7rMhewUurUqVmFG6Q01uZWYKY8+V2SUiXfmMz5AeT8OPxwFTCVUwhhKMFFmMSSXD/+kcGSh4yjZyB6DwoEkk6BL/lsZGfrKylWlO0T7+fGYSM9m7LKs1oiag4Fvd1L6eBj6dVei8WJj35f9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=L9loEyYG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="L9loEyYG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2CD+vq0t/y3lKLpZWTCB2Kl7s13Ty6fzKDJE63ASeNw=; 
	b=L9loEyYGj3W3n9hec+MWr0NG7kcjqRUS4CrL9iKKexjr27AL1P29pP85yPYSx55rPeLTyyAgj2Z
	7ni67iwk6HTcjtUbGDO6lNNtTgeE1LDG/4TP5GuJ0IHchTGRocW7CcsvY40QeyXNzzbc7aVdce1oD
	8bWbpzKmMJBa3NfE+hVHRljWMxdKIPbF4Z8wuC41fVmnbNMwvGGQYm7y1/Fpk+PpVOmYNbKsUEEiR
	gujNblKa9Ea4dZUTo9LaeeIyY197Jh2JK5QgKpEgEOwndmZgw32eHZx/MXyBDSSJEIaGkI4iaWaiq
	gJUu1RtBwdKP2eH+SJusdHFz94dxpOKMFMmA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QdF-0000000An7L-3OKe;
	Fri, 04 Sep 2026 17:54:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:54:49 +1000
Date: Fri, 4 Sep 2026 19:54:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:SAMSUNG S5P Security SubSystem (SSS) DRIVER" <linux-samsung-soc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: s5p-sss: pass s5p_aes_dev to irq handler
Message-ID: <apqVabaRCvLtfhoX@gondor.apana.org.au>
References: <20260811043358.136042-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811043358.136042-1-rosenp@gmail.com>

On Mon, Aug 10, 2026 at 09:33:58PM -0700, Rosen Penev wrote:
> The threaded irq handler takes the platform device and calls
> platform_get_drvdata() to recover the driver data.  Pass the driver
> data directly as the devm_request_threaded_irq() argument instead,
> dropping the platform_get_drvdata() call.
> 
> Assisted-by: opencode:deepseek-v4-flash-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/s5p-sss.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
