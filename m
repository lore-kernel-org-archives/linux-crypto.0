Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC861A6835;
	Sat, 19 Sep 2026 04:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789790921; cv=none; b=RkxKmkkNo0L8EFbQGL728rzU5XNcY8MdlSiixfQCzSNARAFjOwyHIEIpsD/fveIxyRo62Otjh15cjdrMcSCkfQacnR97kvNO+CtJBs7z1Sc+HcXIWWHDOk3fBrWgx7DrhhKrM2WH+x1fTscxZZfaVAq149LK9DV6kmaVBitrta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789790921; c=relaxed/simple;
	bh=qyvOyQLD9w0fiWG56DjkaZLTDZRO/IUSvLTt2c+jEZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJCfBKia3t29xx/khLTxxp9eFAT9SK+jwvnerfjCUNY0G5KEgp26TvXxChujPOCJodGfURwVTrPbpWpjfxRtIYqh4kdcff295o45kXufEePYgiipsWl3TUl0GADdDU0kpfvzKczIchm2W4beoGh2WiP9aAISknJY3RThDGGHUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JHU7Bwkj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JHU7Bwkj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=E54W9vNKYtwYJPY4XZ4dSKVMR8thPWKxCqGGyDy3hzA=; 
	b=JHU7Bwkj5z2Uiy+SHta97WFr8UyTVTpFt/zIBFgV1mpJEuwYRnZMeGJZfu/NVPfSgRnon0uW3n+
	7ukpdAPKi22dzjtHhehMuxSwetoWjGSTKBzqOWcvuRzeDbnGltB/WxQ3BgPcj/70XO/ajRXJf839H
	9Kub4QiARbbZZwW4eauGAQxljTj5p8BuKo2qBSy2zT4XhrF8iOYYDIMPNueVSB5tiriK8U4UsL0ja
	h7vXoKfGxVl13iqzqC/Fkn+CHioZpuaipSc+sLiyTiaEbBcQ10dddqem9aHemJFVfxk2S1aSb0kTr
	FmuzsfxTvUzv6UgWG3KxNYbimo/+2s0S8zOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7mNM-0000000Fda6-0RWF;
	Sat, 19 Sep 2026 12:08:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Sep 2026 14:08:32 +1000
Date: Sat, 19 Sep 2026 14:08:32 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leonid Ravich <lravich@amazon.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, ebiggers@kernel.org, snitzer@kernel.org,
	mpatocka@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH v5 4/5] dm crypt: batch a bio segment's sectors via dun()
Message-ID: <aq4KwKXFBJctXlAY@gondor.apana.org.au>
References: <20260630083431.2772-1-lravich@amazon.com>
 <20260630083431.2772-5-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630083431.2772-5-lravich@amazon.com>

On Tue, Jun 30, 2026 at 08:34:30AM +0000, Leonid Ravich wrote:
>
> @@ -1410,7 +1452,9 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
>  		memcpy(iv, org_iv, cc->iv_size);
>  	}
>  
> -	skcipher_request_set_crypt(req, sg_in, sg_out, cc->sector_size, iv);
> +	skcipher_request_set_crypt(req, sg_in, sg_out, len, iv);
> +	/* A dun() tfm reads this; a plain skcipher ignores it (len is one sector). */
> +	skcipher_request_set_data_unit_size(req, sector_size);

Is this going to use the generated IV for reading through dm-crypt?
Shouldn't it be using the IV stored on disk instead of generating it
again for reading?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
