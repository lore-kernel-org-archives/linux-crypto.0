Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E1484;
	Fri,  1 Dec 2023 02:08:57 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r90S0-005hfu-HY; Fri, 01 Dec 2023 18:08:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:08:57 +0800
Date: Fri, 1 Dec 2023 18:08:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: starfive - Pad adata with zeroes
Message-ID: <ZWmwuUpIJ3tq5NxI@gondor.apana.org.au>
References: <20231120031242.25100-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120031242.25100-1-jiajie.ho@starfivetech.com>

On Mon, Nov 20, 2023 at 11:12:42AM +0800, Jia Jie Ho wrote:
> Aad requires padding with zeroes up to 15 bytes in some cases. This
> patch increases the allocated buffer size for aad and prevents the
> driver accessing uninitialized memory region.
> 
> v1->v2: Specify reason for alloc size change in descriptions.
> 
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> ---
>  drivers/crypto/starfive/jh7110-aes.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
