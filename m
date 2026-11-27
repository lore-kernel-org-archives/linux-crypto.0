Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756607;
	b=jBpoYsaXiN7iT2D1LCOKNAVBrSJVt0UV6Z0z0owiJo41XUjw1/2jMPmT23nzO80CKLVR
	 SihXUfMzny3ZmWSxNs6wOdeuGdPMiWBCFpxzm3GuX86D+9MthhBmawWuEXi33XTRgLdrL
	 q8058+Sddw6H7B+i/b8+sesDWMRur2j1n7zV1FSoTMd52FdkvN8Xk/wXOZ0t0qLPBVp3J
	 omA8stV8lDQmSkECLV+AAnwfuKgjt36EjCEhdyINeTnCStjQzyq+Pt8GQpnKTQQoNcuvj
	 uyqLG576LNaq3oGeCkLKe77HjNgi5nKbA5M8Moi4Hr/gCXj9XoEyZOnUHW0DOwzFF2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756607;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=65LcxIH/izNEZhF/8SUgg0Mx2oByVHkrhxL4YzMRCD0=;
	b=m1yKApho5L3k0X/rP6CLFTy8KmfKwrBmNJOuJBXT0xtK5DV3O/lvxAtiPSNWmvPm2KES
	 OKSiEl2UeJ7LtoWQ1wbj4pbtvLoA5jHwqnRhyG6uNiwhEuIgsKXrfUTxP7pku5fiLUZ5z
	 P9h40T+o7bRele7daN5UpjUfka7UTO7rrpjAmXbY+FvACIClQDVj1ld+4qWNJUpkgbmWO
	 Zi3UMhsA/d6LWOwgoZqM5Uu9vGVLWAbbelW9rdiFckgYq3TwfRftSNUPzCNAcKCF+IEJM
	 WgShESKH+C6Iu+2JbR/Z2hexYYxnejcvLWMqwfZydWt7EQ0iVakS+d/ficXUXlfQPIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dYWGcQsG;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00FD606A32F;
	Fri, 27 Nov 2026 05:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B00FD606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=dYWGcQsG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=65LcxIH/izNEZhF/8SUgg0Mx2oByVHkrhxL4YzMRCD0=; 
	b=dYWGcQsGQOgIdn3Uf3ipJDEDgrRB2RgiTFcShUVK4T9KKtxdVrrwJjN18+1rYd9sXjzLDIWacVG
	dWdkPxYB0HnYq91/km9i228kPwmD1MMdd1WPLal8clKHXDzoogGXxb1VZ0WjtbTyQwCtcCefYK+Xu
	imGvBvX4OhfV8k8N1gDzyVACBcfjqkQ5jLp0whspO+PvO+pLa4LkhfwZzuDEh5P8QffrGuEJLe08D
	ECQf0yBS7skIrucdMxB8VW0u9CC4zIZCH5zBqnbOqR21qv4j78fKtjUePnsMpPSxGFZXLOwul4nGm
	xsQfKsWOZ98GSfQM+9Fwp8amgPOJn6BUU7jQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoJx-00000002VXA-3CQy;
	Fri, 27 Nov 2026 13:16:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:16:29 +0800
Date: Fri, 27 Nov 2026 13:16:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: sahil.malhotra@nxp.com, davem@davemloft.net, horia.geanta@nxp.com,
	pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com, stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com, martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de, sahil.malhotra@oss.nxp.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/2] crypto: caam - Fix RSA error-path unmap and
 unaligned dst buffers
Message-ID: <awkSLXIuw-2b4Msi@gondor.apana.org.au>
References: <20261120123732.1200685-1-changwei.zou@canonical.com>
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
In-Reply-To: <20261120123732.1200685-1-changwei.zou@canonical.com>

