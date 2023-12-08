Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AA61712
	for <linux-crypto@vger.kernel.org>; Thu,  7 Dec 2023 20:09:43 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBSBH-008IlS-1G; Fri, 08 Dec 2023 12:09:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:09:48 +0800
Date: Fri, 8 Dec 2023 12:09:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ovidiu.panait@windriver.com
Cc: linux-crypto@vger.kernel.org, festevam@gmail.com
Subject: Re: [PATCH 1/7] crypto: sahara - remove FLAGS_NEW_KEY logic
Message-ID: <ZXKXDKuk9hoM3PrJ@gondor.apana.org.au>
References: <20231201170625.713368-1-ovidiu.panait@windriver.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201170625.713368-1-ovidiu.panait@windriver.com>

On Fri, Dec 01, 2023 at 07:06:19PM +0200, ovidiu.panait@windriver.com wrote:
> From: Ovidiu Panait <ovidiu.panait@windriver.com>
> 
> Remove the FLAGS_NEW_KEY logic as it has the following issues:
> - the wrong key may end up being used when there are multiple data streams:
>        t1            t2
>     setkey()
>     encrypt()
>                    setkey()
>                    encrypt()
> 
>     encrypt() <--- key from t2 is used
> - switching between encryption and decryption with the same key is not
>   possible, as the hdr flags are only updated when a new setkey() is
>   performed
> 
> With this change, the key is always sent along with the cryptdata when
> performing encryption/decryption operations.
> 
> Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  drivers/crypto/sahara.c | 34 +++++++++++++---------------------
>  1 file changed, 13 insertions(+), 21 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
