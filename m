Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597688;
	b=b1vxa8r0YFZX03qOEpLmbeyFbm8rluyE4kixoJg/umTrhntdwaTN9WM/fPZstlVyCy7G
	 WTQjVbwxNKGCRZp9EmOVYYmqKmzy3ojrHDGpC4xeyZWzTwHKsFBJ9uzallQ40YtJdU9K7
	 nksZ5Kc5+R8WeGAvAngq2MYZMMyzI03IlpIxFHwnx26RS/wCvOm2IOs60bfdlmK2U/Euo
	 a39OEWtrsqvsZKiZzKL3k9t1XAHotaOuv/DCLbZ/r+Ebciwexa/y2a3Gdd1YP3a6tDcZI
	 IZvrFOslVnAGVy1PqL+ix0Iak4G7xpGA9HWhtqd/eQmjI3rEsP5InhtHHNbWp0CHxkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597688;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9nmjMDlXaUZxxOERznasrTQeCkH4R7bd8Ev17LoaJKE=;
	b=2Fx2P/PTUUEO8vWS7c3C9cGmY5dNbpIezfvTmOMjgUauObOsreU9oD47TThUL8DJw2Wp
	 vXwoC40pqAGhoUC2t+oghEUKCUVpedLysPA1CZn7553uyg+iGysvfruY7152r8ocSARDF
	 fSKAvcNkdhxDPIWWGDONAY4zeCtHWSpsEgkptY/Tmc99mBt3YgpwcGCWg9dVuhPh3XSoM
	 PHxRRuYkNc+nYwGWkFVdWjZQEU3oQrNh41Kud80ilOrdkhsv2hSzKozOet4CVcEiOMfZC
	 vh1dO+tW/rZZRCKXWwsqxogVqNBCBgcbujQcVqgEnxguxLiBaUVtT0OTKNqCPwfa+mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFVHL65D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A557606A319;
	Wed, 21 Oct 2026 15:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFVHL65D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECAE1F000C1;
	Wed, 21 Oct 2026 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792597688;
	bh=9nmjMDlXaUZxxOERznasrTQeCkH4R7bd8Ev17LoaJKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aFVHL65DDAHpj+qZTHL5kptPnxAveIgHL3K4bh4ZGsaddG7HcCqQ9qKxOzVb26hSM
	 NH+evLGaJ4CWfGGQ9io+AKAKmxL4TpuJkTbq/LupAqpAFvIcjfUbm8CJOLMNkgr+US
	 m8rg/p5nZwFaU+Gs874D1u6ikUjAqPc6xxEeRAjyb3zhLedUrKwt/lZnyAA/ewILdN
	 eMRH/PXsk4FvfmSFWcxOQLrLVU0Tst/WAjrqJaTqyZkQ66pueu/EO2+mgx3cA75RI5
	 g7hAL8Myxx9FVFsQHO6DngyuRDkWAD1UvLbJn1iTDL0EsknPzCoYdpFitVZgHHwpaw
	 tPS20iYIVNS9A==
Date: Wed, 21 Oct 2026 08:48:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Jeremy.Jean@oss.cyber.gouv.fr, Jason@zx2c4.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: arm64: Fix lost Poly1305
 carry when resuming NEON" failed to apply to 6.12-stable tree
Message-ID: <20261021154806.GA1879@quark>
References: <2026102137-contently-unshaven-7da4@gregkh>
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
In-Reply-To: <2026102137-contently-unshaven-7da4@gregkh>

[+Cc linux-crypto@vger.kernel.org]

On Wed, Oct 21, 2026 at 04:40:37PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

It's a clean cherry-pick, as git detects the rename of
poly1305-armv8.pl.  So there should be no need to require this to be
resent.  Also, missing Cc to linux-crypto.

Same for 6.12, 6.6, 6.1, 5.15, and 5.10.

- Eric
