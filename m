From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 8/8] [CRYPTO] aead: Add support for multiple template
	parameters
Date: Thu, 27 Sep 2007 17:32:28 -0500
Message-ID: <1190932349.2477.64.camel@faith.austin.ibm.com>
References: <200709272225.l8RMPjb5003200@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39247 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbXI0WgY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2007 18:36:24 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8RMaJ4w012362
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 18:36:19 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8RMaIL1348624
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 16:36:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8RMaHj5027424
	for <linux-crypto@vger.kernel.org>; Thu, 27 Sep 2007 16:36:18 -0600
In-Reply-To: <200709272225.l8RMPjb5003200@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sorry, I really messed up my Subject header.
This comment was for [PATCH 2/8] [CRYPTO] aead: Add support for 
multiple template parameters in the patchset.

The second patch in patch set, not the eighth.

Joy

On Thu, 2007-09-27 at 17:25 -0500, Joy Latten wrote:
> My apologies for such late notice, but I observed this only recently
> and wanted to point it out. 
> 
> 
>  	if (!try_module_get(THIS_MODULE))
>  		goto err;
> @@ -101,33 +106,73 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
>  
>  	memcpy(param->template, name, len);
>  
> -	name = p + 1;
> -	len = 0;
> -	for (p = name; *p; p++) {
> -		for (; isalnum(*p) || *p == '-' || *p == '_' || *p == '('; p++)
> -			;
> +	i = 0;
> +	for (;;) {
> +		int notnum = 0;
>  
> -		if (*p != ')')
> -			goto err_free_param;
> +		name = ++p;
> +		len = 0;
> +
> +		for (; isalnum(*p) || *p == '-' || *p == '_'; p++)
> +			notnum |= !isdigit(*p);
> +
> +		if (*p == '(') {
> +			int recursion = 0;
> +
> +			for (;;) {
> +				if (!*++p)
> +					goto err_free_param;
> +				if (*p == '(')
> +					recursion++;
> +				else if (*p == ')' && !recursion--)
> 
> Shouldn't p be incremented after this check? Otherwise, it will 
> still be pointing to ')' after breaking from this for-loop and we will
> end up copying "hmac(sha1" instead of "hmac(sha1)", right?
> Also, I think we will prematurely break from top for-loop 
> because of check, "if (*p == ')') break;" which is done further down...
> 
> +					break;
> +			}
> +
> +			notnum = 1;
> +		}
>  
>  		len = p - name;
> +		if (!len)
> +			goto err_free_param;
> +
> +		if (notnum) {
> +			param->attrs[i].alg.attr.rta_len =
> +				sizeof(param->attrs[i].alg);
> +			param->attrs[i].alg.attr.rta_type = CRYPTOA_ALG;
> +			memcpy(param->attrs[i].alg.data.name, name, len);
> +		} else {
> +			param->attrs[i].nu32.attr.rta_len =
> +				sizeof(param->attrs[i].nu32);
> +			param->attrs[i].nu32.attr.rta_type = CRYPTOA_U32;
> +			param->attrs[i].nu32.data.num =
> +				simple_strtol(name, NULL, 0);
> +		}
> +
> +		param->tb[i + 1] = &param->attrs[i].attr;
> +		i++;
> +
> +		if (WARN_ON(i >= CRYPTO_MAX_ATTRS))
> +			goto err_free_param;
> +
> +		if (*p == ')')
> +			break;
> +
> +		if (*p != ',')
> +			goto err_free_param;
>  	}
> 
> 
> Regards,
> Joy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
