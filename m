Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0B9265604;
	Mon, 28 Apr 2025 11:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841232; cv=none; b=RsPqi7Zu8UAALatU724r9OtdYTQ+m354qMvL6ZQWuVl+OnjLfE6CRsgkyNRNjX5q/4Uy2PrMnB1YwxUPBgQ+iXVU2aSwcu7nLTRiOnZPovooA3y0rwZ7346nNZeKI9G36+hWe6l6Q04JLejiseC7yX65MkxzAOczqVhHnJxhbTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841232; c=relaxed/simple;
	bh=+lweNaZ4IIR/WWP5vkBwcgvSpBh0/05FHECd2rEST0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUXrIF9y2z/tm0SGQE31NUXcn/Hg5yh3oJ7LK3nDZQZsabzjE4t2oQ8AXlRwkCkeAmYGtMBhmHJKYlgQCmqJ1Up3jhqESNmjPSkcp1Oc5YaHYeujUZ2GhmXpJU+A8mavRwEQPGGS258sNFKKhvpwiOYlzNvzeic+Re5rPg6pacU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ftXANzCm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ftXANzCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JCIxb6KxtNgGIni8qVkGyXOpNxUgqN+zGP49XIJbcO4=; b=ftXANzCm1LJpcwaENbP4y31DDi
	ntSqRpGQPeDv7PSeZDzzFM52Z/iBy5NTS1bFHvL9J6Up09bizKQLhAUwuhvpG6f6FxJg6V/H/iSt5
	qwyxWypIr6w20qjwRiZv/Tt6ywzhAzoJtZs+6e8L/Tey3Xenn+2/CKjlh7PFnBYme4Zf09bIaOnoj
	pd01Q7W6LGXWMqnwvKlD6gORLiHKImi00AF7s8s6LlJfbnOy2necdUj7JKA8t+a1PraGCfRRJ3tHX
	Tq+6bKxdzUkdU4ySyeOhqeLK9sD1ZJeEZEnStazX2s5rd6qU5V62mpnwSBSbt4wGSWYUf0haaaYpr
	e9SpAnZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9N3L-001bJb-0u;
	Mon, 28 Apr 2025 19:53:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 19:53:39 +0800
Date: Mon, 28 Apr 2025 19:53:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: sun8i-ce-cipher - fix error handling in
 sun8i_ce_cipher_prepare()
Message-ID: <aA9sQ5p9_wQ2Vmhb@gondor.apana.org.au>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>

On Fri, Apr 25, 2025 at 03:45:14PM +0300, Ovidiu Panait wrote:
> Fix two DMA cleanup issues on the error path in sun8i_ce_cipher_prepare():
> 
> 1] If dma_map_sg() fails for areq->dst, the device driver would try to free
>    DMA memory it has not allocated in the first place. To fix this, on the
>    "theend_sgs" error path, call dma unmap only if the corresponding dma
>    map was successful.
> 
> 2] If the dma_map_single() call for the IV fails, the device driver would
>    try to free an invalid DMA memory address on the "theend_iv" path:
>    ------------[ cut here ]------------
>    DMA-API: sun8i-ce 1904000.crypto: device driver tries to free an invalid DMA memory address
>    WARNING: CPU: 2 PID: 69 at kernel/dma/debug.c:968 check_unmap+0x123c/0x1b90
>    Modules linked in: skcipher_example(O+)
>    CPU: 2 UID: 0 PID: 69 Comm: 1904000.crypto- Tainted: G           O        6.15.0-rc3+ #24 PREEMPT
>    Tainted: [O]=OOT_MODULE
>    Hardware name: OrangePi Zero2 (DT)
>    pc : check_unmap+0x123c/0x1b90
>    lr : check_unmap+0x123c/0x1b90
>    ...
>    Call trace:
>     check_unmap+0x123c/0x1b90 (P)
>     debug_dma_unmap_page+0xac/0xc0
>     dma_unmap_page_attrs+0x1f4/0x5fc
>     sun8i_ce_cipher_do_one+0x1bd4/0x1f40
>     crypto_pump_work+0x334/0x6e0
>     kthread_worker_fn+0x21c/0x438
>     kthread+0x374/0x664
>     ret_from_fork+0x10/0x20
>    ---[ end trace 0000000000000000 ]---
> 
> To fix this, check for !dma_mapping_error() before calling
> dma_unmap_single() on the "theend_iv" path.
> 
> Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
