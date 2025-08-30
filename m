Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D520F22D4DD
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 08:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543827; cv=none; b=t21RTzqR5FQk+UQDLCruFS9xKPlyXA65v5eF6UwRvsoMfWhRKppui9Quvo56ycg+5OIz5xjmlPI+PVnrQt1MXOD9dIWXqe2LRa7/EoJbcS5E7BitrKbVoSmjVz9bPs6nVv1eop2pgr3ruVJddtYj3i7c+lET39ktZYRN0w01vjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543827; c=relaxed/simple;
	bh=GO/QfiILV98yfmPX1DXUijW62O3bi+wL1Tlsvbaa0L0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=jXaMgeqS7u98vjGk3QAWKr32P8pDMYTNHH2K/QDNuS6XEH9q/uFYN9zaamd0RLmISYvXLKCSDMAISLN8cs7o0RCKRJeme0NgeeFYtXcCOtJI5T8u6LCf1mNwgMSKJ3HaLcYhwtI0DRzOvzBhUeGXQzD5fmv/2dy6OxUXA57MKfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JK97MzfZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JK97MzfZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aFiX2cMTfwUXbsAoAK0RidRjQFd9bQG2zA2JxO1CdPM=; b=JK97MzfZb4vhevaRyon2jcyOZr
	tgGFkLw1jjPHRrPD9/FDhk8VZ/1CWEsdQD+xYr6YpaN3y3uAyaXuZ6JXRmb4YwPSaivZk6QeNhAj5
	SjCM8DgJjj4/ugOEnI6G/PhDfR2+V1wjISxzyjzRIt3t+g0CSZJZQwb01D10sG/NaQCN3geY7i2Oj
	qQGIuh8NrSaO02iQj876s5gUv2XnninxnNaza5yUqnV7852bO8rkyuJPqy7NTDc5lHBVElTega6WF
	/cfnyz2EU6DtVpyeN2RTpcHaAM5PiqC+TNzPleH+/OG6jeciemiNY2qaJHPzXRdbkrp1U+sM3Lcqd
	0tVhMMQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH2U-00179x-22;
	Sat, 30 Aug 2025 16:50:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:50:19 +0800
Date: Sat, 30 Aug 2025 16:50:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	ebiggers@kernel.org
Subject: Re: [PATCH] crypto: arm64/aes - use SHA-256 library instead of
 crypto_shash
Message-ID: <aLK7S3MK8Go2XYQg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818224740.103925-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> In essiv_cbc_set_key(), just use the SHA-256 library instead of
> crypto_shash.  This is simpler and also slightly faster.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> arch/arm64/crypto/Kconfig    |  1 +
> arch/arm64/crypto/aes-glue.c | 21 +--------------------
> 2 files changed, 2 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
