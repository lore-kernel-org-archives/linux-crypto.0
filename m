From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Sun, 26 Feb 2017 20:14:21 +0100
Message-ID: <e8f61e87-51b4-ffeb-1425-f4a1bc79e664@linux.vnet.ibm.com>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
 <20170224234400.GA2758@gallifrey>
 <20170225151707.GA28667@gondor.apana.org.au>
 <20170225192022.GA18004@gallifrey>
 <20170226042235.GA29266@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37629 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751232AbdBZTOa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Feb 2017 14:14:30 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1QJDwjO134251
        for <linux-crypto@vger.kernel.org>; Sun, 26 Feb 2017 14:14:29 -0500
Received: from e06smtp09.uk.ibm.com (e06smtp09.uk.ibm.com [195.75.94.105])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28u6408rcq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sun, 26 Feb 2017 14:14:28 -0500
Received: from localhost
        by e06smtp09.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Sun, 26 Feb 2017 19:14:26 -0000
In-Reply-To: <20170226042235.GA29266@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/26/2017 05:22 AM, Herbert Xu wrote:
> On Sat, Feb 25, 2017 at 04:20:22PM -0300, Marcelo Cerri wrote:
>> Yeah, I agree. This should work as long as the module aliases are
>> correct, which is enough.
>>
>> Other templates will not trigger the same error since they don't have to
>> try more than one underlying algorithm. But I think this is still
>> desirable for the remaining templates to avoid a long chain of unused
>> fallbacks as in the example I gave in my previous email.
>>
>> Probably a helper function to return the correct mask might be useful
>> for readability and to avoid duplicate code.
> You're right.  Here is a patch to add a helper for this.
> Thanks!
>
> ---8<---
> Subject: crypto: api - Add crypto_requires_off helper
>
> This patch adds crypto_requires_off which is an extension of
> crypto_requires_sync for similar bits such as NEED_FALLBACK.
>
> Suggested-by: Marcelo Cerri <marcelo.cerri@canonical.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index ebe4ded..436c4c2 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -360,13 +360,18 @@ static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
>  	return crypto_attr_alg(tb[1], type, mask);
>  }
>
> +static inline int crypto_requires_off(u32 type, u32 mask, u32 off)
> +{
> +	return (type ^ off) & mask & off;
> +}
> +
>  /*
>   * Returns CRYPTO_ALG_ASYNC if type/mask requires the use of sync algorithms.
>   * Otherwise returns zero.
>   */
>  static inline int crypto_requires_sync(u32 type, u32 mask)
>  {
> -	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;
> +	return crypto_requires_off(type, mask, CRYPTO_ALG_ASYNC);
>  }
>
>  noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
applied the xts.c create patch v2 and the helper patch, built and installed.
Now the aes_s390 module loads perfect without any hang, no complains
in syslog and /proc/crypto shows that all selftests for the algs in the module
passed successful.

Thanks all for your help :-)

regards, Harald Freudenberger
