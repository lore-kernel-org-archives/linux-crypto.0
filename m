Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADC822F74D;
	Mon, 23 Jun 2025 09:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670412; cv=none; b=q1qGHm0qrMCTn2K+dKxzLQduHbXsTgvbk1Ln8w4T0TL4nqG/eCOHu2uSccc/F7Ij4BLJtBBN1IethHEoOpREXLlK3sTnoXYMnLG0EutWtpFb7in6EOF2TXEfu3CblldWtJaY0mDRien8+o0g4HrIxzP655rGoNWeASFkKyCuei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670412; c=relaxed/simple;
	bh=pgz5yZJHh1OA/qVvcjVcv+LfrTvsvl71ofScf4jNulY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7NG7sE2V3JLDE3mLOYL53ZWBKgwm3UKSlehtRkMs1gwC81lW3xFIiLYI+Huax3tL2ZLuldrSitSd6dfWlbz20yCC1ofaysz8EID85cvaSglV14l/NbE+xu7iDG99iZcLWfiGnkANxi/i4YnRgnZwBuH6l4lIsfAJFhRdiZxFpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nYRSKHTX; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nYRSKHTX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r5Jc+CQrkK73bB0V8VwOxnwQpA1eSxslP9GajFKoFdM=; b=nYRSKHTXEeTelqyfGQy1aN7iiZ
	xr7YRWqv8aWfQITslky2iZ/97dQZzgW+Zi1LlPTdX3rwAYV8MCjXDc2m42zHgrwUCVTfFtTo+ykRY
	7j4Dl3P6vY/wprFSkWowBm+1eKwXgan/psShKpZFciUWfxP9ZUUNEwUV5GzDn0zpnE//n7AhNK63e
	ej7/2BiyHmwVtSlMi3ssYiCKPl+vgHhFZp0acq2y57W4SANVnU95PxigG/azwq2143MxZbwXOi25B
	gZ7WS2JMGhzK9fZ/firYJDitv11isLyqhXg/EVDkofsINQqp23K0qWbuAxFTcEqenjW+pvo5s9lpy
	3+wxFGrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd5y-000FYD-2D;
	Mon, 23 Jun 2025 17:20:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:20:03 +0800
Date: Mon, 23 Jun 2025 17:20:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: ebiggers@kernel.org, linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <aFkcQ5yw7nPIRjcf@gondor.apana.org.au>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613103309.22440-1-giovanni.cabiddu@intel.com>

On Fri, Jun 13, 2025 at 11:32:27AM +0100, Giovanni Cabiddu wrote:
> Most kernel applications utilizing the crypto API operate synchronously
> and on small buffer sizes, therefore do not benefit from QAT acceleration.
> 
> Reduce the priority of QAT implementations for both skcipher and aead
> algorithms, allowing more suitable alternatives to be selected by default.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Link: https://lore.kernel.org/all/20250613012357.GA3603104@google.com/
> Cc: stable@vger.kernel.org
> ---
>  drivers/crypto/intel/qat/qat_common/qat_algs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
