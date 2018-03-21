From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 06/12] integrity: Introduce
 asymmetric_sig_has_known_key()
Date: Wed, 21 Mar 2018 19:17:45 -0400
Message-ID: <1521674265.3848.220.camel@linux.vnet.ibm.com>
References: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
         <20180316203837.10174-7-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316203837.10174-7-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-03-16 at 17:38 -0300, Thiago Jung Bauermann wrote:
> IMA will only look for a modsig if the xattr sig references a key which is
> not in the expected kernel keyring. To that end, introduce
> asymmetric_sig_has_known_key().
> 
> The logic of extracting the key used in the xattr sig is factored out from
> asymmetric_verify() so that it can be used by the new function.
> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  security/integrity/digsig_asymmetric.c | 44 +++++++++++++++++++++++++---------
>  security/integrity/integrity.h         |  8 +++++++
>  2 files changed, 41 insertions(+), 11 deletions(-)
> 
> diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> index ab6a029062a1..241647970c19 100644
> --- a/security/integrity/digsig_asymmetric.c
> +++ b/security/integrity/digsig_asymmetric.c
> @@ -79,26 +79,48 @@ static struct key *request_asymmetric_key(struct key *keyring, uint32_t keyid)
>  	return key;
>  }
> 
> -int asymmetric_verify(struct key *keyring, const char *sig,
> -		      int siglen, const char *data, int datalen)
> +static struct key *asymmetric_key_from_sig(struct key *keyring, const char *sig,
> +					   int siglen)
>  {
> -	struct public_key_signature pks;
> -	struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
> -	struct key *key;
> -	int ret = -ENOMEM;
> +	const struct signature_v2_hdr *hdr = (struct signature_v2_hdr *) sig;
> 
>  	if (siglen <= sizeof(*hdr))
> -		return -EBADMSG;
> +		return ERR_PTR(-EBADMSG);
> 
>  	siglen -= sizeof(*hdr);
> 
>  	if (siglen != be16_to_cpu(hdr->sig_size))
> -		return -EBADMSG;
> +		return ERR_PTR(-EBADMSG);
> 
>  	if (hdr->hash_algo >= HASH_ALGO__LAST)
> -		return -ENOPKG;
> +		return ERR_PTR(-ENOPKG);
> +
> +	return request_asymmetric_key(keyring, be32_to_cpu(hdr->keyid));
> +}
> +
> +bool asymmetric_sig_has_known_key(struct key *keyring, const char *sig,
> +				  int siglen)
> +{
> +	struct key *key;
> +
> +	key = asymmetric_key_from_sig(keyring, sig, siglen);
> +	if (IS_ERR_OR_NULL(key))
> +		return false;
> +
> +	key_put(key);
> +
> +	return true;
> +}
> +
> +int asymmetric_verify(struct key *keyring, const char *sig,
> +		      int siglen, const char *data, int datalen)
> +{
> +	struct public_key_signature pks;
> +	struct signature_v2_hdr *hdr = (struct signature_v2_hdr *)sig;
> +	struct key *key;
> +	int ret = -ENOMEM;
> 
> -	key = request_asymmetric_key(keyring, be32_to_cpu(hdr->keyid));
> +	key = asymmetric_key_from_sig(keyring, sig, siglen);
>  	if (IS_ERR(key))
>  		return PTR_ERR(key);
> 
> @@ -109,7 +131,7 @@ int asymmetric_verify(struct key *keyring, const char *sig,
>  	pks.digest = (u8 *)data;
>  	pks.digest_size = datalen;
>  	pks.s = hdr->sig;
> -	pks.s_size = siglen;
> +	pks.s_size = siglen - sizeof(*hdr);
>  	ret = verify_signature(key, &pks);
>  	key_put(key);
>  	pr_debug("%s() = %d\n", __func__, ret);
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 2d245f44ca26..4c381b992e11 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -179,12 +179,20 @@ static inline int integrity_init_keyring(const unsigned int id)
>  #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
>  int asymmetric_verify(struct key *keyring, const char *sig,
>  		      int siglen, const char *data, int datalen);
> +bool asymmetric_sig_has_known_key(struct key *keyring, const char *sig,
> +				  int siglen);
>  #else
>  static inline int asymmetric_verify(struct key *keyring, const char *sig,
>  				    int siglen, const char *data, int datalen)
>  {
>  	return -EOPNOTSUPP;
>  }
> +
> +static inline bool asymmetric_sig_has_known_key(struct key *keyring,
> +						const char *sig, int siglen)
> +{
> +	return false;
> +}
>  #endif
> 
>  #ifdef CONFIG_IMA_LOAD_X509
> 
