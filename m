From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix size of RSA prime factor q
Date: Sat, 5 May 2018 15:17:39 +0800
Message-ID: <20180505071739.v7l46xlvj5lkg7hj@gondor.apana.org.au>
References: <AM4PR08MB28197AB3772FC2932C58EBFC9C8E0@AM4PR08MB2819.eurprd08.prod.outlook.com>
 <20180427084011.26234-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: David Binderman <dcb314@hotmail.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180427084011.26234-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 27, 2018 at 11:40:11AM +0300, Horia Geantă wrote:
> Fix a typo where size of RSA prime factor q is using the size of
> prime factor p.
> 
> Cc: <stable@vger.kernel.org> # 4.13+
> Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
> Fixes: 4a651b122adb ("crypto: caam - add support for RSA key form 3")
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
