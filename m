From: Gary R Hook <ghook@amd.com>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Mon, 23 May 2016 08:27:38 -0500
Message-ID: <5743054A.3010009@amd.com>
References: <20160520041901.GA2645@gondor.apana.org.au>
 <573F324E.7000100@amd.com> <20160520233132.GA18006@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Denis B <begun.denis@gmail.com>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0074.outbound.protection.outlook.com ([157.56.110.74]:55472
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbcEWPBD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 11:01:03 -0400
In-Reply-To: <20160520233132.GA18006@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/20/2016 06:31 PM, Herbert Xu wrote:
> On Fri, May 20, 2016 at 10:50:38AM -0500, Gary R Hook wrote:
>>
>> Why is (or should) setting geniv (be) required?
>>
>> crypto_givcipher_default() appears to call crypto_default_geniv() if
>> the geniv member
>> is NULL. That function returns "eseqiv" or "chainiv" (under certain
>> conditions). If an
>> implementation isn't generating its own IVs, shouldn't the default
>> happen anyway? Or is
>> this more a matter of populating the structure with known,
>> intentional values?
>>
>> Thank you for any illumination provided.
>
> In the upstream kernel AEAD geniv has been completely phased out
> and no longer exists.  Denis is working on an old kernel that still
> has it.
>
> We haven't yet phased it out for skcipher but I'm working on it.

...and there was light.

Thank you; very helpful.

(I'll work harder on my line wraps... If someone knows how to get 
Thunderbird
to do it for me, I'd love to know.)
