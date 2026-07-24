Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E505395243
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 12:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897557; cv=none; b=hPruyBVxjpFxM5KvLKkTyTu36corADPdJFXK8MjnDgTE0etmtvmfIGv9GeAabBSGuoGX+bZdUDOMGZcG3PWQUdPDQTOKK1Hg+OTGZcpgyUpUQkqHqDHF25TiqknHidXCm42wPMQL9OBONctpSyGzV75UM2FIkfOQz/HPVI7JKe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897557; c=relaxed/simple;
	bh=qlJA9/DIwLTOal1LH4qMNzHESvTfeFf3a5zLYfiBOvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dl7FRxblBQojrmt9+HqczlyIbmaVGHYLTcguFr0/r4m/Cpop8GnzCG5EKrkpNrAHjjZuZg6XxKqX97io6K+ml+M/ddyNYrrTrS7vTAKo01+hjltN+B5hOUZcNEXjSNF2yMRjeHR3cd2vh7fT94n9bvdXB4AO6ofq2HuZVYtGEdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KKBqLPEd; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KKBqLPEd"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso2503465e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 05:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784897552; x=1785502352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rtN44z1BuwvvFd9UHNBpsGREUSMEsEWybwxiKcauHzU=;
        b=KKBqLPEdP9JGycRByu5RZFxC6mHjtSlz/zbpiYV+eEVMKroIGbnHsSFb0VHprmIEkQ
         eVutXpwLHLjFrJl1hpuoWdoQydB+oJXoqx0cA2pXyU2vi1T0xRdhAzBTrNXG+jyuqxhi
         A8AQ2l0CL1q0ULAWYm8Vib4KHwZ6e7k0l3DduZ1qbEe8oOoNKVlIEx5mTVfiExvVNke3
         QGU3OojP0U3BTpGdzwE26iLd+vCwQfLdb0kHtziGTE1yN0GscNlzIR/ir1h/iSqzWPt6
         gNnQPnADKsscdBh5POcXA71piRU5YICXtHw6llkv0ztA/Xzg5urBLV7LEAymamVuRUA2
         kgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784897552; x=1785502352;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rtN44z1BuwvvFd9UHNBpsGREUSMEsEWybwxiKcauHzU=;
        b=KeHdl51bqIMqry/tBNVzgu0K1bXlQN7FvCEjYhRyozdx+5cp7dSh6bZAUa0XlZkoVS
         vs9OAQFcPHw03mwKwbF50CGznXZH0UtHVFIOmDcXDqE9htagu6vs6Tk2nx0mq2uHn/jB
         8cg1T2EPfagu520N4wIym5wP+wv6qYHRP784oWOgZTJvrQ8l0YwT1/6vi4iH4PTcA9ln
         yt9igk0uSodDh6QE2wjAxp/YNLIzOlYMU6gXGV3LbCi9nbdxNGaPpkDBpdooy+K38M+l
         uPhkFvYHieOE2f3ElZ8TZK0wEIKWzLtC6CpszKVCOPZ4WjwgTp2oSrq5Cas43otqA7cG
         JZVA==
X-Forwarded-Encrypted: i=1; AHgh+RobaoD/xjuEN8zUb+vVXXS3bd9rTt+7EKNVIuEdaxcJtsKbM5Bm+NnL04d5NWCCtASN26fFkVe3QsX69TQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSVRDM0/c0Lq9hG4Vz5WXIiS8TQZX8jevXlhNq2SsPjIlWq/sm
	z5d7IJ0P4vI2sYcfr0Ra97osbI2XU/MBPxD6ElCsm8tduIstG7UzbWYj0Rh6+aXacQ8=
