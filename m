From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC][PATCH] x86-optimized SHA1 hash for CryptoAPI
Date: Fri, 18 May 2007 17:08:23 +1000
Message-ID: <20070518070822.GA17928@gondor.apana.org.au>
References: <20061023175020.23fabf00.bgilbert@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4229 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756035AbXERHI3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 May 2007 03:08:29 -0400
Content-Disposition: inline
In-Reply-To: <20061023175020.23fabf00.bgilbert@cs.cmu.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Bejamin:

On Mon, Oct 23, 2006 at 05:50:20PM -0400, Benjamin Gilbert wrote:
> This is a new CryptoAPI module containing an x86-optimized implementation of
> SHA1, taken from Nettle.

Thanks for the patch! Sorry for the very late response.  I just
discovered this while cleaning up my mailbox :)
 
> 1.  Recognizing that arch/i386/crypto/sha1.c contains almost the same
> functionality as crypto/sha1.c, I could abstract out common code between the
> two implementations.  However, given the length of the files in question, I
> suspect the complexity isn't worth it.  In-tree, AES uses duplicated code
> between the asm and C versions, while Twofish pulls out common code into a
> separate module.

Considering the simplicity of sha1.c, I'd say that you should just
duplicate it.

> 2.  Since the optimized part of the code is the SHA1 compression function,
> and since crypto/sha1.c is just a wrapper around the compression function in
> lib/sha1.c, I could eliminate the separate CryptoAPI module and switch the
> kernel between the C and asm compression functions based on a config option
> -- so that all SHA1 users get the optimized version, instead of just
> CryptoAPI.  There is an API issue though: the optimized code needs to
> allocate its workspace on the stack for register-allocation reasons, and the
> C version expects the caller to allocate a temporary buffer (to minimize the
> number of times the workspace needs to be cleared when hashing several times
> in a row).  If the optimized code was used with the current API, the caller
> would be doing a bunch of allocation and clearing for nothing.  (Note: the
> only direct users of lib/sha1.c right now are /dev/random and syncookies.)
> 
> Which (if any) is the preferred approach?

I think the best solution is to replace SHA_WORKSPACE_WORDS with an
inline function/macro that returns zero for the optimised version.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
