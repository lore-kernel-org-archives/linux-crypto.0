From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 4/4] crypto: add tests vectors for RSA
Date: Tue, 16 Jun 2015 08:37:41 +0800
Message-ID: <20150616003741.GA18212@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201853.15697.45868.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51292 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbbFPAh5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:37:57 -0400
Content-Disposition: inline
In-Reply-To: <20150615201853.15697.45868.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 01:18:53PM -0700, Tadeusz Struk wrote:
> New test vectors for RSA algorithm.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  crypto/Kconfig   |    1 
>  crypto/testmgr.c |  149 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  crypto/testmgr.h |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 293 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index a09404b..90c1f77 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -107,6 +107,7 @@ config CRYPTO_RSA
>  config CRYPTO_MANAGER
>  	tristate "Cryptographic algorithm manager"
>  	select CRYPTO_MANAGER2
> +	select CRYPTO_AKCIPHER

Please add this to CRYPTO_MANAGER2 instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
