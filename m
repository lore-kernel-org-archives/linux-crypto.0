From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH 5/8] KEYS: Provide software public key query function
 [ver #2]
Date: Thu, 23 Jun 2016 08:46:42 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1606230832370.22282@alvander-mobl1.amr.corp.intel.com>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk> <146668969255.2977.2158699976750892093.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
	tadeusz.struk@intel.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21770 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbcFWPqn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 11:46:43 -0400
In-Reply-To: <146668969255.2977.2158699976750892093.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


David,

On Thu, 23 Jun 2016, David Howells wrote:

> Provide a query function for the software public key implementation.  This
> permits information about such a key to be obtained using
> query_asymmetric_key() or KEYCTL_PKEY_QUERY.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
> crypto/asymmetric_keys/public_key.c |   96 ++++++++++++++++++++++++++++++-----
> 1 file changed, 82 insertions(+), 14 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index fd76b5fc3b3a..a48a47a1dff0 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -57,6 +57,81 @@ static void public_key_destroy(void *payload0, void *payload3)
> 	public_key_signature_free(payload3);
> }
>
> +/*
> + * Determine the crypto algorithm name.
> + */
> +static
> +int software_key_determine_akcipher(const char *encoding,
> +				    const char *hash_algo,
> +				    const struct public_key *pkey,
> +				    char alg_name[CRYPTO_MAX_ALG_NAME])
> +{
> +	int n;
> +
> +	if (strcmp(encoding, "pkcs1") == 0) {
> +		/* The data wangled by the RSA algorithm is typically padded
> +		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
> +		 * sec 8.2].
> +		 */
> +		if (!hash_algo)
> +			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
> +				     "pkcs1pad(%s)",
> +				     pkey->pkey_algo);

Did you see Herbert's patch that strips out non-hash pkcs1pad capabilities 
(and the ensuing discussion)?

http://www.spinics.net/lists/linux-crypto/index.html#20432

I'm making use of pkcs1pad(rsa) with a TLS implementation, so it's good to 
see it supported here.

> +		else
> +			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
> +				     "pkcs1pad(%s,%s)",
> +				     pkey->pkey_algo, hash_algo);
> +		return n >= CRYPTO_MAX_ALG_NAME ? -EINVAL : 0;
> +	}
> +
> +	if (strcmp(encoding, "raw") == 0) {
> +		strcpy(alg_name, pkey->pkey_algo);
> +		return 0;
> +	}
> +
> +	return -ENOPKG;
> +}


Regards,

--
Mat Martineau
Intel OTC
