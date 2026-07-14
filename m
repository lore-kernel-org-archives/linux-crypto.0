Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8D339F16B;
	Tue, 14 Jul 2026 12:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031082; cv=none; b=PZ+b2KPmy4JTFZIYMM4vblhCcL96SdHtCncyHd3M+/gWFObti2z/PNQCDJA2HTlz+fm/d9+rJU6Jffz/keAEBH38hBn/47qEhMEgeK3HkEQrAbSk2I04nplfVlghHInAW/YRbGLHaLiCyPYaDYJa2e1sTalVhVTI3v+d5FNqhbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031082; c=relaxed/simple;
	bh=bb3djj0fZ+30tt25Nowh80ILINn4nn8130Kw2SRrtW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDF7Jq6cFzczTGIgzgazLepLkKRsT1vEA2Pj7LE+JzJZvDgWervFrxVwQT4FCWxbSX8FSPgZCFDTeeFcDESPj86lSQfEhX96AzufQReNG5zkMYOSbfjW6vaK9iF/ckBsYAXpKmuVOjvJOj+vpoeaGWEHpYwJ5db42oE1g1odZi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSJLzUZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSJLzUZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401061F000E9;
	Tue, 14 Jul 2026 12:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031077;
	bh=eiFPBn1tbYiWnXsgsAeerc+9XoO81Qyg9ewXiIEgCIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mSJLzUZ1u4So/jNeJG3gQdyMRyt76jnISJCj95cssU5cPktGnVw0pZzi0wUI1BV8h
	 ZH1RYmG6WUXAld29tnNWXxcdZI1ND3WLQr3l3iA0OkCL1qTj8WsLgIDWkes6dg+wju
	 uAJu9/IMZPwkyuSXvXUfuidGWD7Y0nKFNuH5PGEbnAUzp72tNR7hSN4hJObGu7H0XK
	 yHdJXNL9PoReWtbdiXpN++LWC6GSlYCO3L23cFqTTy3Sy85XKZSpWcBd0SyJAdx3o6
	 Ub6SXF6/hO5yJ5rtgQZjJkXAOLO7fPJ0JeVw+CFhwTpcluT1yG76US3bCqvBL5IQZD
	 Y1syx3MaHkDoQ==
Date: Tue, 14 Jul 2026 17:41:13 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Frank.Li@oss.nxp.com, Manivannan Sadhasivam <mani@kernel.org>,
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
Message-ID: <alYnYY0DHl3qi5T6@vaman>
References: <20260521-dma_prep_config-v7-3-1f73f4899883@nxp.com>
 <20260709195203.GA874193@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709195203.GA874193@bhelgaas>

On 09-07-26, 14:52, Bjorn Helgaas wrote:
> On Thu, May 21, 2026 at 11:32:49AM -0400, Frank.Li@oss.nxp.com wrote:
> > From: Frank Li <Frank.Li@nxp.com>
> > 
> > Use dmaenigne_prep_config_single() to simplify code.
> 
> s/dmaenigne/dmaengine/ both in subject and commit log.

Yeah I had fixed while applying

-- 
~Vinod
