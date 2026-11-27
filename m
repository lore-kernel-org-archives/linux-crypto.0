Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795753805;
	b=dNYPuW/dwLKXKCfi7w5oYQODuGPgd6+MQ61um6er5GtWYArQYdtTzyL45mbmjCcPMYZc
	 9OthoKPgJCGvTm0bQOvGy5IkjVjJOgUcaYjqtEHg31m5NwheJvn4KscxQMBhxygzLcQNz
	 uG+1HjOfDDHHKgIoNYeEhI2CX94VikorRdl67Vq7GbIPrbiQTml3Yom3IVjFmjAhojhqW
	 YZMJ4XJTG1KFJNgh5589IP/LwrPm9KcEPNapiBLjgjMbzb57BwFa6fown0iKY1SZ9oljN
	 gpoDouSrBxi7ti5rtnaJ28z0DRlGSoQ0mnsycjU+f0+at26o7g7VMS2ZSrXrADOUd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753805;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=HVhye+rjgDmsCjpX2SwqjFpF4uhxTqFX9Wg2OTfFpuA=;
	b=l5TaIVPhs0OeaL7GD3xwphi14I6N98zVhyKb07W+jXacQZO8MxqjQa/EdSvA3LLErtd3
	 DTp5St34FatZnvfdkpVFQOF2PbhO4/ZyL2AxrWjdPXN5/RAGmxpdceQhJ8K08RfUIM4ud
	 9p8tVIJ2WYKwXWF8Mt3PoK/yZa0zl/BW2OWN/hZGKPZ8ZJzhLJGaJQ4x2m/orCzOhcZmi
	 fGQl8Zcosif4qW2aB5R/AAEa8uzEwdKl+exZePX8Bp/bRwjrh+JMBDYg/2YI++axwvgyD
	 MRPEexyBzFsQfDElSuzqAkS3lyTBQ/+K5qe7i1aYNRTuBQ4rmtdJOxzAZoiZxd3o5Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=NmWVr9U7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D35606A321;
	Fri, 27 Nov 2026 04:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24D35606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=NmWVr9U7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HVhye+rjgDmsCjpX2SwqjFpF4uhxTqFX9Wg2OTfFpuA=; 
	b=NmWVr9U7Gr3gNZ4/ksBJgj83dIvNF4V+Pu1NHI/9SPwucWZblQwVUwJxbeQ9Hp2KCvDxkb3ZSkT
	2QESNFteS3kwKZ34CHxQ1tuDKFOO/+L0DAnmuKgpoWXQlF+4IYVM5eFTxFx1L1EnlzuT5daKgd1Db
	T6+EPJLJZnzCvHfhmXgvu3Mg0nuwyb2YiacDVgtWEcZEy5NZKYKS0zD16k54P3DThmafxjSPl2stB
	lPa5HNKhstRiWjy4YlUgBnlzqOnSqRb/ErXLwlWvw0iuNc+q1KV9Oq9kJD/WasV+Up5bCYD3bzCMB
	RCE2fcdERnH/WojTd6LzDvqzZIVWc0QTQYPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWnao-00000002V1X-2RzR;
	Fri, 27 Nov 2026 12:29:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 12:29:50 +0800
Date: Fri, 27 Nov 2026 12:29:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: aousherovitch@rambus.com
Cc: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	Thi Nguyen <thin@rambus.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v9 4/5] crypto: cmh - add AES skcipher/aead/cmac
Message-ID: <awkHPjWDibjxrb7F@gondor.apana.org.au>
References: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
 <20261118-cmh-b4-a-v9-v9-4-70385613fd50@rambus.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-cmh-b4-a-v9-v9-4-70385613fd50@rambus.com>

On Wed, Nov 18, 2026 at 09:51:48AM -0800, Alex Ousherovitch via B4 Relay wrote:
>
> +/*
> + * Incremental operations and request-state export/import forward to the
> + * keyed generic cmac(aes) fallback allocated in cmh_aes_cmac_init_tfm().
> + * The AES core cannot save/restore intermediate CMAC state, so the
> + * fallback holds the request state; it is synchronous, was
> + * keyed by cmh_aes_cmac_setkey(), and handles both scatterlist and
> + * virtual (CRYPTO_AHASH_REQ_VIRT) input.
> + */
> +static int cmh_aes_cmac_init(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct cmh_aes_cmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
> +	struct cmh_aes_cmac_reqctx *rctx = ahash_request_ctx(req);
> +	struct ahash_request *fb_req = cmh_aes_cmac_fb_req(rctx);
> +
> +	ahash_request_set_tfm(fb_req, tctx->fb);
> +	ahash_request_set_callback(fb_req, 0, NULL, NULL);
> +	return crypto_ahash_init(fb_req);

Please don't use embedded fallback requests.  Put them on the stack
instead with HASH_FBREQ_ON_STACK.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
