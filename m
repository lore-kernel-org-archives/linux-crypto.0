Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B3637881D;
	Thu, 11 Jun 2026 08:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781165941; cv=none; b=gvlDFfvolw7K2ufXgAfVQVYqmmbjWpdjl25XBElJkuMfw8Z3PJZzjZGwGr+cNW58yxip7dltVPsCQbGSFBF9cH/+xfLPd7d4kurIgGiGKupFGkXKwGaV3GJHtr6RK/2nrLWke1d9dlSr/FOw6DQZ50fVRv4wicVDNzgZaR5tC2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781165941; c=relaxed/simple;
	bh=QvWnT/cDz9+GfZYNlFCT1X8ZmsgCVzlJA4+Dn392cus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQmc+lVDAqTUjs/oPZ1o3ueIWweAZCvwSD/4jHDn5jHFTxATKhFk3E+KTRRR7Sm4tyixJ9YlSCTaHaf8WYvupgkvOMgM195sjSdjNRdcaTfE0LvMVLbBRgXPA3jjjPLDF2WCxrwQaLXU30hp6NDiW0/bPM/DkAzMYtWnyCYKXwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kZkpbiSB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kZkpbiSB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bWN1wBO8aRmWQ3Z5/WoXXyFDqjPcYd9bTbbuZYdfivw=; 
	b=kZkpbiSBcd14JAyaq/wQfsbSIhWjiFI7DB+mBrXYJtVhWKwbUIczllOHOLH8+q385UkpGgWlXct
	FUa17FQ8HMaVr/M8wrwq6zW1lFqIqsmKk2vOxSRGDAhPtghpcTXzYXKg/cii8/huKFojEQNu8XpQN
	6Q3jvjminHpoMF2vmRX3MUPO9s3YFOL2ybOdfE+lCi9HS0eoTQyR2ptji+o7xhYCUU4KngTqqfj0y
	4yKgdrqCxauVSOOsZpQun7pMVhIOVkk+/i+tejM1aygB10MhhTFW5pB8V/zqC13cjOZ+E2EXnHk/V
	ovlO0g02AUAmxTfR1U3l/N6J4dIc5TQQVTUQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXa7u-00000004WO6-2CJF;
	Thu, 11 Jun 2026 15:46:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 15:46:58 +0800
Date: Thu, 11 Jun 2026 15:46:58 +0800
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
Message-ID: <aipn8sIAQ6Ai2sax@gondor.apana.org.au>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au>
 <20260611025916-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611025916-mutt-send-email-mst@kernel.org>

On Thu, Jun 11, 2026 at 03:30:14AM -0400, Michael S. Tsirkin wrote:
> On Thu, Jun 11, 2026 at 12:43:09PM +0800, Herbert Xu wrote:
> > On Sun, May 31, 2026 at 10:22:51AM -0400, Michael Bommarito wrote:
> > >
> > > +	size = min_t(unsigned int, size, avail - vi->data_idx);
> > > +	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> > > +	memcpy(buf, vi->data + idx, size);
> 
> All the "malicious device" things are confusing. Spectre things -
> doubly so.
> 
> So if an access is speculated then CPU might speculate feeding a kernel
> secret into RNG. And then the speculated RNG value maybe can be also
> speculatively be used by some kernel code as an index
> to trigger a cache access, finally leaking the secret?
> 
> Maybe?

The way Spectre works is if you have an actual instruction using
idx directly.  I don't see how that translates to memcpy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
