From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Hardware acceleration indication in af_alg
Date: Wed, 02 Nov 2011 03:11:06 +0100
Message-ID: <4EB0A6BA.6090301@gnutls.org>
References: <4EAFE96E.9080601@gnutls.org> <20111101125940.GA5072@totoro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59474 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1KBCJj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Nov 2011 22:09:39 -0400
Received: by wyh15 with SMTP id 15so1017345wyh.19
        for <linux-crypto@vger.kernel.org>; Tue, 01 Nov 2011 19:09:38 -0700 (PDT)
In-Reply-To: <20111101125940.GA5072@totoro>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/01/2011 01:59 PM, Jamie Iles wrote:
> Hi Nikos,
> 
> On Tue, Nov 01, 2011 at 01:43:26PM +0100, Nikos Mavrogiannopoulos wrote:
[...]
>> I suppose that no answer means there is no way. In that case would you
>> consider this or a similar patch to indicate whether a driver provides
>> an algorithm not available to userspace via other means (e.g.
>> instruction set)? This would allow users of the kernel interfaces to
>> avoid using software implementations or implementations that are
>> available to userspace anyway.
> [...]
>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>> index de9adec..3e14cee 100644
>> --- a/include/linux/crypto.h
>> +++ b/include/linux/crypto.h
>> @@ -51,6 +51,11 @@
>>  #define CRYPTO_ALG_DYING		0x00000040
>>  #define CRYPTO_ALG_ASYNC		0x00000080
>>  
>> +/* Set this bit if the algorithm provided is hardware accelerated but
>> + * not available to userspace via instruction set or so.
>> + */
>> +#define CRYPTO_ALG_KERN_ONLY            0x00000100
> Would it be a bit clearer if this was CRYPTO_ALG_IS_UNPRIVILIGED and was 
> set the other way round (so instruction set based ones that users can 
> use)?  I had to do a double take with KERN_ONLY.

Could also be, although I think both names are not so intuitive :) Note
btw that the flag value in the patch is not correct (it overlaps with
another one).

regards,
Nikos
