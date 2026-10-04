Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2607047C0F7;
	Sun,  4 Oct 2026 18:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791136945; cv=none; b=uL/1eI1CC0mH4QOBGet1emhrxmxTk7d4tbrdE9Bj7r/pu3uB0NKN0pr3yoLTBpAmrNg9+TPU9b9VME4CiEZnYHzOavsIUCTRGPc8St9/efj3nuIBJsx9AoNBWrQtSgep2f5gE5t//HiozgKN4U/nZ7z3u1+VOholEk7wO40VpUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791136945; c=relaxed/simple;
	bh=yRs6iOyIksXzAXZLCm/L98/ZXr20yi5TUXOnv8IIzHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIruS799dgFqHA0R5dFuO/Sg1G+MrEATX/Ds7NYsA3mzktxpyrMCmTVDMJrZ3gLu7GJOFX5qsY0ZMsJUKtdrgzDtLL1KhX3AiIbmCDBdBXhkMK5tEnoR6YpHmAtHNbEEaRj2z/1GOeD0FdWFQXB09yuj+2b1n036z2PUDWsBcFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0l7RULS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0l7RULS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD05C1F000FF;
	Sun,  4 Oct 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791136934;
	bh=3NrjrMQG6PRCSAYGrvIhG5WZILo0AC3+blI+7TQNQrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H0l7RULS+6689LmK4W/cZCuj7+DOqNc/kV+zxBRy6jy+8yZVmqbBJahdHbF4XN61v
	 UWxc3oGHOBV3H78WNK/GFjLrrraXqT1Q6Z0nvF8zLWh7Y5mYXbnZCHfpkif/alVCly
	 ZcfF4O5mshEnxBInyjzfuQQHg0VbnMNyrg9Rpn+pJeuNTIHllmWd21rRZrhexlFoVl
	 quzTMz2QJkY3vaBaUeFFhxS/7of5NBzSW6pADACeyMBd7x/HioBhZK5EHXroUVqmEN
	 Ux4UqDIB/c5c8yhBQeaGNhSoWTht7UFonVKpQ3J1+dI0/26yOVAm4OzD/hY/fkKDsZ
	 8U8NPPwavWWyA==
Date: Sun, 4 Oct 2026 20:02:08 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: sparc/aes-xts: Add optimization using the
 AES opcodes
Message-ID: <20261004180208.GD1906@quark>
References: <20261002072110.1221579-1-stian@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002072110.1221579-1-stian@itx.no>

On Fri, Oct 02, 2026 at 09:21:10AM +0200, Stian Halseth wrote:
> +#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
> +ENTRY(aes_sparc64_xts_encrypt_128)
[...]
> +ENTRY(aes_sparc64_xts_encrypt_256)
[...]
> +ENTRY(aes_sparc64_xts_decrypt_128)
[...]
> +ENTRY(aes_sparc64_xts_decrypt_256)

These four functions are almost identical.  They should each just invoke
a macro that expands to different code only in the parts that are
actually different, like what the __aes_xts_crypt macro in
lib/crypto/riscv/aes-riscv64-zvkned-zvbb-zvkg.S or the _aes_xts_crypt
macro in lib/crypto/x86/aes-aesni.S do.

This will generate the same object file with way fewer lines of source.

- Eric
