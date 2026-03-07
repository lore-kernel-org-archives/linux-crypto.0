Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2517523EA8C;
	Sat,  7 Mar 2026 20:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772915719; cv=none; b=KzKqcNonvvYy/jAgvyZEf07yFg+4j4Pw6IrghVTncRI8uK8QVCPcFH08r7RoABGvFzMMhFzHLNVgL/HEKlV4J2v7M+CJyB3k9X5AIdceadbhqOY/zaGOWCwZ/WiUaXE8LT4HuQiCwWOTKPim1y9VV3AeWA6me+n3fVacSTWZa84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772915719; c=relaxed/simple;
	bh=un14T0IT/vIqcYm6aN8xOLPJnlapIRXG/s+nnWU1kqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwYnNBvwJYXUhK40J0G/hQFD/BjYouuGVsSCqewxFbOX73OKom+r11+DkWHSVq1G/KDTb8lZCv9GPdyeZqDfpKKLNxmjguu2vvxZHmiSFJ44J6ffFnA3weq6b3SYMnBktMwzdcvp89wiJ9ev9KgsFAiAhglBGvap9N72saL5rO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fv3jG6JB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fv3jG6JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E94DC19422;
	Sat,  7 Mar 2026 20:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772915718;
	bh=un14T0IT/vIqcYm6aN8xOLPJnlapIRXG/s+nnWU1kqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fv3jG6JBv75N4xFs3hP3/xuPfMcJfEmgzLxtHA1/0aBvtRCg1GamFg0WRHTl1VfTT
	 W9ACjsPMPLYWQrfKKpz+6uz24D/uggUV0a+0G9qGqtv5eDXbjcm3bCyczwfsOzbdOP
	 1moudz6U3cYKoVxc2nm9W051L9fmJApiixzy3/iWnQ8NojskWhU54NzItkTLcUhX/9
	 OkyRJbjkwRxR0M13mJx9jwEAitNTIM8Tly6TE3Esj1WzMX1soHZcnPHqDwOgw6D5rK
	 pcK3r+cS+o9G3okXQVTUV2ZGxUR50Harvo1UPy8o1XYlAKzJ3RJPlBe4UH5U05MRO6
	 bjn/SKVoRzJFQ==
Date: Sun, 8 Mar 2026 02:05:14 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH RFC v11 07/12] crypto: qce - Communicate the base
 physical address to the dmaengine
Message-ID: <aayMAlkJNxp9h4KO@vaman>
References: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
 <20260302-qcom-qce-cmd-descr-v11-7-4bf1f5db4802@oss.qualcomm.com>
 <aahEMjjBRINXL5zC@vaman>
 <CAMRc=Md2G7k7DGMZv2Du75ososQtsAutw2WwwAQ3WL8pC_-LmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Md2G7k7DGMZv2Du75ososQtsAutw2WwwAQ3WL8pC_-LmQ@mail.gmail.com>

On 04-03-26, 16:05, Bartosz Golaszewski wrote:
> On Wed, Mar 4, 2026 at 3:39 PM Vinod Koul <vkoul@kernel.org> wrote:
> >
> > On 02-03-26, 16:57, Bartosz Golaszewski wrote:
> > > In order to let the BAM DMA engine know which address is used for
> > > register I/O, call dmaengine_slave_config() after requesting the RX
> > > channel and use the config structure to pass that information to the
> > > dmaengine core. This is done ahead of extending the BAM driver with
> > > support for pipe locking, which requires performing dummy writes when
> > > passing the lock/unlock flags alongside the command descriptors.
> > >
> > > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> > > ---
> > >
> > >       dma->txchan = devm_dma_request_chan(dev, "tx");
> > >       if (IS_ERR(dma->txchan))
> > > @@ -121,6 +123,12 @@ int devm_qce_dma_request(struct qce_device *qce)
> > >               return dev_err_probe(dev, PTR_ERR(dma->rxchan),
> > >                                    "Failed to get RX DMA channel\n");
> > >
> > > +     cfg.dst_addr = qce->base_phys;
> > > +     cfg.direction = DMA_MEM_TO_DEV;
> >
> > So is this the address of crypto engine address where dma data is
> > supposed to be pushed to..?
> 
> No. In case I wasn't clear enough in the cover letter: this is the
> address of the *crypto engine* register which we use as a scratchpad
> for the dummy write when issuing the lock/unlock command. Mani
> suggested under the cover letter to use the descriptor metadata for
> that.

This is overloading of address field. If we go this was I would add a
comment in code explaining this and why in the setup the engine does not
need peripheral address. Meta data sounds okay as well.

-- 
~Vinod
