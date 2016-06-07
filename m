From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC v4 2/4] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Tue, 7 Jun 2016 22:16:13 +0800
Message-ID: <20160607141613.GA2237@gondor.apana.org.au>
References: <cover.1465301616.git.baolin.wang@linaro.org>
 <238ce3d506051c863300b90720c3e103175747cc.1465301616.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, davem@davemloft.net, ebiggers3@gmail.com,
	js1304@gmail.com, tadeusz.struk@intel.com, smueller@chronox.de,
	standby24x7@gmail.com, shli@kernel.org, dan.j.williams@intel.com,
	martin.petersen@oracle.com, sagig@mellanox.com,
	kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org,
	ming.lei@canonical.com, broonie@kernel.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39127 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbcFGOQy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 10:16:54 -0400
Content-Disposition: inline
In-Reply-To: <238ce3d506051c863300b90720c3e103175747cc.1465301616.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 07, 2016 at 08:17:05PM +0800, Baolin Wang wrote:
> Now some cipher hardware engines prefer to handle bulk block rather than one
> sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
> the intermediate values (IV) by themselves in one bulk block. This means we
> can increase the size of the request by merging request rather than always 512
> bytes and thus increase the hardware engine processing speed.
> 
> So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
> mode.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>

Nack.  As I said before, please do it using explicit IV generators
like we do for IPsec.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
