Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66FF3BAD95;
	Thu,  8 Oct 2026 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448420; cv=none; b=K9yctFDy2UInfGyzQatT/FkkAvwRoH/b1Jk5ZfPX31IE9haN9Wj3Tf3iMaArfz5SyuA2dduWbI94khwuAaevq75WVdcKpMlFspNGLChmzA9xU9+cbiS8O4YtjBdRRZWV8oWj74YwYfcoQQOrfKccctXVJMihPDXXMCba9N4RbT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448420; c=relaxed/simple;
	bh=Z/ENBCnxQhEDOCZDYBH4x6JMCA0J66mXU/0mUADj5fU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0IXpU4kKTTL2P/X4JXUa9v6DzD9/v0edho2Q+Cr8BQzjkEZKMgO8otojK5YNVoZHDUmjKP0bahaG3vwMIuQmFzhuktaDNg49zw2DdbN1tvx6YY3BA74e0K49fdfJsb6rEMWL9Obd5RP9Xpl5j4DnHfjNKoJI+CseoI6UEmrOiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WyKwij8N; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WyKwij8N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7zvAmP+JcSs4QXz7+a2fW6ihhQwddeMuvI7aJuAsdjg=; 
	b=WyKwij8NRSTCL1T4GQpAmysAhtLGEhU0pjIleugYmmk+OmgJDiiWoAZvoaQyVtgyFpBt56x58zx
	TtMui7NP7rpXCFufwvT6xi8EFtyI5jcdqiiUO06HfYsBfPta8v0OZkU69sgDiDK6zMNAEhCS8Jlba
	OY99iw/JOhtV2/JyTV1oFgw4OvZnnDVWgrlPmaJxKdRY/KhycAdyUfVvSHQP5WUPFPlA4QL2BxSSR
	CW0h62s1WoLAg5WZsyAH1zv+/++/NCeS3OmaNupS4N8YHzPseNZGNobAzwdvOQnX3xY1TzTZL+/85
	Qdjm9+igWgyoa1Z4pE32aim2Khbvt71JyMGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjZ6-00000001o4e-1Jbf;
	Thu, 08 Oct 2026 16:33:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:33:24 +1100
Date: Thu, 8 Oct 2026 19:33:24 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Can Peng <pengcan@kylinos.cn>, Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: stm32 - drop redundant initializations
Message-ID: <asdVVLPbRuD_96PZ@gondor.apana.org.au>
References: <20261002143556.43214-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002143556.43214-2-blum@kernel.org>

On Fri, Oct 02, 2026 at 04:35:53PM +0200, Thorsten Blum wrote:
> The variables are reassigned before their initial values are read - drop
> the redundant initializations.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/stm32-rng.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
