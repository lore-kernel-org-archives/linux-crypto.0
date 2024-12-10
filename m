Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054E8226160;
	Tue, 10 Dec 2024 05:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809737; cv=none; b=mV9OXUAIhhmATTJVRyZDAQF8eAGhSr15Xm9UJi/1SUqonq5g5ur9rWVONk24hJNs+Viu0ZlVolGugnUY0uxuBeCAk5mPvYXb5rqLLeCgvt32MvRqRfA/y0MxE2aMY2tiTzdHRyJrlCtuPKSfuo78sy1s1CcQlchRaZeZjZwe/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809737; c=relaxed/simple;
	bh=6B3lZ9bhRa/+q6VHtQH5Gc4XXUMpXqlSKgFori1WCjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWW89BHwqmmEjzC1SYMTT7+ZCd69EvawdVDZr26ZtALOdbmFh8X+wBdaI6jGqc+k/wXPINxmz21uLJ5C3mW6/5RT56ocgYEYMEZkBtUVVsIvuW2hpQiVwUZG4s/kcJBu9PDPtZmXRKQhXYf+9AE038bmgLqkES+1fJGFWbsZLIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JolYQIU5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JolYQIU5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3GhPs9PiDKMSC1ncLVXLvSDCQB2BM9kc0mIj6LHDqsY=; b=JolYQIU5+3/Ofak9+yHEw/rfnw
	YYt3E7ukQPV0eZ8Ja6wmJR20UBXbLYXGxhxIx4nTsWu6XR2I4k2IeYax3BIWN0OM6WClNkheVUJtL
	rT7N2G0zaoVNgmhSARitJiMCj/co6mvZhLpnx2Uu3GkTd0JegvAMawJ9WALPPm1Qjcu+Mii+I+TTY
	p7yeM8xDIPDx2UnaLSb0EiIdCOSjQbXTOyCM14Am4r9VMu3MEiFw9k9srOdnK6VLk/sAOn7U7uS/W
	d7nC29yvIF5JoaFYknZgPqCMh4Ioejlr1GhVlm78FxAmANdlcnFaHQzqMNLT60DniPxGCG0IzcfAX
	N3DLJ8QA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKsu3-000ODV-1g;
	Tue, 10 Dec 2024 13:48:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 13:48:44 +0800
Date: Tue, 10 Dec 2024 13:48:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	"David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>,
	Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Nikolaus Voss <nikolaus.voss@haag-streit.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2] crypto: caam - use JobR's space to access page 0 regs
Message-ID: <Z1fWPNKq3PdcESY3@gondor.apana.org.au>
References: <20241126064607.456633-1-gaurav.jain@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126064607.456633-1-gaurav.jain@nxp.com>

On Tue, Nov 26, 2024 at 12:16:07PM +0530, Gaurav Jain wrote:
> On iMX8DXL/QM/QXP(SECO) & iMX8ULP(ELE) SoCs, access to controller
> region(CAAM page 0) is not permitted from non secure world.
> use JobR's register space to access page 0 registers.
> 
> Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is insecure")
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> ---
> 
> changes in v2
> Updated commit message with SoCs details on which CAAM page 0 is not
> accessible from non secure world.
> 
>  drivers/crypto/caam/blob_gen.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
