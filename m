From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] keys: fixed handling of update method of the
 encrypted key type
Date: Thu, 07 Oct 2010 17:03:11 -0400
Message-ID: <1286485391.2809.7.camel@localhost.localdomain>
References: <201010071429.24664.roberto.sassu@polito.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@polito.it>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33703 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab0JGVDT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Oct 2010 17:03:19 -0400
In-Reply-To: <201010071429.24664.roberto.sassu@polito.it>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nice! This patch applies cleanly to the trusted/encrypted patch set
posted today.

thanks,

Acked-by: Mimi Zohar <zohar@us.ibm.com>

On Thu, 2010-10-07 at 14:29 +0200, Roberto Sassu wrote:
> This patch adds the UPDATE keyword for encrypted key types:
> prevents updating existent keys if UPDATE is missing and creating
> new keys when UPDATE is specified.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/keys/encrypted_defined.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
> index 6b26db6..54c0f0f 100644
> --- a/security/keys/encrypted_defined.c
> +++ b/security/keys/encrypted_defined.c
> @@ -64,7 +64,8 @@ static int aes_get_sizes(int *ivsize, int *blksize)
>  }
>  
>  enum {
> -	Opt_err = -1, Opt_new = 1, Opt_load, Opt_NEW, Opt_LOAD
> +	Opt_err = -1, Opt_new = 1, Opt_load, 
> +	Opt_update, Opt_NEW, Opt_LOAD, Opt_UPDATE
>  };
>  
>  static match_table_t key_tokens = {
> @@ -72,6 +73,8 @@ static match_table_t key_tokens = {
>  	{Opt_NEW, "NEW"},
>  	{Opt_load, "load"},
>  	{Opt_LOAD, "LOAD"},
> +	{Opt_update, "update"},
> +	{Opt_UPDATE, "UPDATE"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -81,6 +84,7 @@ static match_table_t key_tokens = {
>   * datablob format:
>   * NEW <master-key name> <decrypted data length>
>   * LOAD <master-key name> <decrypted data length> <encrypted iv + data>
> + * UPDATE <new-master-key name>
>   *
>   * Tokenizes a copy of the keyctl data, returning a pointer to each token,
>   * which is null terminated.
> @@ -104,23 +108,36 @@ static int datablob_parse(char *datablob, char **master_desc,
>  	*master_desc = strsep(&datablob, " \t");
>  	if (!*master_desc)
>  		goto out;
> -	*decrypted_datalen = strsep(&datablob, " \t");
> -	if (!*decrypted_datalen)
> -		goto out;
> +
> +	if (decrypted_datalen) {
> +		*decrypted_datalen = strsep(&datablob, " \t");
> +		if (!*decrypted_datalen)
> +			goto out;
> +	}
>  
>  	switch (key_cmd) {
>  	case Opt_new:
>  	case Opt_NEW:
> +		if (!decrypted_datalen)
> +			break;
>  		ret = 0;
>  		break;
>  	case Opt_load:
>  	case Opt_LOAD:
> +		if (!decrypted_datalen)
> +			break;
>  		*hex_encoded_iv = strsep(&datablob, " \t");
>  		if (!*hex_encoded_iv)
>  			break;
>  		*hex_encoded_data = *hex_encoded_iv + (2 * ivsize) + 2;
>  		ret = 0;
>  		break;
> +	case Opt_update:
> +	case Opt_UPDATE:
> +		if (decrypted_datalen)
> +			break;
> +		ret = 0;
> +		break;
>  	case Opt_err:
>  		break;
>  	}
> @@ -647,11 +664,9 @@ static int encrypted_update(struct key *key, const void *data, size_t datalen)
>  		return -ENOMEM;
>  
>  	memcpy(buf, data, datalen);
> -	new_master_desc = strsep(&buf, " \t");
> -	if (!*new_master_desc) {
> -		ret = -EINVAL;
> +	ret = datablob_parse(buf, &new_master_desc, NULL, NULL, NULL);
> +	if (ret < 0)
>  		goto out;
> -	}
>  
>  	new_epayload = encrypted_key_alloc(key, new_master_desc,
>  					   epayload->datalen);
