Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4D3331A61;
	Fri, 17 Jul 2026 08:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276337; cv=none; b=OfZajQSpqX9+k3VsT7UTqf9eGFhDn8ok4j1cV7Dph9THWjjg6x8OXR4GdfGsrw0AYRwfzBwximCCe4pW+w9/wfKr9zb3JcrhGnohpbNcMEG9vkSoImQojLPGuP8UvWBnW7hcPjoY56WKVLCDEfLecEMBlrn02t54v8jyIS7JFwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276337; c=relaxed/simple;
	bh=4eqwJocznfk1qCzm9smfcedRYjWTocSlvUWgRMrq5qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vux16oijjX4IjIzs7OaMR9n5VEw8Ap9ZJlOzcBH178o1GRw6UnO43XkC0C1W1iIHQGAfau+9JmA/JJLn7OEmwroJdPWNyGgfLLqJrtMqGAV0D4TTv8SRxSlNfcsi22+UXE4rTAxhz3cf+0GhFM1DtYTyyFSFihevt5T/BodGXg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SO/3J9kD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SO/3J9kD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=whazl9Cr8OKKBhetdb/FWk7It0nd2O2kqxLKYX3c2r0=; 
	b=SO/3J9kDH+hjq3iBt+U9mdvrIt1Ybr6OhKzw8fbW696C+HienV51YxDb3eNb6747fjkil0mdH0v
	Y5nV0tX5uTJIKtskWr9yYI4uWEWAJFDBxgK6MDTZjw8QEcMN6rPkC42aYkudUnsXsla3YIc2XG33j
	R9p11yCKnEDWoNq/8rmkRrwKP+NczTA18olJyheVKN5axCF0tQsu90YfgiBjUkC7AUWpp5VQ3Tz2Q
	qlDoNq9nNzS4OB9MPARrLglP/NGDgvdLgGZ6B43E0PSmGTrHCZDoQvpIDs1IV1OwOL3hfzEjkM+Lj
	A9l0SOwDTq/gxLkyfdbmJkZh1c51scCwnKfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdmS-0000000EODf-3tXq;
	Fri, 17 Jul 2026 16:18:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:18:48 +1000
Date: Fri, 17 Jul 2026 18:18:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: demiobenour@gmail.com
Cc: Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <alnlaCXmoLRAlr96@gondor.apana.org.au>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>

On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
> From: Demi Marie Obenour <demiobenour@gmail.com>
> 
> This driver is harmful:
> 
> - It is much slower than the CPU [1] [2].
> - It Has a history of bugs [2] [3].
> - It does not have exclusive access to the hardware [4], causing races
>   with the secure world.
> - It register its implementations with too low a cra_priority for them
>   to be actually used [5].
> 
> Therefore, disable it to ensure that nobody builds it into kernels they
> intend to ship.
> 
> In the future, the driver will be used for processing restricted media
> content.  However, the kernel does not currently support this.  Since
> the driver will have future uses, allow building it if COMPILE_TEST is
> enabled.
> 
> [1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
> [2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
> [3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com/
> [4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com/
> [5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/
> 
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
> ---
> Changes in v2:
> - Add Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> - Add Cc: stable@vger.kernel.org
> - Link to v1: https://lore.kernel.org/r/20260712-qce-broken-v1-1-85e2bff17871@gmail.com
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 -
>  arch/arm64/configs/defconfig        | 1 -
>  drivers/crypto/Kconfig              | 6 +++++-
>  3 files changed, 5 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
