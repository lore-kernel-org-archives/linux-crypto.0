Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544023AE6FA;
	Fri, 18 Sep 2026 09:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722812; cv=none; b=GmO0a0F0XhKaXjxCBkE/19i5mERiHJxx4Rb6J/2mDAzB4HLvhhbPvQizfeoShv3CNWdKJ0szLTWS+QXtmOxImdE947nLbV3Y5hG1YBYYgWoDgzwTHiRirzCFMJH0JaMZM3gWN9lU5ysRTW3khjpaEg9nTNK4OzroGsoOMuXxlOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722812; c=relaxed/simple;
	bh=roQp6ZtuJAwWznFEYsqXd9PRQS4+tptsOWj0ORTZdbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJtJ6u7tQWeWEgPakHv2sN75HfpmMttriTL+Ryluirg0XS1ERIpAEUpgn1H7g8DH/rEaZgGd5wdDeS1cDf5wn4fIabCzwHWDv+dSOFCZO2/28VVhntyvFpf9TVe22nZ828anO16wXztg//rCePxD8CrErioZoni07vkfZhMLv+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=S6WGALYz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="S6WGALYz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VM9TEEKFpNgfG6OQ1DzUhmw/h6ZpmwuxRb13EkzzIDc=; 
	b=S6WGALYzJ5wCX0syFBKOMcjy2rwP7LrwdZdg7ilt4/f58LJ3ZwBsjOU66ZROmyaYT5mV9xuFJ8K
	9y5VBCEwKKabg4Bo3E4tty33YfcJZnR983F3WAR1ADO6tje3eLLDHYzgsfhOST8+ChOi/IDCRZJmg
	FGkodlfF/x3YohuFs19m2axFLB7jsVNhrC7zIF/M6+QtfKCH8wmUrxID+BoiDsjZc6UOzjO9xnufu
	SmH0QyKTldkjJMHjs6Ulo+oliBDfHW2DT/T51bL+in8wJPRZpHtyXJ2rGZgHvYfia99gSJeOHFuzg
	gXYimoLb6nNFsWbQfF1kgcuXzrKhCZP7ExDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7Uer-0000000FL6R-0DWr;
	Fri, 18 Sep 2026 17:13:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:13:25 +1000
Date: Fri, 18 Sep 2026 19:13:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com,
	linwenkai6@hisilicon.com
Subject: Re: [PATCH 2/4] crypto: hisilicon/sec2 - fix scheduling while atomic
 in aead soft fallback
Message-ID: <aq0AtfUHUw1qOD2Y@gondor.apana.org.au>
References: <20260911102942.387778-1-huangchenghai2@huawei.com>
 <20260911102942.387778-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911102942.387778-3-huangchenghai2@huawei.com>

On Fri, Sep 11, 2026 at 06:29:40PM +0800, Chenghai Huang wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> sec_aead_soft_crypto() allocates the sub-request with GFP_KERNEL, which
> may sleep.  This is safe when called directly from sec_aead_crypto()
> (process context), but the function is also reachable through the
> backlog drain path.
> 
> When an AEAD request sits in the backlog queue and qp_send_message()
> returns a non-EBUSY error, the backlog is drained in software while
> the backlog spinlock is still held. The GFP_KERNEL allocation inside
> aead_request_alloc() can then schedule out, triggering scheduling
> while atomic.
> 
> Fix it by switching the allocation to GFP_ATOMIC so it is safe in both
> the process-context path and the spinlock-held backlog drain path.
> 
> Fixes: 0a2a464f8631 ("crypto: hisilicon/sec - fix the aead software fallback for engine")
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index 0a2f7c8b44fc..bbb6826ab256 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -2533,7 +2533,7 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
>  	struct aead_request *subreq;
>  	int ret;
>  
> -	subreq = aead_request_alloc(a_ctx->fallback_aead_tfm, GFP_KERNEL);
> +	subreq = aead_request_alloc(a_ctx->fallback_aead_tfm, GFP_ATOMIC);

Please use SYNC_AEAD_REQUEST_ON_STACK for the fallback.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
