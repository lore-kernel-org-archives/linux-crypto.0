Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050024BBFD
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183867; cv=none; b=WwuxF90fQiDilZ+FZuGyAuQHRRC06pxc5akYQ++OiK0GUzrGFFZkZLaotxavEUczocKJZkh31/zjRN36u3YG8Wyusth1O0xdBfea8KCb+Pefn56+d68ZIHUSZoPqbnPHl2MAjIekoLDaKMkfBVAtM64eeg1V0YaTlEh7erF1T1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183867; c=relaxed/simple;
	bh=RjZZ5AhcRc1kQ01+zIiXLQvInXoLTVCWoxuL7r5VZNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvQE85DKBIoZAz9Jw4eOBzmQEJEIbUec3Su3lDKoBsbzDG5W1MBAB3rx0pQb9nOXHw3jIZXlhGBVMDLZUpQsmTz7w1VHugSwsJJ5gU95MDSh65UsQG8o2MLO9+SY8bryn52vtPVykPrkDQB3wN37l/+/05INuckndDioeImIz90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aCExl2NM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aCExl2NM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AToyKnOnD1v+SUQPd1Fd3I6aomA1OJw/wBfqmGsPzWw=; b=aCExl2NMBzWUF69P81jOvU4kZr
	nLZGYt305ctQgnTzaKWUsBISvq9QAmNMl2hV3t/wyfj9enEDfbCHz3yKQeAXLMoLSdcVukekJJyLh
	AwgbhsKTa1GzAJ8Mncha0FrU8JSSkjQp3pPKdu9anORPCS0oOZ7CTmGu1EjLU5LLSJlA/44I2Rf+o
	pHk76oxVgfe3SOJRwzucCF/Ji9kkn4g0QdL9kHinszpW0XFVQI6c9EWKhYTpI50COVtc+vykRIhlH
	jizw3rYvkY9WFCGEaJcit2xbHJudw+madT1ho5GMzw/8pXScAGAQQovaCNFYQ8EGCedvlQ+CdJSRr
	ZVvP1HQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tppSQ-003zix-26;
	Wed, 05 Mar 2025 22:10:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 22:10:46 +0800
Date: Wed, 5 Mar 2025 22:10:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8hbZlCY-esYktJe@gondor.apana.org.au>
References: <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8fHyvF3GNKeVw0k@gondor.apana.org.au>
 <Z8fsXZNgEbVkZrJP@google.com>
 <Z8gBSgasXlu_0_s2@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8gBSgasXlu_0_s2@gondor.apana.org.au>

On Wed, Mar 05, 2025 at 03:46:18PM +0800, Herbert Xu wrote:
>
> > Also, please take a look at patch 2 in this series for another reason, I
> > want to make sure if your virtual address series can be used to remove
> > the !virt_addr_valid() memcpy() case completely.
> 
> Yes it should work provided that you specify the memory as nondma.

Actually you can do better than that, specify the memory as nondma
if IS_ENABLED(CONFIG_HIGHMEM), and otherwise as virt.

The idea is that we only have two hardware offload drivers, both
from Intel and they're probably not going to be used on platforms
with HIGHMEM.

So something like:

	if (IS_ENABLED(CONFIG_HIGHMEM))
		acomp_request_set_nondma(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
	else
		acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);

Of course all this would disappear if we used SG lists properly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
