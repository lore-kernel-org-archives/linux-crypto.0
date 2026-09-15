Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5CE43E4BA
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451133; cv=none; b=hU0oanMEoWfuhN7bMboPn2vVjXwVp/WuiGw1M9FXORM2Q2z8eg0QijbHPvQ8dpenqD5X6GX5CgXWbdag0+uHnmvHtHZbIgt1SlUB1zE5PVkzueOcHt0acW1ENIqhhDE6AzcJJf6OGgZvZghvlIpU+QpMXw4OVZ8fUFS7RQC1ERc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451133; c=relaxed/simple;
	bh=DS7z9s+rtl31asGAawcmvn2Qu8pVRtb+uquTq8L2fxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSDWxdb7+Vj3GenygLwRPLoAs8mEzDOSbEM6aOHbbmIOoLN3pQ85h+J3n/6G25MbMPPBilEmg8quGNnvVh6IM8uh2bnhQh18T3DDbyW6UDQsaTx5TFg9KSbnfasujm1MlDv+jzu9Yxe7/2KhG5ykhzVLsCppWFFb87+2c9qePA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DcY9i9/M; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DcY9i9/M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/BSe0N7xDFxxEDqDejFgIwwWqt/hTYd31y0KxFxLW34=; 
	b=DcY9i9/MKUdvvdIjP6iHRrCITiRY4AvYlv4uE3ClpTxMSyrUBdCzv2gdZ/spOKWcOihxOq5eHyy
	jyWsSMFIbUAVp9+8IFLVarFkcsMmr/SXZc+C+NUJ+QGU4/8Vgo137F/dfYXfF7TXoxq4GyrmZOGim
	c9JJaVEgnUbUMgoDviA03aLTDv5TtPmMkDj+z3S1RR6lHxaQ45DyWocB3NrxEMLNxfom5O4zJDD3h
	/NSkD7iUy7R+Z3n7qY9hTNZKfeNke0CR5DUU/fYiI4usD9uEgtF0Yf8xvXQS4II83IV+0NxuiFDfG
	XkcsvWgeuDsH75OAvABbaS+yM6m+BshP0GcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6Lyu-0000000E5dH-24vX;
	Tue, 15 Sep 2026 13:45:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Sep 2026 15:45:24 +1000
Date: Tue, 15 Sep 2026 15:45:24 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqjbdBJsVemZW7bo@gondor.apana.org.au>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
 <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
 <aqfJgFY73ZYtFJmH@strlen.de>
 <aqfPeIDmYPI8-ZTb@gondor.apana.org.au>
 <aqgKwiRQ5oz-Mwc-@strlen.de>
 <aqjOTzlY6acaOaTg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjOTzlY6acaOaTg@gondor.apana.org.au>

On Tue, Sep 15, 2026 at 02:49:19PM +1000, Herbert Xu wrote:
>
> Please also change the added mutex_lock calls to mutex_lock_nested
> with depth 1:
> 
> 	mutex_lock_nested(&ht->mutex, 1);
> 
> I forgot about Neil's recent change to lockdep depths when writing
> this.

Actually please leave it alone because the nested stuff is buggy
so I will change it to use separate keys instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
