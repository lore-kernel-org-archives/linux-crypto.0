Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC0427F8B
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 10:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890431; cv=none; b=Cg2nrRQNLabh/b7atrUYe/D48bNqeILRqLqD03jNbW7XtZgASIadFXhn/tR7+vfNbuSGFznnCzom6KcejkArKemDXMHKo6b1t1d7ATIBkTSsGBNVn0I7g+cm0SluX9tU8x47QEW6Bdq6OfVPbja4Sb/ceQ63yz5WPIq1er+XJpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890431; c=relaxed/simple;
	bh=2Id8Lf7l9nSqlQQ3kJj2nmTWJEwu65vgbgq0B4au8sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scTmvzrAhqg32juJMv14YqCWsxElPFhlY7Xyk0UAT48+zeVBQCDtsUBwRN8S76eKOdCtk+0miysuNUpamYoWkMe6r353tQdBOp7vKcihWb5qc65Y1j1U7GvH8cQXlvnchm5LIoFn/UNLylOrYSJsHipZT1F4wuho05T0MC4Sss4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q2XKA4pc; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q2XKA4pc"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso210061f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 03:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784890428; x=1785495228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9qGNYqgu45iCzPUDN1sRc/iOGDzLiyCE7X0FhGMvUzY=;
        b=Q2XKA4pcoFE0/oewMrGycoNNC4PVtJI3YgBQm7O2y+RxaGCYV9Gvkr6ppuUF/C2jTw
         xJqbhcW5qbSXSEe32kG/Ijo+SNvAsJro3R+zEdv7Ob8FPhDfjA+5BUv4pDglvxxoUOTm
         A+a6kLKBGYP1PE/wgmBjBmQ3KTQinKigH4wUQjTLaCKouzV8/Ccxy0DLWkFgFCXQlPvv
         z/roC2b/3ndSZ4qbcmIRZ9w/Vp07rho4xjJ2Bj33s5DMGD2dBQtJmF3EYU9Sctn3oMYT
         KUehfiKlwEv3nsh9Zx3wshRRZy9HT85pmN00ySfZMlQ4WxvjJIVNSHNPiVt1c/eKsRU0
         bWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784890428; x=1785495228;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9qGNYqgu45iCzPUDN1sRc/iOGDzLiyCE7X0FhGMvUzY=;
        b=ROti0YAHat1yndV+ZNVmhtnVVrjKwWFdayaKg0W5xbohVf5aFTrlyZvrthrIgFlTJ4
         YqlfrSWXYm8Cuu8g85/lOEG5QjN8osH+OS5u34xFT+EnJOQfpNDQL2ylBo7d0xFRISJi
         EZkrZkzJhE3pPFXBCGzBTxyQy2Ui0Gqc4tMg6cJNyln9inMCDXKPJ8VMTpCErYL0LmOB
         fYmYOHublkhxtHf6783rleljfYvcid05wbcR8t2vL0WqVtitq8HDxXOzoIkFEPFUVw5D
         V0bCut/WNhNpLeqraLS2ziCMMmRTIqofu3p6BWDxWFx2DydIJOrCsuYUuAgHPDuQTAuX
         WZJA==
X-Forwarded-Encrypted: i=1; AHgh+RpFCRMTw+T7QafPXnkQVRxNKTUrDqIFzxFs0drHBxNbHWzAy6aHqN1M5Ga8y9jKFrkI+lTHtiFgHiCPZXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxW4bEqBVTZ3KnfbuYHLHbdm2aaf43cHn9uJ+L5eG5vFv8OAzZ
	rFglspXQPzHSrQJl6+bYYjp5lZlv8VpEP4OLbyL4oWaMYrsEsQmzqYDvSJmJlvcHpbk=
X-Gm-Gg: AR+sD11QDOuA2xi56L7hdj8Dwkq44VWE5pe4SuqVtvICQ97pnklHm7IL1O+io1R33jZ
	fw8AkL0VXKBy1vsH62eZTQlqXRqkJag9uf9HUrjeRrtAUNCm/BMKwKcaXKApW4F3tRS6NIdHjt2
	+DWIZ4UTIkBilqT1jHAId+4RGAGsI6cjCD+aNuVZfjH8rxlT98X6Y3mfLPuXF5arAb8oTUdfpaa
	TYeZRr8LKAcIFyv25bEM8l3O8rX5RJS1fzANFcR2p6VrBjH4O5Akkm4KjwMYqlRhMhjkqdHc8QX
	IyIyDJGQS0xO8HQJDKLWYgxKUh2colOTh/9bJrXVC72bB/QSeGqXObE7sWboA80K5WzYeE/bc2Y
	MaYsvWYs8RYcS6vcUrvQnnRxsqdAgzUthNdpRpkPro5JKJzBtO2Ke5Ku0EEQV8PdlCtoJaHygFU
	f/283yGUGt3x2aCQ==
X-Received: by 2002:a05:6000:2489:b0:460:3233:beed with SMTP id ffacd0b85a97d-47f8d75ec77mr9286973f8f.41.1784890427609;
        Fri, 24 Jul 2026 03:53:47 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:d8e1:da6c:62ef:6ff9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb5127sm22309568f8f.10.2026.07.24.03.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:53:47 -0700 (PDT)