X-Gm-Gg: AR+sD124mHx/YNF1D8jIYpPLQ0mHAMqlKoDtifX/is/5QbWVqJzdzPcUMecELgYl0+4
	y30akvb/zmkWFT3f6QLAi3xb5EZBORK+ieLe8IGnPeJs9fHM0vstfHK9ogHpcWvFvP3bGFWbWZh
	XBG2HyZw97vkHjHm5Z9fKQY22x+Uq+Y4FFe/8o210Tky8LTgxn9tyhjUCRp/xmBItmOwxCeCf1v
	EHlr9hxWPUgb8dLBF/Zfmv8FbogRn5i1vs0yl5CKNrm0qH/UpeKDShyGNpCRUQ5EveoVEQAgBkh
	G+1TAwckXVcuWhSESXtV183hwhf9UkruQUMliD6RB8zqVfV8RpA86mEvSI7G1O1piNunazcHWWS
	H64S/CgSqDnse5JJJxPlEgbNGjh+9QGAXiwE760dECmXX6OehIoEgM14D4jGDoj0LveKrziC0Gm
	APcWJ8AupqUfaOCg==
X-Received: by 2002:a05:600d:8444:10b0:495:5845:fb2 with SMTP id 5b1f17b1804b1-49573cfa980mr62663925e9.38.1784897552342;
        Fri, 24 Jul 2026 05:52:32 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:d8e1:da6c:62ef:6ff9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957af78a02sm67574155e9.7.2026.07.24.05.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 05:52:31 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:52:27 +0200
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
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vignesh Raghavendra <vigneshr@ti.com>, dmaengine@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, brgl@kernel.org
Subject: Re: [PATCH v24 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <amNf-bljjasmTKn_@linaro.org>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
 <20260723-qcom-qce-cmd-descr-v24-6-4f87bb4d9938@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723-qcom-qce-cmd-descr-v24-6-4f87bb4d9938@oss.qualcomm.com>

On Thu, Jul 23, 2026 at 07:09:12PM +0200, Bartosz Golaszewski wrote:
> Add support for BAM pipe locking. To that end: when starting DMA on a TX
> channel (DMA_MEM_TO_DEV) - prepend the existing queue of issued
> descriptors with an additional "dummy" command descriptor with the LOCK
> bit set. Once the transaction is done (no more issued descriptors),
> issue one more dummy descriptor with the UNLOCK bit.
> 
> We *must* wait until the transaction is signalled as done because we
> must not perform any writes into config registers while the engine is
> busy.
> 
> The dummy writes must be issued into a scratchpad register of the client
> so provide a mechanism to communicate the right address via slave
> config.
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> [Stephan: came up with the solution to write lock/unlock descriptors
> directly into the FIFO]
> Co-developed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
> Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  drivers/dma/qcom/bam_dma.c       | 146 ++++++++++++++++++++++++++++++++++-----
>  include/linux/dma/qcom_bam_dma.h |  13 ++++
>  2 files changed, 142 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index f3e713a5259c2c7c24cfdcec094814eb1202971a..373569c36a94e149d54ef041974b11018e634669 100644
> --- a/drivers/dma/qcom/bam_dma.c
> +++ b/drivers/dma/qcom/bam_dma.c
> [...]
> @@ -676,10 +697,51 @@ static void bam_free_chan(struct dma_chan *chan)
>  static int bam_slave_config(struct dma_chan *chan,
>  			    struct dma_slave_config *cfg)
>  {
> +	struct bam_config *peripheral_cfg = cfg->peripheral_config;
>  	struct bam_chan *bchan = to_bam_chan(chan);
> +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
> +
> +	if (peripheral_cfg && cfg->peripheral_size != sizeof(*peripheral_cfg))
> +		return -EINVAL;
>  
>  	guard(spinlock_irqsave)(&bchan->vc.lock);
>  
> +	/*
> +	 * This is required to setup the pipe locking and must be done even
> +	 * before the first call to bam_start_dma().
> +	 */
> +	if (bdata->pipe_lock_supported && peripheral_cfg) {
> +		if (cfg->direction != DMA_MEM_TO_DEV)
> +			return -EINVAL;
> +
> +		if (bchan->bam_locked)
> +			return -EBUSY;
> +
> +		if (!bchan->lock_ce) {
> +			bchan->lock_ce = kmalloc_obj(*bchan->lock_ce, GFP_ATOMIC);
> +			if (!bchan->lock_ce)
> +				return -ENOMEM;
> +
> +			bchan->lock_ce_phys = dma_map_single(bchan->bdev->dev, bchan->lock_ce,
> +							     sizeof(*bchan->lock_ce),
> +							     DMA_TO_DEVICE);
> +			if (dma_mapping_error(bchan->bdev->dev, bchan->lock_ce_phys)) {
> +				kfree(bchan->lock_ce);
> +				bchan->lock_ce = NULL;
> +				return -ENOMEM;
> +			}
> +		}
> +
> +		bam_prep_ce_le32(bchan->lock_ce, peripheral_cfg->lock_scratchpad_addr,
> +				 BAM_WRITE_COMMAND, 0);
> +		dma_sync_single_for_device(bchan->bdev->dev, bchan->lock_ce_phys,
> +					   sizeof(*bchan->lock_ce), DMA_TO_DEVICE);

Nitpick: The sync is redundant if you just called dma_map_single()
above. It doesn't hurt to sync again for the one-time setup though.

> +		bchan->locking_enabled = true;
> +	} else {
> +		/* Don't touch lock_ce here, it might still be used by issued descriptors */
> +		bchan->locking_enabled = false;
> +	}
> +
>  	memcpy(&bchan->slave, cfg, sizeof(*cfg));
>  	bchan->reconfigure = 1;
>  
> @@ -802,6 +864,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
>  		}
>  
>  		vchan_get_all_descriptors(&bchan->vc, &head);
> +		bchan->bam_locked = false;
>  	}