On Fri, Nov 20, 2026 at 11:37:30PM +1100, Changwei Zou wrote:
> This series fixes two issues in the rsa-caam driver.
> 
> Patch 1 fixes wrong unmap operations where rsa_pub_unmap() was called
> regardless of the key type.
> 
> Patch 2 adds a bounce buffer to handle unaligned RSA destination
> buffers on DMA-incoherent hardware such as i.MX8, fixing intermittent
> -EKEYREJECTED errors when loading signed kernel modules.
> 
> AI assistance disclosure (per Documentation/process/generated-content.rst):
> the OpenCode agent (claude-sonnet-4.6) was used to help analyse the code
> paths, draft parts of the changes and the changelogs.
> 
> Changes in v8:
> - Patch 2: Add Fixes: 8c419778ab57 ("crypto: caam - add support for RSA
>   algorithm").
> 
> Changes in v7:
> - Rebase onto the current tree; v6 no longer applied after the upstream
>   caam_rsa_set_priv_key_form() changes (a91d9346a70b, 828c3b265b6d). No
>   code changes.
> - Drop the non-standard "Assisted-by:" trailer from both patches; it is
>   not a recognised trailer (and fails checkpatch), and the AI assistance
>   is disclosed in this cover letter instead.
> - Pick up Reviewed-by from Sahil Malhotra on both patches.
> 
> Changes in v6:
> - Patch 1: Factor the priv_form switch into rsa_priv_unmap(), shared by
>   rsa_priv_f_done() and rsa_pdb_unmap(), removing the duplicated switch.
> - Patch 2: Hoist req_ctx to function scope in set_rsa_priv_f{1,2,3}_pdb(),
>   removing the duplicate block-local declarations in the src/dst branches.
> 
> Changes in v5:
> - Patch 1: Factor the public/FORM1/FORM2/FORM3 error-path unmap dispatch
>   into rsa_pdb_unmap(), so akcipher_do_one_req() and akcipher_enqueue_req()
>   no longer open-code it twice (Sahil).
> - Patch 2: Do not overwrite the caller's req->dst. Use req_ctx->fixup_dst
>   for the DMA side (mirroring fixup_src) and drop the orig_dst/restore
>   logic (Sahil). Expand the commit message to identify the caller that
>   hands in the misaligned dst (rsassa_pkcs1_verify() /
>   crypto_akcipher_sync_prep()) and why the DMA API does not bounce it.
> 
> Changes in v4:
> - Patch 2: Describe the bounce scatterlist with the aligned allocation
>   size (ALIGN(dst_len, dma_get_cache_alignment())) instead of the
>   possibly-unaligned dst_len. Otherwise, on
>   CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC systems, dma_map_sg() evaluates
>   sg->length and can treat the already aligned bounce buffer as
>   unaligned, bouncing it again via swiotlb or failing with -ENOMEM.
> 
> Changes in v3:
> - Patch 1: Dispatch the error-path unmap on the operation (the completion
>   callback rsa_pub_done vs rsa_priv_f_done) instead of key->d, so the
>   unmap always matches the map.
> - Patch 2: Bound the bounce-buffer copy-back to the RSA output size
>   (key->n_sz) instead of the full dst_len, so the trailing capacity of
>   the caller's destination buffer is left untouched; add Tested-by from
>   Stephane Debusne.
> 
> Changes in v2:
> - Patch 1: Add Fixes: tag; pick up Reviewed-by from Sahil Malhotra.
> - Patch 2: Move the !bounce_buf check out of do_rsa_bounce_buf() into
>   the caller rsa_bounce_buf_done() so the helper is only entered when a
>   bounce buffer actually exists; add Reported-by/Closes and Tested-by
>   from Martin Kepplinger-Novakovic.
> 
> Link to v7:
> https://lore.kernel.org/linux-crypto/20261120110525.1170175-1-changwei.zou@canonical.com/
> 
> Link to v6:
> https://lore.kernel.org/linux-crypto/20261114060032.872141-1-changwei.zou@canonical.com/
> 
> Link to v5:
> https://lore.kernel.org/linux-crypto/20261113113650.63038-1-changwei.zou@canonical.com/
> 
> Link to v4:
> https://lore.kernel.org/linux-crypto/20261111230221.40297-1-changwei.zou@canonical.com/
> 
> Link to v3:
> https://lore.kernel.org/linux-crypto/20261020025426.955531-1-changwei.zou@canonical.com/
> 
> Link to v2:
> https://lore.kernel.org/linux-crypto/20261004210200.290119-1-changwei.zou@canonical.com/
> 
> Link to v1:
> https://lore.kernel.org/linux-crypto/20260821045555.806471-1-changwei.zou@canonical.com/
> 
> Changwei Zou (2):
>   crypto: caam - Fix wrong unmap operations
>   crypto: caam - Use bounce buffer for unaligned RSA destination buffers
> 
>  drivers/crypto/caam/caampkc.c | 177 ++++++++++++++++++++++++++--------
>  drivers/crypto/caam/caampkc.h |   7 ++
>  2 files changed, 142 insertions(+), 42 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
