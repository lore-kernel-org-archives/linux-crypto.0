From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: allow compression algs in fips mode
Date: Thu, 6 Dec 2012 17:20:14 +0800
Message-ID: <20121206092013.GD15870@gondor.apana.org.au>
References: <1353354340-4188-1-git-send-email-mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:41672 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492Ab2LFJUQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Dec 2012 04:20:16 -0500
Content-Disposition: inline
In-Reply-To: <1353354340-4188-1-git-send-email-mbroz@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 19, 2012 at 07:45:40PM +0000, Milan Broz wrote:
> When in fips mode, compression algoritms fails to initialize,
> e.g. modprobe ubifs returns
>   UBIFS error: compr_init: cannot initialize compressor lzo, error -2
> 
> FIPS mode should not care about compression algoritms at all.
> 
> Patch just set fips_enabled flag to 1 to all compression algorithms
> managed by testmgr.
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
