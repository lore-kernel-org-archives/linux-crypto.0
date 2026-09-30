Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AB55172EB;
	Wed, 30 Sep 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787384; cv=none; b=i4dL0yRpv8KO9bQr/BQO2CpOn4TWpmOPhM1TFjmu54CW4KKBXVSaW1kuAOnODZWYNuHbhGhT4UsD9ucONgi4JmCfCEhKGAVV1LOOwPIJO4PBWXenA4Da7W8D6+/T6tdrNxTVfht7dgqFBB42npt0TBtbTvT58r9m0ncQ0TTS5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787384; c=relaxed/simple;
	bh=eAJWhgPEBUmIfICJ2OMf/y08joH9wLceKD7r07HIOgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4Q36iAGCIveKXgLur6UgtDFL9m4xDDHP6UaesfupNpP/Aakt8lFzc5Fq2HInHllylidp9uXS63rE1TVUptyY0VZYyhyVFgp6sktNIJ2S+K94MiuwlN2UywogPS3StsSM3x8o9f0iI0jPFghVAnrwSbNMofQMaheC2xAsGjdwTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OiOhok8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OiOhok8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9F01F0089B;
	Wed, 30 Sep 2026 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790787383;
	bh=MEt9F7bDmFpXzE8U3rYbOUl8S1E1YNzfSq4bi3U+m2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OiOhok8J4oOfwL2I0IK8JGcUqZT7PsmqQQudooDFm3wIPbZpTnqBZ2/wyH/cPCn+6
	 GSRa2o5JVLy5gxNJxy+rZKNMGYdYYsSLC3u1GbaOfcoefML7O546kycOhol/j7KGx/
	 maXCxYxaDs+ptjqCpqp2lS9FQVBaefVgHq6PUrFgkHM855P5bHtj1qOJUnORTV0rww
	 eCAzL5cgJEcDEQGW5QEpRHU0COps1i2YXUvuxt0urTVsdRR8o74rv97zcKDyioaP36
	 o0RgPA8rtMgiZwIHEZ995GOX/sUcDKiHRmWrxYmL6hVQwjpch7FbqDz0iKthyKWg0I
	 EJlCqgAkKLdiQ==
Date: Wed, 30 Sep 2026 09:56:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 00/20] Migrate x86 and RISC-V accelerated AES modes
 into library
Message-ID: <20260930165621.GC1904@sol>
References: <20260927224418.109759-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>

On Sun, Sep 27, 2026 at 03:42:51PM -0700, Eric Biggers wrote:
> This series applies to v7.3-rc4.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-lib-x86-riscv-v2
> 
> Patch 1 was already applied to libcrypto-fixes, but is resent to make
> this series applicable directly to v7.3-rc4 (ensuring that the Sashiko
> review runs).  Patches 2-20 are targeting libcrypto-next for 7.4.
> 
> This series migrates the x86 and RISC-V accelerated implementations of
> the AES modes ECB, CBC, CBC-CTS, CTR, XCTR, and XTS into lib/crypto/.
> 
> This makes the corresponding library APIs be properly accelerated on
> these architectures, while still accelerating crypto_skcipher as well
> (via the library-based code in crypto/aes.c).
> 
> It removes a lot of redundant glue code, since crypto API boilerplate no
> longer needs to be duplicated per-architecture.
> 
> Finally, it fixes the longstanding issue where these optimizations were
> disabled by default.
> 
> In the case of RISC-V, this series handles all remaining AES code in
> arch/riscv/crypto/.  In the case of x86, AES-GCM is still left in
> arch/x86/crypto/ for now; it will be handled later.  Other architectures
> will be handled later as well.
> 
> For various reasons, aesni-intel_asm.S (the x86-accelerated ECB, CBC,
> CBC-CTS, CTR, and XTS code that doesn't use AVX or VAES) is replaced
> with new functions written from scratch.  The other assembly functions
> are kept but are modified slightly for integration into the library.
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
