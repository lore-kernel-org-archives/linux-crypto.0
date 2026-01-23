Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD9363C7A;
	Fri, 23 Jan 2026 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769147664; cv=none; b=cnHq/f3DgUfOu2onSDx1Cew1tqfJnRMTOFO0/PLRMNyHddJs/JXQrb1AfwlfCuPnBfthdSbvbW0lBU0pGCvyWcozFxLX3f9gGNgNKVgY3i798+zF5eH9MLqegU8j+/SrY9AgXh1fYcNE7OWGrcLQntvZVgbAh3IR1SuNpSh+HH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769147664; c=relaxed/simple;
	bh=x9losJsaZs14xXgmJTxnciBeHzxV8JyXO+rUMMs+97M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jlqc937UCM4gZeqRssmyZxfkHV7NP/hqOHoYRFmurR0BzbHCt8xCKAYNTPPxUNgxk2rb3c1k7UIDBdddjpvZCW6brrhpkHf3fv0qG8n6FmqHX9rRuRwCQ7PbKcNsl0Vavh/FaQhUcwBwlzlfxy8nBbD+q9bJp3OMpzMhFvw7VgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LZqoBSxj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LZqoBSxj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s9Yo3/ql7MbFKqpUVZCOelnBMGGWc4CKq7+A5r+Gd3Q=; 
	b=LZqoBSxjmLw6HD6QWrPdaqNVmk1MJXohNAYRDQEjzYEYO3iqK2rPZzxdPGqrS+7ZeyhablJWXR2
	nOPCScPAXIihazyabNAbilexhMWCRulqrFmfRNKKfftG+KwvSOjxEjDxVX6nJDj9gK86NtOmm99K5
	aHzgbJu2RIgwVZUAW34CwZEofmvrGatQESIguvfdR+bepcGtUVmiFeUQ/wLtjxa/q7PICp1gdqcjZ
	5glNeCuEPJ8vapDXbKshGMY1aAKfgda5yOmPU7MK4mSFrAcZon6TxWBsaLjs77+GWQYXHqSq2Gp4R
	P+fg4si2+aAOr1EEdQ2D57/7U1CoKu/7ayZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjA7T-001VLc-2x;
	Fri, 23 Jan 2026 13:54:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 13:54:07 +0800
Date: Fri, 23 Jan 2026 13:54:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, michal.simek@amd.com,
	linux-arm-kernel@lists.infradead.org, jay.buddhabhatti@amd.com
Subject: Re: [PATCH v2 00/14] crypto: zynqmp-aes-gcm: Bug fixes and aes-gcm
 support for Versal
Message-ID: <aXMM_zaGqzlNMtL7@gondor.apana.org.au>
References: <20251220155905.346790-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220155905.346790-1-h.jain@amd.com>

On Sat, Dec 20, 2025 at 09:28:51PM +0530, Harsh Jain wrote:
> This series includes bug fixes and adds aes-gcm support for Versal device.
> It is based on cryptodev-2.6 tree.
> 
> Changes in V2:
> - Rebase series to cryptodev-2.6
> - Register H/W keys with gcm(paes) 
> 
> Harsh Jain (14):
>   firmware: zynqmp: Move crypto API's to separate file
>   crypto: zynqmp-aes-gcm: cleanup: Remove union from zynqmp_aead_drv_ctx
>   firmware: zynqmp: Add helper API to self discovery the device
>   dt-bindings: crypto: Mark zynqmp-aes as Deprecated
>   crypto: zynqmp-aes-gcm: Update probe to self discover the device
>   crypto: zynqmp-aes-gcm: Return linux error code instead of firmware
>     error code
>   crypto: zynqmp-aes-gcm: Avoid Encrypt request to fallback for authsize
>     < 16
>   crypto: zynqmp-aes-gcm: Avoid submitting fallback requests to engine
>   crypto: zynqmp-aes-gcm: Register H/W key support with paes
>   crypto: xilinx: Replace zynqmp prefix with xilinx
>   crypto: zynqmp-aes-gcm: Change coherent DMA to streaming DMA API
>   firmware: xilinx: Add firmware API's to support aes-gcm in Versal
>     device
>   crypto: xilinx: cleanup: Remove un-necessary typecast operation
>   crypto: xilinx: Add gcm(aes) support for AMD/Xilinx Versal device
> 
>  .../bindings/crypto/xlnx,zynqmp-aes.yaml      |    2 +
>  .../firmware/xilinx/xlnx,zynqmp-firmware.yaml |    1 +
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c        | 1007 +++++++++++++----
>  drivers/firmware/xilinx/Makefile              |    2 +-
>  drivers/firmware/xilinx/zynqmp-crypto.c       |  239 ++++
>  drivers/firmware/xilinx/zynqmp.c              |   49 -
>  include/linux/firmware/xlnx-zynqmp-crypto.h   |  119 ++
>  include/linux/firmware/xlnx-zynqmp.h          |   14 +-
>  8 files changed, 1155 insertions(+), 278 deletions(-)
>  create mode 100644 drivers/firmware/xilinx/zynqmp-crypto.c
>  create mode 100644 include/linux/firmware/xlnx-zynqmp-crypto.h
> 
> -- 
> 2.49.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
