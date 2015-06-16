From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 4/4] crypto: add tests vectors for RSA
Date: Tue, 16 Jun 2015 14:28:58 +0800
Message-ID: <20150616062858.GA21883@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201853.15697.45868.stgit@tstruk-mobl1>
 <20150616003741.GA18212@gondor.apana.org.au>
 <557FC1B2.1090603@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <557FC1B2.1090603@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 15, 2015 at 11:26:58PM -0700, Tadeusz Struk wrote:
> On 06/15/2015 05:37 PM, Herbert Xu wrote:
> >>  config CRYPTO_MANAGER
> >> >  	tristate "Cryptographic algorithm manager"
> >> >  	select CRYPTO_MANAGER2
> >> > +	select CRYPTO_AKCIPHER
> > Please add this to CRYPTO_MANAGER2 instead.
> 
> This causes a recursive dependency error
> 
> crypto/Kconfig:115:error: recursive dependency detected!
> crypto/Kconfig:115:	symbol CRYPTO_MANAGER2 default value contains CRYPTO_ALGAPI
> crypto/Kconfig:34:	symbol CRYPTO_ALGAPI is selected by CRYPTO_AKCIPHER
> crypto/Kconfig:94:	symbol CRYPTO_AKCIPHER is selected by CRYPTO_MANAGER2

That's because you need to split AKCIPHER into AKCIPHER and
AKCIPHER2 just like every other type.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
