Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C831411DE;
	Wed, 30 Apr 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746026462; cv=none; b=rZOs4Ng5Z0B9P2quMdWnQnQmJdMmzyLzrphpNmkZws8UecyNjTNr8eo2i+UeFlGNOCQYtuF1xMoKq/wsp3D3CIsDvtzHtkA3lcIrtGUmGBIGsnRBuSrKUkzVDVnC5Jd82iwM7Whdx0qi6dcHfNXzr/jS528CAUPfmavzAD03BzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746026462; c=relaxed/simple;
	bh=uhFxYPnXiTUoSpJeM3bSvzBlKPYFN1uP7NgCPaX74Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJ2eMqaljt4EAMOKgMPF9Yrb2BP8vBwx7mmjNV1lyWXlhptQMrxYD4KDb5sgA3nRdkRgfcW3TxRLQu0NXM1JDQsCvDX4Q6M4qnfejA1B9OESmrvnQdxJkxPD9oUyiLOd9/Je7v+UUHmUKOQk0yubBnukIpcHXPbPypd8oeD7ylA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqetwA91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqetwA91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170E9C4CEE7;
	Wed, 30 Apr 2025 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746026461;
	bh=uhFxYPnXiTUoSpJeM3bSvzBlKPYFN1uP7NgCPaX74Ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dqetwA91TNfX2vPVxtEzl224LWpSUdN5YGmo45+YXp5+ahlF6ma9NDKN4M2JwI1ep
	 +WtGN8SFYtZkaU/HcyTeL5OxjvKD7Dq0CMAoH/SQJ5ORawpeI6728Vrq3y44zYvNmK
	 64MmMGTtIVvn1EF7JCzRi9syZ2E3l+jLSyt9fKmpuY+PLKfWPD8cqGPr2VYak2R6cz
	 WufeyYihKwOXIUOf9ZN7388uK2bnPnnrwQSUfXzTRZ5V8V1FDVWCyNrCD6DWUMExYz
	 fo3P1UhSMJfblEtVAqncaIWRfr+MxJuLvAPD92yKaBf7LqXcsuUdQTuXdowmpP7WNz
	 c8US+IIEOITog==
Date: Wed, 30 Apr 2025 18:20:56 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use SHA-256 library API instead of crypto_shash
 API
Message-ID: <aBI_2NJHRk61n9TY@kernel.org>
References: <20250428183838.799333-1-ebiggers@kernel.org>
 <ae48d190-03fd-4f4d-ab6f-969301e8b96e@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae48d190-03fd-4f4d-ab6f-969301e8b96e@intel.com>

On Mon, Apr 28, 2025 at 12:19:50PM -0700, Dave Hansen wrote:
> On 4/28/25 11:38, Eric Biggers wrote:
> > -static int sgx_get_key_hash(const void *modulus, void *hash)
> > -{
> > -	struct crypto_shash *tfm;
> > -	int ret;
> > -
> > -	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
> > -	if (IS_ERR(tfm))
> > -		return PTR_ERR(tfm);
> > -
> > -	ret = __sgx_get_key_hash(tfm, modulus, hash);
> > -
> > -	crypto_free_shash(tfm);
> > -	return ret;
> > -}
> 
> Let's just say, theoretically, that there was some future hardware that
> also supported SHA384.  There doesn't seem to be a SHA-384 library API.
> 
> Would you leave the crypto_shash() in place if that were to be
> happening? Theoretically of course.

I don't see any reason why SHA-384 could not be added in order to
support a CPU feature.

BR, Jarkko
