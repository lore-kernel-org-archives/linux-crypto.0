Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E424024E;
	Tue, 14 Jan 2025 03:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736826001; cv=none; b=SNjcUz01WCV/7Ntd1S+yjveTUOa78suNck7+TndmcNht3ApHkPyroH/wiHkIGUq6IZ0HCmFAUm1skmlmNXwyCTdBxSLqu+axtScpj2UxzyO/pBFTWFrE3WIhOS2r+1h68G7R/5AKZMls7VZrRVYQkdDQeHtZWxj8mEGyH2w4V8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736826001; c=relaxed/simple;
	bh=Z0QQpwzGoRsS7WNBQWq5pMf2h73cVOST2hrMfvFIovY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHuUVdWyVFxYwINRr98zsp9kekyauiz5mDmTAZpsrcRh9rtvEbRGR8m00VjPAKJ4eOoJ5hJsMUEnIqCdiYeiq270XQtGSqWkDlQv3bbGy3m1hKTP6yq17VYcVn6Kh29adMymOPPVS/eIEN/pWxC0vnUVoa0f7VUOT5HrkStSMaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TUaY0XDe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TUaY0XDe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nBMX/RwpVZLTrNmk+ewwXWbgiWs47A+kQ15hcZrKz0E=; b=TUaY0XDe+XiNnpwiTzBFn/qvk1
	x+5GZkHoWemrbCdaafLISTLO2vsF1OllMqJBpjCUlYeHxzc2FHNJU1OjLMo/txuFbzUto+Z+2PJkN
	MyOQD1xsmSlPo1hpB09OkBhl3kEifbcbl/XNXwbEL1vAGGSu9AzXknvvg4ixlUbzwmGpUVtoOANQv
	bLfcLbQ8dPbOWzhfffM8pnxzCtgFXGy1BB9OzTuuUHgI/RDxqWiYsG25kU/RcipHpKvHvGt4sN/fX
	EV2tLS97n5MhHjVOXBdFZJYeVIbJvfbElWwCzFQNgbaRIT/vrLB2dgMtzLs/+Bmd5vffU/nYG9G8R
	6EmkUzwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tXXZX-008xVM-0j;
	Tue, 14 Jan 2025 11:39:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Jan 2025 11:39:51 +0800
Date: Tue, 14 Jan 2025 11:39:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: proc - Use str_yes_no() and str_no_yes() helpers
Message-ID: <Z4Xch8hvC9yGTotS@gondor.apana.org.au>
References: <20241230113654.862432-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241230113654.862432-2-thorsten.blum@linux.dev>

On Mon, Dec 30, 2024 at 12:36:54PM +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_yes_no() and str_no_yes()
> helpers. Remove unnecessary curly braces.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/proc.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
