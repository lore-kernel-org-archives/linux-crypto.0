From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: use chunks smaller than algo block size in chunk
 tests
Date: Fri, 1 Aug 2014 22:40:16 +0800
Message-ID: <20140801144016.GC15005@gondor.apana.org.au>
References: <1406481530-21035-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, mpatocka@redhat.com,
	catalin.marinas@arm.com, linux@arm.linux.org.uk
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52207 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaHAOkV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Aug 2014 10:40:21 -0400
Content-Disposition: inline
In-Reply-To: <1406481530-21035-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 27, 2014 at 07:18:50PM +0200, Ard Biesheuvel wrote:
> This patch updates many of the chunked tcrypt test cases so that not all of the
> chunks are an exact multiple of the block size. This should help uncover cases
> where the residue passed to blkcipher_walk_done() is incorrect.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> 
> Herbert,
> 
> After this change, the ARM and arm64 bugs regarding blkcipher_walk_done() are
> identified by tcrypt mode=10

Patch applied.  Thanks Ard!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
