Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC70D33D6F7;
	Thu, 11 Jun 2026 04:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781153007; cv=none; b=lMmev1ascIVRzXILShDX1I/Py2l/73/jAKTVVTqgTDLqS+oG0D7GOVHOD7+24BnehB6Ty2m4xtpFXeYOtbclLXBdmdwV7+tXMmD0BwmZ2qxAAJaXX2OvK7wIppUSd0d7A5E9I4LO6oG+zJZqw2xWyB0ZDChrbCtB2KjqobZIlrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781153007; c=relaxed/simple;
	bh=CDqx9r46DKTCgMW2sSnhdavaJ0jvRv2bg0+WpwCCWpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meikgd+OiK7hWxw2FS7qs8i34qhbkYiWqabBDuVSbXrqPUa5THSPgn5f9jaGn16/FEVxJ3KNRAwsHgXcuA+z1KVN8RDWSt7MXKIbsrdnoOfMNPanBOl0jEzxqDYzjiE7o9jWMIaKW/XSFqacE34smeDTduk+CXVtO9jfqseRIgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZjU3VnKx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZjU3VnKx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=oeKD7mPCFKhQ8XKM32Ys/gTK8P2DHVnaFTKN61Ko/f4=; 
	b=ZjU3VnKxYZzffPHALzdUB7Yr4P+GxkfqKDpTXXkqDhfSPmTlcjNY85wPaGG+xwhcKcG6Jt0sj+2
	DVOtLfwXLZsK0ci2cHBmIkMAFWu+J8R5DN2GOBCwbIuOHmbePVkwHc5VgpeV+iIWQygm5DW35VeDB
	uVuaPxQAREyuNnr9Hxmm+AE4htUEguHlKdKDUap2JSgQCsbRonYzvvCA8GhDzEef4TnFQzfhWoQJz
	+sp5OQajECFSFTnqirWkwP8gfDRDU41Uibd5RUWN0QXNOx0e0d4G8NIYv0mLUlGvwzx1TOL/av/Vf
	WLi1FlhSZRe2kz6Yl+/rUi9dZv+TXNMuWTzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXXG1-00000004TTX-0Aiu;
	Thu, 11 Jun 2026 12:43:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 12:43:09 +0800
Date: Thu, 11 Jun 2026 12:43:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Kees Cook <kees@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
	alan@linux.intel.com, tglx@linutronix.de
Subject: Re: [PATCH v3] hwrng: virtio: clamp device-reported used.len at
 copy_data()
Message-ID: <aio83ZWadVTiuNpR@gondor.apana.org.au>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531142251.2792061-1-michael.bommarito@gmail.com>

On Sun, May 31, 2026 at 10:22:51AM -0400, Michael Bommarito wrote:
>
> +	size = min_t(unsigned int, size, avail - vi->data_idx);
> +	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> +	memcpy(buf, vi->data + idx, size);

I don't see how nospec can help here.  Please enlighten me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
