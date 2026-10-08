Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5F41DE0D;
	Thu,  8 Oct 2026 08:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448260; cv=none; b=XyrtpUJ0lpBm7bKPyEVYDTFR+Upq9tRHTeB0XMat2B+fQ9QHdt+vxY1tLGjmxLjWsubMz+kk6Yhi5TJ8zHJ66gEpTUpM4uiYkk9bXF8yvGMR161qDq3gCBMebnFwcKiRdwFNNHcFmlf24GP5oZjh992wCz05KfSsheO8YCSNCnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448260; c=relaxed/simple;
	bh=nzmiGjvG45Ot80r/zMW/fLloAN8a8QuAj4T5PSk17yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuIYeebBBQVrdSwV94YgD6WbfXQJJoZ74eZ/+C7TJa9xzCqsQK0IlrdDE2ZA65+YF7lAwMEvqKdvYNys4+sPCJhO8Wt3mF0pXdkqjmlzj5x5A7XOOgCgSzk7yV8Rn0FobZBTyfvW+2CN+Xl3tKXni9o7Q4xRxAkrfeAmBgZNGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qIKjItQY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qIKjItQY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2cGg7vqN5gh+xfOnxcOPmZXmOQNKXNAIRvENkXIxNIs=; 
	b=qIKjItQYN06spk6nG1/hearX+DT3hfNdRQhof6XhrBWX4aJVgQMq9I3Go6ELye9qN+L0+8aBJ7B
	O6KKhFNwa9I8Mj2wLk0SNI+zOVCxeTHwfRI3zihruD2FkjvUZnLyiZ2U+jvZClcPbu90R3TPNN128
	SsuCMa1c6IvezVvY3Piib0+u7UHeAsMy/bHoqeD0GdcfdkYQlZhe3m21vnuS5aI3EiX22AX6B4ZIq
	HT6w39QBEBBtBgCv320uLip+/uZHDXqDRGv5eXUVEvgzc4w8qj+Ipv36U00oZJLFu48c4E8GBoMDT
	lDsUdKgmvSJC+LS6XcayUkPkxcLD8empvrvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjWf-00000001o1A-3ptC;
	Thu, 08 Oct 2026 16:30:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:30:53 +1100
Date: Thu, 8 Oct 2026 19:30:53 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: cctrng - drop redundant initializations
Message-ID: <asdUvWT-avPg7J2T@gondor.apana.org.au>
References: <20261001150603.143696-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001150603.143696-3-blum@kernel.org>

On Thu, Oct 01, 2026 at 05:06:04PM +0200, Thorsten Blum wrote:
> The variables are reassigned before their initial values are read - drop
> the redundant initializations.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
> Changes in v2:
> - Missed two redundant initializations
> - v1: https://lore.kernel.org/r/20260930200139.110437-4-blum@kernel.org/
> ---
>  drivers/char/hw_random/cctrng.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
