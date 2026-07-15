Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B633E8333;
	Wed, 15 Jul 2026 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784129811; cv=none; b=b1+ll1zGOCKs23/o5Qp/29RAPqtHmXQpMu6P2NYJ06g0xlssm/fmqgUxZNT+SgYpxmxuZZH46UQ8/jS03NQIgBl5kWWRCh2QBRIMWmdYyFOw7jB/+6iViLipuo+Kx34aMzqbf+62gKe4zbsptCxHcD+ZVHQCyODdf3DRPsfsPww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784129811; c=relaxed/simple;
	bh=PkXT5SsF9P8wtCiUKr4ybimXB0ryCIgHrwUQJzGxDzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWHqvpVhOEJd/9Z4GKDT6ACqb3koaIu2O5Sv5M07/azw130uxmlFUP0NQ+RC9r03a/t8vTNc0rkxjf63XcssDVAMR3ioMAL+VpZqIZS3prCoAK9ymM+w1X+7zdVrbYPjRoLVKOsWVMnamVe9jsvi7I3DLmF/zsmAB06DKsbcmPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VygLZc03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VygLZc03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23151F000E9;
	Wed, 15 Jul 2026 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784129809;
	bh=yY805taQCjgb03o/s8e5sUsofMrXtbd/rx03espmDQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VygLZc03gz4xzJm+budUdm3rStKb6PFBOhsNxZQM0yXDPX70SIhaMelOv+5f3H8lb
	 pz+OAsnmghx1L8QzstPAAnTqU2ML9N0M1WCURhWu8ijlIU8hYokpic9Uz3Z38vAbJC
	 nsDnoKDLvjJr4/9iF9OmcTfcu+6ty2BYIm5j8MrxKXtr9RjRvg4QoCPurf+DSoyMEf
	 KMvGIB80Ah1I93Ea1E6CZuXWzeVXDhudJGlkugb4+3Sx+zXQJTp/KAYXWOhp8g7Ril
	 1wgbs3E9xuwpTHv2W3J6wljq31KKn/5B2ySg0h5+b/BH7lzt7RuUgdJqjdCh1oZtLx
	 ieD241T8ApPLw==
Date: Wed, 15 Jul 2026 21:06:46 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Stephan Gerhold <stephan.gerhold@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <alepDnRJmRLbFGRQ@vaman>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
 <20260713-qcom-qce-cmd-descr-v21-6-bc2583e18475@oss.qualcomm.com>
 <alYGGu7_3G6mJAzQ@linaro.org>
 <CAMRc=MevqXga1u-XC8LYc3hnjjzmdESntsSGYP25XECeeySfJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MevqXga1u-XC8LYc3hnjjzmdESntsSGYP25XECeeySfJA@mail.gmail.com>

On 15-07-26, 14:43, Bartosz Golaszewski wrote:
> On Tue, 14 Jul 2026 11:49:14 +0200, Stephan Gerhold
> <stephan.gerhold@linaro.org> said:
> > On Mon, Jul 13, 2026 at 03:01:07PM +0200, Bartosz Golaszewski wrote:
> >> Add support for BAM pipe locking. To that end: when starting DMA on an RX
> >> channel - prepend the existing queue of issued descriptors with an
> >> additional "dummy" command descriptor with the LOCK bit set. Once the
> >> transaction is done (no more issued descriptors), issue one more dummy
> >> descriptor with the UNLOCK bit.
> >>
> >> We *must* wait until the transaction is signalled as done because we
> >> must not perform any writes into config registers while the engine is
> >> busy.
> >>
> >> The dummy writes must be issued into a scratchpad register of the client
> >> so provide a mechanism to communicate the right address via descriptor
> >> metadata.
> >>
> >> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> >> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> >
> > Thanks for the fixes. The lock/unlock sequence looks good to me now,
> > I commented on a couple of minor things below that would be good to fix
> > (some of them are also reported by Sashiko).
> >
> 
> Thanks.
> 
> >> ---
> >>  drivers/dma/qcom/bam_dma.c       | 191 +++++++++++++++++++++++++++++++++++++--
> >>  include/linux/dma/qcom_bam_dma.h |  14 +++
> >>  2 files changed, 198 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> >> index f3e713a5259c2c7c24cfdcec094814eb1202971a..f08549ee3872eece85884606d6ee9e540ee688ca 100644
> >> --- a/drivers/dma/qcom/bam_dma.c
> >> +++ b/drivers/dma/qcom/bam_dma.c
> >> [...]
> >> @@ -686,6 +702,35 @@ static int bam_slave_config(struct dma_chan *chan,
> >>  	return 0;
> >>  }
> >>
> >> +static int bam_metadata_attach(struct dma_async_tx_descriptor *desc, void *data, size_t len)
> >> +{
> >> +	struct bam_chan *bchan = to_bam_chan(desc->chan);
> >> +	const struct bam_device_data *bdata = bchan->bdev->dev_data;
> >> +	struct bam_desc_metadata *metadata = data;
> >> +
> >> +	if (!data)
> >
> > Doesn't really matter much, but since the parameter exists you might as
> > well add
> >
> > 	&& len == sizeof(*metadata)
> >
> > here to be sure.
> >
> 
> Ok.
> 
> >> +		return -EINVAL;
> >> +
> >> +	if (!bdata->pipe_lock_supported)
> >> +		/*
> >> +		 * The client wants to use locking but this BAM version doesn't
> >> +		 * support it. Don't return an error here as this will stop the
> >> +		 * client from using DMA at all for no reason.
> >> +		 */
> >> +		return 0;
> >> +
> >> +	guard(spinlock_irqsave)(&bchan->vc.lock);
> >> +
> >> +	bchan->scratchpad_addr = metadata->scratchpad_addr;
> >> +	bchan->direction = metadata->direction;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct dma_descriptor_metadata_ops bam_metadata_ops = {
> >> +	.attach = bam_metadata_attach,
> >> +};
> >
> > I'm not sure if we have discussed this before, but could we avoid
> > re-programming the scratchpad_addr all the time by placing it into
> > struct dma_slave_config -> peripheral_config? It still feels awkward to
> > me to place a global constant configuration value into per-descriptor
> > metadata.

The concept is that a dmaengine can handle multiple peripherals, so the
peripheral is always per desciptor

> Yes, this was discussed several versions ago. I went with using
> dmaengine_slave_config() until v11. I think Vinod or Dmitry requested we change
> it to the metadata.

metadata seems better fit for this.

> >>  /**
> >>   * bam_prep_slave_sg - Prep slave sg transaction
> >>   *
> >> [...]
> >> @@ -802,6 +851,7 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
> >>  		}
> >>
> >>  		vchan_get_all_descriptors(&bchan->vc, &head);
> >> +		bchan->bam_locked = false;
> >
> > I wonder about the implications of this. If the LOCK descriptor was
> > already processed, will we cause a deadlock if we never submit the
> > UNLOCK descriptor? Or I guess bam_reset_channel() might reset the lock
> > as well?

Good point

-- 
~Vinod
