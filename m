Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A06918B0F
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 04:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742100579; cv=none; b=b9gJgxDuPtbKFT1bZZcudebnOsgVxh4ONJcumXfzylEB7aD/I3GDwEYSmPILRSfLdjxjHCbMhJzrI7/7Xm2uUtv6fTL5KQQuxiRS99vCbLd8gbW4ofpbKh8/CArNgsR2rPb2VTw6ENOwarCizMUzxGcs2od3w6ILFuDaI+ftGm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742100579; c=relaxed/simple;
	bh=GmhZ5iZ8tHZv81naPCPFSg2FUsq7XUSZX5B9Aw7E1+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4MKXHDCRVc18dg2LS4Q0yBfhm+G9QRO3AYcYlK7QGQzJVeeWADjYLjdPXCJrTaPncpwTKxOYKfUoa+zDmR1fc4cMyrnkqm1IlpsLGHjVbqXCEthf4LUhLspUy5h1jP/x5KxAFkAtutb01NkrF8UAfhPNtV7cel54wNkIXI/pSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmMHaEDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmMHaEDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD2CC4CEDD;
	Sun, 16 Mar 2025 04:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742100578;
	bh=GmhZ5iZ8tHZv81naPCPFSg2FUsq7XUSZX5B9Aw7E1+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pmMHaEDCpHvj7rpa8g9R90l/M0nY9vv1LNuefz7V/sDIsaXQZUrnSShcTLLIdIEb0
	 jedF/sHqge5PMPySLQy0elcx1IqQfv/DajA2bXWmPKBgcXI5uN859oPlZf+l8jJelq
	 uBjx1B3H/sIDt5oFCdhZaXuGj6HkGLzdwy7ZoS8Ep2UbpbD+DmwtWeDOygZPvk02Zt
	 HUGMd1MzmClYnjxz2WAeEWIQzarwMykUUSerpLZO+Sa6aK/HtUd4iu6ct3870Pkysm
	 wzgXRj2sW6ybBM63QuUeBG9+EaeX70/va6rViaDh91FgjeAg/sAR06RFDoowodCgRL
	 K6y06R1aqNz0w==
Date: Sat, 15 Mar 2025 21:49:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <20250316044937.GE117195@sol.localdomain>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>

On Sun, Mar 09, 2025 at 10:43:21AM +0800, Herbert Xu wrote:
> This adds request chaining

As I've said before, this would be much better handled by a function that
explicitly takes multiple buffers, rather than changing the whole API to make
every request ambiguously actually be a whole list of requests (whose behavior
also differs from submitting them individually in undocumented ways).

And again, as usual for your submissions, this has no tests or documentation.

- Eric
