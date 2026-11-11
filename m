Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394229;
	b=oxMoYJOO90kYzEcZ087AiGgk7ljZVjIY/m6rAbxEv/sQDZZEYT0N5a8pVV0tuwJD/907
	 c4rLHw7qSYkm03UDjUZElH3PntUEpFoHIf+x7NOnYxfTUEt8n9eB0tI+XETpLhTnlEcrX
	 q2MLxb7hi4JKhbkWubGyi/69mvwLggvtfORlkr4aHXBoOyvQvOryBe8yN/uaZgKLoltX8
	 JmNqNh8gNtB4XWABH2YRrypi2kaJfR6pwmD2c1VaofpVo7utTv0F8GzYoQu4R8tkd9d/F
	 y4qWLQxF53fERwONY6DBMAVSo5uHIg2iqlM93puwMAWNEht0vxrvV5Z7/zTYmI6nEYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394229;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=AvcBgrPzTkerP4XT6zd7gDQi0L+d93ktdb5ouA+0y+0=;
	b=w9Yp2dJBG8HfgWjg2dSmhHof16q/TFVoh65qowaCu8oQSKO0CIWVf6dZbQ5wGAFOp7Y5
	 s0bdmQZSJNYEcBUP11i6ZWuBx4Xa00ngzWlo+pm55HtQ8pKfcjq+qZyiHvst3P7nsYuGi
	 LpkcBDngdOVfDEOwGtH9Vx9h4o9IXuSs6zXDRH8fMgiPfM8VpXQ++41WKdiiTyb6teJml
	 OFhQOPVwpVFTQCl7nANO2VcL0BfldXcxIh1kkM4MIC7vSpRnYZB7/0cTpAeNMgP9fZoMi
	 fX10ftl4Aa2+2T5n9yAPY2ldjndFFttg0nKRGVr6gCz6ml/wJoKWX8c7jL9C8HLgvig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hXyb69Uk;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B4F606A31C;
	Wed, 11 Nov 2026 10:50:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B4F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hXyb69Uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AvcBgrPzTkerP4XT6zd7gDQi0L+d93ktdb5ouA+0y+0=; 
	b=hXyb69UkKGHtHfUMegNRZjUDd8HJ5ZsS8vLHvqR6Z8sgsl6Ae91HiIYVHMq8AVk6IJRKRVET2Wp
	hy2ypgFRqQtS49xWcrqDu50yjlM8tbFt9sgX+hZgCa0FIWpRuSejwz4Jv5og2a9+4GXiJJcwYUsjS
	xox4DyqCBV7wvOBgPBrQf9MW9sVzKvC7esqCqrtLEA1RX7Tei6tIaf8w1fE9Qg2ZJ5tkyjXvnwWTA
	QnPTVeTaPgdRSPDI3cXJ667uWHnW0Vsu5mEiKQoBmqWcZ9CMLRmRia1omdX0mhQihCigywWsryJW+
	Ba4M4tpo3PnsrYMPv2WR2acZxm3DqEqVWR1w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR5u6-0000000Dlyt-1IvG;
	Wed, 11 Nov 2026 18:50:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 18:50:10 +0800
Date: Wed, 11 Nov 2026 18:50:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: sahil.malhotra@nxp.com, davem@davemloft.net, horia.geanta@nxp.com,
	pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com, stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com, martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de, sahil.malhotra@oss.nxp.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] crypto: caam - Use bounce buffer for unaligned
 RSA destination buffers
Message-ID: <avRIYjWB6AUbeLUS@gondor.apana.org.au>
References: <20261020025426.955531-1-changwei.zou@canonical.com>
 <20261020025426.955531-3-changwei.zou@canonical.com>
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
In-Reply-To: <20261020025426.955531-3-changwei.zou@canonical.com>

On Tue, Oct 20, 2026 at 01:54:26PM +1100, Changwei Zou wrote:
> The rsa-caam driver directly DMA-maps the destination buffer supplied by
> the caller via req->dst without checking whether it meets the cacheline
> alignment requirements of DMA-incoherent hardware such as i.MX8.
> 
> On CPUs with non-coherent DMA caches, if the destination buffer shares a
> cacheline with other data (i.e. it is not cacheline-aligned), cache
> writeback/invalidation during DMA can corrupt adjacent memory or cause
> stale data to be read back. This manifests as intermittent -EKEYREJECTED
> errors when loading signed kernel modules.
> 
> When any segment of req->dst is not cacheline-aligned in either its
> start offset or length, allocate a single contiguous aligned bounce
> buffer covering the full dst_len rounded up to a cacheline multiple,
> redirect the operation to it, and copy the result back to the original
> destination once the hardware has completed successfully.
> 
> Introduce a helper sg_is_dma_aligned() that checks both sg->offset and
> sg->length for cacheline alignment. Checking sg->offset suffices for
> the start address since physical pages are always page-aligned and
> PAGE_SIZE is a multiple of dma_get_cache_alignment(). sg->length is
> also checked to ensure the buffer end does not share a cacheline with
> adjacent memory.
> 
> The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
> can be triggered when loading signed kernel modules:
> 
>     for i in $(seq 1 100); do
>         sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
>         && sudo rmmod xfs || echo "FAILED on attempt $i"
>     done
> 
> Reported-by: Martin Kepplinger-Novakovic <Martin.Kepplinger-Novakovic@ginzinger.com>
> Closes: https://lore.kernel.org/r/6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com
> Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
> Assisted-by: OpenCode:claude-sonnet-4.6
> Tested-by: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>
> Tested-by: Stephane Debusne <stephane.debusne@cynove.com>
> ---
>  drivers/crypto/caam/caampkc.c | 87 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/caam/caampkc.h |  6 +++
>  2 files changed, 92 insertions(+), 1 deletion(-)

Please respond to the Sashiko comments:

https://sashiko.dev/#/patchset/20261020025426.955531-1-changwei.zou%40canonical.com

I'm also disappointed with the lack of response from the caam
maintainers.  Unless active maintainence can be demonstrated
for this driver, I'm going to have it removed again.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
