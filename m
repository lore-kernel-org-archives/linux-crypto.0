Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E71862;
	Mon, 20 Jul 2026 01:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784510449; cv=none; b=AyYyKuJx7iO/7fUsF6Zm/+3rHTbDRsIKrltuB36zpsR4Kbai5tdT7Z/GnGRbZ/CfC12jkJL5YAvJqaVIaLCkEAOwDhijYuxee8m+r6LefLUXES8fKc78xU6Zr3MECgKPkQNtnMEuXCxvJZ4ssGZZtcSzb7DwL/a84xkcVO6rO3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784510449; c=relaxed/simple;
	bh=gIoLXvoLR3PGjEglC5P3oJlvkZ7yqW5U1sq3ZKmkZkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak5a2E9t7QV+RX5Nhx0RxmRVaf7sg7cSdtpzC6nH9nZlmVENli2y5HHMiP2OdbGebxiDrLejQ6GiKhBLFl5QzzsCe5zNJK0xCMbgI4wCw4YRmBqazL7nTe7UxUZNRP2xYaTenWzLTMPdOIQ85n0UGZZeTrYa+3+fsmnmIjCgbUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kSCNF/K2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kSCNF/K2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+WNTOP19hSxd9LtjWUtrMGiOZ9xlFIJgiLKC8Et7ISw=; 
	b=kSCNF/K2dVJ1Tn9RcBWuxKQEJE6EflQW1gMNM+G5uepKzQC/7cH4THl8agczyMvIx3H2iiToV68
	2iHm394wB8NVN3YcFtEXKvp9QGao16PBngKHNcZXAnH9/U/3pPvSqYAOLPgwpJgHoBvv0XUrzflYQ
	SOZbB8ZdkbQSBpED58n9TBChw3QIfuF+FmYpWLeXFsARUFj8cqWcvQKpv1BqxdkYporri5Js1YR+0
	7ni9Hk8oO4kZ3U6m2t0XUs2qRjbTNaD0J4IVQTFviHMIeEIDhjUZwrbo6c4q1nSqN7/uwzr2UqknF
	9XLGOpdoOQg2G0uzHeiq/Auszqi/auT9+aSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wlcgO-0000000Ey8z-1Mv3;
	Mon, 20 Jul 2026 09:20:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Jul 2026 11:20:36 +1000
Date: Mon, 20 Jul 2026 11:20:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vladislav Dronov <vdronov@redhat.com>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tegra - fix rctx->cryptlen in
 tegra_gcm_do_one_req()
Message-ID: <al135EQMcdtTnHxZ@gondor.apana.org.au>
References: <20260719171302.15078-1-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719171302.15078-1-vdronov@redhat.com>

On Sun, Jul 19, 2026 at 07:13:02PM +0200, Vladislav Dronov wrote:
> Perform rctx->cryptlen calculation in tegra_gcm_do_one_req() the same way
> it is done in tegra_ccm_crypt_init(). The current formulae may lead to a
> crash if a caller does not call tegra_gcm_setauthsize() and so ctx->authsize
> remains zero. Then a decrypt operation with incorrect rctx->cryptlen will
> lead to a write beyound rctx->dst_sg buffer.
> 
> Signed-off-by: Vladislav Dronov <vdronov@redhat.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Vladis.

Please also do a follow-up cleanup that deletes ctx->authsize since
it appears to be completely unused.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
