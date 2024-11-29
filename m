Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BEE13D62B;
	Fri, 29 Nov 2024 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732891726; cv=none; b=PnXIVuJ1FPynEjPzxd/juuQ9kZwWX3L1cNZhYgvOL8KmgocvOpiBYbWi1beUPMS7ciVsnF7SWvs11oere007qpe0paoMJYj05VHuV0YDLOt7aTxRXjZ3dGDjKyGjWwBE/sQp/zE4OF+hTGJid0LGw3May+xqep4ibl++QBTHqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732891726; c=relaxed/simple;
	bh=Tiz2B5jXTprDgzZE35cPt7dUjmF+troZo9TTgtqgxLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQZARKsF3STDfNzM+Gn53em5dtrnGY+99/L7P23qsZjDHDiU7NQPHJ9Nl1Jn0aQdamV3paAtoiiUm27M1a799NkKMmqRSCgDtJytGMVn9xGvZY8qeBsOsgWAvoL1Xw1CvnsGRlDKEvixaHC1DjtdYCgiO4wulE72Jd0cATmlY2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AhmV5Z7F; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AhmV5Z7F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GEWl5NVp3Zv83iWj9bU6X1qy5XOxznJ93A6A+/FFGhY=; b=AhmV5Z7F/ToAYqv5RufiP09NfG
	afv4pCnyay4GpC7IEN/4viHZzNKNU7r2yzrXQDUPUCcgR6B9ZO8xx9VezvmBVjvlswObTlKzDOWiB
	pRxgjSFe4SVzvWRuxnPTVlIkPXXjCZWLklPpsqiPWWaFz+Rc/Bp3O867V3nrB6mfdhs+Pt3wnNMS+
	TqEnNa+8pgXAC1HP54COBAfTEYVw2rDNIeArXWxE6P0WuzAumvCrB0Jo2lDC06wOKpx6EUrtERIvZ
	3BpW7toHYd+m9t3QskPeREIhhAZsjyvcyThdBjxm1+xCn+K11XQXg0sLvYZp38mArwJfF3UWWLmg5
	WreXg2Fw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tH2IL-002PW5-1E;
	Fri, 29 Nov 2024 22:48:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Nov 2024 22:48:33 +0800
Date: Fri, 29 Nov 2024 22:48:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: davem@davemloft.net, dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 2/2] s390/crypto: New s390 specific protected key hash
 phmac
Message-ID: <Z0nUQQ9E32xq0SY4@gondor.apana.org.au>
References: <20241129111059.303905-1-freude@linux.ibm.com>
 <20241129111059.303905-3-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129111059.303905-3-freude@linux.ibm.com>

On Fri, Nov 29, 2024 at 12:10:58PM +0100, Harald Freudenberger wrote:
>
> +static inline int phmac_keyblob2pkey(const u8 *key, unsigned int keylen,
> +				     struct phmac_protkey *pk)
> +{
> +	int i, rc = -EIO;
> +
> +	/* try three times in case of busy card */
> +	for (i = 0; rc && i < 3; i++) {
> +		if (rc == -EBUSY && msleep_interruptible(1000))
> +			return -EINTR;

You can't sleep in an ahash algorithm either.  What you can do
however is schedule a delayed work and pick up where you left
off.  That's how asynchronous completion works.

But my question still stands, under what circumstances can
this fail? I don't think storage folks will be too happy with
a crypto algorithm that can produce random failures.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
