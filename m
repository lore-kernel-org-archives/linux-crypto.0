Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB072367DC;
	Thu, 26 Mar 2026 09:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516486; cv=none; b=QXPGx2IK/iK6pIXGjCuqYwHWEFdNtRtqYPt/0rps7/qkqW6AkxCzgt4K4fAZW3MCV0ABULU17ziHRN5w/wPXz/lLV+oYVk915rXp/0MFeE+OezwGQgcnavO/oHmEpFyByKMgXZvjj12cZU7mG3K2WK2iaSdxwR1Kjnz8iUyV3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516486; c=relaxed/simple;
	bh=igo2bTRModl+JFh+OPUsk8tW6JJpTWtOF++w5IRCS50=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JYQaU1/r+GSeV+MsdUYUpxDyXQB652Oolsc0fHqSK2U5gSOzawVGSl2R+tiqwqf1q+XqRl8xhR6o1vLxKppiI9o4Wr+4LsM6kyBDm4+9KtdGpouKcAaaS5sxzi9S3yEqfU3wGG0tTszMWSRm8PuKfW5vfPx4PHkEXREFJKZ7mdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iuvlneNR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iuvlneNR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=U3Oro36vSFFJ3w1Bhnm6eGqMXSlY/att/G4pK8K43Rw=; b=iuvlneNRoTejTMz9qTAgatP7yB
	XnrqKK5lAxY2/jFh/auWUCXrtz3gC5V4CGSGIbAz/idXMdy3cUFVcpdC9jaRNiEHf7A6UKSZPMbtz
	LeAaSQLrBLj6o/lwMCtUb/3BdVisXG003hNtNv19d8BltRkMdcohTVLW+0AxC1hAxHHF0mwIg5TZN
	pOvn1qFuwo1m6g5Auf4onuQXZBQePDYPVKW4xhNezth2Vm9NtHgW7EWFFwVXKIg73ioW0fOP8CVB0
	zB4u+L3qIf6suB1yXcGQS+DD75bZmKijBdTE1zM9QPG60cSj5GxVWvCRO2zlsleGQ2G1hqFCxoxSo
	sRqfy9cA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5gO3-001FrZ-2y;
	Thu, 26 Mar 2026 17:14:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 18:14:38 +0900
Date: Thu, 26 Mar 2026 18:14:38 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Norbert Szetei <norbert@doyensec.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - fix NULL pointer dereference in
 scatterwalk
Message-ID: <acT4_uHfBS8TSaZq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <735D2FB1-6154-463F-AE93-026C40BE77B2@doyensec.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Norbert Szetei <norbert@doyensec.com> wrote:
> From: Norbert Szetei <norbert@doyensec.com>
> Date: Wed, 25 Mar 2026 18:26:13 +0100
> Subject: [PATCH] crypto: af-alg - fix NULL pointer dereference in scatterwalk
> 
> The AF_ALG interface fails to unmark the end of a Scatter/Gather List (SGL)
> when chaining a new af_alg_tsgl structure. If a sendmsg() fills an SGL
> exactly to MAX_SGL_ENTS, the last entry is marked as the end. A subsequent
> sendmsg() allocates a new SGL and chains it, but fails to clear the end
> marker on the previous SGL's last data entry.
> 
> This causes the crypto scatterwalk to hit a premature end, returning NULL
> on sg_next() and leading to a kernel panic during dereference.
> 
> Fix this by explicitly unmarking the end of the previous SGL when
> performing sg_chain() in af_alg_alloc_tsgl().
> 
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")

I think this goes back to the very first commit of algif_skcipher so
I've adjusted the Fixes accordingly.

> Signed-off-by: Norbert Szetei <norbert@doyensec.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