I think this needs some more thought. I put this assignment into
bam_reset_channel(), because presumably that's the only operation that
would really reset the lock status without processing an unlock
descriptor.

bam_dma_terminate_all() does not always reset the BAM channel. It does
that only if (!list_empty(&bchan->desc_list)) {
	bam_chan_init_hw(bchan, async_desc->dir);
}

I _think_ it is possible that we have no in-flight descriptors
(bchan->desc_list), but the unlock is still pending (or not even written
to the FIFO yet). In that case, bchan->bam_locked should not be reset
here.

I would put the bchan->bam_locked = false; into bam_reset_channel() like
in my diff.

Then, you could either leave this as-is (and assume the unlock
descriptor will still be finished/written even after cancelling the
descriptors).

Or, you add some more checks to this if statement to reset the BAM. This
could work I think:

	if (!list_empty(&bchan->desc_list)) {
		async_desc = list_first_entry(&bchan->desc_list,
					      struct bam_async_desc, desc_node);
		bam_chan_init_hw(bchan, async_desc->dir);
	} else if (bchan->bam_locked || bchan->head != bchan->tail) {
		/* BAM still locked or unlock still pending */
		bam_chan_init_hw(bchan, DMA_MEM_TO_DEV);
	}

Unfortunately, bchan->bam_locked alone doesn't tell us if the BAM is
locked, only if we haven't written the UNLOCK descriptor yet. It may be
pending in the FIFO. head != tail should tell us that the FIFO is not
empty (which should be the UNLOCK descriptor if desc_list is empty)...

>  
>  	vchan_dma_desc_free_list(&bchan->vc, &head);
> @@ -869,7 +932,7 @@ static int bam_resume(struct dma_chan *chan)
>  static u32 process_channel_irqs(struct bam_device *bdev)
>  {
>  	u32 i, srcs, pipe_stts, offset, avail;
> -	struct bam_async_desc *async_desc, *tmp;
> +	struct bam_async_desc *async_desc;
>  
>  	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
>  
> [...]
> @@ -919,13 +991,12 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>  			 * push back to front of desc_issued so that
>  			 * it gets restarted by the work queue.
>  			 */
> -			if (!async_desc->num_desc) {
> +			list_del(&async_desc->desc_node);
> +			if (!async_desc->num_desc)
>  				vchan_cookie_complete(&async_desc->vd);
> -			} else {
> +			else
>  				list_add(&async_desc->vd.node,
>  					 &bchan->vc.desc_issued);
> -			}
> -			list_del(&async_desc->desc_node);
>  		}

I think this is an unneeded/unrelated formatting change now. Drop?

