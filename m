From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: atmel-sha - fix .import()/.export()
 implementation
Date: Tue, 16 Feb 2016 20:21:36 +0000
Message-ID: <20160216202136.GG11908@gondor.apana.org.au>
References: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nicolas.ferre@atmel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 08, 2016 at 04:26:47PM +0100, Cyrille Pitchen wrote:
> This series of patches includes two fixes for the atmel-sha.c driver.
> 
> The first one fixes the implementation of the import/export hooks, which
> did not pass the recent updates in testmgr.c (partial update exercise).
> The new implementation now passes the tcrypt tests: tested with
> next-20160208.
> 
> The second patch fixes a race condition if acquiring the hardware when it
> is already busy.

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
