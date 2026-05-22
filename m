Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BE2228CB8;
	Fri, 22 May 2026 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452915; cv=none; b=lhzDWzZtMEkdx19brg3GYHIpGx77zE0Pwf+yOXgU78OIz28E6eNxQ/hMgXm7HiVYqqU9ZLs79G0yXHmPY07F44GoqPa0foByj7rN9brSaFaYUwFqWOSUSfrRMBTt/zMZKuIKfTPR7ajwlh3vKePdPKY1HZdfwssYV6IFupeHeJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452915; c=relaxed/simple;
	bh=f+D8SenTTALMhiI2mAuDOylSK+fEvqjt/QA/uNZVa08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeXoUUqt9l8LhMeIVsYyppJ9wRUVGtpmGDPy4YocMPsNZBhyV80YK28Ya7rtn2HeQd7lkakU7YbFVkyGtVtA8RxMp2KCcZ1DL2Mp6O2NWQONgtkVHd9ovWpgKmXBVZYtTNGWNosclk9jOey4nMEmuuNRXHqp5O8MzNniyLgDmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BwvAJUbk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BwvAJUbk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RoUd+Y48VZFNA0tM+iXmpy93jNUmFeESiRei3QMsZ/E=; 
	b=BwvAJUbkttOBz+4MrcGHELXHZc/EXgIEdoPt3KTPP6dNgWtGdrexG9uAFmZOA9BZHjdfDxMd1ZP
	uSKXOvljevd2FMI01mzG4shDjWvPjW69jdRDY4P0lSakElYuwoN052PEvnWmpIjK5tKSVAjwXCxn9
	f1GmTOeNB6RS+S5PmE1lNeEIiSIj4e1w07FMp+gItFeXqVFLwBqCIybyg3NCCcutxfIrgOEDgNhZ5
	7zCypFpkgtmGvRbZmkL455VsFXqzmAXBIAy1QcTcKN133UvZOWFRY5bwdGcEvfBhC6W0j3+F517HB
	uTYQUNPVYTnedDvNypAGH1kU/nTkuFVbNPSg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQOz6-00GSKJ-0b;
	Fri, 22 May 2026 20:28:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:28:12 +0800
Date: Fri, 22 May 2026 20:28:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cesa - use max to simplify mv_cesa_probe
Message-ID: <ahBL3JvM3aqrh8Qs@gondor.apana.org.au>
References: <20260512133415.302370-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512133415.302370-3-thorsten.blum@linux.dev>

On Tue, May 12, 2026 at 03:34:15PM +0200, Thorsten Blum wrote:
> Use max() to simplify mv_cesa_probe() and improve its readability.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/cesa/cesa.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
