Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E807543932C;
	Thu,  9 Jul 2026 05:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783575828; cv=none; b=J6cqVpVfQnbzLtQuLE7wDETTubkNuLrShdDq0XwBtLPfkuWacATdUTFIPV/e/Q+WCSoOOAr2cuphHeWtXgRHs3NnRMmGhivW71455WHdTsXGgvyuy4g/3yKWpL9KiDoQNx8eYy0ijLtpr0FwZ9y3ZTsBQKxWQ1acdtEVWLBTkIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783575828; c=relaxed/simple;
	bh=c/7Wj6PdrlZXC2hh+OdKcA0brKNMahmYbkopRZsSj4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSyI5CHFr6sr9wle9ITTkCmdtm1fXavm5qFbQHV2CtdSUkHUrZSZEd6XTNHkQRNwpyyjbvvhhMWT7Cn2Wd1ClrEmi3WoriHjRmdgHF808PNzBRRMpPga/qySEdn+IaevZqBsucUj2AAkE/b9jbAI7scTOYQbPr2Z1VJz6HYAE6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzMErqn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzMErqn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAF51F000E9;
	Thu,  9 Jul 2026 05:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783575826;
	bh=qiRZlu+pN9UCQWPo2SujBtFWkDfJIgfryKRGlCH9SOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BzMErqn7H0tBQWhIwwL6cUV+PjYiwddzfMugre75ZSIDqZBCLeCqXrYojO2boVY6m
	 WEHqDK9+AFssKNWzeZSrEXx6ZE8pGP7XrpR/kzxGx0xXXBHhVlVk05mMLjuZx3AN3q
	 nFwms3UbgAZTz7CoZQfvH1PiOO0qS3P/j07senEZR/5mIK9KDJT3xrUlGAfo+o5Pzk
	 P9PlZ9QqFsr4ZtFXhvfxdyJmNot3XsN9XOSspEw0RmfmQP+oJ0IKP8AK6VLS+VFyh4
	 9hMocZ0tLgRbX3AucUK107XcluYsLU4ZDIC+IANdz7E7zD6WbZ1KA6LiNnn/ZYB3C4
	 F7pcOoylRdyqw==
Date: Thu, 9 Jul 2026 07:43:19 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, 
	"Vaibhaav Ram T . L" <vaibhaavram.tl@microchip.com>, Kumaravel Thiagarajan <kumaravel.thiagarajan@microchip.com>, 
	Even Xu <even.xu@intel.com>, Xinpeng Sun <xinpeng.sun@intel.com>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Jiri Kosina <jikos@kernel.org>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
	Longfang Liu <liulongfang@huawei.com>, Vinod Koul <vkoul@kernel.org>, Lee Jones <lee@kernel.org>, 
	Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, 
	Sunil Goutham <sgoutham@marvell.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>, Oded Gabbay <ogabbay@kernel.org>, 
	Maciej Falkowski <maciej.falkowski@linux.intel.com>, Karol Wachowski <karol.wachowski@linux.intel.com>, 
	Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
	Andreas Noever <andreas.noever@gmail.com>, Mika Westerberg <westeri@kernel.org>, 
	Will Deacon <will@kernel.org>, Xinliang Liu <xinliang.liu@linaro.org>, 
	Tian Tao <tiantao6@hisilicon.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Srujana Challa <schalla@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	Antoine Tenart <atenart@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Raag Jadav <raag.jadav@intel.com>, Hans de Goede <hansg@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, 
	Andi Shyti <andi.shyti@kernel.org>, Robert Richter <rric@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Nirmal Patel <nirmal.patel@linux.intel.com>, 
	Kurt Schwemmer <kurt.schwemmer@microsemi.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, 
	Tomasz Jeznach <tomasz.jeznach@linux.dev>, Jonathan Cameron <jic23@kernel.org>, 
	Ulf Hansson <ulfh@kernel.org>, Shawn Lin <shawn.lin@rock-chips.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Benjamin Tissoires <bentiss@kernel.org>, 
	linux-input@vger.kernel.org, linux-i3c@lists.infradead.org, dmaengine@vger.kernel.org, 
	Philipp Stanner <phasta@kernel.org>, netdev@vger.kernel.org, nic_swsd@realtek.com, 
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-usb@vger.kernel.org, 
	iommu@lists.linux.dev, linux-riscv@lists.infradead.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, linux-cxl@vger.kernel.org, 
	linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	linux-serial@vger.kernel.org, mhi@lists.linux.dev, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Jan Dabros <jsd@semihalf.com>, linux-i2c@vger.kernel.org, 
	Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, 
	linux-spi@vger.kernel.org, Jonathan Derrick <jonathan.derrick@linux.dev>, 
	linux-pci@vger.kernel.org, linux-gpio@vger.kernel.org, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: (subset) [PATCH 0/37] PCI/MSI: Enforce explicit IRQ vector
 management by removing devres auto-free
Message-ID: <vb3ywnzdult3h3bzvh2m6ye5xcuxuzvufcsp4kdos6g2a4q6tn@5ut3kgguaey6>
References: <1771860581-82092-1-git-send-email-shawn.lin@rock-chips.com>
 <178357565325.731734.7291964273199898845.b4-ty@b4>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178357565325.731734.7291964273199898845.b4-ty@b4>

On Thu, Jul 09, 2026 at 07:40:53AM +0200, Manivannan Sadhasivam wrote:
> 
> On Mon, 23 Feb 2026 23:29:39 +0800, Shawn Lin wrote:
> > This patch series addresses a long-standing design issue in the PCI/MSI
> > subsystem where the implicit, automatic management of IRQ vectors by
> > the devres framework conflicts with explicit driver cleanup, creating
> > ambiguity and potential resource management bugs.
> > 
> > ==== The Problem: Implicit vs. Explicit Management ====
> > Historically, `pcim_enable_device()` not only manages standard PCI resources
> > (BARs) via devres but also implicitly triggers automatic IRQ vector management
> > by setting a flag that registers `pcim_msi_release()` as a cleanup action.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [13/37] bus: mhi: host: Replace pci_alloc_irq_vectors() with pcim_alloc_irq_vectors()
>         commit: 256995e80fcd39cab94eee8135dd90f6da6ac744
> 

Sorry, this is a mistake. This patch is not applied.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
