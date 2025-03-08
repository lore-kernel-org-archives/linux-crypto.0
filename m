Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C95188733
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 08:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741422831; cv=none; b=PLmo58zYqC2JuDLcBpVmjg/MK1w3xNO90ExyIlLeLrHUffacsV2jB/SFUaV8n8+0P1SixdG5j9vrhZ2NJOUdk5H2oeSMr2KcrFU54sjKRh0F08GWSydxDU0MviF5SDdWaKv4t9RUUHwU+8Wng5SKImpJ05QDaAZdJY0i+2YbZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741422831; c=relaxed/simple;
	bh=PKKmzSkqKdE9KTZwt4N4qmH7xKE1iIDOv3pOm6FT0mk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=MnOJEX2FD1rYbCKCkDKsGK/RpfUgQ3kUKwmm5K+9Ii1oo0OigoXmg9zWas2aFydbtlwlrqHRNyCeXAFo2QeIc7KXsvQwe5S1+hQPGzNOK8Sj/yyz9CKwbhLjfy/fIxXO6uC+cbEiITtPCIMUmQoJwoJV2OU8sC/1Y/b0ce/PRsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Vl7M4wKX; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Vl7M4wKX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4AKd3P/M0ZH+dIBJOz86VneKzSRvs9GOx9VeD4Qf9ig=; b=Vl7M4wKX/nMOTjqj1H3pUBQ10y
	XZycpwEkVtim3V05Qs90VPulzOh4f0rpxWAaGZVonmKYjTc2AvCXxCmEUKk3sNXa2KNxaxTvTxIZh
	Ol3ngji/w8BAv2s12DCaJ8M83uJLsikjJLNv6lM/zaHXo2GFIKfrtigQMaWM+tJhaEQ1Y5khxLus1
	rftXx7Xwk4hTJ4pLH9zMOOMqxn2+E/+DnxYESktx3aHnZNDv19IVulY2R0uY7WLoNnjLu+QErrlip
	bXiVtseXPwZ9F99k4SU6jqcBOhbiZgL9kRUgKzXeCxHhPQojU/FSJ48pbJ3y+8CjqKiE12/6zFDNA
	QBXVj+/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqpcv-004ogK-22;
	Sat, 08 Mar 2025 16:33:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 16:33:45 +0800
Date: Sat, 8 Mar 2025 16:33:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: skcipher - fix mismatch between mapping and
 unmapping order
Message-ID: <Z8wA6ajscAK35OmO@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306033305.163767-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Local kunmaps have to be unmapped in the opposite order from which they
> were mapped.  My recent change flipped the unmap order in the
> SKCIPHER_WALK_DIFF case.  Adjust the mapping side to match.
> 
> This fixes a WARN_ON_ONCE that was triggered when running the
> crypto-self tests on a 32-bit kernel with
> CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y.
> 
> Fixes: 95dbd711b1d8 ("crypto: skcipher - use the new scatterwalk functions")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/skcipher.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
