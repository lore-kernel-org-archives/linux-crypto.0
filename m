Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22A29ACC6;
	Mon, 20 Oct 2025 04:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760933642; cv=none; b=HWcI4dvFS8cXhA1Pij0MxgRrEITdqwVLLb80Gp/Esbjn4jTf7YklR4g4KgcVZWbImQqwlegL4Hxf8pySFAl+itiZHMVSnF0UwU1gamznmarAmtHncXhHheYrVY5CJDD8g0y4LV+HLh+ny/KFs+ZTEgU+zDDqefbdThqX+tpVqi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760933642; c=relaxed/simple;
	bh=wXBCY+F4wLSHNH2PEfSoFhq5ce8KB4OT3rvWRV6OOms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDt9l7+UhyWzLnSwOAu9qVSC+y+bYs103l7aGrTboDxtDwQ90Au1h/XB9kd8q8gy1xXJj5ne4N/rX9Usqeby/oPIIoLVI5lAcNN4tjGj1xn6fqIMG4snlRUsHAVcS2yvGdlHrLTRwsATu/4Bhf5AxubnPvtz+X+0X3Zl07UnG7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=J4i8lcDn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="J4i8lcDn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JAKNGO3kJKU6Ja3I7Yn/HEP2ZwKCfxrCLCJ01jsW2gM=; 
	b=J4i8lcDnYP/ICMS9feoNUbbErEBwpaZla98BbGX/8UWkAp31GDD+jEv3A+xZN8UQFbIfvvOMM+0
	12Imq6xOvsiVOTNO4zXyt/0OIErayxpZ8FnsjCql3iIfEQSj13pLF4chyh6fA1b/DMvCVyqDx0pr3
	jQ10IS7yV/xudoP9nLqIepFfU7r6WKqQBkCsMrP6UxK0E+yOkubsOOyFYJIC+XWKvKn2UCGgu1YTu
	hNMJ4KjX7wFVtp8yRo7ajYuT0mLDzbbc4yHAkFjpNETfxpc1QKCzdKTMncEWzldqZ15uXY/SbvtWZ
	/1KGMQt7zfh0nu1XlmVxEz7UP+DvfjjgzlVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vAhHI-00DwsK-23;
	Mon, 20 Oct 2025 12:13:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Oct 2025 12:13:48 +0800
Date: Mon, 20 Oct 2025 12:13:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <aPW2_B3utVHNxaEV@gondor.apana.org.au>
References: <20251014003123.GA2763@sol>
 <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
 <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
 <20251017160437.GA1566@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017160437.GA1566@sol>

On Fri, Oct 17, 2025 at 09:04:37AM -0700, Eric Biggers wrote:
> 
> Well, it seems you didn't read the patchset (even the cover letter) or
> any of the replies to it.  So maybe I should just take it, as I already
> said I preferred, and later did do since you hadn't said you wanted to
> take it.  It would have been okay if you had volunteered to take this,
> but you need to actually read the patches and replies.

The reason I didn't see your cover-letter is because you didn't send
it to me.  Your To/CC list was:

To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
x86@kernel.org,
Ard Biesheuvel <ardb@kernel.org>,
"Jason A . Donenfeld" <Jason@zx2c4.com>,
Eric Biggers <ebiggers@kernel.org>

So all I get is the patches without the cover letter.  Of course
anybody who replies to the cover letter won't be visible to me
either.

Please consider adding my email address to the Cc list next time.

I will drop this patch-set.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
