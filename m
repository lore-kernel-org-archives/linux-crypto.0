Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D6917C98
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 00:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741221649; cv=none; b=rzhIqkYon+26XuDdNNMEmTqKnCfLumYdp9RaETqVrbwoIWfoQ6dJzSpLAvBRhxoT3pB9803PB4+HmUcy36eSpAYQROoKhcz0EN8zp9P4uoqtpJ2uVuSggsfQgw9RfvSL1EXyUF604dVvxHTmnSIaxMmGRfwQ/HIt4rnr9aJW0bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741221649; c=relaxed/simple;
	bh=u9JyBj7XJzRhVgOsD5L3KCdlp9/erNjRRs1be4CzSfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMB9TyyDBHuuJttAV0N63tMczVJvdHWNptbZx1cw2r3OydGw+0EwGgTjvbX9lY0IJoVJHskm+kMfHFv40yGWVALhkUFzK7rGkbP3/xjhXWsNEixD4H5mnZttjzIAtCIkm6ywz/1Z7D37YEC9L58J2VpC+sWuXCqMDq4IEsTJD2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JvMMvT6h; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JvMMvT6h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ohH1185Na6KXSfmzmI23KVm4RM6mKbU8oHns1dwUWjw=; b=JvMMvT6hQsYLc0fsUVb8n53/cL
	6px6ShuSbDQauCbsWpFHdWSD9TvzFhOHGnlNC9tj5PhgaDfcjYqXNhRJcSr0ppq3J80gvr9LexuRD
	+oZ6FM34mQublv2I/eYlGiJgqcdlo58prLr5aqeldDQ9zhPwFuVvY9SlpSf2bnuZNiNQxZeGrkEYT
	cuMc/5FnF7pmycKA2d822mW+82QIOux9zyjVRf2J315IcYOCA8evNK9iyDFmj+hzBTXexP/kE5lty
	fztLizPO9bX6oTt58lZAppkSJDOsApOIGwLNo6mpHmui2KcxiU29+Lx1lMy9wj69X66TBcsNfQFui
	RpLoKsOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpzHn-0048tW-1Q;
	Thu, 06 Mar 2025 08:40:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 08:40:27 +0800
Date: Thu, 6 Mar 2025 08:40:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8ju-_hOYV0wO1SF@gondor.apana.org.au>
References: <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8fHyvF3GNKeVw0k@gondor.apana.org.au>
 <Z8fsXZNgEbVkZrJP@google.com>
 <Z8gBSgasXlu_0_s2@gondor.apana.org.au>
 <Z8hbZlCY-esYktJe@gondor.apana.org.au>
 <Z8h7CJYO6OxkVXhy@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8h7CJYO6OxkVXhy@google.com>

On Wed, Mar 05, 2025 at 04:25:44PM +0000, Yosry Ahmed wrote:
>
> Zswap is already using an SG list when calling into the crypto API. The
> problem is that SGs (i.e. sg_init_one()) does not support kmap highmem
> addresses. Is there a fundamental reason this can't happen, or is it
> just sg_set_bug() using virt_to_page().

The whole point of SG lists is so that you don't need to kmap it
until the data is actually accessed.  Putting kmapped memory into
the SG lists defeats the purpose.

> Also, since the crypto API is using SG lists internally as far as I can
> tell, how does acomp_request_set_nondma() essentially deal with this? I
> don't understand why we need to use a separate nondma API for highmem.

I will post another acomp update soon where the hardware offload
path (the only one that can't deal with nondma) will simply fall
back to software compression if it sees a nondma address.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
