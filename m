Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAB52931C1;
	Fri, 11 Sep 2026 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104698; cv=none; b=mbDTEqT7rCiw7vrt1NqaFVgJSDUj7ORne2juN4BR01wQDXzgI6EZARmjui33S/JSQ35rEzUcyZ7Y4fpaM1Bq08pwYM393PK06JyNeGynXxJHHSrer7Wq7ias5siooduUY8QcYoYne2aZn7gluvf0ek6fzNWrN2STOuyA6NZeq60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104698; c=relaxed/simple;
	bh=eUhMviTe7l/Z8IvO5Kc1ail4fuwGDVlQbuEFnbOvzGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J18s7MFBtMjX0nlfPW23BXykDw4BlPecTllc4r+5c0F2dO5HaPQ26/CeDi/Pnl6+3cDtmrw2HVvBGeRemtcqY231HXRg/Kw9djY673siJqYSmwKkAO4GpK7qFbKJkhinRydits5WkkuRE0EWbMV8mhyqMkDe9ix6HYMCJ9XFixU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rdzIC/ri; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rdzIC/ri"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yJnrdlNp2yV1IsgL/qbAsqaCjof1te0wIYaB1HGeSsY=; 
	b=rdzIC/riHxd85MWw2u11qRs1G/qiY4QHyTd6t77T4sBtguWSwxJZhYBdOJdRFiuZ9yrOaQSKFXB
	jV1cZmDrksafdxP4GdLNxva/9XdcDBDFMeHR1Eh1CfPeZqicWQ/VZuz6WDTVusn6rvNYmQESN8s3Q
	2lRwoYrgLJHPAtAHiiN9K409KFjE0G0fXrILlMaI1zgfVff3dtm5EYeMd4LjeEd0gfTMiOk8pefLF
	G33U/JPosQBDhoxsrlt7C99Zeqsi0Clmrx0GbVRbaYGZJGqO4HtW/h7ZVwqrJzFDGKtlh9zJGaabQ
	LcFgSEBul0X4UFQZrwUJTJcPMTKUHqnsGbMg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4trI-0000000CuBK-2VWS;
	Fri, 11 Sep 2026 13:31:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:31:32 +1000
Date: Fri, 11 Sep 2026 15:31:32 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] crypto: lskcipher - preserve state across unaligned
 chunks
Message-ID: <aqOSNPrFCFtXO-N5@gondor.apana.org.au>
References: <20260829194314.42685-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829194314.42685-1-kmehltretter@gmail.com>

On Sat, Aug 29, 2026 at 09:43:14PM +0200, Karl Mehltretter wrote:
> crypto_lskcipher_crypt_unaligned() splits a request into page-sized
> chunks but never sets CRYPTO_LSKCIPHER_FLAG_CONT, so a stateful algorithm
> restarts from its keyed state at every page boundary. It also marks every
> chunk CRYPTO_LSKCIPHER_FLAG_FINAL, which is wrong but harmless: chunks are
> trimmed to a multiple of the chunk size, so the trailing partial block that
> FINAL guards against is caught after the loop instead.
> 
> ARC4 is the only lskcipher with internal state, and cbc, the other
> in-tree user of the direct API, never passes more than one block, so
> this went unnoticed. bpf_crypto_crypt() however hands
> __bpf_dynptr_data() to crypto_lskcipher_encrypt() unchecked, leaving
> both alignment and length to the BPF program. An 8192-byte ARC4 request
> offset by one byte comes back with its second page identical to its
> first: the keystream is reused.
> 
> Set FINAL only on the last chunk and CONT after the first, mirroring the
> progression used by crypto_lskcipher_crypt_sg().
> 
> Fixes: 0ae4dcc1ebf6 ("crypto: skcipher - Add internal state support")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Reproduced on a Raspberry Pi 400 (Cortex-A72) with a BPF program that
> creates a "skcipher"/"arc4" context, takes a dynptr over an 8192-byte map
> value, offsets it by one with bpf_dynptr_adjust() and calls
> bpf_crypto_encrypt(). Unpatched, the second page of the output equals the
> first; patched, it matches an aligned run exactly, final state included.
> 
> Rebuilding that needs two programs: bpf_crypto_ctx_create() is KF_SLEEPABLE
> and only available to BPF_PROG_TYPE_SYSCALL, bpf_crypto_encrypt() only to
> SCHED_CLS/SCHED_ACT/XDP, so the context passes between them as a kptr.
> 
> With CONFIG_CRYPTO_ARC4=m, load arc4 first: arc4.ko advertises only the
> legacy "ecb(arc4)" alias, so a cold create with algo "arc4" fails with
> -EOPNOTSUPP before reaching this path. CONFIG_CRYPTO_ARC4=y also works.
> 
> ecb(aes), cbc(aes) and cbc(camellia) were checked the same way before and
> after at several lengths and misalignments and are unchanged; with generic
> ciphers they have alignmask 0 and never enter the helper.
> 
> The helper is not dead code, in case removing it looks tempting: ecb() and
> cbc() inherit the wrapped cipher's alignmask (crypto/ecb.c), and geode-aes,
> padlock-aes and sparc64 camellia still declare one, so those instances use
> it today. They are all stateless, hence unaffected by the flag handling.
> 
> Not an unprivileged surface: the crypto kfuncs need CAP_BPF, and
> bpf_crypto_encrypt() additionally CAP_NET_ADMIN.
> 
>  crypto/lskcipher.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
