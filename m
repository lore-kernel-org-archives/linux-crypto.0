Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B544239AD34
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784131604; cv=none; b=QcKT5RFjLojTBC+hWBmZevXPXhLX6IN1A5hfgLyNXRUh9QlgGzWaq3MDYB0nxfiNRJPZAFxWTsXj8tA3m+83gdGe0LS+AUgHCF+NZQnVlIDuBfrwePJRNkQiDBcblHakBn5LZ26OqO1WBU5RBZxxTV4yH07Rb6u6fTPZhG2DWG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784131604; c=relaxed/simple;
	bh=uPscrPb3ETPjEhpObEhVsTsiQn+HK7qL2dKRijNuK8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Og7u/gZzg7shAUkuLYhpAo+YhKoH97HtKJR0Ain67qh14yAJpO+bOSqr6Cy/VE3ClIOO1sJbaES/iZsTUS8qPVVwPakL47Z59wiUXYcVx62/7TbOx426ldTCh0SFufZ71FXMhYeIngKmrDtFoif2uM8+iejpBjmABO/7kCJ0s8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L/w6819Y; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L/w6819Y"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493f0ae9572so23421315e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 09:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784131597; x=1784736397; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+lQdKSmRz9WhvxdTzt01CBN7vUfgGKc2JFY2x/IMYok=;
        b=L/w6819YpG6zvtVivauQzoTlUu6iQhFmqBRoilsZiSCK9bQvK1uS8A/r3QjmXYY5X5
         8otN79COhU6MBjKpOKi/nSGDsbCB9LLJH28m4/mcZMrj3YpPvOA7QVcupTn0PGQyKq6D
         vN858PP+vcd0qcMtE2qcT2ubcCLikN4tLHztdwbikYKNsuz2VWnurQs4Rr66qVsFzZdQ
         s863zaiNwAqGKK22Qk+pG/SNajH4cjlZhXLbJBI9YpME7bAEwJa+KsEmJWJQKkStSixp
         M7KlZK7lNe6Q62rXbRcJ2vH7K64axATViboGvAJWgRiTzEGtbLM/dx4XZrAJCRywWZi3
         F9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784131597; x=1784736397;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+lQdKSmRz9WhvxdTzt01CBN7vUfgGKc2JFY2x/IMYok=;
        b=nZUP365QQ9tUd2U/RWoMgSJDEfqMog4gSs/3Qsp0sh34xj0dwPvzzuz2cBdFXiBOzX
         Bjjn6RqB3yyYM3HeptM1+D5mWPX72uOKT+oiu0K7+uSK+X3zXeqL5btJRjvXCulCZrNv
         JrELEwyrK3R/DLZ1hAfht+sFfRzdMUikJW5YBXInMsAnul1kY7nM+gj6v7CP5XpANTHm
         5+FiriuGs6abAJMQIFwZsj8gRJdTDWa/KyE/F+R6O7VlvNl7cnUifOnIVFKL+TxA8k+R
         3v6R3zXZ8+X4aiY/RNaSjx5tLKXOaenB6O99rZFXi+h+/vEbJxLihB7YvWgGAP0VZx1E
         hpUA==
X-Forwarded-Encrypted: i=1; AHgh+RrumgNlhxdi+H39XOmZr3SPSTAgmymfvwYaorSf5rV6apxnkevvB8EDx0Y+Pcj3Qdb59rlLySHJxM86ZmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHp4LBfgDvd/b9OjduGFfEtJDPzi2toNW7W2Tj6qitCjKh0PR1
	Jl7uwdZnW4uLAmYYhERACTuw2IVbLxUBz+ZuGRtnSkMcePt8BU8F4XedwPCukMQDeQw=
X-Gm-Gg: AfdE7clqy8Hmr4JWIM5a3vfGX7UD7JP9vKnW+70ZB0mKdJpoP9geTOY4LrmjZgARWLA
	T9zq60Zc8t+3YddJr12jB/PLzt1M5G1ljgz3AXM6ffx4PhgRZMJzeWM2XYp+BPDCANE3qVN6JT3
	S+7QDZQQI3p9SLoMpqxISxBapp4jdGPRS9+mdqvWPiU42IQ9P1LhRpRZBewbRl8lQtCRuVyp8SX
	dk2Oc8wwdXlG4QY5+PG5dkwDUseIfTENuv2hf9QCqKA//5U+tQDzXCUYJVywV74qJk3Z6Pvy69H
	k1QymkucBubEIG2/iP9EBIDyvCljPcpd1f2c0DGdSFDLt5zZF2pYm8P+Irfogwfnj0sgWKikcpw
	j5n8VlwE21rfJGz8fGKqrTM3WMj2Qjz33b+M4QaEDfd6OhZNVnqmQ3q3Vr/EyeIfNwd1SKBCk9+
	6OTRPaj6Lt4o9RwxpYpMFsVNm0MBVl84KkTDk=
X-Received: by 2002:a05:600c:8b6d:b0:495:3fc4:81b4 with SMTP id 5b1f17b1804b1-495403fcaadmr9759685e9.30.1784131597440;
        Wed, 15 Jul 2026 09:06:37 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:d62b:a557:d06c:e9ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a32a2casm232743795e9.12.2026.07.15.09.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 09:06:36 -0700 (PDT)
Date: Wed, 15 Jul 2026 18:06:27 +0200
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Vinod Koul <vkoul@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v21 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <alewA9ubkYKHpnuj@linaro.org>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
 <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com>
 <alYGGu7_3G6mJAzQ@linaro.org>
 <CAMRc=MevqXga1u-XC8LYc3hnjjzmdESntsSGYP25XECeeySfJA@mail.gmail.com>
 <alepDnRJmRLbFGRQ@vaman>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alepDnRJmRLbFGRQ@vaman>

