Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3A784;
	Fri,  1 Dec 2023 02:11:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r90UM-005hjr-EA; Fri, 01 Dec 2023 18:11:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:11:23 +0800
Date: Fri, 1 Dec 2023 18:11:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: starfive - Fix dev_err_probe return error
Message-ID: <ZWmxSzlRL7T9PmAz@gondor.apana.org.au>
References: <20231120151121.60942-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120151121.60942-1-jiajie.ho@starfivetech.com>

On Mon, Nov 20, 2023 at 11:11:21PM +0800, Jia Jie Ho wrote:
> Current dev_err_probe will return 0 instead of proper error code if
> driver failed to get irq number. Fix the return err code.
> 
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202311160649.3GhKCfhd-lkp@intel.com/
> ---
>  drivers/char/hw_random/jh7110-trng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
