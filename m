From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: lz4,lz4hc - fix decompression
Date: Fri, 29 Aug 2014 21:48:45 +0800
Message-ID: <20140829134845.GC9971@gondor.apana.org.au>
References: <1408697076-20272-1-git-send-email-hidden@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55590 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaH2Nsu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2014 09:48:50 -0400
Content-Disposition: inline
In-Reply-To: <1408697076-20272-1-git-send-email-hidden@sch.bme.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 22, 2014 at 10:44:35AM +0200, KOVACS Krisztian wrote:
> The lz4 library has two functions for decompression, with slightly
> different signatures and behaviour. The lz4_decompress_crypto() function
> seemed to be using the one that assumes that the decompressed length is
> known in advance.
> 
> This patch switches to the other decompression function and makes sure
> that the length of the decompressed output is properly returned to the
> caller.
> 
> The same issue was present in the lz4hc algorithm.
> 
> Coincidentally, this change also makes very basic lz4 and lz4hc
> compression tests in testmgr pass.
> 
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
