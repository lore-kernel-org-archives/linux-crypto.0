Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008BF415F12
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712898; cv=none; b=AlW5LPoEP1z6cv9JMG1r2E5vpGnq4cImPaFy4BeOj/KoixSDlAHRNICZtJXgJ1K+DjKCj41YgXCHuzdvLFXdO6l3EtsUyqXuwq62r5JBQra36OmfHCG3IFxNcOPmvCB5fX35V35XUNGtO17r0XQ7qdOh4+NWdPmrmCDvWcHVRKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712898; c=relaxed/simple;
	bh=jpHtfx4p4it1loPSHgYfz9mzDUkXWoO0M6SnL2+H9us=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZw0b9IYDeN92XtJQbryIykbW0QM+/u6w97JD/HEAo5rw/KTRN9JwUke+k6v1KLb8EP6SUIKen0JOQ5t6SCCwtXBxYBEO28OuTGRMuAnboCuYlSi9fGvKfsKQ7PJLGHJpwOKJZLoiYa6lA2IG4+PXVbhKZd2QmP6ZOALoDDHb5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cu6Mc/sT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cu6Mc/sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98EF1F000E9
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784712895;
	bh=i4WgNrEKdg3Ic3C4pPexVwOX2zafZ8GZg4cnbInNRII=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=Cu6Mc/sTiHEugnS/UEUP5o1+6fDnZqVfmlxJQqiFffjcMGqHzy+gRrrDqF5vE3wCX
	 jDfzbDes4z1Vi0jlCuNfJ5S0dC1KAONP/jSJeLDrvazOVYPa6UM0wAtDAiUagN89ri
	 p5U0TDZ7Cv15Kmj7t/aHdNiEeIr1/mcbOu3MIIh86c33Si5/Y2kubgA2tVudJ5aqKj
	 AK35MmbSuTb5RsAz0tT7fx81y8C9OPKS8raXuKAu3KHhXvJsrcDyWG3/yBGeIA7GaU
	 g9NvPL48PxcMkPwS4T/GY9Y/6CBaVDVG4gLgEVlX8KRHc8oRagh/LLFfZflsA8+ivm
	 ev8j87IUsQxaQ==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39c74c469e8so93124571fa.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 02:34:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoGGFEtK28XoN9BvDGWxigm30fGD0B0+QwyQWCjcnFUFwqK85tgC70vVWvaU8ydCwhb/W3aoMxqNpzLQH4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya/A7b55J31Dq3It4Az3vRlcWnxF2tg0YRYEi+X4UORIChTFmn
	l8LLa+Cbw/yK4dhCDLob5/zHy65xrbbNddBX6NG71JymciIlWDLLIHH2UILwEL88VyCXycAIUcR
	CYDp8OiILxI/Ijf7iD4hONtuJj+Ii7fuVxihd2Kt0bA==
X-Received: by 2002:a05:6512:6f:b0:5ae:b0c0:16bc with SMTP id
 2adb3069b0e04-5b28f890184mr3237380e87.27.1784712894372; Wed, 22 Jul 2026
 02:34:54 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 02:34:52 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 02:34:52 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <amCGXUUd4VmuQRGD@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-6-1be02deffda9@oss.qualcomm.com>
 <20260721134853.2B2401F000E9@smtp.kernel.org> <amCGXUUd4VmuQRGD@linaro.org>
