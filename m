Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18D33BAD9B;
	Thu, 11 Jun 2026 08:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168132; cv=none; b=Ud9wvGLzYUq1drAQsf/zUbyTGRvOGJQ3z29AoOyveIoYJ1tYIztmJxNgZakttmqiPLkRxIIeoVtoax3QqetANtuM8Nlpk1X9OYxoNGlthiIud92gLokwZPWgAqwgaABNmfNShKGTNnwQAcq0xso9GqZpiTBbCe6zX615074jwhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168132; c=relaxed/simple;
	bh=EjysZ4q466U4CjRorId75exWpK2cykdobnNWz32Ax38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGxoYqqzSulcHHi6MHBhSwjH70GqW+jQV+7xLa5rSkoBtECrkHllXh0xPuFejFRVqHvgfKbjS0M17n9/0s0Ld9DKkJJ5NUksAIoqCliRiX8pzbgRCZhaM3KC5Xh9rNVdW2LwL+IOhJ+nq4Law5trhOYfk/gwkVUI4JvyHDIpTgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VM6jG7hf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VM6jG7hf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CR3A2dDva0uLF2AhHsEv/ds0RRniV9rJ8VnU5N4/N1o=; 
	b=VM6jG7hf2hRxhDD2tyVtiMngdCVqX3/4rCveWnnwvm0CRGyTeVkVz1wuhwj7F+f7RXrbeCNI8oS
	ugJ/Jvt82gGbMxOSYCZbOo6A9VBgs6/SQck/ErM4M2nqD9rm+mlR7xn58IPo08gAENtpDednML+8q
	n/jS3dv+tlJI0xKjI66pGjHW7xFggbGgBS0xpueGi/OaCZQIb43ddu7pcFqxx99m8IECZgdPWDETA
	ApobPeI0zvdt3+ShBs+98Hyu7eLMlPp00KjWipGwuGQRuWY1TMaCK8jlrkGkFwWaTINYmWc9uV5R0
	5aGmOoQy4+Su4K2vmPKKHqJQnFSyFXLazubQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbC8-00000004Xdu-3g5Y;
	Thu, 11 Jun 2026 16:55:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:55:24 +0800
Date: Thu, 11 Jun 2026 16:55:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: akhilrajeev@nvidia.com, davem@davemloft.net, thierry.reding@kernel.org,
	jonathanh@nvidia.com, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: tegra: fix refcount leak in
 tegra_se_host1x_submit()
Message-ID: <aip3_Hqk876NZFHf@gondor.apana.org.au>
References: <20260604102706.3787771-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604102706.3787771-1-vulab@iscas.ac.cn>

On Thu, Jun 04, 2026 at 10:27:06AM +0000, Wentao Liang wrote:
> The timeout error path in tegra_se_host1x_submit() returns without
> calling host1x_job_put(), while all other paths (success, submit
> error, pin error) properly release the job reference through the
> job_put label.  Since host1x_job_alloc() initializes the reference
> count and host1x_job_put() is required to drop it, omitting it on
> timeout causes a permanent refcount leak.
> 
> Fix this by redirecting the timeout return to the existing job_put
> label, ensuring the job reference and any associated syncpt
> references are consistently released.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/tegra/tegra-se-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
