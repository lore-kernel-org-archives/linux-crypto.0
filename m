Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DCE15278E;
	Mon, 27 Jul 2026 00:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112409; cv=none; b=nf1Qy1koI1T9Gwa4Z8MLNxUj6zF7ZKhjnSa2QW0n0rNR5DCyOA4DMlT5cc8CNwJjan03LFYzBnuwe0HYAchTG8yMhCnFAWh95QKuK61+gGYuIyAWuPvMJIg1V4GYklbdPUzDhRKJTdOMGJx8+CG2oHwGWOmdkCteGp6eltqpahA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112409; c=relaxed/simple;
	bh=bnRCaOUPn6ZJckl7MpKoFfZuzBQWxJwZXbeVfC8sMks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iK0P2R/ps+NefCeEnCOdeB/ofAe2SdB3mNH6JIGXYZ3LyL8hc3rLVoroH8uqDFYr0AMg18drYwjPzq/FLGO7Er/3WrsioXZl6aPNaFHdmItgyCgTrtZsp0eAqh4nYFKdjtL7EdlWhMMtrsNFRnPcqo7VE7HEZ0kb/qfR59N5P0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dygxneMB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dygxneMB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WjZtuUblEj6An+kSvb8O6iU+ZCv/7hpRhrR5ogr7bjg=; 
	b=dygxneMBsKBRTLCe3S2r+IOW1cYLsZKRqsbaYIvPcT4xnqRuIB0FT42kVbgS5kZ9pLPjFcWHc7D
	WX30kmiaK8/tvK+NRUgG8+0Wc9T2IHKuipUXd+y7kWADHI3wvxcQ3AhxttyAYcAIkFPMmsGSjOlx3
	9FCNBobX/sOP5YygFJqFUynla+ZqIFf6wIehB1UaSHEiewUS6KMFMFZxMPaD80axH/sHGbG+qkUPX
	ySXKoY72PuEU6nPv/GVYgQlTzEvogjjeKW3fwCrGRZvd9kJ/7x0fDHXxHd5/y1oXRU5ogvmoNEdmZ
	wvcnJTitrDEE3eN6Cv7+NpJxSIx+wVvo9YYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9HT-0000000Gywe-333N;
	Mon, 27 Jul 2026 08:33:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:33:19 +1000
Date: Mon, 27 Jul 2026 10:33:19 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Can Peng <pengcan@kylinos.cn>
Cc: davem@davemloft.net, mgross@linux.intel.com, mikex.healy@intel.com,
	daniele.alessandrelli@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - publish OF module alias for OCS AES/SM4
Message-ID: <amanT_iK3Pr_HFd0@gondor.apana.org.au>
References: <20260714131442.153699-1-pengcan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714131442.153699-1-pengcan@kylinos.cn>

On Tue, Jul 14, 2026 at 09:14:42PM +0800, Can Peng wrote:
> The Keem Bay OCS AES/SM4 driver has an OF match table wired to
> .of_match_table, but does not export the table with MODULE_DEVICE_TABLE().
> 
> Although the match table lives in keembay-ocs-aes-core.o, that object is
> part of the composite keembay-ocs-aes module.  Add the missing
> MODULE_DEVICE_TABLE(of, ...) entry so modpost can generate OF module alias
> information for OF based module autoloading.
> 
> This is a source-level fix.  It does not claim dynamic hardware
> reproduction; the evidence is the driver-owned match table, its use by the
> platform driver, and the missing module alias publication.
> 
> Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
> Signed-off-by: Can Peng <pengcan@kylinos.cn>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
