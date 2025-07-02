Received: from mail-m16.yeah.net (mail-m16.yeah.net [1.95.21.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522192367B3;
	Wed,  2 Jul 2025 08:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=1.95.21.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751445586; cv=none; b=pFA56LyExn7O7G85cLU01ZhxqqaSGJVsU0/lCsXQQDWvTji2a06W0SmvB2UNhiyaw6NxAVYnHM/ip6wZ/MXniODPHPpYN1wHXsGoepYO0kAvKDDG06/uln5EU0qDLJiTT3/vwmPGT+COo+qSTaxEPu7wi//kJA3DTf0bBmT8TRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751445586; c=relaxed/simple;
	bh=h69eKJGK22OdLLw+KLex6FL443o3ymPTOdqDKgsyu2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eo7LUMy7MezAGhtyUkhEQhiHvvIkxQMRG4RDhY/BZ0JAMMTXBbrz5MBO0brBcxYLNkq+pmJzoPbKohMq2JxkF8lp5nJlKjjLO7YpHW2C0GSITPDdHVagTh/a+P22al2CA2ZtyuwMvQdEfy4LoikCh4OSz27/9Q4vPwULVt9y3dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=eNEcCmTp; arc=none smtp.client-ip=1.95.21.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="eNEcCmTp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=bt7kRNitnRRomL12XcgnkgtBgNnfGJgLPobysScsIdU=;
	b=eNEcCmTpKvsNznW2z72kTSHm/x8r/H5RnC6X9E5eszrzz7BzwCkQIwRnQpc3Jt
	sZ+HdxhwUSfJxnvSLSoOfV8LGZMtn3nzjbvIH6KEQwsiDvY6LfbWnPITx1ypNfea
	LEYanzNaQGBqt9UBxlWwfbKTKjx5MxMQu/cHIUBuSL/Es=
Received: from dragon (unknown [])
	by gzsmtp3 (Coremail) with SMTP id M88vCgDHz8oW8GRohq0NAA--.9535S3;
	Wed, 02 Jul 2025 16:38:49 +0800 (CST)
Date: Wed, 2 Jul 2025 16:38:46 +0800
From: Shawn Guo <shawnguo2@yeah.net>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Message-ID: <aGTwFl911B0W6PKu@dragon>
References: <20250611113748.2986988-1-john.ernberg@actia.se>
 <20250611113748.2986988-5-john.ernberg@actia.se>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250611113748.2986988-5-john.ernberg@actia.se>
X-CM-TRANSID:M88vCgDHz8oW8GRohq0NAA--.9535S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4fJw4xJrykWFyDAryfCrg_yoWxCwc_Z3
	WxJw10vw4rGFWxJa15Ga1fXr1rKay5Gr45WrZ0vwsxGas0vFWxKrykJrZaq3y09wsFvF9x
	AF18t3yUu343ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjX18PUUUUU==
X-CM-SenderInfo: pvkd40hjxrjqh1hdxhhqhw/1tbiCwF+ZWhk3sY-3gAAsk

On Wed, Jun 11, 2025 at 11:38:09AM +0000, John Ernberg wrote:
> From: Horia Geantă <horia.geanta@nxp.com>
> 
> The iMX8QXP and iMX8QM have a CAAM (Cryptographic Acceleration and
> Assurance Module) like many other iMXs.
> 
> Add the definitions for it.
> 
> Job Rings 0 and 1 are bound to the SECO (Security Controller) ARM core
> and are not exposed outside it. There's no point to define them in the
> bindings as they cannot be used outside the SECO.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> Reviewed-by: Peng Fan <peng.fan@nxp.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>

Applied, thanks!

