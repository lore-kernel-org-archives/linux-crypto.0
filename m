Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28C751AFEC;
	Tue, 22 Sep 2026 23:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790118562; cv=none; b=Lrc/RPYJ/kxgie4vfjI1BfJ0e6HGN0GuxD1z/PSePB3TKSCiJpUsZB4+VMpDzvvbyVpX0GAJR1MBzn3BbWLapixCEZVIK2mqXmb6JQaWti5AUvD3ZU6E9MD0zxHAlseKzfh9D1qzNfuTwSPhepQpNX6k9VwUjGCrBewOFrqdJ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790118562; c=relaxed/simple;
	bh=1TOAMxqkO48nfNBJrJSPoy218qnCyaKxgthTx2KtYZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UDfZLsGdvw5XZ97qyFEiRaVcz+Lifo0cuplrNtH7Qoe3dZKJD7/mvs+B1V/WzVJz7PvUgRYPGoUGkbEWmHkY3J066Kc4EVyDMWFIkOsCk1mlTnqRYdvUFgHxnojkR8HZTUsA1SwK1u/2acZtnePNS+608OsPNpLCETiBfwm7VxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n3zp+/j3; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n3zp+/j3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790118560; x=1821654560;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1TOAMxqkO48nfNBJrJSPoy218qnCyaKxgthTx2KtYZE=;
  b=n3zp+/j3fyKvVbWJZ7v/5s868VoU9J5VplcYL3I5HjBdJ7Ypp3gPH7vj
   r6G7/Zsjos7ttVuftx1jokUOzWkUkE3M4p6S8+D7LE4o1Ptcnkf7Au8YS
   jx2IcVvh3QoR5iaRawgXsZe7mu0bVM/voTmkL0rHETgaBziNJ5WIftnsI
   JEfqw5SXx2BITEJRMBa2uSwmtMlcoRx2y/KL4lfDGU9v4MkbphcGp/jMP
   8a9Ow55CgTLadj+4nXXdrCJK+axzfq8XQulRrynALJcuGDF5WELfS/ka8
   zXsZ7hh//MPGkYw3j4JStYnQrl+pB//UJSlMJnanCFcjNEspp8TT0dYZm
   A==;
X-CSE-ConnectionGUID: k0GlXm0XTTKZeyPZrUiS6Q==
X-CSE-MsgGUID: DK7JoJMARyeYlBv6xBoIoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89686411"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="89686411"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:09:19 -0700
X-CSE-ConnectionGUID: 4U5aPbVoQqmx97Dc4s1tUQ==
X-CSE-MsgGUID: zzMGiacpS9mQiph3S0ldXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="4634624"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.110.50]) ([10.125.110.50])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:09:18 -0700
Message-ID: <b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com>
Date: Tue, 22 Sep 2026 16:09:16 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dmaengine: change dmaengine_get_unmap_data() first
 arg to dma_chan
To: Frank.Li@oss.nxp.com, Dan Williams <djbw@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
 Frank Li <Frank.Li@kernel.org>, Jon Mason <jdmason@kudzu.us>,
 Allen Hubbe <allenbh@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Eric Biggers
 <ebiggers@kernel.org>, "open list:CRYPTO API"
 <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM"
 <dmaengine@vger.kernel.org>, "open list:NTB DRIVER CORE"
 <ntb@lists.linux.dev>
Cc: imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>
References: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/22/26 11:45 AM, Frank.Li@oss.nxp.com wrote:
> From: Frank Li <Frank.Li@nxp.com>
> 
> Replace the struct device *dev argument with struct dma_chan *chan so
> callers do not need to reach into the dma_device internals to obtain
> the device pointer.  The implementation now derives the device via
> dmaengine_get_dma_device(chan), which correctly handles the per-channel
> IOMMU mapping case.
> 
> Prepare to make dma_device private and make dmaengine API consistent.
> 
> Signed-off-by: Frank Li <Frank.Li@nxp.com>

