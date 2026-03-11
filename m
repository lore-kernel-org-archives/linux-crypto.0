Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605A63AB26B
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 10:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223252; cv=none; b=pxadoVNfIlLN9M3X4LhFHQuEQz6FMnbr6+MnnP1v4z96yCHec9AHC2fPQUcv6t/X/fvqrJIgWhy5PXU+sjPHsLXcVBP5G0Ig5kgOnjS5H3SxhHfvZqtNUhBVfM6m2ge7Xi6ocrfZRv0zeA0t4oYsOsaCX4owvHkviakep9sY9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223252; c=relaxed/simple;
	bh=th6/Spfb/htH3UowzS/TbF+AxDPJCsaUEzoaTbrPt1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shkKe3/sZi5MaXrFqcnzOIgwEsx4TM3A0cdzkm00pH+VFq+Wls4nHreWe1sItbDZ6kiBGcrqBP/c4iIor33CIFxWbc9Xt1XPxwK8ClWy/7/Nqu6AYhwl1sC0OsBjvH4fvaDvIj7JAxdEOiaMgkUA9DGCqdBiNn7l6SFtB2J7yl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ojrug3DF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ojrug3DF"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439c944bb62so5281868f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 03:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773223250; x=1773828050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow79JTabgZIRsJS6+UL0N2v2U8DPJz+PJynXqjT3UBM=;
        b=Ojrug3DFrlQpiG7ZGcIeWrsmvJFxYRvI2nn6ZQcYK6Xzb1I943fiAERZ/tNHxQxVT9
         bOw/BxOXwg9O9uzdXw3ubJlW861JRNnCD0fwAYq/v3JHSH2MGaJ1XtB8xRrp2nycDQbB
         XDkJLmYhnpGRsChycg4IEwW6VrtaUaE7GpnDqB4fF+8rpHHEyxjX6irn26lsiinYG6WS
         UZPygpfCXwovyWcbdVrHGX8kkHyKhTN5w2NNxkJ61wM3NHQil9JK7Ry977OAPpr5I70/
         wfGjV8PBuudrRhdo8wTq8g378WesMEVAO+4Mli0AiNaJzFI0vIlLe4dnzJpVzKQCv+uI
         HykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773223250; x=1773828050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ow79JTabgZIRsJS6+UL0N2v2U8DPJz+PJynXqjT3UBM=;
        b=YGdIux3qr7fzodQMaXC29VkcxYN5xOzqnMl3VgAfzm0Rigz3HKKZTkr4YhYzK9QGu2
         /MpOLiXBTtLGryFuEwoaY+wmlDHXs+oL0Y0MWZet3IJRSN3KtyEJ5DUKOLgdi79AwFx4
         FMvz7RBzEu1cIkUiL0Lw0HN17Nl/8XtyinGqnOimVzTKM8a3mU3iXIbOpY7s/AC6AzRE
         MrTbsBQ5OSyJHxvYkqvbFgAWYfP/w5PiOnSDbC/8VeO46BUqU4FaJui7IhGzV2HRBy9Y
         R+BQsVIt4J+IaJsYEA3Lpfc5BVE24m5rs0UHpvE1L1kVfOoTbIgLkQIDbE7yWrOfjAvR
         FIMA==
X-Forwarded-Encrypted: i=1; AJvYcCXG9Hmf2zQ3fXJ4AKb+RFa/vPJ2LdAK1tunmgT31kcEmsRB1Kvp3M7KAx29lj7/dw/Q8CRimBgcDUihbWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtKNODrHrtw5ei/uU/IVeyBLOrnX/5duuPXGSWYu7cRjJpB/+q
	FCMBWnC9YXCPgzLNLcQpNfOsYGCd2n4UfUrMH/FuaiT9WkZ7eBQGJc7Hw0F+yoMLnVE=
X-Gm-Gg: ATEYQzwDE5fCwEJ8XbzmMj2edhxRACyhjXEXzNq+88epcpZQ8vGpC57Iz8v9E7MU9br
	QcCt6M9qjOqGba/ECuDeeLq0SqCpjp/Mi5DmM8QglwAVpL+AH8M9mG3VgZvUg2ywE9hRkfof0vQ
	tvx8Smy96slgInqUaqTeeSIrybS3r7rulyFF5/939KVIGngedP9LVUv0snRQ4QCFueEAK5qxwJI
	xZqdWhGXXxEwtHTLd9EYUvLSmZKmSRIm8vS0CNWyZhGQFlaA3uWt4GHi4NRQnHdEUIyflcsLQnq
	fL92pmfvSpudAjmC+W2QhKYUDW44OQa0EvGnahykW+rHjcX3e+ecSgfJyqg6SRe+HhuQtDJtu+0
	+5BUvuJRsTmu17fxITWkut+r/v0KiDk2xPj6Vad8/71hhNf53AGQ5wkQIDhhqSU6AJkFmlWOb1V
	vfFNLHirfcafiy8z9LKBvXF2Yq5tozAx2mMrI=
X-Received: by 2002:a05:6000:2f85:b0:439:c38e:66cc with SMTP id ffacd0b85a97d-439f821e5aemr3551932f8f.46.1773223249530;
        Wed, 11 Mar 2026 03:00:49 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff23:4441:1c2c:7aff:fe45:362e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f81acc22sm5146729f8f.16.2026.03.11.03.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 03:00:48 -0700 (PDT)
Date: Wed, 11 Mar 2026 11:00:37 +0100
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	brgl@kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v12 05/12] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <abE9RQfGN6Ycns1B@linaro.org>
References: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
 <20260310-qcom-qce-cmd-descr-v12-5-398f37f26ef0@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-qcom-qce-cmd-descr-v12-5-398f37f26ef0@oss.qualcomm.com>

