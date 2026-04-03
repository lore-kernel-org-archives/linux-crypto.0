Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC2D237713
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775177063; cv=none; b=Zmv8ArWCb4KE+yNqsCtmC6qA/VhZf8s/eZNoX6gJE0fWeGswnSifKEDxVbZXjRzRIDqLCs30LP0HM2if9Sjg4GuV5FeZL6uBnxoPX6zhzI/uDZ6f9rAsEoujDr+S7e/jDv9jid2QvtSwhVRWcxQiVzRqu+4xZBZeZhvKozV4ndE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775177063; c=relaxed/simple;
	bh=qxqrQ6wKX9lQmiHQNeNN0srwUcwrN4TT3VBm3NEzn+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhKNpyTQNX2NjTT/qNLQ9Q+gaQ1NCgP9x0TyRYvAhfA5KnXq5MQx5ONXXK5KnfRgDLSjFGY0kQEMOqhyDrDZ6dHkFGYRlnPxS3dm3xo5Re74pC7bDhNs6WHr79gqigFwojVo8x6aN5cOipwhgaFaOwW/5DJuMIPnqUDpKwk9ja8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ImgPRD6w; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ImgPRD6w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=u4jJ9vo9vcaqqgi5LhFVhFnPvQpmbto8g6k9guRK7Dk=; 
	b=ImgPRD6wPOUVrbeclzzr32aiW6gGlQGxaDWmUnR5o84CxjYuMN6KlUWogUQ7+Ek+C1DN7SxvvEC
	5G1ROBOI0R9ZOH+BMK5He7INybbpOl+/s9DquB5Lo18M3U2woiaC+bIpL07d1KJVxBb795Tcwhbmg
	TSFJRBxRefcxa1ooDEzw/R5tobdVv9pM53lorJ/XKB9erm0uzwTv6G+r4+Bj23TZUPPVUBAmc2w8t
	GcsEKXdX3n3PQPrBIREE2SPNKhoZwOZZHOgmSuqJfwqYffhkIfcXdveFokuWRWJDgRFdg11ll4Wbk
	hCu0NDIue8h7mR8BL3DsSFwaSC1XU8sUalcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SEX-003QhD-19;
	Fri, 03 Apr 2026 08:44:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 08:44:16 +0800
Date: Fri, 3 Apr 2026 08:44:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Wojciech Drewek <wojciech.drewek@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH] crypto: acomp - fix wrong pointer in
 acomp_reqchain_done()
Message-ID: <ac8NYE0XsniCvNSk@gondor.apana.org.au>
References: <20260324180721.120175-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324180721.120175-1-giovanni.cabiddu@intel.com>

On Tue, Mar 24, 2026 at 06:07:09PM +0000, Giovanni Cabiddu wrote:
>
> @@ -251,7 +252,7 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
>  
>  static void acomp_reqchain_done(void *data, int err)
>  {
> -	struct acomp_req *req = data;
> +	struct acomp_req *req = container_of(data, struct acomp_req, chain);

How about just passing the request in as data?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
