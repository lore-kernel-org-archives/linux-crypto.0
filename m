Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D9C24DFF9;
	Thu, 11 Jun 2026 05:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781157059; cv=none; b=hfZgEc3k7xYObr/wyYG45ZH2tgCU/NfMO3KOUycH1Fil74+F17r/VsY1ZKxtSeKNNBRmWdhKRjfY1TzepXUpl98esGZK0YPN8Pyhe3/OcdQ47X4lm53CisvbpSnrzO/qOldxqMGEsrwVeAN8fCaXWpjt08YA+f0moH10KVbIV44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781157059; c=relaxed/simple;
	bh=aFCBRapvOXew+Noti49kRnnBaKKU2jD8tcX7iyV7Sfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSQHfquBdwO+wuOhAL8bSMlk4jtA41NE03Ltxzu0bwdZgmUQrYt1NdcGpZr3nzTzRoE7dbv8d18Nv3xDK9geJV5rNZDLQ3FqSeRhIXjsEc7YjlpW8z828Ps8nnhez4EEjrTP66jzxGfNWgc8ESrYK8hqrbrBiLkjUprRHl6SgLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PHsFQmuq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PHsFQmuq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nqS/eIx4316IuyHGDGsTI2Mit/s75slnzsaDmUc7NhU=; 
	b=PHsFQmuq1Z2V1HiPubIPvX4M8kGjH9eqqFv3hpzoti55/gcKnKwu9U7vyL4R+/pPRcSshgHHwBC
	iPUn5K5MobboF+N7OlRnEfRRd7/h9ZajuV54EWlp1wOAv/QHahgcKaDYYcqDhOKq66Exo3YNEAIIU
	LaNJIgn3QwTZfEi4OsiTMUTq7jZS/NTJNLDtjV9xt2hXVfHHLJkXD+/qHMIvvZXQFG6IwtdDLZs5l
	6sM1CP7SrzKbKiVSjoXHer41qbnFut1jkydXowuDXP7KhcbskusC9HO4SFQslZps1OPgQC7KiCpph
	T2Us3L5y8ic/9scnHYWkjEd+enLSYq82il/A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXYJa-00000004UZM-0NLn;
	Thu, 11 Jun 2026 13:50:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:50:54 +0800
Date: Thu, 11 Jun 2026 13:50:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v13 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aipMvkD_Y4NO4hfR@gondor.apana.org.au>
References: <20260604165210.1141842-1-pavitrakumarm@vayavyalabs.com>
 <20260604165210.1141842-3-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604165210.1141842-3-pavitrakumarm@vayavyalabs.com>

On Thu, Jun 04, 2026 at 10:22:08PM +0530, Pavitrakumar Managutte wrote:
> Add ahash support to SPAcc driver.
> Below are the hash algos supported:
> - cmac(aes)
> - xcbc(aes)
> - cmac(sm4)
> - xcbc(sm4)
> - hmac(md5)
> - md5
> - hmac(sha1)
> - sha1
> - sha224
> - sha256
> - sha384
> - sha512
> - hmac(sha224)
> - hmac(sha256)
> - hmac(sha384)
> - hmac(sha512)
> - sha3-224
> - sha3-256
> - sha3-384
> - sha3-512
> - michael_mic
> 
> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Acked-by: Ross Bannerman <rbannerm@synopsys.com>
> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
> ---
>  drivers/crypto/dwc-spacc/spacc_ahash.c     |  897 ++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.c      | 1311 ++++++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h      |  838 +++++++++++++
>  drivers/crypto/dwc-spacc/spacc_device.c    |  275 ++++
>  drivers/crypto/dwc-spacc/spacc_device.h    |  237 ++++
>  drivers/crypto/dwc-spacc/spacc_hal.c       |  374 ++++++
>  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 ++
>  drivers/crypto/dwc-spacc/spacc_interrupt.c |  329 +++++
>  drivers/crypto/dwc-spacc/spacc_manager.c   |  611 +++++++++
>  9 files changed, 4986 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c

Please also check the Sashiko comments, some of those look alarming:

https://sashiko.dev/#/patchset/20260604165210.1141842-1-pavitrakumarm%40vayavyalabs.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
