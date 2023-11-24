Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5086D1A5;
	Fri, 24 Nov 2023 02:16:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r6TE3-00367Y-TK; Fri, 24 Nov 2023 18:15:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Nov 2023 18:16:04 +0800
Date: Fri, 24 Nov 2023 18:16:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: starfive - Minor fixes in driver
Message-ID: <ZWB35BkxByHNcaJN@gondor.apana.org.au>
References: <20231114171214.240855-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114171214.240855-1-jiajie.ho@starfivetech.com>

On Wed, Nov 15, 2023 at 01:12:12AM +0800, Jia Jie Ho wrote:
> First patch updates the dependency for JH7110 drivers as the hash module
> depends on pl08x dma to transfer data. The second patch fixes an
> intermittent error in RSA where irq signals done before the actual
> calculations have been completed.
> 
> Jia Jie Ho (2):
>   crypto: starfive - Update driver dependencies
>   crypto: starfive - RSA poll csr for done status
> 
>  drivers/crypto/starfive/Kconfig       |  2 +-
>  drivers/crypto/starfive/jh7110-cryp.c |  8 -----
>  drivers/crypto/starfive/jh7110-cryp.h | 10 +++++-
>  drivers/crypto/starfive/jh7110-rsa.c  | 49 +++++++--------------------
>  4 files changed, 23 insertions(+), 46 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
