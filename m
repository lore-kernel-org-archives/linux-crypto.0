Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D11D2153CB;
	Mon, 23 Jun 2025 09:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670761; cv=none; b=m4YoXrMXNvIRXtz1r/2vY8C+sVBesWxKzwiq1xw01hObHf4cXnjvaeLOoHMEExyX4ioXjzMWNs4ScxOsHIq4fIGTqEEVNIgk5gRMbgWTOFwPgofXB845tH2tn8T1iKtn6jhhvYN95U38xBpigSHaF48A/8GGQ0W3jBi34qV7m/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670761; c=relaxed/simple;
	bh=OH7AJS4qRPo9d6d5otj3YANX9D46v3fAukmYG5Px5Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnf9yvtxQKErf8TJrfK+VnpdygqAkWchaNR06JyjAyEOQpnTNDquQ8RrHtrlt14lbZuE2oDhExrRXVwN+IqIpAb9FpKs1fHV3BvAh7wUGvcSHeOItaxUhRhveYxqf1DJh79XBIAwjpXfoMa+joVv9qiBUpDxqjfSX0tFXPbq8Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=arnrawTF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="arnrawTF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C8gm8DvUCu2gFGrryJVGp4b24ZZxxKjxkt1MvFsDY70=; b=arnrawTFIT5eQlWEhJ7ZPt4Vke
	PAqxXaowHjnxr6eGM8rYLAEwN2bJxYqbUjpZQ5M3ffwFb0AwTLhOu57BQqFBjXfuHa5rfiJUgvuQG
	RQqhe1gpvXYbnV7zpUEUlYaic2qfWL0kwPLnst0mDZVIxD+Fhw4d+VE0SvjP7y0sO0I54D2iUMGDt
	172QNe5hvELF7Mq4i0wUBNXcxLjvG8fVg6GsEIoSVINjp7QnGSA241/v6QCRZO+Sb3Thl3fjaBlFF
	fY8h6NVxmThW17QxNdjQ8OGBtPlSyCAKzdhAo1oCsklfoCxpysOBEg2w74F/9Nk+NzCq1rK77lgnn
	nWcMfCDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTdBe-000FhC-2C;
	Mon, 23 Jun 2025 17:25:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:25:55 +0800
Date: Mon, 23 Jun 2025 17:25:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, shenyang39@huawei.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon - Use fine grained DMA mapping
 direction
Message-ID: <aFkdo8swvmW1Z9dQ@gondor.apana.org.au>
References: <20250618100026.1586-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618100026.1586-1-yuzenghui@huawei.com>

On Wed, Jun 18, 2025 at 06:00:26PM +0800, Zenghui Yu wrote:
> The following splat was triggered when booting the kernel built with
> arm64's defconfig + CRYPTO_SELFTESTS + DMA_API_DEBUG.
> 
>  ------------[ cut here ]------------
>  DMA-API: hisi_sec2 0000:75:00.0: cacheline tracking EEXIST, overlapping mappings aren't supported
>  WARNING: CPU: 24 PID: 1273 at kernel/dma/debug.c:596 add_dma_entry+0x248/0x308
> 
>  Call trace:
>   add_dma_entry+0x248/0x308 (P)
>   debug_dma_map_sg+0x208/0x3e4
>   __dma_map_sg_attrs+0xbc/0x118
>   dma_map_sg_attrs+0x10/0x24
>   hisi_acc_sg_buf_map_to_hw_sgl+0x80/0x218 [hisi_qm]
>   sec_cipher_map+0xc4/0x338 [hisi_sec2]
>   sec_aead_sgl_map+0x18/0x24 [hisi_sec2]
>   sec_process+0xb8/0x36c [hisi_sec2]
>   sec_aead_crypto+0xe4/0x264 [hisi_sec2]
>   sec_aead_encrypt+0x14/0x20 [hisi_sec2]
>   crypto_aead_encrypt+0x24/0x38
>   test_aead_vec_cfg+0x480/0x7e4
>   test_aead_vec+0x84/0x1b8
>   alg_test_aead+0xc0/0x498
>   alg_test.part.0+0x518/0x524
>   alg_test+0x20/0x64
>   cryptomgr_test+0x24/0x44
>   kthread+0x130/0x1fc
>   ret_from_fork+0x10/0x20
>  ---[ end trace 0000000000000000 ]---
>  DMA-API: Mapped at:
>   debug_dma_map_sg+0x234/0x3e4
>   __dma_map_sg_attrs+0xbc/0x118
>   dma_map_sg_attrs+0x10/0x24
>   hisi_acc_sg_buf_map_to_hw_sgl+0x80/0x218 [hisi_qm]
>   sec_cipher_map+0xc4/0x338 [hisi_sec2]
> 
> This occurs in selftests where the input and the output scatterlist point
> to the same underlying memory (e.g., when tested with INPLACE_TWO_SGLISTS
> mode).
> 
> The problem is that the hisi_sec2 driver maps these two different
> scatterlists using the DMA_BIDIRECTIONAL flag which leads to overlapped
> write mappings which are not supported by the DMA layer.
> 
> Fix it by using the fine grained and correct DMA mapping directions. While
> at it, switch the DMA directions used by the hisi_zip driver too.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
> 
> The hisi_zip part has not been tested due to a lack of HW. I'd appreciate
> it if someone could help to test it.
> 
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 21 +++++++++++++--------
>  drivers/crypto/hisilicon/sgl.c             | 15 ++++++++-------
>  drivers/crypto/hisilicon/zip/zip_crypto.c  | 13 +++++++------
>  include/linux/hisi_acc_qm.h                |  4 ++--
>  4 files changed, 30 insertions(+), 23 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
