Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4836125
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jul 2024 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720227679; cv=none; b=S7iGnp5U3I2yLwZbFyALXkbjdJ1qBWQC6Ij/CcChMQ2/N2h/buw75/UrEEf0Bw6cZE6KL/ihQOxt2k2upKrPlDp/VliaVUub2TFdeIgYmkkEpLL+JlEWWcnX937Ru/nTJ66ngxOObEbLy7Uq7C1HpC4dzwvZea3xgd8+I7et8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720227679; c=relaxed/simple;
	bh=0IFX0zJGYqa3/+xkQgLge9uf6Yo5BCoUTXQPLert7Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o95nOXwov47LeK66xmP+AEDmawX+tlS8RIczXUXbBQdjO82FPVm7szm+JPVYRPDALqSg2m8w24l5YprPE0Z2qoibJrikkSDeExjgrcYKOqOSmnpPD5umxOutkYktX7DT+1rn1nihoJVG+5Fsa/iaJ5CGhunG4FBWktk47GZmTnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPtcG-006h1k-0a;
	Sat, 06 Jul 2024 10:49:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:49:15 +1000
Date: Sat, 6 Jul 2024 10:49:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH] Documentation: qat: fix auto_reset attribute details
Message-ID: <ZoiUi1HGwrLAAT+M@gondor.apana.org.au>
References: <20240625143657.3381-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625143657.3381-1-giovanni.cabiddu@intel.com>

On Tue, Jun 25, 2024 at 03:36:44PM +0100, Giovanni Cabiddu wrote:
> From: Damian Muszynski <damian.muszynski@intel.com>
> 
> The auto_reset attribute was introduced in kernel 6.9. Fix version and
> date in documentation.
> 
> Fixes: f5419a4239af ("crypto: qat - add auto reset on error")
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
