From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix compile errors of XTS
Date: Wed, 17 Feb 2016 07:55:21 +0000
Message-ID: <20160217075521.GC16041@gondor.apana.org.au>
References: <17540790.vcykgraQyO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kbuild test robot <fengguang.wu@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17540790.vcykgraQyO@positron.chronox.de>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 17, 2016 at 07:00:01AM +0100, Stephan Mueller wrote:
> Commit 28856a9e52c7 missed the addition of the crypto/xts.h include file
> for different architecture-specific AES implementations.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
