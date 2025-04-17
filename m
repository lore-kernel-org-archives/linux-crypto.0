Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E050E17332C;
	Thu, 17 Apr 2025 07:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744874175; cv=none; b=ZLr++3v6Y7F/Xvrg7lTs2lcyqL6u+DVaKvCVhY2vaD6x2AsvKjqabTqX02+dBk5hxW61OpuPyWjtJIJsCgciSHoxLEI/ApjouRIJSZt+vOF1AhZCvz8UZy8dEq1RGroub89VH29RaFwhKsmVZHbS0p2i5mNUhCeCbOYnZXWo3+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744874175; c=relaxed/simple;
	bh=wbY+xCAceps6BiEokx5mZ7TV1N/5MDzo2KtlsYlwDgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPtS3tbGpxfZE8eJy4q9Fph2FDmjKo85qMQf9pWaf/CyNOEuzELVpro3eY4eb2wfMuuqSx8C1kbtH2Kf4Mdnh3ImFHVFqL1Lg/uyvfPhvxegMmiY2Z5JMhxhRsw73MJkvT/UfnWY89/Tgifw1Oqzio8C5t8krXsqEn67T+J5Ej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TnnsifGl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TnnsifGl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LlDCp6AVu7/4JZIeTdq8YPdA+butgXVNGLgdY4CoYJE=; b=TnnsifGlQXhpunXm1BJ+lpeUIA
	v55zJ0pnZgqNnA5zFfYCTIVtitGIlGBqT7z9ZX0xiWW488rM2WnD9Aw/R58FDG0yNbMRp1voPxfK5
	MF4dAf2iwJkr59IcbHLXyZr/dBiDYRGc0qWI4rkx2LVdw1PTpAggRW6HFRusG1GzFQmbK0dQ/Xcvx
	LYIPI7QcSkkx+H0OALZThzAI5xVLmJ1pwQy0QzeqFEbmDqiTmEKp3S1+suGizN1mCJ6Vqw/X8+cMw
	S52iCk9YRpp6WAy9IJNQJWLd/KQHb76zhhph91l/j1+s1RPJ0yrYJTB7bz+jIugUmVgyIp608kXEz
	ajkSv+nQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5JTg-00GP9A-21;
	Thu, 17 Apr 2025 15:16:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 17 Apr 2025 15:16:04 +0800
Date: Thu, 17 Apr 2025 15:16:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/4] crypto: sun8i-ss - use API helpers to setup fallback
 request
Message-ID: <aACqtBnAJD-3Txey@gondor.apana.org.au>
References: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
 <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>

On Mon, Apr 07, 2025 at 03:36:03PM +0300, Ovidiu Panait wrote:
> Rather than setting up the fallback request by hand, use
> ahash_request_set_callback() and ahash_request_set_crypt() API helpers
> to properly setup the new request.
> 
> This also ensures that the completion callback is properly passed down
> to the fallback algorithm, which avoids a crash with async fallbacks.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
> Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
> Cc: Samuel Holland <samuel@sholland.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-sunxi@lists.linux.dev

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
