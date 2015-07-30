From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx - use be32_to_cpu for __be32 field in debug
 msg
Date: Thu, 30 Jul 2015 21:52:23 +0800
Message-ID: <20150730135223.GB17690@gondor.apana.org.au>
References: <1438213409-6968-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438213409-6968-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 29, 2015 at 07:43:29PM -0400, Dan Streetman wrote:
> One of the debug messages in the NX 842 PowerNV driver is missing
> the required be32_to_cpu() wrapper when accessing the __be32 field
> csb->count.  Add the wrapper so the message will show the correct count.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
