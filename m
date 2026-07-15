Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E723C2BB4
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126606; cv=none; b=EWc7Ew2hoAJv6nqQDPb7viTk/8KCX4zRgIJO2tNvcP+9D14Lt3Yttn8wEzGrkAOij6QG0yILV4Tlrq0ry15AUBwgHljNnaZA3MJbvM5VA6j7O6Ic/8CrzLD2fhlvbO+7JOWH5a/gXFbbvi304MWA92tkKVAfI1LGINlHMr2hFWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126606; c=relaxed/simple;
	bh=X68c1nYcCWv51v8mSTJWPYgBW9OqZPEcLkd+ji0RP3s=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ol2O2o8GTMGvyTyZS67DyAffU4q0UZSIduxZ1PF7SIybknBIEq/rLOvmGFUuG1f3Ki37bIpuQ4wBJqa5pTDuSnEamvYWb/LITBUJEdIvFlT0+K76EW6ygoQzvkzzLQkk1sQ9HRV349DbE8yIRt/HXsLBY6ALgCyMW/Sc4lHEptY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDOeV5yc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDOeV5yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D86D1F0155A
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784126605;
	bh=mexSkd/L7M+JcqMlYSpV/uW631x4GMkwLLLY8A/EWBA=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=ZDOeV5ycp3foMgCcNX9Z+3ELyYPAxIObDsdGg1YjY8Hl2ZHIYqvb/fWhlioqKp1dC
	 hbHqECScHSZ9M/uAiofWtjItzDAgIFZWSuebPrEqQqqIcXvi3VHoxCF/P4QcZlDP+n
	 oNUkLOXKxyporwe966ny5RtpqPJN9MdIZ0XFhACGRqA2m2J9sGUk8AyLb3H/xcMW8o
	 7mEAVa2SRpwrt+ryieuM4FZg0SgdI9iIW/4+dgAM9TYUVHRjecJV+9GFiQhP2Pps8F
	 8Hw1gHVgjXGNY5yLic7rx0PGd7mDfCqX2lVo4pCG3KoCS7fMvg7j21BHIg9If8zpR2
	 RXyUpImiQlMxA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b00d083818so693688e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 07:43:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr8oiDdKgNlbN41QpYq/bAYnHPpw7V7PLihwIZ1uMhzdam7oWJhP7zi1ByRVfGHepAvv0WkeM99hrzXGYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfN817UfXG1Erc+4ctb9D3kt47yJvXcomhpR6vqwr0CA5hYMP1
	IU7TcFSKazwfzMs3bNWxf626Pyx3xowrs5Po8HeQkpZpB4NAigfKMXHWRTkbOjby7+acvfvo6/4
	C07czKo0D3QX+kcUUzIWRBg6sxO2wgxcu4dIvp3cpBQ==
X-Received: by 2002:a05:6512:230e:b0:5b0:1186:fdf with SMTP id
 2adb3069b0e04-5b023d119b6mr4054246e87.11.1784126603717; Wed, 15 Jul 2026
 07:43:23 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jul 2026 14:43:21 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jul 2026 14:43:21 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <alYGGu7_3G6mJAzQ@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
 <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com> <alYGGu7_3G6mJAzQ@linaro.org>
Date: Wed, 15 Jul 2026 14:43:21 +0000
X-Gmail-Original-Message-ID: <CAMRc=MevqXga1u-XC8LYc3hnjjzmdESntsSGYP25XECeeySfJA@mail.gmail.com>
X-Gm-Features: AUfX_mz84E27Q1EUpA_PNW8nZwsEDXDnWfdcPZvHlIEcElHMR4d25WVPlOXxIfA
Message-ID: <CAMRc=MevqXga1u-XC8LYc3hnjjzmdESntsSGYP25XECeeySfJA@mail.gmail.com>
Subject: Re: [PATCH v21 06/14] dmaengine: qcom: bam_dma: add support for BAM locking
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@codeaurora.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, dmaengine@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, brgl@kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Jul 2026 11:49:14 +0200, Stephan Gerhold
<stephan.gerhold@linaro.org> said:
> On Mon, Jul 13, 2026 at 03:01:07PM +0200, Bartosz Golaszewski wrote:
>> Add support for BAM pipe locking. To that end: when starting DMA on an RX
>> channel - prepend the existing queue of issued descriptors with an
>> additional "dummy" command descriptor with the LOCK bit set. Once the
>> transaction is done (no more issued descriptors), issue one more dummy
>> descriptor with the UNLOCK bit.
>>
>> We *must* wait until the transaction is signalled as done because we
>> must not perform any writes into config registers while the engine is
>> busy.
>>
>> The dummy writes must be issued into a scratchpad register of the client
>> so provide a mechanism to communicate the right address via descriptor
>> metadata.
>>
>> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>
> Thanks for the fixes. The lock/unlock sequence looks good to me now,
> I commented on a couple of minor things below that would be good to fix
> (some of them are also reported by Sashiko).
>

