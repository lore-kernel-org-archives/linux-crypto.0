Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADECF43DA55
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 12:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783513080; cv=none; b=n6Rb+wnIGf9x58cigYJubGLq96llmSby2DUsJXctOE3Oyb5kS4ErWBd4YzwKmDIe+ONheoRnHcCz82wb6U1orNQ7e52n7CWZHHtw3Uk/BNdgK+pQ0mXhUpterPOMeuW2/GMxn6MCMKdkWNfJaZyfuiPcehVmmqSnrG72rikKRZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783513080; c=relaxed/simple;
	bh=gt1sheQIviRHfIj/UZc8opTwHEugzb9D3v4q5g0GNME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvixJHCXaLIO7n4epN4shgWs7NKu1e3pZW9Fd8aNhsN8UoVG/lYZNnPUH3/mJL2z4UdumwZ8hwPxx/S6pjzJTFJuQ81P9Z+Wp6AlNeqp1FOU+rMbpqhnm1vMi1xh71hhH1levBRwH2yjmg4AO9GctD99E2Bn7spKNOZ0zy6qrZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n1lJiYVk; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n1lJiYVk"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47de0093c42so623214f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 05:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1783513076; x=1784117876; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1ulKrnpD8tXDSCpSxwsbsqYNUR8mY4krEK4ViHq+duU=;
        b=n1lJiYVkfNgEzxvugVKuV0yrOwRSSL60Uw1HXTySn9I0pM0k/yKAoz6FY61xt9aH+R
         Nah/tucx9fFgg4QKbe3uYLba8p3JXzXo69B/5KVZdUcHRQypb4bsUO+dT0NMK/NrY0vM
         powvW+2IQ+VvQ4dtjfw6AiXi+F0Jq/oFkE2YYrA9wqbXT4JvJT7G19d1KOqmHWBxuFY2
         bA3nk1U/IEmDS8e54HIxJjlUpBcwcc2d0bILPG+2qpY+5pWXGStVv3ar5e+Z/N3AleJM
         hyprtPNl0Pog4xNY1/2WdzWyuoYjy2rlNZ+mv66MBNSxspU35ZNs94MyY4OFcFS6nt3c
         UetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783513076; x=1784117876;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ulKrnpD8tXDSCpSxwsbsqYNUR8mY4krEK4ViHq+duU=;
        b=fsFFoB+g5nfXCUPbHzMl28sfM/R1OvQExf2NaKgkh0pu0tC9v0es/+HiMk+TdEl0cd
         BZdFTMNxX9S0+wPQVGVOX6YeqM3SOvwIdpJw57uYPlEyZZg18m6arGp8pxzD1FqLLmZ+
         VsZC6jUf/vfjPJ8LVCIQylJKi0vvFvaHS9zHgIFSSF+nGcIGbVqTMm5iM+G3+h9ojKGl
         d3I3Gq1q8xXPLwy0JwPACii+3cWoP0jX38gA83pJJfnHAfNg2xyEDhBAQxtRuG08I/Yj
         ZU4ev9P/ob4xsKem8JavCWQ0P9eoHkf2lqjMLFnKHIV08xkXylnsPYyCDhbBCqESgEcx
         +A9w==
X-Forwarded-Encrypted: i=1; AHgh+RokaeeslFbCSTyDE7bVLoUrhWmdtCP7iIa4h52mEZ9PbHJ3n+srOUsRWyWUoTa83vwB8DtFo6E+7YEJ8bI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMtXVdT7xrmuOb6ItuRmU8JD+3CBDVRtQeF3lIRtT+dzrNq2Kg
	BrSxLKws48aZA2yV2qKfUtfKgAuTkMfYN4tpRnWNruVyp3g7sOPieaL8fpw+SzA2SSQ=
X-Gm-Gg: AfdE7cm+gW4OfkuW0KwTlzxUQ+jSFHtERL6NM4OTplI7LPUyHEa3qZYmFXDRIGv1/oz
	RSxzMl+k6KScl6SCGNXie/v2P8+/InxB5HS3Qb7NYqaEEiFGAhgUPK3nETj40xwFeyAo7fkHT0d
	IdWYfPLdCWgVmrav71+FDEhsDCslrnd+dOz0w+m0K2919j0eXnTWaytcp+L7Qt/qeP4+R7W95Ff
	Fp02xtkB1Nz7xM73HC4mYfvVkdDGLVmZQoprJeAYtJHQY/6syFA0kF9lSFnFKGtNL70rw4gZ9ur
	ao0N2tSB4g3T/Q4o4OQqbZV3md+y6O2LbMBEahOzRFizzDIhBv7NeL0Rl7kx4uacbvrsUlKPIml
	227EhUn6+sycjRAJRbYDasDkRFBHol9DHgb0+7UanTjOB0g+C7w9VxobEFmDmv1cyDFz4xetc7k
	neqq0Nu3MySqJOpP8OGEjP44/4
