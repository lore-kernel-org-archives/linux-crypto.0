Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA9D4EA36D
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 09:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055385; cv=none; b=Mn/uNIkY8bWEMB8CunjgQmDuUSdkTgLmJ7Zq1cfH7nLiWFSSqdRRFXElWMB9nVnWB+WY13MXqEGD1rEkpjsdWcIbPrPN2X34V9UyJd1JoxKXfIgZ/aOqUb+HYebCozrO3ui0a3O3ImeaPW0zkrUfZg6M/EXAKjYm+QqFwrbxrr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055385; c=relaxed/simple;
	bh=bTuKz4n1fmn1wLnjWZzIPkNtadi1Bpcotyp3TpPNmKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNrSQW26O1+FR8jHdVWs5PYuszyL4YUQsfl7KwRvuQHc90inNOcu+RhrfXKxgvRLSbzTd44XFVWcFGWT+SSPDZvyOv98Vd8HsY8zrZjbJbw8BkgEYlRNf0AUADpv4ots4BTD+WgawEvTHTQ9Kjg1qXZx5qxWBo1O/AxFS/FZH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lS8wbTVC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lS8wbTVC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=K/SfvTgQE58/87bdmkJrLAzdL+yIyNAIajlL2I7ljdo=; 
	b=lS8wbTVCTxdDmB47nzvUGzvSFXwjhLOJQWuKSIcnS9l+KPe5wxY9CLlsBuuQ9FmE8ZTKN5gjKK0
	uxOm+BD9s7SQ+xK/1s6V1XWvKOru36tfCiA2JLk0TowQ/IgWWXS32ujeH/PDAB3wIafHUhIHMJ4BB
	D4t0zcOKoxY1SL1Le99O53cB1UOaevze87udMd0WL58xerg1UFV3fc3fXGh9hUSrnarVboV7Bd/1E
	/SYZp9B3kidDKxtz0o/A433ZAGOfAFTcAJM++geJVFgaJ9V5DABQ1yu+D78L8xv8rYg2hRrQmtOU+
	8plmn1D30QGwMlymngAKMZzE+GA+xLEciFzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHHSv-000000046rE-2BRi;
	Thu, 15 Oct 2026 17:09:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:09:33 +1100
Date: Thu, 15 Oct 2026 20:09:33 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - enable three-service mode for QAT GEN5
Message-ID: <atCYTTHMcE2KvMjf@gondor.apana.org.au>
References: <20261006144840.2514754-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006144840.2514754-1-ahsan.atta@intel.com>

On Tue, Oct 06, 2026 at 03:48:38PM +0100, Ahsan Atta wrote:
> QAT GEN5 devices (qat_420xx) have enough accelerator engines to run
> three services concurrently, but the driver currently only allows a
> maximum of two to be configured at a time, matching the GEN4 limit.
> 
> This series lifts that restriction so that symmetric crypto, asymmetric
> crypto and compression can be enabled together on GEN5, as is already
> possible on GEN6 (qat_6xxx).
> 
> In summary:
> Patch #1: Define the firmware object layout, ring-to-service mapping,
> thread-to-arbiter mapping and service-to-accelerator-engine accounting
> required for the sym;asym;dc configuration on GEN5, and register the
> new service combination in adf_cfg_services so that it can be selected
> through the cfg_services sysfs attribute.
> 
> Patch #2: Update the cfg_services ABI documentation to state that GEN5
> devices (qat_420xx) support a maximum of three combined services,
> alongside the existing GEN6 entry. Documentation only, no functional
> change.
> 
> Bairavi Alagappan (2):
>   crypto: qat - enable three-service mode for QAT GEN5 devices
>   Documentation: qat: document three-service mode for QAT GEN5 devices
> 
>  Documentation/ABI/testing/sysfs-driver-qat    |   4 +-
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 104 +++++++++++++++++-
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |   6 +
>  .../intel/qat/qat_common/adf_cfg_services.c   |   3 +
>  .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
>  5 files changed, 113 insertions(+), 5 deletions(-)
> 
> 
> base-commit: 32117b78aa099e5991df76c34ffbe18260342ff6
> -- 
> 2.50.1

Please check the Sashiko review:

https://sashiko.dev/#/patchset/20261006144840.2514754-1-ahsan.atta%40intel.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
