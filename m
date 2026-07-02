Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58553FCC;
	Thu,  2 Jul 2026 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005975; cv=none; b=QP1UXDBgXsqG3riNMlFmB3te/AFZ+0/ggqNKTD0nBfG6T145q8Gkh5V5mZLP5kaQOPwYfplVZl5QqWOu1nREiHc96hAa3UXyk4LiECclW1AL/XnJuOg1XtAR22Ql65Lti0TFtljxbUzNoXumcphDBqaZBAweR3xY/b0y8dMt5Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005975; c=relaxed/simple;
	bh=P1huFSkBxlDWmM9Bex8x2Kh++bjeHpt6f165uZxIRCg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EwAGB4LaUZQeLz4mu7kBK7l5f1WLfRFA04gXWtX7X5bz75b8w5GTt3QONQ/HJzvZ/Od3H/Hx/3b6Sbv/0UKF7Me7/nQ2lZ84/luOFcZ0WRWPkaY/VJD6PSfLj58o65oMbmGaAjv+Zcf8MpGeJWUBX0KDtTwmdL7jJt5rlAQngLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlT93tZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlT93tZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BD81F000E9;
	Thu,  2 Jul 2026 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005974;
	bh=7unR8yvtQ9taeigaG7HqsXFuVB10+E437UJK7eQF5HI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VlT93tZX0KmWBgfzHBqYA6MZ4OVnMILicDuEgMwbD85mP+D8HPdzDcbfd7yUvqSu7
	 pGFQ+VWyujHb9OvJX9VniLR9X363fkZ3vSck5JSYJ1kzbeq9j4r8LDR/JAKR9xEAU2
	 xbSC92vIliVCwzZIbkQQmB6tdN/W6h4rVlm7nGj3XTLaZngZacN4tDYMywvu/c77Xy
	 Nb1cBIy3LV93hMVbeySsB8bOcrwdBPLSHhRUowj+/YS+AaSKszuXcHDgz3qb1ArKTn
	 dLVcBR0f80h8DG+EGDxcAjXukhVn4mDrkKAPY8NoC6kYNSqdWfKdhE83NXE6AfVcG6
	 /O7PTlSQORlnA==
From: Vinod Koul <vkoul@kernel.org>
To: Manivannan Sadhasivam <mani@kernel.org>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Nicolas Ferre <nicolas.ferre@microchip.com>, 
 Alexandre Belloni <alexandre.belloni@bootlin.com>, 
 Claudiu Beznea <claudiu.beznea@tuxon.dev>, Koichiro Den <den@valinux.co.jp>, 
 Niklas Cassel <cassel@kernel.org>, Frank.Li@oss.nxp.com
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, 
 mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260521-dma_prep_config-v7-0-1f73f4899883@nxp.com>
References: <20260521-dma_prep_config-v7-0-1f73f4899883@nxp.com>
Subject: Re: [PATCH v7 0/9] dmaengine: Add new API to combine configuration
 and descriptor preparation
Message-Id: <178300596742.727083.5865685817987530958.b4-ty@kernel.org>
Date: Thu, 02 Jul 2026 20:56:07 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


On Thu, 21 May 2026 11:32:46 -0400, Frank.Li@oss.nxp.com wrote:
> Previously, configuration and preparation required two separate calls. This
> works well when configuration is done only once during initialization.
> 
> However, in cases where the burst length or source/destination address must
> be adjusted for each transfer, calling two functions is verbose.
> 
> 	if (dmaengine_slave_config(chan, &sconf)) {
> 		dev_err(dev, "DMA slave config fail\n");
> 		return -EIO;
> 	}
> 
> [...]

Applied, thanks!

[1/9] dmaengine: Add API to combine configuration and preparation (sg and single)
      commit: 796bdb33e86aec8504bf8868e0665f120638ac72
[2/9] dmaengine: Add safe API to combine configuration and preparation
      commit: af900b7dc1e1cdac571ac38e7fee80f1a1776a62
[3/9] PCI: endpoint: pci-epf-test: Use dmaenigne_prep_config_single() to simplify code
      commit: 9605825841061bbdd2fc2a0218098373c539173e
[4/9] dmaengine: dw-edma: Use new .device_prep_config_sg() callback
      commit: bfb66d8098dbbaaada3ab877eda21cd447115c95
[5/9] dmaengine: dw-edma: Pass dma_slave_config to dw_edma_device_transfer()
      commit: 1af246e9d222f93aee59f3b47ff3bd59d08725e7
[6/9] nvmet: pci-epf: Remove unnecessary dmaengine_terminate_sync() on each DMA transfer
      commit: bd00d2c4a1b2a1e7ad3060d3d606fb4c9db6a064
[7/9] nvmet: pci-epf: Use dmaengine_prep_config_single_safe() API
      commit: a0fba0a49f77effd3962723b1fa14c766fbc0ec4
[8/9] PCI: epf-mhi: Use dmaengine_prep_config_single() to simplify code
      commit: 53191cc449db1cf4f25db275978c61b1c6aaeba9
[9/9] crypto: atmel: Use dmaengine_prep_config_sg() API
      commit: c9e9927c6d8346cdf6555a8f97da093980172e4b

Best regards,
-- 
~Vinod