>  	}
>  
> [...]
>  /**
>   * bam_start_dma - start next transaction
>   * @bchan: bam dma channel
>   */
>  static void bam_start_dma(struct bam_chan *bchan)
>  {
> -	struct virt_dma_desc *vd = vchan_next_desc(&bchan->vc);
> +	struct virt_dma_desc *vd;
>  	struct bam_device *bdev = bchan->bdev;
>  	struct bam_async_desc *async_desc = NULL;
>  	struct bam_desc_hw *desc;
> @@ -1064,22 +1145,34 @@ static void bam_start_dma(struct bam_chan *bchan)
>  
>  	lockdep_assert_held(&bchan->vc.lock);
>  
> -	if (!vd)
> +	vd = vchan_next_desc(&bchan->vc);
> +	if (IS_BUSY(bchan) || (!vd && !bchan->bam_locked))
>  		return;
>  
>  	ret = pm_runtime_get_sync(bdev->dev);
>  	if (ret < 0)
>  		return;
>  
> +	if (!bchan->initialized)
> +		bam_chan_init_hw(bchan, container_of(vd, struct bam_async_desc, vd)->dir);

Okay yeah, that was my bug. Thanks for moving it :-)

> +
> +	if (bchan->locking_enabled && !bchan->bam_locked) {
> +		/* Defer locking until we also have space for a data descriptor */
> +		avail = CIRC_SPACE(bchan->tail, bchan->head, MAX_DESCRIPTORS + 1);
> +		if (avail < 2) {
> +			queue_work(system_bh_highpri_wq, &bdev->work);
> +			goto out;
> +		}
> +
> +		bam_fifo_write_lock(bchan, DESC_FLAG_LOCK);
> +		bchan->bam_locked = true;
> +	}
> +
>  	while (vd && !IS_BUSY(bchan)) {
>  		list_del(&vd->node);
>  
>  		async_desc = container_of(vd, struct bam_async_desc, vd);
>  
> -		/* on first use, initialize the channel hardware */
> -		if (!bchan->initialized)
> -			bam_chan_init_hw(bchan, async_desc->dir);
> -
>  		/* apply new slave config changes, if necessary */
>  		if (bchan->reconfigure)
>  			bam_apply_new_config(bchan, async_desc->dir);
> @@ -1135,11 +1228,24 @@ static void bam_start_dma(struct bam_chan *bchan)
>  		list_add_tail(&async_desc->desc_node, &bchan->desc_list);
>  	}
>  
> +	/*
> +	 * Close the bracket once there is no more client work queued. The
> +	 * UNLOCK is flagged for an interrupt so process_channel_irqs() is
> +	 * guaranteed to observe its completion and retire it from the FIFO
> +	 * promptly, instead of leaving bchan->head to lag until a later
> +	 * bracket's skip-loop catches up with it.
> +	 */

Fair enough, I was a bit lazy here and omitted the DESC_FLAG_INT. It
should help with the head!=tail check I mentioned for
bam_dma_terminate_all() though.

> +	if (bchan->bam_locked && !vd && !IS_BUSY(bchan)) {
> +		bam_fifo_write_lock(bchan, DESC_FLAG_UNLOCK | DESC_FLAG_INT);
> +		bchan->bam_locked = false;
> +	}
> +
>  	/* ensure descriptor writes and dma start not reordered */
>  	wmb();
>  	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
>  			bam_addr(bdev, bchan->id, BAM_P_EVNT_REG));
>  
> +out:
>  	pm_runtime_mark_last_busy(bdev->dev);
>  	pm_runtime_put_autosuspend(bdev->dev);
>  }
> @@ -1162,7 +1268,13 @@ static void bam_dma_work(struct work_struct *work)
>  
>  		guard(spinlock_irqsave)(&bchan->vc.lock);
>  
> -		if (!list_empty(&bchan->vc.desc_issued) && !IS_BUSY(bchan))
> +		/*
> +		 * A channel also needs kicking if a bracket is still open
> +		 * (bam_locked) with no further client work queued: closing
> +		 * the UNLOCK requires a fresh call into bam_start_dma().
> +		 */
> +		if ((!list_empty(&bchan->vc.desc_issued) || bchan->bam_locked) &&
> +		    !IS_BUSY(bchan))
>  			bam_start_dma(bchan);

The if statement is redundant, bam_start_dma() now checks all of that
internally. 

	if (IS_BUSY(bchan) || (!vd && !bchan->bam_locked))
		return;

list_empty(desc_issed) == !vd

Same for !IS_BUSY() in bam_issue_pending().

Thanks,
Stephan
