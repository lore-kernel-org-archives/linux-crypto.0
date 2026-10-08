Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE88470453;
	Thu,  8 Oct 2026 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448617; cv=none; b=kFo7fOuFqpn45Y3w+KOrd+rHjnQ2FKC2T7633On3ZtP2FCnMNc8u5naZ7HFjBDVyLz3NwhrL5Trg4xq4vWfAEtY+UqMrx6PDhIVKIECuSNoeKhrix1sz8GCnTXOvPMKGZhdlwFwB8ZynBgvVIXi/WwQeGSegxSbD+wc+ZEC1RZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448617; c=relaxed/simple;
	bh=EJze0rSzfYhT//NzE2UVHRZ2vKrJJf5OTEe8RjcsctQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWtC/tpxunhnRg29UX+bmmacSw8eIBr0hESWQVCZUax5sog/aUiBDzxP8CnLeInDJq604r05hSoTxm91Mrp3JcdyisOMrYpgSIuQSlndS+vZz9hV1dvJl+F860eDEVM1b8EyII4cS219lcP+TXsbdvmaY08HNP16sGPMpgaDx9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KKIYXQ7a; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KKIYXQ7a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aIkt51qSwtLxEIzSoxULpG/DSm+K3XlpeTnhLjyIP1M=; 
	b=KKIYXQ7a2IBHSCsoKdwmdZRru5Q1nAAuHl1G/rEzJ3jKyoTcPv38WfAMY+MXiutH21ZiRt+xK3+
	9Vr8Cc4+dxzBLAa6VQCLiXblxsC7HoI0uGFJ8B1GplPPsA3NwrzR3yUxTlSRgtPbrlB/V47x3ZkrV
	ma+w6YN7MxNhG82wBAOU3YgR0Qcseyb5eohDCCoxD7ELZ6XJ21kE/7nTUhMef/j19o2gV8LA0pjcS
	g+Nlw16Qk8lspcNATQbw2d3r9bewkahQF+FT7tu+Ao+u8+gRIDColu9vzlgBSfAnBy63tEaKvoyEJ
	M8x+hQzk9/ZaSdrEStz5KKxV3II5WPnGBYbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjcQ-00000001oA0-2wgu;
	Thu, 08 Oct 2026 16:36:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:36:50 +1100
Date: Thu, 8 Oct 2026 19:36:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: algif_skcipher: rewind rounded output bytes
Message-ID: <asdWIprHmkPiPgKp@gondor.apana.org.au>
References: <20261004050946.3131044-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004050946.3131044-1-4ncienth@gmail.com>

On Sun, Oct 04, 2026 at 02:09:46PM +0900, Daehyeon Ko wrote:
> af_alg_get_rsgl() advances the receive iterator by the unrounded RX
> scatterlist length.  For a continuing skcipher request,
> _skcipher_recvmsg() then rounds its local length down to a whole chunksize
> without restoring the iterator.
> 
> A later chunk starts after bytes which the provider never wrote, while the
> syscall returns only the processed length.  When copy_splice_read()
> supplies non-zeroed pages and publishes that return as a dense prefix, the
> gap exposes stale bytes from a previous page lifetime.
> 
> With unprivileged xts(aes), a 31-byte MSG_MORE request followed by one
> final byte advances a 47-byte destination while returning 32 bytes.  A
> hardened v7.2-rc5 image retained all 15 seeded stale bytes in 4,829 of
> 4,829 records.  With init_on_alloc enabled, all 72,345 gap bytes observed
> were zero.
> 
> Rewind the iterator by the tail excluded during rounding, before rejecting
> a zero processed length.  The crypto request uses only the rounded length;
> af_alg_free_resources() releases the entire RX list before another receive
> iteration.
> 
> The fixed target-like kernel returned byte-identical dense 48-byte output
> in 4,771 of 4,771 rounds.  The unmodified kernel returned the vulnerable
> 32-byte short record in 2,409 of 2,409 rounds.
> 
> Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> ---
>  crypto/algif_skcipher.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