For the NTB bits:
Acked-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  crypto/async_tx/async_memcpy.c      | 4 ++--
>  crypto/async_tx/async_pq.c          | 4 ++--
>  crypto/async_tx/async_raid6_recov.c | 4 ++--
>  crypto/async_tx/async_xor.c         | 8 ++++----

Maybe one day Dan's wishes will become true and someone will finally deprecate async_tx....

DJ>  drivers/dma/dmaengine.c             | 4 ++--
>  drivers/dma/dmatest.c               | 2 +-
>  drivers/dma/mv_xor.c                | 4 ++--
>  drivers/ntb/ntb_transport.c         | 4 ++--
>  drivers/ntb/test/ntb_perf.c         | 2 +-
>  include/linux/dmaengine.h           | 4 ++--
>  10 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
> index 323152c89b3a1..d03e9a9bc1e2d 100644
> --- a/crypto/async_tx/async_memcpy.c
> +++ b/crypto/async_tx/async_memcpy.c
> @@ -39,8 +39,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
>  	struct dma_async_tx_descriptor *tx = NULL;
>  	struct dmaengine_unmap_data *unmap = NULL;
>  
> -	if (device)
> -		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOWAIT);
> +	if (chan)
> +		unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
>  
>  	if (unmap && dmaengine_is_copy_aligned(chan, src_offset, dest_offset, len)) {
>  		unsigned long dma_prep_flags = 0;
> diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
> index fcc8d9ebc0fec..6a31271852cd4 100644
> --- a/crypto/async_tx/async_pq.c
> +++ b/crypto/async_tx/async_pq.c
> @@ -188,7 +188,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
>  	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
>  
>  	if (device)
> -		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
> +		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
>  
>  	/* XORing P/Q is only implemented in software */
>  	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
> @@ -310,7 +310,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
>  	BUG_ON(disks < 4 || disks > MAX_DISKS);
>  
>  	if (device)
> -		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
> +		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
>  
>  	if (unmap && disks <= dma_maxpq(device, 0) &&
>  	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
> diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
> index 27909afda694a..5055531145bd2 100644
> --- a/crypto/async_tx/async_raid6_recov.c
> +++ b/crypto/async_tx/async_raid6_recov.c
> @@ -29,7 +29,7 @@ async_sum_product(struct page *dest, unsigned int d_off,
>  	u8 *a, *b, *c;
>  
>  	if (dma)
> -		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
> +		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
>  
>  	if (unmap) {
>  		struct device *dev = dma->dev;
> @@ -97,7 +97,7 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
>  	u8 *d, *s;
>  
>  	if (dma)
> -		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
> +		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
>  
>  	if (unmap) {
>  		dma_addr_t dma_dest[2];
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 4ed9d3196fc46..9ed331d9b8e64 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -178,8 +178,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
>  
>  	BUG_ON(src_cnt <= 1);
>  
> -	if (device)
> -		unmap = dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOWAIT);
> +	if (chan)
> +		unmap = dmaengine_get_unmap_data(chan, src_cnt + 1, GFP_NOWAIT);
>  
>  	if (unmap && dma_xor_aligned_offsets(chan, offset, src_offs,
>  					     src_cnt, len)) {
> @@ -310,8 +310,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
>  
>  	BUG_ON(src_cnt <= 1);
>  
> -	if (device)
> -		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOWAIT);
> +	if (chan)
> +		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
>  
>  	if (unmap && src_cnt <= device->max_xor &&
>  	    dma_xor_aligned_offsets(chan, offset, src_offs, src_cnt, len)) {
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index cc1c0a7c9f33d..4585ebcd2e8cd 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -1474,7 +1474,7 @@ static int __init dmaengine_init_unmap_pool(void)
>  }
>  
>  struct dmaengine_unmap_data *
> -dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
> +dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags)
>  {
>  	struct dmaengine_unmap_data *unmap;
>  
> @@ -1484,7 +1484,7 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
>  
>  	memset(unmap, 0, sizeof(*unmap));
>  	kref_init(&unmap->kref);
> -	unmap->dev = dev;
> +	unmap->dev = dmaengine_get_dma_device(chan);
>  	unmap->map_cnt = nr;
>  
>  	return unmap;
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 2ae3469397f37..043bb065dd68a 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -748,7 +748,7 @@ static int dmatest_func(void *data)
>  			filltime = ktime_add(filltime, diff);
>  		}
>  
> -		um = dmaengine_get_unmap_data(dma_dev, src->cnt + dst->cnt,
> +		um = dmaengine_get_unmap_data(chan, src->cnt + dst->cnt,
>  					      GFP_KERNEL);
>  		if (!um) {
>  			failed_tests++;
> diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
> index c4e0dce3ca64e..dec01b6264d7a 100644
> --- a/drivers/dma/mv_xor.c
> +++ b/drivers/dma/mv_xor.c
> @@ -794,7 +794,7 @@ static int mv_chan_memcpy_self_test(struct mv_xor_chan *mv_chan)
>  		goto out;
>  	}
>  
> -	unmap = dmaengine_get_unmap_data(dma_chan->device->dev, 2, GFP_KERNEL);
> +	unmap = dmaengine_get_unmap_data(dma_chan, 2, GFP_KERNEL);
>  	if (!unmap) {
>  		err = -ENOMEM;
>  		goto free_resources;
> @@ -927,7 +927,7 @@ mv_chan_xor_self_test(struct mv_xor_chan *mv_chan)
>  		goto out;
>  	}
>  
> -	unmap = dmaengine_get_unmap_data(dma_chan->device->dev, src_count + 1,
> +	unmap = dmaengine_get_unmap_data(dma_chan, src_count + 1,
>  					 GFP_KERNEL);
>  	if (!unmap) {
>  		err = -ENOMEM;
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index b8f8b333b89eb..e9e1506df71d6 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -1532,7 +1532,7 @@ static int ntb_async_rx_submit(struct ntb_queue_entry *entry, void *offset)
>  	if (!dmaengine_is_copy_aligned(chan, pay_off, buff_off, len))
>  		goto err;
>  
> -	unmap = dmaengine_get_unmap_data(dma_dev, 2, GFP_NOWAIT);
> +	unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
>  	if (!unmap)
>  		goto err;
>  
> @@ -1871,7 +1871,7 @@ static int ntb_async_tx_submit(struct ntb_transport_qp *qp,
>  	if (!dmaengine_is_copy_aligned(chan, buff_off, dest_off, len))
>  		goto err;
>  
> -	unmap = dmaengine_get_unmap_data(dma_dev, 1, GFP_NOWAIT);
> +	unmap = dmaengine_get_unmap_data(chan, 1, GFP_NOWAIT);
>  	if (!unmap)
>  		goto err;
>  
> diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
> index 774e643c9f4c6..1cb991e2f0cf7 100644
> --- a/drivers/ntb/test/ntb_perf.c
> +++ b/drivers/ntb/test/ntb_perf.c
> @@ -809,7 +809,7 @@ static int perf_copy_chunk(struct perf_thread *pthr,
>  	dst_vaddr = dst;
>  	dst_dma_addr = peer->dma_dst_addr + (dst_vaddr - vbase);
>  
> -	unmap = dmaengine_get_unmap_data(dma_dev, 1, GFP_NOWAIT);
> +	unmap = dmaengine_get_unmap_data(pthr->dma_chan, 1, GFP_NOWAIT);
>  	if (!unmap)
>  		return -ENOMEM;
>  
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index fc661e76de84d..c8ecf80288f13 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -656,7 +656,7 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
>  }
>  
>  struct dmaengine_unmap_data *
> -dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
> +dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags);
>  void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
>  #else
>  static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
> @@ -664,7 +664,7 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
>  {
>  }
>  static inline struct dmaengine_unmap_data *
> -dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
> +dmaengine_get_unmap_data(struct dma_chan *chan, int nr, gfp_t flags)
>  {
>  	return NULL;
>  }

