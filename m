Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575111;
	b=HZZtHsZGgpybbvcuQYElf8VAo5OgU24p2kgywEgfUh3Snan6OuM4itGAKmusgAmcbkhu
	 XT9XQXIOQOVhQbF9dPxj0F1lj2UGFnXjruphJa4BB1MBytEkmJb/b9nkXaLs0tZ2/WuTY
	 fqleebRvZCxjzyHp0/qmbzL6vWMzuHhbr/mWxe+bZXww4wcZDUfixjB+IyZEFOMtUJ2G6
	 CYeKsI1BIP2ewPTN48Ojvu/bNQecPz+Gqyb449cMb6+jREvtMVtJyKPxL7sPUFIlCtNH4
	 3Nrq0E+2FHE9pb/fTfPnk30R0P4RPnhfbaknohQc0aQmygeF8MUcFJRKBnlKVknHcyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575111;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=xWw1J9mSWgdv7DNzpCEet1r9y7gQKToUFoNa96M4jfc=;
	b=XK+5zlCAP8ZOUwaZ9hs1iK/LxhUgM9Vt7/PBHO38Bmpo7Ue6McacGwAvnkU9W3aqppu3
	 DkE5TCKzDIrq/YBsr32TFgCm/XofN3sz6yJdQsjNKX89nTCD5RcOqSn5EJgPMtYyv/WXi
	 OiKxS6k092TdtfIXxlo/rWh0nxc6Dh/WRStUvC/ycpjEn7LVGJas44rTt0LnDb2HOXa2x
	 GjcdDlxlT9vPI8rvDUumn95qeuoWM4BbdYdVXNxL2Dx4J6JvwKiPvfkLSKsVmvOyJBOSf
	 c+9bUo1XZP7pNGgmV3FqByc/iOC/PX4llI/dsZTAIcWGduCE8gUwqdyHBKiEwuxPMnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=m+dUfaJH;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88929606A331;
	Fri, 13 Nov 2026 13:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88929606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=m+dUfaJH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xWw1J9mSWgdv7DNzpCEet1r9y7gQKToUFoNa96M4jfc=; 
	b=m+dUfaJHnsBWjzlq66UOe1bYyueuXFAE4msYTY+Yiz/4uYuPoCsJkiSAQFIigIICO3hObrck6t8
	wNggbae10oFcpJXwB9ia1eTwh53VbR335sFGVxFnJ2FgeTiToAo9OGd8rxjPK/TPETU9kael37c+d
	X81PjgAPg4PvuISgrW0Se8o2S+ZtdAaClPdVa/KPGQxwTk7MoKIKwxBwbubbjV9ipd67B64vLijeT
	uO60ONme2DJ9Z1yLlO0870NlHZWQkxvORXx54PCyUuhFKgtu1bdkKoPBa2+RMpmGdueEdI3xbNrr0
	03nsLP5vrBld2ffbQqsyJwWXzZ9+fJUfPh4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqxo-0000000EfFi-05AK;
	Fri, 13 Nov 2026 21:05:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:05:08 +0800
Date: Fri, 13 Nov 2026 21:05:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] rhashtable: headers: add missing members, remove excess
 ones
Message-ID: <avcLBErMDphzdfed@gondor.apana.org.au>
References: <20261103031547.2662864-1-rdunlap@infradead.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103031547.2662864-1-rdunlap@infradead.org>

On Mon, Nov 02, 2026 at 07:15:47PM -0800, Randy Dunlap wrote:
> Add or remove kernel-doc comments for missing or excess struct members
> and function (or macro) parameters to prevent these kernel-doc warnings:
> 
> Warning: include/linux/rhashtable-types.h:108 struct member 'alloc_tag' not described in 'rhashtable'
> Warning: include/linux/rhashtable-types.h:108 struct member 'lockdep_key' not described in 'rhashtable'
> Warning: include/linux/rhashtable-types.h:145 struct member 'end_of_table' not described in 'rhashtable_iter'
> Warning: include/linux/rhashtable-types.h:199 Excess function parameter 'ht' description in 'rhashtable_init'
> Warning: include/linux/rhashtable-types.h:199 Excess function parameter 'params' description in 'rhashtable_init'
> Warning: include/linux/rhashtable-types.h:220 Excess function parameter 'hlt' description in 'rhltable_init'
> Warning: include/linux/rhashtable-types.h:220 Excess function parameter 'params' description in 'rhltable_init'
> 
> Warning: include/linux/rhashtable.h:87 struct member 'dep_map' not described in 'bucket_table'
> Warning: include/linux/rhashtable.h:87 Excess struct member 'rehash' description in 'bucket_table'
> Warning: include/linux/rhashtable.h:87 Excess struct member 'ntbl' description in 'bucket_table'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> 
>  include/linux/rhashtable-types.h |   11 +++++++----
>  include/linux/rhashtable.h       |    3 +--
>  2 files changed, 8 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
