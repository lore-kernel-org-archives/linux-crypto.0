Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803B93624BF
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 09:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022572; cv=none; b=ZjZBf6wfC+PZZqvZDAj0Zgny4vh+E76bJvid0hlFnWfG09gHXy+Wp6sMajEp+9zPYHNJ/IEiiLxW/5JbO/lgDQbUH+B+4Duc3tyBdDdKYySZgWr/euOWG/3KNwU+7kNtJfnJMx3TYIR9/4kknsarjTPdojqfYlGk3Xgrb4UkkKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022572; c=relaxed/simple;
	bh=7+y1hZpjFQEJ95siQK4W2WWl4j+nNVYR7+F8Qz3d7yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBmsTwRHYYdAFrm+MBKKQvCR5mrQ6k3U05BaLyskPyl9KhR9J83MmoW8gLz6yV5YN/zsSV4eUDMSe+Vi/Mba1gFeAcQ2Sd6zVRcajCGVMkkEqn51a84t23r9q73P5xjvrGA5NDXDrV2kqyeiOPuPmZBAAQcKpyHfKGOQlQWkXX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i+Rvh7z/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i+Rvh7z/"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47362928f65so3818883f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 02:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784022566; x=1784627366; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T1DYXIUQnIiN84/lMI+GWM+J+e6plcKuO3rAiK+mKgk=;
        b=i+Rvh7z/u9ZyzpCeyqeUU6Z4bcET9h9mipVkIhhNVB+aiLKx/rtbKxgK1wrWqa3zVT
         XZLyRebhWLuBb3qu7FasaLReRWuPR6qhrbykxE6/6wmNuStwTvZGp+gPpuIAfjSo5nXS
         Q7RKS+n8/4iFJc50RKFcGHSEJIyWxmpfifPELRuwcL+ddpjQfUqU6DspUCoLgOhziHMz
         ISsCJyFVU7BXcsqtFkQXL+0ZC5Nj5Gpi9usUMv44dWankfdQW82zErCPhLklz+eOsr9a
         deNjiBiJ5/rY0WfqMnBehnNkz78iGC6Kru6veMO8POwZS8D6qkbheXvbhaYRjgjutxnS
         MhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784022566; x=1784627366;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T1DYXIUQnIiN84/lMI+GWM+J+e6plcKuO3rAiK+mKgk=;
        b=Bt+9/7dFVE3mFxoqSquqxHJqn0XM3fap/LsFjC3SnNSTFCpDui3bLj0aidZmNKOL5Z
         P7q7KU8ND6LkryJeUO6oa6RuFTguj0fyyag5RI8DUkFkYODr5TkT4waB9ykfn9mJnzc8
         BAV9mFAMv4DNr7TMk4R7DQoy5oib4QQpyyed2dgSYrsLRectEJZhmz/6Wz8Aj72+cTfW
         I9BD5W+jVvtN9S3Ymbz8/xvHGHtWdegt4g1VMq6t94LaCDBVAihRc8kLPRyWaEAb2T4S
         hI17h50oY1yZHivpDynAkz50iGZdJ/GT2k8+fwgzrtmd/jInxrqxeFQexMP1lUT3PiRM
         dKrw==
X-Forwarded-Encrypted: i=1; AHgh+RrUyxGvSxhTPj7Es1gUbXI25k1f+npixDPXLBa4AAETOpcQeEkjbCieURVPDAwVb7rYIyUuS6HebW0nJwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDF7gS40UH6P1XZz1bWCYYFoaleyUpMqSzpd+6VF0F3jj1VaMp
	NEuQxpMqoDJ8DFxE6QxyChl3oa5OkbF2JpMIP3x1FGVLK4Rngb736SdEja73yNXZahA=
