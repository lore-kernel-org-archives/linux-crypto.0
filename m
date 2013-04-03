From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: caam - change key gen functions to
 return signed int
Date: Wed, 3 Apr 2013 09:53:27 +0800
Message-ID: <20130403015327.GD20205@gondor.apana.org.au>
References: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 26, 2013 at 06:10:14PM -0500, Kim Phillips wrote:
> commit 2af8f4a "crypto: caam - coccicheck fixes" added error
> return values yet neglected to change the type from unsigned.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
