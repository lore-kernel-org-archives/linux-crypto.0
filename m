From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] crypto, x86: assembler implementation of SHA1
Date: Wed, 10 Aug 2011 19:03:30 +0800
Message-ID: <20110810110330.GC2649@gondor.apana.org.au>
References: <1312481965-26484-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60101 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1HJLDh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2011 07:03:37 -0400
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

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
