Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A13F21E097;
	Fri, 29 May 2026 06:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034868; cv=none; b=cfgiXpR4sezWjTY7O6TgnHw2zjGaYrf6VwKpuVj3aDBUeWjlSV0pI+Q+6CUxOWN1gY7WNpu2w3RFtsd4g2LiOacDXW0REO1Npcs1cTelX+s8Bpr+PWzpU5741hAKQVmgxL8AzT6D+VeZbjL44NRVBwM4P8pDRo5sdZK63VouG0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034868; c=relaxed/simple;
	bh=1RuuZDQYnEkjTe4ZIOLXlOJqYfMls+CHDAGk7PkMtJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SNJUTSqK4P1/zk7D01Zv2anVt2zuxmIFXGmLhT+Sfq67JWosD/h51YnmhHPgkzF5Ogx/V56HWTE2jfGnnjwoWiRLQk6beSklH2aJXRBjGaiOEG+79cj7iudG0AOXEzgeyTBteuPW9b1Wy7is4oD2fTxAksnuFjL5lNIIgllH3Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rHuuy5GJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rHuuy5GJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+9SDfwD7MJrAghMpWxeQS0wnP+95uTpCtrFPjkkTmIQ=; 
	b=rHuuy5GJqQHxFVDZx/CLx+/QnGn3Iz0b0cJaFA+Kd1RPQjvXAHgLqphsVkkA0yfBuJEW2liSXOJ
	NqaFKtxNMoiBiaUwMZfXSe9/a/veX3PAsKXtJhbdauyPk7RCaXwuO89i6puyHJ05h4F/TQEx8lxUX
	soE9ffyKNLBaqxyQ9UvSGUslE2vucLC0S+kXwERety/hPkzjmZN9x30MnK/2vkXN0jHgFzG1Enbk3
	PzujOEXgkSH41dyOhlyoWlmshftN1ajruJTZULnquNxOxcwl3cYaZM8zSXaqvnvemlhZjLfvpRNt9
	/5nZC6yTbLwjRXKwfJq2n58pxuQH2pP9bMew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqNj-000dIk-0M;
	Fri, 29 May 2026 14:07:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:07:43 +0800
Date: Fri, 29 May 2026 14:07:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Williams <djbw@kernel.org>, x86@kernel.org,
	linux-coco@lists.linux.dev, "Pratik R . Sampat" <prsampat@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH kernel] crypto/ccp/tsm: Enable the root port after the
 endpoint
Message-ID: <ahktLwh4MzZkxvN-@gondor.apana.org.au>
References: <20260521074301.2369293-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521074301.2369293-1-aik@amd.com>

On Thu, May 21, 2026 at 05:43:01PM +1000, Alexey Kardashevskiy wrote:
> The PCIe r7.0, chapter "6.33.8 Other IDE Rules" mandates if selective IDE
> is enabled for config requersts, a stream must be enabled on the endpoint
> before enabling it on the rootport:
> 
> ===
> For Selective IDE, the Stream must not be used until it has been enabled in
> both Partner Ports. For cases where one of the Partner Ports is a Root Port
> and Selective IDE for Configuration Requests is enabled, the other
> Partner Port must be enabled prior to the Root Port. For other scenarios,
> the mechanisms to satisfy this requirement are implementation-specific.
> ===
> 
> Do what the spec says.
> 
> Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev-tsm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
