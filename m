Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5B8E571
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 05:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744781011; cv=none; b=XAjasLneY5NKyt8HNvUHWnGAskHy78trH50HlyrzAQDYevs2x43UHxi+68A/vS+zyRiU6YIMuUruzniO+SKaJkWFvEj7Phc97jixWCmxtzV66fGjgpuAXCQHufMiwWonHSKUSEpWNs0hkTwcXAvVJeIbCZsSPu5YQRE637aUt5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744781011; c=relaxed/simple;
	bh=i8y0PD5CZWo0MjZxtefVNWdoLkMb4cnHp1/+yli4WUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHOXCdwxM4KQgDio3kWtYQ6PlIbrY1z0TbKeEHIbaMUXuqFHUAatE6/EgyI6XWk7r2qy8DENHo98izQFPJEOegafrxsbAfmL5AxK08P04pEYnWN+UdMldQ4upOb8yGXgImHhyGXl9xWQWXXIQZj+4Tduodij4zTsd5I0sIeEiyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qWhC8qZb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qWhC8qZb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Cfp8lWToO+zGme3lJa7dHsbqJADHhqOxzh2Ikedzztg=; b=qWhC8qZbpMoW2VipUEU1Peu3lP
	Apc8dYJ70PsI0Whzv8BAFZse4VcbZQDavzCtsGeXjxMKqw6LOdRn2tSz0l28yG/2hqYUOuo1O5sUA
	H9JADRg8Sx2FxQKDHnrdJL4nGdFH5M29oYeJR8N/DQj2iuBeBSucIBDzKcVW5qARU7H78JQd3yMld
	/8/AkPTxTKEpZdu6+mrO5eeS/W+LyTh95Jgld4KYzTtGzICz0PBA8iLe37SwKB3cCgFkNZoknTt5g
	bHqbIRX+FzuLat72/0oo02DTs3ELaPhu8R7tgCtVnh92vmNKEAcmL8oPQhvKhPrC+Amn7clCLVxQ0
	QRGEuyBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4vF5-00G5ZN-2L;
	Wed, 16 Apr 2025 13:23:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 13:23:23 +0800
Date: Wed, 16 Apr 2025 13:23:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/8] crypto: hash - Preparation for block-only shash
Message-ID: <Z_8-y1NkOSm7HY8C@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
 <20250413162933.GB16145@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413162933.GB16145@quark.localdomain>

On Sun, Apr 13, 2025 at 09:29:33AM -0700, Eric Biggers wrote:
>
> What is a "block-only shash" and why does it make sense?

It's not such a big deal with shash, especially if you use the library
plus block function model like sha256.

However, where it does make a big difference is with the drivers.

I'm only doing shash because I want to ensure that the export
format is identical between shash and ahash for a given algorithm,
so that you can fallback to shash even if you've already done an
export.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
