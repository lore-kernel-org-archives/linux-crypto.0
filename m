Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7F111AD;
	Sat, 24 Aug 2024 13:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724506957; cv=none; b=gL0Xu9c27vRgCMxmiA//DpCtSc9KCUrEwjuhquzt8KDgrZkBB+qsscQv9PTxeVrV2dUziDi1zsp2cQ3TUwVuwvDkdYKZAJLxIQSdfkUpAe0dHoe77Vmghuj8xTB9T7eUn4jMo71nBFnaEGAh8FDEDcbz34iaAT8hnKXYY0S4H1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724506957; c=relaxed/simple;
	bh=bw9ORmxsQ6caup9Mnh9BhSq+xVQNAWDa7nOcdY/pe3s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=V+VZg6ddiDtMEUGMQCgKuxZA8S7y0eSHraBuOuVRRkSOACZLjooNxo7hqITu76bI3jdfFy/rzPL3zO/jAWNuoLkBHWR1qN0w7GNYEXTHFF2I7mC2zhrvNu63ZuwfwGVgXsX1mImXf6pwzIjGOQaknA96SFUrQ+iVYEJOmq97Sy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shqtQ-0071uy-0i;
	Sat, 24 Aug 2024 21:42:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:42:09 +0800
Date: Sat, 24 Aug 2024 21:42:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: use integer wrap around to prevent deadlock on
 seq_nr overflow
Message-ID: <ZsnjMWrFP0IYJmaa@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com> wrote:
> When submitting more than 2^32 padata objects to padata_do_serial, the
> current sorting implementation incorrectly sorts padata objects with
> overflowed seq_nr, causing them to be placed before existing objects in
> the reorder list. This leads to a deadlock in the serialization process
> as padata_find_next cannot match padata->seq_nr and pd->processed
> because the padata instance with overflowed seq_nr will be selected
> next.
> 
> To fix this, we use an unsigned integer wrap around to correctly sort
> padata objects in scenarios with integer overflow.
> 
> Co-developed-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
> Signed-off-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
> Co-developed-by: Max Ferger <max.ferger@rohde-schwarz.com>
> Signed-off-by: Max Ferger <max.ferger@rohde-schwarz.com>
> Signed-off-by: Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>
> ---
> kernel/padata.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