Date: Wed, 22 Jul 2026 02:34:52 -0700
X-Gmail-Original-Message-ID: <CAMRc=MfBNB0pvv1kPPcswE4Y2m7PXBO49bwJg=v0+aY=JmJKWw@mail.gmail.com>
X-Gm-Features: AUfX_mwVr6pWOzeRIi6v2GZNWX7GGrq8Md8rkImjzrBVx4v9bKKGCd1iVRWIwX0
Message-ID: <CAMRc=MfBNB0pvv1kPPcswE4Y2m7PXBO49bwJg=v0+aY=JmJKWw@mail.gmail.com>
Subject: Re: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM locking
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Vignesh Raghavendra <vigneshr@ti.com>, dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	brgl@kernel.org, sashiko-reviews@lists.linux.dev, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 10:59:09 +0200, Stephan Gerhold
<stephan.gerhold@linaro.org> said:
> On Tue, Jul 21, 2026 at 01:48:52PM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
>> - [High] State leak causing hardware misconfiguration on channel reuse due to uncleared `lock_scratchpad_addr` and hardcoded direction.
>> - [High] Channel state corruption when `bam_slave_config` fails validation.
>> - [High] Infinite BH workqueue loop and unratelimited log flood on memory allocation failure.
>> - [High] DMA API violation: `lock_ce` buffer shares a cacheline with frequently CPU-modified struct members.
>> - [Low] Unused assignment of `hdesc` in IRQ handler.
>> --
>>
>> --- Patch [6]: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM locking ---
>> commit 8b44c5e4935cbb61832adb3262df00b3b606a283
>> Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>>
>> dmaengine: qcom: bam_dma: add support for BAM locking
>>
>> This commit adds support for BAM pipe locking by prepending and appending
>> dummy command descriptors with LOCK/UNLOCK bits when starting DMA on a TX
>> channel. It uses a peripheral-local scratchpad address communicated via slave
>> config for the dummy writes.
>>
>> > diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
>> > index f3e713a5259c2..411c60c4433e2 100644
>> > --- a/drivers/dma/qcom/bam_dma.c
>> > +++ b/drivers/dma/qcom/bam_dma.c
>> [ ... ]
>> > @@ -72,6 +76,11 @@ struct bam_async_desc {
>> >
>> >  	struct bam_desc_hw *curr_desc;
>> >
>> > +	/* BAM locking infrastructure */
>> > +	bool is_lock_desc;
>> > +	struct scatterlist lock_sg;
>> > +	struct bam_cmd_element lock_ce;
>> > +
>> >  	/* list node for the desc in the bam_chan list of descriptors */
>> >  	struct list_head desc_node;
>>
>> [Severity: High]
>> Does placing lock_ce immediately adjacent to desc_node risk a DMA API
>> violation? lock_ce is mapped for DMA via dma_map_sg(), but desc_node is
>> actively modified by the CPU via list_add_tail() during bam_start_dma()
>> while the mapping is active. On non-coherent architectures, could this
>> cause cacheline tearing or stale data writebacks if they share the same
>> cacheline?
>>
>
> I think this complaint was there in some revisions before. Could be
> mostly a false positive given that the lock_ce is just DMA_MEM_TO_DEV
> (i.e. read-only for the BAM)...
>

Yes, I ignored it because it's not a problem for us in this case.

>> [ ... ]
>> > @@ -676,13 +691,26 @@ static void bam_free_chan(struct dma_chan *chan)
>> >  static int bam_slave_config(struct dma_chan *chan,
>> >  			    struct dma_slave_config *cfg)
>> >  {
>> > +	struct bam_config *peripheral_cfg = cfg->peripheral_config;
>> >  	struct bam_chan *bchan = to_bam_chan(chan);
>> > +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
>> >
>> >  	guard(spinlock_irqsave)(&bchan->vc.lock);
>> >
>> >  	memcpy(&bchan->slave, cfg, sizeof(*cfg));
>> >  	bchan->reconfigure = 1;
>> >
>>
>> [Severity: High]
>> Is it safe to overwrite bchan->slave and set bchan->reconfigure = 1 before
>> validating the configuration direction below? If cfg->direction !=
>> DMA_MEM_TO_DEV, this returns -EINVAL to the caller, but the channel
>> retains the rejected parameters and will apply them on the next transfer
>> because bchan->reconfigure remains set.
>>
>
> Yeah, better to swap the order.
>

Sigh... ok.

>> > +	/*
>> > +	 * This is required to setup the pipe locking and must be done even
>> > +	 * before the first call to bam_start_dma().
>> > +	 */
>> > +	if (bdata->pipe_lock_supported && peripheral_cfg) {
>> > +		if (cfg->direction != DMA_MEM_TO_DEV)
>> > +			return -EINVAL;
>> > +
>> > +		bchan->lock_scratchpad_addr = peripheral_cfg->lock_scratchpad_addr;
>> > +	}
>>
>> [Severity: High]
>> If bam_slave_config() is called without peripheral_cfg, should
>> bchan->lock_scratchpad_addr be reset to 0 to avoid leaking state from a
>> prior configuration? If the previous lock_scratchpad_addr is retained,
>> bam_start_dma() might erroneously inject dummy lock descriptors on new
>> transfers.
>>
>
> Probably unlikely to happen, but yeah.
>
> I would also check if (cfg->peripheral_size == sizeof(peripheral_cfg)),
> just to be safe.
>

Ok.

>> [ ... ]
>> > @@ -919,13 +959,19 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>> >  			 * push back to front of desc_issued so that
>> >  			 * it gets restarted by the work queue.
>> >  			 */
>> > +
>> > +			list_del(&async_desc->desc_node);
>> >  			if (!async_desc->num_desc) {
>> > -				vchan_cookie_complete(&async_desc->vd);
>> > +				hdesc = async_desc->desc;
>> > +
>>
>> [Severity: Low]
>> Is the assignment to hdesc used anywhere? It appears to be assigned here but
>> is never read.
>>
>
> Yeah, I think I pointed this out before.
>

Dang it, I removed one but seem to have missed this.

>> [ ... ]
>> > @@ -1064,6 +1197,7 @@ static void bam_start_dma(struct bam_chan *bchan)
>> >
>> >  	lockdep_assert_held(&bchan->vc.lock);
>> >
>> > +	vd = vchan_next_desc(&bchan->vc);
>> >  	if (!vd)
>> >  		return;
>> >
>> > @@ -1072,6 +1206,24 @@ static void bam_start_dma(struct bam_chan *bchan)
>> >  		return;
>> >
>> >  	while (vd && !IS_BUSY(bchan)) {
>> > +		/*
>> > +		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
>> > +		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
>> > +		 * already have bam_locked set and must not trigger a second pair.
>> > +		 */
>> > +		if (!bchan->bam_locked) {
>> > +			ret = bam_setup_pipe_lock(bchan);
>> > +			if (ret) {
>> > +				dev_err_ratelimited(bdev->dev,
>> > +					"failed to setup the pipe lock, deferring transfer: %d\n",
>> > +					ret);
>> > +				queue_work(system_bh_highpri_wq, &bdev->work);
>> > +				break;
>> > +			}
>>
>> [Severity: High]
>> Does requeuing to a high-priority BH workqueue upon ENOMEM cause CPU
>> starvation? Because system_bh_highpri_wq executes in softirq context,
>> requeuing immediately without sleeping prevents the memory reclaim needed
>> to resolve the GFP_NOWAIT failure, leading to an infinite spin loop.
>>
>
> It looks like my suggestion to queue_work() again in the error path of
> bam_start_dma() wasn't great if we end up causing an infinite spin loop.
> We do need to retry somehow or report an error though, I don't think
> aborting and leaving the desccriptors completely unhandled is an option
> either... :(
>
> One option would be to try to avoid the allocation and write the lock
> descriptors directly into the FIFO, but this will probably get really
> messy as well, since you would need to carefully modify the FIFO
> management in several functions ...
>
> I don't have a good spontaenous idea how to solve this right now. :/
>

Pre-allocate the lock descriptors (if needed) in bam_prep_slave_sg()? As in:
call bam_make_lock_desc() in bam_prep_slave_sg(), store the descriptors and
make bam_setup_pipe_lock() return void as it will no longer be possible for it
to fail? It would just grab the preallocated descriptors.

Bart
