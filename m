Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1CC4D0A05
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792158016; cv=none; b=HP/q8lYW3c3A98BeXUqh7+m4YTHva3Jt2HfSXGT1EZoMeSkQ+scQVvj/vWPGWlqXvAeNFB+ZdJFifpcdh/Orlza40qfWmWkyIGAA4dGWUJfTNHKg3htCvSd9qsjaN1ytYJMuOoJJItIuBBmQ2wi3uWUh/W40KRcBQ91hb1S6SOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792158016; c=relaxed/simple;
	bh=erMqNnqKnE3TTlb4bHitvna4KLJz4uoSJmF4IdyTeC4=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4rQPsTe5HYJcaLvr4s6zl+Rk9SWM1lGm1/ZWzBIPHCklvqtPmpuyq9BVMbYaMhHUqToJ8IN5MRwGr7X5HFcK/mwR8m0hmSzrxqs7brlaq101zRBVHTNFn/eISYK5y+BL9Pr0bzyApFgaApUcFIU7VpSr2jFWoU0ARGzUmiV7bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiJUU6Xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiJUU6Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DE51F000C6
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792158014;
	bh=eNVBQyP50cHJEa5KS5OJogHRlPLCmh3Z4HuhJl22Lv8=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=hiJUU6Xu0Z9AlP5L+IEXay2yVtDatHVCdvOGnJO0wgS4J/QLLFSyQPgqOBGBYKnEe
	 eQLPBh2e1k+82sHtpj4Yy3mfPEkfTq5zxqaDj8CfrrHh34Zg5SQVUd0hcurx0J6ouB
	 hqjcM6MQ4v+8OG6dy9foKwlAf8A0cWvlzNRmJUx1G4y95lTlmh3J7DFbdFHTALU5qB
	 p2hTDIpYcsEFAq1f1pMNLOxLmDQ96lL7qoqzvstuJ3tWvyt2b68e058qZT8twOP9fF
	 07JfskBb4+Urv4oS+O08/jnAKzJFFAVD1KPi6ySoA4snZpRN6QkyqMzEIbbhnaKfp9
	 5cxYHZDu62cgw==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b8f5e2ce5eso5848021e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 06:40:14 -0700 (PDT)
X-Gm-Message-State: AFq9FYLOxjDDXgN2P4p7c1j+6PJ++845pJ1xLqKm/Tti4lBHSmO9YDD6
	/GIXM9F48L+GSSptU8DPNpVrSVucVkTgRwQiM7Ajd2UP6huBJKuYZlx3EpvlHRh/Ga3LBGXrtK2
	19RIjvgCvG5djIe9TxbEqwU1BUsp9cLUB/B9HXmuUiw==
X-Received: by 2002:a05:6512:3994:b0:5be:4c7c:fb8 with SMTP id
 2adb3069b0e04-5be4c7c0ffcmr610991e87.13.1792158013398; Fri, 16 Oct 2026
 06:40:13 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 16 Oct 2026 09:40:08 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 16 Oct 2026 09:40:08 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
Date: Fri, 16 Oct 2026 09:40:08 -0400
X-Gmail-Original-Message-ID: <CAMRc=Mf6DbSHKEnXLOpDXs8x3bHYQN+oQHmg+tj4aD-rCc9dzg@mail.gmail.com>
X-Gm-Features: AclHuK-59soD-0iTM4uUCy0udpQ6HrlKwlsewh314Ac8DwFej8E-BhAtkZWIOM4
Message-ID: <CAMRc=Mf6DbSHKEnXLOpDXs8x3bHYQN+oQHmg+tj4aD-rCc9dzg@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: qce - fix CCM AAD buffer leak and the AEAD
 error paths
To: ZhaoJinming <zhaojinming@uniontech.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Bartosz Golaszewski <brgl@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Thara Gopinath <thara.gopinath@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 04:09:42 +0200, ZhaoJinming
<zhaojinming@uniontech.com> said:
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
>
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
> ---

All three look correct to me, thanks!

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
