From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: caam - fix memleak in caam_jr module
Date: Thu, 10 Jul 2014 17:00:06 +0800
Message-ID: <20140710090006.GB15621@gondor.apana.org.au>
References: <1404723161-30180-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Garg Vakul-B16394 <vakul@freescale.com>, stable@vger.kernel.org
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404723161-30180-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 07, 2014 at 11:52:41AM +0300, Cristian Stoica wrote:
> This patch fixes a memory leak that appears when caam_jr module is unloaded.
> 
> Cc: <stable@vger.kernel.org> # 3.13+
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
