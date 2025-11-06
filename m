Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7702D7395;
	Thu,  6 Nov 2025 07:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412869; cv=none; b=QNiqkMuX7gWzD45Hg1iwSMITrFe06IG7JVKkSSWA8QBHajoEbZ+tjpWhCmPZoh5RRoA5X1mUWQkK3xWgF6L7f2iVatEbExy8IJtQIPnjnV5d8ikuzu1Mz+IqnPA2uO8MSo1bpBiIZdaj0oN3ca6SRYr/BnnF8GpdVbssq0gV2YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412869; c=relaxed/simple;
	bh=bYPhqOAfs9dBcdi3Bee76JwQ8jloGQx9/UW23rCneRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9BK3g6TDL9QFdPFanWhAcUVmEyMkFipmG4IRm2CDBl0pPg1L/a2zpXlrFsxtXMpE372O6f9fZk2tqboZ1ETAIzbVdFMy0TKLmuMaZcpMR1tnzY2YfH0YlpXyB48isdgg6RqbwyXPre7cOdTCdvianEwuHoKbUtDayvP77MYxnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GzWsYZut; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GzWsYZut"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wzKwsCh2ybokgApSrSevGn4NpBmVNCBn/oBFlHbqd7g=; 
	b=GzWsYZutWvIVr+JMDhVxpkiTKQoDA8jUQwGBvQ7vGq02Dhx2OQp59TNIqb44y5o8JKhRr1qj0MS
	oDqELp0+BWR+ORPm3gh6DvDXN4t+PujTukC381irEdoNo0CH+XGzQyTNhJLOZ2Lu4SSZ4XcCexvH6
	guxgqCXPdY1cZ0h2Cj2cZW1rglB/FYGirANs7BHZofbHspSSwAIApxyNTlYozHxewOzP0IIvivb/W
	K4KQlqJyOY57ShTjsweLdnZ83mWqdabN5t8/MA/yYHCZfg5e7IjLhceK4afSk/k4c6sZFXFboayg8
	Bf0UzW5Y5sdTQReQMlmsnXpgKXCG2ZksMaZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGu5s-000raU-2Y;
	Thu, 06 Nov 2025 15:07:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:07:40 +0800
Date: Thu, 6 Nov 2025 15:07:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: deflate - Use struct_size to improve
 deflate_alloc_stream
Message-ID: <aQxJPAuSqSjNJTw4@gondor.apana.org.au>
References: <20251030163218.497730-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030163218.497730-1-thorsten.blum@linux.dev>

On Thu, Oct 30, 2025 at 05:32:17PM +0100, Thorsten Blum wrote:
> Use struct_size(), which provides additional compile-time checks for
> structures with flexible array members (e.g., __must_be_array()), to
> calculate the allocation size for a new 'deflate_stream'.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/deflate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch appiled.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
