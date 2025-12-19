Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8FD14F112;
	Fri, 19 Dec 2025 07:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766128217; cv=none; b=kfrC2KnOT6JDAXPKrlvKgnGIe0fiJjew8KVnu6Kk+5rHOFevJythIF3nlIAjHD3dkIla0rEGBC68ID+5+e+gpYt8IdHUxGyP1TLxvgs0v9/AOv/aynf+zz4r68GX0/TH+LLyzFu91nqRXKANbrJsKSIN5n4wMzqzG/XGWqsVKx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766128217; c=relaxed/simple;
	bh=tthodktePkZw6QWs36L2wTy3x3xoJzO7EagOdaEqud4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxrCGBMNq/YNpFAJImgW4YfZcNxtPU59ef1ORSZvM880kTHn7r9bDjzLuRc9L+wj9OZIF1OjdOgYa8KSZTQU5/fUNmlZh0ODagiiTcbHLQnFye2coUTuYw11jFWwNTcxdaxKhh7J/FRfjeRITTMGxtSB4Cuk6Fly/MdQpzqHnZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SxVjGFwW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SxVjGFwW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0IdTEIJic/n+vUotbAdvyVrSN8GI4BHbcbwGgmGsDX4=; 
	b=SxVjGFwW7PDfb6EtVylzQLHOgQPASbXYqZ6QHZNjB4Biw5DnA5At9V42nsiFPfMIo31Pg/0iVsj
	1+bGae7zxqRRgT1OsnzqdOZuCa7BOdf0A/yb9+dwUz99buiGx/ZMxrjhDsuixIDYr/VmO0eDPnkUw
	ZM8B14tDyp36LP14fp0mI0iaOhq3EJ6m2eu/TheMXwjtUQ99oL7qLsC9N+M5tfehj33PXDRH9HWp5
	LfIuNULsrOVFcZ41E+V+PyiNseIQ/Y4gZtFP34fCIHRinj/Pg1B6NTXpOMIly+SeHBjbm7s2Wv2hD
	gIFo6wcewiqt9QVR1ZEpop0IELug2lYSz/eA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUcq-00BEkB-1A;
	Fri, 19 Dec 2025 15:10:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:10:08 +0800
Date: Fri, 19 Dec 2025 15:10:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: algapi - Use crypto_unregister_algs in
 crypto_register_algs
Message-ID: <aUT6UC1WmtiDCmXl@gondor.apana.org.au>
References: <20251211101555.802559-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211101555.802559-1-thorsten.blum@linux.dev>

On Thu, Dec 11, 2025 at 11:15:55AM +0100, Thorsten Blum wrote:
> Replace the for loop with a call to crypto_unregister_algs(). Return
> 'ret' immediately and remove the goto statement to simplify the error
> handling code.
> 
> In crypto_unregister_algs(), unregister the algorithms in reverse order.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/algapi.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
