Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67338156F4A
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449739; cv=none; b=Td7kVzfB/JcrXKKChEfJRPY7rxRC1tXpefAhrUofFZbH3y+yI0BhYYw61J6p0b7NHpUVuNhBZg2GJtTJhQroMaUluWFxoyH8nYLknCggOWLEws+4rmX42fxNStvOYRY3tjFRv1+RT8ofhFIWaGPaOywDW2yXMpl6CURtOEP3kI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449739; c=relaxed/simple;
	bh=LLU2S/lMiy6m3sT2VSjW6VefC5EswQMZ1QVEwOHCbBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sROdk0Sj505gidGmFDKyRIM4GPEfzkHDK3b3ykTAk2pHQThU/1ImBIAhAWsikxHfVAkr2+VPaXCxMaxOiMpIlNl+EyYTaesbBUL/40ya7weNTUASovSmGlAUiseRGJET+YqtrV5qxM1gV8giBa2ZLeUu8NzLRkrnMnbzvDRxmBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=epggsiz8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="epggsiz8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LwwmEJMukn16y5b++5NZZf/54l6sTTj+cNX1nkH43p4=; b=epggsiz8p18lAz9PnInry85FpS
	7zEJAbXVur4XQZV2yXWj3C5DfnB1cc7jY4tyqHXsaFaFxMzhEiddQ0UymM79yWBjKAtysqaMbAYrD
	ALa8cBcxfeBW5RjqmM0QINaJ7eSFeB7F0+p8eSq6+g8zgE99a5zef49cnC4ZOd9CBbuNoNOWbPg3X
	sOTvCkZgPjV+TAAsivHTVmh3qxr+rMEdiXHIjVJnPnw4uGyX3/saZ2aiSoQHZCXPy5Gs3rW+7rds4
	MmL48jrhcSZWpvRQCpfhnhy+TqHRvR6dhDZ1SrWXQRPaICMIl/YbmfLaXZFtgvpbL9hLOMpHaBFCn
	JTxXeM0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBvM4-003Yfd-27;
	Mon, 05 May 2025 20:55:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:55:32 +0800
Date: Mon, 5 May 2025 20:55:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: s390: Still CI failures in linux-next kernel
Message-ID: <aBi1RPfWttYYfhEs@gondor.apana.org.au>
References: <e00c4e69cbb3f78221e1975b6f9ebf16@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e00c4e69cbb3f78221e1975b6f9ebf16@linux.ibm.com>

On Mon, May 05, 2025 at 02:52:30PM +0200, Harald Freudenberger wrote:
> Hello Herbert
> with the latest fix still the CI complains about the sha384 algorithm.
> Looks like you forget to adapt the init for sha384, with the following
> hunk all works fine:

Thanks Harald.  Yes I just received a similar report from Ingo
and sent out a similar patch.

I'll push it out now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
