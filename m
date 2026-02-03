Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C493126AB;
	Tue,  3 Feb 2026 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111694; cv=none; b=QguBxtOPTQXpwk8akfM7LWEh8johI/JZTOmWd4+xoC9QN1BzVCS+AstgkIPumaxKSrhDd+7TLKivVMYF9ir6qfZKR+fi7OGuHyTjG9A76gtOKTJ7wclFEW5yG1+XvwxKLCYJsFh5MhhThgjVK/wqY180FRAPzDoc1zpBuZcxibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111694; c=relaxed/simple;
	bh=cS2besYXZerm6cIUN17/3IBsltoe8BKgW5IeAvu6J5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bo7hLVoHuangalDqdWmFg7Nxv7w8ZniBT4OiJhCTrD3QWDyILDng4JA2Qx7J11YsQbXYcsCh5vgkyH06hkTr3vV+wWhTmcgzUCcDFOUnA6VbTRCbyZMs/DRmagv+Q32EF/lHopE6OiFH07kHlWfkx/jV844z2DIt4DInUXGBpsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AF87qq6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AF87qq6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C270AC116D0;
	Tue,  3 Feb 2026 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770111694;
	bh=cS2besYXZerm6cIUN17/3IBsltoe8BKgW5IeAvu6J5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AF87qq6X0jUko0zR1vUZqpmWdB0ieRVBRHSINr8uFQjWsPOQ0yBDtPyPE4vEd12Kv
	 CVqqAnbr2h7qGeHFW1Ox7IHFhoOhARx0rONgayFfWOn3pw9Nu+ON9L9kW3xz8YTaX5
	 eyrfjNNifUk7c3ff++MPQe8YxeoyHatBd1qyYuWmdIBCtbILS2dUAFQbSAxIMFMAG0
	 RXM5XCsM6bDDuMqFWMsv/bOejDx4y2N647KMRw+ZHA75XisUWaDuGdx7jzautbnMe2
	 FlOOu17GjoSamXT4mjJB6CMIpkLEG9d+JbbmCKUeNKijx8Db9bSbPqJES4Krrogt76
	 +FoBhHdgRerFg==
Date: Tue, 3 Feb 2026 10:41:30 +0100
From: Antoine Tenart <atenart@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: safexcel - Add support for
 authenc(hmac(md5),*) suites
Message-ID: <aYHCC-BiBKUXyUbd@kwain>
References: <20260202202203.124015-1-olek2@wp.pl>
 <20260202202203.124015-2-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202202203.124015-2-olek2@wp.pl>

On Mon, Feb 02, 2026 at 09:21:08PM +0100, Aleksander Jan Bajkowski wrote:
> This patch adds support for the following AEAD ciphersuites:
> - authenc(hmac(md5),cbc(aes))
> - authenc(hmac(md5),cbc(des)))
> - authenc(hmac(md5),cbc(des3_ede))
> - authenc(hmac(md5),rfc3686(ctr(aes)))
> 
> This is enhanced version of the patch found in the mtk-openwrt-feeds repo.

Can you say how it was tested in the commit message?

> +static int safexcel_aead_md5_ctr_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	safexcel_aead_md5_cra_init(tfm);
> +	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
> +	return 0;
> +}
> +
> +struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_ctr_aes = {
> +	.type = SAFEXCEL_ALG_TYPE_AEAD,
> +	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_MD5,
> +	.alg.aead = {
> +		.setkey = safexcel_aead_setkey,
> +		.encrypt = safexcel_aead_encrypt,
> +		.decrypt = safexcel_aead_decrypt,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
> +		.maxauthsize = SHA1_DIGEST_SIZE,

MD5_DIGEST_SIZE?

> +		.base = {
> +			.cra_name = "authenc(hmac(md5),rfc3686(ctr(aes)))",
> +			.cra_driver_name = "safexcel-authenc-hmac-md5-ctr-aes",
> +			.cra_priority = SAFEXCEL_CRA_PRIORITY,
> +			.cra_flags = CRYPTO_ALG_ASYNC |
> +				     CRYPTO_ALG_ALLOCATES_MEMORY |
> +				     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.cra_blocksize = 1,
> +			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
> +			.cra_alignmask = 0,
> +			.cra_init = safexcel_aead_md5_ctr_cra_init,
> +			.cra_exit = safexcel_aead_cra_exit,
> +			.cra_module = THIS_MODULE,
> +		},
> +	},
> +};
> +
>  static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
>  {
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);

Thanks!
Antoine
