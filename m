Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BAD3009E2;
	Wed, 23 Sep 2026 05:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140582; cv=none; b=oIZjmbFQdtcn8QeXxS5Qxt/qM3azn4iL23J5+Xif1R++LZh9sU3rswpQhkn0YURAVdVOoZkGmbz0opRY131DObTGmfodMIxU6sQoXRKhM+fvuX1LhDMyLc58R9IVC9QwgnQ+jmMPryyNXi8yNMUXvt5KSJ5/JAnvEpAcXtUV3Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140582; c=relaxed/simple;
	bh=0KvqwC1jc86Be5G6tZb35nf2qhRhFkUlNG0GsPTsodE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzyz2BH43lQHbH4NGit7B4CF2mXrXpUk4CtMlwmtXtFMjbTO6VhfFscSyetEJyTRYNRdVdsCjCOJP3rUiJTE0d45JRGp1kJl/IHC7OG5qveUr5IXV5ByZzhKnf/RH4Gc6j/JleDadY0Gfhj8rjQS3sAl6dDJpjh6OH9xqXiKK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=auVFEa+X; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="auVFEa+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=I8wM69X4C1XQHXTDA8OR1705KlhzUyG0Av3NZvqVb1o=; 
	b=auVFEa+XuszRvwtUPVuLUiCTEODi04DFK2DFi5RBVkLLfRJvcF6Gl868/uhLNUpOjKCHFVX1g0P
	C8l253hAU7YlQK7nroTlNTa6CiE5U0vAR/P6P8E+Xue8WJzzM+DNfu/fPQm857VaoZSSwX5DrLIPn
	EFueVzcfPAjKe/9hmIHPUBif/6hhyzmKG9kaKP93vJPqlZD+VGdgQQXW8PU91CZxO7y7sZrp/cQlZ
	T4CPhDyl2EfP/5hAQoysGy7ubvablT6mrXHshbHY7SvwH/tubKUc+wiTzGzcuo7Y51rj8kKW8q4+I
	OfmqlF1Qd7kENroOduz1BpnAQ14ujm7Drh4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FL2-0000000GuPz-17Gl;
	Wed, 23 Sep 2026 13:16:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:16:12 +1000
Date: Wed, 23 Sep 2026 15:16:12 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
	Colin Ian King <colin.i.king@gmail.com>, Andrew Davis <afd@ti.com>,
	Pratham T <t-pratham@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Udit Kumar <u-kumar1@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] Clean and improve SA2UL driver
Message-ID: <arNgnMuKPAHYxP4Y@gondor.apana.org.au>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>

On Tue, Sep 15, 2026 at 03:25:06PM +0530, Manorit Chawdhry wrote:
> The following series focuses on some cleanups to the sa2ul driver, it
> starts with very trivial cleanups then goes to fix some bigger cleanups
> and migration to crypto_engine which help fix the broader race condition
> problems with the driver, thereafter it adds the support for AES CM as
> per SAxUL 3.1 IP. KASAN is also run alongside to fix the issues caught
> by them.
> 
> Self test results across K3 family: 
> https://gist.github.com/manorit2001/544587ec3535125663e3ca9dbc186e96
> 
> Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
> ---
> Manorit Chawdhry (30):
>       crypto: sa2ul - remove dead code
>       crypto: sa2ul - remove totally unused structure fields
>       crypto: sa2ul - remove unused algorithm ID fields
>       crypto: sa2ul - remove unused fields from sa_cmdl_cfg
>       crypto: sa2ul - remove unused fields from sa_tfm_ctx
>       crypto: sa2ul - remove unused macro definitions
>       crypto: sa2ul - consolidate encryption offset definitions
>       crypto: sa2ul - remove unused SC ID range tracking
>       crypto: sa2ul - remove unused base register pointer
>       crypto: sa2ul - remove unused includes and defines
>       crypto: sa2ul - remove unused line
>       crypto: sa2ul - remove redundant sa_sha_digest() wrapper
>       crypto: sa2ul - fix struct documentation for match_data
>       crypto: sa2ul - zero out security context on free
>       crypto: sa2ul - fix context release on errors
>       crypto: sa2ul - fix resource leak of sha in init_alg() error path
>       crypto: sa2ul - fix resource leak of AEAD in init_alg() error path
>       crypto: sa2ul - fix DMA mapping leak in sa_run() error paths
>       crypto: sa2ul - generate dynamic metadata length
>       crypto: sa2ul - fix command label stack corruption
>       crypto: sa2ul - fix error handling in sa_prepare_iopad
>       crypto: sa2ul - move export to appropriate location.
>       crypto: sa2ul - fix stack overflow in sa_prepare_iopads
>       crypto: sa2ul - add more checks before processing ipad/opad
>       crypto: sa2ul - fix data corruption by skipping device sync on unmap
>       crypto: sa2ul - use correct DMA direction in sa_sync_from_device
>       crypto: sa2ul - change dma_alloc_pool to mempool
>       crypto: sa2ul - route requests through crypto_engine
>       crypto: sa2ul - report SA engine hardware revision
>       crypto: sa2ul - add AES-CM (SA3UL_CM) TRNG priming support
> 
>  drivers/crypto/Kconfig |    1 +
>  drivers/crypto/sa2ul.c | 1042 +++++++++++++++++++++++++++++-------------------
>  drivers/crypto/sa2ul.h |  162 ++------
>  3 files changed, 661 insertions(+), 544 deletions(-)
> ---
> base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
> change-id: 20251106-b4-upstream-sa2ul-cleanup-ce85d40c7eb8
> 
> Best regards,
> --  
> Manorit Chawdhry <m-chawdhry@ti.com>

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162%40ti.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
