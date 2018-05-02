From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 01/10] crypto: aead - allow to allocate AEAD requests on
 the stack
Date: Wed, 2 May 2018 14:55:19 +0000
Message-ID: <02ad9eb93c494314a85db69886cf787a@AcuMS.aculab.com>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
 <20180502095725.31935-2-antoine.tenart@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        "nadavh@marvell.com" <nadavh@marvell.com>,
        "oferh@marvell.com" <oferh@marvell.com>,
        "igall@marvell.com" <igall@marvell.com>
To: 'Antoine Tenart' <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502095725.31935-2-antoine.tenart@bootlin.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Antoine Tenart
> Sent: 02 May 2018 10:57
> Adds the AEAD_REQUEST_ON_STACK primitive to allow allocating AEAD
> requests on the stack, as it can already be done with various other
> crypto algorithms within the kernel.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  include/crypto/aead.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
> index 1e26f790b03f..b67064786546 100644
> --- a/include/crypto/aead.h
> +++ b/include/crypto/aead.h
> @@ -151,6 +151,11 @@ struct aead_alg {
>  	struct crypto_alg base;
>  };
> 
> +#define AEAD_REQUEST_ON_STACK(name, tfm) \
> +	char __##name##_desc[sizeof(struct aead_request) + \
> +		crypto_aead_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> +	struct aead_request *name = (void *)__##name##_desc
> +

This looks stunningly like a VLA.

	David
