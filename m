Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0821818040;
	Wed, 24 Jul 2024 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721791278; cv=none; b=rbnBQoPesmh4V333pyy5Yd00jd967iq+SdY+NyKyx8muFUPe1fZmP9JgDv1xlDIhtkSlx+2sPyTfbNddhYo/2p4vUtCdY6z3wavwJe0/4aeYHcX+lBfN/x9HAZ85mRDVuhnlqQf8hk+3Vbs8PnhUf10qb4NyGo3w577lwslhDHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721791278; c=relaxed/simple;
	bh=BFuOTls8BjF9nz3Y3p0yZg5UODSyEAXVrFcqihfjIGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHxNzVua+CC9sMjtUed5N52ylLgHvgxm1siq2kc0bbwicdlTJ9iJkpjhRTMdLLGwPcyLUzaRIoVj2cdlkYuz/F7DjF0yDuaGHxr02rM6tBU9ahV21ltoqvTQzoyK9CoXqlWvzYyDSwxCCpqorp46s7T2xvl7Zujx7w6vQoYfJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sWSRU-000Yub-0I;
	Wed, 24 Jul 2024 11:20:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 Jul 2024 11:13:30 +0800
Date: Wed, 24 Jul 2024 11:13:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Bharat Bhushan <bbhushan2@marvell.com>,
	Olivia Mackall <olivia@selenic.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH v1] hwrng: Kconfig - Do not enable by
 default CN10K driver
Message-ID: <ZqBxWgjVIxMOKHb8@gondor.apana.org.au>
References: <20240625195746.48905-1-francesco@dolcini.it>
 <ZoiLd/Cezq2CS4Zp@gondor.apana.org.au>
 <SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com>
 <Zp4CbFEIvgVjgIug@gaggiata.pivistrello.it>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zp4CbFEIvgVjgIug@gaggiata.pivistrello.it>

On Mon, Jul 22, 2024 at 08:55:40AM +0200, Francesco Dolcini wrote:
>
> > Yes, make default if ARCH_THUNDER is true
> 
> Herbert, this patch was merged, do you want a follow-up patch as Bharat wrote
> or you are good with the current status?

Please send me a follow-up patch.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