X-Received: by 2002:a05:6000:40cc:b0:47d:ede0:f8ff with SMTP id ffacd0b85a97d-47df073b1a4mr2646073f8f.9.1783513076033;
        Wed, 08 Jul 2026 05:17:56 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:28ff:335b:63e2:fdd2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ad69519c2sm45642623f8f.37.2026.07.08.05.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 05:17:55 -0700 (PDT)
Date: Wed, 8 Jul 2026 14:17:51 +0200
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	Andy Gross <agross@codeaurora.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	brgl@kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v20 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <ak4_vsdef9MJd1Yv@linaro.org>
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
 <20260629-qcom-qce-cmd-descr-v20-6-56f67da84c05@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629-qcom-qce-cmd-descr-v20-6-56f67da84c05@oss.qualcomm.com>

On Mon, Jun 29, 2026 at 12:01:08PM +0200, Bartosz Golaszewski wrote:
> Add support for BAM pipe locking. To that end: when starting DMA on an RX
> channel - prepend the existing queue of issued descriptors with an
> additional "dummy" command descriptor with the LOCK bit set. Once the
> transaction is done (no more issued descriptors), issue one more dummy
> descriptor with the UNLOCK bit.
> 
> We *must* wait until the transaction is signalled as done because we
> must not perform any writes into config registers while the engine is
> busy.
> 
> The dummy writes must be issued into a scratchpad register of the client
> so provide a mechanism to communicate the right address via descriptor
> metadata.
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

I finally found the time to try this for the qcom_nandc driver on
MDM9607 (with scratchpad_addr = nandc->base_phys + NAND_VERSION). It
seems to work fine and my initial impression is that it does solve the
crashes/corruption when both Linux and the modem access the NAND in
parallel. (Hard to reproduce, needs a bit more testing.) Thanks!

It feels a bit awkward to call dmaengine_desc_attach_metadata() with the
same scratchpad_addr for every descriptor (especially because you store
it globally), but I also don't really have a better idea how to pass the
address for the dummy register.

> ---
>  drivers/dma/qcom/bam_dma.c       | 189 +++++++++++++++++++++++++++++++++++++--
>  include/linux/dma/qcom_bam_dma.h |  14 +++
>  2 files changed, 196 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index f3e713a5259c2c7c24cfdcec094814eb1202971a..f4f258994264a234f60debd3e66e31a6b35d1dc5 100644
> --- a/drivers/dma/qcom/bam_dma.c
> +++ b/drivers/dma/qcom/bam_dma.c
> [...]
> @@ -919,13 +977,23 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>  			 * push back to front of desc_issued so that
>  			 * it gets restarted by the work queue.
>  			 */
> +
> +			list_del(&async_desc->desc_node);
>  			if (!async_desc->num_desc) {
> -				vchan_cookie_complete(&async_desc->vd);
> +				struct bam_desc_hw *hdesc = async_desc->desc;
> +				u16 flags = le16_to_cpu(hdesc->flags);
> +
> +				if (flags & (DESC_FLAG_LOCK | DESC_FLAG_UNLOCK)) {
> +					if (flags & DESC_FLAG_UNLOCK)
> +						bchan->bam_locked = false;
> +					bam_dma_free_lock_desc(&async_desc->vd);
> +				} else {
> +					vchan_cookie_complete(&async_desc->vd);
> +				}
>  			} else {
>  				list_add(&async_desc->vd.node,
>  					 &bchan->vc.desc_issued);
>  			}
> -			list_del(&async_desc->desc_node);
>  		}
>  	}
>  
> [...]
> @@ -1064,9 +1220,23 @@ static void bam_start_dma(struct bam_chan *bchan)
>  
>  	lockdep_assert_held(&bchan->vc.lock);
>  
> +	vd = vchan_next_desc(&bchan->vc);
>  	if (!vd)
>  		return;
>  
> +	/*
> +	 * Wrap the issued work with a LOCK/UNLOCK pair exactly once, at the
> +	 * start of a fresh sequence and only when there is real work to lock
> +	 * around. On a re-entry after a full FIFO, we see the BAM is locked
> +	 * and must not add another pair we simply continue loading the
> +	 * remainder of the same locked sequence.
> +	 */
> +	if (!bchan->bam_locked) {
> +		ret = bam_setup_pipe_lock(bchan);
> +		if (ret == 0 && bchan->bam_locked)
> +			vd = vchan_next_desc(&bchan->vc);
> +	}

I *suspect* though that Sashiko is right about the new race condition
here if new descriptors are queued while the hardware is busy processing
a locked sequence.

https://sashiko.dev/#/patchset/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05%40oss.qualcomm.com?part=6

Any idea how to fix this?

Thanks,
Stephan
