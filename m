Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A924344D88;
	Sat, 15 Aug 2026 01:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757178; cv=none; b=sMs9JIFR8G7RFhc5zxujEC4IsMfiCBbnvGbAMfTA4/rLNxxY5A2ylKZXL9QQvKWtfO0m2NCb4o/AJTFDHR3/Ns0AkH8UHCmsEfWLnphHzI6Gt1rr5uG4tu+rTjLDuAWXfqSU7IsvEMGnCEQresyEsWWAjA9umSZz4VsrIQQ/js4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757178; c=relaxed/simple;
	bh=KhTNr/50lbXMx/ztsnuhARHGCEwZuYFRYqlpplZAUqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Od9haVP/yXipLsY0ElU4N0WSn+yRiX3FeZucG1JCWjl3N0p4QkvxHYWo9skqBk0z9BGaQ8n1VOvUuAP0RST9TggZFP94HUSGTd+g26xt/HyK379bo47+aDCYrezMlFxjiA1EtlNRUPcz4OXg99dvdibc5yFIi7GlNIiGif3h0uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gFGR6T/3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gFGR6T/3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=k9u2F0jxMQRDWxjUAvaCbrfLZGFeFer9UNUh8841OWA=; 
	b=gFGR6T/3VF0WvOFXCsRf36W8uN75NWjriGkrGpSinn+s0kerkkMJUkwLvsIH2mjSljD4U3F3jQK
	RGMkYSNzS7wrUu1pHU04XO9QZyrKwCUhCdsNmZ75D/sPk+k+LleJiOLU1N9SmiOjxEpUhYsU2vwQZ
	wAoIaAz/Ml71pKpR/He23rVMpg0Oue7SLCFK03H4wFdN8zM+j7ZZBergr2OghRtiBnCmRZfiJfJvL
	Jor52PbFFn0x/ExXf901euLyMWs5zsqzR53HFeaFR2Fza/ipU6+gJueYD4VgRirU+1QyBDP/kTZoa
	owUDrsqQmPUEww9eKX7Y87w/CF8XVzzwfmKw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv39w-000000054ti-12Nt;
	Sat, 15 Aug 2026 09:26:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:26:04 +1000
Date: Sat, 15 Aug 2026 11:26:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jeffrey Altman <jaltman@auristor.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto/krb5: use kfree_sensitive() for derived key
 buffers
Message-ID: <an_ALPtrIGVPoGhh@gondor.apana.org.au>
References: <20260803192621.329577-1-linux@jaseg.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260803192621.329577-1-linux@jaseg.de>

On Mon, Aug 03, 2026 at 09:26:21PM +0200, Jan Sebastian Götte wrote:
> crypto_krb5_prepare_encryption() and crypto_krb5_prepare_checksum()
> free the buffer holding the freshly derived keys with plain kfree(),
> leaving the key material behind in the freed slab object.
> 
> Fixes: 3936f02bf2d3 ("crypto/krb5: Implement Kerberos crypto core")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
> ---
>  crypto/krb5/krb5_api.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
