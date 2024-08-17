Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7B683CC8;
	Sat, 17 Aug 2024 07:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878540; cv=none; b=Fh6ghSHsFE+OPifL71cUGvZ3yjq1ZCoc7SoClWShIVDNwGVtvX84ShJvgPNXs9qK8pdQVc5wqL5TL10/jbt2H/KBuN6B61x55qx2v+YfEloT1gaStYArH4M1g4EGB6uEGCqlZ2BmXJwyRuY57v2Fxkd67SklxcpSw2/7DT+FP3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878540; c=relaxed/simple;
	bh=r2+UrI6+W45AwcGE5821zWllb6npl1HVdoJDKmiJ6+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNggrJZIPlEz/V7dhf7f0RzinRv744yezIu8RoCckoy/pmvvtrKoG5R7iG3BmqLO9irK4dehvqdZjs8yAnjsHlBr9K026swcVqPj9+Lq2X5zNoCvgY63Z3mURGjedK4Jzw9KUZIj32nHEKSESi51SfnKLU476iJv09m5rfg7HYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDPh-005IKB-0g;
	Sat, 17 Aug 2024 15:08:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:08:34 +0800
Date: Sat, 17 Aug 2024 15:08:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Haren Myneni <haren@us.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: nx - Use static_assert() to check struct
 sizes
Message-ID: <ZsBMckWJ_GXaBFme@gondor.apana.org.au>
References: <ZrVCAqGrl+5prW1Y@cute>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrVCAqGrl+5prW1Y@cute>

On Thu, Aug 08, 2024 at 04:09:06PM -0600, Gustavo A. R. Silva wrote:
> Commit 1e6b251ce175 ("crypto: nx - Avoid -Wflex-array-member-not-at-end
> warning") introduced tagged `struct nx842_crypto_header_hdr`. We want
> to ensure that when new members need to be added to the flexible
> structure, they are always included within this tagged struct.
> 
> So, we use `static_assert()` to ensure that the memory layout for
> both the flexible structure and the tagged struct is the same after
> any changes.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/nx/nx-842.h | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
