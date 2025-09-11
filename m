Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4E4242938;
	Thu, 11 Sep 2025 05:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757569757; cv=none; b=H2DdANrka94TvIU1vjaGBDeNODNycculsE9dd1VpIksPOuywoHuNlv0ElD9W5Q+12CpMePQHCQA2OC6scvwmgenmwKTxe35668VdDpwiHJ4YL2AACtB7OINh524lS3PxcECQsx4P+zPXWxW5LKu6vQpT7Kf9Pt6dcvWW0WFwUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757569757; c=relaxed/simple;
	bh=nHJHmiZpr3gHTpUGzwXHXYJ7MWK9sCOvSdxrSN+Zw+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INRvr0kc8dClbNRLC3QVcJF8Rv3RhqodliyeeUS8x+x7ZB+1GtFrvDd5NIj6v6XrJ00WPYFtecq4D54HBygtN0qFDiZq+he9VInihEZ2/92hBtwKO+hjzc9AcmAIZe7SMwK2MIPFQPa/O/eCeXaCTld94sELvSDMHIUyLkpW/+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=K8PX+Dik; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="K8PX+Dik"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VoD98y0NHyUKZm+Z1qwT/gbNVGzSKvRVpvXW9KHn/cQ=; b=K8PX+Dik8R2fVJNxknZjALd8cs
	AleWsxuNTWkIyVzY/OEzwB1mM0Ikf8CRkkQcJV39VkCBy7yQsrl9ROms8YiIXwDfMtUcqI17nB1wx
	Bb40lDRqLR0Pr1W9E76+tD2eBIADjZYrGsWP6uHbVgJR8S2VnTWbl8CNURInFtGBJPQHbHKW0/otX
	4B0bhhBfecy9jdf9FEn39ExEqEYYjR8A8Sucsehu6HyD8E4oUd+3vEBAH6Og8nKXHf+nM2OVY724H
	OEOZzTjcmwpMZpZz/z2KmCOxlJD6V27s/e6FadhGNdtOz0wEbVkeJNFhbGf4oIPqkpAekIcl8CJv0
	xzGUgQBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uwZvR-004RVn-1t;
	Thu, 11 Sep 2025 13:48:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Sep 2025 13:48:49 +0800
Date: Thu, 11 Sep 2025 13:48:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
	Vladis Dronov <vdronov@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-modules@vger.kernel.org,
	Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
Subject: Re: [PATCH RFC 005/104] crypto: hide crypto_default_rng variable
Message-ID: <aMJiwScCaA4gq1yQ@gondor.apana.org.au>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-6-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904155216.460962-6-vegard.nossum@oracle.com>

On Thu, Sep 04, 2025 at 05:50:37PM +0200, Vegard Nossum wrote:
>
> -int crypto_get_default_rng(void)
> +int crypto_get_default_rng(struct crypto_rng **result)

The usual way to do this is

	struct crypto_rng *crypto_get_default_rng(void)

and return the error value as an ERR_PTR().

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
