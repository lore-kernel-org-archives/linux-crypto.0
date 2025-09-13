Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F2A29DB64;
	Sat, 13 Sep 2025 04:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737850; cv=none; b=XPkCNx2Osr+W6UuCtlwQoVCYGWMYV95IujuNmyJHYHzzWsbJE5lWcL4PhWkLiRusqYKN/ZcfF1HLc+TQNH/o+u+ZGSCfFZoWnpgLYag8wwDIuhG1+UTn299fiZYoN9virUDF1dynzv9LTzG8OCidWJ/jpfbkoZQ7BGGZ3ERCiII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737850; c=relaxed/simple;
	bh=CXpXhmdsVtvEvrLp+ILD1kPAwb9KAxnc7aOELFxlyI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGeU5V3d3urXUW2xMzQbvPGPcnOLdToVISOND1P/ba0N8jEIAMCOZavsMHeS6QcXgsDDBNBczadISqxzrjzLFv7WzUzr/dJeG3HA8MQj6gByOB7PN6WLg3mPFz8asCsIq2zdaYiCYMDVaSdlloomqN5qpg0/SMFsb0V+Ckq4gFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bKfSdEcK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bKfSdEcK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/fiZw3v58vdstUMKtdorobBRutHLWxPyqp5z873SG2E=; b=bKfSdEcKa6/4m7AmU7WyClIDp2
	ySDJDcXRlddxmx8nWRnFwCaAPpz8cOfPkuxTkj6XAKsVDQAxiMp/q19T/A9YzmNoaZ1PK3xajTXXj
	yPOlac80TYh5+DYUsgV+Qq4aC3AhL2aoznhWC2am4DwBEKgoVxDJnG9gcrPbjDJ2T5tTq7Qv41Ndx
	70vsP45T0Zcx/DIH0mHORijVfN7Ffhbsady6e2ouAKfmUU7RVbhB959nQdtFE9fvus1BExAo6HhcQ
	+rBl3kJcqWK0fJ1NGFcyjbp+C5JcF5kShahIv7o12BAvrGPzZbvYbsDt8XFeH1UJ6hf3b90uhYXRO
	sAitbOrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHev-0053wS-30;
	Sat, 13 Sep 2025 12:30:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:30:42 +0800
Date: Sat, 13 Sep 2025 12:30:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
	Silvano Di Ninno <silvano.dininno@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - double the entropy delay interval for
 retry
Message-ID: <aMTzcmnTAovW_Bw-@gondor.apana.org.au>
References: <20250905101148.212722-1-gaurav.jain@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905101148.212722-1-gaurav.jain@nxp.com>

On Fri, Sep 05, 2025 at 03:41:48PM +0530, Gaurav Jain wrote:
> during entropy evaluation, if the generated samples fail
> any statistical test, then, all of the bits will be discarded,
> and a second set of samples will be generated and tested.
> 
> the entropy delay interval should be doubled before performing the
> retry.
> 
> also, ctrlpriv->rng4_sh_init and inst_handles both reads RNG DRNG
> status register, but only inst_handles is updated before every retry.
> so only check inst_handles and removing ctrlpriv->rng4_sh_init
> 
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> ---
>  drivers/crypto/caam/ctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
