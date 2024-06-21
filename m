Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59388152E12;
	Fri, 21 Jun 2024 12:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718972926; cv=none; b=QKPv08/EHyOGNG1wft/xQw5WMX5Dl7RHbc/O5U3YoqV1ZPz+DJ21acQFvldxMYlc6VwvvPMtllJp1hoz61P8pK0mH7Eux1HQKAPcQmIZDTOeRX0laMaCRoSy0qYFXZKX3YMOPVZoLCnWv7xhYzTqFmnpA1efyNWKgpOxK9nRl9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718972926; c=relaxed/simple;
	bh=Kezbc0dwmXoo7ppANLaQEvwaaHt1xvW6QlWJOBcasE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zs9DkImAqYo4mnV374Cwr2bmBlT3V+Iu1Vx8U5GZEkZ/r5iEqBf71jfRuw1DozLhfOzaR3M5MDb9Og+lbroOLMopJiGVm/nZIbQIIch349GrdGn5dSWlppQyyU1qBwlXvAsoeHr3f7CP1UDI/C0Hh0PrA/u6BRyVaCX9AIvF40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdN9-002efo-26;
	Fri, 21 Jun 2024 22:28:08 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:28:08 +1000
Date: Fri, 21 Jun 2024 22:28:08 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Adam Guerin <adam.guerin@intel.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: make adf_ctl_class constant
Message-ID: <ZnVx2HlOOc7UglYv@gondor.apana.org.au>
References: <2024061050-scale-presume-f311@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024061050-scale-presume-f311@gregkh>

On Mon, Jun 10, 2024 at 10:18:51AM +0200, Greg Kroah-Hartman wrote:
> Now that the driver core allows for struct class to be in read-only
> memory, we should make all 'class' structures declared at build time
> placing them into read-only memory, instead of having to be dynamically
> allocated at runtime.
> 
> Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Adam Guerin <adam.guerin@intel.com>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
> Cc: Shashank Gupta <shashank.gupta@intel.com>
> Cc: qat-linux@intel.com
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  .../crypto/intel/qat/qat_common/adf_ctl_drv.c | 21 +++++++++++--------
>  1 file changed, 12 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
