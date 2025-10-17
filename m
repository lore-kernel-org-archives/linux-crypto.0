Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064A4334686;
	Fri, 17 Oct 2025 05:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760679693; cv=none; b=aTzReagqkwtqNg8EZGwvromskFH+4bipHtVe7LQozBrdgyRvfrzw85STTk+TXvWJmEkQ1diuDDmJRx4Wy3n2btH+JNKZEhzfFSu4r/JRi2im54UFMWban2ZE/KHvyc7WdsjpjAaDoDweZG6l0OMifoTuAkrjhNTUEfhTxP/+9CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760679693; c=relaxed/simple;
	bh=K6TvAM+nJKwPC0wU+6UlduZNEOmfeDCgZeysu2km0cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdFekmtHYAYRiD1ZZj0/PUNpLp+QyFAUNEdZjsK6MArZfM1QD3Y84xBYo9P5o8cuciM4DPtlaY3xe40UeQnBso1k6GMGvAoeKdCt7MFpX844ChKA9obpvbbuDBSzUa2JhzDjXT9UT0wDsV/UkwuPcc4pii2anRvAtkYIFJMtslU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ORY0w2BI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ORY0w2BI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8yw0M0VnK4HX+aAzMi+L4/qHOL+9gcWX9ypFnvc4gPo=; 
	b=ORY0w2BIJ52gWpfOiTUhxkU7Rxrk5QuZIpHsH/qKhV2KYUI+VptMu9pQLOJelwQHE0IUBZm2ixp
	Z5TfkRdtFn5Uv0uL5WNkmL+6rgnK0bXZCLmV7/881kxvfGlAsKKiSBE0O4P1kNrTi/D646ePVyx8I
	nUjoWXGsjKKL91I1ywc06LJ8RtMbEX+ersUklUr6IA5liDSekoOBTct3dvZ2X9H1LABPoxw/IkEti
	PO8Ah4xNouZkUIX43bomY2rF6K101nXnl79R/h24bVm2NTKIsQo2nReZNayG6/8IUOjlxwxnTzLA1
	vvc375n9bm8t9bzSxoXos5OHRwdPRy1iqjQg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9dDL-00DL2K-1L;
	Fri, 17 Oct 2025 13:41:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 13:41:19 +0800
Date: Fri, 17 Oct 2025 13:41:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] crypto: ti - Add support for AES-XTS in DTHEv2
 driver
Message-ID: <aPHW_zyWwA36Usy1@gondor.apana.org.au>
References: <20251009111727.911738-1-t-pratham@ti.com>
 <20251009111727.911738-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009111727.911738-2-t-pratham@ti.com>

On Thu, Oct 09, 2025 at 04:11:31PM +0530, T Pratham wrote:
>
> +static int dthe_cipher_xts_init_tfm(struct crypto_skcipher *tfm)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
> +
> +	ctx->dev_data = dev_data;
> +	ctx->keylen = 0;
> +
> +	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));

Just use the name "xts(aes)" directly.

> +	ctx->skcipher_fb = crypto_alloc_skcipher(alg_name, 0,
> +						 CRYPTO_ALG_NEED_FALLBACK);

You should allocate a fallback that is synchronous only.  Then you
can store the sub-request on the stack with SYNC_SKCIPHER_REQUEST_ON_STACK.
Otherwise the sub-request reqsize may overflow your request object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
