Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B771DDC02
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733164028; cv=none; b=hcHq4ZhD/3Fm5HzZKrFiFV7eHLNCHPWtjAqLgKFnMk+QDx+I4kt5Z5KI0r2nGNpSX1pDqUOZzUk5YYQ+U7NTXuuZGr2m2Ybczc4st4RYt1sF80ZBmVna9CE3fufF+GDW/K7nMefoV1uZ+iWH6yYZyQA01Aa7X31j+w3txUA5m34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733164028; c=relaxed/simple;
	bh=wdKK+PkyJH3h5ZrI5lebesLfAgsK4mHhtintSvua9v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asYjVuntPkqQE2IcYqWatctxOvebRx53AMRevNDSMKjE+UviPf+mLebhxLCdMlKUeKGHlfR52Os14aT2pMwMMr1MXigEGYPL+MrzjNkeX7tkF1kRzQ71HM001EOIYWw2v0L70lCgJkBSkH6i/ed6AtBZS/TqDw3v6XMDAKBo4BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQm+DOhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQm+DOhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F5BC4CED1;
	Mon,  2 Dec 2024 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733164027;
	bh=wdKK+PkyJH3h5ZrI5lebesLfAgsK4mHhtintSvua9v8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQm+DOhDwjUknLItBzTtpBjXsSgVwGpaTijCxo/G8ymdaXOZalcv3FSOeVI+R4nCT
	 IHWLnwz6Y37a4Iq2KcVEhxaFTc95iMzMwjFw4Sk/w6MKk1JGyswpuTl2zC7we4A5p/
	 QVAZGjQ41J8ydnfg0BX3ZCVlzml17b/CFwGDzLGPZ7bQUksO27zdAcCBlCoRo/EQH+
	 ZYufhbpVihvSQddYETfHptLYm4TMvP5esjLC/kkQSBdd7c0Pz122uU4R9qlL63QFpX
	 MWfrg1m99qVDFTZSJ4gZ9q4RTc0DH8++Mlp4Mdr35O1EBnf+7Jg/Worzzc98EZQAXp
	 yAdDgGQBhl3FQ==
Date: Mon, 2 Dec 2024 10:27:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 01/10] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20241202182705.GA2037@sol.localdomain>
References: <20241202142959.81321-1-hare@kernel.org>
 <20241202142959.81321-2-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202142959.81321-2-hare@kernel.org>

On Mon, Dec 02, 2024 at 03:29:50PM +0100, Hannes Reinecke wrote:
> Separate out the HKDF functions into a separate module to
> to make them available to other callers.
> And add a testsuite to the module with test vectors
> from RFC 5869 (and additional vectors for SHA384 and SHA512)
> to ensure the integrity of the algorithm.
> 
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: linux-crypto@vger.kernel.org

Acked-by: Eric Biggers <ebiggers@kernel.org>

> +int hkdf_expand(struct crypto_shash *hmac_tfm,
> +		const u8 *info, unsigned int infolen,
> +		u8 *okm, unsigned int okmlen)
> +{
> +	SHASH_DESC_ON_STACK(desc, hmac_tfm);
> +	unsigned int i, hashlen = crypto_shash_digestsize(hmac_tfm);
> +	int err;
> +	const u8 *prev = NULL;
> +	u8 counter = 1;
> +	u8 tmp[HASH_MAX_DIGESTSIZE] = {};

Zero-initializing tmp is not necessary.

- Eric
