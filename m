From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-sham - Fix compile errors when CONFIG_OF
 not defined
Date: Sun, 20 Jan 2013 11:13:27 +1100
Message-ID: <20130120001327.GE26742@gondor.apana.org.au>
References: <1358283182-29392-1-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358283182-29392-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 15, 2013 at 01:53:02PM -0700, Mark A. Greer wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> Fix the compile errors created by commit 2545e8d
> (crypto: omap-sham - Add Device Tree Support)
> when CONFIG_OF is not defined.  This includes
> changing omap_sham_get_res_dev() to omap_sham_get_res_of()
> and creating an empty version of omap_sham_of_match[].
> 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
