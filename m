Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9F1729;
	Fri,  1 Dec 2023 03:16:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r91VJ-005jUY-CW; Fri, 01 Dec 2023 19:16:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 19:16:26 +0800
Date: Fri, 1 Dec 2023 19:16:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: davem@davemloft.net, t-kristo@ti.com, j-keerthy@ti.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sa2ul - Return crypto_aead_setkey to transfer
 the error
Message-ID: <ZWnAigmdiFIweUjW@gondor.apana.org.au>
References: <20231127020301.2307177-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127020301.2307177-1-nichen@iscas.ac.cn>

On Mon, Nov 27, 2023 at 02:03:01AM +0000, Chen Ni wrote:
> Return crypto_aead_setkey() in order to transfer the error if
> it fails.
> 
> Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
> Changelog:
> 
> v1 -> v2:
> 1. Simplify code
> 2. Update commit message
> ---
>  drivers/crypto/sa2ul.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
