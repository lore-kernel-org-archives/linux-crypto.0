From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] keys: added cleanup code for trusted and encrypted
 key types
Date: Thu, 07 Oct 2010 17:05:01 -0400
Message-ID: <1286485501.2809.9.camel@localhost.localdomain>
References: <201010071430.46281.roberto.sassu@polito.it>
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
Received: from e35.co.us.ibm.com ([32.97.110.153]:43631 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0JGVFE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Oct 2010 17:05:04 -0400
In-Reply-To: <201010071430.46281.roberto.sassu@polito.it>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for catching this! This patch applies cleanly to the
trusted/encrypted patch set posted today.

thanks,

Acked-by: Mimi Zohar <zohar@us.ibm.com>

On Thu, 2010-10-07 at 14:30 +0200, Roberto Sassu wrote:
> This patch frees the payload at the end of the instantiate
> method of both trusted and encrypted key types if an error occurs.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/keys/encrypted_defined.c |    6 ++++++
>  security/keys/trusted_defined.c   |    4 ++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
> index 54c0f0f..8426e66 100644
> --- a/security/keys/encrypted_defined.c
> +++ b/security/keys/encrypted_defined.c
> @@ -624,7 +624,13 @@ static int encrypted_instantiate(struct key *key, const void *data,
>  	}
>  	ret = encrypted_init(epayload, master_desc, decrypted_datalen,
>  			     hex_encoded_iv, hex_encoded_data);
> +	if (ret)
> +		goto out_free_epayload;
> +
>  	rcu_assign_pointer(key->payload.data, epayload);
> +out_free_epayload:
> +	if (ret)
> +		kfree(epayload);
>  out:
>  	kfree(datablob);
>  	return ret > 0 ? -EINVAL : ret;
> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> index aedad16..ab7c7f9 100644
> --- a/security/keys/trusted_defined.c
> +++ b/security/keys/trusted_defined.c
> @@ -848,6 +848,10 @@ static int trusted_instantiate(struct key *key, const void *data,
>  out:
>  	if (!ret)
>  		rcu_assign_pointer(key->payload.data, p);
> +	else {
> +		if (p)
> +			kfree(p);
> +	}
>  	kfree(datablob);
>  	return ret;
>  }
