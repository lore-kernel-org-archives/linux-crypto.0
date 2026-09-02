Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A9D259C80;
	Wed,  2 Sep 2026 06:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788329471; cv=none; b=qPOROKSXC5+ieOPsUfFh6Kp5pWwL2w2t9zoCu4oqqKm9Trf+9NJvbQ4UyFG3VfLfcLd4c1RSaaEx8brLDqLaXajKV5rtpVN1XDYmwbfHwGNvsGS9jQW4aJu509VQtrLt/XogPEttjWEuqLDWzO6CqUpPrsAVW0/kXJgfF7SuzWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788329471; c=relaxed/simple;
	bh=pGeV0rjOrcK5PziliThbOKIDAyaEnjt2j+nfxRoIxHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/qcWtvPw7wp+dDYr7BXPbDTAOv4ZEb1cOTqliC9IcaRaITxghMzpSIALK4wkfDwcqco5/ADC/A2GccufZos2Fj941id/sbqBZU5nNz5a2XGQ6wbUamYp2o792r7fUaWj/icsZFcFAWFiNvWI4/BUJbVP7hIkdX8J6BwvzQcpqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Uc7384BP; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Uc7384BP"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id BC64E20223;
	Wed,  2 Sep 2026 08:11:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1788329464;
	bh=1EFui00I9wCrFfnNNQLTULcqRmkQ7y2kFqovYPcpuiY=; h=From:To:Subject;
	b=Uc7384BP5mk+9dyY0aes7EDKvHh7xap0Fc6jB4jVzgYOE+6DH1TO5F9f5NYPaMsep
	 toGlnXcT7sTRyaNCK8Ja0dErXINX/ULDBpXHNiG5PFHZEYFuVOMe5RKRwYZNfjn08/
	 9ChFUC9wHVO2nEm38LiQIG2Fl7xOrlYa4/jXmRxSVcgTfexj4+F9Cn+2m99mLAq80K
	 G6IgxjmJUqqil5Ie+Nh1OLTdfeCmjX2E+oq/oCNR4yAIvNBmSyn1szwPXZXV2G6CFt
	 LQg5qb9Xyoifb/Goa2tG00TxGHMvA6Ydx8C4g+BKJhfntxn0wobOViMkIc2ZlsyGUc
	 YYk2B9HYSdmGw==
Date: Wed, 2 Sep 2026 08:10:59 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>,
	Emanuele Ghidoli <ghidoliemanuele@gmail.com>
Subject: Re: [PATCH] crypto: caam: map job ring registers without claiming
 region
Message-ID: <20260902061059.GA7187@francesco-nb>
References: <20260901203736.13248-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901203736.13248-1-rosenp@gmail.com>

+ Emanuele

On Tue, Sep 01, 2026 at 01:37:36PM -0700, Rosen Penev wrote:
> devm_platform_ioremap_resource() ends up calling request_mem_region(),
> which fails with -EBUSY on i.MX SoCs:
> 
> There the job rings are modelled as sub-regions of their parent
> fsl,sec-v4.0 register window, and caam_probe() already reserves the
> whole window exclusively via devm_of_iomap() before the children are
> populated.  Every job ring therefore collides with its own parent and
> fails to probe, taking the hardware RNG offline (seen on i.MX6, i.MX7
> and i.MX8 boards such as colibri-imx7 and verdin-imx8mp).
> 
> Map the job ring registers with devm_ioremap() instead, which does not
> claim the (already owned) region.
> 
> Fixes: 9a955c0a7d11 ("crypto: caam - simplify probe resource and IRQ handling")
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Reported-by: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
Closes: https://lore.kernel.org/lkml/20260901194524.908240-1-ghidoliemanuele@gmail.com/

Thanks,
Francesco

