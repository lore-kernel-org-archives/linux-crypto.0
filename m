Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED963C3F73;
	Thu,  8 Oct 2026 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448540; cv=none; b=X7CMQehLMCGuoy47xRQjOXHfYjEDfmOikGIqVTNpok/hkjlXiskFaBMNfvMo42TInHrlj5YWRKu0CSZgKDT6e4Xl1PQLL0Q8CnBs2yfLs1ErJcvPcKEWTt0NG5NaUdekyJ6jc2YX2vWyLI7rMCgfGGnA+J6g5JcLG8SFoA10zmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448540; c=relaxed/simple;
	bh=Ph2FS3kEFdkb4XCKW/t9xTbC7eT4bGXrA7qNNu5JvdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBAI8DKCQ4u1dtwkRVaqJ8AnDKw99vHV8nAZitmaQiyOztLKd81G62cdH2CTjDwdWZqmqgSib3gKmedWOqGoyoDXH5vgHec9OrlsZLDZreI1y5x2SJkXJtAFcjuT2k4Thrt+QC/0wtgjkO70ClDgr+17lflw0spEox4ZuSkIA+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FaCdELf/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FaCdELf/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dYDIQxc40W32F2lkkbfE8ebUJqgi8FbP9fFvz0Y3g7k=; 
	b=FaCdELf/wlpwZSJcr7C6QqzpkFpOpvyydMFh9RSo0kRPrS7bnynXtiw2F7cyBi9rdFfKRQa6KpN
	Y4ZjRFX2iAV/xTKNdzvRS+LpY7lJof0Y+PyrCUDBUX/lspFrqDKRx8JRqgM0V3gMYY1HL+o9QI6mj
	WYmwKfVU+9Zug09dqIT5DU3TnoE7UmF7ndDdsJ4hQAto4kZ5hTA5lxYouxnK/pfGzQQXyzSbpDRFm
	dNRtBgDDUHWG4OB5+Um74aQcbGFn1NJBMo8NokyOLeyMalkhmccLTsuBhwiVVHGj0LYnfk5679j7Z
	GpOe/rMkmP0uGCcI5C9nOHAGEb1vWsXg64TQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjbC-00000001o7W-0R9U;
	Thu, 08 Oct 2026 16:35:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:35:34 +1100
Date: Thu, 8 Oct 2026 19:35:34 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tero Kristo <t-kristo@ti.com>, Keerthy <j-keerthy@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: Re: [PATCH] crypto: sa2ul - Remove unused fields
Message-ID: <asdV1nWD25Y01kqM@gondor.apana.org.au>
References: <20261002215019.14822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002215019.14822-1-ebiggers@kernel.org>

On Fri, Oct 02, 2026 at 02:50:19PM -0700, Eric Biggers wrote:
> Remove the shash, authkey, and auth fields from sa_tfm_ctx since they
> have no purpose and create confusion with fields that actually matter.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/sa2ul.c | 9 ---------
>  drivers/crypto/sa2ul.h | 3 ---
>  2 files changed, 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
