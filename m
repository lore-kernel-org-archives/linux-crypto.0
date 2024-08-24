Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D09376E9;
	Sat, 24 Aug 2024 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507418; cv=none; b=YW02LI9G7eRjIoODCvUqp856CfcMznqNMrMUjaH8PzUXzi9YFD4Lt2RYe4aB4LKrpofEaztBP6ohXy5w9mtPby8kArzwBhvZeZvOXJMfpYnWmP/BbylJpr52ThD8Yf9JIUTqpCz25z1ERM2I/ni7A0oBGd7nhIyHsTUeLqT7vwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507418; c=relaxed/simple;
	bh=8F5WEVZ+MUblM27ypMljXaGMxzPsiBC9lUQ0QNnDMlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8N3nich10xpHS//YYgjxuTpjIXP6+ronVDMIR5/HB6pr9taF8IUvkSecCLuph2vzuP8a39xVD2A8MLh34m1g2RoK5p7CqUsPdFR2GLdhkpUKEAZ/oCFKdDeyBMRDGYNt5NvAQ/7Yf4beyk2hsVVvrV6l9czDSsVEoV7u8S+iIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shr19-00721A-1t;
	Sat, 24 Aug 2024 21:50:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:50:08 +0800
Date: Sat, 24 Aug 2024 21:50:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Bhoomika K <bhoomikak@vayavyalabs.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: Re: [PATCH 0/3] crypto: spacc - Fix Smatch issues
Message-ID: <ZsnlEIliMPBNxsVP@gondor.apana.org.au>
References: <b47b6e7a-dd63-4005-9339-edb705f6f983@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b47b6e7a-dd63-4005-9339-edb705f6f983@stanley.mountain>

On Thu, Aug 15, 2024 at 12:11:46AM +0300, Dan Carpenter wrote:
> Fix a couple off by ones, and a minor style nit.
> 
> Dan Carpenter (3):
>   crypto: spacc - Fix bounds checking on spacc->job[]
>   crypto: spacc - Fix off by one in spacc_isenabled()
>   crypto: spacc - Add a new line in spacc_open()
> 
>  drivers/crypto/dwc-spacc/spacc_core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
