From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser
 actions
Date: Fri, 15 Apr 2016 13:58:51 +0800
Message-ID: <20160415055851.GA29682@gondor.apana.org.au>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <50351949.oWvfu4SbDk@tauon.atsec.com>
 <AM3PR04MB1300D3E01F404CA61D833C3DB8970@AM3PR04MB1300.eurprd04.prod.outlook.com>
 <1694759.CAoKSHjcSd@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43051 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbcDOF66 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 01:58:58 -0400
Content-Disposition: inline
In-Reply-To: <1694759.CAoKSHjcSd@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 14, 2016 at 05:38:08PM +0200, Stephan Mueller wrote:
>
> > I don't think this is really needed. memzero_explicit is used only on stack
> > variables that get cleared just before they go out of scope.
> 
> Are you so sure that a compiler is not getting smart on seeing a memset 
> followed by a free without marking the pointer as volatile? You free the 
> pointer immediately after memset(). I would not want to bet anything that a 
> compiler would leave the memset for non-volatile pointers.
> 
> Besides, memzero_expicit does not cost anything -- it does not add any 
> instruction but convinces the compiler to not optimize it away.

memzero_explicit is only meant for stack pointers, so there is
no need to use it here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
