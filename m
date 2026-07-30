Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B53B6348;
	Thu, 30 Jul 2026 07:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395072; cv=none; b=qFWa5YOZv9PPg/64ZSwQDOtdGFwLV62O67+U4iiPlucUuqb85bkwIr+Ts92JdwXV/nx+vkm9HNkg6DZkHwUnYy2lZ2m/hLdYUsAykq62eYTi6dnl7YcfTZNMT9MS0TpDUWkcXqOKAC5lzNFw6MqcEHjuj5W78sknys+opcOM6uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395072; c=relaxed/simple;
	bh=xOw0nyrytFu/ulgiPPcrPEpX81eih8PUxGhVxpv1OM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KT0feZiBuqe2ewcClDtXlh6dbNmHVUSemuB0W5XGojwQW5v6ys80mxQ9X2e9sNEjlmE7tnIrn7FbDE3KJcvpzux1oReR8ES+no4/XpfjgLSMgVcYbKMddeoEAXEWWAqMKxR6Zj3Ymn7UlIA8ATMeYD7bC7gQ/3NnkvbrLslcumY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RYJnZXS0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RYJnZXS0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rfUHSmqcsanc2pDbRitz1gYD/pXpvjzYFSDI51NwPic=; 
	b=RYJnZXS0owqEGSBE1+XB8j++mnhw1cPTDRZcG88jhsUPL2vhUS4yjNpOk24sBhnjk+1044n4VZk
	/FqeUhAm/6SYn4LA/P41QA7dJBgUNfsi2DzsnaekTMD+nvmhLDHFRV0f5KQ/fLd2wuOvXD1ziUl0k
	idmlEkhBlotNys9purfOXa894/l3ufsoxh3Yg+vN87SYZE2Me94zyzOpLEHaksyp1zyUYmS14fpaU
	sDSKXSSbGMBdm1+Nuc5MaIG/fp/78L5qVrVuY50fO41tNBpPGseoKb+xoAYvxNalsH2CHugp0b6nu
	ZH9N+IAgVKPZc79pMiH0Jgc+VALh1B9iA3HA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpKoT-00000000RMQ-4BiU;
	Thu, 30 Jul 2026 15:04:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:04:17 +1000
Date: Thu, 30 Jul 2026 17:04:17 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, 13667453960@163.com
Subject: Re: [PATCH] crypto: krb5 - Use constant-time checksum comparison
Message-ID: <amr3cTpCcPd7PYna@gondor.apana.org.au>
References: <20260720031304.198172-1-yijiangshan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720031304.198172-1-yijiangshan@kylinos.cn>

On Mon, Jul 20, 2026 at 11:13:04AM +0800, Jiangshan Yi wrote:
> The MIC checksum comparison in rfc3961_verify_mic() uses memcmp(),
> whose execution time depends on the position of the first mismatched
> byte. This creates a timing side-channel that could allow an attacker
> to forge Kerberos checksums byte by byte.
> 
> The same crypto/krb5 subsystem already uses crypto_memneq() for the
> equivalent checksum comparison in crypto/krb5enc.c (line 255), making
> the memcmp() in rfc3961_simplified.c an inconsistent oversight.
> 
> Replace memcmp() with crypto_memneq() to perform a constant-time
> comparison, consistent with the rest of the crypto subsystem
> (gcm, ccm, chacha20poly1305, rsassa-pkcs1, etc.). Add an explicit
> <crypto/utils.h> include since this file did not previously pull in
> the crypto_memneq() declaration.
> 
> Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
> ---
>  crypto/krb5/rfc3961_simplified.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Please explain exactly what secret information might be leaked by
the timing attack.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