On Tue, Mar 10, 2026 at 04:44:19PM +0100, Bartosz Golaszewski wrote:
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
> [...]
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index 83491e7c2f17d8c9d12a1a055baea7e3a0a75a53..627c85a2df4dcdbac247d831a4aef047c2189456 100644
> --- a/drivers/dma/qcom/bam_dma.c
> +++ b/drivers/dma/qcom/bam_dma.c
> [...]
> +static int bam_do_setup_pipe_lock(struct bam_chan *bchan, bool lock)
> +{
> +	struct bam_device *bdev = bchan->bdev;
> +	const struct bam_device_data *bdata = bdev->dev_data;
> +	struct bam_async_desc *lock_desc;
> +	struct bam_cmd_element *ce;
> +	struct scatterlist *sgl;
> +	unsigned long flag;
> +
> +	lockdep_assert_held(&bchan->vc.lock);
> +
> +	if (!bdata->pipe_lock_supported || !bchan->scratchpad_addr ||
> +	    bchan->slave.direction != DMA_MEM_TO_DEV)
> +		return 0;
> +
> +	if (lock) {
> +		sgl = &bchan->lock_sg;
> +		ce = &bchan->lock_ce;
> +		flag = DESC_FLAG_LOCK;
> +	} else {
> +		sgl = &bchan->unlock_sg;
> +		ce = &bchan->unlock_ce;
> +		flag = DESC_FLAG_UNLOCK;
> +	}
> +
> +	lock_desc = bam_make_lock_desc(bchan, sgl, ce, flag);
> +	if (!lock_desc)
> +		return -ENOMEM;
> +
> +	if (lock)
> +		list_add(&lock_desc->vd.node, &bchan->vc.desc_issued);
> +	else
> +		list_add_tail(&lock_desc->vd.node, &bchan->vc.desc_issued);
> +
> +	bchan->locked = lock;
> +
> +	return 0;
> +}
> +
> +static int bam_setup_pipe_lock(struct bam_chan *bchan)
> +{
> +	return bam_do_setup_pipe_lock(bchan, true);
> +}
> +
> +static int bam_setup_pipe_unlock(struct bam_chan *bchan)
> +{
> +	return bam_do_setup_pipe_lock(bchan, false);
> +}
> +
>  /**
>   * bam_start_dma - start next transaction
>   * @bchan: bam dma channel
> @@ -1121,6 +1266,7 @@ static void bam_dma_work(struct work_struct *work)
>  	struct bam_device *bdev = from_work(bdev, work, work);
>  	struct bam_chan *bchan;
>  	unsigned int i;
> +	int ret;
>  
>  	/* go through the channels and kick off transactions */
>  	for (i = 0; i < bdev->num_channels; i++) {
> @@ -1128,6 +1274,13 @@ static void bam_dma_work(struct work_struct *work)
>  
>  		guard(spinlock_irqsave)(&bchan->vc.lock);
>  
> +		if (list_empty(&bchan->vc.desc_issued) && bchan->locked) {
> +			ret = bam_setup_pipe_unlock(bchan);
> +			if (ret)
> +				dev_err(bchan->vc.chan.slave,
> +					"Failed to set up the pipe unlock descriptor\n");
> +		}
> +
>  		if (!list_empty(&bchan->vc.desc_issued) && !IS_BUSY(bchan))
>  			bam_start_dma(bchan);
>  	}

I'm not entirely sure if this actually guarantees waiting with the
unlock until the transaction is "done", for two reasons:

 1. &bchan->vc.desc_issued looks like a "TODO" list for descriptors we
    haven't fully managed to squeeze into the BAM FIFO yet. It doesn't
    tell you which descriptors have been consumed and finished
    processing inside the FIFO.

    Consider e.g. the following case: The client has issued a number of
    descriptors, they all fit into the FIFO. The first descriptor has a
    callback assigned, so we ask the BAM to send us an interrupt when it
    has been consumed. We get the interrupt for the first descriptor and
    process_channel_irqs() marks it as completed, the rest of the
    descriptors are still pending. &bchan->vc.desc_issued is empty, so
    you queue the unlock command before the rest of the descriptors have
    finished.

 2. From reading the BAM chapter in the APQ8016E TRM I get the
    impression that by default an interrupt for a descriptor just tells
    you that the descriptor was consumed by the BAM (and forwarded to
    the peripheral). If you want to guarantee that the transaction is
    actually done on the peripheral side before allowing writes into
    config registers, you would need to set the NWD (Notify When Done)
    bit (aka DMA_PREP_FENCE) on the last descriptor before the unlock
    command.

    NWD seems to stall descriptor processing until the peripheral
    signals completion, so this might allow you to immediately queue the
    unlock command like in v11. The downside is that you would need to
    make assumptions about the set of commands submitted by the client
    again... The downstream driver seems to set NWD on the data
    descriptor immediately before the UNLOCK command [1].

    The chapter in the APQ8016E TRM kind of contradicts itself
    sometimes, but there is this sentence for example: "On the data
    descriptor preceding command descriptor, NWD bit must be asserted in
    order to assure that all the data has been transferred and the
    peripheral is ready to be re-configured."

Thanks,
Stephan

[1]: https://git.codelinaro.org/clo/la/platform/vendor/qcom/opensource/securemsm-kernel/-/blob/fa55a96773d3fbfcd96beb2965efcaaae5697816/crypto-qti/qce50.c#L5361-5362
