Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478544;
	b=ymoz8wMYS5LiGSYeP1T/PQjmxztOvzUz0uUHb47KJOiJdRI3CdqodBxR8UavS01RTNjb
	 qyYTPgICu3yWKva+Wydqysnw3WDszFybkKCfr9E8w7b2VwxoHIPZcoCy0kLUAgVNuhyd0
	 ZIRQ98yaMaGaiHItBYnNDe9YP3cLsoHX3EC0yGukMr/ypY7rgmKgDyXzFbv6u+dXxTPii
	 JkRI3D4KKVeXYaOyb498HJqeOHm3/tkRujC7FHqYMNIyrVQ/5mhUFbVe24hCBPMN6Q37r
	 2SXn9t94+T7iw6g2V80YYbWeEJ2or9TxAJMvo6hCzlJnt4+Y85k5Tk7obHTTal6fIKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478544;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=zyTh7ykvQz+s9FkH5ObutlkuVJTiFEvX2XiA/Eo73dU=;
	b=AFvKzwJjvrnYcl7EPIWJpkcZZsihyYcQa+M/7QJSt3vYYxgrvmc08lHpPdJp4dRtZUH+
	 yJUu2ZrL2LNxWgx3KvSOM1St2jgqKCHzBECbQ0JNaQc94WNr5kpGfgXyGmonTGbKZftru
	 okbTiqmKA/+6tp41GAN53NLLe9EzsA+KZQj2JCY8eejfFbWLNYAkujhxGH2aV6nLAa7X4
	 bjyO21gH+DG0VrrXVS/mhSVUyFTDPX/3UKdz2vsZp+1VPdkB3Iy6NFdNt4LPO4zEpWtA2
	 eCh5jGUbrUimZG6Q7Ze02j3TIcT1x5H67sP8SbFN0H7w0We9w3LdUSt/YOlezhhTUbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=RNsYYjU7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D3B606A327
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 10:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86D3B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=RNsYYjU7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zyTh7ykvQz+s9FkH5ObutlkuVJTiFEvX2XiA/Eo73dU=; 
	b=RNsYYjU7uacr2YEgC0Nyq6JrON7+qx4vWGZRwQroy60I/Upson9mrzddDboqSNNTToh0xKzBMam
	DYHP6N/uoHSClWA622BkyCVuDUivJri+xrjQGFaMhUlgyVf40o8YGqRvJ//CYeaOLZOiAz4vpzwRv
	sX0IrbzUP8jYpRSyOeyOImlQTorsh00lYPEKdXiPwQ97/pBv5oFHjs0NFY09dDB5udN4G86lIpbu8
	X1yNOdXwOgJW9mBf1kU9S0ztwwwSf06tlwSh56Pts/xG5E7wXqTU/PFFeKTAsF5fZv3jMqPL60sdv
	W/XUeyckHyIkG4CApJ1SmqLUphM6fNVO8NKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRqG-0000000EEED-0D8M;
	Thu, 12 Nov 2026 18:15:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:15:40 +0800
Date: Thu, 12 Nov 2026 18:15:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2 0/2] crypto: qat - enable three-service mode for QAT
 GEN5
Message-ID: <avWRzFMEjntrIPX1@gondor.apana.org.au>
References: <20261030143019.484280-1-ahsan.atta@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030143019.484280-1-ahsan.atta@intel.com>

On Fri, Oct 30, 2026 at 02:30:17PM +0000, Ahsan Atta wrote:
> QAT GEN5 devices (qat_420xx) have enough accelerator engines to run
> three services concurrently, but the driver currently only allows a
> maximum of two to be configured at a time, matching the GEN4 limit.
> 
> This series lifts that restriction so that symmetric crypto, asymmetric
> crypto and compression can be enabled together on GEN5, as is already
> possible on GEN6 (qat_6xxx).
> 
> In summary:
> Patch #1: Define the firmware object layout, ring-to-service mapping
> and thread-to-arbiter mapping required for the sym;asym;dc
> configuration on GEN5, and register the new service combination in
> adf_cfg_services so that it can be selected through the cfg_services
> sysfs attribute.
> 
> Patch #2: Update the cfg_services ABI documentation to state that GEN5
> devices (qat_420xx) support a maximum of three combined services,
> alongside the existing GEN6 entry. Documentation only, no functional
> change.
> 
> There is an existing issue opened by Sashiko regarding the AE count when
> different services are configured on the device. That shall be addressed in
> later commits if applicable.
> 
> Changes in v2:
> - Dropped the per-service AE accounting for rate limiting in
>   three-service mode; it now uses the same AE count as the other
>   GEN4/GEN5 configurations. This also resolves the stale-count issue
>   reported by Sashiko.
> - Renamed ADF_GEN4_SYM_ASYM_DC_RING_TO_SRV_MAP to
>   ADF_420XX_SYM_ASYM_DC_RING_TO_SRV_MAP.
> 
> Bairavi Alagappan (2):
>   crypto: qat - enable three-service mode for QAT GEN5 devices
>   Documentation: qat: document three-service mode for QAT GEN5 devices
> 
>  Documentation/ABI/testing/sysfs-driver-qat    |  4 +-
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 59 ++++++++++++++++++-
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |  6 ++
>  .../intel/qat/qat_common/adf_cfg_services.c   |  3 +
>  .../intel/qat/qat_common/adf_cfg_services.h   |  1 +
>  5 files changed, 69 insertions(+), 4 deletions(-)
> 
> 
> base-commit: 9c5d66e1ea78912b8a43ce16a1c14db1357e0ae0
> -- 
> 2.50.1

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