Date: Fri, 24 Jul 2026 12:53:36 +0200
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
	linux-arm-kernel@lists.infradead.org, brgl@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v24 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <amNEMK4k54l655ku@linaro.org>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
 <20260723-qcom-qce-cmd-descr-v24-6-4f87bb4d9938@oss.qualcomm.com>
 <20260723172814.661591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723172814.661591F000E9@smtp.kernel.org>

On Thu, Jul 23, 2026 at 05:28:13PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> New issues:
> - [High] Calling `queue_work()` inside `bam_start_dma()` when there is exactly 1 slot available creates an infinite busy-loop in softirq context (softlockup).
> - [High] The transaction completion callback fires before the hardware pipe is actually unlocked, violating the mutual exclusion requirement.
> - [High] The driver clears the software lock state prematurely, allowing concurrent configuration changes to corrupt in-flight hardware execution.
> - [Medium] The 'reserved' field of the lock command element is left uninitialized before being synced to the device.
> 
> Pre-existing issues:
> - [Critical] Mismatch between FIFO wrapping modulo and CIRC_SPACE size leads to silent descriptor overwrites and data corruption.
> --
> 
> --- Patch [6]: [PATCH v24 06/14] dmaengine: qcom: bam_dma: add support for BAM locking ---
> commit bf87fb2cf384d859e1e0efff5d0a48f0cb3ccea2
> Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> 
> dmaengine: qcom: bam_dma: add support for BAM locking
> 
> Add support for BAM pipe locking. To that end: when starting DMA on a TX
> channel (DMA_MEM_TO_DEV) - prepend the existing queue of issued
> descriptors with an additional "dummy" command descriptor with the LOCK
> bit set. Once the transaction is done (no more issued descriptors),
> issue one more dummy descriptor with the UNLOCK bit.
> 
> > diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> > --- a/drivers/dma/qcom/bam_dma.c
> > +++ b/drivers/dma/qcom/bam_dma.c
> 
> [ ... ]
> 
> > @@ -676,10 +697,51 @@ static void bam_free_chan(struct dma_chan *chan)
> >  static int bam_slave_config(struct dma_chan *chan,
> >  			    struct dma_slave_config *cfg)
> >  {
> > +	struct bam_config *peripheral_cfg = cfg->peripheral_config;
> >  	struct bam_chan *bchan = to_bam_chan(chan);
> > +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
> > +
> > +	if (peripheral_cfg && cfg->peripheral_size != sizeof(*peripheral_cfg))
> > +		return -EINVAL;
> >  
> >  	guard(spinlock_irqsave)(&bchan->vc.lock);
> >  
> > +	/*
> > +	 * This is required to setup the pipe locking and must be done even
> > +	 * before the first call to bam_start_dma().
> > +	 */
> > +	if (bdata->pipe_lock_supported && peripheral_cfg) {
> > +		if (cfg->direction != DMA_MEM_TO_DEV)
> > +			return -EINVAL;
> > +
> > +		if (bchan->bam_locked)
> > +			return -EBUSY;
> > +
> > +		if (!bchan->lock_ce) {
> > +			bchan->lock_ce = kmalloc_obj(*bchan->lock_ce, GFP_ATOMIC);
> 
> [Severity: Medium]
> Will this leave the reserved field of the command element uninitialized?
> 
> Looking at how this is initialized in include/linux/dma/qcom_bam_dma.h:
> 
> static inline void
> bam_prep_ce_le32(struct bam_cmd_element *bam_ce, u32 addr,
>                  enum bam_command_type cmd, __le32 data)
> {
>         bam_ce->cmd_and_addr =
>                 cpu_to_le32((addr & 0xffffff) | ((cmd & 0xff) << 24));
>         bam_ce->data = data;
>         bam_ce->mask = cpu_to_le32(0xffffffff);
> }
> 
> The reserved field is not set here, and kmalloc_obj() does not zero the
> memory. Could this map and sync uninitialized kernel heap memory to the DMA
> hardware?
> 

kzalloc_obj()? This is your bug. :-)

> [ ... ]
> 
> > @@ -1064,22 +1145,34 @@ static void bam_start_dma(struct bam_chan *bchan)
> >  
> >  	lockdep_assert_held(&bchan->vc.lock);
> >  
> > -	if (!vd)
> > +	vd = vchan_next_desc(&bchan->vc);
> > +	if (IS_BUSY(bchan) || (!vd && !bchan->bam_locked))
> >  		return;
> >  
> >  	ret = pm_runtime_get_sync(bdev->dev);
> >  	if (ret < 0)
> >  		return;
> >  
> > +	if (!bchan->initialized)
> > +		bam_chan_init_hw(bchan, container_of(vd, struct bam_async_desc, vd)->dir);
> > +
> > +	if (bchan->locking_enabled && !bchan->bam_locked) {
> > +		/* Defer locking until we also have space for a data descriptor */
> > +		avail = CIRC_SPACE(bchan->tail, bchan->head, MAX_DESCRIPTORS + 1);
> 
> [Severity: Critical]
> This is a pre-existing issue, but does CIRC_SPACE() calculate the correct
> available space when bchan->tail wraps at 4095?
> 
> MAX_DESCRIPTORS is 4095. Down below in bam_start_dma(), the pointers wrap
> via:
> 
>     bchan->tail += async_desc->xfer_len;
>     bchan->tail %= MAX_DESCRIPTORS;
> 
> Since bchan->tail wraps to 0 after 4094, it never reaches 4095. However,
> CIRC_SPACE() is called with MAX_DESCRIPTORS + 1 (4096). Because
> CIRC_SPACE() assumes the pointers wrap at the provided power-of-2 size, when
> the buffer is full (tail == head), won't it incorrectly evaluate the space as
> 4095 and cause a massive buffer overrun?
> 

Ooof, this seems correct to me but we can/should fix this separately
probably...

> > +		if (avail < 2) {
> > +			queue_work(system_bh_highpri_wq, &bdev->work);
> > +			goto out;
> > +		}
> 
> [Severity: High]
> Can this early return cause an infinite busy-loop softlockup?
> 
> If exactly one slot is available (avail == 1), queue_work() is called and
> we return. The worker executes bam_dma_work():
> 
>     if ((!list_empty(&bchan->vc.desc_issued) || bchan->bam_locked) &&
>         !IS_BUSY(bchan))
>         bam_start_dma(bchan);
> 
> Since IS_BUSY() only tests for avail == 0, the check passes and
> bam_start_dma() is immediately called again. It sees avail < 2 again,
> queues the work again, and returns. Could this loop indefinitely in softirq
> context until a hardware interrupt eventually fires?
> 

Yes, the queue_work() doesn't make sense here. We need to wait for the
BAM to finish processing some descriptors. Once it has notified us about
that, the IRQ handler will queue_work() it anyway, so you can just drop
this.

Technically, the avail < 2 check isn't even needed. We could start
writing the LOCK descriptor and then wait for the BAM to make further
room for the data descriptors. I just thought it's a bit weird to queue
LOCK without also adding some data descriptors at the same time.

> [ ... ]
> 
> > @@ -1135,11 +1228,24 @@ static void bam_start_dma(struct bam_chan *bchan)
> >  		if (((avail <= async_desc->xfer_len) || !vd ||
> >  		     dmaengine_desc_callback_valid(&cb)) &&
> >  		    !(async_desc->flags & DESC_FLAG_EOT))
> >  			desc[async_desc->xfer_len - 1].flags |=
> >  				cpu_to_le16(DESC_FLAG_INT);
> 
> [Severity: High]
> Does this cause the transaction completion callback to fire before the
> hardware pipe is actually unlocked?
> 
> DESC_FLAG_INT is set on the data descriptor here, regardless of whether an
> UNLOCK descriptor will immediately follow. When the data descriptor completes,
> an interrupt is generated and process_channel_irqs() completes the cookie:
> 
>     if (!async_desc->num_desc)
>         vchan_cookie_complete(&async_desc->vd);
> 
> Could this notify client drivers of transaction completion while the UNLOCK
> descriptor is still pending in the hardware FIFO, allowing clients to modify
> state or power down the device prematurely?
> 

Yes, but the client driver should be only concerned about the completion
of its own data operations, the lock handling is transparent and
internal to the BAM driver IMO. "Works as intended."

> [ ... ]
> 
> > +	/*
> > +	 * Close the bracket once there is no more client work queued. The
> > +	 * UNLOCK is flagged for an interrupt so process_channel_irqs() is
> > +	 * guaranteed to observe its completion and retire it from the FIFO
> > +	 * promptly, instead of leaving bchan->head to lag until a later
> > +	 * bracket's skip-loop catches up with it.
> > +	 */
> > +	if (bchan->bam_locked && !vd && !IS_BUSY(bchan)) {
> > +		bam_fifo_write_lock(bchan, DESC_FLAG_UNLOCK | DESC_FLAG_INT);
> > +		bchan->bam_locked = false;
> > +	}
> 
> [Severity: High]
> Is the software lock state cleared too early here?
> 
> We synchronously set bchan->bam_locked to false immediately after placing the
> UNLOCK descriptor into the software FIFO, before the hardware has actually
> completed the transaction. 
> 
> If a client then calls bam_slave_config(), the -EBUSY check for
> bchan->bam_locked will pass, and the driver might overwrite bchan->lock_ce
> or configuration registers while the hardware is still busy processing
> in-flight descriptors. Does this violate the mutual exclusion requirement?

It's true, but I think this can be ignored. That's why I didn't even
have the -EBUSY check in my diff. bam_start_dma() already re-configures
the channel in the middle of a transaction (if bchan->reconfigure is
set), so that one will already make changes to in-progress descriptors
anyway. It's a bit problematic though that we don't provide a way for
clients to wait until the unlocking has been completed, so they don't
have any chance to avoid affecting ongoing unlock operations from their
side.

Or you just disallow changing the lock_scratchpad_addr once it has been
set. Whatever. I don't think anyone will ever use multiple different
addresses there.

Thanks,
Stephan
