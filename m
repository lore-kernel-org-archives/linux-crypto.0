Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D94178CDE;
	Sat, 26 Oct 2024 07:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729926282; cv=none; b=o0BNxtrMg+KTkgQsY6dTcMAd425cE1wKHPvHwdjFKxfnYzfLcgkoVxEAQWIH4uFvLqgpxrEuM9HHvzZicGPNHBJH8hf3GNW4H2M5aOYQslYgaNu7E3NGYZNoFvkbMsu24lRepI3OLKzk+uwOMr+YvRe0iJKASs8v4BwyIodCgg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729926282; c=relaxed/simple;
	bh=4AHEfbkYfSjiISLyOMEeSwKW27HAv+1y0xWqfm6mGP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DrlpmASLtYo/nJCEYgTnmJpxtuqUduosgp/6/rEd1CCJGqH1Dfg6KQl6V+i0RojlxyGFC0NLGxv9fiqoNcWKx72Zf97ABTi0g+AquZHI9RMejHLq4wzmqqqoS4O7F4167ZWLzyDpf7dX1UmjGT5qqkKOHHMNVHEf0BzEX7PltFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WIcWAaJw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WIcWAaJw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GyAPHbdRNpjTRD8bi2oQ4iGgZ9FyuuVKHeAWYMjPTL4=; b=WIcWAaJwG4ISeaZUWgfw77Y6pv
	6lvQlojSDr8PjS7bjoNOhTnzMM9TtUqr6zbxZKk2xvJMKouSrO/ocYJrp5AQifhCu2aAUiN/iqMTi
	1o4MBQg7Z5ThKV9GXm4P35u3fIfXT4BSwU1ARmW9bMQ5jUC0enUX0PvGp21G8RqCbFFM5VPHYk5mX
	s2x870BflmoJx1d8oiaVaXD0uC7JrPgXz5Q77PNUW05mcEug1/IffmVRZ0mWc65vBpvpkXQ8/Td6I
	ZGOZvyPYJx/Pu5SEiK4zmqT8WozlS6JyimgKKnrKx+8hb4BU05UH4fdj/dk5LDOb3m5hvY0GKJoRP
	mLNXAqJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4aqf-00CG2H-1M;
	Sat, 26 Oct 2024 15:04:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 15:04:33 +0800
Date: Sat, 26 Oct 2024 15:04:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: tegra - remove unneeded crypto_engine_stop()
 call
Message-ID: <ZxyUgfp7SzOM0xr4@gondor.apana.org.au>
References: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>

On Sun, Oct 20, 2024 at 10:25:31PM +0300, Ovidiu Panait wrote:
> The explicit crypto_engine_stop() call is not needed, as it is already
> called internally by crypto_engine_exit().
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
> Cc: Akhil R <akhilrajeev@nvidia.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: linux-tegra@vger.kernel.org
> 
>  drivers/crypto/tegra/tegra-se-main.c | 2 --
>  1 file changed, 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