On Wed, Jul 15, 2026 at 09:06:46PM +0530, Vinod Koul wrote:
> On 15-07-26, 14:43, Bartosz Golaszewski wrote:
> > On Tue, 14 Jul 2026 11:49:14 +0200, Stephan Gerhold
> > <stephan.gerhold@linaro.org> said:
> > > On Mon, Jul 13, 2026 at 03:01:07PM +0200, Bartosz Golaszewski wrote:
> > >> Add support for BAM pipe locking. To that end: when starting DMA on an RX
> > >> channel - prepend the existing queue of issued descriptors with an
> > >> additional "dummy" command descriptor with the LOCK bit set. Once the
> > >> transaction is done (no more issued descriptors), issue one more dummy
> > >> descriptor with the UNLOCK bit.
> > >>
> > >> We *must* wait until the transaction is signalled as done because we
> > >> must not perform any writes into config registers while the engine is
> > >> busy.
> > >>
> > >> The dummy writes must be issued into a scratchpad register of the client
> > >> so provide a mechanism to communicate the right address via descriptor
> > >> metadata.
> > >>
> > >> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> > >> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> > [...]
> > >> ---
> > >>  drivers/dma/qcom/bam_dma.c       | 191 +++++++++++++++++++++++++++++++++++++--
> > >>  include/linux/dma/qcom_bam_dma.h |  14 +++
> > >>  2 files changed, 198 insertions(+), 7 deletions(-)
> > >>
> > >> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> > >> index f3e713a5259c2c7c24cfdcec094814eb1202971a..f08549ee3872eece85884606d6ee9e540ee688ca 100644
> > >> --- a/drivers/dma/qcom/bam_dma.c
> > >> +++ b/drivers/dma/qcom/bam_dma.c
> > >> [...]
> > >> @@ -686,6 +702,35 @@ static int bam_slave_config(struct dma_chan *chan,
> > >>  	return 0;
> > >>  }
> > >>
> > >> +static int bam_metadata_attach(struct dma_async_tx_descriptor *desc, void *data, size_t len)
> > >> +{
> > >> +	struct bam_chan *bchan = to_bam_chan(desc->chan);
> > >> +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
> > >> +	struct bam_desc_metadata *metadata = data;
> > >> +
> > >> +	if (!data)
> > >
> > > Doesn't really matter much, but since the parameter exists you might as
> > > well add
> > >
> > > 	&& len == sizeof(*metadata)
> > >
> > > here to be sure.
> > >
> > 
> > Ok.
> > 
> > >> +		return -EINVAL;
> > >> +
> > >> +	if (!bdata->pipe_lock_supported)
> > >> +		/*
> > >> +		 * The client wants to use locking but this BAM version doesn't
> > >> +		 * support it. Don't return an error here as this will stop the
> > >> +		 * client from using DMA at all for no reason.
> > >> +		 */
> > >> +		return 0;
> > >> +
> > >> +	guard(spinlock_irqsave)(&bchan->vc.lock);
> > >> +
> > >> +	bchan->scratchpad_addr = metadata->scratchpad_addr;
> > >> +	bchan->direction = metadata->direction;
> > >> +
> > >> +	return 0;
> > >> +}
> > >> +
> > >> +static const struct dma_descriptor_metadata_ops bam_metadata_ops = {
> > >> +	.attach = bam_metadata_attach,
> > >> +};
> > >
> > > I'm not sure if we have discussed this before, but could we avoid
> > > re-programming the scratchpad_addr all the time by placing it into
> > > struct dma_slave_config -> peripheral_config? It still feels awkward to
> > > me to place a global constant configuration value into per-descriptor
> > > metadata.
> 
> The concept is that a dmaengine can handle multiple peripherals, so the
> peripheral is always per desciptor
> 
> > Yes, this was discussed several versions ago. I went with using
> > dmaengine_slave_config() until v11. I think Vinod or Dmitry requested we change
> > it to the metadata.
> 
> metadata seems better fit for this.
> 

Modelling this as descriptor metadata is really misleading. You call
dmaengine_desc_attach_metadata() on a specific descriptor, but then the
bam_metadata_attach() above just writes it globally into

desc->chan (struct dma_chan) -> to_bam_chan() (struct bam_chan)
-> bchan->scratchpad_addr

The descriptor that you pass in is completely unused. If you call this
on a different descriptor later with a different value, it will just
change the global configuration for the previous descriptor as well (if
they are submitted together). It will always be like this, since it's
the entire channel (and descriptor sequence) that is locked and not an
individual descriptor.

dmaengine_slave_config() operates directly on the struct dma_chan, so it
is IMO the right place to add this. That makes it clear that this
configures something for the entire channel.

I don't think that breaks support for multiple peripherals connected to
a single BAM (dmaengine). A BAM pipe (channel) should always belong to a
single peripheral. And even if it belongs to multiple peripherals, we
still need a single "scratchpad_addr" to use for the lock/unlock
sequence.

I would avoid using struct dma_slave_config->dst_addr (like in v11) [1]
though, since it's more a "address to dummy register" now than the
actual dst_addr of the peripheral. That's why I suggested
struct dma_slave_config->peripheral_config.

Thanks,
Stephan

[1]: https://lore.kernel.org/linux-arm-msm/20260302-qcom-qce-cmd-descr-v11-7-4bf1f5db4802@oss.qualcomm.com/
