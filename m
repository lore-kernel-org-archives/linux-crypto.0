Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF44512C489
	for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 04:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730348058; cv=none; b=FNkqhFmbrcz4rDDClKE7jU32x9WFaxBiBO20Hg6sxSiLfEjiBkf7vGGC9fbuqFwWlkLlc+KK0yvwP20DQWVxv3T3iJ1hc0jZsvds2Q3o4R/NdMHd/NpXkBuiJwtIpGNiBMG8uiHAZs4MCeN1wPEWK0DCYZzjj4YxxGjLp4fOOcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730348058; c=relaxed/simple;
	bh=ZNlkdSXlvNSXtAvDEHw49RPNj5B/orMK0mudTXHF0sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CgTOBFNrre2z/APQU2CV92jWORN8QHGMaGksgLNzv3t6pxL53tltpBoQzUWLNKYsDxeRwxWWruqUIoQlW2OJQGZ05p8+humHj8lB5+3u/CNwBqy0jwWPiwk7z56Nb0ZdvxIYtvtoy9f6sUH4VtzRDjYxOoKoRuo2iUO6WSG+gxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KrDf6a3I; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KrDf6a3I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ofBYesOIbnsamv8jCWCh7Is1p9seqJTzPEz8/FqmI88=; b=KrDf6a3IC96egnPchBa+ZYQQa9
	LScfvzhJL0ZCUbmmTnVC8fttDzZ5GU9IFq5NDJTp9XvFGpuOU/gdRE5H5CAY+HfiTJKQcw9JMl3e3
	gBTxsdAW6Asgv602J16R364XNqGVpbrQT/QsOx/19O+dqtIyXo/7jZPQOmGgKzNpQHIopm4D89FBH
	uvW1i+dcjMc808VQU4Lb4brYuiWJJGR5IvtI3l3XdEIVCzv7emPpaOi7KPIc3r5rPmT57/I/Rcm08
	1nphRTa3B38P1X2bnR2KcxBIL+dJtbSszc2iQ8U6GJrOy+/lC2mg/wDnAmtQ2P1WrRTmO0vY2RWt9
	g3vn3IcQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t6MZK-00DQcv-08;
	Thu, 31 Oct 2024 12:13:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 31 Oct 2024 12:13:58 +0800
Date: Thu, 31 Oct 2024 12:13:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, davem@davemloft.net, hca@linux.ibm.com,
	linux390-list@tuxmaker.boeblingen.de.ibm.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/3] crypto: api - Adjust HASH_MAX_DESCSIZE for phmac
 context on s390
Message-ID: <ZyMEBg6VGVw648as@gondor.apana.org.au>
References: <20241030162235.363533-1-freude@linux.ibm.com>
 <20241030162235.363533-2-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030162235.363533-2-freude@linux.ibm.com>

On Wed, Oct 30, 2024 at 05:22:33PM +0100, Harald Freudenberger wrote:
>
> +#ifdef CONFIG_S390
> +/*
> + * The descsize for phmac on s390 exceeds the generic "worst case".
> + */
> +#define HASH_MAX_DESCSIZE	384
> +#else
>  /*
>   * Worst case is hmac(sha3-224-generic).  Its context is a nested 'shash_desc'
>   * containing a 'struct sha3_state'.
>   */
>  #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
> +#endif

Why not just increase it everywhere? It's not a big difference.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
