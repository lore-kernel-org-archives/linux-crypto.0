Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9833546FC;
	Mon, 28 Sep 2026 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572839; cv=none; b=qdMsrhCb3Jkwb+ul34uVZFbRjspEmKln1RFZh4kqaJhJ1sF4mTmw7TqqkIIliFqq1LYpsJCxhgOAam98RxUKa/43ub7tgoh1Xvth61preu5nbjFIMD4W36l8CNpI1VUm76y6XfX3e0elJxFDmUhM3A2S+urg8j6GecxxDCmzHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572839; c=relaxed/simple;
	bh=h+U20ic58MAPuyQCh/ma8s4zR3UkpYKQlikN55TpemM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9z+MlvNwj5XmEjUgQPCHzARemulNdttMAwT8+OMGDnAbaWHvOF7XWzq2GHoqi4gFmXNlUjJadFnKKCoTP8VpKIiJ5nmASFlFHb2p5ueipDXDBgyv7PZcM2tezpVYtC2W9E/3zUY3gDLhQs3SfEVI/hGSVDTR1sgW4+0Hw3lTVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VfSBZ5wn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VfSBZ5wn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2zJn4Ku/cvpQ5W43TdJeJKuMCC8pMnlM/Sf5d38Q8Ms=; 
	b=VfSBZ5wncgfkI0UtA6GjXJQgQE4jhTwQSLUL/Nxtuw5S+EQ7TZss8Meug9NzRRfEynpoFCW02hR
	0+z3GBgMSbTojbo9xiOi6KxTkIzcysMjAi9hFCokGA4PLqJ4i4qPhEm4FtOv1bD9m9QS+CT8IeEUH
	QBTwquYc3Mhwbhdvx4GukRGNJJbg/o8AVXQdWb7q5MSH+YGMg9tiUu27zzmOWC4FTXzSd65KihQpI
	/U2UPcHOQxWwZ1kwr2vGNdEXPnC24dws5Z4Af1xXpm+d77yDcwbY0PzqhuJ6Aa2vXK7pnp7lYE84E
	5tiSDODULQNk7rlNXgIg7Lw1FRlgShxR406g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xB3mv-00000000wDl-45D7;
	Mon, 28 Sep 2026 13:20:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Sep 2026 15:20:29 +1000
Date: Mon, 28 Sep 2026 15:20:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/15] crypto: ti - Fix use-after-free of dev_data on
 DTHEv2 driver removal
Message-ID: <arn5HcrQcER2_dio@gondor.apana.org.au>
References: <20260918102245.2784000-1-t-pratham@ti.com>
 <20260918102245.2784000-5-t-pratham@ti.com>
 <arNo63c8NOHkc5CH@gondor.apana.org.au>
 <604ddec3-bf19-4a41-8fc3-c4ec949e4e03@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604ddec3-bf19-4a41-8fc3-c4ec949e4e03@ti.com>

On Thu, Sep 24, 2026 at 09:09:33PM +0530, T Pratham wrote:
>
> As an aside, my LLM suggests me to instead do:
> - .cra_reqsize = sizeof(struct dthe_aes_req_ctx),
> + .cra_reqsize = sizeof(struct dthe_aes_req_ctx) + CRYPTO_DMA_PADDING,
> 
> Doesn't look to me that it is doing same thing as
> crypto_skcipher_set_reqsize_dma(). Your thoughts?

That's exactly what you should do.  I'm very impressed with how
far LLM has come over the past couple of months :)

With the extra space, you can then safely use the reqctx_dma
helpers to access the aligned context.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
