From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crash in ppc4xx-rng on canyonland
Date: Wed, 20 Apr 2016 17:58:15 +0800
Message-ID: <20160420095815.GA3003@gondor.apana.org.au>
References: <20160418095939.GA18915@gondor.apana.org.au>
 <14761928.ine93l7C6D@debian64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Christian Lamparter <chunkeey@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49120 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbcDTJ6U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 05:58:20 -0400
Content-Disposition: inline
In-Reply-To: <14761928.ine93l7C6D@debian64>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 18, 2016 at 01:42:49PM +0200, Christian Lamparter wrote:
>
> what else I fixed in v1->v2: 
>  - added a check to test trng device's status state with
>    of_device_is_available.
>  - if the hwrng device registration failed, the flag which
>    enables the trng was left enabled (note: the v1 code
>    disabled the hwrng device as part of crypto4xx_remove.
>    so it wasn't enabled when the crypto4xx driver was
>    unloaded)

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
