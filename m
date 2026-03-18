Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3E53AEF5A
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773836972; cv=none; b=uGYGTTRyDTLYIwSiTM0ECRr74PIykaOi5q749BMWnb5e/MdK/LwXyAQSR83PWknZC3ItfKaXBiwxJKcnO2jb0gpRBKf1PkghCb9lkWFD3ZJvUySGl8ZmjjXCDqe2XCLtJz5tcSYADQddrT0Y6l8BMa/SpidmqqcOjjbxmmkdpZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773836972; c=relaxed/simple;
	bh=N0hZfNuCwxur62Dhe9eZWTzvJYSym3qOI+8A1UclxuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjeYLU3w8vY9zDlY0dbgBD3OJwdzFXrTViuaT08JqhWuxtp9b7vwu0RFi2o66LZK3PuP2mLPkK3m3Lk9u/QwFwU9q5WQozTuBJA8dXVEoFphYByMKRjxvVj/c/5HmV+uDBxLAGzoJM7iD9a/CwUDeU3cTNPD7DVLpTIZ4zMDFao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZakMuvHZ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZakMuvHZ"
Date: Wed, 18 Mar 2026 13:29:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773836959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2GdGv5dmSzHUDnW0c1bGqLqX8yfm9FaWipGd7a7als=;
	b=ZakMuvHZcfTJM3L6Wkc9KE1AUB/1Ew7nYxMs88YJKRah6rkshZIvI5lBOJ+KbphmKzb0Xf
	3zB5/PeFwg9qYZnSrwuP1aWN0WAVjogoczY9ikyWC0axJBaTFXzQvVai0OesQGs4P2Arnf
	XcyIZtX+dgnxheNY/rzZ82apQrzpc9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Yuan Kang <Yuan.Kang@freescale.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - remove HMAC key hex dumps from
 hash_digest_key
Message-ID: <abqal8qyPbsmpM6p@linux.dev>
References: <20260306111204.302544-1-thorsten.blum@linux.dev>
 <abTqefme_iApfHZi@gondor.apana.org.au>
 <abk4_r-KUYIhvyNL@linux.dev>
 <abpYWkDzofozlOWp@gondor.apana.org.au>
 <abqUQxdoH7zuszZQ@linux.dev>
 <abqXgt5x232kEPUj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abqXgt5x232kEPUj@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 18, 2026 at 09:16:02PM +0900, Herbert Xu wrote:
> On Wed, Mar 18, 2026 at 01:02:11PM +0100, Thorsten Blum wrote:
> >
> > My main concern is that with CONFIG_DYNAMIC_DEBUG enabled, which doesn't
> > require DEBUG, these raw key dumps can still be turned on at runtime in
> > a deployed kernel.
> > 
> > If we want to keep the dumps for debug-only kernels, then #ifdef DEBUG
> > plus print_hex_dump() might be a good compromise.
> 
> Exactly.  Having sensitive information printed with DYNAMIC_DEBUG
> is arguably a problem, but putting them behind DEBUG is definitely
> OK.

Ok, thanks.  I'll send a v2 soon using print_hex_dump() guarded by
#ifdef DEBUG.
