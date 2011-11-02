From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hardware acceleration indication in af_alg
Date: Thu, 3 Nov 2011 09:51:27 +1100
Message-ID: <20111102225127.GA10130@gondor.apana.org.au>
References: <20111101125940.GA5072@totoro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nmav@gnutls.org, linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41773 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1KBWvi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Nov 2011 18:51:38 -0400
Content-Disposition: inline
In-Reply-To: <20111101125940.GA5072@totoro>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jamie Iles <jamie@jamieiles.com> wrote:
>
>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>> index de9adec..3e14cee 100644
>> --- a/include/linux/crypto.h
>> +++ b/include/linux/crypto.h
>> @@ -51,6 +51,11 @@
>>  #define CRYPTO_ALG_DYING             0x00000040
>>  #define CRYPTO_ALG_ASYNC             0x00000080
>>  
>> +/* Set this bit if the algorithm provided is hardware accelerated but
>> + * not available to userspace via instruction set or so.
>> + */
>> +#define CRYPTO_ALG_KERN_ONLY            0x00000100
> 
> Would it be a bit clearer if this was CRYPTO_ALG_IS_UNPRIVILIGED and was 
> set the other way round (so instruction set based ones that users can 
> use)?  I had to do a double take with KERN_ONLY.

Actually I think Nikos's suggestion is the right one.  Going the
other way would be more intrusive.  Of course I'm open to a better
name than KERN_ONLY.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
