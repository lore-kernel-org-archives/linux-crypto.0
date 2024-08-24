Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BA81714B2;
	Sat, 24 Aug 2024 13:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507374; cv=none; b=GVHQpUalOsN9kJKY59+uVdKUIu1tfxUxrUxsqzBNM2GFZg7EtVTb8ZZ1sfqyZkRyGvjmgKapPsQdjDlku+RrzgN1iNVrTy1wqYeN+7mLHW5+orD3JIsPIY5KqfdOWxX9sE+2Frw7g5p4i57jPO2OlUublR340p3ajsUbZbx/tt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507374; c=relaxed/simple;
	bh=QJ+p85wvz0FKGzCIaUhYJnyY1jgwhVp+lUo1ZVcfcfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tog3ZNr6AIDa06Ok8Ka92ItmeydFeJnCt0QXl73ANS5sVWcrv3YaI4jhIrgULA9bNl9Mnn8elnPZ+q6dGkX9vGDEtSW6pdyWCuuxqvLSaDMn7xOnYds4Ze48wjFy3c72l8fypsmf11p3xjS12WKYoBMl7BZsgYTVfQhkd24SA6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shr0S-007200-0L;
	Sat, 24 Aug 2024 21:49:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:49:25 +0800
Date: Sat, 24 Aug 2024 21:49:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Liao Chen <liaochen4@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	declan.murphy@intel.com, davem@davemloft.net
Subject: Re: [PATCH -next] crypto: keembay - fix module autoloading
Message-ID: <Zsnk5eCyom-_POJe@gondor.apana.org.au>
References: <20240814024406.3875287-1-liaochen4@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814024406.3875287-1-liaochen4@huawei.com>

On Wed, Aug 14, 2024 at 02:44:06AM +0000, Liao Chen wrote:
> Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
> based on the alias from of_device_id table.
> 
> Signed-off-by: Liao Chen <liaochen4@huawei.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
