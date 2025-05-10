Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792741E2852;
	Sat, 10 May 2025 01:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746841085; cv=none; b=ElRsA8o1jMrP2xgh6yCXOsfFhKdrZe6SCD7Igi1uhXOrifyDJ7gyEFhHvqxns5KlJxmFTFwdAcg75pXEnWay8IGwBLwhpPFEMEPe1RKere9gP/JyDNI8K/DGus2qQW5/+kkrPVv5IdQxMQ3ahTi4im4bPbRZXF4HzmrA/uET71g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746841085; c=relaxed/simple;
	bh=dj8o2QTnCDr8ohkesAp8BSgfS4SRxpbtqt4mGydYjLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8DYRp42O8PkRLurp/ghZGsQnMqgzvjQ+3zMPLv/6F/YR28xZQVubnS2KV8il5WebwnyY9eyAulwpO5IVdQ83my+Lf57Qsvw/fu2NCVt14IUY/XwvTK2QUgZN5NX/FKHZBjItpZexTDuiILTji/eA0q8s+1i8bo3TNvb69ToHKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HmXOFb4U; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HmXOFb4U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iyV8HkAn6nqQyuiUYQoJaHYTsOkBmzu+xr40l8RNaEU=; b=HmXOFb4UYofjAQ8c2BlImQRCXl
	TYEmcTlD2O9evPk7Hqh2ayp0ZZQ5hORT7K3L/TL8q+m/ZayQUm8VEAgCsKBE0xBe6ZJ23ZG6FWM2e
	+igoaXEC+l691s7Wps1c9y/Tr+sBtSHnRvdG2HwrKQB4I8uxQ7hyje0H/BOIK5mymFHcBDuYrtH7D
	S2J6Bs8d4/vX9GTJdtQgokbDi6zGn1fBSGulrN+t/1GKzyH/Or9RP6OOY2qPkfvrFaBTUgPZB8qlW
	8A9hMlfB8+pBTFrLpws8elVgsUZIJKNqsZMLicBGq9XDTYcNDGLOL4gZOPWVHjnOsw3ecsRS8s1Aw
	qo6PEOeA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDZA6-004zn5-1g;
	Sat, 10 May 2025 09:37:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 09:37:58 +0800
Date: Sat, 10 May 2025 09:37:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB6t9lfMCSuYVxwv@gondor.apana.org.au>
References: <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
 <aBy06xyzh5kKC48a@Red>
 <aB10PqZNk0L-ly70@gondor.apana.org.au>
 <aB24nSeEJKtP1bO_@gondor.apana.org.au>
 <aB3ggeQDdaPblUxi@Red>
 <aB6oxlR6DINIvdLM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB6oxlR6DINIvdLM@gondor.apana.org.au>

On Sat, May 10, 2025 at 09:15:50AM +0800, Herbert Xu wrote:
> 
> I see some bugs in the driver with regards to zero-length updates,
> but I'm at a loss as to why that would only make a difference when
> run concurrently.

In particular, when testmgr does an update+final, it will give a
non-NULL SG list to the final call.

The buggy code in marvell/cesa will then read that non-NULL SG list
during the final call and overwrite the cached bytes with it.
However, I still can't see why that would make a difference because
it should contain the same data.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
