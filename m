From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Tue, 28 Jun 2016 15:51:08 +0800
Message-ID: <20160628075108.GA15610@gondor.apana.org.au>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
 <20160613085612.GA7333@gondor.apana.org.au>
 <20160622155350.GA22247@sivswdev01.ir.intel.com>
 <20160623105034.GA10475@gondor.apana.org.au>
 <20160624083728.GA15549@sivswdev01.ir.intel.com>
 <20160624092643.GA18935@gondor.apana.org.au>
 <20160628074141.GA7321@sivswdev01.ir.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51465 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbcF1HvO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 03:51:14 -0400
Content-Disposition: inline
In-Reply-To: <20160628074141.GA7321@sivswdev01.ir.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 28, 2016 at 08:41:42AM +0100, Giovanni Cabiddu wrote:
>
> Are you suggesting a different cache of scratch buffers for every
> algorithm implementation or a shared cache shared across all legacy
> scomp algorithms?

One that's shared for every scomp algorithm.

> Would it be ok 128K instead?
> We are proposing to use the acomp API from BTRFS. Limiting the size
> of the source and destination buffers to 64K would not work since
> BTRFS usually compresses 128KB. 
> Here is the RFC sent by Weigang to the BTFS list:
> http://www.spinics.net/lists/linux-btrfs/msg56648.html

While I don't see any big differences between 64K and 128K, I have
noticed that btrfs is already doing partial decompression on a
page-by-page basis, which is the most optimal setup.

So whatever we do for this conversion we should make sure that
btrfs does not regress into using vmalloc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
