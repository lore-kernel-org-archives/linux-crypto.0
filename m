Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE24B1475;
	Wed, 16 Sep 2026 09:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552719; cv=none; b=fbS3AGPmhVXpNapUB78RcNgJQ+kUEPbhw1xqbi3iU3PYZ4+eOBoJj/PP/pgBptq+8Dh1jHdyJReeMA44NSEERsbt7zB9UuFCeTDaaGaPgn6kUdkSarUmhS08qAi9FoB4guo6I2oab1KeIxxDPj+o494JE5bVEapOsBhxZjnRVmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552719; c=relaxed/simple;
	bh=09QxOegCltAhsTdvDQLtRpFg6Vj5dGrtW8BSN13HBWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsNrE6UksyqSNnPuG0sNNP3reBLA0hROu9b1K3Ur24e8b5qWOFgiIowAQG2DjKzzU6RHs+fGbuksWf5Ym3sB8MVssGS/+XCeH/9gb3spukcUBTJ48TbsN50oDqw+xryPrIMKTgAelKq30SNFxe30yJqfFdMKzcL2dgGJ/p7fVcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SLL7wAbf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SLL7wAbf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fJERUKem0y70lXHoy9ClpYXrks5/nKOFERkXxUtyEbI=; 
	b=SLL7wAbf2ZVO0RuQcq1w35MOVvyzm0vHyC158jmxQ+/NxgdQhAY4krNbPPPtgceeU0iY0/HENdq
	OH32bG0+5LyZrXP2k4LSlYykgpeKYyRqu/d6qMYPRj0ARQv8Dg0xLQDWUGicP2WsStioTXf3UYgri
	gEvQiVpZ+YLIG7SAxKtqki80RmGcE6tiHO3aAunkYAZ+i8HPjANZFOKtv2O2tMbE2ZOIL7+mXSJJ4
	h7hBRLFXJ6icmLcF8JMXMTC3KYPzQ8ilONEFFz3RF8H2u2ALT7hPcfHI2WWQIF/lbUqg6oBMNfEiU
	F0i+ZxiAWR0AFkptFUG7NwzoxDGN6Bv+KviA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6mPK-0000000EZCQ-1kXX;
	Wed, 16 Sep 2026 17:58:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 19:58:26 +1000
Date: Wed, 16 Sep 2026 19:58:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp.h - repair all kernel-doc comments
Message-ID: <aqpoQvtD4pl-bnBZ@gondor.apana.org.au>
References: <20260901185438.31038-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901185438.31038-1-rdunlap@infradead.org>

On Tue, Sep 01, 2026 at 11:54:38AM -0700, Randy Dunlap wrote:
> Eliminate all kernel-doc warnings in <linux/ccp.h>:
> - add Returns: for function return values
> - use the enum keyword when describing an enum in kernel-doc
> - add missing enum value descriptions
> - add or repair missing struct member descriptions
> - use nested struct notation as needed
> 
> Warning: include/linux/ccp.h:30 No description found for return value
>  of 'ccp_present'
> Warning: include/linux/ccp.h:42 No description found for return value
>  of 'ccp_version'
> Warning: include/linux/ccp.h:67 No description found for return value
>  of 'ccp_enqueue_cmd'
> Warning: include/linux/ccp.h:97 cannot understand function prototype:
>  'enum ccp_aes_type'
> Warning: include/linux/ccp.h:114 cannot understand function prototype:
>  'enum ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GHASH' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GCTR' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GCM' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GMAC' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:134 cannot understand function prototype:
>  'enum ccp_aes_action'
> Warning: include/linux/ccp.h:190 struct member 'authsize' not described
>  in 'ccp_aes_engine'
> Warning: include/linux/ccp.h:190 struct member 'aad_len' not described
>  in 'ccp_aes_engine'
> Warning: include/linux/ccp.h:202 cannot understand function prototype:
>  'enum ccp_xts_aes_unit_size'
> Warning: include/linux/ccp.h:245 struct member 'type' not described in
>  'ccp_xts_aes_engine'
> Warning: include/linux/ccp.h:255 cannot understand function prototype:
>  'enum ccp_sha_type'
> Warning: include/linux/ccp.h:394 cannot understand function prototype:
>  'enum ccp_passthru_bitwise'
> Warning: include/linux/ccp.h:410 cannot understand function prototype:
>  'enum ccp_passthru_byteswap'
> Warning: include/linux/ccp.h:472 struct member 'src_dma' not described
>  in 'ccp_passthru_nomap_engine'
> Warning: include/linux/ccp.h:472 struct member 'dst_dma' not described
>  in 'ccp_passthru_nomap_engine'
> Warning: include/linux/ccp.h:472 Excess struct member 'src' description in
>  'ccp_passthru_nomap_engine' (did you mean one of: 'src_len', 'src_dma')
> Warning: include/linux/ccp.h:472 Excess struct member 'dst' description in
>  'ccp_passthru_nomap_engine' (did you mean one of: 'dst_dma')
> Warning: include/linux/ccp.h:489 cannot understand function prototype:
>  'enum ccp_ecc_function'
> Warning: include/linux/ccp.h:587 struct member 'u' not described in
>  'ccp_ecc_engine'
> Warning: include/linux/ccp.h:587 Excess struct member 'mm' description in
>  'ccp_ecc_engine' (did you mean one of: 'u.mm')
> Warning: include/linux/ccp.h:587 Excess struct member 'pm' description in
>  'ccp_ecc_engine' (did you mean one of: 'u.pm')
> Warning: include/linux/ccp.h:602 cannot understand function prototype:
>  'enum ccp_engine'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> 
>  include/linux/ccp.h |   58 +++++++++++++++++++++++++++---------------
>  1 file changed, 38 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
