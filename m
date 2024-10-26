Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CDC17C;
	Sat, 26 Oct 2024 06:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729924271; cv=none; b=OlxwM1Xjw4CQx+D6lp1raYtOpinfWGZef7seXB8ALg59PpXe9mErXlpDj/j2MHVszk0G0OeeoeP+IZX2KaWi91viaWutHfC/+ClVsSJT9LLR40R/7Rhd70jaggl2UtGcf5u6foegRed+/c2Z0yoxiMeXptEglg6mOO+V8pjR6ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729924271; c=relaxed/simple;
	bh=lBfMn1B5bivKwkhJa5oIr62Gy1KJXNDR/JQWVKMfAdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdOprDNqztubY2xuiDf5+iuGsTt++dX+MzMzLZ8NqQ0i3KSfkqGMcjg2w6VYffKhnh7aRZjgJKdfxLdnmzTsXIERyziKI2Enmf5KgDGVd2F/bSeaJIGLU3jku49nQF75M/Z8Zx7SsdkhFPEdxvqTXWkJ1suCWy/wMcSSv4MoaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FUcE4GQl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FUcE4GQl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UeETOkMVFm2TFJxstCe99mVtoDs6lMro4XEgzTXc0Pk=; b=FUcE4GQl4uwYV/u/M2l89P86K2
	BCJ+6ISuk5C6l3q/Bq8LCYkXLOMHrBUXgUM6W7skDsAeQlMEvSajyF0YH+4numwPieTPAGRPIzJwX
	xtG1idBjn/cK4xyyOsFBcFr6biMODPX9NjWjSp7uFiFXavxPvJ46iwji7r/qk1K/f/Jwx7OE+/bRS
	PYy6gRx/g8wiiGhjbYnuuhPeiFj8cO+grEI0wjFGx9rYdf7uZglHG5PAHrJ4U1uUVPkoA9AhsuTCe
	r+rFr2VnjHgXuCAx57ZU54+4pC6jopYLBwtR+aFCAeuDhY6vY6J63J+yEVDvJO0AUG82wTAHqnZRo
	vclNR4bg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4aK5-00CFgm-19;
	Sat, 26 Oct 2024 14:30:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:30:53 +0800
Date: Sat, 26 Oct 2024 14:30:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 1/2] crypto: hisilicon/sec2 - fix for aead icv error
Message-ID: <ZxyMnWbTkf7JEnT7@gondor.apana.org.au>
References: <20241018105830.169212-1-huangchenghai2@huawei.com>
 <20241018105830.169212-2-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018105830.169212-2-huangchenghai2@huawei.com>

On Fri, Oct 18, 2024 at 06:58:29PM +0800, Chenghai Huang wrote:
>
> @@ -911,10 +910,8 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
>  		return -EINVAL;
>  	}
>  	if (!c_req->encrypt && ctx->alg_type == SEC_AEAD) {
> -		tfm = crypto_aead_reqtfm(aead_req);
> -		authsize = crypto_aead_authsize(tfm);
> -		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - authsize;
> -		memcpy(a_req->out_mac, mac_offset, authsize);
> +		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - a_ctx->authsize;
> +		memcpy(a_req->out_mac, mac_offset, a_ctx->authsize);

You've lost me.  a_ctx->authsize is set to the value of
crypto_aead_authsize(tfm).  In other words nothing has changed.
What am I missing?

> @@ -2356,10 +2331,12 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
>  	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
>  	struct sec_req *req = aead_request_ctx(a_req);
>  	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
> +	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
>  	int ret;
>  
>  	req->flag = a_req->base.flags;
>  	req->aead_req.aead_req = a_req;
> +	a_ctx->authsize = crypto_aead_authsize(tfm);
>  	req->c_req.encrypt = encrypt;
>  	req->ctx = ctx;

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
