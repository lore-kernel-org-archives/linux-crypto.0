From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v1,1/3] crypto: powerpc/sha1 - assembler
Date: Mon, 2 Mar 2015 23:25:59 +1300
Message-ID: <20150302102559.GA24450@gondor.apana.org.au>
References: <ce3e5ff2-5904-4e1c-bfa9-e37c9682f961@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53684 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbCBK0G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 05:26:06 -0500
Content-Disposition: inline
In-Reply-To: <ce3e5ff2-5904-4e1c-bfa9-e37c9682f961@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 24, 2015 at 08:36:40PM +0100, Markus Stockhausen wrote:
> This is the assembler code for SHA1 implementation with
> the SIMD SPE instruction set. With the enhanced instruction 
> set we can operate on 2 32 bit words in parallel. That helps 
> reducing the time to calculate W16-W79. For increasing 
> performance even more the assembler function can compute 
> hashes for more than one 64 byte input block. 
> 
> The state of the used SPE registers is preserved via the 
> stack so we can run from interrupt context. There might 
> be the case that we interrupt ourselves and push sensitive 
> data from another context onto our stack. Clear this area
> in the stack afterwards to avoid information leakage.
> 
> The code is endian independant.
> 
> Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
