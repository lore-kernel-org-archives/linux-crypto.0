From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/3] SP800-38F / RFC3394 key wrapping
Date: Thu, 15 Oct 2015 21:20:15 +0800
Message-ID: <20151015132015.GF3981@gondor.apana.org.au>
References: <5314960.0aGFzHXOSP@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47113 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbJONUW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 09:20:22 -0400
Content-Disposition: inline
In-Reply-To: <5314960.0aGFzHXOSP@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 09:05:48AM +0200, Stephan Mueller wrote:
> Hi,
> 
> Changes v4:
> * make patch 3/3 standalone by incorporating and updating patch
> https://lkml.org/lkml/2015/6/16/342
> 
> Changes v3:
> * split patch for easier review
> * add support for full SGL handling in decrypt by adding a "fast-forward"
> function
> * significant simplification of code and removal of one memcpy per round
> * use of scatterwalk API throughout code and removal of self-written code
> * perform a full CAVS test with all AES implementations available on X86
>   (C, assembler and AES-NI)

v3 applied as we discussed earlier.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
