Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C971CAA62;
	Mon,  7 Jul 2025 03:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859045; cv=none; b=NlzqeItinNPfMhE+Q/gI9p0lU5isrZPqRddgjgHepHIMc7TqmSUhJip3pLl18OnR9OleatgESjB3kpInqrBb/q3THWZBjQQp8ugaBjgFJFwz+sUtKLUTllSn6TDOZbQfM9UIO0tz0Vw9nLzrvOmIut9g4lLqnJZ9psd3MHQb1Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859045; c=relaxed/simple;
	bh=p9jCjh3WFEk6XNNuNq5seuEgeXxwJkbt+GV4E7VM2CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVDRqixuBgprbN08xl1YHK2WjSbapDTEnyTswFVOQs11EPCy/EwAXriso3aWzeYvKc/SJWZG2mQz7/DHP8k8W7fVE2JZbs4I3koQr85p2NHiwCtLCAHb6CHXyuTr9wRxNg+5yimZ0atYCivmJuKVH8x79XQz0gQmTy3u54H54m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oRMlceRb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oRMlceRb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rFOorbQqXKdEiu+hNgh3SVZ7h5TX7HKgtsg8mnfh8mY=; b=oRMlceRbNzD2mC9oYrHsjQiK6h
	eNbWym+GO8rnCDlxkhsOjrP3Br5vJ5cqtxcLk70aZ+Pn4mAKpqyrqnYNeaVgCSjYKBCCPoTZKsis4
	6Mx+Zs4p0B8uvyFTcoIzjwmp61RtiPObfL904o5VSr/Xp9UZaKV156Xrop8iQSDjyz6lOUt/YMJV/
	Yd+WZHroGpldLY9jQu0Fjsd0Ay42JsxvOCWKbm6d8E5kgSwvzO68ReNGsewIlFjvyzvE+U0mjw1aD
	pb4tcARwlzgV2bq+F/esb/DC5IugTxuWqX+I3b2KNL0CcAAvh4jmwYO+gA/yiv5hneoPbcnKveYQF
	n0j0EECA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uYcJW-004Van-2k;
	Mon, 07 Jul 2025 11:30:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Jul 2025 15:30:39 +1200
Date: Mon, 7 Jul 2025 15:30:39 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Theil <theil.markus@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: jitter - fix intermediary handling
Message-ID: <aGs_X1RvsvbB01al@gondor.apana.org.au>
References: <20250621113643.107745-1-theil.markus@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621113643.107745-1-theil.markus@gmail.com>

On Sat, Jun 21, 2025 at 01:36:43PM +0200, Markus Theil wrote:
> The intermediary value was included in the wrong
> hash state. While there, adapt to user-space by
> setting the timestamp to 0 if stuck and inserting
> the values nevertheless.
> 
> Acked-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Markus Theil <theil.markus@gmail.com>
> ---
>  crypto/jitterentropy-kcapi.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
