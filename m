From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] crypto, x86: assembler implementation of SHA1
Date: Fri, 5 Aug 2011 15:49:04 +0800
Message-ID: <20110805074904.GA1060@gondor.apana.org.au>
References: <1312481965-26484-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49328 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab1HEHtO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2011 03:49:14 -0400
Content-Disposition: inline
In-Reply-To: <1312481965-26484-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 04, 2011 at 08:19:23PM +0200, Mathias Krause wrote:
> This patch series adds an assembler implementation for the SHA1 hash algorithm
> for the x86-64 architecture. Its raw hash performance can be more than 2 times
> faster than the generic C implementation. This gives a real world benefit for
> IPsec with an throughput increase of up to +35%. For concrete numbers have a
> look at the second patch.
> 
> This implementation is currently x86-64 only but might be ported to 32 bit with
> some effort in a follow up patch. (I had no time to do this yet.)
> 
> Note: The SSSE3 is no typo, it's "Supplemental SSE3".
> 
> v3 changes:
> - removed #ifdef in first patch
> v2 changes:
> - fixed typo in Makefile making AVX version unusable
> - whitespace fixes for the .S file

I'll apply this as soon as rc1 is out.  Thanks!

PS if you have time please look into the asynchronous version.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
