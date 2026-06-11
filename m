Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9A372B32;
	Thu, 11 Jun 2026 08:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781165937; cv=none; b=eQQREdmA9u+U8LwOuIYNf/FWxVvlYkCwhXPugSXmaPTZvvTgnptzoAiF43OgddWgP+3FqlOdyTRwl7T7mEF3Sc3u0oSWaMbztV0j0KzDIUS97F510G6uVpMrq+P5ObIEMx/PHzr+uhhiKAPbax6mjZMbcfTqbhUSefwxXoUSP+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781165937; c=relaxed/simple;
	bh=5G70vOCM2WZ3J9uoB6jY52+G26GMBhwcbbbSTI1xENg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhwEAcdwwOVOopUtSeYTpjCuVhfk/mjRBn9I0wek2OlM1aMe35OoRAHnV6HRidmQ04IxqF9GezlnnOV88k5l6FtZF/qGcYwfoBWiIJ+lG0e1kHC3f4XGJhX82FchozLvYx8xDa/ntF50hyXhHQwE+dQKq1NUjJH5v/88VFpEoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=K4EWc5Df; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="K4EWc5Df"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=O+nCbDPXlUZ+LQVSkJK2EmiKnCMOMg1kYFQHMYzV0XE=; 
	b=K4EWc5DfQkLYPA/nqUw8gHig8REgh1vnQbRQaqlTGtv+kFyrtGPsPFKYihqNzPCrkgRfk2Wxo+7
	w8cIT7gL7sORrSQVroRuV2nKS/VoWEpPNlyfcw91XdcEPucYijfTCNU1NAE+F+jBRn0/2aIRqld51
	RmlHucWV4yuAdGzE60o2H6vqrdVnM2mMgZukqdPGhcymdX9Y5mulCrzvfGYWZqwaFRs/1lyaGklqM
	lBobVM8gsy9JDWr3eIjho2QWVGwQHqUg10zqlz855pe415IYr3XgsqX8r+EDqhGfYcLV4f5+XvAoZ
	tCZhvkJqWHCtmjicY3V6zuskUOkNQrHJC3Hg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXacg-00000004Wyj-3bPC;
	Thu, 11 Jun 2026 16:18:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:18:46 +0800
Date: Thu, 11 Jun 2026 16:18:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, Kees Cook <kees@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
	alan@linux.intel.com, tglx@linutronix.de
Subject: Re: [PATCH v3] hwrng: virtio: clamp device-reported used.len at
 copy_data()
Message-ID: <aipvZhfvdtRxOQm0@gondor.apana.org.au>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au>
 <20260611025916-mutt-send-email-mst@kernel.org>
 <aipn8sIAQ6Ai2sax@gondor.apana.org.au>
 <20260611035035-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611035035-mutt-send-email-mst@kernel.org>

On Thu, Jun 11, 2026 at 03:58:17AM -0400, Michael S. Tsirkin wrote:
> On Thu, Jun 11, 2026 at 03:46:58PM +0800, Herbert Xu wrote:
> > On Thu, Jun 11, 2026 at 03:30:14AM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Jun 11, 2026 at 12:43:09PM +0800, Herbert Xu wrote:
> > > > On Sun, May 31, 2026 at 10:22:51AM -0400, Michael Bommarito wrote:
> > > > >
> > > > > +	size = min_t(unsigned int, size, avail - vi->data_idx);
> > > > > +	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> > > > > +	memcpy(buf, vi->data + idx, size);
> > > 
> > > All the "malicious device" things are confusing. Spectre things -
> > > doubly so.
> > > 
> > > So if an access is speculated then CPU might speculate feeding a kernel
> > > secret into RNG. And then the speculated RNG value maybe can be also
> > > speculatively be used by some kernel code as an index
> > > to trigger a cache access, finally leaking the secret?
> > > 
> > > Maybe?
> > 
> > The way Spectre works is if you have an actual instruction using
> > idx directly.  I don't see how that translates to memcpy.
> 
> I am not sure it has to be direct:
> 
> if (malicious_idx > SIZE)
> 	return;
> src += malicious_idx;

Wait but vi->data_idx isn't even under the hypervisor's control.

It's an index maintained by our own driver.  So how can it be
malicious?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
