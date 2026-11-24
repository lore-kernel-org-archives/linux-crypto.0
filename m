Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795524551;
	b=yrhfz5I7FGqzUhmglKgEnLlMOoFPFzUs5PXj0IhddgBaSr32NxqqtD5JkfTYfLj145Z2
	 LnKoN57yjbw0PV+Q9f5lgu9n1olTpi0C9iftPMMeHkIVi1dBbR49lHVNTFvx8lGVzfinH
	 yI+sXG3vzfhpyyDxnLdrzYUnMFhCWn1Fa6fqP8Rrpyh316dcDfsnbkQ9/pX0VMnE4NRSS
	 OIMPpDxiOLpO+Wxbuysafde3ADStiW4mI36j0uANQ16DxE505t2qJI0YH8DRvULrpmrgw
	 BvyI+OnGw5p15DvFKNwHuuNAHAI4UuTsaaKhvWzHkyNBvVLhfzvnEgyyXGPfbP83kEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524551;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9cnMVGzxTuIHoQH62vELDNNDNvOirq7wvh4En0KQes8=;
	b=xAnPsT4D0OlwvWjlEIkInuvDVTEgwQ5DCEnD0T31jxbT48IMPAQ7R2GJ2ZG0/WWmQFcs
	 7zzyg0gmpRv6Zs5X36sahKPpnZrLq/LXdemacv/cpDDSOChLGP+BnWNbxIJaI1vclX0iO
	 1MDfXrL0bfn17S5TYWl20NVphjUD2I7k0BC8rfxtj+/milL6SuWEoyoqmdBUrU/90ZgdZ
	 BfNOgVWlPK8NfP0Q3Lr2jNJAhZ1g/fSdQRtWPgvenraNLTnynP7K2zoaN08+oNuZuVXdn
	 o8/FTXtxtA1lMkYmI+2P89rGnpQT+gCQsZfnseVPIq2QXpg6MHRyUyhB8FDAOiakR7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ea1oFfQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8A3DB606A31E;
	Tue, 24 Nov 2026 12:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ea1oFfQ9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D4BA1F000C4;
	Tue, 24 Nov 2026 12:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795524551;
	bh=9cnMVGzxTuIHoQH62vELDNNDNvOirq7wvh4En0KQes8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ea1oFfQ9iiL/9KI3aDiVB3CxLBlk0Ro85Mg53SVRC+MoOau9z2IzTqCeFOLaUbllk
	 E5+6ebyYCSUNlhdTZgbFTxwBbzZ4dYHDjmtiqs1yVCKZmydy2oWQXxi6/anJu180yX
	 LIjHRnm0pyvsWXBYhK+JYYqRIltxUiiFO5oC/XO4rqb8FcKqtha/eQ6Iws6zb6XVZE
	 F9SekgZeora7KFiGEeozWdO4Md4aQSs4XYDYRHBCoi2Ri88qXe4Mp9E22e66/OCsM5
	 lCZh/7RcnkZ3NtSTbvpEMbdqlPphMqaKeiZ7/jKABV4Lf4CgbSV5oi+xXzNMEF+CTz
	 FUqn4xlZfMPaQ==
Date: Tue, 24 Nov 2026 13:49:07 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Lee Jones <lee@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Thorsten Blum <blum@kernel.org>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 08/10] crypto: qce - Pass mapped scatterlist count to
 qce_dma_prep_sgs()
Message-ID: <i5lcy272xcv5lvosep6ak73bh2eehdlnloz2z24vawtv6cvkn4@273e66vs56fi>
References: <20261123151055.2533735-1-lee@kernel.org>
 <20261123151055.2533735-9-lee@kernel.org>
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
In-Reply-To: <20261123151055.2533735-9-lee@kernel.org>

On Mon, Nov 23, 2026 at 03:09:59PM +0000, Lee Jones wrote:
> In qce_ahash_async_req_handle(), dma_map_sg() maps req->src and returns
> the number of coalesced DMA segments in ret, which is immediately
> overwritten when mapping rctx->result_sg.  The function then passes the
> unmapped segment count rctx->src_nents to qce_dma_prep_sgs().
> 
> When an IOMMU coalesces scatterlist entries so the mapped count is
> smaller than rctx->src_nents, dmaengine_prep_slave_sg() walks past the
> mapped entries and reads uninitialised DMA addresses and lengths from
> the tail of req->src, while dma_unmap_sg() still requires the original
> rctx->src_nents count.
> 
> Save the mapped segment count from dma_map_sg() in a dedicated
> src_nents variable and pass it to qce_dma_prep_sgs(), matching the
> skcipher path.
> 
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Closes: https://sashiko.dev/#/bug/linux-24490c31-257a-4148-a816-0aaf416f64a1
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>
> ---
 
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
