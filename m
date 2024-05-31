Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ADA1420D0;
	Fri, 31 May 2024 09:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717149492; cv=none; b=l1yL/mYaNA5aIqitD4kzC/CZvaGnAHBXB4CyfpRfm1zkP3yPdk/Q2cAgnSSWG9HrTFQpmAmVIKJ2l33VHysA+UTKqcoAstqLYPXp/SPZ9GaqPjdtd7XjqnSRhfisWun+K74LmIVmoe61Rjpf2htLbgW4yeT3KTLeWjfJI/m7134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717149492; c=relaxed/simple;
	bh=94iYdllfxysf6lNnQkW5j/Rq7ZTQ0anOlDqgFRB/n4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCWqGNiRGOiuFv6Q/LjcfuTEyThgqSCatbHEufhHf1PZ/vxY8xaiNFCkNr+gWc0lEhusW17SVn/n2KzgNASUnwrXLrMTE1gMfartf+EMGKqOFCyL5mJnw8QqChH12O9poQTgBPVSkyleoP4Ph0YkMsF5S+OZKC+NqhskUQ1Gijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCz1O-004AHr-0d;
	Fri, 31 May 2024 17:58:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 17:58:04 +0800
Date: Fri, 31 May 2024 17:58:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hifn_795x: Remove unused hifn_*_command structs
Message-ID: <ZlmfLIr9WzdAJmQI@gondor.apana.org.au>
References: <20240511145426.226379-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511145426.226379-1-linux@treblig.org>

On Sat, May 11, 2024 at 03:54:26PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Remove 'hifn_mac_command' and 'hifn_comp_command' which are unused.
> They're the same structure as 'hifn_crypt_command' which is used.
> 
> (I was tempted to remove
>    hifn_base_result
>    hifn_comp_result
>    hifn_mac_result and
>    hifn_crypt_result
> which are also unused, but they vary, and perhaps they're telling
> someone in the future what to look at.)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/hifn_795x.c | 17 -----------------
>  1 file changed, 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
