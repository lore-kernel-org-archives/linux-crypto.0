Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795753585;
	b=zsj83DfO9THl766xgo1EH31OdleZbXcKnYqwljElJDMtAoR/ijBRGXk3oJ8SNorhlTpa
	 iMGFjqd/Cu8T/F7tR68Mz5XKj/OFwnNrAuLC0QnkkY21lMFv+jORFqXGATHFm5pE1DXMP
	 f0VWQqZH3v5uNFYuMe03DhV8CQFfWEiVXuSlmUI/DoO6mUGVuZ1k1VyNR+vkQPo78NQiX
	 sabZasKKHsu8lG0Ty2wXrKkfgAVP4noKtmWG19Zd8DmKLw2if/0Mzbi27gqECv2LfRLJc
	 syXPsb5crAHVDgJOZ4XNf5akYcCNu6bItA/kaEMb0urP1kqlTtUBwHb05bOp7Ogu1PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753585;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=wroQkwyUmImSby60FSSEA23WGTsljWCUGSUqmlr+5fs=;
	b=QtjmF6AWiQlfy6STKTv5+U9yzVfTORJhXiWkvKC8dMHdNPJoqdmE7g88rIhNfUBFryJN
	 t1ZBfz1xaAnWIi/+HCAkWQxS85vfBnJNrwWJpb+4SuTakNLZb8j15FFb6xRGsrxXNWWQ9
	 e2DOov0grkRA/qAoXqUDI6auMYlvoK/3Mkypp4o2xMhEhAqHTUPvFEcBCPZ0VTJgKsZCT
	 wmL0gQVA/0wkVAP7WyNxjpv5nBcj2nll6mHeXdpbin1t9iJytKUV8qpW/nvd2uqend6a4
	 bw4ekUu+0Ak4v01fEBnrSxehLN05kaJyGeFzBAeXcwQX5W5jeJ60B+n9f4cH237xdlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=T+aOBZEX;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC9A606A31E;
	Fri, 27 Nov 2026 04:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BC9A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=T+aOBZEX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wroQkwyUmImSby60FSSEA23WGTsljWCUGSUqmlr+5fs=; 
	b=T+aOBZEX6uzmlDxlpiKDB9TunL9hzXwiHnKJ1On1QOse0ZeS/h3+Wb+Qgqb7EoVtcaQa/jbi9rR
	0FFPOw3G5FfEuNYwz4rBR/oIsIplpf76eoqHuvJw2NckcqnjLNNYRO/tEnF9bT8D3ooCjHyl3mira
	eDHz6AY1Geefx5nSl+Qrx68RxA/E86hQ3chi/oHU/UnMZ6sQq9S9pTvGrvC3VosQkM+e5ELB5VpGj
	AWsEw0uYYsbniJvHhAQE5RK5AsJHVkNKPGcewZUGROL4sWi8bnn1Wo2CXpTHwKcIHDuEWWUhjWQ60
	kv6SvYjF41mSKwKfT7Q2pv5XjhHi/GCAHjiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWnXH-00000002Utb-1xXi;
	Fri, 27 Nov 2026 12:26:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 12:26:11 +0800
Date: Fri, 27 Nov 2026 12:26:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guicai Ma <maguicai@kylinos.cn>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Fix data-race in af_alg_wait_for_data()
 and af_alg_wait_for_wmem()
Message-ID: <awkGY8QdvNxzTVHG@gondor.apana.org.au>
References: <20261118154815.607879-1-maguicai@kylinos.cn>
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
In-Reply-To: <20261118154815.607879-1-maguicai@kylinos.cn>

On Wed, Nov 18, 2026 at 10:48:15AM -0500, Guicai Ma wrote:
> KCSAN reported a data-race between af_alg_sendmsg() and
> af_alg_wait_for_data():
> 
>   BUG: KCSAN: data-race in af_alg_sendmsg / af_alg_wait_for_data
> 
>   write to 0xffff8eec18118fa4 of 1 bytes by task 17152 on cpu 17:
>    af_alg_sendmsg+0x1c7/0xfa0 crypto/af_alg.c:949
>    skcipher_sendmsg+0x78/0x90 crypto/algif_skcipher.c:47
>    ...
> 
>   read to 0xffff8eec18118fa4 of 1 bytes by task 17143 on cpu 1:
>    af_alg_wait_for_data+0x1f9/0x3c0 crypto/af_alg.c:854
>    _skcipher_recvmsg+0x52f/0x720 crypto/algif_skcipher.c:65
>    ...
> 
>   value changed: 0x13 -> 0x1b
> 
> Both af_alg_wait_for_data() and af_alg_wait_for_wmem() are called with
> the socket lock held and use sk_wait_event() to wait for the condition.
> However, sk_wait_event() calls release_sock() before evaluating the
> condition expression for the first time, which reads ctx->init,
> ctx->more, and ctx->used without the socket lock. Meanwhile,
> af_alg_sendmsg() acquires the socket lock and modifies ctx->write (which
> shares the same 1-byte bitfield as ctx->more and ctx->init), as well as
> ctx->init, ctx->more, and ctx->used.
> 
> Unlike TCP/UDP sockets, af_alg updates these context fields only in
> process context under lock_sock(sk). Since add_wait_queue() with
> woken_wake_function is already done while holding the socket lock, check
> the wait condition under lock_sock(sk) before calling release_sock(sk)
> and wait_woken(), avoiding the lockless read entirely.
> 
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guicai Ma <maguicai@kylinos.cn>
> ---
> Testing:
> Verified with a concurrent AF_ALG skcipher (ecb(aes)) send/recv stress
> test under CONFIG_KCSAN=y (QEMU arm64, 8 vCPUs, 60s per run, ~470k rounds):
> - Baseline (6.6.156): 51 af_alg KCSAN data-race reports (both the 1-byte
>   bitfield race and the 8-byte ctx->used race).
> - Patched (6.6.156, 2 runs): 0 af_alg KCSAN reports; roundtrip
>   functional check passed and unrelated KCSAN reports remained active.
> - Upstream (20eef29b7c84, arm64 defconfig + KCSAN): compile-tested
>   crypto/af_alg.o, crypto/algif_skcipher.o, and crypto/algif_aead.o
>   with W=1 cleanly (0 warnings/errors).
> 
>  crypto/af_alg.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

This looks like a false-positive because sk_wait_event evaluates
__condition twice, once without locks before the wait and once with
locks.

It's the evaluation within locks that is final so everything should
be correct.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
