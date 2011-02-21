From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] picoxcell_crypto: add support for the picoxcell crypto
	engines
Date: Mon, 21 Feb 2011 16:48:34 +1100
Message-ID: <20110221054834.GB26462@gondor.apana.org.au>
References: <1297776733-17816-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39585 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1BUFsj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Feb 2011 00:48:39 -0500
Content-Disposition: inline
In-Reply-To: <1297776733-17816-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 15, 2011 at 01:32:13PM +0000, Jamie Iles wrote:
> Picochip picoXcell devices have two crypto engines, one targeted
> at IPSEC offload and the other at WCDMA layer 2 ciphering.
> 
> v2:	- use symbolic constants for key sizes etc
> 	- cleanup DDT generation
> 	- use strict_strtoul() for stat irq threshold
> 	- minor code cleanups
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Patch applied.  Thanks Jamie!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
