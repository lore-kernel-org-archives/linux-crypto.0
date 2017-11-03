From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Fixes for the Atmel AES crypto module
Date: Fri, 3 Nov 2017 22:28:29 +0800
Message-ID: <20171103142829.GT9011@gondor.apana.org.au>
References: <20171031152524.25216-1-romain.izard.pro@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Romain Izard <romain.izard.pro@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171031152524.25216-1-romain.izard.pro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 31, 2017 at 04:25:22PM +0100, Romain Izard wrote:
> After encountering an issue with cts(cbc(aes)) in the Atmel AES module,
> I have used tcrypt and libkcapi's test suite to validate my fix. This led
> me to observe some other issues.
> 
> This series includes the IV issue correction for the Atmel AES crypto
> engine, as well as a secondary issue observed when running
> 'insmod tcrypt.ko mode=10' and 'insmod tcrypt.ko mode=152' on a SAMA5D2
> board.
> 
> The libkcapi test suite still reports some problems, for example when the
> input data is too large to fit into an intermediate buffer in unaligned
> cases. And it seems that with the v4.14 updates, new asynchronous tests
> are enabled and report new issues.
> 
> Romain Izard (2):
>   crypto: atmel-aes - properly set IV after {en,de}crypt
>   crypto: atmel-aes - Reset the controller before each use
> 
>  drivers/crypto/atmel-aes.c | 50 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 40 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
