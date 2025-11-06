Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBEE274650;
	Thu,  6 Nov 2025 07:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412601; cv=none; b=g/18gUCNchYXrbaf+rw3ubn+Pht/kD7XDSE8dOnq3YyiOVpin4peH/K2fj2rUWvZTWHVcTyt4LYlCe2vKIvCJwZ1fvvnhsyolT2o8IuTfhBQKpQdugeP9kqVATKsUgViOyHftC8lP3ZHWUa3V8NpOYVIo78qf4FT7vH6auNDnwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412601; c=relaxed/simple;
	bh=luvKqG+/GOGOix4yPCkK+aLwwsGNwrlXQvts34ptKps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3hXi8eHYwRTc/cnxbpqBsIgNOnbDXxTX/w4mDtd+dbP+K35ADrQXcKcEkYDLvK0pGdLQvUxidGAIUs4Y/5a6pyABXzqRMxkdA3WZH1YqsVoX0mOuxL7JI9zRaQeHGgbYtRrreqhM3tM4alLSX1Xn60xStyaZ6tcarhzoUlRA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bOaniV1x; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bOaniV1x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ua/mlvlW15KKa4KYEb4RgZ+N+5du1S24gKV99lPqDpA=; 
	b=bOaniV1xco/d37517Satw9EfqLfHooEcavMTeq9VX7Zd2JGNYenh6ezGfpx3qmvWCqPCjHo2+K8
	W6iGaFnB0+gnC1TZC6IDoSHnFLqn+Ianu2JuqzKnGjfGhMIonb7hbzTcriFvWmHcOrs159nl67vvN
	G6qhFpIC2mPDMSYoIl2866BsiheAg5UnWMZsT3J6jaePtXh04fk7fy3Dc50M5EyeN8IvnUau/Zvc/
	KnMu04c8tiaR2Q3o+jeGryY/m8+0CO7CvGN67MKDJd+n5fHSPXQpPimUWS3/apfl3/OhoC2I7RlSs
	BNkfUTAGUPA8w5BmzVmEjZhcqNSto41sNPWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGu1L-000rUI-2W;
	Thu, 06 Nov 2025 15:03:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:02:59 +0800
Date: Thu, 6 Nov 2025 15:02:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Miaoqian Lin <linmq006@gmail.com>
Cc: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kai Ye <yekai13@huawei.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/qm - Fix device reference leak in
 qm_get_qos_value
Message-ID: <aQxII1gx0PbV_oLK@gondor.apana.org.au>
References: <20251027150934.60013-1-linmq006@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027150934.60013-1-linmq006@gmail.com>

On Mon, Oct 27, 2025 at 11:09:34PM +0800, Miaoqian Lin wrote:
> The qm_get_qos_value() function calls bus_find_device_by_name() which
> increases the device reference count, but fails to call put_device()
> to balance the reference count and lead to a device reference leak.
> 
> Add put_device() calls in both the error path and success path to
> properly balance the reference count.
> 
> Found via static analysis.
> 
> Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
