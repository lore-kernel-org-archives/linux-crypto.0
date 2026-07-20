Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E373C3781
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 07:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532812; cv=none; b=ZlmtkHX6FMF7+Bp1CXQGCDLDSIVW36+XLFVOweSD/N69k0MD47AepugCgR4LChM73gX1TMm6WyNBZ5yjt7iVDzVwqkwPgODoow41plWNsgA9VGNy0udQMOot/gSdS/KsM7JGNt2LI5MN2CdTBDtNNw90gvYYujr+PoJE+bcVq1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532812; c=relaxed/simple;
	bh=EtFr7SpaBZPqMsLgiZiW+YfjFccwIhevLWBpka1ep4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMxaJZtSELLt8jLS28EM/mE1xQ7iE3l81ff0yjP3+K3tsm+ftmIjCzaHS5e+vImZHU59N21Z4GuTDok8aKcrb/yUfFYLqjiDUvCIX45z9n+en/Bfu1OQnEh3lhZoC1Zy9oBJ6CP9bjFbDk7M3pM1Y2HAXvx9dVsGFEtyQJDBOis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aK6gTxh9; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aK6gTxh9"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f7444576cso546082f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 00:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784532805; x=1785137605; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9dlR1VSEOP+P+zQGfaFMhFwH/x1vDY3bfx6C3cbYWvs=;
        b=aK6gTxh9a6bwPyR5IoXM5p2yzpsL0MGd2qmPTXcf0OTvEsIE6H+oAGQEEKZ+dJqKw/
         fqxQsTMytDAZJEmcwsCIkknOE4smFdH0l7ODB0JWFyepkpyiU8z6xjXaDF/4LgiNlV5z
         yJ1HpaC1MBQYCDJ2cFsViKuiADpvpkHxLu5tT2F1+5DCd51Ti5MJGT2/8xwcozpuJBSE
         SXRTzbDZ6dx4PBZQG2/Ss6uSS0o6IpbenG2q3KWhZrZj7ePlNEA3ONpgUgDAX+85dmzt
         EnxX4LyBYQGpVPcz626IO62wRLCY83vIiX11PxvvbZIy/xFoTRuX22AJgH63XiX4AT7K
         wHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784532805; x=1785137605;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9dlR1VSEOP+P+zQGfaFMhFwH/x1vDY3bfx6C3cbYWvs=;
        b=MIxNejsyT6N2rmXGjT1OTkOSLlLdgB3ZeEQ7twZ68ji/SY0OBTAXQsEkCymZCFxtun
         FR00oCgTClBNfil4UeGNGSwsn1PYDgvQe0MI4YfPZL6+QEjUIgeX4zZ2FzQuJRq8b92T
         CZ6rTCTJGi3E7onRGrxxxhCFJJxADxK1Y4Cog98IV/T/jvvVNn85olog6tdoy4PUFVZh
         gNjssHNpYZD78o+t217+GWGaLfX+0Yby6fB8DyTXcAhMt7UJAxcacFxSZXKkYfl9oboh
         qL/fIPE/UsaZ4nAk0OkVTUOsAZKYgGrHrUu4CPxlUXbaFNRGCW4aTqqol8fRs9hogOv2
         n3kg==
X-Forwarded-Encrypted: i=1; AHgh+RqY5W8TGIVojikBIprIKOz4BEjv8/PPwnE90iK1n9yD5zRVUA0oUuOKkwrGYAsYd+l9LeS0AqAiMIDry44=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEn3WonkXmr8ZcJzDip2DQ8jCPeWnlo4jrfEsc04Gukiqz7YTX
	35ym6EZMXT5f8eQE7Ltj+jqzTLHAMUGZFXNCZ4WpNM1m9f7ODqlqGp6eD9i1qnjPmjM=
X-Gm-Gg: AfdE7cnNpS1/gdRBDrVcz0lmQZX038Tp3veRBGbUMkCuaGWj3I4vLXByNOzTuhAbhDI
	omsVshZ3pscHJVRzuNsE4pXLlK9CZwoLHmzbX/FgkBf6yWlxlhq791Y67ryMGTlK70zl4eidhhA
	LT/O9hSPcPwYbC+dArNVcFARnMn7k/sZxJEOVw+1lKNKilHxtXDN9f2ZcwX6ABtr7eW/4jE9r7J
	Gu7GNXWznq3AcXox8kI9FBAUri02BGgAEYJeHzyfTtegK2NOD06nO9b0wj3DVsg6mfBPkBToBQ3
	qlwcYI/EAeNQa+6PqzuceCmelL+dZIdZYCLTs7FJ0Z+8etkGxV19RxvxQovKWzaT+pw9vXD5XeM
	U3I2QIgkEgKo6Ov4FNBEbDqgv+z54u8CXokwmR1wLa+abliPBbsvsis3Orp8GemJFLKtngOdrpf
	Ks5dI4mmXTadjd4A==
