Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630253;
	b=PWyDCFa3qqN2o8UFdmtbZStFrnBonho5YHtn71vGX81WJa+HwVEuwVIPlPJzOXHwHrb5
	 /YUm6wCSLLZwg4BLL1SCboDaa1LQrySgOa/oGcP8LJEbhvXGX+cbspcD5B0+lBZl30Q5j
	 qom7MFfojil5S8gpeNZNC6LKm0rKAyL0u4fb5ES9ofj3D9+Jtd2PwMlsuyERxO44PnvJy
	 s2PtVSoBJhNEmIDr69HM7ZrDxBI+WRLOTk5wZY+1isdWW9aWdzy038H42+4Wya/SdQ77N
	 XcZxCZ+ABrPMt4QKwq9NrDuahtX/2/fhwacF2stm59ZfsAf0ejtFNi8sh3/ozj4fyWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630253;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=p1rEPWL3JSpdsqU+4IRSLrFr7K0QkDaS4V/jg716gpg=;
	b=QL6Pfr+bF+jRYm8zSVuNShDejFvFCvHFtdRvlaInh/vyl8b665S1NMGFDG7UETQKnZMF
	 gXw0r4lpp7PaXg/gLL0l3zAtDzh3JZmd4kRa13m2RXM+GPikKgXFBuCgA+SSiScNP2ZmS
	 mV0Pf6UvuZ95HEjB1JtlhYFuSOk23ExeJ2bbBIBeKyk0ilW3u5tXoi8m/x1I9rFKUN9UV
	 0TUmXH0xMo6Qt/kPHxVlEXRjVgNypz5UW3/FIkjeSWDfxvryRbDO9+hZdD3uiIaBQam4X
	 VneEcLSswq3rTjja0caGBms+LEODP7ZaOPkWjzL8bHYZyXRrJ7DZeQmrAQm5CbYvbOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZ7A2rAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5AA606A329
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZ7A2rAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D13B1F000C4;
	Sat, 14 Nov 2026 04:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630252;
	bh=p1rEPWL3JSpdsqU+4IRSLrFr7K0QkDaS4V/jg716gpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IZ7A2rAdpPB2KpKQWKVXBjOcZB0kcdubWDkRgBeTy0tOYWuQaUTUoGMeMvvHdps2b
	 XMjcqoZ4C7SCQxE1vJYeEWANYruc1Ubb7PNTI2phiSzaIZwcNRFTu1SDkPddQdktx6
	 YB+mOrNJx0SeMwTaXCg35S7F739SkVLMH2FJgc/wnZND26xQUWNpqTLShpmxLOJiDQ
	 P6l/LnxKrhL7VPo9rPvGPKK3ddXF6gH9xCm2d6qRlfmY75sOk5MpsuA1xaIFLK9AU3
	 OEZrjjHvN8l9aqn24g/BJyq2G5TAwC79E+Sp1RumbVRh8I08LBJ66Fcn0rSH47xBqP
	 hcmakRar5kQeg==
Date: Fri, 13 Nov 2026 20:24:11 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: x86/poly1305: Drop redundant checks for AVX
 and AVX2
Message-ID: <20261114042411.GC2025@sol>
References: <20261111201525.40031-1-ebiggers@kernel.org>
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
In-Reply-To: <20261111201525.40031-1-ebiggers@kernel.org>

On Wed, Nov 11, 2026 at 12:15:25PM -0800, Eric Biggers wrote:
> Reorganize the code in poly1305_mod_init_arch() to use nesting.  This
> eliminates redundant boot_cpu_has() calls.  It also makes the code
> structure more closely match poly1305_blocks(), which has an early
> return if poly1305_use_avx isn't set.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/poly1305.h | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