Thanks.

>> ---
>>  drivers/dma/qcom/bam_dma.c       | 191 +++++++++++++++++++++++++++++++++++++--
>>  include/linux/dma/qcom_bam_dma.h |  14 +++
>>  2 files changed, 198 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
>> index f3e713a5259c2c7c24cfdcec094814eb1202971a..f08549ee3872eece85884606d6ee9e540ee688ca 100644
>> --- a/drivers/dma/qcom/bam_dma.c
>> +++ b/drivers/dma/qcom/bam_dma.c
>> [...]
>> @@ -686,6 +702,35 @@ static int bam_slave_config(struct dma_chan *chan,
>>  	return 0;
>>  }
>>
>> +static int bam_metadata_attach(struct dma_async_tx_descriptor *desc, void *data, size_t len)
>> +{
>> +	struct bam_chan *bchan = to_bam_chan(desc->chan);
>> +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
>> +	struct bam_desc_metadata *metadata = data;
>> +
>> +	if (!data)
>
> Doesn't really matter much, but since the parameter exists you might as
> well add
>
> 	&& len == sizeof(*metadata)
>
> here to be sure.
>

Ok.

>> +		return -EINVAL;
>> +
>> +	if (!bdata->pipe_lock_supported)
>> +		/*
>> +		 * The client wants to use locking but this BAM version doesn't
>> +		 * support it. Don't return an error here as this will stop the
>> +		 * client from using DMA at all for no reason.
>> +		 */
>> +		return 0;
>> +
>> +	guard(spinlock_irqsave)(&bchan->vc.lock);
>> +
>> +	bchan->scratchpad_addr = metadata->scratchpad_addr;
>> +	bchan->direction = metadata->direction;
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct dma_descriptor_metadata_ops bam_metadata_ops = {
>> +	.attach = bam_metadata_attach,
>> +};
>
> I'm not sure if we have discussed this before, but could we avoid
> re-programming the scratchpad_addr all the time by placing it into
> struct dma_slave_config -> peripheral_config? It still feels awkward to
> me to place a global constant configuration value into per-descriptor
> metadata.
>

Yes, this was discussed several versions ago. I went with using
dmaengine_slave_config() until v11. I think Vinod or Dmitry requested we change
it to the metadata.

>> +
>>  /**
>>   * bam_prep_slave_sg - Prep slave sg transaction
>>   *
>> [...]
>> @@ -802,6 +851,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
>>  		}
>>
>>  		vchan_get_all_descriptors(&bchan->vc, &head);
>> +		bchan->bam_locked = false;
>
> I wonder about the implications of this. If the LOCK descriptor was
> already processed, will we cause a deadlock if we never submit the
> UNLOCK descriptor? Or I guess bam_reset_channel() might reset the lock
> as well?
>

I'll look into it.

>>  	}
>>
>>  	vchan_dma_desc_free_list(&bchan->vc, &head);
>> [...]
>> @@ -870,6 +929,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>>  {
>>  	u32 i, srcs, pipe_stts, offset, avail;
>>  	struct bam_async_desc *async_desc, *tmp;
>> +	struct bam_desc_hw *hdesc;
>>
>>  	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
>>
>> @@ -919,13 +979,20 @@ static u32 process_channel_irqs(struct bam_device *bdev)
>>  			 * push back to front of desc_issued so that
>>  			 * it gets restarted by the work queue.
>>  			 */
>> +
>> +			list_del(&async_desc->desc_node);
>>  			if (!async_desc->num_desc) {
>> -				vchan_cookie_complete(&async_desc->vd);
>> +				hdesc = async_desc->desc;
>> +				u16 flags = le16_to_cpu(hdesc->flags);
>
> Is this unused? Also a bit odd to have hdesc declared outside of the
> loop and flags declared inside.
>
>> +
>> +				if (async_desc->is_lock_desc)
>> +					bam_dma_free_lock_desc(&async_desc->vd);
>> +				else
>> +					vchan_cookie_complete(&async_desc->vd);
>>  			} else {
>>  				list_add(&async_desc->vd.node,
>>  					 &bchan->vc.desc_issued);
>>  			}
>> -			list_del(&async_desc->desc_node);
>>  		}
>>  	}
>>
>> @@ -1046,13 +1113,102 @@ static void bam_apply_new_config(struct bam_chan *bchan,
>>  	bchan->reconfigure = 0;
>>  }
>>
>> +static struct bam_async_desc *
>> +bam_make_lock_desc(struct bam_chan *bchan, unsigned long flag)
>> +{
>> +	struct dma_chan *chan = &bchan->vc.chan;
>> +	struct bam_async_desc *async_desc;
>> +	struct bam_desc_hw *desc;
>> +	struct virt_dma_desc *vd;
>> +	struct virt_dma_chan *vc;
>> +	unsigned int mapped;
>> +
>> +	async_desc = kzalloc_flex(*async_desc, desc, 1, GFP_NOWAIT);
>> +	if (!async_desc) {
>> +		dev_err(bchan->bdev->dev, "failed to allocate the BAM lock descriptor\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	sg_init_table(&async_desc->lock_sg, 1);
>> +
>> +	async_desc->num_desc = 1;
>> +	async_desc->curr_desc = async_desc->desc;
>> +	async_desc->dir = DMA_MEM_TO_DEV;
>> +	async_desc->is_lock_desc = true;
>> +
>> +	desc = async_desc->desc;
>> +
>> +	bam_prep_ce_le32(&async_desc->lock_ce, bchan->scratchpad_addr, BAM_WRITE_COMMAND, 0);
>> +	sg_set_buf(&async_desc->lock_sg, &async_desc->lock_ce, sizeof(async_desc->lock_ce));
>> +
>> +	mapped = dma_map_sg(chan->slave, &async_desc->lock_sg, 1, DMA_TO_DEVICE);
>
> I agree with Sashiko that mapping using the BAM device
> (bchan->bdev->dev) would be more precise, since the BAM will be reading
> the descriptor. (It doesn't matter in practice since both BAM and
> consumer usually have the same IOMMUs defined.)
>

Ok

>> +	if (!mapped) {
>> +		kfree(async_desc);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	desc->flags |= cpu_to_le16(DESC_FLAG_CMD | flag);
>> +	desc->addr = sg_dma_address(&async_desc->lock_sg);
>
> cpu_to_le32()
>

Right.

>> +	desc->size = cpu_to_le16(sizeof(struct bam_cmd_element));
>> +
>> +	vc = &bchan->vc;
>> +	vd = &async_desc->vd;
>> +
>> +	dma_async_tx_descriptor_init(&vd->tx, &vc->chan);
>> +	vd->tx.flags = DMA_PREP_CMD;
>> +	vd->tx_result.result = DMA_TRANS_NOERROR;
>> +	vd->tx_result.residue = 0;
>> +
>> +	return async_desc;
>> +}
>> +
>> [...]
>> @@ -1072,6 +1229,18 @@ static void bam_start_dma(struct bam_chan *bchan)
>>  		return;
>>
>>  	while (vd && !IS_BUSY(bchan)) {
>> +		/*
>> +		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
>> +		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
>> +		 * already have bam_locked set and must not trigger a second pair.
>> +		 */
>> +		if (!bchan->bam_locked &&
>> +		    !container_of(vd, struct bam_async_desc, vd)->is_lock_desc) {
>
> Do we need the ->is_lock_desc check here? Looks redundant to me.
>

I don't remember anymore but I think I did it on purpose for some reason. I'll
double check.

>> +			ret = bam_setup_pipe_lock(bchan);
>> +			if (ret == 0 && bchan->bam_locked)
>> +				vd = vchan_next_desc(&bchan->vc);
>
> Do we want some error handling here? If there is an error, this will
> silently continue queuing everything without any locking.
>

Ok, makes sense.

Bart
