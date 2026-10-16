Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42E94DDB27;
	Fri, 16 Oct 2026 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166191; cv=none; b=qflZZ2p13fByNNkX5EbV+uSpwlfES+LwwuP5OmcA76uTBj7zhJqy5rWuobzsXNJzbvnczQVIw1FkUMKKefVd/daEM/9iq2P1gDTqx1NhWd0+VTZ30R+Z/Y5rkKPShYa+myVhn+bqEGFQj+5amw3/4AMtB2DjzbX34uJ2uVM+D0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166191; c=relaxed/simple;
	bh=BuTSWLH0EWkTfyPug+LLeQe/PFy5rLGOsJrintsnAhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAvbt/tORb+czjcpbV8r39BaWQnTGk3TxjTjVJ5ypHwB6bQH40evYW9NHBPs9MQRGIs4HRD+jgbPUnJFlPfDX+UE4z+e4BupZ15ubiSMGXwr1PB5KU3qFY14CDqLeT1gvmoqJDNASkfqPv0afhr720LTepyNW0FI+GqJG+nStCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLygHqgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLygHqgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278BB1F000C4;
	Fri, 16 Oct 2026 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792166190;
	bh=/DGgFAunhTyGKABJxIqR8CB8oQjJs71Ms9Y6z1ysLtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SLygHqgtrfYr7SIL1S3nNKjvJObZXnRynkCAqLmX2eu8PbDqF+xOgGBMu7FA6kLrK
	 zQ4VAZ7meIO5302J4fceLCrxCqCrXxpDVPmL0EST70xeby8SK+iIh9wPnFSAmsYv5W
	 Oex51pexigcG3Y8kiPTcJkhldHU5r9t57dVoifbsfWlrTif5pd81FMXmz6nUN7IJAP
	 DcunQp40Z0T+TNyOXnhAI4domPcI3aQ02jiGXixwe/3rQvuemkNxMBSWqOEsRm/qz6
	 J4xbhqnDiUjCw3bYAb6wadiqqkBCgZ42HHN4VJQe4Dp7atUSdBATTGcqiN2DjIvt29
	 Zb2lyk5rsb3og==
Date: Fri, 16 Oct 2026 15:56:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: ZhaoJinming <zhaojinming@uniontech.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thara Gopinath <thara.gopinath@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: qce - fix CCM AAD buffer leak and the AEAD
 error paths
Message-ID: <20261016155628.GA3947801@google.com>
References: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>

On Fri, Oct 16, 2026 at 10:09:42AM +0800, ZhaoJinming wrote:
> This series fixes a memory leak in the QCE AEAD driver together with two
> bugs in the error handling around it.
> 
> qce_aead_ccm_prepare_buf_assoclen() allocates rctx->adata for every CCM
> request that carries associated data, but the buffer is never freed.
> 
> While preparing that fix, two problems in the error path of
> qce_aead_async_req_handle() turned out to matter:
> 
>   - It unmaps req->src although rctx->src_sg is the scatterlist that was
>     passed to dma_map_sg().  For CCM requests with associated data,
>     rctx->src_sg carries the AAD buffer, so its mapping is leaked, and
>     freeing rctx->adata there would free memory that is still DMA-mapped.
> 
>   - A dma_map_sg() failure for the source scatterlist is not detected,
>     because the result is checked for a negative value while
>     dma_map_sg() returns 0 on failure.  The error path then unmaps a
>     scatterlist that was never mapped.
> 
> Patch 1 unmaps the correct scatterlist, patch 2 adds the missing frees
> and patch 3 fixes the dma_map_sg() check.
> 
> All three were reported as pre-existing in the Sashiko review of the QCE
> BAM locking series.  They touch the same function that was recently fixed
> by commit 7f2345f47dd1 ("crypto: qce - fix CCM AAD buffer
> underallocation").

Note that I reported these bugs (and others still unfixed) 3 months ago:
https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/

- Eric
