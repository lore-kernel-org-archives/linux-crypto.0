From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 08:05:19 +0800
Message-ID: <20150616000519.GA16973@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
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
In-Reply-To: <20150615201842.15697.59701.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 15, 2015 at 01:18:42PM -0700, Tadeusz Struk wrote:
>
> + * @setkey:	Function invokes the algorithm specific set key function, which
> + *		knows how to decode and interpret the BER encoded key

We should split this into two functions: setpubkey and setprivkey.

> + *
> + * @reqsize:	Request context size required by algorithm implementation
> + * @base:	Common crypto API algorithm data structure
> + */
> +struct akcipher_alg {
> +	int (*sign)(struct akcipher_request *req);
> +	int (*verify)(struct akcipher_request *req);
> +	int (*encrypt)(struct akcipher_request *req);
> +	int (*decrypt)(struct akcipher_request *req);
> +	int (*maxsize)(struct crypto_akcipher *tfm);

Hmm, we could actually get rid of maxsize by just having each
function check the dst_len and if it is insufficient write the
required length in it and then return an error.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
