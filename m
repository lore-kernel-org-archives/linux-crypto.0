Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A72208A7
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 02:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742524427; cv=none; b=FvKgPv+RpIPCrUKpdcqGWVcatR9bZeK85ubFe59PXLNjQuUIqb2N3dZ+V8YASXDizMtL5neyH6SR+r8qL5DGpNq2s/LPsQbPR+CVOrXz/7rMpVIOas6lKI+/kSi2/XafJtHO3So58YCYpgQ8tvkv1ilL+ayxZx5DtMowrIBi8t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742524427; c=relaxed/simple;
	bh=UmSIPkDBFwGnfk3qQd5yOufURIc3017FXWVRGciFAQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmK0f+rcLSM2PK2X+DI+d53PA+BtZq7HNYwnCRRdbuM7+rLP3FXR+t3ONGRbtY5Irz6aLuGuS1mM9/RaSJJXBfO54MlBPjSYAsMN0UTpHC3BSjbJabRmK2QHrQO9OAm8Wit34Ch+3yQKxAc01mCCtO+uD3y1GqF7dmgIUOm3TOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EjRGJh+e; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EjRGJh+e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A5W/lkXgSqfh3K8Y8Beh9JxGkAWJpefOcj+GakFjxc8=; b=EjRGJh+eGJUFnK7s7AHNP5g/qP
	UxH+vkhqnUYH5w845D2xzWrrIv/SedLdJTHzTUrSkD0+d8kynz6pUpiGJjDp/yeOHzNBDBLU2VJuo
	GQGmiWwd3vk0VR7uYGGkU6nVdqyH38fAhkexFt90LnDkie5GibRLmGqoSc8L5BkUqPFnM9pcFGHM/
	O4KHvnsEvKaUAdcAIMVz7fohYC16j7RB8nbbgIAZJG3yTL2KP2p2dOQOFurPxuQPUgVcXWbfe1OPN
	sSGuNxA6IkjC5d/m9KCkbbBdNozAFKelxsWvqGQlbKiNhJV/pNLp2VspNMC/ibDnQ0TaW+M9C26EN
	t9OGhlOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvSCW-008uar-2G;
	Fri, 21 Mar 2025 10:33:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 10:33:36 +0800
Date: Fri, 21 Mar 2025 10:33:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <Z9zQALjYg7F_ZXUs@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
 <Z9xPaQNIyFi9fiYe@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9xPaQNIyFi9fiYe@gcabiddu-mobl.ger.corp.intel.com>

On Thu, Mar 20, 2025 at 05:24:57PM +0000, Cabiddu, Giovanni wrote:
>
> > +static int acomp_reqchain_finish(struct acomp_req_chain *state,
> > +				 int err, u32 mask)
> > +{
> > +	struct acomp_req *req0 = state->req0;
> > +	struct acomp_req *req = state->cur;
> > +	struct acomp_req *n;
> > +
> > +	acomp_reqchain_virt(state, err);
> > +
> > +	if (req != req0)
> I'm hitting a NULL pointer dereference at this point as req0 is NULL.

Yes sorry, my testing was screwed up.  When I thought I was testing
the chaining fallback path I was actually testing the shash
fall-through path.

I will resend these patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
