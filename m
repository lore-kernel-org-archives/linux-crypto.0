Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC122F362B
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 04:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774498665; cv=none; b=hDMPQjxAvEB85u4EPMe09Bfjg/EhHGxlHk6v+1X3vvNMeAS2+AVPGj8v1EEA9JxUBYe2Aj+G2vaH+bC05UyG7HlhonwbMFZKAPzWXr1fBaYlJEjWQSMN2FnYHt3HnKmFd5LUHGFq4dm1FNSJbOHsXJJO65hjiMbndSP/jLhbcgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774498665; c=relaxed/simple;
	bh=7Vc+IZwEKI/aExoAPMqrLzSVFvvBkLiAV4ALug/+rIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcU4Z2mXBgKlbIbR8cJZwGHyh7PfEVBy+AdsugiATal3DZmF4nVxxeKDj7YI1b2W5ohy1IgRpuxLepGHfqEF0ccmw+Pj7iWfEdLb+msm9gfuOhd4AbxNSPk7Y8xJt/CRtxEQcQJrP3/p6az7gDu9ORSixpKX7GzwUBzp8t7Q7Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RqjE+/ST; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RqjE+/ST"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=di36djunGzh1zDhUYAsOQHLljST8a0a9F6Tpb/7N5vA=; 
	b=RqjE+/ST7jEp2RMx3TugM3QH210G4LlXrTdTzKd8mATe1BqZdDWvWoc0i2ng/s2rSxLj5q57QV8
	SxrV5mE3DomrWo8FW4aO/23xA1b5DNZCYa0wimLLKXzPc//2j2SDDa4+k+NTdHf8vPmBeZTiFldR2
	17tz0SFpml1lAdl6NnjUf5MtxOoEesuawlUlBqYdwpUt5s30nzcAwMO4FwHjez2Li1hwyeijGSxsC
	WlXKgbNSFyIIiIw5GBkKiYYDRQs/v2ccvzCEGXSHxcnWbunnaZK/gNPUD4ascM96eGs/MyWR6EBRE
	jlDCINW5gmWbKfnRfxKOkkFYFXHsiDIrAzKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5bkV-001C3I-3D;
	Thu, 26 Mar 2026 12:17:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 13:17:30 +0900
Date: Thu, 26 Mar 2026 13:17:30 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Taeyang Lee <0wn@theori.io>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>
Subject: Re: [PATCH] crypto: authencesn - Copy high sequence number from src
 after out-of-place decryption
Message-ID: <acSzWm2bzRXTkhVH@gondor.apana.org.au>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
 <CAHk-=wiEzzo=LQ4TasUqFDkSYYAXa3VT6PvLx+AS8asOEA6hng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiEzzo=LQ4TasUqFDkSYYAXa3VT6PvLx+AS8asOEA6hng@mail.gmail.com>

On Wed, Mar 25, 2026 at 09:23:31AM -0700, Linus Torvalds wrote:
>
> Side note: can we please just get rid of the horrid
> scatterwalk_map_and_copy() when making changes to code?
> 
> That function is disgusting. It's really hard to see which direction it copies.
> 
> At least with memcpy_to/from_sglist() the function name and the order
> of the arguments gives a better hint of what the code is trying to do.

Sure, I'll post a follow-up patch to convert scatterwalk_map_and_copy
to memcpy_to/from_sglist.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