X-Gm-Gg: AfdE7clu+LDFfqLMPtTo4O/XUqnZgq1B6HAZ1jljjyDhE2NBA3OnvWX9YH0uEuiQVW4
	ug4Q9Imhov+TJbStuwSF46GcQOZZrxX+SpMYq2gqe/pifzy7Tcm4pSYr7sU9jjijXB5EydmvJl0
	ADzotIU2dxI1NaA5T3Xu6pdJT9MvzNsMW4zPAti7QYb13uHqe34XIiLzVi14jGkRBOkT/j2qj1L
	JjrwmjNgaLwwkE49TjJx1tMDFnX3B9wuxMzn4OQnrrsfrZlIfr6r3apZBbpG38PB9XggcaH+c32
	Bgd+PAQIDpAUI8CA81YT/KmEvSNVAo54xj8Gg+QhIg/+u98yxVTPV8NHKNOPkKzCySYteIChEOn
	bUlRzpVbkeHHeGxiAGd1vZm6hdsWwsMVZGrUpmD99OKxz6OViIXXQAJiRBhqYUHOfQT5k4cp2st
	1x6AohlXjbB66OV0bY7dNGfxZN
X-Received: by 2002:a05:6000:4602:b0:47d:fb9e:c3f6 with SMTP id ffacd0b85a97d-47f488573eamr1707837f8f.20.1784022566424;
        Tue, 14 Jul 2026 02:49:26 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:6c30:6cbd:7b12:2745])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a9879sm7671449f8f.22.2026.07.14.02.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 02:49:25 -0700 (PDT)
