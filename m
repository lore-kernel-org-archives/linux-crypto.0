Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756625;
	b=aXMMkzss+8Etst4T4hq+3B3AzLzCiRWYpfpZr/aLS+j5dET5b7skzykodKrfGW4ME1AV
	 XFr2LECJwlJo+diQc5ryx8qzGN6953X8jBK/5V6wo9uQwlAdJzblyf5+Xcgxj32tqSPoz
	 CR7VNMJBE/D6KBIgCumEaPsg8WSdFsVD8t5jOD50xKXNEfKx7hSiMrxkjQaBht+CMUPga
	 nRTFlQenln8P3rjwg9KAimqbxstUxlL+M19pe+m/geneuICFkkqGaMCg3LbzF1vmxLBcW
	 5G7nnIXFq+3cSLaEqOvy0rQac0uwwzSY4txvu9gmbiAtik6hG7cHcgt0sE2nK9T+4Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756625;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=rCTUltGYUfDut+dLHTTZSo7XsdacsDATELtjavFo3IY=;
	b=hCLQThYkVmDgNUPs8vwmDt8SOdcfcD1Rsbaa5fWrez28cjwmsCrumNUWfdscyn7W6XMN
	 g6CrXJor0VyMmlM51YOG7CSLavIyooL7zmnVxahkzXhz1zkc3M2sPh+wO766KowhxI/OD
	 r8BUl9I0cfUWdhtJThetdG3V1PVjMHxef/2UNIuSwqL39ypjZuMtqUZVlXibEw07iTq4a
	 gpG7TwRuuYwWIP1/Y+T7OKixoinWZ1+FHrMbwk5a6sN0XdPT6eZjGRt/WNDdcQx5PreV7
	 f/C9y2aXGML8BZ+OL4bP7kSVVcRqtG3Ol8TVT8bQg1r8FeGxFlaEKHFMARaJkKDz+iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=L2V1k9QN;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F6C606A31E;
	Fri, 27 Nov 2026 05:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20F6C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=L2V1k9QN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rCTUltGYUfDut+dLHTTZSo7XsdacsDATELtjavFo3IY=; 
	b=L2V1k9QNg4eYR47tRV9RnqQJhebMOUAchoZW2gCg5Qk/UbIAVtPiZbzZVynaN4p3zuDATHRd1Im
	45rml4kD5ANXn3tKFdxAJFIJGfgtiIQpz8lMq6oMOVQuL+g9zrNneK0auXhpKAwoNfIuB01MqYgNg
	z+BrEBcardV6HyFBml3maS6jvjAn6IsAXxw6fQ+GcJKOxkUMef5LUoB9ePrgijxorb9AI0vIY6Whc
	iDbyhMY7rARHTVMmuhSmgOU6T/A+nbKLGPkzHnsA+0fZSGFSv+nihSQhnTWO4b6yQ8QtQSmv0YMgE
	BQh4gZujTuDWlHSwalg7SJAxugBIOgYBBwaA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoKS-00000002Vad-0cZS;
	Fri, 27 Nov 2026 13:17:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:17:00 +0800
Date: Fri, 27 Nov 2026 13:17:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Danny Tsen <dtsen@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org, leitao@debian.org,
	nayna@linux.ibm.com, appro@cryptogams.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH v2] crypto: powerpc/p10-aes-gcm - Fix IPsec stall on bond
 failover
Message-ID: <awkSTCnlXZ5gmsVs@gondor.apana.org.au>
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
> ---
> Tested with tcrypt.ko (including the self-tests) and with IPsec traffic
> across a bond failover. TCP throughput no longer drops to zero.
> 
>  arch/powerpc/crypto/Kconfig            |   3 +-
>  arch/powerpc/crypto/aes-gcm-p10-glue.c | 155 +++++++++++++++++++------
>  2 files changed, 119 insertions(+), 39 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
