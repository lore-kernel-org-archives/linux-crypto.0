Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3200333260C;
	Thu, 11 Jun 2026 09:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781169577; cv=none; b=IEx896QzVpuiDgnYWmvL65Gji58hxTdxVpDgkGJL27+kt6aLG9RYKM4dFno/NgFaBMNP3dIHPIA/9jBfe5m0mEo6b1BZyYSjjd/3//Em1Ds/NSVWoM0S5ShUiC9q/BOfk2TOpFGLuhDQ1l0WJsXajBzXrXVOoRlvv59hbCp4uYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781169577; c=relaxed/simple;
	bh=7RP2ImnmPS6QGJg/BjRNpO83yOZ6xPrChkuvELN1BhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxoOIJx3sGrOu31h9WYp82mJObFLTNW/FjiGlIKvfA3xx29Y+UgIVsDf4cPDCHwny3E4avUDk0duTQXYQ05tFwmsgahT5pY/x1es6HoHKC7yQMrLeRGdwvRyjHdOhP+j+eexRV/zqodrwbd+fNMdldyeUy5PbzJbjLZG6H9s8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gEj08VtJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gEj08VtJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ron/iZw0N+i10pIwlar1zaqIblnxytRF1UWI3uzY+1Q=; 
	b=gEj08VtJAKqCUPkV6v4zXF1WJ50LN9i95ngDcHBJ6MxSeiFJ/mmZp1Iq5MPif/XiDKOMNDJvVul
	6M9+H01mQ0Rf1Bqo2p9gV5kFdhhrM/C4J7j8IBECj1sO8UiQZWqAGKGDhbKchrnvgA8FzS8dq3lpB
	JrWwKeQyjtMeaPRASEf5IdPJRcRs43LAwxbRb/0rQX6yDXdcCJc6df007aEqjHwofRCRlgVyH2gZa
	ssvAb1olFjuXdxZaPzDvPNW07w30PNy5WlUSvb4eP4IBzYrkvA220IJqDjJ78fCjNc07kYyHmcm8y
	pZX75ewNN7yhEABrKdB8NH+9KDhRdCXy1l/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbZO-00000004Y8q-1e1x;
	Thu, 11 Jun 2026 17:19:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 17:19:26 +0800
Date: Thu, 11 Jun 2026 17:19:26 +0800
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
Message-ID: <aip9nja-Oz2RxkWi@gondor.apana.org.au>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au>
 <20260611025916-mutt-send-email-mst@kernel.org>
 <aipn8sIAQ6Ai2sax@gondor.apana.org.au>
 <20260611035035-mutt-send-email-mst@kernel.org>
 <aipvZhfvdtRxOQm0@gondor.apana.org.au>
 <20260611050731-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611050731-mutt-send-email-mst@kernel.org>

On Thu, Jun 11, 2026 at 05:10:32AM -0400, Michael S. Tsirkin wrote:
>
> data_avail is under hypervisor control
> 
>         avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
>         if (vi->data_idx >= avail) {
>         	vi->data_idx = 0;
> 
> and maybe this can speculate past the if?
> 
> I agree, this is all speculation )

Either it is vulnerable to Spectre, or it isn't.  Adding nospec
markers when you're not sure is cargo cult programming.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
