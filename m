Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E672AE90;
	Mon,  7 Apr 2025 05:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003251; cv=none; b=eGxOO0ylDHbXaT4GaduzuX11B2R24Svs2qHFrvGrxLJDN37k1YQ5/FGPcOV3WZA1suGl1lZ1I5AfSRwJjIezew88KJBk1QTd3z1T85I4VSJHXeHqbAesgXxIIRVX7KDVyHHU56SB9AQnPHQLEaEdlcWuaAtFIS9R/ZFAeoJ8+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003251; c=relaxed/simple;
	bh=OTEQ1ZTFFuptBeQqjkypjU1aU78eHGga/dpkiCUlRGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuK6FtZR0qm2KbafQqYAjozOe2AtS3AcbT6DsKwMfxpqcQ1yQ6GxGT91Rsa74o2zexbvTKluQvm3/DLmjjxrK9LsvwDvTSaRU68EQoxDRmS7hUg5e0EeHZhBv4PGDnXV771YDHR8ncPbKuBF23WZV8dZmsmxg2b2VhJUHdu/Vao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=C7eGr4hO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="C7eGr4hO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W/sFNnnYDP3WM5i4aaEONeZU2u5ojVBXsZftT/kGcgo=; b=C7eGr4hOTrTiiXEE3bGhJ84JQE
	dD1jq82wFjlLLVOdirWYgTAS1eYh6TZtLyRaxQWAFRdRxgUsgRigv3SdxRhojeGCJQtvoor01W9sd
	9WUF5M+mCpKAwwhZbdLXpal8Nio3GrWjkUcyvarWfx7oQL7ap4KkTXFW1o81G0V5SFHt02gniUH/q
	B+kYilITx0XKqk5goMq5N6cpiGen0rsgTj41Pt4J/h57jgO1EZmdp5fumRvZQwKA89a/lOLZ2eh2r
	M0lyVr/CZYVCoxr9aGi7E2oWxvTViCS/S7V7SMNMuTEl14PrVa3bKzjcgEcw98TSxS6+U2jjIvQRW
	Lgv3gL6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1euY-00DNHA-10;
	Mon, 07 Apr 2025 13:20:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:20:42 +0800
Date: Mon, 7 Apr 2025 13:20:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: davem@davemloft.net, thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tegra: Fix IV usage for AES ECB
Message-ID: <Z_NgqqGqFtgF5xgT@gondor.apana.org.au>
References: <20250326145111.57991-1-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326145111.57991-1-akhilrajeev@nvidia.com>

On Wed, Mar 26, 2025 at 08:21:10PM +0530, Akhil R wrote:
> Modifying the crypto_request turns out to be not the right way to handle
> the stale value issue with the IV. Though the IV is not used for AES ECB,
> it eventually get used in algorithms like LRW in the next step after
> AES ECB encryption/decryption. Setting req->iv to NULL breaks the
> implementation of such algorithms. Hence modify only the local reqctx
> to check for IV.
> 
> Fixes: bde558220866 ("crypto: tegra - Set IV to NULL explicitly for AES ECB")
> Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