X-Received: by 2002:a05:6000:491c:b0:47f:73d3:bfc3 with SMTP id ffacd0b85a97d-47f73d3c0fcmr5580169f8f.61.1784532805224;
        Mon, 20 Jul 2026 00:33:25 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:b6d9:bb37:a20c:1c55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63edd7d3sm26586179f8f.25.2026.07.20.00.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 00:33:24 -0700 (PDT)
Date: Mon, 20 Jul 2026 09:33:13 +0200
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
Subject: Re: [PATCH v22 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <al3POSAJKHkLYVgW@linaro.org>
References: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
 <20260717-qcom-qce-cmd-descr-v22-6-ff0d18b27246@oss.qualcomm.com>
 <20260717085136.E0FBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717085136.E0FBC1F000E9@smtp.kernel.org>

On Fri, Jul 17, 2026 at 08:51:36AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] DMA API violation due to mismatched device pointers in dma_map_sg and dma_unmap_sg.
> - [High] The client-provided physical address for the lock scratchpad is silently truncated to 24 bits.
> - [Medium] Transient allocation failure for lock descriptors causes a permanent channel stall.
> - [Medium] Pipe locking is restricted to TX channels instead of RX channels, contradicting intended design.
> - [Medium] The dummy lock descriptor clears the `reconfigure` flag using a hardcoded TX direction, potentially misconfiguring the channel.
> - [Low] Missing integer argument for `%d` in `dev_err_ratelimited` call.
> --
> 
> --- Patch [6]: [PATCH v22 06/14] dmaengine: qcom: bam_dma: add support for BAM locking ---
> commit c786d3c51276cef4b55a461357b399c32982316b
> Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Subject: dmaengine: qcom: bam_dma: add support for BAM locking
> 
> This commit adds support for BAM pipe locking by prepending and appending
> dummy command descriptors with LOCK and UNLOCK bits set. It aims to prevent
> writes into config registers while the engine is busy.
> 

Thanks for all the changes! It looks good to me for the most part, so
I'll just comment on the remaining Sashiko comments below.

> > Add support for BAM pipe locking. To that end: when starting DMA on an RX
> > channel - prepend the existing queue of issued descriptors with an
> 
> [Severity: Medium]
> Is this intended to be restricted to TX channels? The commit message mentions
> starting DMA on an RX channel, but the implementation in bam_setup_pipe_lock()
> aborts the lock setup if the direction is not DMA_MEM_TO_DEV.
> 

Is this a typo in your commit message? I guess RX vs TX depends on the
perspective (kernel or peripheral), but I think "TX channel" would be
clearer here (or even just put DMA_MEM_TO_DEV).

> > diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> > index f3e713a5259c2..edaa694eb9df0 100644
> > --- a/drivers/dma/qcom/bam_dma.c
> > +++ b/drivers/dma/qcom/bam_dma.c
> 
> [ ... ]
> 
> > @@ -859,6 +887,15 @@ static int bam_resume(struct dma_chan *chan)
> >  	return 0;
> >  }
> >  
> > +static void bam_dma_free_lock_desc(struct virt_dma_desc *vd)
> > +{
> > +	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
> > +	struct dma_chan *chan = vd->tx.chan;
> > +
> > +	dma_unmap_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
> 
> [Severity: High]
> Will this cause a DMA API violation? 
> 
> The scatterlist is unmapped here using the client device (chan->slave), but it
> is mapped in bam_make_lock_desc() using the DMA controller device 
> (bchan->bdev->dev).
> 

Yep, we need to change all those DMA calls to bchan->bdev->dev.

> > +	kfree(async_desc);
> > +}
> 
> [ ... ]
> 
> > @@ -1046,13 +1090,101 @@ static void bam_apply_new_config(struct bam_chan *bchan,
> >  	bchan->reconfigure = 0;
> >  }
> >  
> > +static struct bam_async_desc *
> > +bam_make_lock_desc(struct bam_chan *bchan, unsigned long flag)
> > +{
> > +	struct bam_async_desc *async_desc;
> 
> [ ... ]
> 
> > +	bam_prep_ce_le32(&async_desc->lock_ce, bchan->lock_scratchpad_addr, BAM_WRITE_COMMAND, 0);
> 
> [Severity: High]
> Can this truncate the physical address and cause memory corruption?
> 
> The client-provided lock_scratchpad_addr is a 64-bit phys_addr_t, but
> bam_prep_ce_le32() masks the address to 24 bits:
> 
> bam_ce->cmd_and_addr = cpu_to_le32((addr & 0xffffff) | ((cmd & 0xff) << 24));
> 
> If the physical address is above 16MB, the BAM engine will perform its dummy
> write to an arbitrary truncated address.
> 

This looks correct as well. It seems the address in a BAM command
descriptor is more like a "address within the peripheral" than an actual
physical address, so the same applies to the lock_scratchpad_addr. Can
you clarify this inside the struct bam_config documentation comment?

This also means there is no point to accept a phys_addr_t in
lock_scratchpad_addr, u32 is sufficient.

> > +	sg_set_buf(&async_desc->lock_sg, &async_desc->lock_ce, sizeof(async_desc->lock_ce));
> > +
> > +	mapped = dma_map_sg(bchan->bdev->dev, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
> 
> [ ... ]
> 
> > +static int bam_setup_pipe_lock(struct bam_chan *bchan)
> > +{
> > +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
> > +	struct bam_async_desc *lock_desc, *unlock_desc;
> > +
> > +	lockdep_assert_held(&bchan->vc.lock);
> > +
> > +	if (!bdata->pipe_lock_supported || !bchan->lock_scratchpad_addr ||
> > +	    bchan->direction != DMA_MEM_TO_DEV)
> > +		return 0;
> 
> [Severity: Medium]
> Does this restriction conflict with the commit message? 
> 
> The condition limits pipe locking to DMA_MEM_TO_DEV (TX), making this feature
> dead code for RX channels (DMA_DEV_TO_MEM).
> 

Clarifying the commit message should fix this comment as well.

> > +
> > +	/*
> 
> [ ... ]
> 
> > @@ -1072,6 +1205,22 @@ static void bam_start_dma(struct bam_chan *bchan)
> >  		return;
> >  
> >  	while (vd && !IS_BUSY(bchan)) {
> > +		/*
> > +		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
> > +		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
> > +		 * already have bam_locked set and must not trigger a second pair.
> > +		 */
> > +		if (!bchan->bam_locked) {
> > +			ret = bam_setup_pipe_lock(bchan);
> > +			if (ret) {
> > +				dev_err_ratelimited(bdev->dev,
> > +					"failed to setup the pipe lock, deferring transfer: %d\n");
> 
> [Severity: Low]
> Is this missing the integer argument for the %d format specifier?
> 

Yep.

> [Severity: Medium]
> Will this cause a permanent channel stall on memory pressure? 
> 
> If bam_setup_pipe_lock() fails due to a GFP_NOWAIT allocation failure, the
> loop breaks and leaves the descriptors on the desc_issued list, but no
> mechanism appears to schedule a retry.
> 
> > +				break;

Could be true, if we break out of the loop here, where will this
deferral happen? Will anything call bam_start_dma() again?

Perhaps we should have queue_work() here?

> > +			}
> > +			if (bchan->bam_locked)
> > +				vd = vchan_next_desc(&bchan->vc);
> > +		}
> > +
> >  		list_del(&vd->node);
> >  
> >  		async_desc = container_of(vd, struct bam_async_desc, vd);
> 
> [ ... ]
> 
> >  		/* on first use, initialize the channel hardware */
> >  		if (!bchan->initialized)
> >  			bam_chan_init_hw(bchan, async_desc->dir);
> >  
> >  		/* apply new slave config changes, if necessary */
> >  		if (bchan->reconfigure)
> >  			bam_apply_new_config(bchan, async_desc->dir);
> 
> [Severity: Medium]
> Could the dummy lock descriptor clear the reconfigure flag with the wrong
> direction?
> 
> The lock descriptor is created with async_desc->dir hardcoded to
> DMA_MEM_TO_DEV. If pipeline locking is ever enabled for RX channels,
> bam_apply_new_config() will configure the BAM engine using dst_maxburst
> instead of src_maxburst, and clear the bchan->reconfigure flag before the
> real data descriptor is processed.
> 

Err, what? I think we can ignore this one, since I don't think there is
a use case for locking on the RX channel.

Although, looking a bit more at your changes, I think you should make
sure the direction is correct already in bam_slave_config():

+	/*
+	 * This is required to setup the pipe locking and must be done even
+	 * before the first call to bam_start_dma().
+	 */
+	if (bdata->pipe_lock_supported && peripheral_cfg) {
+		bchan->lock_scratchpad_addr = peripheral_cfg->lock_scratchpad_addr;
+		bchan->direction = cfg->direction;
+	}
+

I don't think there is much point to store the direction at all if we
just support DMA_MEM_TO_DEV in bam_setup_pipe_lock(). I would just check
the direction inside this if statement and return -EINVAL if some user
tries to setup pipe locking on a TX channel. Then you don't need to
store bchan->direction at all.

> >  
> 
> [ ... ]
> 
> > @@ -1191,8 +1344,11 @@ static void bam_issue_pending(struct dma_chan *chan)
> >   */
> >  static void bam_dma_free_desc(struct virt_dma_desc *vd)
> >  {
> > -	struct bam_async_desc *async_desc = container_of(vd,
> > -			struct bam_async_desc, vd);
> > +	struct bam_async_desc *async_desc = container_of(vd, struct bam_async_desc, vd);
> > +	struct dma_chan *chan = vd->tx.chan;
> > +
> > +	if (async_desc->is_lock_desc)
> > +		dma_unmap_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
> 
> [Severity: High]
> Does this share the same DMA API violation mentioned earlier? 
> 
> The abort/cleanup path also unmaps using the client device instead of the
> DMA controller device.
> 

Same thing here as above, yeah. Should be bchan->bdev->dev.

Thanks,
Stephan
