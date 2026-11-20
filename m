Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795166093;
	b=4ktl6vXp/Dx1OMyqAACJZh46ZfwoDrcsTuy5T/IPPfjF6Q0jn94rW3hIuULoxw0h6XFk
	 dxmG8z3v3nSQsBQNiWu4DpOlKgdMBuAKyRPWUMPXiy8rugGh43IgJT/1zi2Ffd9uxzzvd
	 RwI6xRvD+368gedjw9Dr5UPvB6lGxAcWX5WrRWKfd70yLjgrYmVT5+CDWOVo+hf0DlEOy
	 hwWza3g0WuFSFm0rzLczgDvqxDbFXKQZs/NYd2Qtx6k1kQ8yn9Ma0NVkzh+PMaHy15Wvz
	 kUfxLs2M/nDmSMEP22GhU+xWeuMn6a3i4e8ZxmX6rD4H8XfX+5trXc2zC6AbuVFrE0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795166093;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=nlOZ4k4jiEeYMcrixrMUvGbyScUaQsUnjCuRsm6rEbU=;
	b=5AIvE8XiW3aM57rGCX6zaTzjTzx8/y15F5z0AHKxyiMfZmc/0cCRbCE9X5ja7sb2/L0J
	 LlO9JR98JU5uZ1RfmFlvOYGvJbEgV1EE1C67UwH2D6HdVio1yFwrxoBGmIaFP84WQ3AMd
	 CCvn6tmiQB+nDIr2NnMlOQfEy+IYrrAiXeDsHJla60JrXd6diwaEfbPTMY3i9zBKVNIvS
	 k0ixubGIPq1ch4EscXlp9bthbL6L9N/Lt3v1vxNzF3jSe2HilZBdWwuuatPg2t+Bjpce+
	 z7Yo5wqCZ0AbTqA4lb/dWP1iqFkwyEGJx1HzyR/NV5UbC443p38nrFb6S2ZaryQIG5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ABG0hpLd;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9906606A320;
	Fri, 20 Nov 2026 09:14:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9906606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ABG0hpLd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nlOZ4k4jiEeYMcrixrMUvGbyScUaQsUnjCuRsm6rEbU=; 
	b=ABG0hpLd7nzq/bFlWOiIfZqPjpaaWWiXOTa/R2vAco9LWCUdjSCeA3Q07cLJs2FqPvDqnylwXm3
	DoLYQ5qiur52x0OvZLTsZ+aD3nv0EWhSvberQkEZ5BPhWXcuHkhjqwCc0neyhqMcYlLGONAQis3mi
	CY1T0lLYAsxzFtE8goDWlXnFojZCf7CZqAd/pmyh9T+HlN+ywH7nSWDrw8YnxjgF4eurkGFe9Nb5c
	PhktsApS+dLCIYcOvT7ulp9UQHLivU36bY807Oifkdkm3RaeHQ4ufPmukusJJixPFWmwuRagzTuP1
	UsFWsPBuSdHg4/2wjwb/4NjIiPDNAEaaIeDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xUKhb-0000000HXnf-1emh;
	Fri, 20 Nov 2026 17:14:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:14:39 +0800
Date: Fri, 20 Nov 2026 17:14:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: efecanicoz@gmail.com
Cc: lukas@wunner.de, ignat@linux.win, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Efe Can Icoz <efe.canicoz@atlascopco.com>
Subject: Re: [PATCH] crypto: rsassa-pkcs1 - Allocate the RSA buffer separately
Message-ID: <awAPfzBPyJ-gdVSw@gondor.apana.org.au>
References: <20261111113022.2033191-1-efecanicoz@gmail.com>
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
In-Reply-To: <20261111113022.2033191-1-efecanicoz@gmail.com>

On Wed, Nov 11, 2026 at 12:30:22PM +0100, efecanicoz@gmail.com wrote:
> From: Efe Can Icoz <efe.canicoz@atlascopco.com>
> 
> rsassa_pkcs1_verify() allocates the akcipher request, its private
> context, and the RSA input/output buffer in a single allocation.
> The buffer starts immediately after the request context, whose size
> is not necessarily a multiple of ARCH_DMA_MINALIGN.
> 
> Although kmalloc() aligns the allocation itself, this does not
> guarantee suitable alignment of the interior buffer. On systems with
> non-coherent DMA, the buffer can therefore share cache lines with
> CPU-accessed request state. Updates to that state after DMA mapping
> can interfere with the device-written result during cache maintenance.
> 
> This is reproducible on i.MX7D with rsa-caam, whose request context is
> 48 bytes while the kernel DMA alignment is 64 bytes. CAAM reports
> successful completion, but the recovered output retains the original
> signature prefix and PKCS#1 verification fails. This prevents the
> shipped X.509 certificates and regulatory database signature from
> being verified.
> 
> Allocate the RSA buffer separately with kmemdup() so that it benefits
> from kmalloc's DMA alignment guarantees and does not share cache lines
> with the request context. Keep a separate pointer to the allocation
> base for sensitive cleanup, since verification may advance out_buf
> past the leading zero byte.
> 
> Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
> Signed-off-by: Efe Can Icoz <efe.canicoz@atlascopco.com>
> ---
> Tested on a custom board with i.MX7D and i.MX8QXP, running Linux
> 6.18.37 with:
> 
>      CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API=y
>      CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
>      CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
> 
> During diagnosis, the selected signature driver was
> pkcs1(rsa-caam,sha256), with a 256-byte RSA buffer and a 48-byte
> child request context.
> 
> Before the change, hardware completion returned success, but
> verification rejected the recovered output because it lacked the
> expected leading zero byte. Its prefix matched the input signature.
> 
> After the change, the sforshee and wens certificates load successfully
> and regulatory database signature verification succeeds.
> 
> The cache-line interference described above is supported by the
> allocation layout and the runtime comparison; the exact corruption
> sequence has not been directly traced.
> 
>  crypto/rsassa-pkcs1.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

This issue is being addressed with patches to caam.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
