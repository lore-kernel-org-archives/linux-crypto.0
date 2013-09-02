From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/10] Series of fixes for NX driver
Date: Mon, 2 Sep 2013 20:35:38 +1000
Message-ID: <20130902103538.GA815@gondor.apana.org.au>
References: <1377787000-4966-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:45996 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755517Ab3IBKfv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Sep 2013 06:35:51 -0400
Content-Disposition: inline
In-Reply-To: <1377787000-4966-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 29, 2013 at 11:36:30AM -0300, Marcelo Cerri wrote:
> This series of patches contains fixes in several algorithms implemented
> by the NX driver. The patches can be separated in three different
> categories:
>   
>  - Changes to split the data in several hyper calls to respect the
>    limits of data that the co-processador can handle. This affects
>    all AES modes.
>  - Fixes in how the driver handle zero length messages. This affects
>    XCBC and GCM.
>  - Fixes for SHA-2 when chunks bigger than the block size are provided.
> 
> v2:
>  - Fixed conflict.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
