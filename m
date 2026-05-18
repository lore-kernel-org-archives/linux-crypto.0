Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D151E21D590;
	Mon, 18 May 2026 03:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779074251; cv=none; b=Maxo2ME/MRoglUOpfgSahynnzsPXFYBg5PKfEpdJLaQGdaK4HE7x2ZAAfXB4JS9ZpGOygEDMLm/9hR3LALsMpTt4Y+NQpJGGUSNsn4IZaroFWKtUXRQPXJd0Oaysmxfvy5tVzFzrGu7wMZsuRIJgbMUtJ9fLYGUP2CJmqjRXjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779074251; c=relaxed/simple;
	bh=Ss+YNztn/9Zp8Cxdp8yzFFFtnmzGiwcErDXNDj0L5nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAeZ8p9EnYQQxv8uhNAcgcvo/cl2ZMHQVwBbY0McLRxdU+xBFA64CnFwY9IA6gsRmg32apl/bWuqoGGkCFXHXrKvjcxSZlVNQNSXbI7fZ83BlfxBivjIDwZShgvoCoeYHThF0j1BIHlTuAtfpeHk3yh4ZiAUlwZ/6RfQPSBBa4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oUCx6MOw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oUCx6MOw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qkw319F8Mm2LdfyPX+uH9mASPigoSoOkZj56TRwEYyE=; 
	b=oUCx6MOwVzfxfWFiSVv8MxSmDUzc/bMWixSBdo7FTV3Vl44eeFp7m686Nv7Ad0uy6JMdBW++if2
	NYCRfex0P1NM7wSy8X3sITeSYxeUvwlEG3gorQcBosySERRgXtTTluQ9Z/iDt+9WDVZzekYnDj36F
	Pa4w2ieBmZTungU/OyQSqP1JHOj3l2BKFOAJss12iSAHEdV/TlJB7rLfFI1I4vK0RRPhuzv9FIgFL
	e/gUjyArZX1jBd4FGotKo7eNxlczFzd8Y2BUzDeG/CFSHb8Qxl8YxsVwISzRECWDCsBZz6TfVg3+k
	sIiGwQG4mD0z0k76neFx9Vpwr4/zXhfs/qOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wOoTl-00F1h2-15;
	Mon, 18 May 2026 11:17:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 18 May 2026 11:17:17 +0800
Date: Mon, 18 May 2026 11:17:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Scott Guo <scott_gzh@163.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Scott GUO <scottzhguo@tencent.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] authencesn: Refactor in-place decryption
Message-ID: <agqEvY4xJYjbZVDI@gondor.apana.org.au>
References: <20260515083645.4024574-1-scott_gzh@163.com>
 <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
 <8aaa00f3-d8e0-4de0-918b-1f025b632eb9@163.com>
 <agp6lDddmDZaoH6L@gondor.apana.org.au>
 <9f625d9d-6820-442e-9527-1b2802309993@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f625d9d-6820-442e-9527-1b2802309993@163.com>

On Mon, May 18, 2026 at 10:55:38AM +0800, Scott Guo wrote:
> BTW, I am wondering whether we should disable inplace decryption for now? I
> think that to mitigate vulnerabilities like Fragnesia, maybe something has
> to be done on the memory side. Maybe something like forcing a pagefault when
> trying to write to these pages?

I think stopping ESP from putting frags into the dst SG list would
be prudent until the whole stack has been audited.

Alternatively switch from the black-list to a white-list approach
and only allow ESP to do in-place processing of packets from a
source that's known to be writable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
