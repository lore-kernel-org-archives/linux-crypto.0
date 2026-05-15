Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47603CB2C7;
	Fri, 15 May 2026 10:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840573; cv=none; b=fbjzSRtH5Ew49uvRfxTigQf5Rl/51/+tnAfGpac5f7+rlHNCHIPfsXRH9IrRwwU866CqaVE0Yd0Uj8RYttAlwEcSe2U0Aud2lTpsb7GIkZGWDyxoGWQKk5eqWiiSp8ZrSzH3xN22BIQoGb0FMHY9MBoXfyYYrapH7bMqrmy7dnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840573; c=relaxed/simple;
	bh=+3suQ19nyjis/Xz9427/DbkvOogpg3BJaI3nouIbudM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSt6Yta5nrrx59FYlQHDTO3As2PZ9O/c8qkl19Ms2UWHg1dqDpXs6yT4PqEQ28KHlpv/KH8ca4Lsz6jgF3HmPKbGnDeg9YtIE+IcwhXK0mFI/zhvkKtPCyM836pfsrp5I0w2DbbCFqItzVV2P35/xOKnrPPWrntlLp6LUuv6WY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=CXPbGaXa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="CXPbGaXa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Q3wUhTurdEDhvDGgFRW5TeeNS1XMn+B0qucNOV2aHCI=; 
	b=CXPbGaXaZN8zoF0x4+xTc3TxfUYmfA0/IcomOQc7Gv2CyOWAIIJgjyskyqF/01wsxXNzEewAOQk
	HlOJslogVkdPltbBrjFOxTfJvhihpDJwQCtU1jtOJkGQzJdY3WDfIQJ2CiZBijTm4U2GeMLRZQooT
	ISk95w6lK4M3FB6d1xuekV08+pSeps7QPsRupcEm4wup1ehPHvgyq3/Vmf3j0nzInbPDiDaYiKsHT
	2/ZrNbpA/fXLSnrmicmxsAo1pjgtZbXChb43AKiP1OG9pGi1QMphqorQ+rdgotn3Y8vlGdzVx6yXH
	ISLL9PeTxKGlUWg8j6Upv0/SBQPpF2LAtQlQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpgr-00EOX9-2y;
	Fri, 15 May 2026 18:22:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:22:45 +0800
Date: Fri, 15 May 2026 18:22:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stepan Ionichev <sozdayvek@gmail.com>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, aik@amd.com,
	john.allen@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp: sev-dev-tsm: bail out early when
 pdev->bus is NULL
Message-ID: <agbz9bZGHYfoNyWg@gondor.apana.org.au>
References: <20260507023619.398-1-sozdayvek@gmail.com>
 <20260507140608.8612-1-sozdayvek@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507140608.8612-1-sozdayvek@gmail.com>

On Thu, May 07, 2026 at 07:06:08PM +0500, Stepan Ionichev wrote:
> dsm_create() initially checks pdev->bus when computing segment_id:
> 
> 	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
> 
> But the next two lines unconditionally dereference pdev->bus via
> pcie_find_root_port() and especially pci_dev_id(pdev), which expands
> to PCI_DEVID(dev->bus->number, dev->devfn). If pdev->bus is in fact
> NULL, segment_id is initialised to 0 but the very next statement
> crashes the kernel.
> 
> smatch flags this:
> 
>   drivers/crypto/ccp/sev-dev-tsm.c:253 dsm_create() error: we
>     previously assumed 'pdev->bus' could be null (see line 251)
> 
> Make the NULL handling consistent: if pdev->bus is NULL the device
> has no PCI context to work with and SEV TIO setup cannot proceed,
> so return -ENODEV before any of the bus-dependent lookups. The
> remaining initialisation now runs only on the path where pdev->bus
> is known to be valid.
> 
> No change for callers where pdev->bus is non-NULL, which is the
> only case where dsm_create() did meaningful work before this change.
> 
> Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
> ---
> v2:
> - Add Fixes: tag (suggested by Tom Lendacky).
> - Cc Alexey Kardashevskiy (original author of the SEV-TIO code).
> 
>  drivers/crypto/ccp/sev-dev-tsm.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
