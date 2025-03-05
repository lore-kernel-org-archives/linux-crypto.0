Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA39E1FC0E0
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 07:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160494; cv=none; b=Uq3ImE3wRP0T+SH6upHa8rN0ie0O9onTF1XI4qhWqjwc8LrOOQutNrezS2Wd628hhBHl4oxXrx42orbf/Yg5BHp8g3m1hft78U+3G3TdyZmcE5sxQg/xOIx3mBrNtegIK3C6dQntOVediABg5bfkBoLEHyuudX9Sz+UBikhvqPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160494; c=relaxed/simple;
	bh=WqN5rRDOFM3629OeJu927nDJlkzRSyXzIy10y+9tACs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2mgqLgB4hCLBNnENHCXx05qDI3ISsrvdcfr78vnqwvfFlYNIicQFSTepH2ZiqiOC3MtiL2w3Su93cHQcdm8/Zt0js2GWdXc/tsXsJOYv6Pj6UvaBCaredEqXDFDi9nkVNrVP/bjIGtst+d3RZuBddQyjcSr9dLelQs7aIKXHbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HKi2nR7u; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HKi2nR7u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7xModNEFPcIIbBzmat4JrHhx48BKKC8IQs2Skp7fbN0=; b=HKi2nR7u9Q9hcpUr5NSToASzBY
	bg3INRgz9ajdCb/b8AT+8t3dPOlKTxWG7JFZTyrfP8CSYuAydl5v7cDCJxDuqJ3INXU+OIUSHRSRS
	VuiWrzLZ0zF7I39GcpxKAKSuy5YR+7Tbn+dZ0ZoVPf/xcdOcVCvLqFxRwF+aj6ZrPjGJx7WyMKIGa
	2iQrbYDQULg3wevTnXnCgqiikkK9ZevA/CoZwJ5vpkXtMDS8U6da7Xli3YVOMyOV2cM3eewiYX3LA
	xaD6NDzrAgDVlEmkaD7M10vypwdv7ji4g62Yqc3dY7v9l9jSDA8KW5xA+3CwAhC2StPhVzsVjuIXW
	ToWkTtzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpjNW-003tor-2j;
	Wed, 05 Mar 2025 15:41:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 15:41:18 +0800
Date: Wed, 5 Mar 2025 15:41:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8gAHrXYc52EPsqH@gondor.apana.org.au>
References: <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com>
 <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
 <Z8fssWOSw0kfggsM@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8fssWOSw0kfggsM@google.com>

On Wed, Mar 05, 2025 at 06:18:25AM +0000, Yosry Ahmed wrote:
>
> I think there are other motivations for zcomp. Nhat was actually talking
> about switch zswap to use zcomp for other reasons. Please see this
> thread:
> https://lore.kernel.org/lkml/CAKEwX=O8zQj3Vj=2G6aCjK7e2DDs+VBUhRd25AefTdcvFOT-=A@mail.gmail.com/.

The only reason I saw was the support for algorithm parameters.
Yes that will of course be added to crypto_acomp before I attempt
to replace zcomp.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
