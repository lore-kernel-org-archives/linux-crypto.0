From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 12/12] ima: Write modsig to the measurement list
Date: Mon, 26 Mar 2018 08:29:37 -0400
Message-ID: <1522067377.3541.47.camel@linux.vnet.ibm.com>
References: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
         <20180316203837.10174-13-bauerman@linux.vnet.ibm.com>
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
In-Reply-To: <20180316203837.10174-13-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-03-16 at 17:38 -0300, Thiago Jung Bauermann wrote:
> Define new "d-sig" template field which holds the digest that is expected
> to match the one contained in the modsig.
> 
> Also add modsig support to the "sig" template field, allowing the the
> contents of the modsig to be included in the measurement list.

Although including the appended signature in the template data doesn't
make sense on its own, as the file digest (without the appended
signature) is needed to validate the appended signature, defining a
new template field and its usage should be independent of other
changes.

Mimi

> 
> Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
> ---
>  Documentation/security/IMA-templates.rst  |  5 ++++
>  security/integrity/ima/ima_template.c     |  4 ++-
>  security/integrity/ima/ima_template_lib.c | 47 +++++++++++++++++++++++++++++--
>  security/integrity/ima/ima_template_lib.h |  2 ++
>  4 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index 2cd0e273cc9a..f2a0f4225857 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -68,6 +68,11 @@ descriptors by adding their identifier to the format string
>   - 'd-ng': the digest of the event, calculated with an arbitrary hash
>     algorithm (field format: [<hash algo>:]digest, where the digest
>     prefix is shown only if the hash algorithm is not SHA1 or MD5);
> + - 'd-sig': the digest of the event for files that have an appended modsig. This
> +   field is calculated without including the modsig and thus will differ from
> +   the total digest of the file, but it is what should match the digest
> +   contained in the modsig (if it doesn't, the signature is invalid). It is
> +   shown in the same format as 'd-ng';
>   - 'n-ng': the name of the event, without size limitations;
>   - 'sig': the file signature.
> 
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index 30db39b23804..36fc32f538b5 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -43,8 +43,10 @@ static struct ima_template_field supported_fields[] = {
>  	 .field_show = ima_show_template_string},
>  	{.field_id = "sig", .field_init = ima_eventsig_init,
>  	 .field_show = ima_show_template_sig},
> +	{.field_id = "d-sig", .field_init = ima_eventdigest_sig_init,
> +	 .field_show = ima_show_template_digest_ng},
>  };
> -#define MAX_TEMPLATE_NAME_LEN 15
> +#define MAX_TEMPLATE_NAME_LEN 24
> 
>  static struct ima_template_desc *ima_template;
>  static struct ima_template_desc *lookup_template_desc(const char *name);
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index afb52a90e532..1dca082cce43 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -220,7 +220,8 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
>  	return 0;
>  }
> 
> -static int ima_eventdigest_init_common(u8 *digest, u32 digestsize, u8 hash_algo,
> +static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
> +				       u8 hash_algo,
>  				       struct ima_field_data *field_data)
>  {
>  	/*
> @@ -323,6 +324,35 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>  					   hash_algo, field_data);
>  }
> 
> +/*
> + * This function writes the digest of the file which is expected to match the
> + * digest contained in the file's embedded signature.
> + */
> +int ima_eventdigest_sig_init(struct ima_event_data *event_data,
> +			     struct ima_field_data *field_data)
> +{
> +	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
> +	enum hash_algo hash_algo = HASH_ALGO_SHA1;
> +	const u8 *cur_digest = NULL;
> +	u8 cur_digestsize = 0;
> +	int ret;
> +
> +	if (!xattr_value || xattr_value->type != IMA_MODSIG)
> +		return 0;
> +
> +	if (event_data->violation)	/* recording a violation. */
> +		goto out;
> +
> +	ret = ima_get_modsig_hash(xattr_value, &hash_algo, &cur_digest,
> +				  &cur_digestsize);
> +	if (ret)
> +		return ret;
> +
> + out:
> +	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> +					   hash_algo, field_data);
> +}
> +
>  static int ima_eventname_init_common(struct ima_event_data *event_data,
>  				     struct ima_field_data *field_data,
>  				     bool size_limit)
> @@ -379,10 +409,23 @@ int ima_eventsig_init(struct ima_event_data *event_data,
>  		      struct ima_field_data *field_data)
>  {
>  	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
> +	int xattr_len = event_data->xattr_len;
> 
>  	if (!is_ima_sig(xattr_value))
>  		return 0;
> 
> -	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
> +	/*
> +	 * The xattr_value for IMA_MODSIG is a runtime structure containing
> +	 * pointers. Get its raw data instead.
> +	 */
> +	if (xattr_value->type == IMA_MODSIG) {
> +		int rc;
> +
> +		rc = ima_modsig_serialize_data(&xattr_value, &xattr_len);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return ima_write_template_field_data(xattr_value, xattr_len,
>  					     DATA_FMT_HEX, field_data);
>  }
> diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
> index 6a3d8b831deb..3cd353e83f73 100644
> --- a/security/integrity/ima/ima_template_lib.h
> +++ b/security/integrity/ima/ima_template_lib.h
> @@ -38,6 +38,8 @@ int ima_eventname_init(struct ima_event_data *event_data,
>  		       struct ima_field_data *field_data);
>  int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>  			    struct ima_field_data *field_data);
> +int ima_eventdigest_sig_init(struct ima_event_data *event_data,
> +			     struct ima_field_data *field_data);
>  int ima_eventname_ng_init(struct ima_event_data *event_data,
>  			  struct ima_field_data *field_data);
>  int ima_eventsig_init(struct ima_event_data *event_data,
> 
