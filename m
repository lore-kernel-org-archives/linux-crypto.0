From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx - don't err if compressed output > input
Date: Thu, 30 Jul 2015 21:52:10 +0800
Message-ID: <20150730135210.GA17690@gondor.apana.org.au>
References: <1438213329-6884-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438213329-6884-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 29, 2015 at 07:42:09PM -0400, Dan Streetman wrote:
> Return success instead of error if compression succeeds but the output is
> larger than the input.
> 
> It's unlikely that the caller will use the compressed data since it's
> larger than the original uncompressed data, but there was no error and
> returning an error code is incorrect.  Further, for testing small input
> buffers, the output is likely to be larger than the input and success
> needs to be returned to verify the test.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
