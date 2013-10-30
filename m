From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: caam - Add Platform driver for Job Ring
Date: Wed, 30 Oct 2013 12:11:01 +0800
Message-ID: <20131030041101.GB2957@gondor.apana.org.au>
References: <1382682663-18651-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:40797 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702Ab3J3ELD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Oct 2013 00:11:03 -0400
Content-Disposition: inline
In-Reply-To: <1382682663-18651-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 25, 2013 at 12:01:01PM +0530, Ruchika Gupta wrote:
> The SEC Job Rings are now available as individual devices.
> This would enable sharing of job rings between kernel and
> user space. Job Rings can now be dynamically bound/unbound
> from kernel.
> 
> Changes are made in the following layers of CAAM Driver
> 1. Controller driver
>         - Does basic initialization of CAAM Block.
>         - Creates platform devices for Job Rings.
> (Earlier the initialization of Job ring  was done
>  by the controller driver)
> 
> 2. JobRing Platform driver
>         - Manages the platform Job Ring devices created
>           by the controller driver
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
> Reviewed-by: Garg Vakul-B16394 <vakul@freescale.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
