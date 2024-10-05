Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2637F6;
	Sat,  5 Oct 2024 05:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728104516; cv=none; b=u9+i4Y/pkQxNhIqT+WkKn7rDyf+3Z18l10SFg99Zcplagzbi/LYZhuajC3bYcRHB8jzvDyhGRBysIChiX/hqkyRhMujG0aY+rOxqXHZNpGZhsE5wMk56txW5bXpstZUH1MspJeTxOlEj47d3DGPxGMWE83A7oiarjY+yP92/tu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728104516; c=relaxed/simple;
	bh=PtAHF6nmFBjakNUMqDaVTY/lZAmyoAg3r19rlIXoY6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGDpfCXuXEuIYBl2ekE1lOMbRr8uKXtH1c8aDeU0XjvQSDkVPfNTnaPrF44m2Znxh3L37n1umcZ2qjhOQrETK55ayu3yCnLNdUQZuyymOfP0R0L94VqhaCs6MP3o7VFlAsJifdohArx+3eEpW14Xv4fTgIS7YeCqhGQGbp5B9ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VtxLH9Bq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VtxLH9Bq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3z6NNEarCXYn5FFImGq5AZYT+4SCo1bYJnN8MKuxYiY=; b=VtxLH9Bq9hm3hLFtWZaKX5OqqM
	bgp23Z7GkoSafWfDhhF55fktJuSXoK093IdAul4qul6QqNNfZjAke5dHOejJJqJKJQv7yubCOlQRJ
	V0ePqA/BRMxuJoJO2gBSPKJdebZwDhSmQXM6xN5TP6Fx4YtA16UX+xDkLZ54bWUCzarCHD9bdVEc6
	FwWahTlh2mtT/MD102UJWtKeQ863W5IJZAXZ5taqn9D1vSXEpjKVoH74iE8/geuFHWozZUUuhBTIl
	XUiTCAbktj/uvju3wd8/TiVo9kBqZyqNPlEpVAdlfUNUo0rAf+w0n8tna3p7Wna4dHVocqO6Sp3LT
	iwLYxOWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swwlS-0071IJ-1w;
	Sat, 05 Oct 2024 13:01:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:01:48 +0800
Date: Sat, 5 Oct 2024 13:01:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 1/2] crypto: hisilicon/sec2 - fix for aead icv error
Message-ID: <ZwDIPF58yX8r7bQO@gondor.apana.org.au>
References: <20240929112630.863282-1-huangchenghai2@huawei.com>
 <20240929112630.863282-2-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240929112630.863282-2-huangchenghai2@huawei.com>

On Sun, Sep 29, 2024 at 07:26:29PM +0800, Chenghai Huang wrote:
> When the AEAD algorithm is used for encryption or decryption,
> the input authentication length varies, the hardware needs to
> obtain the input length to pass the integrity check verification.
> Currently, the driver uses a fixed authentication length,which
> causes decryption failure, so the length configuration is modified.
> In addition, the step of setting the auth length is unnecessary,
> so it was deleted from the setkey function.
> 
> Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec.h        |   2 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 114 ++++++++-------------
>  drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
>  3 files changed, 42 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index 410c83712e28..bd75e5b4c777 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -36,6 +36,7 @@ struct sec_aead_req {
>  	dma_addr_t out_mac_dma;
>  	u8 *a_ivin;
>  	dma_addr_t a_ivin_dma;
> +	size_t authsize;
>  	struct aead_request *aead_req;
>  };
>  
> @@ -90,7 +91,6 @@ struct sec_auth_ctx {
>  	dma_addr_t a_key_dma;
>  	u8 *a_key;
>  	u8 a_key_len;
> -	u8 mac_len;
>  	u8 a_alg;
>  	bool fallback;
>  	struct crypto_shash *hash_tfm;

This makes no sense.  The authsize is an attribute of the tfm,
not the request.  Why are you moving it from the tfm context into
the request?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
