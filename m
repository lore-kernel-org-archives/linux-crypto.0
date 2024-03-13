Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DBDAD56;
	Wed, 13 Mar 2024 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294315; cv=none; b=emoT5yfoEh0lpH8aAz+7ThgPSKYAf8baM1jqEdmQZPqE/+Qex8WmDIdYujzwoK6x6brrJV5cCdklw8ne3elvdtFD5VI/Mc/PJtLqbK8XRdPH3vmHZEZuK3cq9tdZvT3mBEni2XxR6SxyR5b2ZYALYxTC0kDgGLhj7uoRFUVy7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294315; c=relaxed/simple;
	bh=TyI/Ftlwwoqk8hZ4P+yJVQ6eUlU2Ul5aDOdMXow+c7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1Lu4a1vVrClZUl6mTzj10lRRLPr6sJywJDUKYuNTrBPsh7gUIaXg3F/P525IchKQCGryaA0vNrHkTJiYyrEmRarZisFdUX8Nz7lufK4Oi21TURUwpOcWPSPuJrUKTci/dPMgwmlG0mhQjfwcDcePC80g5ChA+8heuSH591MdMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rkDfv-006L3a-Uw; Wed, 13 Mar 2024 09:45:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 13 Mar 2024 09:45:15 +0800
Date: Wed, 13 Mar 2024 09:45:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@google.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Linux Crypto List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-ID: <ZfEFKxl8/42oXv0i@gondor.apana.org.au>
References: <20240313115751.36b01158@canb.auug.org.au>
 <ZfEE2GDznBOZDXs4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfEE2GDznBOZDXs4@gondor.apana.org.au>

On Wed, Mar 13, 2024 at 09:43:52AM +0800, Herbert Xu wrote:
>
> Instead of using the non-existent crypto_comp_alg_common, it
> should do something like
> 
> 		return crypto_acomp_tfm(tfm)->__crt_alg->cra_flags & ...

Nevermind, the stats revert should not have removed acomp infrastructure
like this.

I'll revert it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
