From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH RFC v3 2/3] crypto: RSA: KEYS: convert rsa and public
 key to new PKE API
Date: Fri, 05 Jun 2015 10:50:12 +0200
Message-ID: <1433494212.3358.16.camel@x220>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1>
	 <20150603224414.22310.17260.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150603224414.22310.17260.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

A few remarks, perhaps not of the kind you'd like for an RFC, that I
hope are still relevant after Herbert's comment.

On Wed, 2015-06-03 at 15:44 -0700, Tadeusz Struk wrote:
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -8,6 +8,7 @@ asymmetric_keys-y := asymmetric_type.o signature.o
>  
>  obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
>  obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
> +obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa_pkcs1_v1_5.o

This builds two modules if PUBLIC_KEY_ALGO_RSA = 'm': rsa.ko and
rsa_pkcs1_v1_5.ko. Is that what you want?
 
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c

> +int rsa_pkcs1_v1_5_verify_signature(const struct public_key *pkey,
> +				    const struct public_key_signature *sig);
> +

> -int public_key_verify_signature(const struct public_key *pk,
> +int public_key_verify_signature(const struct public_key *pkey,
>  				const struct public_key_signature *sig)
>  {
> [...]
> -	return algo->verify_signature(pk, sig);
> +	return rsa_pkcs1_v1_5_verify_signature(pkey, sig);
>  }


> --- a/crypto/asymmetric_keys/rsa.c
> +++ b/crypto/asymmetric_keys/rsa.c
 
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("RSA Public Key Algorithm");

> +static int rsa_init(void)
> +{
> +	return crypto_register_akcipher(&rsa);
> +}

Is there a reason not to mark this __init? (This is not a rhetorical
question, perhaps there really is.)

> +static void rsa_exit(void)
> +{
> +	crypto_unregister_akcipher(&rsa);
> +}

Ditto for __exit.

> +module_init(rsa_init);
> +module_exit(rsa_exit);
> +MODULE_ALIAS_CRYPTO("rsa");

Could the MODULE_* macros be grouped in one place please?

> --- /dev/null
> +++ b/crypto/asymmetric_keys/rsa_pkcs1_v1_5.c

> +/*
> + * Perform the verification step [RFC3447 sec 8.2.2].
> + */
> +int rsa_pkcs1_v1_5_verify_signature(const struct public_key *pkey,
> +				    const struct public_key_signature *sig)
> +{
> [...]
> +}

public_key.c uses this, so it can end up in public_key.ko. But it's not
exported. So a _quick and dirty_ build test generated:
    WARNING: "rsa_pkcs1_v1_5_verify_signature" [[...]/crypto/asymmetric_keys/public_key.ko] undefined!

Also no MODULE_LICENSE() macro, so loading rsa_pkcs1_v1_5.ko should
trigger a warning and taint the kernel.

Thanks,


Paul Bolle
