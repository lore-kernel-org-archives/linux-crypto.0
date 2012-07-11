From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: twofish-avx - remove useless instruction
Date: Wed, 11 Jul 2012 11:26:19 +0800
Message-ID: <20120711032618.GH5263@gondor.apana.org.au>
References: <20120705184358.GE2091@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120705184358.GE2091@kronos.redsun>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 05, 2012 at 08:43:58PM +0200, Johannes Goetzfried wrote:
> The register %rdx is written, but never read till the end of the encryption
> routine. Therefore let's delete the useless instruction.
> 
> Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
