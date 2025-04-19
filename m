Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198EE442C;
	Sat, 19 Apr 2025 04:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745035653; cv=none; b=FxnVOaDhcP+3/XY8jFXCFWuMje1urGoKfELTMZd8gpgHlfqnSyy1OpIoKMluGwM1IGu+NyQqnruBiFsLchf4jB+1YXRn+KpjQi6Ua1O402ngJLSWiz5c/IDI+lKRUrq9UsfPAa2rafiVsJ7KXn7Um75C8xK5VTtWwPWOlf8nYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745035653; c=relaxed/simple;
	bh=MeNpYcii+z/9qvY4laMUGSacOn2mzr2peaP6b1KTfjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pLUNIY9mVZdJ5qdp9Tan7X9Pr8yTyWuP70ZnFczLfzicwaZvU/ecy6AHc0lkFRS/0Jrxu/k5tsjSZ5mboLczDs3A/tMonccnw0098NPJoodV2M4wix8PcPqW7z4EhMG3RJQCMON2CsOBixH/XCy74cPS7mgxVlRG0EWM9QbO0G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fpEMYrW4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fpEMYrW4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mGOL1PpCjzxYDOyt68iLzxOF7neGzcJzaEFed48nI64=; b=fpEMYrW4F3s5PLFL/Ef9G1NbgQ
	QQyoMzDUPfQuWxEFTTf6xkxvAW7+Vh98b5rCfmot6EC24KjxAzsgN5qJiRSPxMcFTTf6EEPTh5hk0
	R1l9nY2TeLw4TAqfvF1juHCWtYI7As6qp88q7FIV0xZBKKHNzcVZSlkUJcgWT5aPbe80JxIj4sbvQ
	8CEDqH/I6mSZUb6WHaZ/M+/wnquNzEJ0zEBbRluNbjhhu42Ybyzm/DaRSHWWjZXiafojk034Zcuf2
	TzKdOtuahJkcbECreTpBBHQ3OCvl30fhVInYzjS6gSPubNgHjjl/Yl3Ky0PCSrd/vndzaaU9ryjJL
	VQKzWDeQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5zTl-00Guwx-2S;
	Sat, 19 Apr 2025 12:06:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Apr 2025 12:06:57 +0800
Date: Sat, 19 Apr 2025 12:06:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Akhil R <akhilrajeev@nvidia.com>, davem@davemloft.net,
	thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	Dragan Simic <dsimic@manjaro.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Tegra Security Engine driver improvements
Message-ID: <aAMhYaq0Ze-z6E8q@gondor.apana.org.au>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
 <D99QMGBHHYJO.1D7D0ZXJLBG9Y@cknow.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D99QMGBHHYJO.1D7D0ZXJLBG9Y@cknow.org>

On Fri, Apr 18, 2025 at 01:45:23PM +0200, Diederik de Haas wrote:
> 
> Earlier today I tried to boot my 6.15-rc1 kernel on my RockPro64
> (rk3399) and that didn't go too well:

This should be fixed in the latest mainline kernel where hash
request chaining has been disabled.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
