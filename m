Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6374812BF02;
	Sat, 28 Dec 2024 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735386393; cv=none; b=qOyrrowtVMXmzcDPE3DmZbn1VSAUA+5PAnjxKRLUeuMRX/8rZvKba5rJVlCE7evreEfRrZq8YpCCMQmFdY780fsxDK9llaUVTNqRNPkEYkVVnnVipAkH0d2/YvaXVfCRZoc7aWNg+p2fqFuUPkQCKSSDjFc9KRYJzd9j6McrSRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735386393; c=relaxed/simple;
	bh=4K1dkIy0T3YBCTmmxXct0CaEK7vfbtRvNu8w3RkKHm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6Z4ppdOxfyNMjU3feYL4BiLtEfnWVCMkZKqwxHgfXYTfwvrGGilW3kjn55htev1u2F0r/atSK0QOWKuiyqdivrIxaAu4PGQ2n+lfHdt8uBShe1zd87gQWMtMm9xGKSdgX3F55fLoTRA+vxWaiP+34iP03epEMCx4c7wPWsQmgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DeMVPGVN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DeMVPGVN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gQSGh7ChLZ6SIkGPLQOi8mUoiexMog40UKhBm2WpLzg=; b=DeMVPGVNRne4phsiqPRv7tmO+k
	N7GfT9S5FxDC4egVTsCh4yIrMFZCO2odczcyNUhXgLYtwS+uDWzMoVRIXvR0ZRTN84aUDTnjSnV50
	58ZcpbhHf7ySCIJynbMg18L/YIfBCuoenSCaUmLzGrj+vtmJZzYPIVw6RZ2o0wJTCfm6To/o5Q8eP
	pR9WNU7lC9XXI0YUtsSTFC/DfTuoDANhOWxncV+T0zyFMvJoa/iHxdlAGhC94gTMjh1q7JDQyvR+/
	j+3hYj5EE8M2Ss+WsnaZzGeMXRkGZimpkD4/vNysfQRiYcjaC0o2yiGDYc8WWVBfvrzQFotjxgvfO
	Mi8N9fLw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tRV3n-003ZCO-1H;
	Sat, 28 Dec 2024 19:46:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Dec 2024 19:46:08 +0800
Date: Sat, 28 Dec 2024 19:46:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosryahmed@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221063119.29140-3-kanchana.p.sridhar@intel.com>

On Fri, Dec 20, 2024 at 10:31:09PM -0800, Kanchana P Sridhar wrote:
> This commit adds get_batch_size(), batch_compress() and batch_decompress()
> interfaces to:

First of all we don't need a batch compress/decompress interface
because the whole point of request chaining is to supply the data
in batches.

I'm also against having a get_batch_size because the user should
be supplying as much data as they're comfortable with.  In other
words if the user is happy to give us 8 requests for iaa then it
should be happy to give us 8 requests for every implementation.

The request chaining interface should be such that processing
8 requests is always better than doing 1 request at a time as
the cost is amortised.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
