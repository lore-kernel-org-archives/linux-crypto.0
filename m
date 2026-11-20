Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795205683;
	b=s4NQB/8g8m8hSuItyKSAX4oO2Qu217cqbwio8TCfjsmQqzpMKfdE9OzaCq+5ikdQBv3E
	 D/s0UDOZdr0toQqQGty2OP+8a6AmLuFjiAI/G92xn6OKtNfB4QM8oRpyuKpCpOYr7/1TR
	 JV1bL8m3Vb9Uwco9GR/oipzc+W42wC6VbJ10+HPHjRyx1J/vv5b2WmLMGg6c1nIbTj1Bo
	 MNVi5Y/ip7DxavFQw4vl4PRuwU2HHFW6E9tNsv+te0nAJT+vSpRyYkz9y+Y1LlCuqPBZ0
	 jLSmWNT4cte9LdHLnncGKSBl/wQcnrklgRLKT0eM0Zc7YYtv5df6IRG8UNCf14Hw8Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795205683;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=FFTP1NPza1DvwgzCri+N43IcvcyxR0U6bBZgpwRHscQ=;
	b=GCsHNaBv6pfVHXpRDIweuay7yh9jwlMnUQFR2b/x95LYoSjeYUkcOrrIDa1F1Txy5HXZ
	 E5sY7WAlsdKUsZ8duTa7NVev+gXrWPQcwv8Ifiu91XvhTM9UxrTsSWYM/3jYemYShWdpq
	 dBO3vIv7yQMdf9m/JUogtx8W2VBoMaKlde3RjLRZ7kfZdSx79J2MJPPe8y7vfQNhjoB0B
	 zf1in8d3eUVLeYoPntri77KN5xykEN03sbBypdlRnTEQwv14tAh08vlElrASkAzHc7VYT
	 3uoNBkpRLO2X1SRAKA25C3y8VdGDE1k/NmC9LHFU6c9stp1cXk3mNfqp3t5E8WoLs1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kOcxHrVk;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981CE606A6F1;
	Fri, 20 Nov 2026 20:14:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 981CE606A6F1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kOcxHrVk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FFTP1NPza1DvwgzCri+N43IcvcyxR0U6bBZgpwRHscQ=; b=kOcxHrVkAyIvrsNI5n9oXxz2Cd
	zSYQ4zJyHNy9cHPfsv8prE2GWzy7pHB1MWM7Dj3TWGiCaruL8l65x0Sm5WFdyFaKLGLAITTLlWQ7m
	rxdUlf8+KA1YJewSlLAbJruWpBcyvE7EfLgg2pzT3Km2AW0r8QF+/MRmMD1Ev0CPNzb4q5GJrjYH7
	OgqwmsrEuxm5iLJ8NKVcuWbVYWz6ijqfbX0c9UZWFUaV2Hf0R/k537BzeIuPLyh7CyTM3hfaT1W20
	iNoObdEBvfnwMcdKMCyDI1KV6UKItF9Ibv9+NKRYzMBPN9rZj4nxTp5mbzBxjSTq+2pve3SNhC4Aj
	jjRH1Nww==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xUV0E-0037jW-20;
	Fri, 20 Nov 2026 20:14:34 +0000
Date: Fri, 20 Nov 2026 12:14:29 -0800
From: Breno Leitao <leitao@debian.org>
To: Danny Tsen <dtsen@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
	herbert@gondor.apana.org.au, nayna@linux.ibm.com, appro@cryptogams.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au, 
	ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH v2] crypto: powerpc/p10-aes-gcm - Fix IPsec stall on bond
 failover
Message-ID: <awCpkj5wsxEPt-Vd@gmail.com>
References: <20261120181657.6396-1-dtsen@linux.ibm.com>
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
In-Reply-To: <20261120181657.6396-1-dtsen@linux.ibm.com>
X-Debian-User: leitao

On Fri, Nov 20, 2026 at 01:16:57PM -0500, Danny Tsen wrote:
> The Power10 AES-GCM driver registers its gcm(aes) and
> rfc4106(gcm(aes)) algorithms through the crypto SIMD helper. When
> crypto_simd_usable() is false, for example in softirq context, the
> helper defers requests to cryptd and completes them asynchronously
> with -EINPROGRESS.
> 
> This breaks IPsec traffic during a bond failover. With the crypto
> offload device active, traffic is switched to a passive device that
> has only software encryption, and the ESP requests then go through
> aes_gcm_p10_crypto. Under heavy load, some or all of the TCP streams
> drop to zero throughput and do not recover. The stack is seen to drop
> the ACKs as invalid, which points to the cryptd queueing delaying or
> reordering the packets.
> 
> Fix this by registering the algorithms directly as aead_alg with
> CRYPTO_ALG_NEED_FALLBACK, and allocating a "gcm(aes)" or
> "rfc4106(gcm(aes))" fallback tfm in ->init(). When VSX cannot be used
> (!crypto_simd_usable()), the key was not set up for SIMD, or
> cryptlen < 64, the request is handed to the fallback and completed
> synchronously in the caller's context. The driver no longer defers
> work to cryptd.
> 
> Remove Kconfig option CRYPTO_SIMD and add CRYPTO_AES and CRYPTO_GCM.
> 
> Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>

Reviewed-by: Breno Leitao <leitao@debian.org>

> - * Copyright 2022- IBM Inc. All rights reserved
> + * Copyright IBM Corp. 2022, 2023, 2024, 2025, 2026

Do we really want to change this in this "fix" commit?
