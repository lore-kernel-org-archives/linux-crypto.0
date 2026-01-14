Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9E526CE3B;
	Wed, 14 Jan 2026 22:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768429959; cv=none; b=NhsNTMq/TkCbp+OsDI5zkcNUmC/fVLlNQT3UmAUo66aqKmkLE6/NKUaNXgbOHlFFqtHHCRsVefzvodu3LRzS/wI4ffOvcbIeub0hrdlFKdBFmb+k39delaICfjyp4KYQM94pvIuaKKHZZOt6VMbydCT4+qRIqzLw1HQIZcPL/uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768429959; c=relaxed/simple;
	bh=4oikowT4rCGYSBAs/PctCCk+m8y0Lr0Dfu3VAL0C3tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WV96XhLeJPrZcUSfeJ8043caDmJbayaCll4cknaDLOkrqnqgcDxkitEqDqOfXO6uzWtSWUrZ/xU9kHZ5z+FOvD8nErREV9rqwSqXYq6KzUXFMEYqEObUyPKhlcFJ1fSnszqlTnob7MLqx4pFmlg1ZG2xrf9xuTd+vl0jlOkUuHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7m54ETa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7m54ETa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AE9C4CEF7;
	Wed, 14 Jan 2026 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768429958;
	bh=4oikowT4rCGYSBAs/PctCCk+m8y0Lr0Dfu3VAL0C3tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B7m54ETaFT9P4PEODfSiBsPO+XNAqkV3Kg5NueDJVgXJ0jxdm9urRTRqK1qaNy6/m
	 9sLTqizTiJsGqnW2i3/LROaCgGZ5yRIYW7uy25DVYVOQrjuuCNo0xnjnDpLHvyLUgI
	 wWDW8wFJ3zL8mZGjxbREllc1MN4gbvB9e5ClFqqmJx86RsDOb9KvQhMqHgPhOpLLVX
	 ljfm01nvGVEGmk0CY57TMyX8l1Ossds2gygmXrtTI99lD8Ap/+rkVgo/BVusYJZ5Fn
	 3Y4NP3tHkZmmDO8FqP2E3g7Ln7jthokgvmcI4uWrDSUyTEbR6rB831ajvyo/nD4Co3
	 en4W7xUH38PRA==
Date: Wed, 14 Jan 2026 22:32:36 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jang Ingyu <ingyujang25@korea.ac.kr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [Question] Redundant ternary operators in nhpoly1305/sha256
 digest functions?
Message-ID: <20260114223236.GA1449008@google.com>
References: <20260114153839.3649359-1-ingyujang25@korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114153839.3649359-1-ingyujang25@korea.ac.kr>

On Thu, Jan 15, 2026 at 12:38:39AM +0900, Jang Ingyu wrote:
> From: Ingyu Jang <ingyujang25@korea.ac.kr>
> 
> Hi,
> 
> I noticed that in arch/x86/crypto/, several digest functions use
> the ternary operator (?:) to chain function calls:
> 
> In nhpoly1305-avx2-glue.c and nhpoly1305-sse2-glue.c:
> 
>   return crypto_nhpoly1305_init(desc) ?:
>          nhpoly1305_xxx_update(desc, src, srclen) ?:
>          crypto_nhpoly1305_final(desc, out);
> 
> In sha256_ssse3_glue.c (sha256_ssse3_digest, sha256_avx_digest,
> sha256_avx2_digest, sha256_ni_digest):
> 
>   return sha256_base_init(desc) ?:
>          sha256_xxx_finup(desc, data, len, out);
> 
> However, all the functions being checked always return 0:
>   - crypto_nhpoly1305_init() always returns 0
>   - nhpoly1305_xxx_update() always returns 0
>   - crypto_nhpoly1305_final() always returns 0
>   - sha256_base_init() always returns 0
> 
> This makes the short-circuit evaluation of ?: unnecessary.

This code was written to be compatible with the crypto_shash API, which
is defined to have an error code for every hashing operation.  So it was
defensive coding to assume that an error might occur, even though
apparently in these particular cases no error was possible.

> Is this intentional defensive coding for potential future changes,
> or could this be cleaned up?

It was already cleaned up as part of the migration into lib/crypto/,
where hashing operations now always succeed and return void.  SHA-256
was cleaned up in 6.17.  The NH cleanups are queued for 6.20.

- Eric
