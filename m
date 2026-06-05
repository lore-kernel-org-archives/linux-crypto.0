Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA564183D5;
	Fri,  5 Jun 2026 10:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780655544; cv=none; b=NizeckKf0aqzYsLtH4S/7meWQLa3CdhuWVEu+c/fztUO91iqfBe2q/ghNt140rCmkDU23A7c23MMduN7wuFrbAJyz/Hko2i2kgL5x+kTkolVjV27GIoJf4LnAyZq+SdSlSSjA9rFIwsZlYbNhUAiAxvNVdFWorEHaGrwDh4qhbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780655544; c=relaxed/simple;
	bh=BbjK/2QigkTOms2k/oYPbsW8B3hZYOgI7MJ/cpsjFHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoVb6dpog9qTgHqGUTLOasYXTXjqZBzEU/7M9GD24a599wvPm3N6+Al35DV4RL0NPvM6Y0w2NAErbaWdf6Bed7/nk/2C+uMWDq2GhTiuYi1/zuTxHXX5IuL4PDs35uluWJJNs+7COJfKyZHQse2ay7nDaCaDEVJ7L/Q3vnxqzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZvR7Opl8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZvR7Opl8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WXe7Ct4+XNpzH/EC6qkLPStSGUHKUoWOcXQbLurzEG8=; 
	b=ZvR7Opl8OoqDs/yxmqeM1WMup9/9/JTa3It7ZWBsKXB5bHqwRw8ZSe9HCpUXUaexIhoL8Vxt8Ha
	nVBIskULGAX71ZvqJ/hxvb7dnzbn7q1l3xchSlmqxYm/exbBwOhmXoqCDWyf0dmwYIlU+depB5iiw
	nw7wIOVPzPwfVTkSmk04BCH46G4CAARpV6DQBPjQDH1zfj8bjWsFDOK5iCWUdddyqRrq5zEVKmHaE
	hW3bsNSO+pKBtVOocwWmCNgxCTNmdiUrTVOfK1OW/H0edGaLmlNbhN+3DT0wADRTpgbxqTD/JNHJZ
	QntTlqCeRb5bNiZc6ndz9f86ISXiy2hNBF/A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVRqQ-002nYy-2I;
	Fri, 05 Jun 2026 18:32:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 18:32:06 +0800
Date: Fri, 5 Jun 2026 18:32:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio: fix inflight counter leak in
 chcr_aes_encrypt()
Message-ID: <aiKlpvKfVhEYpBj8@gondor.apana.org.au>
References: <20260526155736.2297383-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526155736.2297383-1-vulab@iscas.ac.cn>

On Tue, May 26, 2026 at 03:57:36PM +0000, Wentao Liang wrote:
> chcr_aes_encrypt() increments dev->inflight via atomic_inc() before
> submitting the cipher operation. If chcr_start_cipher() subsequently
> fails, the function returns an error without decrementing dev->inflight,
> causing the counter to drift and potentially stalling future operations
> that rely on the counter reaching zero.
> 
> Add atomic_dec(&dev->inflight) on the chcr_start_cipher() failure path
> to restore the counter.
> 
> Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 6dec42282768..eece1ac1085a 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -1359,7 +1359,7 @@ static int chcr_aes_encrypt(struct skcipher_request *req)
>  	err = process_cipher(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx],
>  			     &skb, CHCR_ENCRYPT_OP);
>  	if (err || !skb)
> -		return  err;
> +		goto error;
>  	skb->dev = u_ctx->lldi.ports[0];
>  	set_wr_txq(skb, CPL_PRIORITY_DATA, reqctx->txqidx);
>  	chcr_send_wr(skb);

Doesn't the same problem exist in chcr_aes_decrypt?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
