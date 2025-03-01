Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F206728F5
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 07:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740814740; cv=none; b=ZOGNmhrMtelvVa9jQC8ZfSPVQNRCwtLXWR//Yovlod7+t4ZFMN8tpzB/Q5L6eZaaENWBEL9H9PX0XTjKDZWQC+K8zjzi87uObYEUf/fl921g7YcxqrVGYC9v3GiOMXVEm2ROSo6efDXpKp4C1Gy+fncf7ecqwh7WjK2s980DVfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740814740; c=relaxed/simple;
	bh=JnghmmWyzPl5/ruQzqxxTBr1/2h0S7DnIHHq5v5TNoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSuHGuDtTko31GSugZudXLdD2z9LsfsWuylJsnjaPduNt3Si8m37qea2gJDpDx5XG01cIxW4nnAEWaVf5Tk9HeuEjVggU066aXHnx1HpStJssHSoXQ33qUKx1Z2xf93y/RNKUmlT1dN/SlW0sg32FsfgIJy2uquTv4DRjnffxDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=h+wJVuyG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="h+wJVuyG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=L71zF+y7ql/yI9YZsnxpiUc90jcPNYGBSwMdLjupP+Y=; b=h+wJVuyGc07vOtHMeCGPYyWym8
	BAGuSRYxONoF7tt7TcKHoOoe0/0Irz2ImVvkAlWKi+LBHq5+dV+W0ES4aq5r8zz0+E7GzvFu2OUei
	hZO9e9hCd4qXIz7EQiEqz8YOzrYDOFv7GKOjv1gSRUJW/nmAYNfcq87P1huO8pLIOFe518XS4f5Yy
	EPUFlJupYEk+0agyxWBHiLH9cPgEZ6d5wcCeKg8ICYx9WGQbZks9IInqJnx1oMqjsi75lanExYocX
	V41oTghqRefmx3g0mXE7JoNJOcVFbtXiPia2MUdhH2GNxnBDkAFqjfzgw0zwqGWe5KG4JzceXRi37
	vS6MdMpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toHQv-002mdZ-2e;
	Sat, 01 Mar 2025 15:38:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 01 Mar 2025 15:38:49 +0800
Date: Sat, 1 Mar 2025 15:38:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8K5iWSH2FqyIvML@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8K4ibtteV3_hs7e@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8K4ibtteV3_hs7e@gondor.apana.org.au>

On Sat, Mar 01, 2025 at 03:34:33PM +0800, Herbert Xu wrote:
>
> So I'm withdrawing my acomp patch-set because the premise was wrong.
> The only user for acomp actually wants SG lists.

For a laugh I'm going to rewrite the LZO decomp code to take
an SG list as input.  That would then allow the decompression
path to run with zero copies even when the data spans two pages.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