Date: Tue, 14 Jul 2026 11:49:14 +0200
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
Subject: Re: [PATCH v21 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <alYGGu7_3G6mJAzQ@linaro.org>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
 <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com>

On Mon, Jul 13, 2026 at 03:01:07PM +0200, Bartosz Golaszewski wrote:
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

Thanks for the fixes. The lock/unlock sequence looks good to me now,
I commented on a couple of minor things below that would be good to fix
(some of them are also reported by Sashiko).

> ---
>  drivers/dma/qcom/bam_dma.c       | 191 +++++++++++++++++++++++++++++++++++++--
>  include/linux/dma/qcom_bam_dma.h |  14 +++
>  2 files changed, 198 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index f3e713a5259c2c7c24cfdcec094814eb1202971a..f08549ee3872eece85884606d6ee9e540ee688ca 100644
> --- a/drivers/dma/qcom/bam_dma.c
> +++ b/drivers/dma/qcom/bam_dma.c
> [...]
> @@ -686,6 +702,35 @@ static int bam_slave_config(struct dma_chan *chan,
>  	return 0;
>  }
>  
> +static int bam_metadata_attach(struct dma_async_tx_descriptor *desc, void *data, size_t len)
> +{
> +	struct bam_chan *bchan = to_bam_chan(desc->chan);
> +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
> +	struct bam_desc_metadata *metadata = data;
> +
> +	if (!data)

Doesn't really matter much, but since the parameter exists you might as
well add

	&& len == sizeof(*metadata)

here to be sure.

> +		return -EINVAL;
> +
> +	if (!bdata->pipe_lock_supported)
> +		/*
> +		 * The client wants to use locking but this BAM version doesn't
> +		 * support it. Don't return an error here as this will stop the
> +		 * client from using DMA at all for no reason.
> +		 */
> +		return 0;
> +
> +	guard(spinlock_irqsave)(&bchan->vc.lock);
> +
> +	bchan->scratchpad_addr = metadata->scratchpad_addr;
> +	bchan->direction = metadata->direction;
> +
> +	return 0;
> +}
> +
> +static const struct dma_descriptor_metadata_ops bam_metadata_ops = {
> +	.attach = bam_metadata_attach,
> +};

I'm not sure if we have discussed this before, but could we avoid
re-programming the scratchpad_addr all the time by placing it into
struct dma_slave_config -> peripheral_config? It still feels awkward to
me to place a global constant configuration value into per-descriptor
metadata.

> +
>  /**
>   * bam_prep_slave_sg - Prep slave sg transaction
>   *
> [...]
> @@ -802,6 +851,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
>  		}
>  
>  		vchan_get_all_descriptors(&bchan->vc, &head);
> +		bchan->bam_locked = false;

I wonder about the implications of this. If the LOCK descriptor was
already processed, will we cause a deadlock if we never submit the
UNLOCK descriptor? Or I guess bam_reset_channel() might reset the lock
as well?

>  	}
>  
>  	vchan_dma_desc_free_list(&bchan->vc, &head);
> [...]
> @@ -870,6 +929,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>  {
>  	u32 i, srcs, pipe_stts, offset, avail;
>  	struct bam_async_desc *async_desc, *tmp;
> +	struct bam_desc_hw *hdesc;
>  
>  	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
>  
> @@ -919,13 +979,20 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>  			 * push back to front of desc_issued so that
>  			 * it gets restarted by the work queue.
>  			 */
> +
> +			list_del(&async_desc->desc_node);
>  			if (!async_desc->num_desc) {
> -				vchan_cookie_complete(&async_desc->vd);
> +				hdesc = async_desc->desc;
> +				u16 flags = le16_to_cpu(hdesc->flags);

Is this unused? Also a bit odd to have hdesc declared outside of the
loop and flags declared inside.

> +
> +				if (async_desc->is_lock_desc)
> +					bam_dma_free_lock_desc(&async_desc->vd);
> +				else
> +					vchan_cookie_complete(&async_desc->vd);
>  			} else {
>  				list_add(&async_desc->vd.node,
>  					 &bchan->vc.desc_issued);
>  			}
> -			list_del(&async_desc->desc_node);
>  		}
>  	}
>  
> @@ -1046,13 +1113,102 @@ static void bam_apply_new_config(struct bam_chan *bchan,
>  	bchan->reconfigure = 0;
>  }
>  
> +static struct bam_async_desc *
> +bam_make_lock_desc(struct bam_chan *bchan, unsigned long flag)
> +{
> +	struct dma_chan *chan = &bchan->vc.chan;
> +	struct bam_async_desc *async_desc;
> +	struct bam_desc_hw *desc;
> +	struct virt_dma_desc *vd;
> +	struct virt_dma_chan *vc;
> +	unsigned int mapped;
> +
> +	async_desc = kzalloc_flex(*async_desc, desc, 1, GFP_NOWAIT);
> +	if (!async_desc) {
> +		dev_err(bchan->bdev->dev, "failed to allocate the BAM lock descriptor\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	sg_init_table(&async_desc->lock_sg, 1);
> +
> +	async_desc->num_desc = 1;
> +	async_desc->curr_desc = async_desc->desc;
> +	async_desc->dir = DMA_MEM_TO_DEV;
> +	async_desc->is_lock_desc = true;
> +
> +	desc = async_desc->desc;
> +
> +	bam_prep_ce_le32(&async_desc->lock_ce, bchan->scratchpad_addr, BAM_WRITE_COMMAND, 0);
> +	sg_set_buf(&async_desc->lock_sg, &async_desc->lock_ce, sizeof(async_desc->lock_ce));
> +
> +	mapped = dma_map_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);

I agree with Sashiko that mapping using the BAM device
(bchan->bdev->dev) would be more precise, since the BAM will be reading
the descriptor. (It doesn't matter in practice since both BAM and
consumer usually have the same IOMMUs defined.)

> +	if (!mapped) {
> +		kfree(async_desc);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
> +	desc->addr = sg_dma_address(&async_desc->lock_sg);

cpu_to_le32()

> +	desc->size = cpu_to_le16(sizeof(struct bam_cmd_element));
> +
> +	vc = &bchan->vc;
> +	vd = &async_desc->vd;
> +
> +	dma_async_tx_descriptor_init(&vd->tx, &vc->chan);
> +	vd->tx.flags = DMA_PREP_CMD;
> +	vd->tx_result.result = DMA_TRANS_NOERROR;
> +	vd->tx_result.residue = 0;
> +
> +	return async_desc;
> +}
> +
> [...]
> @@ -1072,6 +1229,18 @@ static void bam_start_dma(struct bam_chan *bchan)
>  		return;
>  
>  	while (vd && !IS_BUSY(bchan)) {
> +		/*
> +		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
> +		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
> +		 * already have bam_locked set and must not trigger a second pair.
> +		 */
> +		if (!bchan->bam_locked &&
> +		    !container_of(vd, struct bam_async_desc, vd)->is_lock_desc) {

Do we need the ->is_lock_desc check here? Looks redundant to me.

> +			ret = bam_setup_pipe_lock(bchan);
> +			if (ret == 0 && bchan->bam_locked)
> +				vd = vchan_next_desc(&bchan->vc);

Do we want some error handling here? If there is an error, this will
silently continue queuing everything without any locking.

Thanks,
Stephan
