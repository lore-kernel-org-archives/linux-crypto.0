Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDCE341057;
	Thu, 30 Jul 2026 07:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397240; cv=none; b=ZiCGFvB1smXhzvI4HdEvOHs/bTi6yUgFgQ9nqJ5Np7n2y993AElfGkz1sslAxrrOD4oBpXVbb4tizOvbpenXMtrRer5OgOjuw7lLuE5GGfqE/KK49Q6cZ3a//CEe87Ml93qYcV+cLSCqM4uQ0r+B2Eudbd0bT3L2vfYrIOQ0ZKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397240; c=relaxed/simple;
	bh=6dcmCeg+8o75c+QVmjpTq49I6K+tUG7tXPcuUgWWKVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzhyLMGAII3Clm4yAEMwM9eIhbWLjOO/YLB0tI5WR3vfmPSP6BkLPMYyxRny3ys/nkGzEJ708pzwv6CD0TS57+ivrSupUw6p9l5cJVat8iwro+ZRRAgBhCtl6p6Se8F/CJW/kW6DWSlM+zcq6OhHliyNRipTY4c2Uto6lnYU57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aUqKQLzo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aUqKQLzo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IHTgTVpfVKCDLh2C4fnu2GWlFtfYm3e5nD/x0N7+ohQ=; 
	b=aUqKQLzomMQxV12pvoRgDuNU6GVLPc9bta40vksgYwRjyWxPAVmjaPAaTHcKRGK4HhdH4MUbBaD
	kFb8grqmn4ewEbCE45MZGjBISorUepu+lST34lUn5JpaEzmusOvBUJPRfQeUpiyTllem2B0aPgK1u
	6czKHvnUlt5aG4zKRH5722eF4g/BslpId7Zo2oJtUbfIme6p1rGRtZrQsbazidDIeAsRcGQDFvz1+
	ci8ygjDnb+iwY/VjrLN8FUPJ0IJoRtv6y0HDyTO6Q5DAqP9u6u2uy3l+e9bo2vYTeVvkswH8UmYCN
	xUFnmUM/83Q+SDiJjcUYgL9ULy0KR3xFlvJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLNX-00000000RxG-341D;
	Thu, 30 Jul 2026 15:40:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:40:31 +1000
Date: Thu, 30 Jul 2026 17:40:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vladislav Dronov <vdronov@redhat.com>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: tegra - fix rctx->cryptlen calculation in
 tegra_gcm_do_one_req()
Message-ID: <amr_77QV3eM2nY-q@gondor.apana.org.au>
References: <al135EQMcdtTnHxZ@gondor.apana.org.au>
 <20260720223331.404050-1-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720223331.404050-1-vdronov@redhat.com>

On Tue, Jul 21, 2026 at 12:33:31AM +0200, Vladislav Dronov wrote:
> Perform rctx->cryptlen calculation in tegra_gcm_do_one_req() the same way
> it is done in tegra_ccm_crypt_init(). The current formulae may lead to a
> crash if a caller does not call tegra_gcm_setauthsize() and so ctx->authsize
> remains zero. Then a decrypt operation with incorrect rctx->cryptlen will
> lead to a write beyound rctx->dst_sg buffer.
> 
> As a follow-up cleanup delete struct tegra_aead_ctx->authsize field since
> it appears to be completely unused. Also simplify tegra_ccm_setauthsize()
> and tegra_gcm_setauthsize() functions respectively.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Vladislav Dronov <vdronov@redhat.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c | 22 +++-------------------
>  1 file changed, 3 insertions(+), 19 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
