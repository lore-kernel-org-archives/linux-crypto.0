Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A1A13B2A9
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 02:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729045310; cv=none; b=dge9nI9fJ/HTxNVvxknH+F1Ym4YCw+l6/KNU9fUVlRisriIEwyGjWkCaiSKDGgV69rk8BdvBSoWjvKOuSbfdroLLbaselye08g37FNISBmoqYlX/Urogy83NRmX8UIM+nNFrqhf5VdsdfyV+blzuiKhDpjpuMqeXCs9fZ+fWVAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729045310; c=relaxed/simple;
	bh=7ir7Hzc+RF4+Nl9GbRJu4/HfxPeRPV03io/CeZ8jtWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3AF3bD1EcuO0i8QlYh/mA8Ux/rkIpOw6r4pGG2zqfbUA7A6zYRePK+bfmuObkZ/TMIF8ZAh+eR2Gm+7fqxdhq+ODL8XtiUW8JoFZf7gJcujqEva0ld0gj93R4GWa2yHMu62i+BCBCeBkgftwTjsoAqr593BhxcELAW+NKWi/rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRAwQd4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRAwQd4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4E6C4CEC6;
	Wed, 16 Oct 2024 02:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729045309;
	bh=7ir7Hzc+RF4+Nl9GbRJu4/HfxPeRPV03io/CeZ8jtWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KRAwQd4OKBP+aqsXec0gvm/L8FmV8fkQTRTX9qA9xgFHZjrjPztz8fEjH9ROSnSAV
	 9YsHDZWu5C8E52iGNHQ4akb2OwFpIWVS8kxD4ZGZhMbEcyomVw79+jQx6N/7GCRHUF
	 eO23F+zmNBKmj95J05FjDexq/xaxqsKmWQKORLgv9EvJDP8YQp7sc57OlBYL5mPIq0
	 +2tTK8t2qQKxUjfG3cVmyMENcNv6daYUiSLRNazMJqhpzMqKO70rdhzf8Ov/aK1CfU
	 ENPWZVIZywTNq53LOHVi/uvYsDl5iZ6CwegqlhJDQsj/iHG3eD6ojBj1KDad3+RVGL
	 oQOAkkI+76NqQ==
Date: Tue, 15 Oct 2024 19:21:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/2] crypto/crc32: Provide crc32-base alias to enable
 fuzz testing
Message-ID: <20241016022148.GB1138@sol.localdomain>
References: <20241015141514.3000757-4-ardb+git@google.com>
 <20241015141514.3000757-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015141514.3000757-5-ardb+git@google.com>

On Tue, Oct 15, 2024 at 04:15:16PM +0200, Ard Biesheuvel wrote:
> +#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> +}, {
> +	.setkey			= crc32_setkey,
> +	.init			= crc32_init,
> +	.update			= crc32_update_base,
> +	.final			= crc32_final,
> +	.digest			= crc32_digest,

crc32_digest() uses the lib implementation.

- Eric
