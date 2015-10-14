From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 3/3] crypto: keywrap - add testmgr support
Date: Wed, 14 Oct 2015 22:26:24 +0800
Message-ID: <20151014142623.GA17455@gondor.apana.org.au>
References: <3564891.reL3VOPkWo@tachyon.chronox.de>
 <2239265.sodxccK8do@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46411 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbJNO03 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:26:29 -0400
Content-Disposition: inline
In-Reply-To: <2239265.sodxccK8do@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 08:59:56PM +0200, Stephan Mueller wrote:
>
> +		.iv_out	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d",
> +	},
> +};

This doesn't build.  Please fix and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
