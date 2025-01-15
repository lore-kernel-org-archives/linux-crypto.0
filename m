Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0B481D1
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2025 04:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736916149; cv=none; b=YNcayvzlTrB+NZeQGoFuI/V9eOlkePBi78gr5rYbU9/GZsKEZHjN6AxFKNkduUshWRdcBGDmEqoKg82C2BoARklengUNYOedPgciQMD9mliAR0EHPhzc4aAyJXdgedHxtEC+Dps6NIKBnql+52dDvsoBYa/RndptmiLaKU917vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736916149; c=relaxed/simple;
	bh=icmYtJsW6sW0ycEwPKJpAqwYk8BmKHN1oaA+6MxViTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxtXuycjAA//Cj5by/o3vCD8Q98H+Wim2sUJQO6bmfduVN9PKf/LFTeob6jkELSDeV2OUh3/zwvhLSlXxnYEZW15HgkPpiPhsf8QZVoFB5t/ey9to0WNc1wRAhJD3xxDq7AUf2HLnknWCD2VAOdYj4gNm14xkFSkWGDNcCgF/DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BM1ejyF7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BM1ejyF7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cDBkh2slymhQ5e/ddEHFjAuxAixQXuFs2Yw7LAGpHy8=; b=BM1ejyF7GtF3Gubgxwi6hz/Ejh
	PbHub0gkHDxC+HbfRwtIfxkMuxj8W/mM9AnnPvir+agEdBnqyS1Uoo7w+Zo8KAwEfcSLhTvXA6jB/
	HTc8zsqrXk4zaVAKVgQ5EIX5p7fgDT5YYNs3cJkVxknGlNpjUKX3vvDge7rg2w9wq0FpWBt8XMRWU
	xQ2tv9CsbCsEnmfpL5AWkUGATV+wvqYF9mSkDX8hI33awzmUxjkT8wCqGaNyAhER3BJRph71+1DaX
	4QYXwc5GEbRdwyoGoc9cxYvfnWBygzIaTK4m7gNWob2JIYPBiT0EUHcD5FpEkHUMRHNPQySP++ROK
	8By/9Dqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tXv1S-009Lcc-32;
	Wed, 15 Jan 2025 12:42:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Jan 2025 12:42:15 +0800
Date: Wed, 15 Jan 2025 12:42:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto: skcipher_walk cleanups
Message-ID: <Z4c8p8lQuvJmqflo@gondor.apana.org.au>
References: <20250105193416.36537-1-ebiggers@kernel.org>
 <Z4XeEiZtN7rLXCZV@gondor.apana.org.au>
 <20250115024020.GA60803@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115024020.GA60803@sol.localdomain>

On Tue, Jan 14, 2025 at 06:40:20PM -0800, Eric Biggers wrote:
>
> Did you forget to push this out?

Oops I did indeed.  It should be there now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
