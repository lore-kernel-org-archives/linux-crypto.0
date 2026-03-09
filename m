Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCD1393DF6;
	Mon,  9 Mar 2026 11:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773054303; cv=none; b=NPlDBY6SkMx+qpe2butY10nE4GMXvzuoN/WzZe6CJiokHR644F9GHURVW/iASA0fAfz45gG4ntApuhXgoTOPPyjmeN+ANQ2K4AgmAYZzh4DAuml0TvVBdXLR4pPzvUnukvg9Vkzibq226fNMfas+JjMarH/aT4dRCQV9dyvNhaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773054303; c=relaxed/simple;
	bh=wEz8Ozl7d1i2Iil0NevpMKFEd8sHrDQan1sUFVnc2jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLKd74oD416GqXwbJWBVniLm32tACnPnbjtx8jO++7RbQKxrWOncVLHMpy/oXBv+fdqBU2Bj7KxPTrG+V6fPHYrY/88i7YsC971K3IATorY+uf24+6zz+dFrJUrjAP3gQ0uvgdssaysoae5UqwFEPulHv7diCMrRes0f5JXHXPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXIOX4YT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXIOX4YT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6435C4CEF7;
	Mon,  9 Mar 2026 11:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773054303;
	bh=wEz8Ozl7d1i2Iil0NevpMKFEd8sHrDQan1sUFVnc2jY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lXIOX4YTIHM87gvY4gOrptvS37DMMvPE1iDdRiW0VDS+X9LpNC1KxxZ+qWSOOkWU7
	 RgJsIjAvzv8p4ooQtA0D45b1dlQGZ1MbUN6T1Un2cjJ17JMUYFmaaZKOItIdYGCPrt
	 J9FNMn0WlSxn0w0D2zzhpSD1dtXG025bcG/J+IFLBht9EIn4w/xj78dt6UMkUkN2J6
	 VDJrjG7fwuJ3btdrXogdNq2lZTs0OWIPPd0pJYZoSjkPCoJt/m6Qv/fOHBZVVGcF6j
	 asZXADR3ahoAmxn6AxQAisPLrDwvDvCNJF8n4E4Xy8SVMnhD/s4QjANpLPnp2TBhvv
	 xjkSaeQDoyosw==
Date: Mon, 9 Mar 2026 12:04:59 +0100
From: Vinod Koul <vkoul@kernel.org>
To: Frank Li <Frank.Li@nxp.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Koichiro Den <den@valinux.co.jp>, Niklas Cassel <cassel@kernel.org>,
	dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org,
	mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	imx@lists.linux.dev
Subject: Re: [PATCH v2 1/8] dmaengine: Add API to combine configuration and
 preparation (sg and single)
Message-ID: <aa6pW-zpxnrZnfPn@vaman>
References: <20251218-dma_prep_config-v2-0-c07079836128@nxp.com>
 <20251218-dma_prep_config-v2-1-c07079836128@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218-dma_prep_config-v2-1-c07079836128@nxp.com>

On 18-12-25, 10:56, Frank Li wrote:
> Previously, configuration and preparation required two separate calls. This
> works well when configuration is done only once during initialization.
> 
> However, in cases where the burst length or source/destination address must
> be adjusted for each transfer, calling two functions is verbose and
> requires additional locking to ensure both steps complete atomically.
> 
> Add a new API dmaengine_prep_config_single() and dmaengine_prep_config_sg()
> and callback device_prep_config_sg() that combines configuration and
> preparation into a single operation. If the configuration argument is
> passed as NULL, fall back to the existing implementation.
> 
> Add a new API dmaengine_prep_config_single_safe() and
> dmaengine_prep_config_sg_safe() for re-entrancy, which require driver
> implement callback device_prep_config_sg().

Okay to add API

> +	struct dma_async_tx_descriptor *(*device_prep_config_sg)(
> +		struct dma_chan *chan, struct scatterlist *sgl,
> +		unsigned int sg_len, enum dma_transfer_direction direction,
> +		unsigned long flags, struct dma_slave_config *config,
> +		void *context);

Do we want to have drivers implement one more callback. It does not make
sense to me. Why not handle this in framework and have it call the
respective lower level APIs.

Drivers should implement simple apis and collectively the functionality
can come from the framework.

Would you consider revising as such. Bonus all existing drivers can
start using this API, no change required for drivers in that case


-- 
~Vinod
