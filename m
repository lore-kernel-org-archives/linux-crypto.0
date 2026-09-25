Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850B175A9D;
	Sat, 26 Sep 2026 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790381526; cv=none; b=bMx9Yn4dz1Aul//YCh/VJk3UeyMwCAco9yABufuOY61eBwzKb5cd4MTRmEZagKL+KiEn8kyk1lcuNzzXgFJWreBNeD42EbryiPwrTTWYlItirKfpnLploUBYScoi3o7sJqaTzrRXgLjpuYnz3yKAmk63n022H2eCeNHITMlfRL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790381526; c=relaxed/simple;
	bh=tFrV9VoXRvd52XhG6YEGxtM234UcygLRPtcLpDJIXv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4k57B196N5Wp4hVJ3vaPvqfDELvcI25GcrUcfYg6cxvV83stPfR/G2rDiUkgvPOxeL+1hwUx+XdFfid8e30/TTqYBl2UsSb7aUTWllFVbCr4qXWLE8+Wre+5kbJfL6+20Gh7KvlXq3W1ZpBl+BhE61gzfeIU2Hps0hRMLFH7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ozjqkRou; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ozjqkRou"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=o/UFtrNJZa0pVt1clqxet8u/6cXmGN/QycLLwgtr+sE=; 
	b=ozjqkRou13Cw8oI1PeH4YnshFZHcpeZPN4D0B/8/5SRvNesAi1nyaDWYn07LCg3BA/SYqIoXxfC
	3jZ/spmirv5nISJaGTcuCNFiWYFnaWiVe/wvqjZLg3T+g8didii+o5FnBKEccxr6b6HBJYS9lzwa2
	EITCXyf6C24Xm0NQFXockyOGiVZ2pELb/XwhU60eAuSiDOihNYrEbnhI6vqP2WWONYsBmaIpq7TzA
	Bs91xtR0KM3Mc4AAIi94uHs7JjjhebPxD4rkg580zeTZbHRCYR5qKxUB3ZK7tL2n1wkr0t0X2uBt0
	uBYWSWEj71Ephzr2jl4KRpnG4cWKgGydfZAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xAFee-00000000Nq1-3SVU;
	Sat, 26 Sep 2026 07:48:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Sep 2026 09:48:36 +1000
Date: Sat, 26 Sep 2026 09:48:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, justinstitt@google.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
	ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
	nickolay.lysenko@gmail.com, peterz@infradead.org,
	rostedt@goodmis.org, sched-ext@lists.linux.dev, tj@kernel.org,
	yatsenko@meta.com
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
Message-ID: <arcIVDhPR4TD4VFF@gondor.apana.org.au>
References: <20260924184733.2317353-1-usama.arif@linux.dev>
 <arW6ibT1RkVCqTdT@gondor.apana.org.au>
 <840c4c37-99a5-44dd-8b33-67057ee23731@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <840c4c37-99a5-44dd-8b33-67057ee23731@linux.dev>

On Fri, Sep 25, 2026 at 10:37:55AM +0100, Usama Arif wrote:
>
> That holds for the params given to rhashtable_init(), but not for the
> params passed to the fast-path helpers. The BPF resizable hashmap
> passes a constant template with no key_len and no obj_cmpfn
> (rhtab_params in kernel/bpf/hashtab.c), and sets key_len only in the
> copy it gives to rhashtable_init(). Without the "?: ht->p.key_len",
> its lookups would memcmp() zero bytes and return the first object in
> the bucket. rht_key_get_hash() has the same fallback for this user,
> see c9429bf56405a. (I added Mykyta the author of that patch in CC.)

That's quite an eyesore but I guess we're stuck with it for now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
