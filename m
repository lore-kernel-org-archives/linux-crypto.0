From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Mon, 11 May 2015 14:03:47 +0800
Message-ID: <20150511060347.GA2117@gondor.apana.org.au>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1>
 <20150506193648.9329.27232.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150506193648.9329.27232.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 06, 2015 at 12:36:48PM -0700, Tadeusz Struk wrote:
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 8aaf298..daa9c07 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -87,6 +87,12 @@ config CRYPTO_PCOMP2
>  	tristate
>  	select CRYPTO_ALGAPI2
>  
> +config CRYPTO_PKEY

Please call this AKCIPHER instead of PKEY.  The existing ciphers
are already known as skcipher (although the conversion process is
by no means complete so other names such as blkcipher/ablkcipher
still exist).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
