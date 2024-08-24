Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444AC15098F;
	Sat, 24 Aug 2024 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507401; cv=none; b=bYPRUm9gXqblL9VcNnrK5fplqPlAS5jmZjeNBtKCZ+5JD2y2kV+Ts23sSrsGG1bKaMsKpO4meqHJu+rYYNEj9/J1OYwfLH69Q3kHonjPzTG2WWuv37/PxISIxnax2/MD3+nnQkrnSumkhQfXYiapiXGtGCdwWbtZAFBQveSwt7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507401; c=relaxed/simple;
	bh=znVHH4Lq+mljaWsTBZHOEjf2uNcVBPlpXJTeg1bm300=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9KlWPQsEMnBl1lXbEJu3Tts/SYiXAHowR/v7ZiS65nwnDnKx6PF6BBoA5hR9Jm+3ZPJ6uyfgeORpfR8f0JwTYJpP4HXk+vKk2jusxpb0gTX2/u9YvcSPQ2T4+jvZSPss9p536kq66IqzNt+oeP/gZZIRcjiuR2ncTyZ2xEQ27U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shr0w-007210-15;
	Sat, 24 Aug 2024 21:49:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:49:55 +0800
Date: Sat, 24 Aug 2024 21:49:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Miller <davem@davemloft.net>, John Allen <john.allen@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH] crypto: ccp: Add additional information about an SEV
 firmware upgrade
Message-ID: <ZsnlA957VzeMX8qk@gondor.apana.org.au>
References: <bba259429fc14c4cac9ee4995dfb05d82065b67b.1723668160.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bba259429fc14c4cac9ee4995dfb05d82065b67b.1723668160.git.thomas.lendacky@amd.com>

On Wed, Aug 14, 2024 at 03:42:40PM -0500, Tom Lendacky wrote:
> Print additional information, in the form of the old and new versions of
> the SEV firmware, so that it can be seen what the base firmware was before
> the upgrade.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
