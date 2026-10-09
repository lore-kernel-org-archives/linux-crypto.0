Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BE4497B87;
	Fri,  9 Oct 2026 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791539029; cv=none; b=I3ktKHm5kwJ7tJQa9DeMBUpZJiu3gJlA2TuLKf4UcDDD2RM9kVh6mbgN27DkNwzPMTMzkHJ1PyZhGM+5Y/HHY4MawPk3nLDXsLgZcVJbB+OCsDHicJJNXXpkKzAZIWWfFRA+iN9Cs02Np7LkVuzlGCwJcuR9t4rzQfiBpbBJfkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791539029; c=relaxed/simple;
	bh=Ni1fdoFnjpafpiRBYCB9qFuOoNMXdGPwfxm/cU2m6Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SB3xQCEIAsZXbhKJZmXkDJNub1QyR0cVlp5tXZmvRpcm1D7vRV5LnygSk5iVujmC7/273yOGDf8rDuk9iHrB9cN0fpBsi1s1S4vTDuu26Whop/49N8Jz7iU5rA5pg8I54pxdZr1wxrY8G4quqAPYECYeYePmWuseFKMe3v4p/qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/knBLIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/knBLIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94BA1F000FF;
	Fri,  9 Oct 2026 09:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791539019;
	bh=PbSICq/SyAcnLxJ/3kBxuPhqZVN84tKx60r3+VjqUJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i/knBLIM4WbJ6eCCx2LdtFz39MlFxgzvCe53ay28diCbGgVGzKdC7g890BfCGOt3F
	 Y4YGw4jR3d6ylWN/N1H6ZGQEQy5jqqbFjclEqZKcp3UALxZ1UtLjuC4/ap9SkixN3p
	 o7VGvNRrPm0wrFTrSeA1Xrwt6Hbz0cliP3RIiUyW44yfDoIYPoxG8pxjfoBgyYBXd7
	 ECRqBUYWgL5F87U+ofqiyKS/ValTrdxq26dC8DANHDCB3W9UyLFkAjhGLHne28BTar
	 WCXotEk6gUY2v5dEUmN280CCi/2IUt2OR51+gcGSoje7gaHjjy+1cwSxSgui/4h06y
	 F+nHhioEpii3g==
Date: Fri, 9 Oct 2026 11:43:35 +0200
From: Vinod Koul <vkoul@kernel.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Frank.Li@oss.nxp.com, Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Frank Li <Frank.Li@kernel.org>, Jon Mason <jdmason@kudzu.us>,
	Allen Hubbe <allenbh@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" <dmaengine@vger.kernel.org>,
	"open list:NTB DRIVER CORE" <ntb@lists.linux.dev>,
	imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 1/1] dmaengine: change dmaengine_get_unmap_data() first
 arg to dma_chan
Message-ID: <asi3R24SY-Y2wJQx@parshuram>
References: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
 <b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com>

On 22-09-26, 16:09, Dave Jiang wrote:
> 
> 
> On 9/22/26 11:45 AM, Frank.Li@oss.nxp.com wrote:
> > From: Frank Li <Frank.Li@nxp.com>
> > 
> > Replace the struct device *dev argument with struct dma_chan *chan so
> > callers do not need to reach into the dma_device internals to obtain
> > the device pointer.  The implementation now derives the device via
> > dmaengine_get_dma_device(chan), which correctly handles the per-channel
> > IOMMU mapping case.
> > 
> > Prepare to make dma_device private and make dmaengine API consistent.
> > 
> > Signed-off-by: Frank Li <Frank.Li@nxp.com>
> 
> For the NTB bits:
> Acked-by: Dave Jiang <dave.jiang@intel.com>
> 
> 
> > ---
> >  crypto/async_tx/async_memcpy.c      | 4 ++--
> >  crypto/async_tx/async_pq.c          | 4 ++--
> >  crypto/async_tx/async_raid6_recov.c | 4 ++--
> >  crypto/async_tx/async_xor.c         | 8 ++++----
> 
> Maybe one day Dan's wishes will become true and someone will finally deprecate async_tx....

Does Intel still have use it. I am looking at fixing the names and we
can drop async_tx completely...? 

-- 
~Vinod
