Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317583C5823;
	Thu,  9 Jul 2026 19:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626726; cv=none; b=ODeXpDlKUALqwu4UxlsbhGKxq7P3YDJxTomGDLKeGXwNIZt3rRnzF6CtWJ7WsBCGgabl872UMo4h35sC6mmSEHHp6ChzxIPBGYAFmWdfoAo8I0TEiQ+ObLDY+YU7NrlMmd1btuPC/95rxTiRnoH4fx+aXJtoX0JfiVTevK5Kv/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626726; c=relaxed/simple;
	bh=CRPaV1YmbzKWbZJtG24RiPNCZS/Y2w8pTojZ5EHiWV0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=etysHW5GFz07stI34phdi58vXFkNDudJf/v+Csc1lPxvWRvtymWqEWtwL5HVZTU+TdBmOLQetPtMWmXJKbVo/XjfApnGI4N3Os4pegbukacVrEDFr5EQJag9diiZga3MZ3rKN5pEloVsamrvrC44JvNtHIDmJg3MWdL9p31IyV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2EkifLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2EkifLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847051F00A3A;
	Thu,  9 Jul 2026 19:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783626724;
	bh=lcOeZjQ1Y6NqCwb7DExMzSG3PRvuO4awJLokV768DDQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=S2EkifLAg5Vb/F4xGBkmYhaBJDuKem8xeb/s+2BBHrtqfj48ztECd0b0dtDbQqK1j
	 D+w5+l2qQVV5aUepaSkDOQsG29C7qnGPdK79ZEb0YVbD1YEW+UNXKIltN5YBMT4EPV
	 FcPSNTgXRpJ/eAj3R9RcOE4lwhl2tfTphskwzM2O2HC04/mr1QseGM7v4LlZ4GGq2a
	 5zwlZAeP42X8xSmgqNjtfhwHxfE9J9pjrvbWi07T1Hly6CpBQtZbfplLpIjCEKHqVh
	 P1nGdAO6CsjxXvbR9aYLMB1+77MRyvT3L+iIg+Mq1P0nclzyyeBjIF2EWu959z3kfb
	 l8rUmv/qTxJLw==
Date: Thu, 9 Jul 2026 14:52:03 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Frank.Li@oss.nxp.com
Cc: Vinod Koul <vkoul@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
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
	imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v7 3/9] PCI: endpoint: pci-epf-test: Use
 dmaenigne_prep_config_single() to simplify code
Message-ID: <20260709195203.GA874193@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521-dma_prep_config-v7-3-1f73f4899883@nxp.com>

On Thu, May 21, 2026 at 11:32:49AM -0400, Frank.Li@oss.nxp.com wrote:
> From: Frank Li <Frank.Li@nxp.com>
> 
> Use dmaenigne_prep_config_single() to simplify code.

s/dmaenigne/dmaengine/ both in subject and commit log.
