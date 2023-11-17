Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC306A6
	for <linux-crypto@vger.kernel.org>; Fri, 17 Nov 2023 03:25:09 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wy4-000dPy-Fl; Fri, 17 Nov 2023 19:25:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:25:08 +0800
Date: Fri, 17 Nov 2023 19:25:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chanho Park <chanho61.park@samsung.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: jh7110 - Correct deferred probe return
Message-ID: <ZVdNlHH2FQbuc66g@gondor.apana.org.au>
References: <CGME20231109063323epcas2p13d88ce8e8251dfa4eba4662c38cc08c9@epcas2p1.samsung.com>
 <20231109063259.3427055-1-chanho61.park@samsung.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109063259.3427055-1-chanho61.park@samsung.com>

On Thu, Nov 09, 2023 at 03:32:59PM +0900, Chanho Park wrote:
> This fixes list_add corruption error when the driver is returned
> with -EPROBE_DEFER. It is also required to roll back the previous
> probe sequences in case of deferred_probe. So, this removes
> 'err_probe_defer" goto label and just use err_dma_init instead.
> 
> Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/crypto/starfive/jh7110-cryp.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
