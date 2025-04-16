Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44EE1C8638;
	Wed, 16 Apr 2025 07:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790197; cv=none; b=gS6kkNgKoAXuXCf/4ARpUgnvax/cM3z32VNzz2vAjtdGBySbG+3p3EnNoScqO17yGv654Kc33dVhkyoz3dkenIMPkaldz2SEXaAZ8pXWkfWh/wfpVYMQIQsY11GaGSbENAYTiqnz4R2+Wx98qINQGe+IB2W1qU+DkmNuuXWcw+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790197; c=relaxed/simple;
	bh=fp6eE8ZqL20jC0+BoM3aFhzzI/5ntqguPRZm6/i1+L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxzHCnNKdNwUaL6v9VkgSZJ5/apJ0MdMW1Ip44mKjzvoz/L3HpVGpSd8qfiWXtmQeAnYPYsYRdjlFzJaeyGocUPHMbEYJnIcsHjbjvQFOAsKJnNsByIbADib0R7YD5tJtOPINybYhuIhyDLlZRitc06nY50XMyFT1h/zzliXaQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZWvfpDFW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZWvfpDFW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/RBFcl3P+Pfb/orFpm2E8rOiWF+UgkCZE+vHJPIvhes=; b=ZWvfpDFWZx3BCnhuaoXBZOGL1o
	6LcM4bz60WRivIVW10ML3rZMQm4jzJFTIXJZMf0jtDSiZZpjSH/ZnPFHnbcnysF7fT5t4gviyJvak
	rqG7nPJJ0NSg/7s7d07P+g4u/CXRS/ftH1jM5IOrcsvxDOMttmMsIgxZrUOotoEfSc7C3T3KAj1zp
	8GW+d7Uv0KjhopEdCIncowIXhoELWDsmF/2TovCzj0sbSCohiJLRiU2JGVfAw1R2OqE9pP3Alj/DW
	z4k0xfVbqwR5M0A/qDRVw7iQc4TXTSgLilY69QMSqlQd/HmpDYXSIKevatqzqV35bn2Ze12LBb5x1
	bUevi/uA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xdB-00G7rM-1K;
	Wed, 16 Apr 2025 15:56:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:56:25 +0800
Date: Wed, 16 Apr 2025 15:56:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Richard <thomas.richard@bootlin.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: Add support for i.MX8QM
Message-ID: <Z_9iqaNoP1IFqebg@gondor.apana.org.au>
References: <20250407-imx8qm-caam-support-v1-1-181cf01a14ec@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407-imx8qm-caam-support-v1-1-181cf01a14ec@bootlin.com>

On Mon, Apr 07, 2025 at 07:33:14PM +0200, Thomas Richard wrote:
> On i.MX8QM, caam clocks are turned on automatically and Linux does not have
> access to the caam controller's register page, so skip clocks
> initialization.
> 
> Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
> ---
>  drivers/crypto/caam/ctrl.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
