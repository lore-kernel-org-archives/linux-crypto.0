From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/caam: Export gen_split_key symbol for other
 modules
Date: Thu, 6 Sep 2012 13:11:43 -0700
Message-ID: <20120906201143.GA24197@gondor.apana.org.au>
References: <BD4C563D-C5E9-494F-91DD-EA145917FCEC@servergy.com>
 <20120824183550.0f27912aaf947cc035dabb9b@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ben Collins <ben.c@servergy.com>, linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:46133 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612Ab2IFULw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:11:52 -0400
Content-Disposition: inline
In-Reply-To: <20120824183550.0f27912aaf947cc035dabb9b@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 24, 2012 at 06:35:50PM -0500, Kim Phillips wrote:
> On Thu, 23 Aug 2012 18:39:57 -0400
> Ben Collins <ben.c@servergy.com> wrote:
> 
> > In 3.6-rc3, without this patch, the following error occurs with a modular build:
> > 
> > ERROR: "gen_split_key" [drivers/crypto/caam/caamhash.ko] undefined!
> > ERROR: "gen_split_key" [drivers/crypto/caam/caamalg.ko] undefined!
> > 
> > Signed-off-by: Ben Collins <ben.c@servergy.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Yuan Kang <Yuan.Kang@freescale.com>
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
